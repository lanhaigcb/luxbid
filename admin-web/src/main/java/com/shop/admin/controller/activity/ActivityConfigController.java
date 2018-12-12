package com.shop.admin.controller.activity;

import com.mine.bizservice.ActivityConfigService;
import com.mine.bizservice.ActivityService;
import com.mine.bizservice.CurrencyService;
import com.mine.common.currencyVo.CurrencyVo;
import com.mine.common.exception.staff.StaffException;
import com.mine.common.vo.activity.ActivityConfigVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * Created by zyy on 2018/5/22.
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
public class ActivityConfigController extends BaseController {

    private static Log logger = LogFactory.getLog(ActivitysController.class);

    @Autowired
    private ActivityConfigService activityConfigService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private CurrencyService currencyService;

    /**
     * 初始化方案配置页面
     */
    @RequestMapping(value = "activityConfig/index")
    @OperatorLogger(operatorName = "初始化方案配置页面")
    public ModelAndView index() {
        List<com.mine.common.vo.activity.ActivityVo> listActivityVo = activityService.getList(null,null,null);
        ModelAndView mv = new ModelAndView("activity/activityConfig_index");
        mv.addObject("listActivityVo", listActivityVo);
        return mv;
    }

    /***
     * 方案配置列表
     *
     * @return
     */
    @RequestMapping(value = "activityConfig/list")
    @OperatorLogger(operatorName = "方案配置列表")
    @ResponseBody
    public Map<String, Object> list(ActivityConfigVo vo ,Integer offset, Integer limit) {
        total = activityConfigService.getCount(vo);
        if (total > 0) {
            List<ActivityConfigVo> listVo = activityConfigService.getList(vo, getOffset(offset), getLimit(limit));
            list = listVo;
        }
        result = true;
        return getResultMap();
    }

    /**
     * 进入添加方案配置页面
     */
    @RequestMapping(value = "activityConfig/add")
    @OperatorLogger(operatorName = "进入添加方案配置页面")
    public ModelAndView add(Integer activityId) {
        List<CurrencyVo> listCurrencyVo = currencyService.listAllEnable();
        ModelAndView mv = new ModelAndView("activity/activityConfig_edit");
        mv.addObject("listCurrencyVo",listCurrencyVo);
        mv.addObject("activityId",activityId);
        return mv;
    }

    /**
     * 保存
     *
     * @return
     */
    @RequestMapping(value = "activityConfig/save")
    @OperatorLogger(operatorName = "添加方案配置")
    @ResponseBody
    public Map<String, Object> save(ActivityConfigVo vo) {
        try {
            if (null != vo.getId()) {
                activityConfigService.update(vo);
            } else {
                activityConfigService.add(vo);
            }
            result = true;
        } catch (StaffException e) {
            result = false;
            message = e.getMessage();
        }
        return getResultMap();
    }

    /**
     * 前往修改页面
     *
     * @param request
     * @param response
     * @param
     * @return
     */
    @RequestMapping(value = "activityConfig/update")
    @OperatorLogger(operatorName = "进入修改页面")
    public ModelAndView updateInput(HttpServletRequest request, HttpServletResponse response, Integer id) {
        ActivityConfigVo vo = activityConfigService.getById(id);
        List<CurrencyVo> listCurrencyVo = currencyService.listAllEnable();
        ModelAndView mv = new ModelAndView("activity/activityConfig_edit");
        mv.addObject("activityConfigVo", vo);
        mv.addObject("listCurrencyVo",listCurrencyVo);
        return mv;
    }


    @ResponseBody
    @RequestMapping("activityConfig/editStatus")
    @OperatorLogger(operatorName = "删除")
    public Map<String, Object> editStatus(Integer id) {
        try {
            ActivityConfigVo vo = activityConfigService.getById(id);
            vo.setStatus(false);
            activityConfigService.update(vo);
            result = true;
        } catch (Exception e) {
            e.printStackTrace();
            result = false;
            message = e.getMessage();
        }
        return getResultMap();
    }
}
