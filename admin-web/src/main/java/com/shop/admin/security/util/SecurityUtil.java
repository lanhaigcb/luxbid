package com.shop.admin.security.util;

import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.common.SecurityConf;
import com.shop.admin.security.model.SystemUser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.Date;


/**
 * 当前登陆用户
 *
 */
public class SecurityUtil {

   static Logger logger = LoggerFactory.getLogger(SecurityUtil.class);

    /**
     * 获取登陆用户
     */
    public static Staff currentLogin() {
        try {
            SystemUser userDetails = (SystemUser) SecurityContextHolder.getContext().getAuthentication()
                    .getPrincipal();
            return userDetails.getStaff();
        } catch (Exception e) {
            return null;
        }
    }

    public static void setSecurityUser(Staff user) {
        try {
            SystemUser userDetails = (SystemUser) SecurityContextHolder.getContext().getAuthentication()
                    .getPrincipal();
            userDetails.setStaff(user);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static boolean loginTimeout(){
        Staff customer = currentLogin();
        if(null == customer){
            setSecurityUser(null);
            return true;
        } else { // 进行时间判断
            long currentTime = System.currentTimeMillis();
            SystemUser userDetails = getSystemUser();
            long lastTime = userDetails.getLastUpdateTime();
            logger.debug("current login staff last update time:"+new Date(lastTime));
            if(currentTime > lastTime+ SecurityConf.LOGIN_TIMEOUT_SECOND){
                setSecurityUser(null);
                return true;
            } else {
                return false;
            }
        }
    }

    private static SystemUser getSystemUser() {
        try {
            SystemUser userDetails = (SystemUser) SecurityContextHolder.getContext().getAuthentication()
                    .getPrincipal();
            return userDetails;
        } catch (Exception e) {
            return null;
        }
    }
}
