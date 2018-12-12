<%@ page contentType="text/html;charset=UTF-8" language="java" %><!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp"%>
<!DOCTYPE html>
<html>
    <%@include file="../common/head-title.jsp"%>
    <script src="theme/js/custom/staff/form-validate-banner.min.js"></script>
<body class="">
<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <input type="hidden" id="nodeId" value="${id}">
                    <table id="cfdTransfer" data-height="400" data-mobile-responsive="true">

                    </table>

                </div>
            </div>
        </div>
    </div>
</div>

</body>
    <script>
        $("#datepicker").datepicker({
            keyboardNavigation: !1,
            forceParse: !1,
            autoclose: !0,
        });
        (function($){
            $("#cfdTransfer").bootstrapTable({
                method: 'POST',
                contentType:"application/x-www-form-urlencoded; charset=UTF-8",
                url:"cfdNode/transfers",
                pagination:true,
                showColumns: true,     //是否显示所有的列1
                showRefresh: true,     //是否显示刷新按钮
                sortable: false,      //是否启用排序
                sortOrder: "asc",     //排序方式
                sidePagination: "server",
                queryParams: queryParams,
                clickToSelect:true,
                singleSelect:true,
                toolbar:"#tableToolbar",
                height:500,
                columns: [{
                    checkbox: true
                }, {
                    field: 'createTime',
                    title: '日期',
                    width:50,
                    align:'center'
                },{
                    field: 'type',
                    title: '划转方向',
                    width:50,
                    align:'center'
                },{
                    field: 'amount',
                    title: '数量',
                    width:50,
                    align:'center'
                }
                ]
            });
            function queryParams(params) {
                params.id = $("#nodeId").val();


                return params;
            }
            $("#search").on("click",function(){
                refresh()
            });
        })(jQuery);

    </script>
</html>