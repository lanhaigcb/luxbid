package com.shop.admin.util;

import com.alibaba.fastjson.JSONObject;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

/**
 */
public class SendSmsUtil {

    private static final Log logger = LogFactory.getLog(SendSmsUtil.class);


    //发送验证码的请求路径URL
    private static final String SERVER_URL = "https://api.netease.im/sms/sendcode.action";
    //校验验证码的请求路径URL
    private static final String SERVER_VALIDATE_URL = "https://api.netease.im/sms/verifycode.action";
    //网易云信分配的账号，请替换你在管理后台应用下申请的Appkey
    private static final String APP_KEY = "b81a1485458d93078530cf4556750570";
    //网易云信分配的密钥，请替换你在管理后台应用下申请的appSecret
    private static final String APP_SECRET = "7aa91365fabf";
    //随机数
    private static final String NONCE = "0123456789";
    //短信模板ID
    private static final String TEMPLATEID = "4052578";
    //手机号
    //private static final String MOBILE="18824586767";
    //验证码长度，范围4～10，默认为4
    private static final String CODELEN = "6";


    public static void main(String[] args) throws Exception {
//        JSONObject object = JSONObject.parseObject(VoiceCode("18510718520", null));
        //System.out.println(object);
//        if (object.get("code").toString().equals("200")) {
            //System.out.println(object.get("code").toString());
            //System.out.println(object.get("obj").toString());
//        }
        sendNotify("18510718520","登陆验证码："+123456);
    }

    public static final ConcurrentMap<String, Object> baseMap = new ConcurrentHashMap<>();
    /*//产品名称:云通信短信API产品,开发者无需替换
    static final String product = "Dysmsapi";
    //产品域名,开发者无需替换
    static final String domain = "dysmsapi.aliyuncs.com";

    // 后台的标示
    static final String accessKeyId = "LTAI1qVlYo0dVsoY";
    static final String accessKeySecret = "KSj8vjeIggjgxf08xk45f2j101nIN5";

    public static SendSmsResponse sendSms(String smsTemplate, String phoneNumber,String code){
        SendSmsResponse sendSmsResponse = null;
        try {
            //可自助调整超时时间
            System.setProperty("sun.net.client.defaultConnectTimeout", "10000");
            System.setProperty("sun.net.client.defaultReadTimeout", "10000");

            //初始化acsClient,暂不支持region化
            IClientProfile profile = DefaultProfile.getProfile("cn-hangzhou", accessKeyId, accessKeySecret);
            DefaultProfile.addEndpoint("cn-hangzhou", "cn-hangzhou", product, domain);
            IAcsClient acsClient = new DefaultAcsClient(profile);
            //组装请求对象
            SendSmsRequest request = new SendSmsRequest();
            //待发送手机号
            request.setPhoneNumbers(phoneNumber);
            //短信签名-可在短信控制台中找到//TODO
            request.setSignName("云通信");
            //短信模板-可在短信控制台中找到
            request.setTemplateCode(smsTemplate);
            //可选:模板中的变量替换JSON串,如模板内容为"亲爱的${name},您的验证码为${code}"时,此处的值为
            request.setTemplateParam("{\"code\":\"" + code + "\"}");

            //选填-上行短信扩展码(无特殊需求用户请忽略此字段)
            //request.setSmsUpExtendCode("90997");
            //可选:outId为提供给业务方扩展字段,最终在短信回执消息中将此值带回给调用者
            request.setOutId("yourOutId");
            //hint 此处可能会抛出异常，注意catch
            sendSmsResponse = acsClient.getAcsResponse(request);
            }catch (ClientException e){
                e.printStackTrace();
            }catch (Exception e){
                e.printStackTrace();
            }
            return sendSmsResponse;
    }


    public static QuerySendDetailsResponse querySendDetails(String phoneNumber, String bizId) throws ClientException {

        //可自助调整超时时间
        System.setProperty("sun.net.client.defaultConnectTimeout", "10000");
        System.setProperty("sun.net.client.defaultReadTimeout", "10000");

        //初始化acsClient,暂不支持region化
        IClientProfile profile = DefaultProfile.getProfile("cn-hangzhou", accessKeyId, accessKeySecret);
        DefaultProfile.addEndpoint("cn-hangzhou", "cn-hangzhou", product, domain);
        IAcsClient acsClient = new DefaultAcsClient(profile);

        //组装请求对象
        QuerySendDetailsRequest request = new QuerySendDetailsRequest();
        //必填-号码
        request.setPhoneNumber(phoneNumber);
        //可选-流水号
        request.setBizId(bizId);
        //必填-发送日期 支持30天内记录查询，格式yyyyMMdd
        SimpleDateFormat ft = new SimpleDateFormat("yyyyMMdd");
        request.setSendDate(ft.format(new Date()));
        //必填-页大小
        request.setPageSize(10L);
        //必填-当前页码从1开始计数
        request.setCurrentPage(1L);

        //hint 此处可能会抛出异常，注意catch
        QuerySendDetailsResponse querySendDetailsResponse = acsClient.getAcsResponse(request);

        return querySendDetailsResponse;
    }

    public static void main(String[] args) throws ClientException, InterruptedException {

        //发短信
        SendSmsResponse response = sendSms("", "", "");
        System.out.println("短信接口返回的数据----------------");
        System.out.println("Code=" + response.getCode());
        System.out.println("Message=" + response.getMessage());
        System.out.println("RequestId=" + response.getRequestId());
        System.out.println("BizId=" + response.getBizId());

        Thread.sleep(3000L);

        //查明细
        if(response.getCode() != null && response.getCode().equals("OK")) {
            QuerySendDetailsResponse querySendDetailsResponse = querySendDetails("", response.getBizId());
            System.out.println("短信明细查询接口返回数据----------------");
            System.out.println("Code=" + querySendDetailsResponse.getCode());
            System.out.println("Message=" + querySendDetailsResponse.getMessage());
            int i = 0;
            for(QuerySendDetailsResponse.SmsSendDetailDTO smsSendDetailDTO : querySendDetailsResponse.getSmsSendDetailDTOs())
            {
                System.out.println("SmsSendDetailDTO["+i+"]:");
                System.out.println("Content=" + smsSendDetailDTO.getContent());
                System.out.println("ErrCode=" + smsSendDetailDTO.getErrCode());
                System.out.println("OutId=" + smsSendDetailDTO.getOutId());
                System.out.println("PhoneNum=" + smsSendDetailDTO.getPhoneNum());
                System.out.println("ReceiveDate=" + smsSendDetailDTO.getReceiveDate());
                System.out.println("SendDate=" + smsSendDetailDTO.getSendDate());
                System.out.println("SendStatus=" + smsSendDetailDTO.getSendStatus());
                System.out.println("Template=" + smsSendDetailDTO.getTemplateCode());
            }
            System.out.println("TotalCount=" + querySendDetailsResponse.getTotalCount());
            System.out.println("RequestId=" + querySendDetailsResponse.getRequestId());
        }

    }*/

    /*public static void main(String[] args) {

        String testUsername = "DAEX"; //在短信宝注册的用户名
        String testPassword = "daex2018@"; //在短信宝注册的密码
        String testPhone = "18824586767";
        String testContent = "【币虎】您的验证码是,若非本人操作请忽略此消息。"; // 注意测试时，也请带上公司简称或网站签名，发送正规内容短信。千万不要发送无意义的内容：例如 测一下、您好。否则可能会收不到

        String httpUrl = "http://api.smsbao.com/sms";

        StringBuffer httpArg = new StringBuffer();
        httpArg.append("u=").append(testUsername).append("&");
        httpArg.append("p=").append(md5(testPassword)).append("&");
        httpArg.append("m=").append(testPhone).append("&");
        httpArg.append("c=").append(encodeUrlString(testContent, "UTF-8"));

        String result = request(httpUrl, httpArg.toString());
        System.out.println(result);
    }*/

    public static String sendSms(String phone, String code, String type) {
        String result = "0";
        String username = "DAEX"; //在短信宝注册的用户名
        String password = "daex2018@"; //在短信宝注册的密码
        String httpUrl = "http://api.smsbao.com/sms";

        String content = getSmsTemplate(type, code);
        //System.out.println("content1:" + content);
        String s = encodeUrlString(content, "UTF-8");
        //System.out.println("content2:" + s);
        StringBuffer httpArg = new StringBuffer();
        httpArg.append("u=").append(username).append("&");
        httpArg.append("p=").append(md5(password)).append("&");
        httpArg.append("m=").append(phone).append("&");
        httpArg.append("c=").append(s);
        Object phoneObj = baseMap.get(phone);
        if (null != phoneObj) {
            long oldTime = Long.parseLong(String.valueOf(phoneObj));
            Date date = new Date();
            long time = date.getTime();
            if (time - oldTime <= 30000) {
                result = "11";
                //System.out.println("上次发送时间：" + new SimpleDateFormat("yyyy-MM-dd hh:mm:ss").format(oldTime));
                //System.out.println("发送验证码时间间隔为2分钟,手机号为：" + phone);
            } else {
                result = request(httpUrl, httpArg.toString());

                baseMap.put(phone, time);
            }
        } else {
            result = request(httpUrl, httpArg.toString());
            Date date = new Date();
            long time = date.getTime();
            baseMap.put(phone, time);
        }
        return result;
    }

    public static String sendNotify(String phone, String content) {
        String result = "0";
        String username = "DAEX"; //在短信宝注册的用户名
        String password = "daex2018@"; //在短信宝注册的密码
        String httpUrl = "http://api.smsbao.com/sms";

        //System.out.println("content1:" + content);
        String s = encodeUrlString("【币虎全球】" + content, "UTF-8");
        //System.out.println("content2:" + s);
        StringBuffer httpArg = new StringBuffer();
        httpArg.append("u=").append(username).append("&");
        httpArg.append("p=").append(md5(password)).append("&");
        httpArg.append("m=").append(phone).append("&");

        httpArg.append("c=").append(s);
        result = request(httpUrl, httpArg.toString());
        return result;
    }

    public static String request(String httpUrl, String httpArg) {
        BufferedReader reader = null;
        String result = null;
        StringBuffer sbf = new StringBuffer();
        httpUrl = httpUrl + "?" + httpArg;

        try {
            URL url = new URL(httpUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.connect();
            InputStream is = connection.getInputStream();
            reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
            String strRead = reader.readLine();
            if (strRead != null) {
                sbf.append(strRead);
                while ((strRead = reader.readLine()) != null) {
                    sbf.append("\n");
                    sbf.append(strRead);
                }
            }
            reader.close();
            result = sbf.toString();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public static String md5(String plainText) {
        StringBuffer buf = null;
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(plainText.getBytes());
            byte b[] = md.digest();
            int i;
            buf = new StringBuffer("");
            for (int offset = 0; offset < b.length; offset++) {
                i = b[offset];
                if (i < 0)
                    i += 256;
                if (i < 16)
                    buf.append("0");
                buf.append(Integer.toHexString(i));
            }
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return buf.toString();
    }

    public static String encodeUrlString(String str, String charset) {
        String strret = null;
        if (str == null)
            return str;
        try {
            strret = java.net.URLEncoder.encode(str, charset);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        return strret;
    }

    public static String getSmsTemplate(String type, String code) {
        String str = "";
        if ("1".equals(type)) {
            str = "【币虎全球】您的注册验证码是" + code + "，请不要把验证码泄漏给其他人，如非本人请勿操作。";
        } else if ("2".equals(type)) {
            str = "【币虎全球】您正在重置登录密码，验证码" + code + "，请不要把验证码泄漏给其他人，如非本人请勿操作。";
        } else if ("3".equals(type)) {
            str = "【币虎全球】您正在设置交易密码，验证码" + code + "，请不要把验证码泄漏给其他人，如非本人请勿操作。";
        } else if ("4".equals(type)) {
            str = "【币虎全球】您正在绑定谷歌验证器，验证码" + code + "，请不要把验证码泄漏给其他人，如非本人请勿操作。";
        } else {
            str = "【币虎全球】您的验证码是" + code + "若非本人操作请忽略此消息。";
        }
        return str;
    }

}
