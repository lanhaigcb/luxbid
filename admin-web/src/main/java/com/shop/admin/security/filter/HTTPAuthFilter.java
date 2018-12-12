package com.shop.admin.security.filter;

import com.mine.util.password.MD5Util;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.codec.Base64;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


public class HTTPAuthFilter implements Filter {

	private String author;

	private String ticket;

	private String realmName;

	/*
	 * (non-Javadoc)
	 * 
	 * @see javax.qrcode.Filter#destroy()
	 */
	public void destroy() {
		// nothing
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see javax.qrcode.Filter#doFilter(javax.qrcode.ServletRequest,
	 * javax.qrcode.ServletResponse, javax.qrcode.FilterChain)
	 */
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
		final HttpServletRequest request = (HttpServletRequest) req;
		final HttpServletResponse response = (HttpServletResponse) res;
		
		if(!request.getRequestURI().contains("rest") && !request.getRequestURI().contains("download") ){
			
			String header = request.getHeader("Authorization");
			if (header == null || !header.startsWith("Basic ")) {
				failed(response);
				return;
			}
			String[] tokens = extractAndDecodeHeader(header, request);
			assert tokens.length == 2;
			String username = tokens[0];
			String pwd = tokens[1];
			// MD5
			if (!author.equals(username) || !ticket.equals(MD5Util.digest(pwd))) {
				failed(response);
				return;
			}
		}
		// 权限验证
		// String path = request.getContextPath();
		// path =
		// Conf.LOGIN_URI.substring(Conf.LOGIN_URI.indexOf(path)+path.length());
		/*
		 * if(!StringUtils.isEmpty(path)){ try { Set<AgencyRole> roles =
		 * SecurityAgencyRoleCacheService.getAgencyRoleSetByURI(path); if(null
		 * != roles && roles.size() != 0 ){
		 * 
		 * AuthUser staff = SecurityUtil.currentLogin();
		 * //System.out.println(staff.getId()+"\t"+staff.getRoles()); if(staff
		 * != null && staff.getRoles() != null){ for(AgencyRole role : roles){
		 * for(String roleName : staff.getRoles()){
		 * if(role.getName().equals(roleName)){ continue; } } } } } } catch
		 * (Exception e) { e.printStackTrace(); } }
		 */
		// continue
		chain.doFilter(req, res);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see javax.qrcode.Filter#init(javax.qrcode.FilterConfig)
	 */
	public void init(FilterConfig config) throws ServletException {
		author = config.getInitParameter("author");
		ticket = config.getInitParameter("ticket");
		realmName = config.getInitParameter("realmName");
	}

	private void failed(HttpServletResponse response) throws IOException {
		response.addHeader("WWW-Authenticate", "Basic realm=\"" + realmName + "\"");
		response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "unauthorized");
	}

	private String[] extractAndDecodeHeader(String header, HttpServletRequest request) throws IOException {

		byte[] base64Token = header.substring(6).getBytes("UTF-8");
		byte[] decoded;
		try {
			decoded = Base64.decode(base64Token);
		} catch (IllegalArgumentException e) {
			throw new BadCredentialsException("Failed to decode basic authentication token");
		}

		String token = new String(decoded, "UTF-8");

		int delim = token.indexOf(":");

		if (delim == -1) {
			throw new BadCredentialsException("Invalid basic authentication token");
		}
		return new String[] { token.substring(0, delim), token.substring(delim + 1) };
	}
}
