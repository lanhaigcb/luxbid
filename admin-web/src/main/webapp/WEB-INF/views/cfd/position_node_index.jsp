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
                                   <%--     <label class="control-label col-xs-1" for="customerId"
                                               style="margin-left: -20px">用户ID：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="customerId" name="customerId"
                                                   placeholder="用户ID">
                                        </div>--%>
                                        <label class="control-label col-xs-1" for="currentNodeId" style="margin-left: -20px">选择节点：</label>
                                        <div class="col-sm-2">
                                            <select id="currentNodeId" name="currentNodeId" class=" form-control">
                                                <option value="">请选择</option>
                                                <c:forEach items="${nodes}" var="node">
                                                <option value="${node.id}">${node.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <label class="control-label col-xs-1" for="cfdApplyType" style="margin-left: -20px">类型：</label>
                                        <div class="col-sm-2">
                                            <select id="cfdApplyType" name="cfdApplyType" class=" form-control">
                                                <option value="">请选择</option>
                                                <option value="RISE">买涨</option>
                                                <option value="FALL">买跌</option>
                                            </select>
                                        </div>
                                        <label class="control-label col-xs-1" for="cfdCurrencyId" style="margin-left: -20px">合约产品：</label>
                                        <div class="col-sm-2">
                                            <select id="cfdCurrencyId" name="cfdCurrencyId" class=" form-control">
                                                <option value="">请选择</option>
                                                <c:forEach items="${cfdCurrencys}" var="currency">
                                                    <option value="${currency.id}">${currency.symbol}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" style="margin-top:15px">


                                        <label class="control-label col-xs-1" for="datepicker" style="margin-left: -20px">创建时间：</label>
                                        <div class="col-sm-3" style="text-align:left;">
                                            <div class="input-daterange input-group" id="datepicker">
                                                <input type="text" class="input-sm form-control" name="start" id="startDate" value="" />
                                                <span class="input-group-addon">到</span>
                                                <input type="text" class="input-sm form-control" name="end" id ="endDate" value="" />
                                            </div>
                                        </div>

                                    <%--    <label class="control-label col-xs-1" for="datepickers" style="margin-left: -20px">价格：</label>
                                        <div class="col-sm-3" style="text-align:left;">
                                            <div class="input-daterange input-group" id="datepickers" >
                                                <input type="text" class="input-sm form-control" name="min" id="min" value="" />
                                                <span class="input-group-addon">到</span>
                                                <input type="text" class="input-sm form-control" name="max" id ="max" value="" />
                                            </div>
                                        </div>--%>
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

        $("#search").on("click", function () {
            if (isFirst) {
                //isFirst = false; 放弃使用 查询后分页不清零
                $("#exchangeOrderTable").bootstrapTable('destroy');
                $("#exchangeOrderTable").bootstrapTable({
                    method: 'POST',
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                    url: "cfd/position/nodeList",
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
                    },{
                        field: 'createTime',
                        title: '创建时间',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'customerId',
                        title: '用户ID',
                        width: 50,
                        align: 'center'
                    }
                    ,{
                        field: 'mobile',
                        title: '手机号',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'email',
                        title: '邮箱',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'cfdApplyType',
                        title: '类型',
                        width: 50,
                        align: 'center',
                        formatter: function (value, row, index) {
                            if(row.cfdApplyType=='RISE'){
                                return "<font color='green'>买涨</font>"
                            } else {
                                return "<font color='red'>买跌</font>"
                            }
                        }
                    }, {
                        field: 'leveraged',
                        title: '杠杆比例',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'cfdCurrency',
                        title: '币种',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'symbolPrice',
                        title: '下单时币价',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'positionPrice',
                        title: '建仓价',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'amount',
                        title: '数量',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'stopLose',
                        title: '止损',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'stopProfit',
                        title: '止盈',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'interest',
                        title: '持仓利息',
                        width: 50,
                        align: 'center'
                    }
                        , {
                            field: 'fee',
                            title: '手续费',
                            width: 50,
                            align: 'center'
                        }

                    , {
                        field: 'profitAndLoss',
                        title: '浮盈亏',
                        width: 50,
                        align: 'center'

                    }, {
                        title: '操作',
                        width: 50,
                        align: 'center',
                        formatter: function (value, row, index) {
                            var html = "";
                            // if(row.enable==true){
                            //     html += "<input type='button' class='btn btn-danger' onclick='change(" + row.customerId + ",false)'  value='冻结' />&nbsp;";
                            // }
                            // if(row.enable==false){
                            //     html += "<input type='button' class='btn btn-success' onclick='change(" + row.customerId + ",true)'  value='启用' />&nbsp;";
                            // }
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
            /*params.customerId = $("#customerId").val();*/
            params.mobile = $("#mobile").val();
            params.email = $("#email").val();
            params.cfdApplyType = $("#cfdApplyType").val();
            params.start = $("#startDate").val();
            params.end = $("#endDate").val();
          /*  params.min = $("#min").val();
            params.max = $("#max").val();*/
            params.nodeId = $("#currentNodeId").val();
            params.cfdCurrencyId = $("#cfdCurrencyId").val();
            return params;
        }

        $("#export").click(function () {
            var params = {};
            params = queryParams(params);
            window.location.href = "cfd/position/exportNode?" +
                /*"customerId=" + params.customerId +*/
               /* "&mobile=" + params.mobile +*/
              /*  "&email=" + params.email +*/
                "&cfdApplyType=" + params.cfdApplyType +
                "&start=" + params.start +
                "&end=" + params.end +
            /*    "&min=" + params.min +
                "&max=" + params.max +*/
                "&noedId=" + params.nodeId +
                "&cfdCurrencyId=" + params.cfdCurrencyId;
        });

    })(jQuery);


    function refresh() {
        $("#exchangeOrderTable").bootstrapTable("refresh");
    }


</script>
</body>
</html>
