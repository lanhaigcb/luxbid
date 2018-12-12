package com.shop.admin.controller.c2c;

import com.mine.bizservice.C2CExchangeOrderService;
import com.mine.common.plugin.i18n.MessageSource;
import com.mine.common.response.Response;
import com.mine.common.vo.CustomerC2COrderVo;
import com.mine.common.vo.CustomerVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.mine.userservice.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;
import java.util.Map;


/**
 * @author baixiaozheng
 * @desc ${DESCRIPTION}
 * @date 2018/5/25 下午3:44
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
@RequestMapping("/customerC2COrder")
public class CustomerC2COrderController extends BaseController {
    @Autowired
    private C2CExchangeOrderService c2cExchangeOrderService;
    @Autowired
    private UserService userService;
    @Autowired
    private MessageSource messageSource;

    @RequestMapping("/index")
    @OperatorLogger(operatorName = "进入CustomerC2COrder管理")
    public ModelAndView currencyManage() {
        ModelAndView mv = new ModelAndView("customerc2corder/index");
        return mv;
    }

    @RequestMapping("/list")
    @OperatorLogger(operatorName = "获取所有CustomerC2COrder")
    @ResponseBody
    public Response list(Integer id, String mobile,String email,Boolean enable,Boolean hasC2CTrade,Integer limit, Integer offset) {
        total = c2cExchangeOrderService.countCustomer(id,mobile,email,enable,hasC2CTrade);
        if(total>0){
            List<CustomerC2COrderVo> list = c2cExchangeOrderService.listCustomer(id,mobile,email,enable,hasC2CTrade,limit,offset);
            return Response.listSuccess(total,list,"success");
        }
        return Response.simpleSuccess();
    }

    /**
     * 用户启用禁用
     * @param
     * @param enable
     * @return
     */
    @ResponseBody
    @RequestMapping("customer/updateStatus")
    @OperatorLogger(operatorName = "修改用户启用/禁用状态")
    public Map<String, Object> updateStatus(Integer customerId, Boolean enable) {
        CustomerVo customerVo = userService.getCustomerById(customerId);
        Boolean baseEnable = customerVo.getEnable();
        if(baseEnable == enable){
            String msg = enable == true ? "启用" : "禁用";
            result = false;
            message = messageSource.getMessage("该用户已经" + msg);
            return getResultMap();
        }
        try {
            userService.updateUserStatus(customerVo.getId(), enable);
            result = true;
            message = messageSource.getMessage("修改成功");
        } catch (Exception e) {
            e.printStackTrace();
            result = false;
            message = messageSource.getMessage("修改失败");
        }

        return getResultMap();
    }

}
