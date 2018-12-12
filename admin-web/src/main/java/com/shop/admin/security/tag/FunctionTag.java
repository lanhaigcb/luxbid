package com.shop.admin.security.tag;

import com.google.common.base.Strings;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.model.staff.StaffRole;
import com.shop.admin.security.service.SecurityStaffRoleCacheService;
import com.shop.admin.security.util.SecurityUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.ConfigAttribute;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.BodyContent;
import javax.servlet.jsp.tagext.BodyTagSupport;
import java.io.IOException;
import java.util.Collection;
import java.util.Set;



/**
 * 控制标签体是否显示,主要是对做权限控制
 */
public class FunctionTag extends BodyTagSupport {

	/**
	 */
	private static final long serialVersionUID = -2333534462769758658L;

	private static Logger logger = LoggerFactory.getLogger(FunctionTag.class);
	/**
	 * url="back/user!list.action"<br/>
	 * 目前页面三个：标签需要用到<br/>
	 * 1.页面\<td\>所包含的超连接<br/>
	 * 2.如果\<td\>所有的超链接都为空，那么对于的\<th\>(操作)列也不要<br/>
	 */
	private String url = "";
	
	public void setUrl(String url) {
		this.url = url;
	}
	
	/**
	 * 判断是否有权限
	 * 
	 */
	private boolean show() {

		//return true;
		if(!Strings.isNullOrEmpty(url)){//判断U                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            RL是否为空
			try {
				Staff staff = SecurityUtil.currentLogin();//获取当前登录的用户
				if(null == staff){
					return false;
				}
				Set<StaffRole> roles = staff.getRoles();//获取用户的角色集合
				if(null == roles || roles.size() == 0 ){
					return false;
				}

				//获取可以访问该URL的角色集合
				Collection<ConfigAttribute> set = SecurityStaffRoleCacheService.getAgencyRoleSetByURI(url);//
				if(null == set ){
					return false;
				}
				if( set.size() == 0){
					return false;
				}
				for(ConfigAttribute configAttribute : set){
					for(StaffRole role : roles){
						if(role.getRoleEnName().equals(configAttribute.getAttribute())){
							return true;
						}
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("权限验证失败");
			}
		}
		return false;
	}
	
	/**
	 * 进行权限验证，如果有权限则在页面显示权限标签中的内容，如果没有则不显示
	 */
	public int doAfterBody() throws JspException {
		BodyContent bc = getBodyContent();//权限标签中的内容
		JspWriter out = getPreviousOut();//获取页面显示的输出流
		try {
			if(show()) {	// 判断是否显示标签体内容
				out.write(bc.getString());
			}
		} catch (IOException e) {
			e.printStackTrace();
			logger.error("权限认证结果返回失败");
		}
		return SKIP_BODY;
	}
}
