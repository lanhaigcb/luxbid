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
                        <%--<div class="panel panel-default">
                            <div class="panel-heading">查询条件</div>
                            <div class="panel-body">
                                <form id="formSearch" class="form-horizontal">
                                    <div class="form-group" style="margin-top:15px">

                                        <label class="control-label col-sm-1" for="datepicker">时间：</label>
                                        <div class="col-sm-4 form-group">
                                            <div style="text-align:left;">
                                                <div class="input-daterange input-group" id="datepicker">
                                                    <input type="text" class="input-sm form-control" name="start" id="startDate" value="" />
                                                    <span class="input-group-addon">到</span>
                                                    <input type="text" class="input-sm form-control" name="end" id ="endDate" value="" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-1" style="text-align:left;">
                                            <button type="button"  id="search" class="btn btn-primary">查询</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>--%>
                        <%--<table id="registerCountTable" data-height="400" data-mobile-responsive="true">
                        </table>--%>
                        <div class="col-sm-12">
                            <h1 align="center" class=""> 统计信息 </h1>
                        </div>
                        <div class="col-sm-12">
                            <div id="main" style="width: 100%;height:400px;">
                                <table class="table table-bordered">
                                    <thead>
                                    <tr>
                                        <th>名称</th>
                                        <th>统计</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <fn:func url="welcome/totalRecharge">
                                    <tr>
                                        <td>充值总金额</td>
                                        <td>${allRecharge==null?0:allRecharge}</td>
                                    </tr>
                                    </fn:func>
                                    <fn:func url="welcome/regCount">
                                    <tr>
                                        <td>注册总人数</td>
                                        <td>${allUser==null?0:allUser}</td>
                                    </tr>
                                    </fn:func>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- End Panel Other -->
    </div>
</div>
<script src="theme/js/plugins/echarts/echarts.min.js"></script>
<script type="text/javascript" charset="UTF-8">
    (function ($) {
        $("#datepicker").datepicker({
            keyboardNavigation: !1,
            forceParse: !1,
            autoclose: !0
        });

        $("#startDate").val(getPreMonthDay(new Date()));
        $("#endDate").val(getNowMonthDay(new Date()));

        /*$("#registerCountTable").bootstrapTable({
            url:"customer/report/register/count",
            pagination:true,
            showColumns: true,     //是否显示所有的列
            showRefresh: true,     //是否显示刷新按钮
            sortable: false,      //是否启用排序
            sortOrder: "asc",     //排序方式
            queryParams:queryParams,
            sidePagination: "server",
            singleSelect:true,
            clickToSelect:true,
            toolbar:"#",
            columns: [{
                checkbox: true
            }, {
                field: 'channelId',
                title: '渠道号',
                width:100,
                align:'center'
            }, {
                field: 'registerTime',
                title: '注册时间',
                width:100,
                align:'center'
            }, {
                field: 'registerCount',
                title: '注册用户统计',
                width:100,
                align:'center'
            }, {
                field: 'buyCount',
                title: '购买次数统计',
                width:100,
                align:'center'
            }
            ]
        });*/

        //查询参数
        function queryParams(params) {
            params.reportDateType = $("#reportDateType").val();
            params.startDate = $("#startDate").val();
            params.endDate = $("#endDate").val();
            params.channelId = $("#channelId").val();
            return params;
        }

        $("#search").on("click", function () {
            refresh()
        });
    })(jQuery);


    function refresh() {
        $("#registerCountTable").bootstrapTable("refresh");
    }

</script>
</body>
</html>
