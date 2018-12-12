package com.shop.admin.security.encoder;

import com.mine.util.password.MD5Util;
import org.springframework.security.authentication.encoding.PasswordEncoder;


public class MD5Encoder implements PasswordEncoder {

    public String encodePassword(String rawPass, Object salt) {
        return MD5Util.digest(rawPass);
    }

    public boolean isPasswordValid(String encPass, String rawPass, Object salt) {
        return encPass.equals(encodePassword(rawPass, salt));
    }
}
