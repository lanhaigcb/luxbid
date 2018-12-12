<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp"%>
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
                            <div class="panel-heading">查询条件</div>
                            <div class="panel-body">
                                <form id="formSearch" class="form-horizontal">
                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-xs-1" for="name" style="margin-left: -20px">banner名称：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="name" placeholder="banner名称">
                                        </div>
                                        <label class="control-label col-xs-1" for="internationalType" style="margin-left: -20px">国际化类型：</label>
                                        <div class="col-sm-2">
                                            <select id="internationalType" class="form-control">
                                                <option value="">请选择</option>
                                                <option value="zh-cn">中国大陆</option>
                                                <option value="zh-tw">中国台湾</option>
                                                <option value="en-us">美国</option>
                                            </select>
                                        </div>
                                        <div class="col-sm-2" style="text-align:left;">
                                            <button type="button" style="margin-left:50px" id="search" class="btn btn-primary">查询</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <div class="btn-group hidden-xs" id="tableToolbar" role="group">
                            <fn:func url="banner/addInput">
                                <button type="button" id="add" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-plus" aria-hidden="true">新增banner</i>
                                </button>
                            </fn:func>
                            <fn:func url="banner/updateInput">
                                <button type="button" id="update" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-pencil" aria-hidden="true">编辑banner</i>
                                </button>
                            </fn:func>
                        </div>
                    <table id="bannerTable" data-height="400" data-mobile-responsive="true">
                    </table>
                </div>
            </div>
        </div>
    </div>
    <!-- End Panel Other -->
    </div>
</div>
    <script type="text/javascript" charset="UTF-8">
        (function($){
            $("#bannerTable").bootstrapTable({
                method: 'POST',
                contentType:"application/x-www-form-urlencoded; charset=UTF-8",
                url:"banner/findListAllBack",
                pagination:true,
                showColumns: true,     //是否显示所有的列1
                showRefresh: true,     //是否显示刷新按钮
                sortable: false,      //是否启用排序
                sortOrder: "asc",     //排序方式
                queryParams:queryParams,
                sidePagination: "server",
                clickToSelect:true,
                singleSelect:true,
                toolbar:"#tableToolbar",
                height:500,
                pageSize : 10, //每页的记录行数（*）
                pageList : [ 10, 25, 50, 100 ], //可供选择的每页的行数（*）
                columns: [{
                    checkbox: true
                }, {
                    field: 'id',
                    title: 'ID',
                    width:50,
                    align:'center'
                }, {
                    field: 'name',
                    title: '名称',
                    width:50,
                    align:'center'
                }, {
                    field: 'imageURI',
                    title: '图片',
                    width:50,
                    align:'center',
                    formatter:function(value,row,index) {
                        if (value!="" && value!=null){
                            return '<img src="'+value+'" width="90" height="90" class="img-rounded" />';
                        }}
                }, {
                    field: 'htmlURL',
                    title: '落地页地址',
                    width:50,
                    align:'center'
                }, {
                    field: 'htmlTitle',
                    title: '落地页标题',
                    width:50,
                    align:'center'
                }, {
                    field: 'terminalType',
                    title: '终端',
                    width:50,
                    align:'center'
                }, {
                    field: 'enable',
                    title: '是否可用',
                    width:50,
                    align:'center',
                    formatter:function(value,row,index) {
                        if (value == true) {
                            return '是';
                        } else if (value == false) {
                            return '否';
                        }
                    }
                }, {
                    field: 'createTime',
                    title: '创建时间',
                    width:50,
                    align:'center'
                }, {
                    field: 'updateTime',
                    title: '最近更新时间',
                    width:50,
                    align:'center'
                }, {
                    field: 'sortParameter',
                    title: '排序参数',
                    width:50,
                    align:'center'
                }, {
                    field: 'internationalType',
                    title: 'banner国际化标记',
                    width:50,
                    align:'center'
                }
                ]
            });

            //查询参数
            function queryParams(params) {
                params.name = $("#name").val();
                params.internationalType = $("#internationalType").val();
                params.limit = params.limit;
                params.offset =params.offset;
                return params;
            }
            $("#search").on("click",function(){
                refresh()
            });
        })(jQuery);

        function refresh(){
            $("#bannerTable").bootstrapTable("refresh");
        }

        $("#add").click(function () {
            layer.open({
                type: 2,
                title: '新增banner',
                shadeClose: true,
                shade: 0.8,
                area: ['80%', '90%'],
                content: 'banner/addInput'
            });
        });

        $("#update").click(function () {
            var rows = $("#bannerTable").bootstrapTable("getSelections");
            if(rows.length != 1){
                layer.msg('请选择一行执行操作！');
                return
            }
            layer.open({
                type: 2,
                title: '编辑banner',
                shadeClose: true,
                shade: 0.8,
                area: ['80%', '90%'],
                content: 'banner/updateInput?id='+rows[0].id
            });
        });
    </script>
</body>
</html>
