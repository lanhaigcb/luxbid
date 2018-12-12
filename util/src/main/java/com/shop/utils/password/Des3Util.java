package com.shop.utils.password;

import com.sun.org.apache.xerces.internal.impl.dv.util.Base64;

import javax.crypto.Cipher;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESedeKeySpec;
import javax.crypto.spec.IvParameterSpec;
import java.security.Key;

/**
 * 数据加密工具类
 */
public class Des3Util {
    private final static String secretKey = "13776409064yzcmlga19920414" ;
    private final static String iv = "_cccbtc_";
    private final static String encoding = "utf-8";
    /**
     *
     * @param plainText
     * @return
     * @throws Exception
     */
    public static String encryptThreeDESECB(String plainText) {
        Key deskey = null;
        try {
            DESedeKeySpec spec = new DESedeKeySpec(secretKey .getBytes());
            SecretKeyFactory keyfactory = SecretKeyFactory.getInstance( "desede");
            deskey = keyfactory.generateSecret( spec);

            Cipher cipher = Cipher.getInstance( "desede/CBC/PKCS5Padding");
            IvParameterSpec ips = new IvParameterSpec( iv.getBytes());
            cipher.init(Cipher. ENCRYPT_MODE, deskey, ips);
            byte[] encryptData = cipher.doFinal( plainText.getBytes( encoding));

            return  Base64.encode(encryptData);
        } catch (Exception e) {
        }
        return null;
    }

    /**
     *
     * @param encryptText
     * @return
     * @throws Exception
     */
    public static String decryptThreeDESECB(String encryptText) {
        //许多传过来的参数原来是+号会变成空格，所以转换一下
        encryptText=encryptText.replace(" ", "+");
        Key deskey = null;
        byte[] decryptData = null;
        try{
            DESedeKeySpec spec = new DESedeKeySpec( secretKey.getBytes());
            SecretKeyFactory keyfactory = SecretKeyFactory.getInstance( "desede");
            deskey = keyfactory. generateSecret( spec);
            Cipher cipher = Cipher.getInstance( "desede/CBC/PKCS5Padding" );
            IvParameterSpec ips = new IvParameterSpec(iv.getBytes());
            cipher.init(Cipher. DECRYPT_MODE, deskey, ips);
            decryptData = cipher.doFinal(Base64.decode(encryptText));
            return new String(decryptData, encoding);
        }catch(Exception e){
            e.printStackTrace();
        }
        return null;
    }
}