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
                    <form class="form-horizontal m-t" id="addSystemSettingForm" action = "systemSetting/add" method="post">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">系统参数名称：</label>
                            <div class="col-sm-8">
                                <input id="name" name="name" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">系统参数类型：</label>
                                <div class="col-sm-8">
                                    <select class="form-control" id="systemSettingType" name="systemSettingType">
                                        <c:forEach items="${types}"  var="type">
                                            <option value="${type.key}">${type.value}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">值：</label>
                            <div class="col-sm-8">
                                <input id="value" name="value" class="form-control" type="text">
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
                //提交前要做什么处理
            },
            beforeSend: function() {
                //发送请求前要做什么操作
            },
            complete: function() {
                //请求完成要做什么操作
            },
            error : function() {
                layer.msg('请求错误！');
            },
            success : function(data) {
                layer.msg(data.message);
                if(data.result){
                    parent.refresh();
                    var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                    parent.layer.close(index); //再执行关闭
                }
            }
        };
        $('#addSystemSettingForm').ajaxForm(options);
    });

</script>
