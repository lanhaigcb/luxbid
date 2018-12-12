package com.shop.admin.security.filter;

import com.google.common.base.Strings;
import com.shop.admin.controller.smsController.SendSmsController;
import com.shop.admin.util.RedisUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CustomerUsernamePasswordAuthenticationFilter extends UsernamePasswordAuthenticationFilter {


    @Override
    protected String obtainUsername(HttpServletRequest request) {
        String userName = super.obtainUsername(request);
        String loginType = request.getParameter("type");
        String typeCode = request.getParameter("typeCode");
        return userName + "|" + loginType + "|" + typeCode;
    }

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request,
                                                HttpServletResponse response) throws AuthenticationException {

        String loginType = request.getParameter("type");

        //TODO 处理其他登录验证的问题，不过用户名和密码是调用在这个执行方法执行完成之后再执行的

        String userValicode = request.getParameter("validatecode");

        String sessionValicode = (String) request.getSession().getAttribute("registerImgCode");

        //System.out.println("登录验证，CustomerUsernamePasswordAuthenticationFilter ~~~~~~~~~" + userValicode +"  "+      sessionValicode);

        if (Strings.isNullOrEmpty(userValicode) || !userValicode.equals(sessionValicode)) {
            throw new UsernameNotFoundException("图片验证码错误");
        }
        return super.attemptAuthentication(request, response);
    }
}
