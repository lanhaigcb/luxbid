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
        (function($){
            $("#currencyTable").bootstrapTable({
                method: 'POST',
                contentType:"application/x-www-form-urlencoded; charset=UTF-8",
                url:"currencyApply/list",
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
                height:600,
                pageSize : 10, //每页的记录行数（*）
                pageList : [ 10, 25, 50, 100 ], //可供选择的每页的行数（*）
                columns: [{
                    checkbox: true
                }, {
                    field: 'id',
                    title: 'ID',
                    width:50,
                    align:'center'
                }, {
                    field: 'currency',
                    title: '币种名称',
                    width:50,
                    align:'center'
                }, {
                    field: 'applyName',
                    title: '联系人',
                    width:50,
                    align:'center'
                }, {
                    field: 'contractInfo',
                    title: '联系方式',
                    width:50,
                    align:'center'
                }, {
                    field: 'createTime',
                    title: '创建时间',
                    width:50,
                    align:'center'
                }
                ]
            });

            //查询参数
            function queryParams(params) {
               // params.symbol = $("#symbol").val();
                //params.chName = $("#chName").val();
                params.size = params.limit;
                params.offset =params.offset;
                return params;
            }
            $("#search").on("click",function(){
                refresh()
            });
        })(jQuery);

        function refresh(){
            $("#currencyTable").bootstrapTable("refresh");
        }

        $("#add").click(function () {
            layer.open({
                type: 2,
                title: '新增币种',
                shadeClose: true,
                shade: 0.8,
                area: ['80%', '90%'],
                content: 'currency/addInput'
            });
        });

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
                content: 'currency/updateInput?id='+rows[0].id
            });
        });
    </script>
</body>
</html>
