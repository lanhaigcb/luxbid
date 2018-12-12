
package com.shop.utils.password;

import javax.xml.bind.DatatypeConverter;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * MD5算法
 * 
 *
 */
public class MD5Util {
    private static final String ALGORITHM = "MD5";
    
    public static String digest(String in) {
        try {
            return DatatypeConverter.printHexBinary(digest(in.getBytes("UTF-8"))).toLowerCase();
        } catch (UnsupportedEncodingException e) {
            // can't be here
            throw new RuntimeException(e);
        }
    }
    
    private static byte[] digest(byte[] in) {
        try { 
            MessageDigest messageDigest = MessageDigest.getInstance(ALGORITHM);
            messageDigest.reset();
            return messageDigest.digest(in);
        } catch (NoSuchAlgorithmException e) {
            // can't be here
            throw new RuntimeException(e);
        }
    }
    
    public static void main(String[] args){
    	System.out.println(digest("amount=100&extra=CZ083110543112566329&order=17083110543112612260000745113462&time=1504148085549&key=6ca4a4156eb52f861a671d252d49a8e4"));
    }
}
