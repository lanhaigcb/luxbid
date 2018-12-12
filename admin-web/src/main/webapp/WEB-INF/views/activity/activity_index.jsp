<%@ taglib prefix="fn" uri="/func" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
                        </div>
                        <div class="btn-group hidden-xs" id="convertTableToolbar" role="group">
                            <button type="button" id="addButton" class="btn btn-outline btn-default">
                                <i class="glyphicon glyphicon-plus" aria-hidden="true">新增活动方案</i>
                            </button>
                            <%--<button type="button" id="updateButton" class="btn btn-outline btn-default">
                                <i class="glyphicon glyphicon-pencil" aria-hidden="true">修改活动方案</i>
                            </button>--%>
                            <button type="button" id="openButton" class="btn btn-outline btn-default">
                                <i class="glyphicon glyphicon-ok" aria-hidden="true"></i>启用
                            </button>
                            <button type="button" id="closeButton" class="btn btn-outline btn-default">
                                <i class="glyphicon glyphicon-trash" aria-hidden="true"></i>禁用
                            </button>
                        </div>
                        <table id="convertTable" data-height="600" data-mobile-responsive="true">
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <!-- End Panel Other -->
    </div>
</div>

<script type="text/javascript" charset="UTF-8">
    var $table = $("#convertTable");
    $table.bootstrapTable({
        url: "activity/list.json",
        pagination: true,
        showColumns: true,     //是否显示所有的列
        showRefresh: true,     //是否显示刷新按钮
        sortable: false,      //是否启用排序
        sortOrder: "desc",     //排序方式
        queryParams: queryParams,
        sidePagination: "server",
        singleSelect: true,
        clickToSelect: true,
        toolbar: "#convertTableToolbar",
        pageSize : 10, //每页的记录行数（*）
        pageList : [ 10, 25, 50, 100 ], //可供选择的每页的行数（*）
        columns: [{
            checkbox: true
        }, {
            field: 'id',
            width: 100,
            align: 'center',
            title: 'ID'

        }, {
            field: 'activityName',
            width: 100,
            align: 'center',
            title: '活动名称'
        }, {
            field: 'lotteryNumber',
            width: 100,
            align: 'center',
            title: '抽奖次数'
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
        },{
            field: 'createTime',
            width: 100,
            align: 'center',
            title: '创建时间'
        }
        ]
    });

    //启用
    $("#openButton").click(function () {
        var rows = $("#convertTable").bootstrapTable("getSelections");
        if (rows.length != 1) {
            layer.msg('请选择一行执行操作！');
            return
        }
        if(rows[0].enable){
            layer.msg('该方案已经启用！');
            return;
        }else{
            editEnable(rows[0].id, 1);
        }

    });

    //禁用
    $("#closeButton").click(function () {
        var rows = $("#convertTable").bootstrapTable("getSelections");
        if (rows.length != 1) {
            layer.msg('请选择一行执行操作！');
            return
        }
        if(rows[0].enable){
            editEnable(rows[0].id, 0);
        }else{
            layer.msg('该方案已经禁用！');
            return;
        }

    });

    //更新状态
    function editEnable(id, enable) {
        $.ajax({
            url: 'activity/editEnable',
            data: {id: id, enable: enable},
            success: function (data) {
                if (!data.result) {
                    layer.msg(data.message)
                }
                refresh();
            }
        })
    }


    //查询参数
    function queryParams(params) {
        params.limit = params.limit;
        params.offset =params.offset;
        return params;
    }

    $("#search").on("click", function () {
        refresh();
    });

    //刷新
    function refresh() {
        $table.bootstrapTable("refresh");
    }

    //新增
    $("#addButton").click(function () {
        layer.open({
            type: 2,
            title: '新增活动方案',
            shadeClose: true,
            shade: 0.8,
            area: ['50%', '50%'],
            content: 'activity/add'
        });
    });

    //更新
    $("#updateButton").click(function () {
        var rows = $("#convertTable").bootstrapTable("getSelections");
        if (rows.length != 1) {
            layer.msg('请选择一行执行操作！');
            return
        }
        layer.open({
            type: 2,
            title: '修改活动方案',
            shadeClose: true,
            shade: 0.8,
            area: ['50%', '50%'],
            content: 'activity/update?id=' + rows[0].id
        });
    });
</script>

</body>
</html>
