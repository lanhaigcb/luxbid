<%@ taglib prefix="fn" uri="/func" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<%@include file="../common/head-title.jsp"%>
<body class="gray-bg">
<div class="wrapper wrapper-content animated fadeInRight">
    <!-- Panel Other -->
<fn:func url="awardCheck/index">
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
                                        <label class="control-label col-xs-1" for="customerAccount" style="margin-left: -20px">用户账号：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="customerAccount" placeholder="用户账号">
                                        </div>
                                        <label class="control-label col-xs-1">奖励币种：</label>
                                        <div class="col-sm-2">
                                            <select class="form-control show-tick"  id="symbol" name="symbol">
                                                <option value="" >请选择</option>
                                                <c:forEach items="${currencys}" var="currency">
                                                    <option value="${currency.symbol}">${currency.symbol}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <label class="control-label col-xs-1" for="senderRealName" style="margin-left: -20px">提交人：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="senderRealName" placeholder="提交人">
                                        </div>
                                        <label class="control-label col-xs-1" for="realNameStatus">是否实名：</label>
                                        <div class="col-sm-2">
                                            <select class="form-control show-tick" id="realNameStatus" placeholder="实名状态">
                                                <option value="" >请选择</option>
                                                <option value="PASS" >已实名</option>
                                                <option value="NOT_PASS" >未实名</option>
                                            </select>
                                        </div>
                                        <label class="control-label col-xs-1" for="regStartDate" style="margin-left: -20px;margin-top: 10px">注册时间：</label>
                                        <div class="col-sm-3" style="text-align:left;margin-top: 10px">
                                            <div class="input-daterange input-group" id="datepicker">
                                                <input type="text" class="input-sm form-control" name="start" id="regStartDate" value=""/>
                                                <span class="input-group-addon">到</span>
                                                <input type="text" class="input-sm form-control" name="end" id="regEndDate" value=""/>
                                            </div>
                                        </div>
                                        <label class="control-label col-xs-1" for="realNameStartDate" style="margin-left: -20px;margin-top: 10px">实名时间：</label>
                                        <div class="col-sm-3" style="text-align:left;margin-top: 10px">
                                            <div class="input-daterange input-group" id="datepicker1">
                                                <input type="text" class="input-sm form-control" name="start" id="realNameStartDate" value=""/>
                                                <span class="input-group-addon">到</span>
                                                <input type="text" class="input-sm form-control" name="end" id="realNameEndDate" value=""/>
                                            </div>
                                        </div>
                                        <label class="control-label col-xs-1" for="startDate" style="margin-left: -20px;margin-top: 10px">提交时间：</label>
                                        <div class="col-sm-3" style="text-align:left;margin-top: 10px">
                                            <div class="input-daterange input-group" id="datepicker2">
                                                <input type="text" class="input-sm form-control" name="start" id="startDate" value=""/>
                                                <span class="input-group-addon">到</span>
                                                <input type="text" class="input-sm form-control" name="end" id="endDate" value=""/>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" style="margin-top:15px">
                                        <div class="col-sm-2" style="text-align:right;">
                                            <button type="button" style="margin-left:10px" id="search" class="btn btn-primary">查询</button>
                                            <button type="button" style="margin-left:10px" id="checkBatch" class="btn btn-primary">批量通过</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    <table id="awardCheckTable" data-height="400" data-mobile-responsive="true">
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
        var isFirst = true;
        (function($){
            $("#datepicker").datepicker({
                keyboardNavigation:!1,
                forceParse:!1,
                autoclose:!0
            });
            $("#datepicker1").datepicker({
                keyboardNavigation:!1,
                forceParse:!1,
                autoclose:!0
            });
            $("#datepicker2").datepicker({
                keyboardNavigation:!1,
                forceParse:!1,
                autoclose:!0
            });
            //查询参数
            function queryParams(params) {
                params.customerAccount = $("#customerAccount").val();
                params.symbol = $("#symbol").val();
                params.realNameStatus = $("#realNameStatus").val();
                params.senderRealName = $("#senderRealName").val();
                params.regStartDate = $("#regStartDate").val();
                params.regEndDate = $("#regEndDate").val();
                params.startDate = $("#startDate").val();
                params.endDate = $("#endDate").val();
                params.realNameStartDate = $("#realNameStartDate").val();
                params.realNameEndDate = $("#realNameEndDate").val();
                return params;
            }
            $("#search").on("click",function(){
                if (isFirst) {
                    isFirst = false;
                    $("#awardCheckTable").bootstrapTable({
                        url:"awardCheck/list",
                        pagination:true,
                        method: 'POST',
                        contentType:"application/x-www-form-urlencoded; charset=UTF-8",
                        showColumns: false,     //是否显示所有的列
                        showRefresh: false,     //是否显示刷新按钮
                        sortable: false,      //是否启用排序
                        sortOrder: "desc",     //排序方式
                        queryParams:queryParams,
                        sidePagination: "server",
                        clickToSelect:true,
                        singleSelect:false,
                        toolbar:"#awardCheckTableToolbar",
                        height:800,
                        pageSize : 10, //每页的记录行数（*）
                        pageList : [ 10, 50 , 100, 500, 1000 ], //可供选择的每页的行数（*）
                        columns: [{
                            checkbox: true
                        }, {
                            field: 'id',
                            title: 'ID',
                            width:100,
                            align:'center'
                        }, {
                            field: 'customerId',
                            title: '账号ID',
                            width:200,
                            align:'center'
                        }, {
                            field: 'customerAccount',
                            title: '用户账号',
                            width:200,
                            align:'center'
                        },{
                            field: 'registerTime',
                            title: '注册时间',
                            width:100,
                            align:'center'
                        }, {
                            field: 'realNameStatus',
                            title: '是否实名',
                            width:200,
                            align:'center',
                            formatter: function (value, row, index) {
                                if ('PASS' == value) {
                                    return '<span style="color: green;">是</span>';
                                } else {
                                    return '<span style="color: red;">否</span>';
                                }
                            }
                        }, {
                            field: 'auditTime',
                            title: '实名时间',
                            width:200,
                            align:'center'
                        }, {
                            field: 'awardNum',
                            title: '奖励数量',
                            width:200,
                            align:'center'
                        },{
                            field: 'symbol',
                            title: '奖励币种',
                            width:200,
                            align:'center'
                        }, {
                            field: 'reason',
                            title: '奖励原因',
                            width:200,
                            align:'center'
                        }, {
                                field: 'senderRealName',
                                title: '提交人',
                                width:200,
                                align:'center'
                        }, {
                                field: 'createTime',
                                title: '提交时间',
                                width:200,
                                align:'center'
                        }, {
                            field: 'make',
                            title: '操作',
                            width: 200,
                            align: 'center',
                            formatter: function (value, row, index) {
                                    return '<button type="button" style="margin-left:5px" class="btn btn-primary" onclick="checkPass(\'' + row.id + '\')">通过</button><button type="button" style="margin-left:5px" class="btn btn-primary" onclick="checkUnPass(\'' + row.id + '\')">驳回</button>';
                            }
                        }]
                    });
                } else {
                    refresh();
                }
            });
        })(jQuery);
        //刷新
        function refresh(){
            $("#awardCheckTable").bootstrapTable("refresh");
        }

        //启用
        function checkPass(id) {
            updateStatus(id, "PASS");
        }

        //禁用
        function checkUnPass(id) {
            updateStatus(id, "NOT_PASS");
        }

        //更新状态
        function updateStatus(id, status) {
            $.ajax({
                url: 'award/updateStatus',
                data: {id: id, status: status},
                success: function (data) {
                    if (data.result) {
                        if ("PASS" == status) {
                            layer.msg("审核通过");
                            refresh();
                        } else {
                            layer.msg("审核不通过");
                        }
                    } else {
                        layer.msg("操作失败");
                    }
                    refresh();
                }
            })
        }

        //批量更新状态
        $("#checkBatch").on("click",function(){
            var rows = $("#awardCheckTable").bootstrapTable("getSelections");
            var ids = "";
            if (rows.length == 0) {
                layer.msg('请选择您要审核的记录！');
                return;
            } else {
                for (var i = 0; i < rows.length; i++) {
                    if (ids == "") {
                        ids = rows[i].id
                    } else {
                        ids += "," + rows[i].id
                    }
                }
            }
            $.ajax({
                type: 'POST',
                url: 'award/updateStatusBatch',
                data: {ids:ids},
                success: function (data) {
                    layer.msg(data.message);
                    refresh();
                }
            })
        })
    </script>
</body>
</html>
