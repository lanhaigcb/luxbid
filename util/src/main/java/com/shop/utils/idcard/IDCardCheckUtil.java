package com.shop.utils.idcard;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.google.common.base.Strings;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * 校验用户的身份证信息，调用阿里的接口
 */
public class IDCardCheckUtil {

    private static final Logger logger = LoggerFactory.getLogger(IDCardCheckUtil.class);

    public static final String APPCODE = "efb2527b5e6c4b6aab033d83724b83d3";

    /**
     * HTTP的Post请求方式
     */
    public static boolean checkIdCard(String realName, String idCard) {

        try {
            String host = "https://idcardcert.market.alicloudapi.com";
            String path = "/idCardCert";
            String urlSend = host + path + "?name=" + realName + "&idCard=" + idCard;
            URL url = new URL(urlSend);
            HttpURLConnection httpURLConnection = (HttpURLConnection) url.openConnection();
            httpURLConnection.setRequestProperty("Authorization", "APPCODE " + APPCODE);//格式Authorization:APPCODE (中间是英文空格)
            int httpCode = httpURLConnection.getResponseCode();
            String json = read(httpURLConnection.getInputStream());
            if (httpCode == 200) {
                if (!Strings.isNullOrEmpty(json)) {
                    JSONObject jsonObject = JSON.parseObject(json);
                    String status = jsonObject.getString("status");
                    logger.info("id card api check :" + realName + " :" + idCard + " result:" + json);
                    if ("01".equals(status)) {
                        return true;
                    }
                }
            } else if (httpCode == 400) {
                logger.info("权限错误");
            } else if (httpCode == 403) {
                logger.info("身份认证次数用完");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    /*
        读取返回结果
     */
    private static String read(InputStream is) throws IOException {
        StringBuffer sb = new StringBuffer();
        BufferedReader br = new BufferedReader(new InputStreamReader(is));
        String line = null;
        while ((line = br.readLine()) != null) {
            line = new String(line.getBytes(), "utf-8");
            sb.append(line);
        }
        br.close();
        return sb.toString();
    }

    /**
     * 调用接口
     */
    public static void main(String[] args) {
        //请正确填写appcode,如果填写错误阿里云会返回错误
        //appcode查看地址 https://market.console.aliyun.com/imageconsole/
        //请求地址
        boolean result = IDCardCheckUtil.checkIdCard("朱建华", "360721199411131615");
        //输出结果
        System.out.println(result);
    }


}
