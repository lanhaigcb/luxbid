package com.shop.admin.controller.support;

import com.google.common.base.Function;
import com.google.common.collect.Lists;
import com.mine.bizservice.ExchangeService;
import com.mine.common.Affiche.AfficheException;
import com.mine.common.enums.SystemSettingType;
import com.mine.common.exception.admin.SystemSettingException;
import com.mine.common.exception.file.FileException;
import com.mine.common.plugin.i18n.MessageSource;
import com.mine.common.response.Response;
import com.mine.common.suportVo.BannerVo;
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
import java.util.List;
import java.util.Map;

/**
 * ExchangeViewController(pc行情配置)
 */

@Controller
@Scope(BaseController.REQUEST_SCOPE)
@RequestMapping("/exchangeView")
public class ExchangeViewController extends BaseController {

    private static Logger logger = LoggerFactory.getLogger(ExchangeViewController.class);

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private ExchangeViewService exchangeViewService;

    @Autowired
    private ExchangeService exchangeService;

    @Autowired
    private SystemSettingService systemSettingService;

    /**
     * 进入exchangeView配置
     */
    @RequestMapping("/index")
    @OperatorLogger(operatorName = "进入exchangeView管理")
    public ModelAndView exchangeViewManage(){
        ModelAndView mv = new ModelAndView("exchangeView/index");
        return mv;
    }

    /**
     * 获取所有exchangeView(后台)
     * @return
     */
    @RequestMapping("/findListAll")
    @OperatorLogger(operatorName = "获取所有exchangeView(后台)")
    @ResponseBody
    public Response listAll(String symbol,Integer offset, Integer limit){
        final SystemSetting systemSetting = systemSettingService.getByType(SystemSettingType.FILE_SERVER_URI);

        if (null == systemSetting) {
            throw new SystemSettingException(SystemSettingType.FILE_SERVER_URI + "没有配置");
        }
        total = (int)exchangeViewService.getCount(symbol);
        if(total > 0) {
            list = exchangeViewService.listAll(symbol, getOffset(offset), getLimit(limit));
        }
        result = true;
        return Response.listSuccess(total, list, "查询成功");
    }

    /**
     * 进入添加ExchangeView页面
     */
    @RequestMapping("/addInput")
    @OperatorLogger(operatorName = "进入添加exchangeView页面")
    public ModelAndView addExchangeView(){
        List<FrontExVo> frontExVos = exchangeService.listIndexExchanges();
        ModelAndView mv = new ModelAndView("exchangeView/add");
        mv.addObject("exchanges", frontExVos);
        return mv;
    }


    /**
     * 添加exchangeView
     * @return
     */
    @RequestMapping("/add")
    @OperatorLogger(operatorName = "添加exchangeView")
    @ResponseBody
    public Map<String, Object> addExchangeView(HttpServletRequest request, ExchangeViewVo exchangeViewVo){
        logger.info("exchangeView:add");
        try {
            ExchangeVo exchangeVo = exchangeService.getExchangeInfoById(exchangeViewVo.getExchangeId());
            exchangeViewVo.setSymbol(exchangeVo.getSymbol());
            exchangeViewService.addExchangeView(exchangeViewVo);
            result = true;
            message = messageSource.getMessage("添加exchangeView成功");
            return getResultMap();
        } catch (Exception e) {
            result = false;
            message = messageSource.getMessage("添加exchangeView错误");
            logger.error("添加exchangeView未知错误", e);
            return getResultMap();
        }
    }

    /**
     * 删除奖励发放记录
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping("/delete")
    @OperatorLogger(operatorName = "删除excahngeView")
    public Map<String, Object> deleteExcahngeView(Integer id) {
        try {
            exchangeViewService.delete(id);
            result = true;
        } catch (Exception e) {
            logger.error("删除奖励发放记录未知错误", e);
            result = false;
        }
        message = result ? "删除成功" : "删除失败";
        return getResultMap();
    }

    /**
     * 根据ID启用/禁用
     */
    @RequestMapping("/updateStatus")
    @OperatorLogger(operatorName = "启用exchangeView")
    @ResponseBody
    public Map<String, Object> updateStatus(Integer id) {
        try {
            exchangeViewService.updateStatus(id);
            result = true;
        } catch (Exception e) {
            logger.error("启用禁用展示交易对未知错误", e);
            result = false;
        }
        message = result ? "操作成功" : "操作失败";
        return getResultMap();
    }

}
