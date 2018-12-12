<%@ page contentType="text/html;charset=UTF-8" language="java" %><!DOCTYPE html>
<%@ taglib tagdir="/WEB-INF/tags" prefix="b" %>
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

</head>

<body class="">
<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox float-e-margins">

                <div class="ibox-content">
                    <form class="form-horizontal m-t" method="post" id="functionInfoForm" action="functionInfo/update">
                        <div class="form-group">
                            <input id="id" name="id" value="${functionInfo.id}" class="form-control" type="hidden">
                            <label class="col-sm-3 control-label">名称：</label>
                            <div class="col-sm-8">
                                <input id="name" name="name" value="${functionInfo.name}" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">URI：</label>
                            <div class="col-sm-8">
                                <input id="uri" name="uri" value="${functionInfo.uri}" class="form-control" type="text" aria-required="true" aria-invalid="false" class="valid">
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
<script src="theme/js/jquery.form.js"></script>
<%--<script src="theme/js/demo/form-validate-demo.min.js"></script>--%>
<script type="text/javascript" src="http://tajs.qq.com/stats?sId=9999999" charset="UTF-8"></script>
</body>


<!-- Mirrored from www.suhai.com/theme/hplus/form_validate.html by HTTrack Website Copier/3.x [XR&CO'2014], Wed, 20 Jan 2016 14:19:16 GMT -->
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
                console.log(22222)
                if(data.result){
                    var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                    parent.refresh();
                    parent.layer.close(index); //再执行关闭
                }
            }
        };
       $('#functionInfoForm').ajaxForm(options);
    });

</script>
