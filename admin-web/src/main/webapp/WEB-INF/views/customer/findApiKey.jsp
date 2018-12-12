<%@ page contentType="text/html;charset=UTF-8" language="java" %><!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp"%>
<!DOCTYPE html>
<html>
    <%@include file="../common/head-title.jsp"%>
    <%@include file="../common/kindeditor.jsp" %>
    <script src="theme/js/custom/staff/form-validate-banner.min.js"></script>
<body class="gray-bg">
<div class="wrapper wrapper-content animated fadeInRight">
    <!-- Panel Other -->
    <div class="ibox float-e-margins">
        <div class="ibox-content">
            <div class="row row-lg">
                <div class="col-sm-12">
                    <div class="panel-body" style="padding-bottom:0px;">
                        <div class="col-sm-12">
                            <div class="btn-group" id="customeApiTableToolbar" role="group">
                                <button type="button" id="unableAPIKEYButton" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-trash" aria-hidden="true"></i>禁用APIKEY
                                </button>
                                <button type="button" id="ableAPIKEYButton" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-ok" aria-hidden="true"></i>启用APIKEY
                                </button>
                            </div>
                            <table id="customeApiTable" data-height="400" data-mobile-responsive="true">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript" charset="UTF-8">

    //查询参数
    function queryParams(params) {
        params.customerId = "${customerApiVo.customerId}";
        return params;
    }
    //        var isFirst = true;
    (function ($) {
        $("#customeApiTable").bootstrapTable({
            url: "customer/findApiKeyList",
            pagination: true,
            method: 'POST',
            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            showColumns: false,     //是否显示所有的列
            showRefresh: false,     //是否显示刷新按钮
            sortable: false,      //是否启用排序
            sortOrder: "asc",     //排序方式
            queryParams:queryParams,
            sidePagination: "server",
            clickToSelect: true,
            singleSelect: false,
            toolbar: "#customeApiTableToolbar",
            height: 550,
            pageSize: 10, //每页的记录行数（*）
            pageList: [10, 25, 50, 100], //可供选择的每页的行数（*）
            columns: [{
                checkbox: true
            }, {
                field: 'id',
                title: 'ID',
                width: 100,
                align: 'center'
            }, {
                field: 'accessKey',
                title: 'accessKey',
                width: 200,
                align: 'center'
            }, {
                field: 'secret',
                title: 'secret',
                width: 400,
                align: 'center'
            }, {
                field: 'ip',
                title: 'ip',
                width: 100,
                align: 'center'
            }, {
                field: 'remark',
                title: 'remark',
                width: 200,
                align: 'center'
            }, {
                field: 'createTime',
                title: '创建时间',
                width: 100,
                align: 'center'
            }, {
                field: 'enable',
                title: '启用',
                width: 100,
                align: 'center',
                formatter: function (value, row, index) {
                    if (value) {
                        return '<span style="color: green;">是</span>';
                    } else {
                        return '<span style="color: red;">否</span>';
                    }
                }
            }
            ]
        });

        $("#ableAPIKEYButton").click(function () {
            var rows = $("#customeApiTable").bootstrapTable("getSelections");
            if (rows.length != 1) {
                layer.msg('请选择一行执行操作！');
                return
            }
            $.ajax({
                url: "customer/updateApiKeyStatus",
                data: {id: rows[0].id, enable: true},
                success: function (data) {
                    if (data.result) {
                        swal("启用成功！", "您已经设置了这条信息。", "success");
                    } else {
                        swal("设置失败！", "设置中出现问题：" + data.message, "warning");
                    }
                    refresh();
                },
                error: function () {
                    swal("设置失败！", "请求错误。", "error");
                }
            });
        });

        $("#unableAPIKEYButton").click(function () {
            var rows = $("#customeApiTable").bootstrapTable("getSelections");
            if (rows.length != 1) {
                layer.msg('请选择一行执行操作！');
                return
            }
            $.ajax({
                url: "customer/updateApiKeyStatus",
                data: {id: rows[0].id, enable: false},
                success: function (data) {
                    if (data.result) {
                        swal("禁用成功！", "您已经设置了这条信息。", "success");
                    } else {
                        swal("设置失败！", "设置中出现问题：" + data.message, "warning");
                    }
                    refresh();
                },
                error: function () {
                    swal("设置失败！", "请求错误。", "error");
                }
            });
        });
    })(jQuery);
</script>
</body>
</html>