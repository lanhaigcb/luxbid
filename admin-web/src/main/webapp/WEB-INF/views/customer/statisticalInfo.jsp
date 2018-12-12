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
                                        <label class="control-label col-xs-1" for="datepicker" style="margin-left: -20px">注册时间：</label>
                                        <div class="col-sm-3" style="text-align:left;">
                                            <div class="input-daterange input-group" id="datepicker">
                                                <input type="text" class="input-sm form-control" name="start" id="startDate" value=""/>
                                                <span class="input-group-addon">到</span>
                                                <input type="text" class="input-sm form-control" name="end" id="endDate"
                                                       value=""/>
                                            </div>
                                        </div>
                                        <label class="control-label col-xs-1" for="channelId" style="margin-left: -20px">渠道：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="channelId" placeholder="">
                                        </div>

                                        <div class="col-sm-2" style="text-align:left;">
                                            <button type="button" style="margin-left:50px" id="search" class="btn btn-primary">查询</button>
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
            if (isFirst) {
                isFirst = false;
                $("#bsTable").bootstrapTable({
                    method: 'POST',
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                    url: "customer/listCustomerStatistics",
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
                    pageSize : 10, //每页的记录行数（*）
                    pageList : [ 10, 25, 50, 100 ], //可供选择的每页的行数（*）
                    columns: [{
                        checkbox: true
                    }, {
                        field: 'channelId',
                        title: '渠道',
                        width: 30,
                        align: 'center'
                    },{
                        field: 'registerNum',
                        title: '注册人数',
                        width: 30,
                        align: 'center'
                    }, {
                        field: 'autonymNum',
                        title: '实名人数',
                        width: 30,
                        align: 'center'
                    }, {
                        field: 'rechargeNum',
                        title: '入金人数',
                        width: 50,
                        align: 'center'
                    }/*, {
                     field: 'sumRechargeAmount',
                     title: '入金总价值(CNY)',
                     width: 30,
                     align: 'center',
                     formatter:function(value,row,index) {
                     var val=Number(value);
                     if (val == 0) {
                     return 0;
                     }else {
                     return val.toFixed(2);
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
            params.startDate = $("#startDate").val();
            params.endDate = $("#endDate").val();
            params.channelId = $("#channelId").val();
            params.pageSize = params.limit;
            params.offset =params.offset;
            return params;
        }

    })(jQuery);

    function refresh() {
        $("#bsTable").bootstrapTable("refresh");
    }




</script>
</body>
</html>
