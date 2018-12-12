package com.shop.admin.security.service;


import com.google.common.base.Strings;
import com.mine.common.exception.staff.StaffException;
import com.shop.admin.controller.smsController.SendSmsController;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.handler.CustomerAuthenticationFailureHandler;
import com.shop.admin.security.model.SystemUser;
import com.shop.admin.service.staff.StaffService;
import com.shop.admin.util.RedisUtil;
import com.mine.util.googleauth.GoogleAuthenticator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;


public class StaffUserDetailService implements UserDetailsService{

    private static Logger logger = LoggerFactory.getLogger(StaffUserDetailService.class);

    @Autowired
    private RedisUtil redisUtil;


	@Autowired
	private StaffService staffService;

    public UserDetails loadUserByUsername(String userName) throws UsernameNotFoundException {

        String loginType = null;

        String typeCode = null;

        if(userName.contains("|")){
            String[] info = userName.split("\\|");
            userName = info[0];
            loginType = info[1];
            typeCode = info[2];
        }

        if(null == userName || "".equals(userName)){
            throw new UsernameNotFoundException("用户名不能为空！");
        }

        if(null == typeCode){
            throw new UsernameNotFoundException("验证码不能为空！");
        }

        Staff staff = staffService.getByName(userName);

        if (staff == null) {
            throw new StaffException("用户名或密码错误！");
        }

        if(Strings.isNullOrEmpty(loginType)){
            throw new StaffException("登陆类型错误");
        }


        // 短信登陆
        if ("SMS".equals(loginType)) {
            String key = SendSmsController.buildBackLoginKey(userName);

            if (redisUtil.exists(key)) {
                String value = (String) redisUtil.get(key);
                if (!typeCode.equals(value)) {
                    throw new StaffException("短信验证码错误");
                }
            } else {
                throw new StaffException("短信验证码错误");
            }
        }

        // 谷歌登陆
        if("GOOGLE".equals(loginType)){

            if(!staff.getGoogleAuth()){
                throw new StaffException("谷歌验证码尚未绑定");
            }

            long t = System.currentTimeMillis();
            GoogleAuthenticator ga = new GoogleAuthenticator();
            ga.setWindowSize(5);
            boolean r = ga.check_code(staff.getGoogleSecurity(), Long.valueOf(typeCode), t);
            if(!r){
                throw new StaffException("谷歌验证码错误！");
            }
        }

        if(!staff.getEnable()){
            throw new StaffException("用户已经被禁用");
        }

        SystemUser systeUser = new SystemUser(staff);
        return systeUser;
    }

}
