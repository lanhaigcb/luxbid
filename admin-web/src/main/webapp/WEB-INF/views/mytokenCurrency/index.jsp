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
                                        <div class="col-sm-2" style="text-align:left;">
                                            <button type="button" id="search" class="btn btn-primary">查询</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <div class="btn-group hidden-xs" id="tableToolbar" role="group">
                            <fn:func url="mytokenCurrency/addInput">
                                <button type="button" id="add" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-plus" aria-hidden="true">在mytoken注册币种</i>
                                </button>
                            </fn:func>
                        </div>
                    <table id="mytokenCurrencyTable" data-height="400" data-mobile-responsive="true">
                    </table>
                </div>
            </div>
        </div>
    </div>
    <!-- End Panel Other -->
    </div>
</div>
    <script type="text/javascript" charset="UTF-8">
        (function($){
            $("#mytokenCurrencyTable").bootstrapTable({
                method: 'POST',
                contentType:"application/x-www-form-urlencoded; charset=UTF-8",
                url:"mytokenCurrency/listAll",
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
                }, {
                    field: 'symbol',
                    title: '符号',
                    width:50,
                    align:'center'
                }, {
                    field: 'name',
                    title: '英文币种名称',
                    width:50,
                    align:'center'
                }, {
                    field: 'logo_url',
                    title: '币种图片',
                    width:20,
                    align:'center',
                    formatter:function(value,row,index) {
                        if (value!="" && value!=null){
                            return '<img src="'+value+'" width="20" height="20" class="img-rounded" />';
                        }}
                }, {
                    field: 'website',
                    title: '官网地址',
                    width:50,
                    align:'center'
                }, {
                    field: 'coinmarketcap_url',
                    title: 'coinmarketcap上的连接地址',
                    width:50,
                    align:'center'
                }, {
                    field: 'explorer_url',
                    title: 'explorer对应地址',
                    width:50,
                    align:'center'
                },{
                    field: 'github',
                    title: 'GitHub 账号或地址',
                    width:50,
                    align:'center'
                }
                ]
            });

            //查询参数
            function queryParams(params) {
                params.symbol = $("#symbol").val();
                return params;
            }
            $("#search").on("click",function(){
                refresh()
            });
        })(jQuery);

        function refresh(){
            $("#mytokenCurrencyTable").bootstrapTable("refresh");
        }

        $("#add").click(function () {
            layer.open({
                type: 2,
                title: '新增mytoken币种',
                shadeClose: true,
                shade: 0.8,
                area: ['80%', '90%'],
                content: 'mytokenCurrency/addInput'
            });
        });

    </script>
</body>
</html>
