<%@ taglib prefix="fn" uri="/func" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="b" %>
<%@include file="../common/taglib.jsp"%>
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
                                        <label class="control-label col-xs-1" for="customerAccount" style="margin-left: -20px">账号：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="customerAccount">
                                        </div>
                                        <label class="control-label col-xs-1" for="senderRealName" style="margin-left: -20px">提交人：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="senderRealName">
                                        </div>
                                        <label class="control-label col-xs-1" for="checkerRealName" style="margin-left: -20px">审核人：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="checkerRealName">
                                        </div>
                                    </div>
                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-xs-1" for="symbol" style="margin-left: -20px">币种：</label>
                                        <div class="col-sm-2">
                                            <select class="form-control show-tick"  id="symbol" name="symbol">
                                                <option value="" >请选择</option>
                                                <c:forEach items="${currencys}" var="currency">
                                                    <option value="${currency.symbol}">${currency.symbol}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <label class="control-label col-xs-1" for="awardStatus" style="margin-left: -20px">状态：</label>
                                        <div class="col-sm-2">
                                            <select class="form-control show-tick"  id="awardStatus" name="awardStatus">
                                                <option value="" >请选择</option>
                                                <option value="PASS">已发放</option>
                                                <option value="NOT_PASS">审核不通过</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-xs-1" for="startdatepicker" style="margin-left: -20px;margin-top: 10px">提交时间：</label>
                                        <div class="col-sm-3" style="text-align:left;margin-top: 10px">
                                            <div class="input-daterange input-group" id="startdatepicker">
                                                <input type="text" class="input-sm form-control" name="start" id="startCreateTime" value=""/>
                                                <span class="input-group-addon">到</span>
                                                <input type="text" class="input-sm form-control" name="end" id="endCreateTime" value=""/>
                                            </div>
                                        </div>
                                        <label class="control-label col-xs-1" for="enddatepicker" style="margin-left: -20px;margin-top: 10px">审核时间：</label>
                                        <div class="col-sm-3" style="text-align:left;margin-top: 10px">
                                            <div class="input-daterange input-group" id="enddatepicker">
                                                <input type="text" class="input-sm form-control" name="start" id="startUpdateTime" value=""/>
                                                <span class="input-group-addon">到</span>
                                                <input type="text" class="input-sm form-control" name="end" id="endUpdateTime" value=""/>
                                            </div>
                                        </div>
                                        <div class="col-sm-2" style="text-align:left;margin-top: 5px">
                                            <button type="button" style="margin-left:50px" id="search" class="btn btn-primary">查询</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <table id="convertTable" data-height="600" data-mobile-responsive="true">
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <!-- End Panel Other -->
    </div>
</div>

<script type="text/javascript" charset="UTF-8">
    var $table = $("#convertTable");
    $table.bootstrapTable({
        method: 'POST',
        contentType:"application/x-www-form-urlencoded; charset=UTF-8",
        url: "awardRecord/list",
        pagination: true,
        showColumns: true,     //是否显示所有的列
        showRefresh: true,     //是否显示刷新按钮
        sortable: false,      //是否启用排序
        sortOrder: "desc",     //排序方式
        queryParams: queryParams,
        sidePagination: "server",
        singleSelect: true,
        clickToSelect: true,
        toolbar: "#convertTableToolbar",
        pageSize : 10, //每页的记录行数（*）
        pageList : [ 10, 25, 50, 100 ], //可供选择的每页的行数（*）
        columns: [{
            checkbox: true
        }, {
            field: 'id',
            width: 100,
            align: 'center',
            title: 'ID'

        }, {
            field: 'customerAccount',
            width: 100,
            align: 'center',
            title: '账号'
        }, {
            field: 'symbol',
            width: 100,
            align: 'center',
            title: '奖励币种'
        }, {
            field: 'awardNum',
            width: 100,
            align: 'center',
            title: '奖励数量'
        }, {
            field: 'awardStatus',
            width: 100,
            align: 'center',
            title: '状态',
            formatter:function(value,row,index) {
                if (value == 'PASS') {
                    return '已发放';
                } else if (value == 'NOT_PASS') {
                    return '审核不通过';
                }else{
                    return '未知状态';
                }
            }
        }, {
            field: 'senderRealName',
            width: 100,
            align: 'center',
            title: '提交人'
        }, {
            field: 'createTime',
            width: 100,
            align: 'center',
            title: '提交时间'
        }, {
            field: 'checkerRealName',
            width: 100,
            align: 'center',
            title: '审核人'
        }, {
            field: 'updateTime',
            width: 100,
            align: 'center',
            title: '审核时间'
        }
        ]
    });

    $("#startdatepicker").datepicker({
        keyboardNavigation: !1,
        forceParse: !1,
        autoclose: !0
    });

    $("#enddatepicker").datepicker({
        keyboardNavigation: !1,
        forceParse: !1,
        autoclose: !0
    });

    //查询参数
    function queryParams(params) {
        params.customerAccount = $("#customerAccount").val();
        params.senderRealName = $("#senderRealName").val();
        params.checkerRealName = $("#checkerRealName").val();
        params.symbol = $("#symbol").val();
        params.awardStatus = $("#awardStatus").val();
        params.startCreateTime = $("#startCreateTime").val();
        params.endCreateTime = $("#endCreateTime").val();
        params.startUpdateTime = $("#startUpdateTime").val();
        params.endUpdateTime = $("#endUpdateTime").val();
        params.limit = params.limit;
        params.offset =params.offset;
        return params;
    }

    $("#search").on("click", function () {
        refresh();
    });

    //刷新
    function refresh() {
        $table.bootstrapTable("refresh");
    }


    //一些事件实例
    var e = $("#examplebtTableEventsResult");
    $table.on("all.bs.table", function (e, t, o) {
        console.log("Event:", t, ", data:", o)
    })
        .on("click-row.bs.table", function () {
            var ids = $("#exampleTableFromData").bootstrapTable("getSelections");
            console.log(ids)
            e.text(ids)
        })
        .on("dbl-click-row.bs.table", function () {
            e.text("Event: dbl-click-row.bs.table")
        })
        .on("sort.bs.table", function () {
            e.text("Event: nihao")
        })
        .on("check.bs.table", function () {
            e.text("Event: check.bs.table")
        })
        .on("uncheck.bs.table", function () {
            e.text("Event: uncheck.bs.table")
        })
        .on("check-all.bs.table", function () {
            e.text("Event: check-all.bs.table")
        })
        .on("uncheck-all.bs.table", function () {
            e.text("Event: uncheck-all.bs.table")
        })
        .on("load-success.bs.table", function () {
            e.text("Event: load-success.bs.table")
        })
        .on("load-error.bs.table", function () {
            e.text("Event: load-error.bs.table")
        })
        .on("column-switch.bs.table", function () {
            e.text("Event: column-switch.bs.table")
        })
        .on("page-change.bs.table", function () {
            e.text("Event: page-change.bs.table")
        })
        .on("search.bs.table", function () {
            console.log("表格刷新按钮了")
        })

</script>

</body>
</html>
