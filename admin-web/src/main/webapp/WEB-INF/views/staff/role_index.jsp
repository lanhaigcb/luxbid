<%@ taglib prefix="fn" uri="/func" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <%@include file="../common/head-title.jsp"%>
<body class="gray-bg">
<div class="wrapper wrapper-content animated fadeInRight">
    <!-- Panel Other -->
    <div class="ibox float-e-margins">

        <div class="ibox-content">
            <div class="row row-lg">
                <div class="col-sm-8">
                    <!-- Example Events -->
                    <div class="example-wrap">
                        <div class="example">
                            <div class="btn-group hidden-xs" id="staffRoleTableEventsToolbar" role="group">
                                <button type="button"  id="add" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-plus" aria-hidden="true">新增角色</i>
                                </button>
                                <button type="button"  id="update" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-pencil" aria-hidden="true">修改角色</i>
                                </button>
                                <button type="button" id="authority" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-wrench" aria-hidden="true">设置权限</i>
                                </button>
                            </div>
                            <table id="staffRoleTableEvents" data-height="600" data-mobile-responsive="true">
                                <thead>
                                <tr>
                                    <th data-field="state" data-checkbox="true"></th>
                                    <th data-field="id">ID</th>
                                    <th data-field="roleName">名称</th>
                                    <th data-field="enable" data-formatter="">使用状态</th>
                                </tr>
                                </thead>
                            </table>
                        </div>
                    </div>
                    <!-- End Example Events -->
                </div>
            </div>
        </div>
    </div>
    <!-- End Panel Other -->
</div>

<script type="text/javascript" charset="UTF-8">

    $("#staffRoleTableEvents").bootstrapTable({
        url:"staffRole/list.json",
        search:!0,
        pagination:!0,
        showRefresh:!0,
        showToggle:!0,
        showColumns:!0,
        iconSize:"outline",
        sidePagination: "server",
        singleSelect:true,
        pageSize: 15,
        clickToSelect:true,
        toolbar:"#staffRoleTableEventsToolbar",
        icons:{refresh:"glyphicon-repeat",toggle:"glyphicon-list-alt",columns:"glyphicon-list"}
    });

    $("#add").click(function () {
        layer.open({
            type: 2,
            title: '新增角色',
            shadeClose: true,
            shade: 0.8,
            area: ['60%', '50%'],
            content: 'staffRole/addInput'
        });
    });

    $("#update").click(function () {
        var rows = $("#staffRoleTableEvents").bootstrapTable("getSelections");
        if(rows.length != 1){
            layer.msg('请选择一行执行操作！');
            return
        }
        layer.open({
            type: 2,
            title: '更新角色',
            shadeClose: true,
            shade: 0.8,
            area: ['60%', '65%'],
            content: 'staffRole/updateInput?id='+rows[0].id
        });
    });

    //授权
    $("#authority").click(function () {
        var rows = $("#staffRoleTableEvents").bootstrapTable("getSelections");
        if(rows.length != 1){
            layer.msg('请选择一行执行操作！');
            return
        }
        layer.open({
            type: 2,
            title: '角色权限设置',
            shadeClose: true,
            shade: 0.8,
            area: ['60%', '80%'],
            content: 'staffRole/authority?staffRoleId='+rows[0].id
        });
    })

    function refresh() {
        $("#staffRoleTableEvents").bootstrapTable("refresh");
    }


</script>

</body>
</html>
