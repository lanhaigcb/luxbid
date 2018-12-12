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
                                        <label class="control-label col-xs-1" for="symbol" style="margin-left: -20px">交易对：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="symbol" placeholder="例：BTC/ETH">
                                        </div>
                                        <div class="col-sm-2" style="text-align:left;">
                                            <button type="button" style="margin-left:50px" id="search" class="btn btn-primary">查询</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <div class="btn-group hidden-xs" id="tableToolbar" role="group">
                            <fn:func url="exchangeView/addInput">
                                <button type="button" id="add" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-plus" aria-hidden="true">新增交易对</i>
                                </button>
                            </fn:func>
                            <fn:func url="exchangeView/delete">
                                <button type="button" id="deleteExchangeViewGrant" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-pencil" aria-hidden="true">删除交易对</i>
                                </button>
                            </fn:func>
                        </div>
                    <table id="exhangeViewTable" data-height="400" data-mobile-responsive="true">
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
            $("#exhangeViewTable").bootstrapTable({
                method: 'POST',
                contentType:"application/x-www-form-urlencoded; charset=UTF-8",
                url:"exchangeView/findListAll",
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
                    field: 'symbol',
                    title: '交易对名称',
                    width:50,
                    align:'center'
                }, {
                    field: 'createTime',
                    title: '创建时间',
                    width:50,
                    align:'center'
                }, {
                    field: 'sortParameter',
                    title: '排序参数',
                    width:50,
                    align:'center'
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

            //查询参数
            function queryParams(params) {
                params.symbol = $("#symbol").val();
                params.limit = params.limit;
                params.offset =params.offset;
                return params;
            }
            $("#search").on("click",function(){
                refresh()
            });
        })(jQuery);

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
                url:'exchangeView/updateStatus',
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

        function refresh(){
            $("#exhangeViewTable").bootstrapTable("refresh");
        }

        $("#add").click(function () {
            layer.open({
                type: 2,
                title: '新增exhangeView',
                shadeClose: true,
                shade: 0.8,
                area: ['50%', '60%'],
                content: 'exchangeView/addInput'
            });
        });
        //删除发放记录
        $("#deleteExchangeViewGrant").click(function () {
            var rows = $("#exhangeViewTable").bootstrapTable("getSelections");
            if (rows.length != 1) {
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
                    url: "exchangeView/delete",
                    data: {id: rows[0].id},
                    success: function (data) {
                        if (data.result) {
                            swal("删除成功！", "您已经删除了这条信息。", "success");
                        } else {
                            swal("删除失败！", "删除中出现问题：" + data.message, "warning");
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
