package com.shop.admin.controller.biz;

import com.mine.bizservice.AdminService;
import com.mine.bizservice.CurrencyService;
import com.mine.common.currencyVo.CurrencyVo;
import com.mine.common.response.Response;
import com.mine.common.vo.admin.AdminQueryVo;
import com.shop.admin.controller.BaseController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * 用户收益日志
 * Created by Administrator on 2018/5/2.
 */
@RequestMapping("subAccountLog")
@Controller
@Scope(BeanDefinition.SCOPE_PROTOTYPE)
public class SubAccountLogController extends BaseController {

    private static Logger logger = LoggerFactory.getLogger(SubAccountLogController.class);

    @Autowired
    private AdminService adminService;

    @Autowired
    private CurrencyService currencyService;

    @RequestMapping("index")
    public String index(ModelMap modelMap) {
        List<CurrencyVo> voList = currencyService.listAllEnable();
        modelMap.addAttribute("voList", voList);
        return "subAccountLog/index";
    }

    @ResponseBody
    @RequestMapping("list")
    public Object list(@RequestParam(value = "offset", defaultValue = "1") int offset,
                       @RequestParam(value = "limit", defaultValue = "10") int limit,
                       AdminQueryVo queryVo) {

        total = adminService.countSubAccountLog(queryVo);
        if (total > 0) {
            list = adminService.listSubAccountLog(queryVo, offset, limit);
        }
        result = true;
        return Response.listSuccess(total, list, "查询成功");
    }
}
