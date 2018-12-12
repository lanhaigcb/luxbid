<%@ taglib prefix="fn" uri="/func" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<%@include file="../common/head-title.jsp"%>
<body class="gray-bg">
<div class="wrapper wrapper-content animated fadeInRight">
    <!-- Panel Other -->
<fn:func url="convertRecord/index">
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
                                        <label class="control-label col-xs-1" for="customerAccount" style="margin-left: -20px">用户账号：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="customerAccount" placeholder="用户账号">
                                        </div>
                                        <label class="control-label col-xs-1" for="customerId" style="margin-left: -20px">用户ID：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="customerId" placeholder="用户ID">
                                        </div>
                                        <label class="control-label col-xs-1" for="symbol" style="margin-left: -20px">奖励币种：</label>
                                        <div class="col-sm-2">
                                            <select class="form-control show-tick"  id="symbol" name="symbol">
                                                <option value="" >请选择</option>
                                                <c:forEach items="${currencys}" var="currency">
                                                    <option value="${currency.symbol}">${currency.symbol}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-xs-1" for="startDate" style="margin-left: -20px">兑换时间：</label>
                                        <div class="col-sm-3" style="text-align:left;">
                                            <div class="input-daterange input-group" id="datepicker">
                                                <input type="text" class="input-sm form-control" name="start" id="startDate" value="" />
                                                <span class="input-group-addon">到</span>
                                                <input type="text" class="input-sm form-control" name="end" id ="endDate" value="" />
                                             </div>
                                        </div>
                                        <div class="col-sm-2" style="text-align:left;">
                                            <button type="button" style="margin-left:10px" id="search" class="btn btn-primary">查询</button>
                                            <fn:func url="convert/record/export">
                                                <button type="button" style="margin-left:10px" id="export" class="btn btn-primary">导出</button>
                                            </fn:func>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <div class="panel panel-default">
                            <div class="panel-heading">统计信息</div>
                            <div class="panel-body">
                                <form id="totalInfo" class="form-horizontal">
                                    <div class="form-group" id="total" style="margin-top:15px"></div>
                                </form>
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

            totalInfo();

            $("#datepicker").datepicker({
                keyboardNavigation:!1,
                forceParse:!1,
                autoclose:!0
            });

            $("#convertRecordTable").bootstrapTable({
                url:"convertRecord/list",
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
                    field: 'id',
                    title: 'ID',
                    width:100,
                    align:'center'
                }, {
                    field: 'symbol',
                    title: '获取币种',
                    width:200,
                    align:'center'
                }, {
                    field: 'customerAccount',
                    title: '兑换人账号',
                    width:200,
                    align:'center'
                }, {
                    field: 'exchangeGet',
                    title: '获取币种数',
                    width:200,
                    align:'center'
                }, {
                    field: 'exchangeUsed',
                    title: '消耗糖果数',
                    width:200,
                    align:'center'
                },{
                    field: 'createTime',
                    title: '兑换时间',
                    width:100,
                    align:'center'
                }
                ]
            });

            $("#search").on("click", function () {
                refresh();
            });

            $("#export").click(function () {
                var params = {};
                params=queryParams(params);
                window.location.href="convert/record/export?"+
                    "customerAccount="+params.customerAccount +
                    "&symbol="+params.symbol +
                    "&startDate="+params.startDate+
                    "&endDate="+params.endDate;
            });
        })(jQuery);
        //刷新
        function refresh(){
            totalInfo();
            $("#convertRecordTable").bootstrapTable("refresh");
        }

        function totalInfo() {
            var customerAccount = $("#customerAccount").val();
            var customerId = $("#customerId").val();
            var symbol = $("#symbol").val();
            var startDate = $("#startDate").val();
            var endDate = $("#endDate").val();

            $.ajax({
                url: "convertRecord/total",
                dataType: "json",
                data: {customerAccount:customerAccount,customerId:customerId,symbol:symbol,
                    startDate:startDate,endDate:endDate},
                success: function (data) {
                    var totalInfo = eval(data.rows);
                    $("#total").empty();
                    for (var i=0;i<totalInfo.length;i++)
                    {
                        var veh = totalInfo[i];//获取LIST里面的对象
                        $("#total").append('<div class="col-sm-7" style="margin-bottom: 5px"><span>获取币种：'+veh.symbol+'&nbsp;&nbsp;&nbsp;</span><span>获取数量：'+veh.exget+'&nbsp;&nbsp;&nbsp;</span><span>消耗糖果数量：'+veh.exused+'</span></div>');
                    }
                }
            });
        }

        //查询参数
        function queryParams(params) {
            params.customerAccount = $("#customerAccount").val();
            params.customerId = $("#customerId").val();
            params.symbol = $("#symbol").val();
            params.startDate = $("#startDate").val();
            params.endDate = $("#endDate").val();
            params.limit = params.limit;
            params.offset =params.offset;
            return params;
        }
    </script>
</body>
</html>
