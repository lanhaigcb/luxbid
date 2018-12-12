<%@ taglib prefix="fn" uri="/func" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<%@include file="../common/head-title.jsp" %>
<body class="gray-bg">
<div class="wrapper wrapper-content animated fadeInRight">
    <!-- Panel Other -->
    <div class="col-sm-4">
        <div class="ibox float-e-margins">
            <div class="ibox-title">
                <h5>菜单树结构</h5>

                <div class="ibox-tools">
                    <a class="collapse-link">
                        <i class="fa fa-refresh" id="refreshTree">刷新</i>
                    </a>
                    <%--<a class="dropdown-toggle" data-toggle="dropdown" href="buttons.html#">
                        <i class="fa fa-wrench"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-user">
                        <li><a href="buttons.html#">选项1</a>
                        </li>
                        <li><a href="buttons.html#">选项2</a>
                        </li>
                    </ul>
                    <a class="close-link">
                        <i class="fa fa-times"></i>
                    </a>--%>
                </div>
            </div>
            <div class="ibox-content">
                <div class="col-sm-12">
                    <div id="menu_tree" class="test"></div>
                </div>
                <div class="clearfix"></div>
            </div>
        </div>
    </div>
    <div class="col-sm-8">
        <div class="ibox float-e-margins">
            <div class="ibox-title">
                <div class="ibox-tools">
                    <a class="collapse-link">
                        <i class="fa fa-chevron-up"></i>
                    </a>
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                        <i class="fa fa-wrench"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-user">
                        <li><a href="#">选项1</a>
                        </li>
                        <li><a href="#">选项2</a>
                        </li>
                    </ul>
                    <a class="close-link">
                        <i class="fa fa-times"></i>
                    </a>
                </div>
            </div>
            <div class="ibox-content">
                <div class="row row-lg">
                    <div class="col-sm-12">
                        <!-- Example Events -->
                        <div class="example-wrap">
                            <div class="example">
                                <div class="btn-group hidden-xs" id="exampleTableEventsToolbar" role="group">
                                    <button type="button" id="add" class="btn btn-outline btn-default">
                                        <i class="glyphicon glyphicon-plus" aria-hidden="true">新增</i>
                                    </button>
                                    <button type="button" id="update" class="btn btn-outline btn-default">
                                        <i class="glyphicon glyphicon-pencil" aria-hidden="true">修改</i>
                                    </button>
                                    <%--<button type="button" class="btn btn-outline btn-default">
                                        <i class="glyphicon glyphicon-trash" aria-hidden="true"></i>
                                    </button>--%>
                                </div>
                                <table id="exampleTableEvents" data-height="700" data-mobile-responsive="true">
                                    <thead>
                                    <tr>
                                        <th data-field="state" data-checkbox="true"></th>
                                        <th data-field="id">ID</th>
                                        <th data-field="name">名称</th>
                                        <th data-field="uri">URI</th>
                                    </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                        <!-- End Example Events -->
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- End Panel Other -->
</div>

<script type="text/javascript" charset="UTF-8">
    $("#exampleTableEvents").bootstrapTable({
        url: "functionInfo/list.json",
        search: true,
        pagination: true,
        /* showRefresh:!0,
         showToggle:!0,
         showColumns:!0,*/
        pageSize: 15,
        singleSelect: true,
        clickToSelect: true,
        iconSize: "outline",
        sidePagination: "server",
        toolbar: "#exampleTableEventsToolbar"
        //icons:{refresh:"glyphicon-repeat",toggle:"glyphicon-list-alt",columns:"glyphicon-list"}
    });
    //一些事件实例
    var e = $("#examplebtTableEventsResult");
    $("#exampleTableEvents")
            .on("all.bs.table", function (e, t, o) {
                console.log("Event:", t, ", data:", o)
            })
            .on("click-row.bs.table", function () {
                var ids = $("#exampleTableFromData").bootstrapTable("getSelections");
                e.text(ids)
            }).on("dbl-click-row.bs.table", function () {
                console.log("Double Click！")
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
                e.text("Event: search.bs.table")
            });

    var parentId = 1;


    $(function () {
        /*
         var data = getFunctionByID(1);

         $("#menu_tree").treeview({
         color: "#428bca", data: data, onNodeSelected: function (e, o) {
         var url = "functionInfo/list.json?parentId=" + o.tag;
         parentId = o.tag;
         $('#exampleTableEvents').bootstrapTable('refresh', {url: url});
         }
         });

         $("#menu_tree").treeview('selectNode', [0, {silent: true}]);*/

        doRefreshTree();

        $("#refreshTree").click(function () {
            doRefreshTree();
        })
    });

    function getFunctionByID(parentId) {
        var menus;
        $.ajax({
            url: "functionInfo/tree.json",
            data: {parentId: parentId},
            async: false,
            success: function (data) {
                menus = data.treeVos;
            },
            error: function () {
                layer.msg('请求错误！');
            }
        });
        return menus;
    }


    function doRefreshTree() {
        var data = getFunctionByID(1);

        $("#menu_tree").treeview({
            color: "#428bca", data: data, onNodeSelected: function (e, o) {
                var url = "functionInfo/list.json?parentId=" + o.tag;
                parentId = o.tag;
                $('#exampleTableEvents').bootstrapTable('refresh', {url: url});
            }
        });

        $("#menu_tree").treeview('selectNode', [0, {silent: true}]);
        var url = "functionInfo/list.json?parentId=" + 1;
        parentId = 1;
        $('#exampleTableEvents').bootstrapTable('refresh', {url: url});
    }

    $("#add").click(function () {
        layer.open({
            type: 2,
            title: '添加菜单',
            shadeClose: true,
            shade: 0.8,
            area: ['60%', '65%'],
            content: 'functionInfo/addInput?parentId=' + parentId,
            yes: function (index, layero) {
                //do something
                layer.close(index); //如果设定了yes回调，需进行手工关闭
                console.log(1111)
            }
        });
    });
    $("#update").click(function () {
        var rows = $("#exampleTableEvents").bootstrapTable("getSelections");
        if (rows.length != 1) {
            layer.msg('请选择一行执行操作！');
            return
        }
        layer.open({
            type: 2,
            title: '修改菜单',
            shadeClose: true,
            shade: 0.8,
            area: ['60%', '65%'],
            content: 'functionInfo/updateInput?id=' + rows[0].id
        })
    })
    function refresh() {
        doRefreshTree();
        console.log("fuck.........");
        //$("#exampleTableEvents").bootstrapTable("refresh");
    }


</script>

</body>
</html>
