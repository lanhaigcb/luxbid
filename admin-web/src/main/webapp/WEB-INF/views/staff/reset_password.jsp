<%@ page contentType="text/html;charset=UTF-8" language="java" %><!DOCTYPE html>
<%@ taglib tagdir="/WEB-INF/tags" prefix="b" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <b:base></b:base>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>H+ 后台主题UI框架 - 表单验证 jQuery Validation</title>
    <meta name="keywords" content="H+后台主题,后台bootstrap框架,会员中心主题,后台HTML,响应式后台">
    <meta name="description" content="H+是一个完全响应式，基于Bootstrap3最新版本开发的扁平化主题，她采用了主流的左右两栏式布局，使用了Html5+CSS3等现代技术">

    <link rel="shortcut icon" href="favicon.ico"> <link href="theme/css/bootstrap.min14ed.css?v=3.3.6" rel="stylesheet">
    <link href="theme/css/font-awesome.min93e3.css?v=4.4.0" rel="stylesheet">
    <link href="theme/css/animate.min.css" rel="stylesheet">
    <link href="theme/css/style.min862f.css?v=4.1.0" rel="stylesheet">
    <link href="theme/css/plugins/bootstrap-table/bootstrap-table.min.css" rel="stylesheet">
    <link href="theme/js/plugins/layer/skin/layer.css" rel="stylesheet">
</head>

<body class="">
<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox float-e-margins">

                <div class="ibox-content">
                    <form class="form-horizontal m-t" id="updateStaffForm" method="post" action = "staff/password/reset">
                        <div class="form-group">
                            <input id="id" name="id"  class="form-control" type="hidden" value="${staff.id}">
                            <label class="col-sm-3 control-label">用户名：</label>
                            <div class="col-sm-8">
                                <input id="name" name="name" class="form-control" type="text" value="${staff.name}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">真实姓名：</label>
                                <div class="col-sm-8">
                                <input id="realname" name="realname" class="form-control" type="text" value="${staff.realname}">
                                <span class="help-block m-b-none"><i class="fa fa-info-circle"></i> 请输入您的真实姓名</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">密码：</label>
                            <div class="col-sm-8">
                                <input id="password" name="password" class="form-control" type="password">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">确认密码：</label>
                            <div class="col-sm-8">
                                <input id="confirm_password" name="confirm_password" class="form-control" type="password">
                                <span class="help-block m-b-none"><i class="fa fa-info-circle"></i> 请再次输入您的密码</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-8 col-sm-offset-3">
                                <button class="btn btn-primary" type="submit">提交</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="theme/js/jquery.min.js?v=2.1.4"></script>
<script src="theme/js/bootstrap.min.js?v=3.3.6"></script>
<script src="theme/js/content.min.js?v=1.0.0"></script>
<script src="theme/js/plugins/validate/jquery.validate.min.js"></script>
<script src="theme/js/plugins/validate/messages_zh.min.js"></script>
<script src="theme/js/plugins/layer/layer.min.js"></script>
<script src="theme/js/jquery.form.js"></script>
<script src="theme/js/custom/staff/form-validate-staff.min.js"></script>
<script src="theme/js/plugins/bootstrap-table/bootstrap-table.min.js"></script>

</body>

</html>

<script>
    <!--异步提交表单验证提交-->
    $(function (){

        var options = {
            beforeSubmit : function() {

            },
            error : function() {
                layer.msg('请求错误！');
            },
            success : function(data) {
                layer.msg(data.message);
                if(data.result){
                    var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                    parent.refresh();
                    parent.layer.close(index); //再执行关闭
                }
                $("#exampleTableEvents").bootstrapTable("refresh",{url:'staff/list.json'});
            }
        };
        $('#updateStaffForm').ajaxForm(options);
    });

</script>
