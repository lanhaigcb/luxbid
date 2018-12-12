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
                                        <div class="col-sm-2">
                                            <select class="form-control show-tick"  id="priceDate" name="priceDate">
                                                <option value="" >请选择</option>
                                                <c:forEach items="${robotConfigVos}" var="robotConfigVos">
                                                    <option value="${robotConfigVos.priceDate}">${robotConfigVos.priceDate}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-sm-2" style="text-align:left;">
                                            <button type="button" style="margin-left:10px" id="search" class="btn btn-primary">查询</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
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
                url:"robotConfig/robotProfitTotalList",
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
                    title: '币种符号',
                    width:200,
                    align:'center'
                }, {
                    field: 'unitPrice',
                    title: '初始单价',
                    width:200,
                    align:'center'
                }, {
                    field: 'number',
                    title: '初始数量',
                    width:200,
                    align:'center'
                }, {
                    field: 'amount',
                    title: '初始金额',
                    width:200,
                    align:'center'
                }, {
                    field: 'nowUnitPrice',
                    title: '当前单价',
                    width:200,
                    align:'center'
                }, {
                    field: 'nowNumber',
                    title: '当前数量',
                    width:200,
                    align:'center'
                }, {
                    field: 'nowAmount',
                    title: '当前金额',
                    width:200,
                    align:'center'
                }, {
                    field: 'symbolProfit',
                    title: '币种盈亏量',
                    width:200,
                    align:'center'
                }, {
                    field: 'initProfit',
                    title: '初始价计盈亏',
                    width:200,
                    align:'center'
                }, {
                    field: 'nowProfit',
                    title: '当前价计盈亏',
                    width:200,
                    align:'center'
                }, {
                    field: 'naturalProfit',
                    title: '自然盈亏',
                    width:200,
                    align:'center'
                }, {
                    field: 'profit',
                    title: '净盈亏',
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
            totalInfo();
            $("#convertRecordTable").bootstrapTable("refresh");
        }

        function totalInfo() {
            var priceDate = $("#priceDate").val();
            $.ajax({
                url: "robotConfig/robotProfitTotalInfo",
                dataType: "json",
                data: {priceDate:priceDate},
                success: function (data) {
                    var totalInfo = eval(data.rows);
                    $("#total").empty();
                    for (var i=0;i<totalInfo.length;i++)
                    {
                        var veh = totalInfo[i];//获取LIST里面的对象
                        $("#total").append('<div class="col-sm-7" style="margin-bottom: 5px"><span>初始金额总计：'+veh.initAmountTotal+'</span></div>');
                        $("#total").append('<div class="col-sm-7" style="margin-bottom: 5px"><span>当前金额总计：'+veh.nowAmountTotal+'</span></div>');
                        $("#total").append('<div class="col-sm-7" style="margin-bottom: 5px"><span>初始价计盈亏总计：'+veh.initProfitTotal+'&nbsp;&nbsp;&nbsp;</span><span>百分比：'+veh.initProfitTotalP+'%</span></div>');
                        $("#total").append('<div class="col-sm-7" style="margin-bottom: 5px"><span>当前价计盈亏总计：'+veh.nowProfitTotal+'&nbsp;&nbsp;&nbsp;</span><span>百分比：'+veh.nowProfitTotalP+'%</span></div>');
                        $("#total").append('<div class="col-sm-7" style="margin-bottom: 5px"><span>自然盈亏总计：'+veh.naturalProfitTotal+'&nbsp;&nbsp;&nbsp;</span><span>百分比：'+veh.naturalProfitTotalP+'%</span></div>');
                        $("#total").append('<div class="col-sm-7" style="margin-bottom: 5px"><span>净盈亏总计：'+veh.profitTotal+'&nbsp;&nbsp;&nbsp;</span><span>百分比：'+veh.profitTotalP+'%</span></div>');
                    }
                }
            });
        }

        //查询参数
        function queryParams(params) {
            params.priceDate = $("#priceDate").val();
            return params;
        }

    </script>
</body>
</html>
