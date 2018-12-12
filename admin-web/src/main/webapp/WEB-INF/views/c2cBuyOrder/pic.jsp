<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<%@include file="../common/head-title.jsp" %>
<head>
    <title>Title</title>
    <style type="text/css">
        *{
            margin:0;
            padding: 0;
            box-sizing: border-box;
        }
        html{
            width: 100%;
            height: 100%;
            font-size: 16px;
        }
        body{
            width: 100%;
            height: 100%;
            -moz-user-select: none; /*火狐*/ /*禁止用户在页面选择文字*/
            -webkit-user-select: none; /*webkit浏览器*/
            -ms-user-select: none; /*IE10*/
            -khtml-user-select: none; /*早期浏览器*/
            user-select: none;
        }
        .code{
            width: 400px;
            margin:0 auto;
        }
    </style>

</head>
<body>
<div class="code">
    <img src=${picUrl} onclick="window.open(this.src)" />
</div>



</body>
</html>
