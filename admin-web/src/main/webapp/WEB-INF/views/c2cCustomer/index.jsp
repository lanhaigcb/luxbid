<%@ page import="com.mine.common.enums.C2CExOrderStatus" %>
<%@ page import="com.mine.common.enums.ExOrderType" %>
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
                                        <label class="control-label col-xs-1" for="customerId"
                                               style="margin-left: -20px">用户ID：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="customerId" name="customerId"
                                                   placeholder="用户ID">
                                        </div>
                                        <label class="control-label col-xs-1" for="mobile" style="margin-left: -20px">手机号：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="mobile" name="mobile"
                                                   placeholder="手机号">
                                        </div>

                                        <label class="control-label col-xs-1" for="email"
                                               style="margin-left: -20px">邮箱：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="email" name="email"
                                                   placeholder="邮箱">
                                        </div>
                                    </div>
                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-xs-1" for="enable" style="margin-left: -20px">状态：</label>
                                        <div class="col-sm-2">
                                            <select id="enable" name="enable" class=" form-control">
                                                <option value="">请选择</option>
                                                <option value="true">正常</option>
                                                <option value="false">冻结</option>
                                            </select>
                                        </div>

                                        <label class="control-label col-xs-1" for="hasC2CTrade"
                                               style="margin-left: -20px">有无法币交易：</label>
                                        <div class="col-sm-2">
                                            <select id="hasC2CTrade" name="hasC2CTrade" class=" form-control">
                                                <option value="">请选择</option>
                                                <option value="true">有</option>
                                                <option value="false">无</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="col-sm-2" style="text-align:left;">
                                        <button type="button" style="margin-left:50px" id="search"
                                                class="btn btn-primary">查询
                                        </button>
                                        <%--<button type="button" style="margin-left:10px" id="export" class="btn btn-primary">导出</button>--%>
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
                    <div class="btn-group hidden-xs" id="tableToolbar" role="group">
                            <button type="button" id="detail" class="btn btn-outline btn-default">
                                <i class="glyphicon glyphicon-plus" aria-hidden="true">查看详情</i>
                            </button>
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
                isFirst = false;
                $("#exchangeOrderTable").bootstrapTable({
                    method: 'POST',
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                    url: "c2cCustomer/list",
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
                    height: 500,
                    columns: [{
                        checkbox: true
                    }, {
                        field: 'customerId',
                        title: '用户ID',
                        width: 50,
                        align: 'center'
                    },{
                        field: 'mobile',
                        title: '手机号',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'email',
                        title: '邮箱',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'enable',
                        title: '状态',
                        width: 50,
                        align: 'center',
                        formatter: function (value, row, index) {
                            if(row.enable==true){
                                return "<font color='green'>正常</font>"
                            } else {
                                return "<font color='red'>冻结</font>"
                            }
                        }
                    }, {
                        field: 'hasC2CTrade',
                        title: '有无交易',
                        width: 50,
                        align: 'center',
                        formatter: function (value, row, index) {
                            if(row.hasC2CTrade==true){
                                return "<font color='green'>有</font>"
                            } else {
                                return "<font color='red'>无</font>"
                            }
                        }
                    }, {
                        field: 'buyOrderCount',
                        title: '买入订单数',
                        width: 30,
                        align: 'center'
                    // }, {
                    //     field: 'buyOrderAmount',
                    //     title: '买入总数量',
                    //     width: 50,
                    //     align: 'center'
                    // }, {
                    //     field: 'totalBuyAmount',
                    //     title: '买入总金额',
                    //     width: 50,
                    //     align: 'center'
                    }, {
                        field: 'sellOrderCount',
                        title: '卖出订单数',
                        width: 30,
                        align: 'center'
                    // }, {
                    //     field: 'sellOrderAmount',
                    //     title: '卖出总数量',
                    //     width: 50,
                    //     align: 'center'
                    // }, {
                    //     field: 'totalSellAmount',
                    //     title: '卖出总金额',
                    //     width: 50,
                    //     align: 'center'
                    }, {
                        field: 'totalOrderCount',
                        title: '总订单数',
                        width: 30,
                        align: 'center'
                    }, {
                        field: 'cancelOrderCount',
                        title: '取消订单数',
                        width: 30,
                        align: 'center'
                    }, {
                        field: 'cardOwner',
                        title: '姓名',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'bankName',
                        title: '银行名',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'subBankName',
                        title: '银行支行',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'cardNumber',
                        title: '卡号',
                        width: 50,
                        align: 'center'
                    }, {
                        title: '操作',
                        width: 50,
                        align: 'center',
                        formatter: function (value, row, index) {
                            var html = "";
                            if(row.enable==true){
                                html += "<input type='button' class='btn btn-danger' onclick='change(" + row.customerId + ",false)'  value='冻结' />&nbsp;";
                            }
                            if(row.enable==false){
                                html += "<input type='button' class='btn btn-success' onclick='change(" + row.customerId + ",true)'  value='启用' />&nbsp;";
                            }
                            return html;
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
            params.mobile = $("#mobile").val();
            params.email = $("#email").val();
            params.enable = $("#enable").val();
            params.hasC2CTrade = $("#hasC2CTrade").val();
            return params;
        }


    })(jQuery);

    function change(id,enable) {

        layer.confirm('确认修改吗？', {
            btn: ['修改','取消'] //按钮
        }, function(){
            $.ajax({
                type: "POST",
                url: "c2cCustomer/enable",
                data: {id: id, enable:enable},
                dataType: "json",
                success: function (data) {
                    layer.msg(data.message);
                    refresh();
                }
            });
        }, function(){
            layer.msg("取消操作");
        });


    }

    function refresh() {
        $("#exchangeOrderTable").bootstrapTable("refresh");
    }

    $("#detail").click(function () {
        var rows = $("#exchangeOrderTable").bootstrapTable("getSelections");
        if(rows.length != 1){
            layer.msg('请选择一行执行操作！');
            return
        }
        layer.open({
            type: 2,
            title: '查看详情',
            shadeClose: true,
            shade: 0.8,
            area: ['80%', '90%'],
            content: 'c2cCustomer/toDetail?customerId='+rows[0].customerId
        });
    });
</script>
</body>
</html>
