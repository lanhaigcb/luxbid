<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="b" %>
<b:base></b:base>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <%@include file="../common/head-title.jsp"%>
<body class="">
<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox float-e-margins">

                <div class="ibox-content">
                    <form class="form-horizontal m-t" id="updateStaffForm" action="staff/update" method="post">
                        <div class="form-group">
                            <input id="id" name="id" class="form-control" type="hidden" value="${staff.id}">
                            <label class="col-sm-3 control-label">登录名：</label>
                            <div class="col-sm-8">
                                <input id="name" name="name" readonly="readonly" class="form-control" type="text"
                                       value="${staff.name}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">真实姓名：</label>
                            <div class="col-sm-8">
                                <input id="realname" name="realname" readonly="readonly" class="form-control"
                                       type="text" value="${staff.realname}">
                                <span class="help-block m-b-none"><i class="fa fa-info-circle"></i> 请输入您的真实姓名</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">选择角色：</label>
                            <div class="col-sm-8">
                                <select class="form-control" id="roleId" name="roleId">
                                    <c:forEach items="${roles}" var="role">
                                        <option value="${role.id}" title="${staff.roleName}" ${role.roleName == staff.roleName ? "selected" : ""}>${role.roleName}</option>
                                    </c:forEach>
                                </select>
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
    $(function () {

        var options = {
            beforeSubmit: function () {

            },
            error: function () {
                layer.msg('请求错误！');
            },
            success: function (data) {
                layer.msg(data.message);
                if (data.result) {
                    var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                    parent.refresh();
                    parent.layer.close(index); //再执行关闭
                }
                $("#exampleTableEvents").bootstrapTable("refresh", {url: 'staff/list.json'});
            }
        };
        $('#updateStaffForm').ajaxForm(options);

    });

</script>
