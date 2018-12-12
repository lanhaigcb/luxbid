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
                                        <label class="control-label col-xs-1" for="datepicker" style="margin-left: -20px">创建时间：</label>
                                        <div class="col-sm-3" style="text-align:left;">
                                            <div class="input-daterange input-group" id="datepicker">
                                                <input type="text" class="input-sm form-control" name="start" id="startDate" value="" />
                                                <span class="input-group-addon">到</span>
                                                <input type="text" class="input-sm form-control" name="end" id ="endDate" value="" />
                                            </div>
                                        </div>
                                        <label class="control-label col-xs-1" for="account" style="margin-left: -20px">用户帐号：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="account" name="account" placeholder="手机号或邮箱">
                                        </div>
                                        <label class="control-label col-xs-1" for="buy" style="margin-left: -20px">买卖：</label>
                                        <div class="col-sm-2">
                                            <select id="buy" name="buy" class=" form-control">
                                                <option value="">请选择</option>
                                                    <option value="1">买</option>
                                                    <option value="0">卖</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-xs-1" for="exchangeId" style="margin-left: -20px">交易对：</label>
                                        <div class="col-sm-2">
                                            <select id="exchangeId" name="exchangeId" class=" form-control">
                                                <option value="">请选择</option>
                                                <c:forEach items="${voList}" var="v" >
                                                    <option value="${v.id}">${v.symbol}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-sm-2" style="text-align:left;">
                                            <button type="button" style="margin-left:50px" id="search" class="btn btn-primary">查询</button>
                                            <button type="button" style="margin-left:10px" id="export" class="btn btn-primary">导出</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <%--<div class="btn-group hidden-xs" id="tableToolbar" role="group">
                            <fn:func url="exchange/addInput">
                                <button type="button" id="add" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-plus" aria-hidden="true">新增交易对</i>
                                </button>
                            </fn:func>
                            <fn:func url="exchange/updateInput">
                                <button type="button" id="update" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-pencil" aria-hidden="true">编辑交易对</i>
                                </button>
                            </fn:func>
                        </div>--%>
                    <table id="exchangeOrderDetailTable" data-height="400" data-mobile-responsive="true">
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

            $("#exchangeOrderDetailTable").bootstrapTable({
                method: 'POST',
                contentType:"application/x-www-form-urlencoded; charset=UTF-8",
                //url:"exchange/findListAll",
                url:"exchangeOrderDetail/list",
                pagination:true,
                showColumns: true,     //是否显示所有的列1
                showRefresh: true,     //是否显示刷新按钮
                sortable: false,      //是否启用排序
                sortOrder: "asc",     //排序方式
                queryParams:queryParams,
                sidePagination: "server",
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
                    title: '用户帐号',
                    width:50,
                    align:'center'
                }, {
                    field: 'orderId',
                    title: '订单ID',
                    width:50,
                    align:'center'
                }, {
                    field: 'dealOrderId',
                    title: '对手订单ID',
                    width:50,
                    align:'center'
                }, {
                    field: 'exPrice',
                    title: '成交价格',
                    width:50,
                    align:'center'
                }, {
                    field: 'fee',
                    title: '手续费',
                    width:50,
                    align:'center'
                },  {
                    field: 'amount',
                    title: '成交数量',
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
                }, {
                    field: 'createTime',
                    title: '创建时间',
                    width:50,
                    align:'center'
                }
                ]});

            $("#search").on("click", function () {
                var startDate = $("#startDate").val();
                var endDate = $("#endDate").val();
                if (startDate.trim() == "" || endDate.trim() == "") {
                    layer.msg("请输入时间段查询");
                    return false;
                }
                if (isFirst) {
                    isFirst = false;
                    $("#exchangeOrderDetailTable").bootstrapTable({
                        method: 'POST',
                        contentType:"application/x-www-form-urlencoded; charset=UTF-8",
                        //url:"exchange/findListAll",
                        url:"exchangeOrderDetail/list",
                        pagination:true,
                        showColumns: true,     //是否显示所有的列1
                        showRefresh: true,     //是否显示刷新按钮
                        sortable: false,      //是否启用排序
                        sortOrder: "asc",     //排序方式
                        queryParams:queryParams,
                        sidePagination: "server",
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
                            title: '用户帐号',
                            width:50,
                            align:'center'
                        }, {
                            field: 'orderId',
                            title: '订单ID',
                            width:50,
                            align:'center'
                        }, {
                            field: 'dealOrderId',
                            title: '对手订单ID',
                            width:50,
                            align:'center'
                        }, {
                            field: 'exPrice',
                            title: '成交价格',
                            width:50,
                            align:'center'
                        },  {
                            field: 'amount',
                            title: '成交数量',
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
                        }, {
                            field: 'createTime',
                            title: '创建时间',
                            width:50,
                            align:'center'
                        }
                        ]
                    });
                } else {
                    refresh();
                }
            })








            //查询参数
            function queryParams(params) {
                params.startDate = $("#startDate").val();
                params.endDate = $("#endDate").val();
                params.account = $("#account").val();
                params.buy = $("#buy").val();
                params.exchangeId = $("#exchangeId").val();
                params.pageSize = params.limit;
                params.offset =params.offset;
                return params;
            }
            $("#search").on("click",function(){
                refresh()
            });

            $("#export").click(function () {
                var params = {};
                params=queryParams(params);
                var url = "exchangeOrderDetail/export?"+
                    "&account="+params.account+
                    "&exchangeId="+params.exchangeId+
                    "&buy="+params.buy+
                    "&startDate="+params.startDate+
                    "&endDate="+params.endDate;
                window.location.href=url;
            });
        })(jQuery);

        function refresh(){
            $("#exchangeOrderDetailTable").bootstrapTable("refresh");
        }

    </script>
</body>
</html>
