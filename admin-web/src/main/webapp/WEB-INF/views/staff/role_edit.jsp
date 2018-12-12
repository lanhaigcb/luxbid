<%@ page contentType="text/html;charset=UTF-8" language="java" %><!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<%@include file="../common/head-title.jsp"%>
<script src="theme/js/custom/staff/form-validate-staff.min.js"></script>
<body class="">
<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <form class="form-horizontal m-t" method="post" id="updateStaffForm" action = "staffRole/edit">
                        <div class="form-group">
                            <input id="id" name="id" value="${staffRole.id}"  class="form-control" type="hidden">
                            <label class="col-sm-3 control-label">用户名：</label>
                            <div class="col-sm-8">
                                <input id="roleName" name="roleName" value="${staffRole.roleName}" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">英文名：</label>
                            <div class="col-sm-8">
                                <input id="roleEnName" name="roleEnName"  class="form-control" value="${staffRole.roleEnName}" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">是否启用：</label>
                            <div class="col-sm-8">
                                <div class="radio i-checks">
                                    <label><input type="radio" value="true" name="enable" checked="checked" > <i></i> 是</label>
                                    <label><input type="radio" value="false" name="enable"> <i></i> 否</label>
                                </div>
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

</body>
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
                $("#staffRoleTableEvents").bootstrapTable("refresh",{url:'staffRole/list.json'});
            }
        };
        $('#updateStaffForm').ajaxForm(options);

    });

</script>
</html>
