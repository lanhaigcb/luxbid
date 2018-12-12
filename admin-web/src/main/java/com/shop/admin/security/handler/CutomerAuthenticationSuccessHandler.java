/**
 * Copyright(c) 2010-2013 by zimadaic.
 * All Rights Reserved
 */
package com.shop.admin.security.handler;

import com.shop.admin.controller.smsController.SendSmsController;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.util.SecurityUtil;
import com.shop.admin.service.staff.StaffService;
import com.shop.admin.util.RedisUtil;
import com.mine.util.ip.IPUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;


/**
 * 登陆成功handler
 *
 * @author
 */
public class CutomerAuthenticationSuccessHandler extends
        SimpleUrlAuthenticationSuccessHandler {

    private static Logger logger = LoggerFactory.getLogger(CutomerAuthenticationSuccessHandler.class);

    @Autowired
    private StaffService staffService;

    @Autowired
    private RedisUtil redisUtil;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
                                        HttpServletResponse response, Authentication authentication)
            throws IOException, ServletException {

        Staff staff = SecurityUtil.currentLogin();

        String ip = IPUtil.getRemoteIPAddress(request);

        staffService.updateStaffLoginInfo(staff.getId(),ip);
        logger.debug("login success~~~");
        HttpSession session = request.getSession();
        session.setAttribute("staffName",staff.getRealname());
        session.setAttribute("roleName",staff.getRoleName());
        redisUtil.remove(SendSmsController.buildBackLoginKey(staff.getName()));
        super.onAuthenticationSuccess(request, response, authentication);
    }
}
