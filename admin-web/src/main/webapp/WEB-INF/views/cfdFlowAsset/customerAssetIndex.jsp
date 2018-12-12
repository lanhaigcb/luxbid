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
                                        <label class="control-label col-xs-1" for="inviter" style="margin-left: -20px">客户归属：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="inviter" name="inviter"
                                                   placeholder="客户归属">
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
                            </form>
                        </div>
                    </div>
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
                    url: "cfdFlowAsset/customerAssetlist",
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
                    height: 600,
                    columns: [{
                        field: 'customerId',
                        title: '用户ID',
                        width: 50,
                        align: 'center'
                    },{
                        field: 'inviter',
                        title: '代理商',
                        width: 50,
                        align: 'center'
                    },{
                        field: 'availableAmount',
                        title: '可用资产',
                        width: 50,
                        align: 'center'
                    },{
                        field: 'depositAmount',
                        title: '冻结保证金',
                        width: 50,
                        align: 'center',
                    }, {
                        field: 'profitAndLoss',
                        title: '浮盈亏',
                        width: 50,
                        align: 'center'
                    },{
                        field: 'totalAsset',
                        title: '账户权益',
                        width: 50,
                        align: 'center'
                    },{
                        field: 'riskRatio',
                        title: '风险率',
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
            params.inviter = $("#inviter").val();
            params.customerId = $("#customerId").val();
            return params;
        }


        $("#export").click(function () {
            var params = {};
            params = queryParams(params);
            window.location.href = "cfdFlowAsset/customerAssetExport?" +
                "&inviter=" + params.inviter +
                "&customerId=" + params.customerId;
        });

    })(jQuery);


    function refresh() {
        $("#exchangeOrderTable").bootstrapTable("refresh");
    }


</script>
</body>
</html>
