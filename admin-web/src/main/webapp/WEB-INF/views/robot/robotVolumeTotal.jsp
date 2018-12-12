<%@ taglib prefix="fn" uri="/func" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<%@include file="../common/head-title.jsp"%>
<body class="gray-bg">
<div class="wrapper wrapper-content animated fadeInRight">
    <!-- Panel Other -->
<fn:func url="robot/robotConfig">
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
                                        <label class="control-label col-xs-1" for="startDate" style="margin-left: -20px">成交时间：</label>
                                        <div class="col-sm-3" style="text-align:left;">
                                            <div class="input-daterange input-group" id="datepicker">
                                                <input type="text" class="input-sm form-control" name="start" id="startDate" value="" />
                                                <span class="input-group-addon">到</span>
                                                <input type="text" class="input-sm form-control" name="end" id ="endDate" value="" />
                                             </div>
                                        </div>
                                        <div class="col-sm-2" style="text-align:left;">
                                            <button type="button" style="margin-left:10px" id="search" class="btn btn-primary">查询</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <table id="convertRecordTable" data-height="400" data-mobile-responsive="true">
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
            $("#datepicker").datepicker({
                keyboardNavigation:!1,
                forceParse:!1,
                autoclose:!0
            });

            $("#convertRecordTable").bootstrapTable({
                url:"robotConfig/robotVolumeTotalList",
                pagination:true,
                method: 'POST',
                contentType:"application/x-www-form-urlencoded; charset=UTF-8",
                showColumns: true,     //是否显示所有的列
                showRefresh: true,     //是否显示刷新按钮
                sortable: false,      //是否启用排序
                sortOrder: "desc",     //排序方式
                queryParams:queryParams,
                sidePagination: "server",
                clickToSelect:true,
                singleSelect:true,
                toolbar:"#convertRecordTableToolbar",
                height:500,
                pageSize : 100, //每页的记录行数（*）
                pageList : [ 10, 25, 50, 100,200 ], //可供选择的每页的行数（*）
                columns: [{
                    checkbox: true
                }, {
                    field: 'symbol',
                    title: '交易对',
                    width:200,
                    align:'center'
                }, {
                    field: 'price',
                    title: '单价',
                    width:200,
                    align:'center'
                }, {
                    field: 'allAmount',
                    title: '所有成交量',
                    width:200,
                    align:'center'
                }, {
                    field: 'allTurnover',
                    title: '所有成交额',
                    width:200,
                    align:'center'
                }, {
                    field: 'robotAmount',
                    title: '机器人成交量',
                    width:200,
                    align:'center'
                }, {
                    field: 'robotTurnover',
                    title: '机器人成交额',
                    width:200,
                    align:'center'
                }, {
                    field: 'customerAmount',
                    title: '用户成交量',
                    width:200,
                    align:'center'
                }, {
                    field: 'customerTurnover',
                    title: '用户成交额',
                    width:200,
                    align:'center'
                }, {
                    field: 'robotCustomerAmount',
                    title: '机器人&用户成交量',
                    width:200,
                    align:'center'
                }, {
                    field: 'robotCustomerTurnover',
                    title: '机器人&用户成交额',
                    width:200,
                    align:'center'
                }
                ]
            });

            $("#search").on("click", function () {
                refresh();
            });

        })(jQuery);
        //刷新
        function refresh(){
            $("#convertRecordTable").bootstrapTable("refresh");
        }

        //查询参数
        function queryParams(params) {
            params.startDate = $("#startDate").val();
            params.endDate = $("#endDate").val();
            params.limit = params.limit;
            params.offset =params.offset;
            return params;
        }

    </script>
</body>
</html>
