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
                                        <label class="control-label col-xs-1" for="exchangeId"
                                               style="margin-left: -20px">交易对：</label>
                                        <div class="col-sm-2">
                                            <select id="exchangeId" class="form-control">
                                                <option value="">请选择</option>
                                                <c:forEach items="${voList}" var="v">
                                                    <option value="${v.id}">${v.symbol}</option>
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
                        </div>--%>
                        <div class="btn-group hidden-xs" id="tableToolbar" role="group">
                            <%--<fn:func url="affiche/lookInput">
                                <button type="button" id="look" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-plus" aria-hidden="true">查看分类</i>
                                </button>
                            </fn:func>--%>
                                <button type="button" id="add" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-plus" aria-hidden="true">新增分区</i>
                                </button>

                                <button type="button" id="update" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-pencil" aria-hidden="true">更新分区</i>
                                </button>
                        </div>
                        <table id="helpTable" data-height="400" data-mobile-responsive="true">
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
        $("#helpTable").bootstrapTable({
            method: 'POST',
            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            url: "exchangePartition/list",
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
            pageSize: 10, //每页的记录行数（*）
            pageList: [10, 25, 50, 100], //可供选择的每页的行数（*）
            columns: [{
                checkbox: true
            }, {
                field: 'id',
                title: 'ID',
                width: 50,
                align: 'center'
            }, {
                field: 'name',
                title: '分区名称',
                width: 50,
                align: 'center'
            }, {
                field: 'createTime',
                title: '创建时间',
                width: 50,
                align: 'center'
            }, {
                field: 'updateTime',
                title: '最近更新时间',
                width: 50,
                align: 'center'
            }, {
                field: 'sortParameter',
                title: '排序参数',
                width: 50,
                align: 'center'
            }
            ]
        });

        //查询参数
        function queryParams(params) {
            params.exchangeId = $("#exchangeId").val();
            params.limit = params.limit;
            params.offset = params.offset;
            return params;
        }

        $("#search").on("click", function () {
            refresh()
        });
    })(jQuery);

    function refresh() {
        $("#helpTable").bootstrapTable("refresh");
    }

    //$("#look").click(function () {
    //    var rows = $("#helpTable").bootstrapTable("getSelections");
    //    if(rows.length != 1){
    //        layer.msg('请选择一行执行操作！');
    //        return
    //    }
    //    layer.open({
    //        type: 2,
    //        title: '查看分类',
    //        shadeClose: true,
    //        shade: 0.8,
    //        area: ['80%', '90%'],
    //        content: 'affiche/lookInput?id='+rows[0].id
    //    });
    //});

    $("#add").click(function () {
        layer.open({
            type: 2,
            title: '新增分区',
            shadeClose: true,
            shade: 0.8,
            area: ['80%', '90%'],
            content: 'exchangePartition/addInput'
        });
    });

    $("#update").click(function () {
        var rows = $("#helpTable").bootstrapTable("getSelections");
        if (rows.length != 1) {
            layer.msg('请选择一行执行操作！');
            return
        }
        layer.open({
            type: 2,
            title: '编辑分区',
            shadeClose: true,
            shade: 0.8,
            area: ['80%', '90%'],
            content: 'exchangePartition/updateInput?id=' + rows[0].id
        });
    });
</script>
</body>
</html>
