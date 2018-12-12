<%@ taglib prefix="fn" uri="/func" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                        <div class="col-sm-12">
                            <div id="main" style="width: 100%;height:400px;">
                                <table class="table table-bordered">
                                    <thead>
                                    <tr>
                                        <th colspan="4">资产统计</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td width="25%">用户ID：</td>
                                            <td width="25%">${adminCustomerVo.id}</td>
                                            <td width="25%">手机号：</td>
                                            <td width="25%">${adminCustomerVo.mobile}</td>
                                        </tr>
                                        <tr>
                                            <td>邮箱：</td>
                                            <td>${adminCustomerVo.email}</td>
                                            <td>实名状态：</td>
                                            <td>${adminCustomerVo.idInfoStatus}</td>
                                        </tr>
                                        <tr>
                                            <td>净资产折合：</td>
                                            <td>${adminCustomerVo.amountCNY} CNY</td>
                                            <td>可用资产折合：</td>
                                            <td>${adminCustomerVo.availableAmountCNY} CNY</td>
                                        </tr>
                                        <tr>
                                            <td>冻结资产折合：</td>
                                            <td>${adminCustomerVo.frozenAmountCNY} CNY</td>
                                            <td>总充值折合：</td>
                                            <td>${adminCustomerVo.sumRechargeAmountCNY} CNY</td>
                                        </tr>

                                        <tr>
                                            <td>总提现折合：</td>
                                            <td>${adminCustomerVo.sumWithdrawAmontCNY} CNY</td>
                                            <td>空投奖励折合：</td>
                                            <td>${adminCustomerVo.sumAwardNumCNY} CNY</td>
                                        </tr>

                                        <tr>
                                            <td>交易笔数：</td>
                                            <td>${adminCustomerVo.exchangeCount}</td>
                                            <td>总交易手续费折合：</td>
                                            <td>${adminCustomerVo.exchangeFeeCNY} CNY</td>
                                        </tr>
                                </tbody>
                                </table>
                            </div>

                            <div class="btn-group" id="customDetailTableToolbar" role="group">
                                <fn:func url="customer/manage/detail">
                                    <button type="button" id="showAccountLog" class="btn btn-outline btn-default">
                                        <i class="glyphicon glyphicon-search" aria-hidden="true"></i>查看资金流水
                                    </button>
                                </fn:func>
                               
                            </div>
                            <table id="customDetailTable" data-height="400" data-mobile-responsive="true">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- End Panel Other -->
    </div>
</div>
<script src="theme/js/plugins/echarts/echarts.min.js"></script>
<script type="text/javascript" charset="UTF-8">
    (function($){

        //查询参数
        function queryParams(params) {
            params.customerId = "${adminCustomerVo.id}";
            return params;
        }

        $("#customDetailTable").bootstrapTable({
            url:"customer/queryCustomerSubAccount",
            pagination:true,
            method: 'POST',
            contentType:"application/x-www-form-urlencoded; charset=UTF-8",
            showColumns: false,     //是否显示所有的列
            showRefresh: false,     //是否显示刷新按钮
            sortable: false,      //是否启用排序
            sortOrder: "asc",     //排序方式
            queryParams:queryParams,
            sidePagination: "server",
            clickToSelect:true,
            singleSelect:true,
            toolbar:"#customDetailTableToolbar",
            height:500,
            pageSize:100,
            pageList:[100, 200],
            columns: [{
                checkbox: true
            }, {
                field: 'currencyId',
                title: 'ID',
                width:100,
                align:'center'
            },{
                field: 'symbol',
                title: '币种',
                width:100,
                align:'center'
            }, {
                field: 'sumRechargeAmount',
                title: '总充值',
                width:200,
                align:'center',
                formatter:function(value,row,index) {
                    if (value == 0) {
                        return 0;
                    }else {
                        return value;
                    }
                }

            }, {
                field: 'c2cBuyAmont',
                title: '法币买入',
                width:200,
                align:'center',
                formatter:function(value,row,index) {
                    if (value == 0) {
                        return 0;
                    }else {
                        return value;
                    }
                }
            }, {
                field: 'sumBbBuyAmount',
                title: '币币买入',
                width:200,
                align:'center',
                formatter:function(value,row,index) {
                    if (value == 0) {
                        return 0;
                    }else {
                        return value;
                    }
                }
            }, {
                field: 'sumAwardNum',
                title: '空投',
                width:200,
                align:'center',
                formatter:function(value,row,index) {
                    if (value == 0) {
                        return 0;
                    }else {
                        return value;
                    }
                }
            }, {
                field: 'sumBfIncomeAmount',
                title: '拨付收入',
                width:200,
                align:'center',
                formatter:function(value,row,index) {
                    if (value == 0) {
                        return 0;
                    }else {
                        return value;
                    }
                }
            }, {
                field: 'sumWithdrawAmont',
                title: '总提现',
                width:200,
                align:'center',
                formatter:function(value,row,index) {
                    if (value == 0) {
                        return 0;
                    }else {
                        return value;
                    }
                }
            }, {
                field: 'c2cSellAmont',
                title: '法币卖出',
                width:200,
                align:'center',
                formatter:function(value,row,index) {
                    if (value == 0) {
                        return 0;
                    }else {
                        return value;
                    }
                }
            }, {
                field: 'sumBbSellAmount',
                title: '币币卖出',
                width:200,
                align:'center',
                formatter:function(value,row,index) {
                    if (value == 0) {
                        return 0;
                    }else {
                        return value;
                    }
                }
            }, {
                field: 'sumBbFeeAmount',
                title: '币币交易手续费',
                width:200,
                align:'center',
                formatter:function(value,row,index) {
                    if (value == 0) {
                        return 0;
                    }else {
                        return value;
                    }
                }
            }, {
                field: 'sumWrFeeAmount',
                title: '提币手续费',
                width:200,
                align:'center',
                formatter:function(value,row,index) {
                    if (value == 0) {
                        return 0;
                    }else {
                        return value;
                    }
                }
            }, {
                field: 'sumBfPayAmount',
                title: '拨付支出',
                width:200,
                align:'center',
                formatter:function(value,row,index) {
                    if (value == 0) {
                        return 0;
                    }else {
                        return value;
                    }
                }
            }/*, {
                field: 'bofuAmount',
                title: '拨付余额',
                width:200,
                align:'center',
                formatter:function(value,row,index) {
                    if (value == 0) {
                        return 0;
                    }else {
                        return value;
                    }
                }
            }*/, {
                field: 'theoryAmount',
                title: '理论资产',
                width:200,
                align:'center',
                formatter:function(value,row,index) {
                    if (value == 0) {
                        return 0;
                    }else {
                        return value;
                    }
                }
            }, {
                field: 'availableAmount',
                title: '可用余额',
                width:200,
                align:'center',
                formatter:function(value,row,index) {
                    if (value == 0) {
                        return 0;
                    }else {
                        return value;
                    }
                }
            },{
                field: 'frozenAmount',
                title: '冻结余额',
                width:200,
                align:'center',
                formatter:function(value,row,index) {
                    if (value == 0) {
                        return 0;
                    }else {
                        return value;
                    }
                }
            }

            ]
        });
    })(jQuery);

    //刷新
    function refresh() {
        $("#customDetailTable").bootstrapTable("refresh");
    }

    $("#showAccountLog").click(function () {
        var rows = $("#customDetailTable").bootstrapTable("getSelections");
        if(rows.length != 1){
            layer.msg('请选择一行执行操作！');
            return
        }
        layer.open({
            title:'查看资金流水',
            type: 2,
            fix: false, //不固定
            maxmin: true,
            area: ['90%', '90%'],
            content: 'customer/showAccountLog?subAccountId='+rows[0].subAccountId+'&customerId=${adminCustomerVo.id}'
        });
    });

    $("#modifyAmount").click(function () {
        var rows = $("#customDetailTable").bootstrapTable("getSelections");
        if(rows.length != 1){
            layer.msg('请选择一行执行操作！');
            return
        }
        layer.open({
            title:'修改余额',
            type: 2,
            fix: false, //不固定
            maxmin: true,
            area: ['90%', '90%'],
            content: 'customer/toModifyAmount?subAccountId='+rows[0].subAccountId+'&customerId=${adminCustomerVo.id}'
        });
    });
</script>
</body>
</html>
