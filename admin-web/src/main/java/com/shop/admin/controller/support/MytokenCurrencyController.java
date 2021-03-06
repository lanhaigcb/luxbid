package com.shop.admin.controller.support;

import com.mine.bizservice.BizService;
import com.mine.bizservice.CurrencyService;
import com.mine.common.currencyVo.CurrencyVo;
import com.mine.common.enums.SystemSettingType;
import com.mine.common.mytoken.MyTokenCurrencyVo;
import com.mine.common.plugin.i18n.MessageSource;
import com.mine.common.response.Response;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.setting.SystemSetting;
import com.shop.admin.service.setting.SystemSettingService;
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
 */
@RequestMapping("mytokenCurrency")
@Controller
@Scope(BaseController.REQUEST_SCOPE)
public class MytokenCurrencyController extends BaseController {
    private static Logger logger = LoggerFactory.getLogger(MytokenCurrencyController.class);
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
        ModelAndView mv = new ModelAndView("mytokenCurrency/index");
        List<MyTokenCurrencyVo> myTokenCurrencyVos = bizService.listAllMyTokenCurrencys(getOffset(offset), getLimit(limit));
        mv.addObject("myTokenCurrencyVos", myTokenCurrencyVos);
        return mv;
    }

    /***
     * mytoken注册币种列表
     *
     * @return
     */
    @RequestMapping(value = "/listAll")
    @OperatorLogger(operatorName = "mytoken注册币种列表")
    @ResponseBody
    public Response list(Integer limit, Integer offset) {
        total = (int) bizService.getMyTokenCurrencyCount();
        List<MyTokenCurrencyVo> myTokenCurrencyVos = new ArrayList<MyTokenCurrencyVo>();
        if (total > 0) {
            myTokenCurrencyVos = bizService.listAllMyTokenCurrencys(getOffset(offset), getLimit(limit));
        }
        return Response.listSuccess(total, myTokenCurrencyVos, "成功");
    }

    /**
     * 新增mytoken币种
     *
     * @return
     */
    @RequestMapping(value = "/addInput")
    @OperatorLogger(operatorName = "进入新增mytoken币种页面")
    public ModelAndView addInput() {
        ModelAndView mv = new ModelAndView("mytokenCurrency/add");
        List<CurrencyVo> currencyVos = currencyService.listAllEnable();
        mv.addObject("currencys", currencyVos);
        return mv;
    }

    /**
     * 添加mytokenCurrency
     * @return
     */
    @RequestMapping("/add")
    @OperatorLogger(operatorName = "添加mytokenCurrency")
    @ResponseBody
    public Map<String, Object> addmytokenCurrency(HttpServletRequest request, MyTokenCurrencyVo myTokenCurrencyVo){
        logger.info("mytokenCurrency:add");
        try {
            SystemSetting systemSettisng = systemSettingService.getByType(SystemSettingType.MYTOKEN_TOKEN);
            bizService.addMyTokenCurrency(myTokenCurrencyVo, systemSettisng.getValue());
            result = true;
            message = messageSource.getMessage("添加mytokenCurrency成功");
            return getResultMap();
        } catch (Exception e) {
            result = false;
            message = messageSource.getMessage("添加mytokenCurrency错误");
            logger.error("添加mytokenCurrency未知错误", e);
            return getResultMap();
        }
    }
}
