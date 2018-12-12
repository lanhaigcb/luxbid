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
                            <select id="activityId" name="activityId" class=" form-control" style="width:200px;">
                                <c:forEach items="${listActivityVo}" var="v">
                                    <option value="${v.id}">${v.activityName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="btn-group hidden-xs" id="convertTableToolbar" role="group">
                            <button type="button" id="addButton" class="btn btn-outline btn-default">
                                <i class="glyphicon glyphicon-plus" aria-hidden="true">新增</i>
                            </button>
                            <button type="button" id="updateButton" class="btn btn-outline btn-default">
                                <i class="glyphicon glyphicon-pencil" aria-hidden="true">修改</i>
                            </button>
                            <button type="button" id="delteButton" class="btn btn-outline btn-default">
                                <i class="glyphicon glyphicon-ok" aria-hidden="true"></i>删除
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
        url: "activityConfig/list.json",
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
            title: '奖励币种'
        }, {
            field: 'awardNum',
            width: 100,
            align: 'center',
            title: '奖励数量'
        }, {
            field: 'prob',
            width: 100,
            align: 'center',
            title: '奖励概率(%)'
        }
        ]
    });

    //禁用
    $("#delteButton").click(function () {
        var rows = $("#convertTable").bootstrapTable("getSelections");
        if (rows.length != 1) {
            layer.msg('请选择一行执行操作！');
            return
        }
        editStatus(rows[0].id);
    });

    //更新状态
    function editStatus(id) {
        $.ajax({
            url: 'activityConfig/editStatus',
            data: {id: id},
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
        params.activityId = $("#activityId").val();
        params.limit = params.limit;
        params.offset = params.offset;
        return params;
    }

    $("#activityId").on("change", function () {
        refresh();
    });

    //刷新
    function refresh() {
        $table.bootstrapTable("refresh");
    }

    //新增
    $("#addButton").click(function () {
        var activityId=$("#activityId").val();
        layer.open({
            type: 2,
            title: '新增活动方案',
            shadeClose: true,
            shade: 0.8,
            area: ['50%', '50%'],
            content: 'activityConfig/add?activityId='+activityId
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
            content: 'activityConfig/update?id=' + rows[0].id
        });
    });
</script>

</body>
</html>
