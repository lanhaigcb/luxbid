<%@ page import="com.mine.common.enums.C2CExOrderStatus" %>
<%@ page import="com.mine.common.enums.ExOrderType" %>
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
                                        <label class="control-label col-xs-1" for="customerId"
                                               style="margin-left: -20px">用户ID：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="customerId" name="customerId"
                                                   placeholder="用户ID">
                                        </div>
                                        <label class="control-label col-xs-1" for="account" style="margin-left: -20px">帐号：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="account" name="account"
                                                   placeholder="手机号或邮箱">
                                        </div>

                                        <label class="control-label col-xs-1" for="status" style="margin-left: -20px">状态：</label>
                                        <div class="col-sm-2">
                                            <select id="status" name="status" class=" form-control">
                                                <option value="">请选择</option>
                                                <c:forEach var="v" items="<%=C2CExOrderStatus.values()%>">
                                                    <option value="${v.name()}">${v.toString()}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-xs-1" for="orderNumber"
                                               style="margin-left: -20px">订单号：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="orderNumber" name="orderNumber"
                                                   placeholder="订单号">
                                        </div>
                                        <label class="control-label col-xs-1" for="operator" style="margin-left: -20px">操作人：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="operator" name="operator"
                                                   placeholder="操作人">
                                        </div>

                                        <label class="control-label col-xs-1" for="type"
                                               style="margin-left: -20px">类型：</label>
                                        <div class="col-sm-2">
                                            <select id="type" name="type" class=" form-control">
                                                <option value="">请选择</option>
                                                <c:forEach var="v" items="<%=ExOrderType.values()%>">
                                                    <option value="${v.name()}">${v.toString()}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-xs-1" style="margin-left: -20px">分钟数：</label>
                                        <div class="col-sm-3" style="text-align:left;">
                                            <div class="input-daterange input-group">
                                                <input type="text" onkeyup="value=value.replace(/[^\d]/g,'')" placeholder="请输入数字" class="input-sm form-control" name="startMinute" id="startMinute" value="" />
                                                <span class="input-group-addon">到</span>
                                                <input type="text" onkeyup="value=value.replace(/[^\d]/g,'')" placeholder="请输入数字" class="input-sm form-control" name="endMinute" id ="endMinute" value="" />
                                            </div>
                                        </div>

                                        <label class="control-label col-xs-1" for="symbol"
                                               style="margin-left: -20px">币种：</label>
                                        <div class="col-sm-2">
                                            <select id="symbol" name="symbol" class=" form-control">
                                                <option value="">请选择</option>
                                                <c:forEach var="v" items="${currencys}">
                                                    <option value="${v.symbol}">${v.symbol}</option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                    </div>
                                    <%--<div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-xs-1" for="channelId" style="margin-left: -20px">渠道：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="channelId" name="channelId" placeholder="渠道号">
                                        </div>
                                        <label class="control-label col-xs-1" for="buy" style="margin-left: -20px">买卖：</label>


                                    </div>
                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-xs-1" for="datepicker" style="margin-left: -20px">创建时间：</label>
                                        <div class="col-sm-3" style="text-align:left;">
                                            <div class="input-daterange input-group" id="datepicker">
                                                <input type="text" class="input-sm form-control" name="start" id="startDate" value="" />
                                                <span class="input-group-addon">到</span>
                                                <input type="text" class="input-sm form-control" name="end" id ="endDate" value="" />
                                            </div>
                                        </div>--%>
                                    <div class="col-sm-2" style="text-align:left;">
                                        <button type="button" style="margin-left:50px" id="search"
                                                class="btn btn-primary">查询
                                        </button>
                                        <%--<button type="button" style="margin-left:10px" id="export" class="btn btn-primary">导出</button>--%>
                                    </div>
                            </div>
                            </form>
                        </div>
                    </div>
                    <%--<table class="table table-bordered">
                        <thead>
                        <tr>
                            <th>统计信息</th>
                        </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td width="200px">&nbsp;&nbsp;成交总价值：<span id="totalAmountCNY"></span></td>
                            </tr>
                        </tbody>
                    </table>--%>
                    <table id="exchangeOrderTable" data-height="400" data-mobile-responsive="true">
                    </table>
                </div>
            </div>
        </div>
    </div>
    <!-- End Panel Other -->
</div>
</div>
<script type="text/javascript" charset="UTF-8">
    var isFirst = true;
    (function ($) {

        $("#datepicker").datepicker({
            keyboardNavigation: !1,
            forceParse: !1,
            autoclose: !0
        });

        $("#search").on("click", function () {
            if (isFirst) {
                isFirst = false;
                $("#exchangeOrderTable").bootstrapTable({
                    method: 'POST',
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                    url: "c2cOrder/list",
                    pagination: true,
                    showColumns: true,     //是否显示所有的列1
                    showRefresh: true,     //是否显示刷新按钮
                    sortable: false,      //是否启用排序
                    sortOrder: "asc",     //排序方式
                    queryParams: queryParams,
                    sidePagination: "server",
                    pageSize: 10, //每页的记录行数（*）
                    pageList: [10, 25, 50, 100], //可供选择的每页的行数（*）
                    clickToSelect: true,
                    singleSelect: true,
                    toolbar: "#tableToolbar",
                    height: 500,
                    columns: [{
                        checkbox: true
                    }, {
                        field: 'id',
                        title: 'ID',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'createTime',
                        title: '创建时间',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'minute',
                        title: '分钟数',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'orderNumber',
                        title: '订单号',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'customerId',
                        title: '用户ID',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'realName',
                        title: '姓名',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'account',
                        title: '帐号',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'type',
                        title: '类型',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'symbol',
                        title: '币种',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'count',
                        title: '数量',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'amount',
                        title: '总额',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'status',
                        title: '订单状态',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'operator',
                        title: '操作人',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'operatorTime',
                        title: '操作时间',
                        width: 50,
                        align: 'center'
                    }, {
                        title: '操作',
                        width: 50,
                        align: 'center',
                        formatter: function (value, row, index) {
                            var html = "";
                            if (row.status == "交易中" || row.status == "待审核卖单" || row.status == "待打款卖单" || row.status=="已转账") {
                                html += "<input type='button' class='btn btn-primary' onclick='done(" + row.id + ")'  value='确认'>";
                                html += "<input type='button' class='btn btn-primary' onclick='cancel(" + row.id + ")' value='取消'>";
                            }
                            return html;
                        }
                    }
                    ]
                });
            } else {
                refresh();
            }
        });


        //查询参数
        function queryParams(params) {
            params.customerId = $("#customerId").val();
            params.account = $("#account").val();
            params.status = $("#status").val();
            params.type = $("#type").val();
            params.orderNumber = $("#orderNumber").val();
            params.operator = $("#operator").val();
            params.startMinute = $("#startMinute").val();
            params.endMinute = $("#endMinute").val();
            params.symbol = $("#symbol").val();
            // params.endDate = $("#endDate").val();
            // params.pageSize = params.limit;
            // params.page =params.offset;
            //getTotalAmountCNY();
            return params;
        }


    })(jQuery);

    function cancel(id) {
        // layer.confirm('确认操作吗？', {
        //     btn: ['确认','取消'] //按钮
        // }, function(){
        //     $.ajax({
        //         type: "POST",
        //         url: "c2cOrder/cancel",
        //         data: {id: id},
        //         dataType: "json",
        //         success: function (data) {
        //             layer.msg("操作成功");
        //             refresh();
        //         }
        //     });
        // }, function(){
        //     layer.msg("取消操作");
        // });

        layer.open({
            type: 2,
            title: '操作',
            shadeClose: true,
            shade: 0.8,
            area: ['600px', '200px'],
            content: 'c2cOrder/op?id='+id+'&type=cancel'
        });
    }

    function done(id) {
        // layer.confirm('确认操作吗？', {
        //     btn: ['确认','取消'] //按钮
        // }, function(){
        //     $.ajax({
        //         type: "POST",
        //         url: "c2cOrder/done",
        //         data: {id: id},
        //         dataType: "json",
        //         success: function (data) {
        //             layer.msg("操作成功");
        //             refresh();
        //         }
        //     });
        // }, function(){
        //     layer.msg("取消操作");
        // });
        layer.open({
            type: 2,
            title: '操作',
            shadeClose: true,
            shade: 0.8,
            area: ['600px', '200px'],
            content: 'c2cOrder/op?id='+id+'&type=done'
        });

    }

    function code(){

        layer.open({
            type: 2,
            title: '操作',
            shadeClose: true,
            shade: 0.8,
            area: ['30%', '30%'],
            content: 'c2cOrder/op'
        });
    }

    function refresh() {
        $("#exchangeOrderTable").bootstrapTable("refresh");
    }
</script>
</body>
</html>
