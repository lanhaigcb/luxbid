package com.shop.admin.controller.staff;

import com.google.common.base.Strings;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.interceptor.GoogleInterceptor;
import com.shop.admin.security.util.SecurityUtil;
import com.shop.admin.service.staff.StaffService;
import com.shop.admin.util.RedisUtil;
import com.mine.util.googleauth.GoogleAuthenticator;
import com.mine.util.password.MD5Util;
import org.apache.http.HttpResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
public class BindGoogleController extends BaseController {

    private static Logger logger = LoggerFactory.getLogger(BindGoogleController.class);

    @Autowired
    private StaffService staffService;

    @Autowired
    private RedisUtil redisUtil;

    @RequestMapping("sec/toCheckGoogle")
    public ModelAndView renderCheckView() {
        Staff staff = SecurityUtil.currentLogin();
        ModelAndView modelAndView = new ModelAndView("google/check");
        staff = staffService.getStaffById(staff.getId());
        if(staff.getGoogleAuth()){
            modelAndView.addObject("bind",true);
        }else{
            modelAndView.addObject("bind",false);
        }
        String key = GoogleInterceptor.buildStaffGoogleCheckKey(staff.getName());
        if(redisUtil.exists(key)){
            modelAndView.addObject("needCheck",false);
        }else{
            modelAndView.addObject("needCheck",true);
        }

        return modelAndView;
    }

    @RequestMapping("sec/toBindGoogle")
    public ModelAndView renderBindView() {
        Staff staff = SecurityUtil.currentLogin();
        ModelAndView modelAndView = new ModelAndView("google/bind");

         staff = staffService.getStaffById(staff.getId());
        if(staff.getGoogleAuth()){
            modelAndView.addObject("bind",true);
        }else{
            modelAndView.addObject("bind",false);

            if(Strings.isNullOrEmpty(staff.getGoogleSecurity())){
                String sect = GoogleAuthenticator.generateSecretKey();
                staff = staffService.updateGoogle(staff.getId(),sect);
            }

            String codeName = "STAFF_"+staff.getName();

            String url = GoogleAuthenticator.getQRBarcode(codeName,staff.getGoogleSecurity());
            modelAndView.addObject("URL",url);
            modelAndView.addObject("security",staff.getGoogleSecurity());
            modelAndView.addObject("codeName",codeName);

        }
        return modelAndView;
    }

    @RequestMapping("sec/bindGoogle")
    @ResponseBody
    public Map<String,Object> googleBind(String password,String googleCode) {
        try {
            Staff staff = SecurityUtil.currentLogin();
            staff = staffService.getStaffById(staff.getId());
            if(!staff.getPassword().equalsIgnoreCase(MD5Util.digest(password))){
                result = false;
                message = "密码不正确";
                return getResultMap();
            }
            long t = System.currentTimeMillis();
            GoogleAuthenticator googleAuthenticator = new GoogleAuthenticator();
            boolean check = googleAuthenticator.check_code(staff.getGoogleSecurity(),Long.valueOf(googleCode),t);

            if(!check){
                result = false;
                message = "谷歌验证码不正确";
                return getResultMap();
            }

            staff.setGoogleAuth(true);

            staffService.updateGoogleBind(staff.getId(),true);

            result = true;
            message = "成功";
            return getResultMap();
        }catch (Exception e){
            e.printStackTrace();
            result = false;
            message ="发生错误";
            return getResultMap();
        }
    }

    @RequestMapping("sec/checkGoogle")
    @ResponseBody
    public Map<String,Object> googleCheck(String googleCode, HttpServletRequest request, HttpServletResponse response) {
        try {
            Staff staff = SecurityUtil.currentLogin();
            staff = staffService.getStaffById(staff.getId());
            long t = System.currentTimeMillis();
            GoogleAuthenticator googleAuthenticator = new GoogleAuthenticator();
            boolean check = googleAuthenticator.check_code(staff.getGoogleSecurity(),Long.valueOf(googleCode),t);

            if(!check){
                String userName = staff.getName();
                String tryKey = buildGoogleCheckWrongTimeKey(userName);
                Integer tryTime = 0;
                if (redisUtil.exists(tryKey)) {
                    tryTime = (Integer) redisUtil.get(tryKey);
                }
                tryTime++;
                redisUtil.set(tryKey, tryTime, 60 * 60 * 24);
                message = "验证错误，" + (3 - tryTime) + "次失败账号将被锁定";

                if (tryTime > 3) {
                    redisUtil.remove(tryKey);
                    staffService.disableStaff(staff.getId());
                    response.sendRedirect(request.getContextPath() + response.encodeRedirectURL("/logout"));
                }
                result = false;
                return getResultMap();
            }

            String checkKey = GoogleInterceptor.buildStaffGoogleCheckKey(staff.getName());
            redisUtil.set(checkKey,"OK",60*30);
            result = true;
            message = "成功";
            return getResultMap();
        }catch (Exception e){
            e.printStackTrace();
            result = false;
            message ="发生错误";
            return getResultMap();
        }
    }


    public static String buildGoogleCheckWrongTimeKey(String userName){
        return "staff:google:try:" + userName;
    }

}
