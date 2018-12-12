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
<script type="text/javascript" charset="UTF-8">
    (function($){

        //查询参数
        function queryParams(params) {
            params.customerId = "${customerId}";
            return params;
        }

        $("#customDetailTable").bootstrapTable({
            url:"c2cCustomer/statistic",
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
                field: 'symbol',
                title: '币种',
                width:100,
                align:'center'
            }, {
                field: 'sellCount',
                title: '买入数量',
                width: 50,
                align: 'center'
            }, {
                field: 'sellAmount',
                title: '买入金额',
                width: 50,
                align: 'center'
            }, {
                field: 'tradeRecoveryCount',
                title: '卖出数量',
                width: 50,
                align: 'center'
            }, {
                field: 'tradeRecoveryAmount',
                title: '卖出金额',
                width: 50,
                align: 'center'
            }

            ]
        });
    })(jQuery);

</script>
</body>
</html>
