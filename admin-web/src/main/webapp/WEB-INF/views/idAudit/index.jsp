<%@ taglib prefix="fn" uri="/func" %>
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
                        <fn:func url="idAudit/showInfo">
                        <div class="btn-group hidden-xs" id="tableToolbar" role="group">
                                <button type="button" id="idAudit" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-pencil" aria-hidden="true">审核信息</i>
                                </button>
                        </div>
                        </fn:func>
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
            url: "idAudit/list",
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
            pageSize : 10, //每页的记录行数（*）
            pageList : [ 10, 25, 50, 100 ], //可供选择的每页的行数（*）
            columns: [{
                checkbox: true
            }, {
                field: 'id',
                title: 'ID',
                width: 50,
                align: 'center'
            }, {
                field: 'customerId',
                title: '用户ID',
                width: 50,
                align: 'center'
            }, {
                field: 'realName',
                title: '姓名',
                width: 50,
                align: 'center',

            }, {
                field: 'idcardNumber',
                title: '身份证号',
                width: 50,
                align: 'center'
            }, {
                field: 'idInfoStatus',
                title: '审核状态',
                width: 50,
                align: 'center'
            }, {
                field: 'pics',
                title: '图片',
                width: 50,
                align: 'center',
                formatter: function (value, row, index) {
                    if (value == true) {
                        return '是';
                    } else if (value == false) {
                        return '否';
                    }
                }
            }, {
                field: 'createTime',
                title: '创建时间',
                width: 50,
                align: 'center'
            }
            ]
        });

        //查询参数
        function queryParams(params) {
            params.name = $("#name").val();
            params.internationalType = $("#internationalType").val();
            params.limit = params.limit;
            params.offset =params.offset;
            return params;
        }

        $("#search").on("click", function () {
            refresh()
        });
    })(jQuery);

    function refresh() {
        $("#bannerTable").bootstrapTable("refresh");
    }



    $("#idAudit").click(function () {
        var rows = $("#bannerTable").bootstrapTable("getSelections");
        if (rows.length != 1) {
            layer.msg('请选择一行执行操作！');
            return
        }
        layer.open({
            type: 2,
            title: '审核信息',
            shadeClose: true,
            shade: 0.8,
            area: ['90%', '90%'],
            content: 'idAudit/showInfo?id=' + rows[0].id
        });
    });
</script>
</body>
</html>
