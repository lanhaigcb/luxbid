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
                        <div class="panel panel-default">
                            <div class="panel-heading">查询条件</div>
                            <div class="panel-body">
                                <form id="formSearch" class="form-horizontal">
                                    <%--<div class="form-group" style="margin-top:15px">--%>
                                        <%--<label class="control-label col-xs-1" for="name" style="margin-left: -20px">banner名称：</label>--%>
                                        <%--<div class="col-sm-2">--%>
                                            <%--<input type="text" class="form-control" id="name" placeholder="banner名称">--%>
                                        <%--</div>--%>
                                        <%--<label class="control-label col-xs-1" for="internationalType"--%>
                                               <%--style="margin-left: -20px">国际化类型：</label>--%>
                                        <%--<div class="col-sm-2">--%>
                                            <%--<select id="internationalType" class="form-control">--%>
                                                <%--<option value="">请选择</option>--%>
                                                <%--<option value="zh-cn">中国大陆</option>--%>
                                                <%--<option value="zh-tw">中国台湾</option>--%>
                                                <%--<option value="en-us">美国</option>--%>
                                            <%--</select>--%>
                                        <%--</div>--%>
                                        <%--<div class="col-sm-2" style="text-align:left;">--%>
                                            <%--<button type="button" style="margin-left:50px" id="search"--%>
                                                    <%--class="btn btn-primary">查询--%>
                                            <%--</button>--%>
                                        <%--</div>--%>
                                    <%--</div>--%>
                                </form>
                            </div>
                        </div>
                        <div class="btn-group hidden-xs" id="tableToolbar" role="group">
                                <button type="button" id="auditOne" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-pencil" aria-hidden="true">二级审核</i>
                                </button>
                        </div>
                        <table id="bannerTable" data-height="400" data-mobile-responsive="true">
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <!-- End Panel Other -->
    </div>
</div>
<script type="text/javascript" charset="UTF-8">
    (function ($) {
        $("#bannerTable").bootstrapTable({
            method: 'POST',
            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            url: "withdraw/auditTwo/list",
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
                field: 'recId',
                title: 'ID',
                width: 50,
                align: 'center'
            }, {
                field: 'customerId',
                title: '用户ID',
                width: 50,
                align: 'center'
            },
                {
                    field: 'symbol',
                    title: '币种',
                    width: 50,
                    align: 'center',

                }, {
                    field: 'amount',
                    title: '金额',
                    width: 50,
                    align: 'center',

                }, {
                    field: 'fee',
                    title: '手续费',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'account',
                    title: '用户帐户',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'realName',
                    title: '姓名',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'receiveAddress',
                    title: '接收地址',
                    width: 50,
                    align: 'center',

                }, {
                    field: 'applyTime',
                    title: '申请时间',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'withdrawStatus',
                    title: '状态',
                    width: 50,
                    align: 'center',
                    formatter:function(value,row,index) {
                        if (value == 'IN_AUDIT_LEVEL_2') {
                            return '等待复审';
                        } else {
                            return '其他状态';
                        }
                    }
                }
            ]
        });

        //查询参数
        function queryParams(params) {
            params.name = $("#name").val();
            params.internationalType = $("#internationalType").val();
            return params;
        }

        $("#search").on("click", function () {
            refresh()
        });
    })(jQuery);

    function refresh() {
        $("#bannerTable").bootstrapTable("refresh");
    }



    $("#auditOne").click(function () {
        var rows = $("#bannerTable").bootstrapTable("getSelections");
        if (rows.length != 1) {
            layer.msg('请选择一行执行操作！');
            return
        }
        layer.open({
            type: 2,
            title: '二级审核',
            shadeClose: true,
            shade: 0.8,
            area: ['80%', '90%'],
            content: 'withdraw/auditTwo/view?id=' + rows[0].recId
        });
    });
</script>
</body>
</html>
