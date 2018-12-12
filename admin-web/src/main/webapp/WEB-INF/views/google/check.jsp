<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.shop.admin.security.common.SecurityConf" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String path = request.getContextPath();
  String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<base  href="<%=basePath%>">
<!DOCTYPE html>
<html>
<!-- Mirrored from www.suhai.com/theme/hplus/login.html by HTTrack Website Copier/3.x [XR&CO'2014], Wed, 20 Jan 2016 14:18:23 GMT -->
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>验证谷歌登陆验证 </title>
  <meta name="keywords" content="">
  <meta name="description" content="">

  <link rel="shortcut icon" href="favicon.ico"> <link href="theme/css/bootstrap.min14ed.css?v=3.3.6" rel="stylesheet">
  <link href="theme/css/font-awesome.min93e3.css?v=4.4.0" rel="stylesheet">

  <link href="theme/css/animate.min.css" rel="stylesheet">
  <link href="theme/css/style.min862f.css?v=4.1.0" rel="stylesheet">
  <!--[if lt IE 9]>
  <meta http-equiv="refresh" content="0;ie.html" />
  <![endif]-->
  <script>if(window.top !== window.self){ window.top.location = window.location;}</script>

</head>

<body class="gray-bg">

<div class="middle-box text-center loginscreen  animated fadeInDown">


  <h3>敏感操作需要验证码谷歌验证码</h3>

   <c:choose>
     <c:when test="${!bind}">
       <h3>您尚未绑定谷歌验证码，请先绑定。</h3>
       <h3><a href="sec/toBindGoogle">去绑定</a></h3>
     </c:when>
     <c:otherwise>
            <div>
              <label>1.输入手机上的谷歌验证码，点击验证即可;</label>
              <label>2.30分钟内无需再次验证;</label>
              <div style="display: block">
                <span style="color: red">3.验证错误3次将锁定账号;</span>
              </div>
              <form id="checkForm" action="sec/checkGoogle" method="post">
                <div class="form-group">
                  <input type="text" class="form-control " name="googleCode" id="googleCode"  placeholder="谷歌验证码">
                </div>
                <span style="color: red" id="error-info">${error}</span>
                <button type="button" class="btn btn-primary block full-width m-b" style="background-color: #337ab7;border-color: #2e6da4;"  onclick="check();">验证谷歌验证码</button>
                <h3><a href="index">返回首页</a></h3>
              </form>
            </div>

     </c:otherwise>


   </c:choose>
</div>
<script src="theme/js/jquery.min.js?v=2.1.4"></script>
<script src="theme/js/bootstrap.min.js?v=3.3.6"></script>
<script src="theme/js/jquery.qrcode.min.js"></script>
<script type="text/javascript">

    function check(){
        var googleCode = document.getElementById("googleCode").value;
        if(googleCode == null || googleCode == ''){
            alert('请输入谷歌验证码');
            return;
        }
        $.ajax({
            url: 'sec/checkGoogle',
            dataType : "json",
            type : "POST",
            data:{
                googleCode:googleCode
            },
            success: function (data) {
                if (data.result) {
                    location.href="index";
                }else{
                    $("#error-info").html(data.message);
                }
            },
            error: function () {
                $("#error-info").html("发生错误");
            }
        })
    }
</script>
</body>


<!-- Mirrored from www.suhai.com/theme/hplus/login.html by HTTrack Website Copier/3.x [XR&CO'2014], Wed, 20 Jan 2016 14:18:23 GMT -->
</html>
