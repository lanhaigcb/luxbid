<%@ page import="com.mine.common.enums.WhiteListApplyStatus" %>
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
                                        <label class="control-label col-xs-1" for="symbol" style="margin-left: -20px">交易对：</label>
                                        <div class="col-sm-2">
                                            <select id="symbol" name="symbol" class=" form-control">
                                                <option value="">请选择</option>
                                                <c:forEach items="${voList}" var="v" >
                                                    <option value="${v.symbol}">${v.symbol}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <label class="control-label col-xs-1" for="account" style="margin-left: -20px">帐号：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="account" name="account" placeholder="手机号或邮箱">
                                        </div>
                                        <label class="control-label col-xs-1" for="note" style="margin-left: -20px">备注：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="note" name="note" placeholder="申请备注">
                                        </div>
                                    </div>
                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-xs-1" for="applyStatus" style="margin-left: -20px">审核状态：</label>
                                        <div class="col-sm-2">
                                            <select id="applyStatus" class="form-control">
                                                <option value="" >请选择</option>
                                                <c:forEach var="v" items="<%=WhiteListApplyStatus.values()%>" >
                                                    <option value="${v.name()}">${v.toString()}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-sm-2" style="text-align:left;">
                                            <button type="button" style="margin-left:50px" id="search" class="btn btn-primary">查询</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <div class="btn-group" id="customTableToolbar" role="group">
                            <button type="button" id="pass" class="btn btn-outline btn-default">
                                <i class="glyphicon glyphicon-ok" aria-hidden="true"></i>审核
                            </button>
                        </div>
                        <table id="whitelistTable" data-height="400" data-mobile-responsive="true">
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
        $("#whitelistTable").bootstrapTable({
            method: 'POST',
            contentType:"application/x-www-form-urlencoded; charset=UTF-8",
            url:"whitelist/list",
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
                field: 'symbol',
                title: '交易对',
                width:50,
                align:'center'
            }, {
                field: 'account',
                title: '用户帐户',
                width:50,
                align:'center'
            },{
                field: 'realName',
                title: '用户姓名',
                width:50,
                align:'center'
            },{
                field: 'idCardNo',
                title: '身份证号码',
                width:50,
                align:'center'
            },{
                field: 'applyStatus',
                title: '申请状态',
                width:50,
                align:'center',
                formatter:function(value,row,index) {
                    return value.value;
                }
            },{
                field: 'note',
                title: '申请备注',
                width:50,
                align:'center'
            }, {
                field: 'applyStaffName',
                title: '申请操作员',
                width:50,
                align:'center'
            }, {
                field: 'createTime',
                title: '创建时间',
                width:50,
                align:'center'
            }, {
                field: 'updateTime',
                title: '最近更新时间',
                width:50,
                align:'center'
            }
            ]
        });

        //查询参数
        function queryParams(params) {
            params.symbol = $("#symbol").val();
            params.account = $("#account").val();
            params.note = $("#note").val();
            params.applyStatus = $("#applyStatus").val();
            params.size = params.limit;
            params.offset =params.offset;
            return params;
        }
        $("#search").on("click",function(){
            refresh()
        });
    })(jQuery);

    function refresh(){
        $("#whitelistTable").bootstrapTable("refresh");
    }


    $("#pass").click(function () {
        var rows = $("#whitelistTable").bootstrapTable("getSelections");
        if(rows.length != 1){
            layer.msg('请选择一行执行操作！');
            return
        }
        layer.open({
            title:'审核',
            type: 2,
            fix: false, //不固定
            maxmin: true,
            area: ['60%', '65%'],
            content: 'whitelist/auditInput?id='+rows[0].id
        });
    });

</script>
</body>
</html>
