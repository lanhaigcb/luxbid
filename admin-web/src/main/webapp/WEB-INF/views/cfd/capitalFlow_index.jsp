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

                                        <label class="control-label col-xs-1" for="inviterId"
                                               style="margin-left: -20px">代理人ID：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="inviterId" name="inviterId"
                                                   placeholder="代理人ID">
                                        </div>

                                        <label class="control-label col-xs-1" for="mobile" style="margin-left: -20px">手机号：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="mobile" name="mobile"
                                                   placeholder="手机号">
                                        </div>

                                        <label class="control-label col-xs-1" for="email"
                                               style="margin-left: -20px">邮箱：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="email" name="email"
                                                   placeholder="邮箱">
                                        </div>

                                    </div>
                                    <div class="form-group" style="margin-top:15px">

                                        <label class="control-label col-xs-1" for="symbol" style="margin-left: -20px">币种类型：</label>
                                        <div class="col-sm-2">
                                            <select id="symbol" name="symbol" class=" form-control">
                                                <option value="">请选择</option>
                                                <c:forEach items="${currencys}" var="currency">
                                                    <option value="${currency.symbol}">${currency.symbol}</option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <label class="control-label col-xs-1" for="accountLogType"
                                               style="margin-left: -20px">操作类型：</label>
                                        <div class="col-sm-2">
                                            <select id="accountLogType" name="accountLogType" class=" form-control">
                                                <option value="">不限</option>
                                                <option value="CFD_TRANSFER_COIN_TO_CFD">资金划转币币账户转入合约账户</option>
                                                <option value="CFD_TRANSFER_CFD_TO_COIN">资金划转合约账户转入币币账户</option>
                                                <option value="CFD_UNWIND_REPAY">合约平仓返还</option>
                                                <option value="CFD_PENDING_FROZEN">合约交易挂单冻结</option>
                                                <option value="CFD_NODE_PENDING_FROZEN">合约交易挂单冻结节点保证金</option>
                                                <option value="CFD_EX_FEE">合约交易手续费</option>
                                                <option value="CFD_NODE_EX_FEE">合约交易节点收取手续费</option>
                                                <option value="CFD_NODE_UNWIND">合约交易节点强制平仓</option>
                                                <option value="CFD_RATE_OUT">合约交易返佣给用户</option>
                                                <option value="CFD_RATE_IN">合约交易返佣</option>
                                            </select>
                                        </div>

                                        <label class="control-label col-xs-1" for="datepicker"
                                               style="margin-left: -20px">时间：</label>
                                        <div class="col-sm-3" style="text-align:left;">
                                            <div class="input-daterange input-group" id="datepicker">
                                                <input type="text" class="input-sm form-control" name="start"
                                                       id="startDate" value=""/>
                                                <span class="input-group-addon">到</span>
                                                <input type="text" class="input-sm form-control" name="end" id="endDate"
                                                       value=""/>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-sm-2" style="text-align:left;">
                                        <button type="button" style="margin-left:50px" id="search"
                                                class="btn btn-primary">查询
                                        </button><button type="button" style="margin-left:50px" id="refrush"
                                                class="btn btn-primary">重置
                                        </button>
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
                        <div class="btn-group hidden-xs" id="tableToolbar" role="group">

                        </div>
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

        $("#refrush").on("click", function () {
            $("#customerId").val('');
            $("#mobile").val('');
            $("#email").val('');
            $("#accountLogType").val('');
            $("#startDate").val('');
            $("#endDate").val('');
            $("#endDate").val('');
        });

        $("#search").on("click", function () {
            if (isFirst) {
                //isFirst = false; 放弃使用 查询后分页不清零
                $("#exchangeOrderTable").bootstrapTable('destroy');
                $("#exchangeOrderTable").bootstrapTable({
                    method: 'POST',
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                    url: "cfd/capitalFlow/list",
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
                        field: 'id',
                        title: '序号',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'createTime',
                        title: '日期',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'inviterId',
                        title: '代理商Id',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'customerId',
                        title: '用户Id',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'mobile',
                        title: '用户手机号',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'email',
                        title: '用户邮箱',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'realName',
                        title: '用户昵称',
                        width: 50,
                        align: 'center'
                    },
                        {
                            field: 'accountLogTypeName',
                            title: '操作类型',
                            width: 50,
                            align: 'center',
                           /* formatter: function (value, row, index) {



                                if (row.accountLogType == 'CFD_TRANSFER_COIN_TO_CFD') {
                                    return "<font>资金划转币币账户转入合约账户</font>"
                                } else if (row.accountLogType == 'CFD_TRANSFER_CFD_TO_COIN') {
                                    return "<font>资金划转合约账户转入币币账户</font>"
                                } else if (row.accountLogType == 'CFD_UNWIND_REPAY') {
                                    return "<font>合约平仓返还</font>"
                                } else if (row.accountLogType == 'CFD_PENDING_FROZEN') {
                                    return "<font>合约交易挂单冻结</font>"
                                } else if (row.accountLogType == 'CFD_NODE_PENDING_FROZEN') {
                                    return "<font>合约交易挂单冻结节点保证金</font>"
                                } else if (row.accountLogType == 'CFD_EX_FEE') {
                                    return "<font>合约交易手续费</font>"
                                } else if (row.accountLogType == 'CFD_NODE_EX_FEE') {
                                    return "<font>合约交易节点收取手续费</font>"
                                } else if (row.accountLogType == 'CFD_NODE_UNWIND') {
                                    return "<font>合约交易节点强制平仓</font>"
                                } else if (row.accountLogType == 'CFD_RATE_OUT') {
                                    return "<font>合约交易返佣给用户</font>"
                                } else if (row.accountLogType == 'CFD_RATE_IN') {
                                    return "<font>合约交易返佣</font>"
                                }
                            }*/
                        }, {
                            field: 'operateAmount',
                            title: '变动资金',
                            width: 50,
                            align: 'center'
                        }, {
                            field: 'availableAmount',
                            title: '变后资金',
                            width: 50,
                            align: 'center'
                        }, {
                            field: 'symbol',
                            title: '币种',
                            width: 50,
                            align: 'center'
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
            params.inviterId = $("#inviterId").val();
            params.mobile = $("#mobile").val();
            params.email = $("#email").val();
            params.accountLogType = $("#accountLogType").val();
            params.start = $("#startDate").val();
            params.end = $("#endDate").val();
            params.symbol = $("#symbol").val();
            return params;
        }


        $("#export").click(function () {
            var params = {};
            params = queryParams(params);
            window.location.href = "cfd/unwind/export?" +
                "customerId=" + params.customerId +
                "&mobile=" + params.mobile +
                "&email=" + params.email +
                "&cfdApplyType=" + params.cfdApplyType +
                "&start=" + params.start +
                "&end=" + params.end +
                "&remark=" + params.remark +
                "&noedId=" + params.nodeId;
        });

    })(jQuery);


    function refresh() {
        $("#exchangeOrderTable").bootstrapTable("refresh");
    }


</script>
</body>
</html>
