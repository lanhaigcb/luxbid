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
                                        <label class="control-label col-xs-1" for="cfdRewardApplyStatus" style="margin-left: 0px">奖励状态：</label>
                                        <div class="col-sm-2">
                                            <select id="cfdRewardApplyStatus" name="cfdRewardApplyStatus" class=" form-control">
                                                <option value="">请选择</option>
                                                <option value="APPLYING">申请中</option>
                                                <option value="COMPLETED">已完成</option>
                                                <option value="REJECTED">已拒绝</option>
                                            </select>
                                        </div>
                                        <div class="col-sm-2" style="text-align:left;">
                                            <button type="button" id="search" class="btn btn-primary">查询</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <div class="btn-group hidden-xs" id="tableToolbar" role="group">
                                <button type="button" id="transfer" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-plus" aria-hidden="true">订单记录</i>
                                </button>
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
    (function($){
        $("#currencyTable").bootstrapTable({
            method: 'POST',
            contentType:"application/x-www-form-urlencoded; charset=UTF-8",
            url:"cfdTransferRewardApply/list",
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
                field: 'customerId',
                title: 'uid',
                width:50,
                align:'center'
            },{
                field: 'mobile',
                title: '手机号',
                width:50,
                align:'center'
            }, {
                field: 'rewardAmount',
                title: '奖励数量',
                width:50,
                align:'center'
            }, {
                field: 'recordId',
                title: '记录信息',
                width:50,
                align:'center'
            }, {
                field: 'applyStatus',
                title: '奖励状态',
                width:50,
                align:'center',
                formatter:function(value,row,index) {
                    if(value == "APPLYING"){
                        return "申请中";
                    }
                    if(value == "COMPLETED"){
                        return "已完成";
                    }
                    if(value == "REJECTED"){
                        return "已拒绝";
                    }
                }
                },{
                    title: '操作',
                    width: 50,
                    align: 'center',
                    formatter: function (value, row, index) {
                        var html = "";
                        if(row.applyStatus=="APPLYING"){
                            html += "<input type='button' class='btn btn-danger' onclick='change("+row.recordId+")'  value='一键转账' />&nbsp;";
                        }
                        return html;
                }
                }
            ]
        });

        //查询参数
        function queryParams(params) {
            params.cfdRewardApplyStatus = $("#cfdRewardApplyStatus").val();
            return params;
        }
        $("#search").on("click",function(){
            refresh()
        });
    })(jQuery);

    function refresh(){
        $("#currencyTable").bootstrapTable("refresh");
    }


    function change(id) {

        layer.confirm('确认转账吗？', {
            btn: ['确认','取消'] //按钮
        }, function(){
            $.ajax({
                type: "POST",
                url: "cfdTransferRewardApply/transfer",
                data: {id: id},
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

    $("#transfer").click(function () {
        var rows = $("#currencyTable").bootstrapTable("getSelections");
        if(rows.length != 1){
            layer.msg('请选择一行执行操作！');
            return
        }
        layer.open({
            type: 2,
            title: '查看订单记录信息',
            shadeClose: true,
            shade: 0.8,
            area: ['80%', '90%'],
            content: 'cfdTransferRewardApply/orders?id='+rows[0].recordId
        });
    });
</script>
</body>
</html>
