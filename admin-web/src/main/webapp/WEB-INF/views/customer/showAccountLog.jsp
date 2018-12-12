<%@ taglib prefix="fn" uri="/func" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<%@include file="../common/head-title.jsp"%>
<body class="gray-bg">
<div class="wrapper wrapper-content animated fadeInRight">
    <!-- Panel Other -->
    <fn:func url="customer/manage/page">
        <div class="ibox float-e-margins">

            <div class="ibox-content">
                <div class="row row-lg">
                    <div class="col-sm-12">
                        <div class="panel-body" style="padding-bottom:0px;">
                            <table id="accountLogTable" data-height="400" data-mobile-responsive="true">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <!-- End Panel Other -->
        </div>
    </fn:func>
</div>
<script type="text/javascript" charset="UTF-8">
    (function($){

        //查询参数
        function queryParams(params) {
            params.customerId = "${customerId}";
            params.subAccountId = "${subAccountId}";
            params.limit = params.limit;
            params.offset = params.offset;
            return params;
        }

        $("#accountLogTable").bootstrapTable({
            url:"customer/queryCustomerAccountLog",
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
            toolbar:"#accountLogTableToolbar",
            height:800,
            pageSize:100,
            pageList:[10,25,50,100, 200],
            columns: [{
                checkbox: true
            }, {
                field: 'id',
                title: 'ID',
                width:100,
                align:'center'
            },{
                field: 'accountLogType',
                title: '操作类型',
                width:100,
                align:'center',
                formatter:function(value,row,index) {
                    if (value!="" && value!=null){
                        return value.value;
                    }}
            },{
                field: 'operateAmount',
                title: '操作金额',
                width:100,
                align:'center'
            }, {
                field: 'availableAmount',
                title: '可用余额',
                width:200,
                align:'center'
            }, {
                field: 'frozenAmount',
                title: '冻结余额',
                width:200,
                align:'center'
            }, {
                field: 'createTime',
                title: '创建时间',
                width:200,
                align:'center'
            }
            ]
        });

    })(jQuery);



</script>
</body>
</html>
