<%@ taglib prefix="fn" uri="/func" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<%@include file="../common/head-title.jsp" %>
<body class="gray-bg">
<div class="wrapper wrapper-content animated fadeInRight">
    <!-- Panel Other -->
<fn:func url="inviteRecord/index">
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
                                        <label class="control-label col-xs-1" for="customerName" style="margin-left: -20px">邀请账号：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="customerName" placeholder="邀请账号">
                                        </div>
                                        <label class="control-label col-xs-1" for="customerId" style="margin-left: -20px">用户ID：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="customerId" placeholder="用户ID">
                                        </div>
                                    </div>
                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-xs-1" for="symbol" style="margin-left: -20px">奖励币种：</label>
                                        <div class="col-sm-2">
                                            <select class="form-control show-tick"  id="symbol" name="symbol">
                                                <option value="" >请选择</option>
                                                <c:forEach items="${currencys}" var="currency">
                                                    <option value="${currency.symbol}">${currency.symbol}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <label class="control-label col-xs-1" for="certification" style="margin-left: -20px">是否实名：</label>
                                        <div class="col-sm-2">
                                            <select class="form-control show-tick" id="certification" placeholder="实名状态">
                                                <option value="" >请选择</option>
                                                <option value="1" >已实名</option>
                                                <option value="0" >未实名</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-xs-1" for="inviteStartDate" style="margin-left: -20px">邀请时间：</label>
                                        <div class="col-sm-3" style="text-align:left;">
                                            <div class="input-daterange input-group" id="datepicker">
                                                <input type="text" class="input-sm form-control" name="start" id="inviteStartDate" value="" />
                                                <span class="input-group-addon">到</span>
                                                <input type="text" class="input-sm form-control" name="end" id ="inviteEndDate" value="" />
                                            </div>
                                        </div>
                                        <label class="control-label col-xs-1" for="authStartDate" style="margin-left: -20px">实名时间：</label>
                                        <div class="col-sm-3" style="text-align:left;">
                                            <div class="input-daterange input-group" id="datepicker2">
                                                <input type="text" class="input-sm form-control" name="start" id="authStartDate" value="" />
                                                <span class="input-group-addon">到</span>
                                                <input type="text" class="input-sm form-control" name="end" id ="authEndDate" value="" />
                                            </div>
                                        </div>
                                        <div class="col-sm-2" style="text-align:left;">
                                            <button type="button" style="margin-left:50px;" id="search" class="btn btn-primary">查询</button>
                                            <button type="button" style="margin-left:10px" id="export" class="btn btn-primary">导出</button>
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
                        <table id="currencyTable" data-height="400" data-mobile-responsive="true">
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
    (function ($) {

        totalInfo();

        $("#datepicker").datepicker({
            keyboardNavigation:!1,
            forceParse:!1,
            autoclose:!0
        });

        $("#datepicker2").datepicker({
            keyboardNavigation:!1,
            forceParse:!1,
            autoclose:!0
        });


        $("#currencyTable").bootstrapTable({
            method: 'POST',
            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            url: "inviteRecord/list",
            pagination: true,
            showColumns: true,     //是否显示所有的列1
            showRefresh: true,     //是否显示刷新按钮
            sortable: false,      //是否启用排序
            sortOrder: "asc",     //排序方式
            queryParams: queryParams,
            sidePagination: "server",
            clickToSelect: true,
            singleSelect: true,
            toolbar: "#tableToolbar",
            height: 500,
            pageSize : 10, //每页的记录行数（*）
            pageList : [ 10, 25, 50, 100 ], //可供选择的每页的行数（*）
            columns: [{
                checkbox: true
            }, {
                field: 'id',
                title: 'ID',
                width: 50,
                align: 'center'
            }, {
                field: 'customerName',
                title: '邀请人',
                width: 100,
                align: 'center'
            }, {
                field: 'inviteeName',
                title: '被邀请人',
                width: 100,
                align: 'center'
            }, {
                field: 'symbol',
                title: '奖励币种',
                width: 100,
                align: 'center'
            }, {
                field: 'amount',
                title: '奖励数量',
                width: 100,
                align: 'center'
            }, {
                field: 'certification',
                title: '是否实名',
                width: 80,
                align: 'center',
                formatter: function (value, row, index) {
                    if (value == true) {
                        return '<span style="color:green;">是</span>';
                    } else if (value == false) {
                        return '<span style="color:red;">否</span>';
                    }
                }
            }, {
                field: 'certificationTime',
                title: '实名时间',
                width: 80,
                align: 'center'
            }, {
                field: 'registerTime',
                title: '邀请时间',
                width: 80,
                align: 'center'
            }
            ]
        });

        $("#search").on("click", function () {
            refresh();
        });

        $("#export").click(function () {
            var params = {};
            params=queryParams(params);
            window.location.href="invite/record/export?"+
                "customerAccount="+params.customerAccount +
                "&symbol="+params.symbol +
                "&startDate="+params.startDate+
                "&endDate="+params.endDate;
        });

    })(jQuery);

    function refresh() {
        totalInfo();
        $("#currencyTable").bootstrapTable("refresh");
    }

    function totalInfo() {
        var inviteStartDate = $("#inviteStartDate").val();
        var inviteEndDate = $("#inviteEndDate").val();
        var authStartDate = $("#authStartDate").val();
        var authEndDate = $("#authEndDate").val();
        var customerName = $("#customerName").val();
        var customerId = $("#customerId").val();
        var symbol = $("#symbol").val();
        var certification = $("#certification").val();

        $.ajax({
            url: "invite/total",
            dataType: "json",
            data: {inviteStartDate:inviteStartDate,inviteEndDate:inviteEndDate,authStartDate:authStartDate,
                authEndDate:authEndDate,customerName:customerName, customerId:customerId,
                symbol:symbol,certification:certification},
            success: function (data) {
                var totalInfo = eval(data.rows);
                $("#total").empty();
                for (var i=0;i<totalInfo.length;i++)
                {
                    var veh = totalInfo[i];//获取LIST里面的对象
                    $("#total").append('<div class="col-sm-7" style="margin-bottom: 5px"><span>获取币种：'+veh.symbol+'&nbsp;&nbsp;&nbsp;</span><span>奖励数量：'+veh.sumAmount+'</span></div>');
                }
            }
        });
    }

    //查询参数
    function queryParams(params) {
        params.inviteStartDate = $("#inviteStartDate").val();
        params.inviteEndDate = $("#inviteEndDate").val();
        params.authStartDate = $("#authStartDate").val();
        params.authEndDate = $("#authEndDate").val();
        params.customerName = $("#customerName").val();
        params.customerId = $("#customerId").val();
        params.symbol = $("#symbol").val();
        params.certification = $("#certification").val();
        params.limit = params.limit;
        params.offset =params.offset;
        return params;
    }

</script>
</body>
</html>
