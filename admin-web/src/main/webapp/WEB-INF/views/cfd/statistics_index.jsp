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
                                        <label class="control-label col-xs-1" for="cfdCurrencyId" style="margin-left: -20px">币种类型：</label>
                                        <div class="col-sm-2">
                                            <select id="cfdCurrencyId" name="cfdCurrencyId" class=" form-control">
                                                <option value="">请选择</option>
                                                <c:forEach items="${cfdCurrencys}" var="currency">
                                                    <option value="${currency.id}">${currency.symbol}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <label class="control-label col-xs-1" for="currentNodeId" style="margin-left: -20px">选择节点：</label>
                                        <div class="col-sm-2">
                                            <select id="currentNodeId" name="currentNodeId" class=" form-control">
                                                <option value="">请选择</option>
                                                <c:forEach items="${nodes}" var="node">
                                                    <option value="${node.id}">${node.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="col-sm-2" style="text-align:left;">
                                        <button type="button" style="margin-left:50px" id="search"
                                                class="btn btn-primary">查询
                                        </button>
                                    </div>
                            </form>
                        </div>
                    </div>

                    <div class="btn-group hidden-xs" id="tableToolbar" role="group">

                    </div>
                    <table id="cfdOrderTable" data-height="400" data-mobile-responsive="true">
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
                $("#cfdOrderTable").bootstrapTable({
                    method: 'POST',
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                    url: "cfd/statistics/list",
                    pagination: true,
                    showColumns: true,     //是否显示所有的列1
                    showRefresh: true,     //是否显示刷新按钮
                    sortable: false,      //是否启用排序
                    sortOrder: "asc",     //排序方式
                    queryParams: queryParams,
                    sidePagination: "server",
                    pageSize: 100, //每页的记录行数（*）
                    pageList: [10, 25, 50, 100], //可供选择的每页的行数（*）
                    clickToSelect: true,
                    singleSelect: true,
                    toolbar: "#tableToolbar",
                    height: 500,
                    columns: [{
                        field: 'symbol',
                        title: '商品名称',
                        width: 50,
                        align: 'center'
                    },{
                        field: 'avgUpPrice',
                        title: '买涨持仓均价',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'avgDownPrice',
                        title: '买跌持仓均价',
                        width: 50,
                        align: 'center'
                    },{
                        field: 'nowPrice',
                        title: '现价',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'upAmount',
                        title: '买涨持仓数量',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'downAmount',
                        title: '买跌持仓数量',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'baseAmount',
                        title: '涨跌数量差',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'upProfitAndLoss',
                        title: '买涨盈亏',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'downProfitAndLoss',
                        title: '买跌盈亏',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'baseProfitAndLoss',
                        title: '盈亏和',
                        width: 50,
                        align: 'center'
                    }
                    ],});
            } else {
                refresh();
            }
        });


        //查询参数
        function queryParams(params) {
            var cfdCurrencyId = $("#cfdCurrencyId").val();
            params.cfdCurrencyId = cfdCurrencyId;
            params.nodeId = $("#currentNodeId").val();
            return params;
        }

    })(jQuery);


    function refresh() {
        $("#cfdOrderTable").bootstrapTable("refresh");
    }


</script>
</body>
</html>
