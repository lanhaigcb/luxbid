package com.shop.admin.security.interceptor;

import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.common.SecurityConf;
import com.shop.admin.security.google.Authority;
import com.shop.admin.security.google.AuthorityType;
import com.shop.admin.security.util.SecurityUtil;
import com.shop.admin.util.RedisUtil;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 */
public class GoogleInterceptor extends HandlerInterceptorAdapter {

    private static final Log logger = LogFactory.getLog(GoogleInterceptor.class);

    @Autowired
    private RedisUtil redisUtil;


    @Resource(name = "messageSource")
    private AbstractMessageSource messageSource;

    /*
     * (non-Javadoc)
     *
     * @see
     * org.springframework.web.servlet.handler.HandlerInterceptorAdapter#preHandle
     * (javax.servlet.http.HttpServletRequest,
     * javax.servlet.http.HttpServletResponse, java.lang.Object)
     */
    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response, Object handler) throws Exception {
        HandlerMethod mHandler = (HandlerMethod) handler;
        Authority authority = mHandler.getMethodAnnotation(Authority.class);

        Staff staff = SecurityUtil.currentLogin();

        // not found annotation, allow every one
        if (null == authority) {
            return true;
        }
        // author type
        AuthorityType type = authority.type();
        if (AuthorityType.ANYMOUS.equals(type)) {
            return true;
        } else if (AuthorityType.GOOGLE.equals(type)) {



            if(!redisUtil.exists(buildStaffGoogleCheckKey(staff.getName()))){
                HttpServletResponse httpServletResponse = (HttpServletResponse) response;
                httpServletResponse.sendRedirect(request.getContextPath() + httpServletResponse.encodeRedirectURL("/sec/toCheckGoogle"));
                return false;
            }else{
                return true;
            }
        }
        return true;
    }

    public static String buildStaffGoogleCheckKey(String staffName) {
        return "back:google:check:" + staffName;
    }

}
