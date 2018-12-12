<%@ taglib prefix="fn" uri="/func" %>
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
                <div class="col-sm-12">
                    <div class="panel-body" style="padding-bottom:0px;">
                        <div class="panel panel-default">
                            <%--<div class="panel-heading">查询条件</div>
                            <div class="panel-body">
                                <form id="formSearch" class="form-horizontal">
                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-sm-1" for="username">姓名</label>
                                        <div class="col-sm-4">
                                            <input type="text" class="form-control" id="username">
                                        </div>
                                        <label class="control-label col-sm-1" >状态</label>
                                        <div class="col-sm-4">
                                           <div class="radio">
                                                <input type="radio" id="singleRadio1" value="option1" name="radioSingle1" aria-label="Single radio One">
                                                <label></label>
                                            </div>
                                        </div>
                                        <div class="col-sm-2" style="text-align:left;">
                                            <button type="button" style="margin-left:50px" id="search" class="btn btn-primary">查询</button>
                                        </div>
                                    </div>
                                </form>
                            </div>--%>
                        </div>
                        <div class="btn-group hidden-xs" id="staffTableToolbar" role="group">
                            <fn:func url="staff/addInput">
                                <button type="button" id="add" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-plus" aria-hidden="true">新增后台用户</i>
                                </button>
                            </fn:func>
                        <fn:func url="staff/updateInput">
                        <button type="button" id="update" class="btn btn-outline btn-default">
                            <i class="glyphicon glyphicon-pencil" aria-hidden="true">修改角色</i>
                        </button>
                            </fn:func>
                        <fn:func url="staff/reset/password">
                        <button type="button" id="resetPassword" class="btn btn-outline btn-default">
                            <i class="glyphicon glyphicon-wrench" aria-hidden="true">重置密码</i>
                        </button>
                            </fn:func>
                        <%--<button type="button" id="delete" class="btn btn-outline btn-default">
                            <i class="glyphicon glyphicon-trash" aria-hidden="true"></i>
                        </button>--%>
                    </div>
                    <table id="staffTable" data-height="600" data-mobile-responsive="true">
                    </table>
                </div>
            </div>
        </div>
    </div>
    <!-- End Panel Other -->
</div>
</div>

<script type="text/javascript" charset="UTF-8">
    var $table = $("#staffTable");
    $table.bootstrapTable({
        url:"staff/list.json",
        pagination:true,
        showColumns: true,     //是否显示所有的列
        showRefresh: true,     //是否显示刷新按钮
        sortable: false,      //是否启用排序
        sortOrder: "asc",     //排序方式
        queryParams:queryParams,
        sidePagination: "server",
        singleSelect:true,
        clickToSelect:true,
        toolbar:"#staffTableToolbar",
        columns: [{
            checkbox: true
        }, {
            field: 'id',
            width: 100,
            align: 'center',
            title: 'ID'

        }, {
            field: 'name',
            width: 100,
            align: 'center',
            title: '登录名'
        }, {
            field: 'realname',
            width: 100,
            align: 'center',
            title: '真实姓名'
        }, {
            field: 'roleName',
            width: 100,
            align: 'center',
            title: '角色'
        }, {
            field: 'make',
            title: '操作',
            width: 100,
            align: 'center',
            formatter:function(value,row,index){
                if (row.enable){
                    return '<span style="color:green">已启用</span><button  onclick="unEnable(\''+ row.id +'\')">禁用</button> ';
                }else {
                    return '<span style="color:red">已禁用</span><button  onclick="enable(\''+ row.id + '\')">启用</button> ';
                }
            }
            }
        ]
    });

    //启用
    function enable(id) {
        updateStatus(id,"enable");
    }
    //禁用
    function unEnable(id) {
        updateStatus(id,"unEnable");
    }
    //更新状态
    function updateStatus(id,status) {
        $.ajax({
            url:'staff/updateStatus',
            data:{id:id,status:status},
            success: function (data) {
                if(data.result){
                    if("enable" == status){
                        layer.msg("已启用");
                    }else {
                        layer.msg("已禁用");
                    }
                }else{
                    layer.msg("操作失败")
                }
                refresh();
            }
        })
    }


    //查询参数
    function queryParams(params) {
        params.name = $("#username").val();
        return params;
    }
    $("#search").on("click",function(){
        refresh();
    });

    //刷新
    function refresh(){
        $table.bootstrapTable("refresh");
    }


        //一些事件实例
    var e=$("#examplebtTableEventsResult");
    $table.on("all.bs.table",function(e,t,o){console.log("Event:",t,", data:",o)})
            .on("click-row.bs.table",function(){
                var ids = $("#exampleTableFromData").bootstrapTable("getSelections");
                console.log(ids)
                e.text(ids)
            })
            .on("dbl-click-row.bs.table",function(){e.text("Event: dbl-click-row.bs.table")})
            .on("sort.bs.table",function(){e.text("Event: nihao")})
            .on("check.bs.table",function(){e.text("Event: check.bs.table")})
            .on("uncheck.bs.table",function(){e.text("Event: uncheck.bs.table")})
            .on("check-all.bs.table",function(){e.text("Event: check-all.bs.table")})
            .on("uncheck-all.bs.table",function(){e.text("Event: uncheck-all.bs.table")})
            .on("load-success.bs.table",function(){e.text("Event: load-success.bs.table")})
            .on("load-error.bs.table",function(){e.text("Event: load-error.bs.table")})
            .on("column-switch.bs.table",function(){e.text("Event: column-switch.bs.table")})
            .on("page-change.bs.table",function(){e.text("Event: page-change.bs.table")})
            .on("search.bs.table",function(){
                console.log("表格刷新按钮了")
            })

    //新增
    $("#add").click(function () {
        layer.open({
            type: 2,
            title: '用户管理',
            shadeClose: true,
            shade: 0.8,
            area: ['60%', '70%'],
            content: 'staff/addInput'
        });
    });

    //新增机构管理员
    $("#add_org_admin").click(function () {
        layer.open({
            type: 2,
            title: '新增机构管理员',
            shadeClose: true,
            shade: 0.8,
            area: ['60%', '70%'],
            content: 'staff/addOrgAdminInput'
        });
    });

    //更新角色
    $("#update").click(function () {
        var rows = $("#staffTable").bootstrapTable("getSelections");
        if(rows.length != 1){
            layer.msg('请选择一行执行操作！');
            return
        }
        layer.open({
            type: 2,
            title: '用户管理',
            shadeClose: true,
            shade: 0.8,
            area: ['60%', '65%'],
            content: 'staff/updateInput?staffId='+rows[0].id
        });
    });


    //修改
    $("#resetPassword").click(function () {
        var rows = $("#staffTable").bootstrapTable("getSelections");
        if(rows.length != 1){
            layer.msg('请选择一行执行操作！');
            return
        }
        layer.open({
            type: 2,
            title: '用户管理',
            shadeClose: true,
            shade: 0.8,
            area: ['60%', '65%'],
            content: 'staff/reset/password?staffId='+rows[0].id
        });
    })


    //删除
    $("#delete").click(function () {
        var rows = $("#staffTable").bootstrapTable("getSelections");
        if(rows.length != 1){
            layer.msg('请选择一行执行操作！');
            return
        }
        swal({
            title: "您确定要删除这条信息吗",
            text: "删除后将无法恢复，请谨慎操作！",
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "删除",
            closeOnConfirm: false
        }, function () {
            $.ajax({
                url:"staff/delete",
                data:{id:rows[0].id},
                success: function (data) {
                    if(data.result){
                        swal("删除成功！", "您已经删除了这条信息。", "success");
                    }else{
                        swal("删除失败！", "删除中出现问题："+data.message, "warning");
                    }
                    refresh();
                },
                error: function () {
                    swal("删除失败！", "请求错误。", "error");
                }
            });
        });
    });
</script>

</body>
</html>
