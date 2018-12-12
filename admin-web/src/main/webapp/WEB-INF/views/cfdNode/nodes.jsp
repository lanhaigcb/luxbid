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
                                        <label class="control-label col-xs-1" for="currentNodeId" style="margin-left: -20px">选择节点：</label>
                                        <div class="col-sm-2">
                                            <select id="currentNodeId" name="currentNodeId" class=" form-control">
                                                <option value="">请选择</option>
                                                <c:forEach items="${nodes}" var="node">
                                                    <option value="${node.id}">${node.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-sm-2" style="text-align:left;">
                                        <button type="button" id="search" class="btn btn-primary">查询</button>
                                    </div>
                                </form>
                            </div>

                        </div>
                        <div class="btn-group hidden-xs" id="tableToolbar" role="group">
                         <fn:func url="cfdNode/transfer">
                                <button type="button" id="transfer" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-plus" aria-hidden="true">划转记录</i>
                                </button>
                            </fn:func>
                          <%--  <fn:func url="cfdNode/updateInput">
                                <button type="button" id="update" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-pencil" aria-hidden="true">编辑节点</i>
                                </button>
                            </fn:func>--%>
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
                url: "cfdNode/nodeList",
                pagination: true,
                showColumns: true,     //是否显示所有的列1
                showRefresh: true,     //是否显示刷新按钮
                sortable: false,      //是否启用排序
                sortOrder: "asc",     //排序方式
                sidePagination: "server",
                queryParams: queryParams,
                clickToSelect: true,
                singleSelect: true,
                toolbar: "#tableToolbar",
                height: 500,
                columns: [{
                    checkbox: true
                }, {
                    field: 'id',
                    title: '序号',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'name',
                    title: '名称',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'totalGross',
                    title: '总入金',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'totalOut',
                    title: '总出金',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'available',
                    title: '节点总权益',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'occupy',
                    title: '占用',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'totalUserProfit',
                    title: '用户盈亏',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'toalNodeProfit',
                    title: '对冲盈亏',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'risk',
                    title: '风险率',
                    width: 50,
                    formatter: function (value, row, index) {
                        return value * 100;
                    },
                    align: 'center'
                }
                ]
            });
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

           // $("#currencyTable").bootstrapTable("refresh");
        }

        //查询参数
        function queryParams(params) {
            params.nodeId = $("#currentNodeId").val();
            return params;
        }
        $("#transfer").click(function () {
            var rows = $("#currencyTable").bootstrapTable("getSelections");
            if(rows.length != 1){
                layer.msg('请选择一行执行操作！');
                return
            }
            layer.open({
                type: 2,
                title: '查看节点划转信息',
                shadeClose: true,
                shade: 0.8,
                area: ['80%', '90%'],
                content: 'cfdNode/transfer?id='+rows[0].id
            });
        });
    </script>
</body>
</html>
