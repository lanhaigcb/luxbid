package com.shop.admin.security.filter;

import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.common.SecurityConf;
import com.shop.admin.security.util.SecurityUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.SecurityMetadataSource;
import org.springframework.security.access.intercept.AbstractSecurityInterceptor;
import org.springframework.security.access.intercept.InterceptorStatusToken;
import org.springframework.security.web.FilterInvocation;
import org.springframework.security.web.access.intercept.FilterInvocationSecurityMetadataSource;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 用户权限认证过滤器
 */
public class CustomerSecurityAuthencationFilter extends
        AbstractSecurityInterceptor implements Filter {

    private FilterInvocationSecurityMetadataSource securityMetadataSource;

    Logger logger = LoggerFactory.getLogger(CustomerSecurityAuthencationFilter.class);

    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletResponse httpServletResponse = (HttpServletResponse) response;
        HttpServletRequest httpServletRequest = (HttpServletRequest) request;

        Staff customer = SecurityUtil.currentLogin();

        logger.debug("check current login staff:"+customer);

        if (null == customer) {
            logger.debug("check current login staff is null,go to login view");
            httpServletResponse.sendRedirect(httpServletRequest.getContextPath() + httpServletResponse.encodeRedirectURL(SecurityConf.LOGIN_URL));
            return;
        } else {
            if (SecurityUtil.loginTimeout()) {//超时
                logger.debug("current login staff is timeout ,go to login view");
                httpServletResponse.sendRedirect(httpServletRequest.getContextPath() + httpServletResponse.encodeRedirectURL(SecurityConf.LOGIN_URL));
                return;
            }
        }
        FilterInvocation fi = new FilterInvocation(request, response, chain);
        invoke(fi);
    }

    public FilterInvocationSecurityMetadataSource getSecurityMetadataSource() {
        return this.securityMetadataSource;
    }

    public Class<? extends Object> getSecureObjectClass() {
        return FilterInvocation.class;
    }

    public void invoke(FilterInvocation fi) throws IOException,
            ServletException {
        InterceptorStatusToken token = super.beforeInvocation(fi);
        try {
            fi.getChain().doFilter(fi.getRequest(), fi.getResponse());
        } finally {
            super.afterInvocation(token, null);
        }
    }

    public SecurityMetadataSource obtainSecurityMetadataSource() {
        return this.securityMetadataSource;
    }

    public void setSecurityMetadataSource(
            FilterInvocationSecurityMetadataSource newSource) {
        this.securityMetadataSource = newSource;
    }

    public void destroy() {
    }

    public void init(FilterConfig arg0) throws ServletException {
    }
}
