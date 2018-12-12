package com.shop.admin.controller.activity;

import com.mine.bizservice.ActivityService;
import com.mine.bizservice.CurrencyService;
import com.mine.bizservice.LuckyDrawRecordService;
import com.mine.common.currencyVo.CurrencyVo;
import com.mine.common.vo.activity.ActivityVo;
import com.mine.common.vo.activity.LuckyDrawRecordVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2018/5/23.
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
public class LuckyDrawRecordController extends BaseController {

    private static Log logger = LogFactory.getLog(LuckyDrawRecordController.class);

    @Autowired
    private LuckyDrawRecordService luckyDrawRecordService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private CurrencyService currencyService;

    @RequestMapping(value = "luckyDrawRecord/index")
    @OperatorLogger(operatorName = "进入幸运转盘抽奖记录页面")
    public ModelAndView index() {
        ModelAndView mv = new ModelAndView("activity/luckyDrawRecord_index");
        List<CurrencyVo> listCurrencyVo = currencyService.listAllEnable();
        mv.addObject("listCurrencyVo",listCurrencyVo);
        List<com.mine.common.vo.activity.ActivityVo> listActivityVo = activityService.getList(null,null,null);
        mv.addObject("listActivityVo", listActivityVo);
        return mv;
    }

    @RequestMapping(value = "luckyDrawRecord/list")
    @OperatorLogger(operatorName = "抽奖记录列表")
    @ResponseBody
    public Map<String, Object> list(LuckyDrawRecordVo vo,Integer offset, Integer limit) {
        total = luckyDrawRecordService.getCount(null);
        if (total > 0) {
            List<LuckyDrawRecordVo> listVo = luckyDrawRecordService.getList(vo, getOffset(offset), getLimit(limit));
            list = listVo;
        }
        result = true;
        return getResultMap();
    }

    @RequestMapping(value = "luckyDrawRecord/getStatInfo")
    @OperatorLogger(operatorName = "统计列表")
    @ResponseBody
    public Object getStatInfo(LuckyDrawRecordVo vo) {
        if(null != vo && StringUtils.isNotEmpty(vo.getActivityName())){
            try {
                String str=new String(vo.getActivityName().getBytes("ISO-8859-1"),"UTF-8");
                vo.setActivityName(str);
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        }
        List<LuckyDrawRecordVo> listVo = luckyDrawRecordService.getStatInfo(vo);
        return listVo;
    }
}
