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


  <title>绑定谷歌登陆验证 </title>
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
   <c:choose>
     <c:when test="${bind}">
       <h3>您已经完成绑定，可以使用;我们将定期清理，重新绑定.</h3>
       <h3><a href="index">返回首页</a></h3>
     </c:when>
     <c:otherwise>
       <div>
         <div>
           <!--<img src="theme/img/logo.jpg" style="width: 30%;"/>-->
           <h1 class="logo-name"></h1>
         </div>
         <h3>请尽快完成谷歌绑定</h3>
         第一步扫描二维码;
         <div class="form-group">
           <label>验证码名称</label>
           <input type="text" class="form-control" name="name" id="name" placeholder="密码" value="${codeName}" readonly>
         </div>
         <div id="qrcode">
         </div>
         <div class="form-group">
           <label>验证码密钥</label>
           <input type="text" class="form-control" name="name" id="security" placeholder="密码" value="${security}" readonly>
         </div>
         第二步绑定二维码;
         <form id="bindForm" action="sec/bindGoogle" method="post">
           <div class="form-group">
             <input type="password" class="form-control" name="password" id="password" placeholder="后台登陆密码" required="">
           </div>
           <div class="form-group">
             <input type="text" class="form-control " name="googleCode" id="googleCode"  placeholder="谷歌验证码">
           </div>
           <span style="color: red" id="error-info">${error}</span>
           <button type="button" class="btn btn-primary block full-width m-b" style="background-color: #337ab7;border-color: #2e6da4;"  onclick="bind();">绑定谷歌验证码</button>
             <%--
                   <p class="text-muted text-center"> <a href="login.html#"><small>忘记密码了？</small></a> | <a href="register.html">注册一个新账号</a>
                   </p>
             --%>
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

    $('#qrcode').qrcode('${URL}');

    function bind(){
        var password = document.getElementById("password").value;
        if(password == null || password == ''){
            alert('请输入密码');
            return;
        }

        var googleCode = document.getElementById("googleCode").value;
        if(googleCode == null || googleCode == ''){
            alert('请输入谷歌验证码');
            return;
        }

        $.ajax({
            url: 'sec/bindGoogle',
            dataType : "json",
            type : "POST",
            data:{
                password:password,
                googleCode:googleCode
            },
            success: function (data) {
                if (data.result) {
                    location.href="sec/toBindGoogle";
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
