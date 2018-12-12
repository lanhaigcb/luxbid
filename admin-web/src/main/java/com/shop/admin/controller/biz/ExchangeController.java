package com.shop.admin.controller.biz;

import com.alibaba.fastjson.JSONObject;
import com.mine.bizservice.CurrencyService;
import com.mine.bizservice.ExchangeService;
import com.mine.common.currencyVo.CurrencyVo;
import com.mine.common.enums.PartitionType;
import com.mine.common.exception.biz.ExchangeException;
import com.mine.common.plugin.i18n.MessageSource;
import com.mine.common.response.Response;
import com.mine.common.vo.ExchangeVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.util.SecurityUtil;
import com.shop.admin.service.staff.StaffOperationLogService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

/**
 * 交易对
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
@RequestMapping("/exchange")
public class ExchangeController extends BaseController {

    private static Logger logger = LoggerFactory.getLogger(ExchangeController.class);

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private ExchangeService exchangeService;

    @Autowired
    private CurrencyService currencyService;

    @Autowired
    private StaffOperationLogService staffOperationLogService;

    /**
     * 进入Exchange管理
     */
    @RequestMapping("/index")
    @OperatorLogger(operatorName = "进入Exchange管理")
    public ModelAndView exchangeManage() {
        ModelAndView mv = new ModelAndView("exchange/index");
        List<CurrencyVo> currencyVos = currencyService.listAllEnable();
        mv.addObject("currencys", currencyVos);
        mv.addObject("currencyArray", JSONObject.toJSONString(currencyVos));
        return mv;
    }

    /**
     * 根据币种对交易对进行搜索
     * 分页
     */
    @RequestMapping("/findListAll")
    @OperatorLogger(operatorName = "根据币种对交易对进行搜索")
    @ResponseBody
    public Response listAllBack(Integer baseCurrencyId, Integer quoteCurrencyId, @RequestParam(value = "offset", defaultValue = "0") int offset,
                                @RequestParam(value = "limit", defaultValue = "10") int limit) {
        total = (int) exchangeService.getAppointCount(baseCurrencyId, quoteCurrencyId);
        if (total > 0) {
            list = exchangeService.listAllBackByCurrency(baseCurrencyId, quoteCurrencyId, getOffset(offset), getLimit(limit));
        }
        result = true;
        return Response.listSuccess(total, list, "查询成功");
    }

    /**
     * 进入添加Exchange页面
     */
    @RequestMapping("/addInput")
    @OperatorLogger(operatorName = "进入添加Exchange页面")
    public ModelAndView addExchangeIndex() {
        ModelAndView mv = new ModelAndView("exchange/add");
        List<CurrencyVo> currencyVos = currencyService.listAllEnable();
        mv.addObject("types", PartitionType.values());
        mv.addObject("currencys", currencyVos);
        return mv;
    }


    /**
     * 添加Exchange
     */
    @RequestMapping("/add")
    @OperatorLogger(operatorName = "添加Exchange")
    @ResponseBody
    public Map<String, Object> addExchange(HttpServletRequest request, ExchangeVo exchangeVo) {
        try {
            exchangeService.addExchange(exchangeVo);
            //记录用户操作日志
            Staff staff = SecurityUtil.currentLogin();
            staffOperationLogService.addStaffOperationLog("新增币种交易对", staff.getRealname() + "-新增币种交易对：" + exchangeVo.getSymbol(), staff.getId(), staff.getRealname());
            result = true;
            message = messageSource.getMessage("exchange.add.success");
            return getResultMap();
        } catch (ExchangeException exchangeException) {
            exchangeException.printStackTrace();
            result = false;
            message = exchangeException.getLocalizedMessage();
            logger.error("exchange 处理错误", exchangeException);
            return getResultMap();
        } catch (Exception e) {
            e.printStackTrace();
            result = false;
            message = messageSource.getMessage("exchange.add.failed");
            logger.error("添加exchange未知错误", e);
            return getResultMap();
        }
    }

    /**
     * 进入修改Exchange页面
     */
    @RequestMapping("/updateInput")
    @OperatorLogger(operatorName = "进入修改Exchange页面")
    public ModelAndView modifyExchange(Integer id) {
        ModelAndView mv = new ModelAndView("exchange/edit");
        ExchangeVo exchangeVo = exchangeService.getExchangeInfoById(id);
        List<CurrencyVo> currencyVos = currencyService.listAllEnable();
        mv.addObject("types", PartitionType.values());
        mv.addObject("currencys", currencyVos);
        mv.addObject("exchange", exchangeVo);
        return mv;
    }

    /**
     * 更新Exchange信息
     */
    @RequestMapping("/update")
    @OperatorLogger(operatorName = "修改Exchange")
    @ResponseBody
    public Map<String, Object> modifyExchange(HttpServletRequest request, ExchangeVo exchangeVo) {
        try {
            exchangeService.updateExchange(exchangeVo);
            //记录用户操作日志
            Staff staff = SecurityUtil.currentLogin();
            staffOperationLogService.addStaffOperationLog("修改币种交易对", staff.getRealname() + "-修改币种交易对：" + exchangeVo.getSymbol(), staff.getId(), staff.getRealname());
            result = true;
            message = messageSource.getMessage("exchange.update.success");
            return getResultMap();
        } catch (ExchangeException exchangeException) {
            result = false;
            message = exchangeException.getLocalizedMessage();
            logger.error("exchange 处理错误", exchangeException);
            return getResultMap();
        } catch (Exception e) {
            e.printStackTrace();
            result = false;
            message = messageSource.getMessage("exchange.update.failed");
            logger.error("添加exchange未知错误", e);
            return getResultMap();
        }
    }

}
