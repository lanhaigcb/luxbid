package com.shop.admin.controller.support;

import com.mine.bizservice.BizService;
import com.mine.bizservice.CurrencyService;
import com.mine.bizservice.ExchangeService;
import com.mine.common.currencyVo.CurrencyVo;
import com.mine.common.enums.SystemSettingType;
import com.mine.common.exception.admin.SystemSettingException;
import com.mine.common.mytoken.MyTokenExchangeVo;
import com.mine.common.plugin.i18n.MessageSource;
import com.mine.common.response.Response;
import com.mine.common.suportVo.ExchangeViewVo;
import com.mine.common.vo.ExchangeVo;
import com.mine.common.vo.front.FrontExVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.setting.SystemSetting;
import com.shop.admin.service.setting.SystemSettingService;
import com.mine.supportservice.service.ExchangeViewService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 *
 */

@Controller
@Scope(BaseController.REQUEST_SCOPE)
@RequestMapping("/mytokenExchange")
public class MytokenExchangeController extends BaseController {

    private static Logger logger = LoggerFactory.getLogger(MytokenExchangeController.class);

    @Autowired
    private MessageSource messageSource;
    @Autowired
    private BizService bizService;
    @Autowired
    private CurrencyService currencyService;
    @Autowired
    private SystemSettingService systemSettingService;
    /**
     * mytoken首页
     */
    @RequestMapping(value = "/index")
    @OperatorLogger(operatorName = "进入mytoken首页")
    public ModelAndView index(Integer limit, Integer offset) {
        ModelAndView mv = new ModelAndView("mytokenExchange/index");
        List<MyTokenExchangeVo> myTokenExchangeVos = bizService.listAllMyTokenExchanges(getOffset(offset), getLimit(limit));
        mv.addObject("myTokenExchangeVos", myTokenExchangeVos);
        return mv;
    }

    /***
     * mytoken交易对列表
     *
     * @return
     */
    @RequestMapping(value = "/listAll")
    @OperatorLogger(operatorName = "mytoken交易对列表")
    @ResponseBody
    public Response list(Integer limit, Integer offset) {
        total = (int) bizService.getMyTokenExchangeCount();
        List<MyTokenExchangeVo> myTokenExchangeVos = new ArrayList<MyTokenExchangeVo>();
        if (total > 0) {
            myTokenExchangeVos = bizService.listAllMyTokenExchanges(getOffset(offset), getLimit(limit));
        }
        return Response.listSuccess(total, myTokenExchangeVos, "成功");
    }

    /**
     * 新增mytoken交易对
     *
     * @return
     */
    @RequestMapping(value = "/addInput")
    @OperatorLogger(operatorName = "进入新增mytoken币种页面")
    public ModelAndView addInput() {
        ModelAndView mv = new ModelAndView("mytokenExchange/add");
        List<CurrencyVo> currencyVos = currencyService.listAllEnable();
        mv.addObject("currencys", currencyVos);
        return mv;
    }

    /**
     * 添加myTokenExchange
     * @return
     */
    @RequestMapping("/add")
    @OperatorLogger(operatorName = "添加myTokenExchange")
    @ResponseBody
    public Map<String, Object> add(HttpServletRequest request, MyTokenExchangeVo myTokenExchangeVo){
        logger.info("myTokenExchange:add");
        try {
            SystemSetting systemSettisng = systemSettingService.getByType(SystemSettingType.MYTOKEN_TOKEN);
            bizService.addMyTokenExchange(myTokenExchangeVo, systemSettisng.getValue());
            result = true;
            message = messageSource.getMessage("添加myTokenExchange成功");
            return getResultMap();
        } catch (Exception e) {
            result = false;
            message = messageSource.getMessage("添加myTokenExchange错误");
            logger.error("添加myTokenExchange未知错误", e);
            return getResultMap();
        }
    }



}
