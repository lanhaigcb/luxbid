<%@ taglib prefix="fn" uri="/func" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<%@include file="../common/head-title.jsp"%>
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
                                        <label class="control-label col-xs-1" for="title" style="margin-left: -20px">操作标题：</label>
                                        <div class="col-sm-2">
                                            <select class="form-control show-tick"  id="title" name="title">
                                                <option value="" >请选择</option>
                                                <c:forEach items="${titleList}" var="titleList">
                                                    <option value="${titleList.name}">${titleList.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <label class="control-label col-xs-1" for="startDate" style="margin-left: -20px">操作时间：</label>
                                        <div class="col-sm-3" style="text-align:left;">
                                            <div class="input-daterange input-group" id="datepicker">
                                                <input type="text" class="input-sm form-control" name="start" id="startDate" value="" />
                                                <span class="input-group-addon">到</span>
                                                <input type="text" class="input-sm form-control" name="end" id ="endDate" value="" />
                                            </div>
                                        </div>
                                        <div class="col-sm-2" style="text-align:left;">
                                            <button type="button" style="margin-left:10px" id="search" class="btn btn-primary">查询</button>
                                        </div>
                                    </div>
                                </form>
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
        method: 'POST',
        contentType: "application/x-www-form-urlencoded; charset=UTF-8",
        url:"staff/staffOperationLogList",
        pagination:true,
        showColumns: true,     //是否显示所有的列
        showRefresh: true,     //是否显示刷新按钮
        sortable: false,      //是否启用排序
        sortOrder: "desc",     //排序方式
        queryParams:queryParams,
        sidePagination: "server",
        singleSelect:true,
        clickToSelect:true,
        toolbar:"#convertTableToolbar",
        columns: [{
            checkbox: true
        }, {
            field: 'id',
            width: 100,
            align: 'center',
            title: 'ID'

        }, {
            field: 'name',
            width: 100,
            align: 'center',
            title: '操作标题'
        }, {
            field: 'content',
            width: 300,
            align: 'center',
            title: '操作内容'
        }, {
            field: 'staffRealName',
            width: 100,
            align: 'center',
            title: '操作人'
        }, {
            field: 'createTime',
            width: 100,
            align: 'center',
            title: '操作时间'
        }
        ]
    });

    $("#datepicker").datepicker({
        keyboardNavigation:!1,
        forceParse:!1,
        autoclose:!0
    });

    //查询参数
    function queryParams(params) {
        params.startDate = $("#startDate").val();
        params.endDate = $("#endDate").val();
        params.name = $("#title").val();
        return params;
    }
    $("#search").on("click",function(){
        refresh();
    });

    //刷新
    function refresh(){
        $table.bootstrapTable("refresh");
    }
        //一些事件实例
    var e=$("#examplebtTableEventsResult");
    $table.on("all.bs.table",function(e,t,o){console.log("Event:",t,", data:",o)})
            .on("click-row.bs.table",function(){
                var ids = $("#exampleTableFromData").bootstrapTable("getSelections");
                console.log(ids)
                e.text(ids)
            })
            .on("dbl-click-row.bs.table",function(){e.text("Event: dbl-click-row.bs.table")})
            .on("sort.bs.table",function(){e.text("Event: nihao")})
            .on("check.bs.table",function(){e.text("Event: check.bs.table")})
            .on("uncheck.bs.table",function(){e.text("Event: uncheck.bs.table")})
            .on("check-all.bs.table",function(){e.text("Event: check-all.bs.table")})
            .on("uncheck-all.bs.table",function(){e.text("Event: uncheck-all.bs.table")})
            .on("load-success.bs.table",function(){e.text("Event: load-success.bs.table")})
            .on("load-error.bs.table",function(){e.text("Event: load-error.bs.table")})
            .on("column-switch.bs.table",function(){e.text("Event: column-switch.bs.table")})
            .on("page-change.bs.table",function(){e.text("Event: page-change.bs.table")})
            .on("search.bs.table",function(){
                console.log("表格刷新按钮了")
            })

</script>

</body>
</html>
