package com.shop.admin.controller.activity;

import com.mine.bizservice.ActivityConfigService;
import com.mine.bizservice.ActivityService;
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
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * Created by zyy on 2018/5/21.
 * 活动方案
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
public class ActivitysController extends BaseController {

    private static Log logger = LogFactory.getLog(ActivitysController.class);

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ActivityConfigService activityConfigService;

    /**
     * 活动方案管理页面
     */
    @RequestMapping(value = "activity/index")
    @OperatorLogger(operatorName = "进入活动方案管理")
    public ModelAndView index() {
        ModelAndView mv = new ModelAndView("activity/activity_index");
        return mv;
    }

    /***
     * 活动列表
     *
     * @return
     */
    @RequestMapping(value = "activity/list")
    @OperatorLogger(operatorName = "查看活动列表")
    @ResponseBody
    public Map<String, Object> list(Integer offset, Integer limit) {
        total = activityService.getCount(null);
        if (total > 0) {
            List<com.mine.common.vo.activity.ActivityVo> listVo = activityService.getList(null, getOffset(offset), getLimit(limit));
            list = listVo;
        }
        result = true;
        return getResultMap();
    }

    /**
     * 进入添加页面
     */
    @RequestMapping(value = "activity/add")
    @OperatorLogger(operatorName = "进入添加页面")
    public ModelAndView add() {
        ModelAndView mv = new ModelAndView("activity/activity_edit");
        return mv;
    }

    /**
     * 保存
     *
     * @return
     */
    @RequestMapping(value = "activity/save")
    @OperatorLogger(operatorName = "添加活动")
    @ResponseBody
    public Map<String, Object> save(com.mine.common.vo.activity.ActivityVo vo) {
        try {
            if (null != vo.getId()) {
                activityService.update(vo);
            } else {
                activityService.add(vo);
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
    @RequestMapping(value = "activity/update")
    @OperatorLogger(operatorName = "进入修改活动页面")
    public ModelAndView updateInput(HttpServletRequest request, HttpServletResponse response, Integer id) {
        com.mine.common.vo.activity.ActivityVo vo = activityService.getById(id);
        ModelAndView mv = new ModelAndView("activity/activity_edit");
        mv.addObject("activityVo", vo);
        return mv;
    }


    @ResponseBody
    @RequestMapping("activity/editEnable")
    @OperatorLogger(operatorName = "修改启用/禁用状态")
    public Map<String, Object> editEnable(Integer id, Boolean enable) {
        result = false;
        try {
            com.mine.common.vo.activity.ActivityVo vo = activityService.getById(id);
            vo.setEnable(enable);
            //启用
            if (enable) {
                List<com.mine.common.vo.activity.ActivityVo> listVo = activityService.getList(vo, null, null);
                if (null != listVo && 0 < listVo.size()) {
                    message = "启用失败，仅可启动一个活动方案";
                    return getResultMap();
                } else {
                    ActivityConfigVo avo = new ActivityConfigVo();
                    avo.setActivityId(id);
                    List<ActivityConfigVo> listActivityConfigVo = activityConfigService.getList(avo, null, null);
                    BigDecimal val = new BigDecimal(0);
                    if (null != listActivityConfigVo && 0 < listActivityConfigVo.size()) {
                        for (ActivityConfigVo activityConfigVo : listActivityConfigVo) {
                            val = val.add(activityConfigVo.getProb());
                        }
                        if (val.compareTo(new BigDecimal(100)) != 0) {
                            message = "启用失败,方案配置概率总和不等于100";
                            return getResultMap();
                        }
                        if (listActivityConfigVo.size() % 2 != 0) {
                            message = "启用失败,方案配置总数不可为奇数";
                            return getResultMap();
                        }
                        vo.setListActivityConfigVo(listActivityConfigVo);
                        activityService.update(vo);
                        result = true;
                        return getResultMap();
                    } else {
                        message = "请先添加该活动的方案配置数据";
                        return getResultMap();
                    }
                }
            } else {
                activityService.update(vo);
                result = true;
                return getResultMap();
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "修改失败";
            return getResultMap();
        }
    }
}
