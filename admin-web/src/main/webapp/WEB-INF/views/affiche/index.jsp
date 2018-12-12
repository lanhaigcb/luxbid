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
                                        <label class="control-label col-xs-1" for="title" style="margin-left: -20px">公告标题：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="title" placeholder="公告名称">
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
                            <fn:func url="affiche/lookInput">
                                <button type="button" id="look" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-plus" aria-hidden="true">查看公告</i>
                                </button>
                            </fn:func>
                            <fn:func url="affiche/addInput">
                                <button type="button" id="add" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-plus" aria-hidden="true">新增公告</i>
                                </button>
                            </fn:func>
                            <fn:func url="affiche/updateInput">
                                <button type="button" id="update" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-pencil" aria-hidden="true">更新公告</i>
                                </button>
                            </fn:func>
                        </div>
                    <table id="afficheTable" data-height="400" data-mobile-responsive="true">
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
            $("#afficheTable").bootstrapTable({
                method: 'POST',
                contentType:"application/x-www-form-urlencoded; charset=UTF-8",
                url:"affiche/findListAllBack",
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
                    field: 'title',
                    title: '标题',
                    width:50,
                    align:'center'
                }, {
                    field: 'coverImg',
                    title: '封面图片',
                    width:50,
                    align:'center',
                    formatter:function(value,row,index) {
                        if (value!="" && value!=null){
                            return '<img src="'+value+'" width="90" height="90" class="img-rounded" />';
                        }}
                }, {
                    field: 'externalLinks',
                    title: '外部链接地址',
                    width:50,
                    align:'center'
                },{
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
                    field: 'noticeType',
                    title: '公告类型',
                    width:50,
                    align:'center',
                    formatter:function(value,row,index) {
                        if (value == 'MEDIA') {
                            return '媒体报道';
                        } else if (value == 'NOTICE') {
                            return '公告';
                        }
                    }
                }, {
                    field: 'clientType',
                    title: '客户端类型',
                    width:50,
                    align:'center',
                    formatter:function(value,row,index) {
                        if (value == 'PC') {
                            return 'PC';
                        } else if (value == 'APP') {
                            return 'APP';
                        }
                    }
                }, {
                    field: 'publishTime',
                    title: '发布时间',
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
                    title: '公告国际化标记',
                    width:50,
                    align:'center'
                }
                ]
            });

            //查询参数
            function queryParams(params) {
                params.title = $("#title").val();
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
            $("#afficheTable").bootstrapTable("refresh");
        }

        $("#look").click(function () {
            var rows = $("#afficheTable").bootstrapTable("getSelections");
            if(rows.length != 1){
                layer.msg('请选择一行执行操作！');
                return
            }
            layer.open({
                type: 2,
                title: '查看公告',
                shadeClose: true,
                shade: 0.8,
                area: ['80%', '90%'],
                content: 'affiche/lookInput?id='+rows[0].id
            });
        });

        $("#add").click(function () {
            layer.open({
                type: 2,
                title: '新增公告',
                shadeClose: true,
                shade: 0.8,
                area: ['80%', '90%'],
                content: 'affiche/addInput'
            });
        });

        $("#update").click(function () {
            var rows = $("#afficheTable").bootstrapTable("getSelections");
            if(rows.length != 1){
                layer.msg('请选择一行执行操作！');
                return
            }
            layer.open({
                type: 2,
                title: '编辑公告',
                shadeClose: true,
                shade: 0.8,
                area: ['80%', '90%'],
                content: 'affiche/updateInput?id='+rows[0].id
            });
        });
    </script>
</body>
</html>
