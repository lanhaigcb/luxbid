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
                                        <label class="control-label col-xs-1" for="baseCurrencyId"
                                               style="margin-left: -20px">交易币种：</label>
                                        <div class="col-sm-2">
                                            <select id="baseCurrencyId" name="baseCurrencyId" class=" form-control">
                                                <option value="">请选择</option>
                                                <c:forEach items="${currencys}" var="currency">
                                                    <option value="${currency.id}">${currency.symbol}&nbsp;(${currency.chName})</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <label class="control-label col-xs-1" for="quoteCurrencyId"
                                               style="margin-left: -20px">对标币种：</label>
                                        <div class="col-sm-2">
                                            <select id="quoteCurrencyId" name="quoteCurrencyId" class=" form-control">
                                                <option value="">请选择</option>
                                                <c:forEach items="${currencys}" var="currency">
                                                    <option value="${currency.id}">${currency.symbol}&nbsp;(${currency.chName})</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-sm-2" style="text-align:left;">
                                            <button type="button" style="margin-left:50px" id="search"
                                                    class="btn btn-primary">查询
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <div class="btn-group hidden-xs" id="tableToolbar" role="group">
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
                        </div>
                        <table id="exchangeTable" data-height="400" data-mobile-responsive="true">
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <!-- End Panel Other -->
    </div>
</div>
<script type="text/javascript" charset="UTF-8">

    var currencyArray =${currencyArray};
    var currencyMap = {};
    currencyArray.forEach(function (item, index) {
        currencyMap[item.id]=item;
    });

    (function ($) {
        $("#exchangeTable").bootstrapTable({
            method: 'POST',
            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            url: "exchange/findListAll",
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
            columns: [{
                checkbox: true
            }, {
                field: 'id',
                title: 'ID',
                width: 50,
                align: 'center'
            }, {
                field: 'baseCurrencyId',
                title: '交易币种',
                width: 50,
                align: 'center',
                formatter: function (value, row, index) {
                    return currencyMap[value].symbol;
                }
            }, {
                field: 'quoteCurrencyId',
                title: '对标币种',
                width: 50,
                align: 'center',
                formatter: function (value, row, index) {
                    return currencyMap[value].symbol;
                }
            }, {
                field: 'symbol',
                title: '符号',
                width: 50,
                align: 'center'
            }, {
                field: 'amountPrecision',
                title: '交易精度',
                width: 50,
                align: 'center'
            }, {
                field: 'pricePrecision',
                title: '对标精度',
                width: 50,
                align: 'center'
            }, {
                field: 'exRate',
                title: '交易手续费率',
                width: 50,
                align: 'center'
            }, {
                field: 'minTradeLimit',
                title: '交易最小单笔金额',
                width: 50,
                align: 'center'
            }, {
                field: 'partitionType',
                title: '分区',
                width: 50,
                align: 'center',
                formatter: function (value, row, index) {
                    if (value == 'MAIN') {
                        return '主分区';
                    } else if (value == 'INNOVATION') {
                        return '创新分区';
                    }
                }
            }, {
                field: 'show',
                title: '是否显示',
                width: 50,
                align: 'center',
                formatter: function (value, row, index) {
                    if (value == true) {
                        return '<span style="color:green">是</span>';
                    } else if (value == false) {
                        return '<span style="color:red">否</span>';
                    }
                }
            },{
                field: 'outKline',
                title: '是否外部K线',
                width: 50,
                align: 'center',
                formatter: function (value, row, index) {
                    if (value == true) {
                        return '<span style="color:green">是</span>';
                    } else if (value == false) {
                        return '<span style="color:red">否</span>';
                    }
                }
            }, {
                field: 'orderParameter',
                title: '排序参数',
                width: 50,
                align: 'center'
            }
            ]
        });

        //查询参数
        function queryParams(params) {
            params.baseCurrencyId = $("#baseCurrencyId").val();
            params.quoteCurrencyId = $("#quoteCurrencyId").val();
            return params;
        }

        $("#search").on("click", function () {
            refresh()
        });
    })(jQuery);

    function refresh() {
        $("#exchangeTable").bootstrapTable("refresh");
    }

    $("#add").click(function () {
        layer.open({
            type: 2,
            title: '新增交易对',
            shadeClose: true,
            shade: 0.8,
            area: ['80%', '90%'],
            content: 'exchange/addInput'
        });
    });

    $("#update").click(function () {
        var rows = $("#exchangeTable").bootstrapTable("getSelections");
        if (rows.length != 1) {
            layer.msg('请选择一行执行操作！');
            return
        }
        layer.open({
            type: 2,
            title: '编辑交易对',
            shadeClose: true,
            shade: 0.8,
            area: ['80%', '90%'],
            content: 'exchange/updateInput?id=' + rows[0].id
        });
    });
</script>
</body>
</html>
