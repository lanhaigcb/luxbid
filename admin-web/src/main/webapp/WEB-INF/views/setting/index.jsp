<%@ taglib prefix="fn" uri="/func" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<%@include file="../common/head-title.jsp"%>
<body class="gray-bg">
<div class="wrapper wrapper-content animated fadeInRight">
    <!-- Panel Other -->
<fn:func url="systemParameter/systemParameter/page">
    <div class="ibox float-e-margins">

        <div class="ibox-content">
            <div class="row row-lg">
                <div class="col-sm-12">
                    <div class="panel-body" style="padding-bottom:0px;">
                        <div class="btn-group  col-sm-12" id="settingTableToolbar" role="group">
                            <fn:func url="systemParameter/systemParameter/add">
                            <button type="button" id="add" class="btn btn-outline btn-default">
                                <i class="glyphicon glyphicon-plus" aria-hidden="true">添加</i>
                            </button>
                            </fn:func>
                            <fn:func url="systemParameter/systemParameter/update">
                            <button type="button" id="update" class="btn btn-outline btn-default">
                                <i class="glyphicon glyphicon-pencil" aria-hidden="true">修改</i>
                            </button>
                            </fn:func>
                            <fn:func url="systemParameter/systemParameter/delete">
                            <button type="button" id="delete" class="btn btn-outline btn-default">
                                <i class="glyphicon glyphicon-trash" aria-hidden="true">删除</i>
                            </button>
                            </fn:func>
                        </div>
                    <table id="settingTable" data-height="400" data-mobile-responsive="true">
                    </table>
                </div>
            </div>
        </div>
    </div>
    <!-- End Panel Other -->
    </div>
</fn:func>
</div>
    <script type="text/javascript" charset="UTF-8">
        (function($){
            $("#settingTable").bootstrapTable({
                url:"systemSetting/list.json",
                pagination:true,
                showColumns: false,     //是否显示所有的列
                showRefresh: false,     //是否显示刷新按钮
                sortable: false,      //是否启用排序
                sortOrder: "asc",     //排序方式
                queryParams:queryParams,
                sidePagination: "server",
                singleSelect:true,
                clickToSelect:true,
                toolbar:"#settingTableToolbar",
                pageSize : 10, //每页的记录行数（*）
                pageList : [ 10, 25, 50, 100 ], //可供选择的每页的行数（*）
                columns: [{
                    checkbox: true
                }, {
                    field: 'id',
                    title: 'ID',
                    width:100,
                    align:'center'
                }, {
                    field: 'name',
                    title: '系统参数名称',
                    width:200,
                    align:'center'
                }, {
                    field: 'systemSettingType',
                    title: '系统参数类型',
                    width:200,
                    align:'center'
                }, {
                    field: 'value',
                    title: '值',
                    width:500,
                    align:'center'
                }
                ]
            });

            //查询参数
            function queryParams(params) {
                params.name = $("#username").val();
                params.limit = params.limit;
                params.offset =params.offset;
                return params;
            }
            $("#search").on("click",function(){
                refresh()
            });
        })(jQuery);

        function refresh(){
            $("#settingTable").bootstrapTable("refresh");
        }

        $("#add").click(function () {
            layer.open({
                title: '添加系统参数',
                type: 2,
                fix: false, //不固定
                maxmin: true,
                area: ['60%', '65%'],
                content: 'systemSetting/addInput'
            });
        });

        $("#update").click(function () {
            var rows = $("#settingTable").bootstrapTable("getSelections");
            if(rows.length != 1){
                layer.msg('请选择一行执行操作！');
                return
            }
            layer.open({
                title: '修改系统参数',
                type: 2,
                fix: false, //不固定
                maxmin: true,
                area: ['60%', '65%'],
                content: 'systemSetting/updateInput?systemSettingId='+rows[0].id
            });
        });

        //删除
        $("#delete").click(function () {
            var rows = $("#settingTable").bootstrapTable("getSelections");
            if(rows.length != 1){
                layer.msg('请选择一行执行操作！');
                return
            }
        });
    </script>
</body>
</html>
