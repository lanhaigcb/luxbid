package com.shop.utils.check;

import org.apache.commons.lang3.StringUtils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by choufengleilei on 2018\7\22
 */
public class XSSCheckUtil {
    /**
     * 检查注入
     * @param str
     */
    public static boolean validate(String str, String  regular) {
        Pattern pattern = Pattern.compile(regular, Pattern.CASE_INSENSITIVE);
        if (pattern.matcher(str).find()) {
            return false;
        }
        return true;
    }

    /**
     * 检查注入
     * @param strs
     */
    public static boolean validate(String[] strs, String regular) {
        Pattern pattern = Pattern.compile(regular, Pattern.CASE_INSENSITIVE);
        for (String str : strs) {
            if (pattern.matcher(str).find()) {
                return false;
            }
        }
        return true;
    }

    /**
     * 替换特殊符号
     * @param str
     */
    public static String replace(String str, String regular) {
        if(StringUtils.isNotEmpty(str) && StringUtils.isNotEmpty(regular)){
            Pattern pattern = Pattern.compile(regular, Pattern.CASE_INSENSITIVE);
            Matcher matcher   =   pattern.matcher(str);
            return   matcher.replaceAll("").trim();
        }
        return "";
    }

    /**
     * 替换特殊符号
     * @param strs
     */
    public static boolean replace(String[] strs, String regular) {
        Pattern pattern = Pattern.compile(regular, Pattern.CASE_INSENSITIVE);
        for (String str : strs) {
            Matcher matcher   =   pattern.matcher(str);
            matcher.replaceAll("").trim();
        }
        return true;
    }

}
