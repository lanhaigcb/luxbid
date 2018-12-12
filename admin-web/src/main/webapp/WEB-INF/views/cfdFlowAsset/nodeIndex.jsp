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
                                        <label class="control-label col-xs-1" for="mobile" style="margin-left: -20px">手机号：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="mobile" name="mobile"
                                                   placeholder="手机号">
                                        </div>
                                        <label class="control-label col-xs-1" for="email" style="margin-left: -20px">邮箱：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="email" name="email"
                                                   placeholder="邮箱">
                                        </div>

                                        <label class="control-label col-xs-1" for="nodeId" style="margin-left: -20px">选择节点：</label>
                                        <div class="col-sm-2">
                                            <select id="nodeId" name="nodeId" class=" form-control">
                                                <option value="">请选择</option>
                                                <c:forEach items="${nodes}" var="node">
                                                    <option value="${node.id}">${node.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>


                                    </div>
                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-xs-1" for="datepicker" style="margin-left: -20px">时间：</label>
                                        <div class="col-sm-3" style="text-align:left;">
                                            <div class="input-daterange input-group" id="datepicker">
                                                <input type="text" class="input-sm form-control" name="beginTime" id="beginTime" value="" />
                                                <span class="input-group-addon">到</span>
                                                <input type="text" class="input-sm form-control" name="endTime" id ="endTime" value="" />
                                            </div>
                                        </div>
                                        <label class="control-label col-xs-1" for="datepicker" style="margin-left: -20px">操作类型：</label>
                                        <div class="col-sm-2">
                                            <select id="remark" name="remark" class=" form-control">
                                                <option value="">请选择</option>
                                                <option value="CFD_TRANSFER_COIN_TO_CFD">入金</option>
                                                <option value="CFD_TRANSFER_CFD_TO_COIN">出金</option>
                                            </select>
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
                    url: "cfdFlowAsset/nodeFlowAssetlist",
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
                        field: 'mobile',
                        title: '手机号',
                        width: 50,
                        align: 'center'
                    },{
                        field: 'email',
                        title: '邮箱',
                        width: 50,
                        align: 'center'
                    },{
                        field: 'enter',
                        title: '入金',
                        width: 50,
                        align: 'center',
                        formatter: function (value, row, index) {
                            if(row.accountLogType=='CFD_TRANSFER_COIN_TO_CFD'){
                                return row.operateAmount
                            } else {
                                return 0
                            }
                        }
                    },{
                        field: 'out',
                        title: '出金',
                        width: 50,
                        align: 'center',
                        formatter: function (value, row, index) {
                            if(row.accountLogType=='CFD_TRANSFER_CFD_TO_COIN'){
                                return row.operateAmount
                            } else {
                                return 0
                            }
                        }
                    },/*{
                        field: 'beginAmount',
                        title: '起始金额',
                        width: 50,
                        align: 'center'
                    },*/ {
                        field: 'operateAmount',
                        title: '变动金额',
                        width: 50,
                        align: 'center'
                    },{
                        field: 'availableAmount',
                        title: '变动后金额',
                        width: 50,
                        align: 'center'
                    },{
                        field: 'createTime',
                        title: '日期',
                        width: 50,
                        align: 'center'
                    }/*,{
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
                    }*/
                    ]
                });
            } else {
                refresh();
            }
        });


        //查询参数
        function queryParams(params) {
            params.mobile = $("#mobile").val();
            params.beginTime = $("#beginTime").val();
            params.endTime = $("#endTime").val();
            params.accountLogType = $("#remark").val();
            params.nodeId = $("#nodeId").val();
            params.email = $("#email").val();
            return params;
        }


        $("#export").click(function () {
            var params = {};
            params = queryParams(params);
            window.location.href = "cfdFlowAsset/nodeExport?" +
                "mobile=" + params.mobile +
                "&beginTime=" + params.beginTime +
                "&endTime=" + params.endTime +
                "&email=" + params.email +
                "&nodeId=" + params.nodeId +
                "&accountLogType=" + params.accountLogType ;
        });

    })(jQuery);


    function refresh() {
        $("#exchangeOrderTable").bootstrapTable("refresh");
    }


</script>
</body>
</html>
