package com.shop.utils.ip;


import com.google.common.base.Strings;

import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 */
public class IPUtil {
  /**
   * 从Request对象中获得客户端IP，处理了HTTP代理服务器和Nginx的反向代理截取了ip
   * @param request
   * @return ip
   */
  public static String getLocalIp(HttpServletRequest request) {
    String remoteAddr = request.getRemoteAddr();
    String forwarded = request.getHeader("X-Forwarded-For");
    String realIp = request.getHeader("X-Real-IP");
    String ip = null;
    if (realIp == null) {
      if (forwarded == null) {
        ip = remoteAddr;
      } else {
        ip = remoteAddr + "/" + forwarded.split(",")[0];
      }
    } else {
      if (realIp.equals(forwarded)) {
        ip = realIp;
      } else {
        if(forwarded != null){
          forwarded = forwarded.split(",")[0];
        }
        ip = realIp + "/" + forwarded;
      }
    }
    return ip;
  }
  public static String getIp(HttpServletRequest request) {
    String remoteAddr = request.getRemoteAddr();
    String forwarded = request.getHeader("X-Forwarded-For");
    String realIp = request.getHeader("X-Real-IP");
    String ip = null;
    if (realIp == null) {
      if (forwarded == null) {
        ip = remoteAddr;
      } else {
        ip = remoteAddr + "/" + forwarded;
      }
    } else {
      if (realIp.equals(forwarded)) {
        ip = realIp;
      } else {
        ip = realIp + "/" + forwarded.replaceAll(", " + realIp, "");
      }
    }
    return ip;
  }
  public static String getIp2(HttpServletRequest request) {
    String ip = request.getHeader("X-Forwarded-For");
    if(Strings.isNullOrEmpty(ip) && !"unKnown".equalsIgnoreCase(ip)){
      //多次反向代理后会有多个ip值，第一个ip才是真实ip
      int index = ip.indexOf(",");
      if(index != -1){
        return ip.substring(0,index);
      }else{
        return ip;
      }
    }
    ip = request.getHeader("X-Real-IP");
    if(Strings.isNullOrEmpty(ip) && !"unKnown".equalsIgnoreCase(ip)){
      return ip;
    }
    return request.getRemoteAddr();
  }

  public static String getRemoteIPAddress(HttpServletRequest request) {
    String ip = request.getHeader("x-forwarded-for");
    if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
      ip = request.getHeader("Proxy-Client-IP");
    }
    if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
      ip = request.getHeader("WL-Proxy-Client-IP");
    }
    if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
      ip = request.getHeader("HTTP_CLIENT_IP");
    }
    if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
      ip = request.getHeader("HTTP_X_FORWARDED_FOR");
    }
    if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
      ip = request.getRemoteAddr();
    }
    if("0:0:0:0:0:0:0:1".equals(ip)){
      return "192.168.1.1";
    }
    return ip;
  }

  /**
   * 获取请求的user-agent
   * @param request
   * @return
   */
  public static String getRequestUA(HttpServletRequest request){
    return request.getHeader("user-agent");
  }

  /**
   *
   * @param content
   *            请求的参数 格式为：name=xxx&pwd=xxx
   *            服务器端请求编码。如GBK,UTF-8等
   * @return
   * @throws UnsupportedEncodingException
   */
  public static String getAddresses(String content){

    if(Strings.isNullOrEmpty(content)){
      return "{}";
    }else{
      String[] ips = content.split("/");
      content = ips[ips.length-1];
    }
    try {
      // 这里调用pconline的接口
      String urlStr = "http://ip.taobao.com/service/getIpInfo.php";
      // 从http://whois.pconline.com.cn取得IP所在的省市区信息
      String returnStr = getResult(urlStr, "ip="+content, "utf-8");
      if (returnStr != null) {
        // 处理返回的省市区信息
        System.out.println(returnStr);
        return returnStr;
        /*String[] temp = returnStr.split(",");
        if(temp.length<3){
          return "未知";//无效IP，局域网测试
        }
        String region = (temp[5].split(":"))[1].replaceAll("\"", "");
        region = decodeUnicode(region);// 省份
        return "".equals(region)?"未知":region;*/
      }
      return "{}";
    }catch (Exception e){
      return "{}";
    }
  }
  /**
   * @param urlStr
   *            请求的地址
   * @param content
   *            请求的参数 格式为：name=xxx&pwd=xxx
   * @param encoding
   *            服务器端请求编码。如GBK,UTF-8等
   * @return
   */
  private static String getResult(String urlStr, String content, String encoding) {
    URL url = null;
    HttpURLConnection connection = null;
    try {
      url = new URL(urlStr);
      connection = (HttpURLConnection) url.openConnection();// 新建连接实例
      connection.setConnectTimeout(1000);// 设置连接超时时间，单位毫秒
      connection.setReadTimeout(5000);// 设置读取数据超时时间，单位毫秒
      connection.setDoOutput(true);// 是否打开输出流 true|false
      connection.setDoInput(true);// 是否打开输入流true|false
      connection.setRequestMethod("POST");// 提交方法POST|GET
      connection.setUseCaches(false);// 是否缓存true|false
      connection.connect();// 打开连接端口
      DataOutputStream out = new DataOutputStream(connection
              .getOutputStream());// 打开输出流往对端服务器写数据
      out.writeBytes(content);// 写数据,也就是提交你的表单 name=xxx&pwd=xxx
      out.flush();// 刷新
      out.close();// 关闭输出流
      BufferedReader reader = new BufferedReader(new InputStreamReader(
              connection.getInputStream(), encoding));// 往对端写完数据对端服务器返回数据
      // ,以BufferedReader流来读取
      StringBuffer buffer = new StringBuffer();
      String line = "";
      while ((line = reader.readLine()) != null) {
        buffer.append(line);
      }
      reader.close();
      return buffer.toString();
    } catch (IOException e) {
      e.printStackTrace();
    } finally {
      if (connection != null) {
        connection.disconnect();// 关闭连接
      }
    }
    return null;
  }
  /**
   * unicode 转换成 中文
   *
   * @author fanhui 2007-3-15
   * @param theString
   * @return
   */
  public static String decodeUnicode(String theString) {
    char aChar;
    int len = theString.length();
    StringBuffer outBuffer = new StringBuffer(len);
    for (int x = 0; x < len;) {
      aChar = theString.charAt(x++);
      if (aChar == '\\') {
        aChar = theString.charAt(x++);
        if (aChar == 'u') {
          int value = 0;
          for (int i = 0; i < 4; i++) {
            aChar = theString.charAt(x++);
            switch (aChar) {
              case '0':
              case '1':
              case '2':
              case '3':
              case '4':
              case '5':
              case '6':
              case '7':
              case '8':
              case '9':
                value = (value << 4) + aChar - '0';
                break;
              case 'a':
              case 'b':
              case 'c':
              case 'd':
              case 'e':
              case 'f':
                value = (value << 4) + 10 + aChar - 'a';
                break;
              case 'A':
              case 'B':
              case 'C':
              case 'D':
              case 'E':
              case 'F':
                value = (value << 4) + 10 + aChar - 'A';
                break;
              default:
                throw new IllegalArgumentException(
                        "Malformed      encoding.");
            }
          }
          outBuffer.append((char) value);
        } else {
          if (aChar == 't') {
            aChar = '\t';
          } else if (aChar == 'r') {
            aChar = '\r';
          } else if (aChar == 'n') {
            aChar = '\n';
          } else if (aChar == 'f') {
            aChar = '\f';
          }
          outBuffer.append(aChar);
        }
      } else {
        outBuffer.append(aChar);
      }
    }
    return outBuffer.toString();
  }

  private static IPUtil uniqueInstance = null;

  private IPUtil() {
  }

  public static IPUtil getInstance() {
    if (uniqueInstance == null) {
      uniqueInstance = new IPUtil();
    }
    return uniqueInstance;
  }

  public static void main(String[] args) {
    System.out.println(getAddresses("123.113.148.132"));
//    System.out.println(getAddresses("222.73.199.8"));
  }
}
