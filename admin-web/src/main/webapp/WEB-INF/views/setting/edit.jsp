<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<%@include file="../common/head-title.jsp"%>
<body class="">
<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <form class="form-horizontal m-t" id="updateSystemSettingForm" action = "systemSetting/update" method="post">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">系统参数名称：${systemSetting.systemSettingType.toString()}</label>
                            <div class="col-sm-8">
                                <input id="systemSettingId" name="systemSettingId" class="form-control" type="hidden" value="${systemSetting.id}">
                                <input id="name" name="name" class="form-control" type="hidden" value="${systemSetting.name}">
                            </div>

                        <div class="form-group">
                            <div class="col-sm-8">
                                值：<input id="value" name="value" class="form-control" type="text" value="${systemSetting.value}">
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
<script src="theme/js/custom/staff/form-validate-setting.min.js"></script>

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
            }
        };
        $('#updateSystemSettingForm').ajaxForm(options);

    });

</script>
