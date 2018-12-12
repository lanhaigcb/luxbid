package com.shop.admin.controller.login;

import com.google.common.base.Strings;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.service.staff.StaffService;
import com.shop.admin.util.RedisUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.security.web.WebAttributes;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
public class LoginController extends BaseController {

    @Autowired
    private RedisUtil redisUtil;

    private static Integer couldTryTime = 3;

    @Autowired
    private StaffService staffService;


    @RequestMapping("auth/toLoginView")
    public ModelAndView toLogin(HttpSession httpSession, HttpServletRequest request,String type) {
        Exception exception = (Exception) httpSession.getAttribute(WebAttributes.AUTHENTICATION_EXCEPTION);

        if(!Strings.isNullOrEmpty(type)){
            httpSession.setAttribute("LoginType",type);
        }else{
            type = (String) httpSession.getAttribute("LoginType");
        }

        String errorMsg = "";
        if (null != exception) {

            errorMsg = exception.getMessage();
            if (errorMsg.startsWith("Bad credentials:")) {
                String userName = errorMsg.split(":")[1];
                String key = backTryLoginKey(userName);
                Integer tryTime = 0;
                if (redisUtil.exists(key)) {
                    tryTime = (Integer) redisUtil.get(key);
                }
                tryTime++;
                redisUtil.set(key, tryTime, 60 * 60 * 24);
                errorMsg = "用户名或密码错误，" + (3 - tryTime) + "次失败账号将被锁定";

                if (tryTime == 3) {
                    Staff staff = staffService.getByName(userName);
                    staffService.disableStaff(staff.getId());
                }
            }
        }

        String viewString ="login/login_sms";
        if("GOOGLE".equals(type)){
            viewString ="login/login_google";
        }
        ModelAndView modelAndView = new ModelAndView(viewString);
        modelAndView.addObject("error", errorMsg);
        return modelAndView;
    }

    public static String backTryLoginKey(String userName) {
        return "staff:pwd:try:" + userName;
    }
}
