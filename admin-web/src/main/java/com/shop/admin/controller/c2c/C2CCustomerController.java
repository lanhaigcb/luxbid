package com.shop.admin.controller.c2c;

import com.mine.bizservice.C2CCurrencyService;
import com.mine.bizservice.C2CExchangeOrderService;
import com.mine.common.response.Response;
import com.mine.common.vo.*;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.mine.userservice.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @author baixiaozheng
 * @desc 用户管理（法币）
 * @date 2018/5/27 下午3:44
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
@RequestMapping("/c2cCustomer")
public class C2CCustomerController extends BaseController {


    @Autowired
    private C2CExchangeOrderService c2cExchangeOrderService;
    @Autowired
    private UserService userService;

    @Autowired
    private C2CCurrencyService c2cCurrencyService;


    @RequestMapping("index")
    public String index(ModelMap modelMap) {
        return "c2cCustomer/index";
    }

    @ResponseBody
    @RequestMapping("list")
    public Object list(Integer customerId, String mobile, String email,
                       Boolean enable, Boolean hasC2CTrade,
                       Integer offset, Integer limit) {


        total = c2cExchangeOrderService.countCustomer(customerId, mobile, email,enable,hasC2CTrade);
        if(total>0){
            List<CustomerC2COrderVo> list = c2cExchangeOrderService.listCustomer(customerId,mobile,email,enable,hasC2CTrade,getLimit(limit),getOffset(offset));
            return Response.listSuccess(total, list, "查询成功");
        }
        return Response.simpleSuccess();
    }
    @RequestMapping("/enable")
    @OperatorLogger(operatorName = "修改用户的启用禁用")
    @ResponseBody
    public Response enable(Integer id, Boolean enable){
        userService.updateUserStatus(id,enable);
        return Response.simpleSuccess();
    }

    @RequestMapping("/toDetail")
    public ModelAndView detail(Integer customerId) {
        ModelAndView mv = new ModelAndView("c2cCustomer/detail");
        mv.addObject("customerId",customerId);
        return mv;
    }

    @ResponseBody
    @RequestMapping("/statistic")
    public Response statistic(Integer customerId){
        List<C2CStatisticVo> vos = new ArrayList<>();
        List<C2CCurrencyVo> c2CCurrencyVos = c2cCurrencyService.list();
        for(C2CCurrencyVo currencyVo:c2CCurrencyVos){
            C2CStatisticVo vo = c2cExchangeOrderService.getC2CStatisticByCustomerId(customerId, currencyVo.getSymbol());
            vos.add(vo);
        }
        return Response.listSuccess(vos.size(), vos, "查询成功");
    }

}
