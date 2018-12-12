<%@ page import="com.mine.common.enums.ExOrderStatus" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<%@include file="../common/head-title.jsp"%>
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
                                            <input type="text" class="form-control" id="customerId" name="customerId" placeholder="用户ID">
                                        </div>
                                        <label class="control-label col-xs-1" for="account" style="margin-left: -20px">帐号：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="account" name="account" placeholder="手机号或邮箱">
                                        </div>
                                        <label class="control-label col-xs-1" for="symbol" style="margin-left: -20px">交易对：</label>
                                        <div class="col-sm-2">
                                            <select id="symbol" name="symbol" class=" form-control">
                                                <option value="">请选择</option>
                                                <c:forEach items="${voList}" var="v" >
                                                    <option value="${v.symbol}">${v.symbol}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <label class="control-label col-xs-1" for="orderStatus" style="margin-left: -20px">状态：</label>
                                        <div class="col-sm-2">
                                            <select id="orderStatus" name="orderStatus" class=" form-control">
                                                <option value="">请选择</option>
                                                <c:forEach var="v" items="<%=ExOrderStatus.values()%>" >
                                                    <option value="${v.name()}">${v.toString()}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-xs-1" for="channelId" style="margin-left: -20px">渠道：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="channelId" name="channelId" placeholder="渠道号">
                                        </div>
                                        <label class="control-label col-xs-1" for="buy" style="margin-left: -20px">买卖：</label>
                                        <div class="col-sm-2">
                                            <select id="buy" name="buy" class=" form-control">
                                                <option value="">请选择</option>
                                                <option value="1">买</option>
                                                <option value="0">卖</option>
                                            </select>
                                        </div>
                                        <label class="control-label col-xs-1" for="isProjectStr"
                                               style="margin-left: -20px">项目方：</label>
                                        <div class="col-sm-2">
                                            <select id="isProjectStr" name="isProjectStr" class=" form-control">
                                                <option value="">请选择</option>
                                                <option value="1">是</option>
                                                <option value="0">否</option>
                                            </select>
                                        </div>
                                        <label class="control-label col-xs-1" for="whiteList" style="margin-left: -20px">白名单：</label>
                                        <div class="col-sm-2">
                                            <select id="whiteList" name="whiteList" class=" form-control">
                                                <option value="">请选择</option>
                                                <option value="1">是</option>
                                                <option value="0">否</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-xs-1" for="datepicker" style="margin-left: -20px">创建时间：</label>
                                        <div class="col-sm-3" style="text-align:left;">
                                            <div class="input-daterange input-group" id="datepicker">
                                                <input type="text" class="input-sm form-control" name="start" id="startDate" value="" />
                                                <span class="input-group-addon">到</span>
                                                <input type="text" class="input-sm form-control" name="end" id ="endDate" value="" />
                                            </div>
                                        </div>
                                        <div class="col-sm-2" style="text-align:left;">
                                            <button type="button" style="margin-left:50px" id="search" class="btn btn-primary">查询</button>
                                            <button type="button" style="margin-left:10px" id="export" class="btn btn-primary">导出</button>
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
    (function($){

        $("#datepicker").datepicker({
            keyboardNavigation:!1,
            forceParse:!1,
            autoclose:!0
        });

        $("#search").on("click",function(){
            var startDate = $("#startDate").val();
            var endDate = $("#endDate").val();
            if (startDate.trim() == "" || endDate.trim() == "") {
                layer.msg("请输入时间段查询");
                return false;
            }
            if (isFirst) {
                isFirst = false;
                $("#exchangeOrderTable").bootstrapTable({
                    method: 'POST',
                    contentType:"application/x-www-form-urlencoded; charset=UTF-8",
                    url:"exchangeOrder/list",
                    pagination:true,
                    showColumns: true,     //是否显示所有的列1
                    showRefresh: true,     //是否显示刷新按钮
                    sortable: false,      //是否启用排序
                    sortOrder: "asc",     //排序方式
                    queryParams:queryParams,
                    sidePagination: "server",
                    pageSize : 10, //每页的记录行数（*）
                    pageList : [ 10, 25, 50, 100 ], //可供选择的每页的行数（*）
                    clickToSelect:true,
                    singleSelect:true,
                    toolbar:"#tableToolbar",
                    height:500,
                    columns: [{
                        checkbox: true
                    }, {
                        field: 'id',
                        title: 'ID',
                        width:50,
                        align:'center'
                    },{
                        field: 'account',
                        title: '帐号',
                        width:50,
                        align:'center'
                    },{
                        field: 'customerId',
                        title: '用户ID',
                        width:50,
                        align:'center'
                    },{
                        field: 'channelId',
                        title: '渠道',
                        width:50,
                        align:'center'
                    }, {
                        field: 'symbol',
                        title: '交易对',
                        width:50,
                        align:'center'
                    },{
                        field: 'buy',
                        title: '买卖',
                        width:50,
                        align:'center',
                        formatter:function(value,row,index) {
                            console.info(value);
                            if (value == true) {
                                return '买';
                            } else if (value == false) {
                                return '卖';
                            }
                        }
                    },  {
                        field: 'amountStr',
                        title: '数量',
                        width:50,
                        align:'center'
                    },  {
                        field: 'remainingAmountStr',
                        title: '剩余数量',
                        width:50,
                        align:'center'
                    },  {
                        field: 'price',
                        title: '单价',
                        width:50,
                        align:'center'
                    }, {
                        field: 'totalAmount',
                        title: '总额',
                        width:50,
                        align:'center'
                    }, {
                        field: 'totalAmountCNYStr',
                        title: 'CNY(总额)',
                        width:50,
                        align:'center'
                    },{
                        field: 'whiteList',
                        title: '白名单',
                        width:50,
                        align:'center',
                        formatter:function(value,row,index) {
                            console.info(value);
                            if (value == true) {
                                return '是';
                            } else if (value == false) {
                                return '否';
                            }
                        }
                    }, {
                        field: 'isProjectStr',
                        title: '项目方',
                        width: 30,
                        align: 'center',
                        formatter:function(value,row,index) {
                            console.info(value);
                            if (value == 1) {
                                return '是';
                            } else if (value == 0) {
                                return '否';
                            }
                        }
                    },{
                        field: 'fee',
                        title: '手续费',
                        width:50,
                        align:'center'
                    },{
                        field: 'orderStatus',
                        title: '订单状态',
                        width:50,
                        align:'center',
                        formatter:function(value,row,index) {
                            return value.value;
                        }
                    },  {
                        field: 'cancelApplyTime',
                        title: '撤单时间',
                        width:50,
                        align:'center'
                    },  {
                        field: 'createTime',
                        title: '创建时间',
                        width:50,
                        align:'center'
                    }, {
                        field: 'make',
                        title: '操作',
                        width: 50,
                        align: 'center',
                        showColumns: false ,
                        formatter: function (value, row, index) {
                            if(row.orderStatus.value == "已下单"){
                                return '<button type="button" style="margin-left:5px" class="btn btn-primary" onclick="adminCancel(\'' + row.id + '\')">撤销</button>';
                            }else{
                             return '无';
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
            params.customerId = $("#customerId").val();
            params.account = $("#account").val();
            params.symbol = $("#symbol").val();
            params.orderStatus = $("#orderStatus").val();
            params.channelId = $("#channelId").val();
            params.buy = $("#buy").val();
            params.isProjectStr = $("#isProjectStr").val();
            params.whiteList = $("#whiteList").val();
            params.startDate = $("#startDate").val();
            params.endDate = $("#endDate").val();
            params.pageSize = params.limit;
            params.page =params.offset;
            //getTotalAmountCNY();
            return params;
        }
        $("#export").click(function () {
            var params = {};
            params=queryParams(params);
            var url = "exchangeOrder/export?"+
                "customerId="+params.customerId+
                "&account="+params.account+
                "&symbol="+params.symbol+
                "&orderStatus="+params.orderStatus+
                "&channelId="+params.channelId+
                "&buy="+params.buy+
                "&isProjectStr="+params.isProjectStr+
                "&whiteList="+params.whiteList+
                "&startDate="+params.startDate+
                "&endDate="+params.endDate;
            window.location.href=url;
        });
    })(jQuery);

    //撤销订单
    function adminCancel(id) {
        $.ajax({
            url: 'exchangeOrder/adminCancel',
            data: {orderId: id},
            success: function (data) {
                if (data.result) {
                    layer.msg("撤销成功");
                } else {
                    layer.msg("撤销失败");
                }
                refresh();
            }
        })
    }

    function getTotalAmountCNY(){
        $.ajax({
            type: "GET",
            url: "exchangeOrder/totalAmountCNY",
            data: {customerId:$("#customerId").val(), account:$("#account").val(), symbol:$("#symbol").val(), orderStatus:$("#orderStatus").val(),
                  channelId:$("#channelId").val(), buy:$("#buy").val(), isProjectStr:$("#isProjectStr").val(), whiteList:$("#whiteList").val()
                  , startDate:$("#startDate").val(), endDate:$("#endDate").val()},
            dataType: "json",
            success: function(data){
                $('#totalAmountCNY').html(data.totalAmountCNY+" CNY");
            }
        });
    }

    function refresh(){
        $("#exchangeOrderTable").bootstrapTable("refresh");
    }
</script>
</body>
</html>
