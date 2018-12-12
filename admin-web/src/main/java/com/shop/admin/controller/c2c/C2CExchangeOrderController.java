package com.shop.admin.controller.c2c;

import com.mine.bizservice.C2CCurrencyService;
import com.mine.bizservice.C2CExchangeOrderService;
import com.mine.common.project.Project;
import com.mine.common.response.Response;
import com.mine.common.vo.C2CCurrencyVo;
import com.mine.common.vo.C2CExchangeOrderVo;
import com.mine.common.vo.CustomerVo;
import com.mine.common.vo.admin.AdminC2COrderVo;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.util.SecurityUtil;
import com.shop.admin.service.staff.StaffService;
import com.mine.userservice.UserService;
import com.mine.util.check.CheckUtil;
import com.mine.util.string.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @author baixiaozheng
 * @desc ${DESCRIPTION}
 * @date 2018/5/25 下午5:53
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
@RequestMapping("/c2cOrder")
public class C2CExchangeOrderController extends BaseController {
    @Autowired
    private C2CExchangeOrderService c2cExchangeOrderService;
    @Autowired
    private UserService userService;
    @Autowired
    private StaffService staffService;
    @Autowired
    private C2CCurrencyService c2cCurrencyService;

    @RequestMapping("index")
    public ModelAndView index() {
        ModelAndView mv = new ModelAndView("c2cOrder/index");
        List<C2CCurrencyVo> vos = c2cCurrencyService.list();
        mv.addObject("currencys",vos);
        return mv;
    }

    @ResponseBody
    @RequestMapping("list")
    public Object list(Integer customerId, String account, Integer startMinute,
                       Integer endMinute, String orderNumber, String type,
                       String status, String operator, Date operatorTime, String symbol,
                       Integer offset, Integer limit) {

        if (!StringUtils.isEmpty(account)) {

            boolean isEmail = CheckUtil.checkEmail(account);
            CustomerVo customerVo = null;
            if (isEmail) {
                customerVo = userService.getCustomerByEmail(account);
            } else {
                customerVo = userService.getCustomerByMobile(account);
            }


            if (customerVo == null) {
                return Response.simpleSuccess();
            }
            if (customerId != null && (customerId.intValue() != customerVo.getId().intValue())) {
                return Response.simpleSuccess();
            }
            customerId = customerVo.getId();
        }
        Date endTime = null;
        Date startTime = null;
        if (startMinute != null && startMinute.intValue() > 0) {
            long start = startMinute * 60 * 1000;
            endTime = new Date(System.currentTimeMillis() - start);
        }
        if (endMinute != null && endMinute.intValue() > 0) {
            long end = endMinute * 60 * 1000;
            startTime = new Date(System.currentTimeMillis() - end);
        }

        Integer operatorId = null;
        if (!StringUtils.isEmpty(operator)) {
            Staff staff = staffService.getByName(operator);
            if (staff != null) {
                operatorId = staff.getId();
            }
        }

        total = c2cExchangeOrderService.countAdmin(customerId, startTime, endTime, orderNumber, type, status, operatorId, operatorTime,symbol);
        if (total > 0) {
            List<AdminC2COrderVo> list = c2cExchangeOrderService.listAdmin(customerId, startTime, endTime, orderNumber, type, status, operatorId, operatorTime,symbol, getOffset(offset), getLimit(limit));
            for (AdminC2COrderVo vo : list) {
                CustomerVo customerVo = userService.getCustomerById(vo.getCustomerId());
                vo.setAccount(customerVo.getMobile() != null ? customerVo.getMobile() : customerVo.getEmail());
                vo.setRealName(customerVo.getRealName());
                long start = System.currentTimeMillis();
                if(!"交易中".equals(vo.getStatus())&&!"待审核卖单".equals(vo.getStatus())&&!"待打款卖单".equals(vo.getStatus())&&!"已转账".equals(vo.getStatus())){
                    start = vo.getOperatorTime().getTime();
                }
                long minute = (start - vo.getCreateTime().getTime()) / 1000 / 60;
                vo.setMinute((int) minute);

                if(vo.getOperatorId()!=null){
                    Staff staff = staffService.getStaffById(vo.getOperatorId());
                    vo.setOperator(staff.getName());
                } else {
                    vo.setOperator("-");
                }
            }
            return Response.listSuccess(total, list, "查询成功");
        }
        result = true;
        return Response.simpleSuccess();
    }


    @RequestMapping("op")
    public String op(ModelMap modelMap, Integer id, String type) {
        modelMap.addAttribute("id",id);
        modelMap.addAttribute("type",type);

        if ("done".equals(type)){
            modelMap.addAttribute("suborder","确认订单");
        }else if ("cancel".equals(type)){
            modelMap.addAttribute("suborder","取消订单");
        }
        return "c2cOrder/code";
    }

    @ResponseBody
    @RequestMapping("cancel")
    public Map<String, Object> cancel(Integer id) {
        Staff currentLogin = SecurityUtil.currentLogin();
        return c2cExchangeOrderService.cancel(id, currentLogin.getId());

    }

    @ResponseBody
    @RequestMapping("done")
    public Map<String, Object> done(Integer id) {
        Staff currentLogin = SecurityUtil.currentLogin();
        Map<String, Object> result = c2cExchangeOrderService.done(id, currentLogin.getId());
        if("确认成功".equals(result.get("message"))){
            C2CExchangeOrderVo orderVo = c2cExchangeOrderService.get(id);
            userService.updateUserHasC2CTrade(orderVo.getCustomerId(), true);
        }
        return result;

    }

}
