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

                        <div class="btn-group hidden-xs" id="tableToolbar" role="group">
                                <button type="button" id="add" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-plus" aria-hidden="true">新增币种</i>
                                </button>
                                <button type="button" id="update" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-pencil" aria-hidden="true">编辑币种</i>
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



        $("#exchangeOrderTable").bootstrapTable({
            method: 'POST',
            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            url: "c2cCurrency/list",
            pagination: true,
            showColumns: true,     //是否显示所有的列1
            showRefresh: true,     //是否显示刷新按钮
            sortable: false,      //是否启用排序
            sortOrder: "asc",     //排序方式
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
                field: 'id',
                title: 'ID',
                width: 50,
                align: 'center'
            }, {
                field: 'createTime',
                title: '创建时间',
                width: 50,
                align: 'center'
            }, {
                field: 'symbol',
                title: '币种',
                width: 50,
                align: 'center'
            }, {
                field: 'precise',
                title: '交易精度',
                width: 50,
                align: 'center'
            }, {
                field: 'price',
                title: '对标单价',
                width: 50,
                align: 'center'
            }, {
                field: 'tradeMinLimit',
                title: '交易最小限额',
                width: 50,
                align: 'center'
            }, {
                field: 'tradeMaxLimit',
                title: '交易最大限额',
                width: 50,
                align: 'center'
            }, {
                field: 'enable',
                title: '是否启用',
                width: 50,
                align: 'center',
                formatter: function (value, row, index) {
                    if(row.enable==true){
                        return "<font color='green'>是</font>"
                    } else {
                        return "<font color='red'>否</font>"
                    }
                }

            }, {
                field: 'needUpdatePrice',
                title: '是否需要同步单价',
                width: 50,
                align: 'center',
                formatter: function (value, row, index) {
                    if(row.needUpdatePrice==true){
                        return "<font color='green'>是</font>"
                    } else {
                        return "<font color='red'>否</font>"
                    }
                }
            }

            ]
        });




    })(jQuery);

    $("#add").click(function () {
        layer.open({
            type: 2,
            title: '新增币种',
            shadeClose: true,
            shade: 0.8,
            area: ['55%', '60%'],
            content: 'c2cCurrency/addInput'
        });
    });

    $("#update").click(function () {
        var rows = $("#exchangeOrderTable").bootstrapTable("getSelections");
        if(rows.length != 1){
            layer.msg('请选择一行执行操作！');
            return
        }
        layer.open({
            type: 2,
            title: '编辑币种',
            shadeClose: true,
            shade: 0.8,
            area: ['55%', '60%'],
            content: 'c2cCurrency/updateInput?id='+rows[0].id
        });
    });


    function refresh() {
        $("#exchangeOrderTable").bootstrapTable("refresh");
    }
</script>
</body>
</html>
