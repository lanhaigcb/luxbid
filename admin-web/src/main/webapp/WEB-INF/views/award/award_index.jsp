<%@ taglib prefix="fn" uri="/func" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="b" %>
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
                        </div>
                        <div class="btn-group hidden-xs" id="convertTableToolbar" role="group">
                            <fn:func url="award/import">
                                <form id="importFrom" action="award/import" method="post" enctype="multipart/form-data">
                                    <input class="btn btn-outline btn-default" type="file" id="uploadFile"
                                           name="uploadFile"/>
                                </form>
                                <button type="button" id="importBatch" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-pencil" aria-hidden="true">批量发放</i>
                                </button>
                            </fn:func>
                            <fn:func url="award/sengReward">
                                <button type="button" id="sengReward" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-pencil" aria-hidden="true">发放奖励</i>
                                </button>
                            </fn:func>
                            <fn:func url="award/deleteAwardGrant">
                                <button type="button" id="deleteAwardGrant" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-pencil" aria-hidden="true">删除发放记录</i>
                                </button>
                            </fn:func>
                        </div>
                        <div class="btn-group hidden-xs" id="tableToolbar" role="group">
                            <label class="control-label col-xs-1">活动名称：</label>
                            <div class="col-sm-2">
                                <select class="form-control" id="grantName" name="grantName">
                                    <option value="请选择">请选择</option>
                                    <c:forEach items="${awardConfigs}" var="awardConfig">
                                        <option value="${awardConfig.id}">${awardConfig.awardConfigName}</option>
                                    </c:forEach>
                                </select>
                            </div>
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
        url: "grant/list.json",
        pagination: true,
        showColumns: true,     //是否显示所有的列
        showRefresh: true,     //是否显示刷新按钮
        sortable: false,      //是否启用排序
        sortOrder: "desc",     //排序方式
        queryParams: queryParams,
        sidePagination: "server",
        singleSelect: false,
        clickToSelect: true,
        toolbar: "#awardTableToolbar",
        pageSize : 10, //每页的记录行数（*）
        pageList : [ 10, 50 , 100, 500, 1000 ], //可供选择的每页的行数（*）
        columns: [{
            checkbox: true
        }, {
            field: 'id',
            width: 100,
            align: 'center',
            title: 'ID'

        }, {
            field: 'customerId',
            width: 100,
            align: 'center',
            title: '账户ID'
        }, {
            field: 'customerAccount',
            width: 100,
            align: 'center',
            title: '用户账户'
        }, {
            field: 'symbol',
            width: 100,
            align: 'center',
            title: '发放币种'
        }, {
            field: 'awardNum',
            width: 100,
            align: 'center',
            title: '发放币种数'
        }, {
            field: 'reason',
            width: 100,
            align: 'center',
            title: '奖励原因'
        }, {
            field: 'awardStatus',
            width: 100,
            align: 'center',
            title: '发放状态',
            formatter: function (value, row, index) {
                if (value == 'WAITING') {
                    return '待发放';
                } else if (value == false) {
                    return '否';
                }
            }
        }, {
            field: 'senderAccount',
            width: 100,
            align: 'center',
            title: '发放人账号'
        }, {
            field: 'senderRealName',
            width: 100,
            align: 'center',
            title: '发放人姓名'
        }, {
            field: 'createTime',
            width: 100,
            align: 'center',
            title: '创建时间'
        }]
    });
    $("#importBatch").click(function () {
        importEmp();
    });

    function importEmp() {
        //检验导入的文件是否为Excel文件
        var uploadFile = document.getElementById("uploadFile").value;
        if (uploadFile == null || uploadFile == '') {
            alert("请选择要上传的Excel文件");
            return;
        } else {
            var fileExtend = uploadFile.substring(uploadFile.lastIndexOf('.')).toLowerCase();
            if (fileExtend == '.xls' || fileExtend == '.xlsx') {
            } else {
                alert("文件格式需为'.xls'或'.xlsx'格式");
                return;
            }
        }
        //提交表单
        document.getElementById("importFrom").submit();
        $table.bootstrapTable("refresh");
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

    //新增发放奖励
    $("#add").click(function () {
        layer.open({
            type: 2,
            title: '兑换信息管理',
            shadeClose: true,
            shade: 0.8,
            area: ['80%', '90%'],
            content: 'convert/addInput'
        });
    });

    //删除发放记录
    $("#deleteAwardGrant").click(function () {
        var rows = $("#convertTable").bootstrapTable("getSelections");
        var ids = "";
        if (rows.length == 0) {
            layer.msg('请选择您要删除的记录！');
            return;
        } else {
            for (var i = 0; i < rows.length; i++) {
                if (ids == "") {
                    ids = rows[i].id
                } else {
                    ids += "," + rows[i].id
                }
            }
        }
        swal({
            title: "您确定要删除这条信息吗",
            text: "删除后将无法恢复，请谨慎操作！",
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "删除",
            closeOnConfirm: false
        }, function () {
            $.ajax({
                url: "award/deleteAwardGrant",
                data: {ids: ids},
                success: function (data) {
                    if (data.result) {
                        swal("删除成功！", "您已经删除了这条信息。", "success");
                    } else {
                        swal("删除失败！", "删除中出现问题：" + data.message, "warning");
                    }
                    refresh();
                },
                error: function () {
                    swal("删除失败！", "请求错误。", "error");
                }
            });
        });
    });

    //发放奖励
    $("#sengReward").click(function () {
        var grantName = $("#grantName").val();
        if (grantName == "请选择") {
            layer.msg('请选择活动名称');
            return;
        }
        var rows = $("#convertTable").bootstrapTable("getSelections");
        var ids = "";
        if (rows.length == 0) {
            layer.msg('请选择您要发放的记录！');
            return;
        } else {
            for (var i = 0; i < rows.length; i++) {
                if (ids == "") {
                    ids = rows[i].id
                } else {
                    ids += "," + rows[i].id
                }
            }
        }
        swal({
            title: "您确定要发放奖励吗",
            text: "发放后将进入发放审核，请谨慎操作！",
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "发放",
            closeOnConfirm: false
        }, function () {
            $.ajax({
                type: 'POST',
                url: "award/sengReward",
                data: {awardConfigId: grantName,ids:ids},
                success: function (data) {
                    if (data.result) {
                        swal("发放成功！", "发放奖励完成。", "success");
                    } else {
                        swal("发放失败！", "发放奖励中出现问题：" + data.message, "warning");
                    }
                    refresh();
                },
                error: function () {
                    swal("发放失败！", "请求错误。", "error");
                }
            });
        });
    });

</script>

</body>
</html>
