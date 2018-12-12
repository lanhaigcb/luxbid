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
                        <div class="panel panel-default">
                            <div class="panel-heading">查询条件</div>
                            <div class="panel-body">
                                <form id="formSearch" class="form-horizontal">
                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-xs-1" for="productId"
                                               style="margin-left: -20px">产品名称：</label>
                                        <div class="col-sm-2">
                                            <select id="productId" name="productId" class=" form-control">
                                                <option value="">请选择</option>
                                                <c:forEach items="${listLoanCurrencyProductVo}" var="vo">
                                                    <option value="${vo.id}">${vo.symbol}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-sm-2" style="text-align:left;">
                                            <button type="button" style="margin-left:50px" id="search"
                                                    class="btn btn-primary">查询
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <div class="btn-group hidden-xs" id="convertTableToolbar" role="group">
                                <button type="button" id="addButton" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-plus" aria-hidden="true">新增</i>
                                </button>
                                <button type="button" id="updateButton" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-pencil" aria-hidden="true">修改</i>
                                </button>
                        </div>
                        <table id="bsTable" data-height="600" data-mobile-responsive="true">
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <!-- End Panel Other -->
    </div>
</div>
<script type="text/javascript" charset="UTF-8">
    $("#bsTable").bootstrapTable({
        url: "loanAmountRate/list.json",
        pagination: true,
        showColumns: true,     //是否显示所有的列
        showRefresh: true,     //是否显示刷新按钮
        sortable: false,      //是否启用排序
        sortOrder: "desc",     //排序方式
        queryParams: queryParams,
        sidePagination: "server",
        singleSelect: false,
        clickToSelect: true,
        toolbar: "#convertTableToolbar",
        pageSize: 10, //每页的记录行数（*）
        pageList: [10, 25, 50, 100], //可供选择的每页的行数（*）
        columns: [{
            checkbox: true
        }, {
            field: 'id',
            width: 100,
            align: 'center',
            title: 'ID'

        }, {
            field: 'symbol',
            width: 100,
            align: 'center',
            title: '符号'
        }, {
            field: 'minLimit',
            width: 100,
            align: 'center',
            title: '利率对应最低金额'
        }, {
            field: 'maxLimit',
            width: 100,
            align: 'center',
            title: '利率对应最高金额'
        }, {
            field: 'rate',
            width: 100,
            align: 'center',
            title: '利率'
        }, {
            field: 'enable',
            width: 100,
            align: 'center',
            title: '状态',
            formatter: function (value, row, index) {
                if (value) {
                    return '<span style="color: green;">启用</span>';
                } else {
                    return '<span style="color: red;">禁用</span>';
                }
            }
        }, {
            field: 'createTime',
            width: 100,
            align: 'center',
            title: '创建时间'
        }
        ]
    });

    //查询参数
    function queryParams(params) {
        params.productId = $("#productId").val();
        params.limit = params.limit;
        params.offset = params.offset;
        return params;
    }

    $("#search").on("click", function () {
        refresh();
    });

    //刷新
    function refresh() {
        $("#bsTable").bootstrapTable("refresh");
    }

    //新增
    $("#addButton").click(function () {
        layer.open({
            type: 2,
            title: '新增产品利率',
            shadeClose: true,
            shade: 0.8,
            area: ['50%', '50%'],
            content: 'loanAmountRate/add'
        });
    });

    //更新
    $("#updateButton").click(function () {
        var rows = $("#bsTable").bootstrapTable("getSelections");
        if (rows.length != 1) {
            layer.msg('请选择一行执行操作！');
            return
        }
        layer.open({
            type: 2,
            title: '修改产品利率',
            shadeClose: true,
            shade: 0.8,
            area: ['50%', '50%'],
            content: 'loanAmountRate/update?id=' + rows[0].id
        });
    });
</script>
</body>
</html>
