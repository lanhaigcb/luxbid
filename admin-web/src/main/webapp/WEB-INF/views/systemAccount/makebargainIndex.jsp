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
                                        <label class="control-label col-xs-1" for="startDate"
                                               style="margin-left: -20px;margin-top: 10px">时间：</label>
                                        <div class="col-sm-3" style="text-align:left;margin-top: 10px">
                                            <div class="input-daterange input-group" id="datepicker">
                                                <input type="text" class="input-sm form-control" name="startDate"
                                                       id="startDate" value=""/>
                                                <span class="input-group-addon">到</span>
                                                <input type="text" class="input-sm form-control"
                                                       name="endDate" id="endDate" value=""/>
                                            </div>
                                        </div>
                                        <label class="control-label col-xs-1" for="symbol" style="margin-left: -20px">交易对：</label>
                                        <div class="col-sm-2">
                                            <select id="symbol" name="symbol" class=" form-control">
                                                <option value="">请选择</option>
                                                <c:forEach items="${voList}" var="v">
                                                    <option value="${v.symbol}">${v.symbol}</option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="col-sm-2" style="text-align:left;">
                                            <button type="button" style="margin-left:50px" id="search"
                                                    class="btn btn-primary">查询
                                            </button>
                                            <button type="button" style="margin-left:10px" id="export"
                                                    class="btn btn-primary">导出
                                            </button>
                                            <input type="hidden" id="totalCNY" value="0">
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <table class="table table-bordered">
                            <thead>
                            <tr>
                                <th>统计信息</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td width="200px">&nbsp;&nbsp;当前页成交总额：<span id="sumAmountCNY"></span></td>
                            </tr>
                            </tbody>
                        </table>
                        <table id="bsTable" data-height="400" data-mobile-responsive="true">
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
            var startDate = $("#startDate").val();
            var endDate = $("#endDate").val();
            if (startDate.trim() == "" || endDate.trim() == "") {
                layer.msg("请输入时间段查询");
                return false;
            }
            $("#totalCNY").val(0)
            $("#sumAmountCNY").html("");
            if (isFirst) {
                isFirst = false;
                $("#bsTable").bootstrapTable({
                    method: 'POST',
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                    url: "systemAccount/makebargainlist",
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
                    pageList: [10, 25, 50, 100, 200, 500], //可供选择的每页的行数（*）
                    columns: [{
                        checkbox: true
                    }, {
                        field: 'symbol',
                        title: '交易对',
                        width: 30,
                        align: 'center'
                    }, {
                        field: 'sumAmountStr',
                        title: '成交量',
                        width: 50,
                        align: 'center',
                        formatter: function (value, row, index) {
                            if (value == 0) {
                                return 0;
                            } else {
                                return value;
                            }
                        }
                    }, {
                        field: 'sumAmountCNY',
                        title: '成交总额(CNY)',
                        width: 30,
                        align: 'center',
                        formatter: function (value, row, index) {
                            var val = Number($("#totalCNY").val()) + Number(value);
                            $("#totalCNY").val(val.toFixed(2));
                            $("#sumAmountCNY").html($("#totalCNY").val() + " CNY")
                            if (value == 0) {
                                return 0;
                            } else {
                                return value;
                            }
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
            $("#totalCNY").val(0)
            $("#sumAmountCNY").val("");
            params.symbol = $("#symbol").val();
            params.startDate = $("#startDate").val();
            params.endDate = $("#endDate").val();
            params.pageSize = params.limit;
            params.offset = params.offset;
            return params;
        }

        $("#export").click(function () {
            var params = {};
            params = queryParams(params);
            window.location.href = "systemAccount/makebargainlistExport?" +
                "startDate=" + params.startDate +
                "&endDate=" + params.endDate +
                "&symbol=" + params.symbol;
        });

    })(jQuery);

    function refresh() {
        $("#bsTable").bootstrapTable("refresh");
    }


</script>
</body>
</html>
