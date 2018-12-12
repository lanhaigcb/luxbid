package com.shop.admin.controller.support;

import com.mine.common.response.Response;
import com.mine.common.vo.CurrencyApplyVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.mine.supportservice.service.CurrencyApplyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 */
@RequestMapping("currencyApply")
@Controller
@Scope(BaseController.REQUEST_SCOPE)
public class CurrencyApplyController extends BaseController {
    @Autowired
    private CurrencyApplyService currencyApplyService;

    @OperatorLogger(operatorName = "进入帮助中心分类管理")
    @RequestMapping("index")
    public String index() {
        return "currencyApply/index";
    }

    @ResponseBody
    @RequestMapping("list")
    @OperatorLogger(operatorName = "获取所有币种借绍(后台)")
    public Object list(CurrencyApplyVo vo,
                       @RequestParam(value = "offset", defaultValue = "0") Integer from,
                       @RequestParam(value = "size", defaultValue = "10") Integer size) {
        int total = currencyApplyService.count(vo);
        if (total > 0) {
            list = currencyApplyService.list(vo, from, size);
        }
        result = true;
        return Response.listSuccess(total, list, "查询成功");
    }
}
