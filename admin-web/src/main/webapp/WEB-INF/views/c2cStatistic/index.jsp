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
                                        <label class="control-label col-xs-1" for="datepicker" style="margin-left: -20px">创建时间：</label>
                                        <div class="col-sm-3" style="text-align:left;">
                                            <div class="input-daterange input-group" id="datepicker">
                                                <input type="text" class="input-sm form-control" name="startTime" id="startTime" value="" />
                                                <span class="input-group-addon">到</span>
                                                <input type="text" class="input-sm form-control" name="endTime" id ="endTime" value="" />
                                            </div>
                                        </div>
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
                    url: "c2cStatistic/list",
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
                        field: 'symbol',
                        title: '币种',
                        width: 50,
                        align: 'center'
                    },{
                        field: 'sellCount',
                        title: '发行总量',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'sellAmount',
                        title: '发行总价值',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'tradeRecoveryCount',
                        title: '法币交易回收',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'tradeRecoveryAmount',
                        title: '法币交易回收价值',
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

            params.startTime = $("#startTime").val();
            params.endTime = $("#endTime").val();

            return params;
        }


    })(jQuery);


    function refresh() {
        $("#exchangeOrderTable").bootstrapTable("refresh");
    }
</script>
</body>
</html>
