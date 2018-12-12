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
                                        <label class="control-label col-xs-1" for="symbol" style="margin-left: 0px">符号：</label>
                                        <div class="col-sm-2">
                                            <input type="text"  class="form-control" id="symbol" placeholder="币种符号">
                                        </div>
                                        <label class="control-label col-xs-2" for="chName" style="margin-left: -40px">中文名称：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="chName" placeholder="币种名称">
                                        </div>
                                        <div class="col-sm-2" style="text-align:left;">
                                            <button type="button" id="search" class="btn btn-primary">查询</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <div class="btn-group hidden-xs" id="tableToolbar" role="group">
                            <fn:func url="cfdCurrency/addInput">
                                <button type="button" id="add" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-plus" aria-hidden="true">新增币种</i>
                                </button>
                            </fn:func>
                            <fn:func url="cfdCurrency/updateInput">
                                <button type="button" id="update" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-pencil" aria-hidden="true">编辑币种</i>
                                </button>
                            </fn:func>
                        </div>
                    <table id="currencyTable" data-height="400" data-mobile-responsive="true">
                    </table>
                </div>
            </div>
        </div>
    </div>
    <!-- End Panel Other -->
    </div>
</div>
    <script type="text/javascript" charset="UTF-8">


        function table() {

            $("#currencyTable").bootstrapTable({
                method: 'POST',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                url: "cfdCurrency/findListAll",
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
                    field: 'currencyName',
                    title: '币种信息',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'symbol',
                    title: '合约币种符号',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'chName',
                    title: '合约币种名称',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'image',
                    title: '合约币种图片',
                    width: 20,
                    align: 'center',
                    formatter: function (value, row, index) {
                        if (value != "" && value != null) {
                            return '<img src="' + value + '" width="20" height="20" class="img-rounded" />';
                        }
                    }
                }, {
                    field: 'precise',
                    title: '精度',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'leverage',
                    title: '杠杆',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'dayRate',
                    title: '日利率',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'feeRate',
                    title: '手续费率',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'tradeMinLimit',
                    title: '单笔交易最小限额',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'tradeMaxLimit',
                    title: '单笔交易最大限额',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'maxPositionLimit',
                    title: '最大持仓量',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'riseSpread',
                    title: '买涨点差',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'fallSpread',
                    title: '买跌点差',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'enable',
                    title: '是否可用',
                    width: 50,
                    align: 'center',
                    formatter: function (value, row, index) {
                        if (value == true) {
                            return '是';
                        } else if (value == false) {
                            return '否';
                        }
                    }
                }, {
                    title: '操作',
                    width: 50,
                    align: 'center',
                    formatter: function (value, row, index) {
                        var html = "";
                        if (row.enable == true) {
                            html += "<input type='button' class='btn btn-danger' onclick='change(" + row.id + ",false)'  value='禁用' />&nbsp;";
                        }
                        if (row.enable == false) {
                            html += "<input type='button' class='btn btn-success' onclick='change(" + row.id + ",true)'  value='启用' />&nbsp;";
                        }
                        html += "<input type='button' class='btn btn-primary' onclick='update(" + row.id + "," + index + ")'  value='修改' />";
                        return html;
                    }
                }
                ]
            });

        }
        //查询参数
        function queryParams(params) {
            params.symbol = $("#symbol").val();
            params.chName = $("#chName").val();
            return params;
        }


        (function($){
            table();
            $("#search").on("click",function(){
                refresh()
            });
        })(jQuery);

        function refresh(){
            $("#currencyTable").bootstrapTable('destroy');
            table();

          //  $("#currencyTable").bootstrapTable("refresh");
        }

        $("#add").click(function () {
            layer.open({
                type: 2,
                title: '新增币种',
                shadeClose: true,
                shade: 0.8,
                area: ['80%', '90%'],
                content: 'cfdCurrency/addInput'
            });
        });
        function change(id,enable) {

            layer.confirm('确认修改吗？', {
                btn: ['修改','取消'] //按钮
            }, function(){
                $.ajax({
                    type: "POST",
                    url: "cfdCurrency/enable",
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
        function update(){
            $("#currencyTable").bootstrapTable("check",index);
            var rows = $("#currencyTable").bootstrapTable("getSelections");
            if(rows.length != 1){
                layer.msg('请选择一行执行操作！');
                return
            }
            layer.open({
                type: 2,
                title: '编辑币种',
                shadeClose: true,
                shade: 0.8,
                area: ['80%', '90%'],
                content: 'cfdCurrency/updateInput?id='+rows[0].id
            });
        }

        function update(id,index){
            $("#currencyTable").bootstrapTable("check",index);
            var rows = $("#currencyTable").bootstrapTable("getSelections");
            if(rows.length != 1){
                layer.msg('请选择一行执行操作！');
                return
            }
            layer.open({
                type: 2,
                title: '编辑节点信息',
                shadeClose: true,
                shade: 0.8,
                area: ['80%', '90%'],
                content: 'cfdCurrency/updateInput?id='+rows[0].id
            });
        }

        $("#update").click(function () {
            var rows = $("#currencyTable").bootstrapTable("getSelections");
            if(rows.length != 1){
                layer.msg('请选择一行执行操作！');
                return
            }
            layer.open({
                type: 2,
                title: '编辑币种',
                shadeClose: true,
                shade: 0.8,
                area: ['80%', '90%'],
                content: 'cfdCurrency/updateInput?id='+rows[0].id
            });
        });
    </script>
</body>
</html>
