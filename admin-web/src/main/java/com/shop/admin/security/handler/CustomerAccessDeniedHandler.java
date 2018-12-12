package com.shop.admin.security.handler;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


public class CustomerAccessDeniedHandler implements AccessDeniedHandler {


	public void handle(HttpServletRequest request, HttpServletResponse response,
			AccessDeniedException ex) throws IOException, ServletException {
		
		boolean isAjax = isAjaxRequest(request);
		if(!isAjax){
			request.setAttribute("isAjaxRequest", isAjax);
			request.setAttribute("message", ex.getMessage());
			/*RequestDispatcher dispatcher = request.getRequestDispatcher("/accessDeny.jsp");
			dispatcher.forward(request, response);*/
			response.sendRedirect(request.getContextPath()+"/accessDeny.jsp");
		}else{
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/plain");
			response.getWriter().write("权限不足");
			response.getWriter().close();
		}
	}

    private boolean isAjaxRequest(HttpServletRequest request) {
        String header = request.getHeader("X-Requested-With");
        if (header != null && "XMLHttpRequest".equals(header))
            return true;
        else
            return false;
    }
}