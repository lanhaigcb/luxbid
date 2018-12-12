<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<!-- Mirrored from www.suhai.com/theme/hplus/login.html by HTTrack Website Copier/3.x [XR&CO'2014], Wed, 20 Jan 2016 14:18:23 GMT -->
<head>

  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">


  <title>登录</title>
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
  <div>
    <div>
      <!--<img src="theme/img/logo.jpg" style="width: 30%;"/>-->
      <h1 class="logo-name"></h1>

    </div>
    <h3>欢迎使用系统</h3>

    <form id="loginForm" action="login" method="post">
      <div class="form-group">
        <input type="text" class="form-control" name="username" id="username" placeholder="用户名" required="">
      </div>
      <div class="form-group">
        <input type="password" class="form-control" name="password" id="password" placeholder="密码" required="">
      </div>
      <div class="form-group">
          <input type="text" class="form-control " name="validatecode" id="validatecode"  placeholder="图片验证码">
        <div class="col-sm-4 col-sm-offset-9">
          <img src="image.jsp" id="randImage" border="0"  name="randImage" alt="图片验证码" style="cursor:pointer;height: 80%;
    margin-top:5%;width: 100%;" onclick="loadimage();"/>
        </div>
        </div>

      <div class="form-group">
        <input type="text" class="form-control " name="smsCode" id="smsCode"  placeholder="短信验证码">
        <div class="col-sm-4 col-sm-offset-9">
          <button  id="sms" onclick="sendSms();" type="button" >发送短信验证码</button>>
        </div>
      </div>

      <button type="submit" class="btn btn-primary block full-width m-b" style="background-color: #337ab7;border-color: #2e6da4;"  onclick="login();">登 录</button>

<%--
      <p class="text-muted text-center"> <a href="login.html#"><small>忘记密码了？</small></a> | <a href="register.html">注册一个新账号</a>
      </p>
--%>
    </form>
  </div>
</div>
<script src="theme/js/jquery.min.js?v=2.1.4"></script>
<script src="theme/js/bootstrap.min.js?v=3.3.6"></script>
<script type="text/javascript">
  function login(){
    var username = document.getElementById("username").value;
    if(username == null || username == ''){
      alert('请输入用户名称');
      return;
    }
    var password = document.getElementById('password').value;
    if(password == null || password == ''){
      alert('请输入用户密码');
      return;
    }

    document.getElementById("loginForm").submit();
  }
  function loadimage(){
    document.getElementById("randImage").src = "./image.jsp?"+Math.random();
  }

  function sendSms(){
      var username = document.getElementById("username").value;
      if(username == null || username == ''){
          alert('请输入用户名称');
          return;
      }

      $.ajax({
          url: 'sms/loginSend?loginName=' + username,
          success: function (data) {
              if (data.result) {
                alert("发送成功");
              }
          },
          error: function () {
              alert("非法操作");
          }
      })
  }
</script>
</body>


<!-- Mirrored from www.suhai.com/theme/hplus/login.html by HTTrack Website Copier/3.x [XR&CO'2014], Wed, 20 Jan 2016 14:18:23 GMT -->
</html>
