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
                            <%--<div class="panel-heading">查询条件</div>
                            <div class="panel-body">
                                <form id="formSearch" class="form-horizontal">
                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-sm-1" for="username">姓名</label>
                                        <div class="col-sm-4">
                                            <input type="text" class="form-control" id="username">
                                        </div>
                                        <label class="control-label col-sm-1" >状态</label>
                                        <div class="col-sm-4">
                                           <div class="radio">
                                                <input type="radio" id="singleRadio1" value="option1" name="radioSingle1" aria-label="Single radio One">
                                                <label></label>
                                            </div>
                                        </div>
                                        <div class="col-sm-2" style="text-align:left;">
                                            <button type="button" style="margin-left:50px" id="search" class="btn btn-primary">查询</button>
                                        </div>
                                    </div>
                                </form>
                            </div>--%>
                        </div>
                        <div class="btn-group hidden-xs" id="convertTableToolbar" role="group">
                                <button type="button" id="add" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-plus" aria-hidden="true">新增活动奖励</i>
                                </button>
                                <button type="button" id="updateInput" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-pencil" aria-hidden="true">修改活动奖励</i>
                                </button>
                            <%--<button type="button" id="delete" class="btn btn-outline btn-default">
                                <i class="glyphicon glyphicon-trash" aria-hidden="true"></i>
                            </button>--%>
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
        url: "awardConfig/list.json",
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
            field: 'awardConfigName',
            width: 100,
            align: 'center',
            title: '奖励活动名称'
        }, {
            field: 'symbol',
            width: 100,
            align: 'center',
            title: '奖励活动币种'
        }, {
            field: 'awardNumTotal',
            width: 100,
            align: 'center',
            title: '奖励活动总数'
        }, {
            field: 'createTime',
            width: 100,
            align: 'center',
            title: '创建时间'
        }
        ]
    });

    //启用
    function enable(id) {
        updateStatus(id, "enable");
    }

    //禁用
    function unEnable(id) {
        updateStatus(id, "unEnable");
    }

    //更新状态
    function updateStatus(id, status) {
        $.ajax({
            url: 'convert/updateStatus',
            data: {id: id, status: status},
            success: function (data) {
                if (data.result) {
                    if ("enable" == status) {
                        layer.msg("已启用");
                    } else {
                        layer.msg("已禁用");
                    }
                } else {
                    layer.msg("操作失败")
                }
                refresh();
            }
        })
    }


    //查询参数
    function queryParams(params) {
        params.toSymbol = $("#toSymbol").val();
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


    //一些事件实例
    var e = $("#examplebtTableEventsResult");
    $table.on("all.bs.table", function (e, t, o) {
        console.log("Event:", t, ", data:", o)
    })
        .on("click-row.bs.table", function () {
            var ids = $("#exampleTableFromData").bootstrapTable("getSelections");
            console.log(ids)
            e.text(ids)
        })
        .on("dbl-click-row.bs.table", function () {
            e.text("Event: dbl-click-row.bs.table")
        })
        .on("sort.bs.table", function () {
            e.text("Event: nihao")
        })
        .on("check.bs.table", function () {
            e.text("Event: check.bs.table")
        })
        .on("uncheck.bs.table", function () {
            e.text("Event: uncheck.bs.table")
        })
        .on("check-all.bs.table", function () {
            e.text("Event: check-all.bs.table")
        })
        .on("uncheck-all.bs.table", function () {
            e.text("Event: uncheck-all.bs.table")
        })
        .on("load-success.bs.table", function () {
            e.text("Event: load-success.bs.table")
        })
        .on("load-error.bs.table", function () {
            e.text("Event: load-error.bs.table")
        })
        .on("column-switch.bs.table", function () {
            e.text("Event: column-switch.bs.table")
        })
        .on("page-change.bs.table", function () {
            e.text("Event: page-change.bs.table")
        })
        .on("search.bs.table", function () {
            console.log("表格刷新按钮了")
        })

    //新增活动奖励
    $("#add").click(function () {
        layer.open({
            type: 2,
            title: '新增奖励活动',
            shadeClose: true,
            shade: 0.8,
            area: ['80%', '90%'],
            content: 'awardConfig/addInput'
        });
    });

    //更新活动奖励
    $("#updateInput").click(function () {
        var rows = $("#convertTable").bootstrapTable("getSelections");
        if (rows.length != 1) {
            layer.msg('请选择一行执行操作！');
            return
        }
        layer.open({
            type: 2,
            title: '修改奖励活动',
            shadeClose: true,
            shade: 0.8,
            area: ['80%', '90%'],
            content: 'awardConfig/updateInput?id=' + rows[0].id
        });
    });
</script>

</body>
</html>
