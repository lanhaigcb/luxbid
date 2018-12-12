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
                        <%--<div class="panel panel-default">
                            <div class="panel-heading">查询条件</div>
                            <div class="panel-body">
                                <form id="formSearch" class="form-horizontal">
                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-xs-1" for="title" style="margin-left: -20px">分类标题：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="title" placeholder="帮助中心分类标题">
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
                        </div>--%>
                        <div class="btn-group hidden-xs" id="tableToolbar" role="group">
                            <%--<fn:func url="affiche/lookInput">
                                <button type="button" id="look" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-plus" aria-hidden="true">查看分类</i>
                                </button>
                            </fn:func>--%>
                            <fn:func url="versionUpdate/addInput">
                                <button type="button" id="add" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-plus" aria-hidden="true">新增版本</i>
                                </button>
                                <button type="button" id="add2" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-plus" aria-hidden="true">新增版本(上传安装包)</i>
                                </button>
                            </fn:func>
                        </div>
                        <table id="versionUpdateTable" data-height="400" data-mobile-responsive="true">
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
        $("#versionUpdateTable").bootstrapTable({
            method: 'POST',
            contentType:"application/x-www-form-urlencoded; charset=UTF-8",
            url:"versionUpdate/list",
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
                field: 'newVersion',
                title: '最新版本号',
                width:50,
                align:'center'
            },{
                field: 'lowVersion',
                title: '最低版本号',
                width:50,
                align:'center'
            },{
                field: 'osType',
                title: 'app系统',
                width:50,
                align:'center'
            },{
                field: 'url',
                title: '下载链接',
                width:50,
                align:'center'
            },{
                field: 'createTime',
                title: '创建时间',
                width:50,
                align:'center'
            },{
                field: 'versionInfo',
                title: '渠道',
                width:50,
                align:'center'
            }
            ]
        });

        //查询参数
        function queryParams(params) {
            params.category = $("#title").val();
            params.internationalType = $("#internationalType").val();
            params.size = params.limit;
            params.offset =params.offset;
            return params;
        }
        $("#search").on("click",function(){
            refresh()
        });
    })(jQuery);

    function refresh(){
        $("#versionUpdateTable").bootstrapTable("refresh");
    }

    //$("#look").click(function () {
    //    var rows = $("#versionUpdateTable").bootstrapTable("getSelections");
    //    if(rows.length != 1){
    //        layer.msg('请选择一行执行操作！');
    //        return
    //    }
    //    layer.open({
    //        type: 2,
    //        title: '查看分类',
    //        shadeClose: true,
    //        shade: 0.8,
    //        area: ['80%', '90%'],
    //        content: 'affiche/lookInput?id='+rows[0].id
    //    });
    //});

    $("#add").click(function () {
        layer.open({
            type: 2,
            title: '新增版本',
            shadeClose: true,
            shade: 0.8,
            area: ['80%', '90%'],
            content: 'versionUpdate/addInput'
        });
    });

    $("#add2").click(function () {
        layer.open({
            type: 2,
            title: '新增版本(上传安装包)',
            shadeClose: true,
            shade: 0.8,
            area: ['80%', '90%'],
            content: 'versionUpdate/addInput2'
        });
    });

    $("#update").click(function () {
        var rows = $("#versionUpdateTable").bootstrapTable("getSelections");
        if(rows.length != 1){
            layer.msg('请选择一行执行操作！');
            return
        }
        layer.open({
            type: 2,
            title: '编辑分类',
            shadeClose: true,
            shade: 0.8,
            area: ['80%', '90%'],
            content: 'versionUpdate/updateInput?id='+rows[0].id
        });
    });
</script>
</body>
</html>
