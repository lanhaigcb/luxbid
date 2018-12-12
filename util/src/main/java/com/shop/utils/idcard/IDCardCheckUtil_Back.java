package com.shop.utils.idcard;

import com.alibaba.fastjson.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * 校验用户的身份证信息，调用阿里的接口
 */
public class IDCardCheckUtil_Back {

    private static final Logger logger = LoggerFactory.getLogger(IDCardCheckUtil_Back.class);

    public static final String APPCODE = "efb2527b5e6c4b6aab033d83724b83d3";

    /**
     * HTTP的Post请求方式
     */
    public static boolean checkIdCard(String realName, String idCard) {
        String returnStr = null; // 返回结果定义
        URL url = null;
        HttpURLConnection httpURLConnection = null;
        String urlString = "http://1.api.apistore.cn/idcard3";
        String param = "cardNo=" + idCard + "&realName=" + realName;
        try {
            url = new URL(urlString);
            httpURLConnection = (HttpURLConnection) url.openConnection();
            httpURLConnection.setRequestProperty("Accept-Charset", "utf-8");
            httpURLConnection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            httpURLConnection.setRequestProperty("Authorization", "APPCODE " + APPCODE);
            httpURLConnection.setDoOutput(true);
            httpURLConnection.setDoInput(true);
            httpURLConnection.setRequestMethod("POST"); // post方式
            httpURLConnection.connect();
            //System.out.println("ResponseCode:" + httpURLConnection.getResponseCode());
            //POST方法时使用
            byte[] byteParam = param.getBytes("UTF-8");
            DataOutputStream out = new DataOutputStream(httpURLConnection.getOutputStream());
            out.write(byteParam);
            out.flush();
            out.close();
            BufferedReader reader = new BufferedReader(
                    new InputStreamReader(httpURLConnection.getInputStream(), "utf-8"));
            StringBuffer buffer = new StringBuffer();
            String line = "";
            while ((line = reader.readLine()) != null) {
                buffer.append(line);
            }

            reader.close();
            returnStr = buffer.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            if (httpURLConnection != null) {
                httpURLConnection.disconnect();
            }
        }

        JSONObject jsonObject = JSONObject.parseObject(returnStr);
        //System.out.println(jsonObject);
        int errorCode = jsonObject.getIntValue("error_code");
        logger.info("id card api check :" + realName + " :" + idCard + " result:" + returnStr);
        if (errorCode == 0) {
            return true;
        }
        return false;
    }

    /**
     * 调用接口
     */
    public static void main(String[] args) {
        //请正确填写appcode,如果填写错误阿里云会返回错误
        //appcode查看地址 https://market.console.aliyun.com/imageconsole/
        //请求地址
        boolean result = IDCardCheckUtil_Back.checkIdCard("朱建华1", "360721199411131615");

        //输出结果
        System.out.println(result);
    }


}
