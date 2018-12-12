<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<%@include file="../common/head-title.jsp" %>
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
                                        <label class="control-label col-xs-1" for="customerId" style="margin-left: -20px">用户ID：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="customerId" name="customerId"
                                                   placeholder="用户ID">
                                        </div>
                                        <label class="control-label col-xs-1" for="symbol" style="margin-left: -20px">币种：</label>
                                        <div class="col-sm-2">
                                            <select id="symbol" name="symbol" class=" form-control">
                                                <option value="">请选择</option>
                                                <c:forEach items="${voList}" var="v">
                                                    <option value="${v.symbol}">${v.symbol}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <label class="control-label col-xs-1" for="fromAddress" style="margin-left: -20px">发送地址：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="fromAddress" name="fromAddress"
                                                   placeholder="发送地址">
                                        </div>
                                        <label class="control-label col-xs-1" for="address" style="margin-left: -20px">接收地址：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="address" name="address"
                                                   placeholder="发送地址">
                                        </div>
                                    </div>
                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-xs-1" for="transId" style="margin-left: -20px">交易ID：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="transId" name="transId"
                                                   placeholder="交易ID">
                                        </div>
                                        <label class="control-label col-xs-1" for="datepicker"
                                               style="margin-left: -20px">创建时间：</label>
                                        <div class="col-sm-3" style="text-align:left;">
                                            <div class="input-daterange input-group" id="datepicker">
                                                <input type="text" class="input-sm form-control" name="start"
                                                       id="startDate" value=""/>
                                                <span class="input-group-addon">到</span>
                                                <input type="text" class="input-sm form-control" name="end" id="endDate"
                                                       value=""/>
                                            </div>
                                        </div>
                                        <div class="col-sm-2" style="text-align:left;">
                                            <button type="button" style="margin-left:50px" id="search"
                                                    class="btn btn-primary">查询
                                            </button>
                                            <button type="button" style="margin-left:10px" id="export"
                                                    class="btn btn-primary">导出
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <table id="rechargeRecordTable" data-height="400" data-mobile-responsive="true">
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <!-- End Panel Other -->
    </div>
</div>
<script type="text/javascript" charset="UTF-8">
    (function ($) {

        $("#datepicker").datepicker({
            keyboardNavigation: !1,
            forceParse: !1,
            autoclose: !0
        });

        $("#rechargeRecordTable").bootstrapTable({
            method: 'POST',
            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            url: "recharge/list",
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
            pageSize: 10, //每页的记录行数（*）
            pageList: [10, 25, 50, 100], //可供选择的每页的行数（*）
            columns: [{
                checkbox: true
            }, {
                field: 'id',
                title: 'ID',
                width: 30,
                align: 'center'
            }, {
                field: 'symbol',
                title: '币种',
                width: 30,
                align: 'center'
            }, {
                field: 'customerId',
                title: '用户ID',
                width: 30,
                align: 'center'
            }, {
                field: 'amount',
                title: '金额',
                width: 30,
                align: 'center'
            }, {
                field: 'fromAddress',
                title: '发送地址',
                width: 100,
                align: 'center',
                formatter: function (value, row, index) {
                    return '<input type="text" class="form-control" style="overflow: hidden;width: 300px;cursor: text" readonly value="' + value + '">';
                }
            }, {
                field: 'address',
                title: '接收地址',
                width: 100,
                align: 'center',
                formatter: function (value, row, index) {
                    return '<input type="text" class="form-control" style="overflow: hidden;width: 300px;cursor: text" readonly value="' + value + '">';
                }
            }, {
                field: 'transId',
                title: '交易ID',
                width: 100,
                align: 'center',
                formatter: function (value, row, index) {
                    return '<input type="text" class="form-control" style="overflow: hidden;width: 300px;cursor: text" readonly value="' + value + '">';
                }
            }, {
                field: 'rechargeStatus',
                title: '充值状态',
                width: 10,
                align: 'center',
                formatter: function (value, row, index) {
                    if (value.key == 'SUCCESS') {
                        return '<span style="color:green">' + value.value + '</span>';
                    } else {
                        return '<span style="color:orange">' + value.value + '</span>'
                    }
                }
            }, {
                field: 'createTime',
                title: '创建时间',
                width: 100,
                align: 'center'
            }
            ]
        });

        //查询参数
        function queryParams(params) {
            params.startDate = $("#startDate").val();
            params.endDate = $("#endDate").val();
            params.customerId = $("#customerId").val();
            params.symbol = $("#symbol").val();
            params.fromAddress = $("#fromAddress").val();
            params.address = $("#address").val();
            params.transId = $("#transId").val();
            params.pageSize = params.limit;
            params.offset = params.offset;
            return params;
        }

        $("#search").on("click", function () {
            refresh()
        });

        $("#export").click(function () {
            var params = {};
            params = queryParams(params);
            window.location.href = "recharge/export?" +
                "startDate=" + params.startDate +
                "&endDate=" + params.endDate +
                "&customerId=" + params.customerId +
                "&symbol=" + params.symbol;
        });
    })(jQuery);

    function refresh() {
        $("#rechargeRecordTable").bootstrapTable("refresh");
    }

</script>
</body>
</html>
