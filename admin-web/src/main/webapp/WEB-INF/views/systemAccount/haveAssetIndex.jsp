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
        $("#search").on("click", function () {
            var symbol = $("#symbol").val();
            if (symbol.trim() == "") {
                layer.msg("请选择币种");
                return false;
            }
            if (isFirst) {
                isFirst = false;
                $("#bsTable").bootstrapTable({
                    method: 'POST',
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                    url: "systemAccount/haveAssetList",
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
                        field: 'id',
                        title: 'ID',
                        width: 30,
                        align: 'center'
                    }, {
                        field: 'account',
                        title: '账号',
                        width: 30,
                        align: 'center'
                    }, {
                        field: 'symbol',
                        title: '币种',
                        width: 30,
                        align: 'center'
                    }, {
                        field: 'frozenAmount',
                        title: '冻结资产',
                        width: 30,
                        align: 'center',
                        formatter: function (value, row, index) {
                            if (value == 0) {
                                return 0;
                            } else {
                                return value;
                            }
                        }
                    }, {
                        field: 'availableAmount',
                        title: '流动资产',
                        width: 50,
                        align: 'center',
                        formatter: function (value, row, index) {
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
            params.symbol = $("#symbol").val();
            params.pageSize = params.limit;
            params.offset = params.offset;
            return params;
        }

        $("#export").click(function () {
            var symbol = $("#symbol").val();
            if (symbol.trim() == "") {
                layer.msg("请选择币种");
                return false;
            }
            var params = {};
            params = queryParams(params);
            window.location.href = "systemAccount/haveAssetListExport?" +
                "symbol=" + params.symbol;
        });

    })(jQuery);

    function refresh() {
        $("#bsTable").bootstrapTable("refresh");
    }


</script>
</body>
</html>
