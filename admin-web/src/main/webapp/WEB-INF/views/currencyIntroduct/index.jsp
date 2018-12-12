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
                                        <%--<label class="control-label col-xs-1" for="title" style="margin-left: -20px">标题：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="title" placeholder="帮助中心明细标题">
                                        </div>--%>
                                        <label class="control-label col-xs-1" for="currency" style="margin-left: -20px">币种：</label>
                                        <div class="col-sm-2">
                                            <select id="currency" class="form-control">
                                                  <option value="" >请选择</option>
                                                <c:forEach items="${currencys}" var="currency" >
                                                    <option value="${currency.symbol}">${currency.symbol}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-sm-2" style="text-align:left;">
                                            <button type="button" style="margin-left:50px" id="search" class="btn btn-primary">查询</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <div class="btn-group hidden-xs" id="tableToolbar" role="group">
                            <%--<fn:func url="affiche/lookInput">
                                <button type="button" id="look" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-plus" aria-hidden="true">查看币种介绍</i>
                                </button>
                            </fn:func>--%>
                            <fn:func url="currencyIntroduct/addInput">
                                <button type="button" id="add" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-plus" aria-hidden="true">新增币种介绍</i>
                                </button>
                            </fn:func>
                            <fn:func url="currencyIntroduct/updateInput">
                                <button type="button" id="update" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-pencil" aria-hidden="true">更新币种介绍</i>
                                </button>
                            </fn:func>
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
    (function($){
        $("#helpTable").bootstrapTable({
            method: 'POST',
            contentType:"application/x-www-form-urlencoded; charset=UTF-8",
            url:"currencyIntroduct/list",
            pagination:true,
            showColumns: true,     //是否显示所有的列1
            showRefresh: true,     //是否显示刷新按钮
            sortable: false,      //是否启用排序
            sortOrder: "asc",     //排序方式
            queryParams:queryParams,
            sidePagination: "server",
            clickToSelect:true,
            singleSelect:true,
            toolbar:"#tableToolbar",
            height:500,
            columns: [{
                checkbox: true
            }, {
                field: 'id',
                title: 'ID',
                width:50,
                align:'center'
            }, {
                field: 'currency',
                title: '币种',
                width:50,
                align:'center'
            }, {
                field: 'name',
                title: '币种名称',
                width:50,
                align:'center'
            },{
                field: 'publishTime',
                title: '发行时间',
                width:50,
                align:'center'
            },{
                field: 'enable',
                title: '是否可用',
                width:50,
                align:'center',
                formatter:function(value,row,index) {
                    if (value == true) {
                        return '是';
                    } else if (value == false) {
                        return '否';
                    }
                }
            }, {
                field: 'createTime',
                title: '创建时间',
                width:50,
                align:'center'
            }, {
                field: 'updateTime',
                title: '最近更新时间',
                width:50,
                align:'center'
            }, {
                field: 'sortParam',
                title: '排序参数',
                width:50,
                align:'center'
            }, {
                field: 'internationalType',
                title: '国际化标记',
                width:50,
                align:'center'
            }
            ]
        });

        //查询参数
        function queryParams(params) {
            params.currency = $("#currency").val();
            //params.helpCategoryId = $("#helpCategoryId").val();
            return params;
        }
        $("#search").on("click",function(){
            refresh()
        });
    })(jQuery);

    function refresh(){
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
            title: '新增币种介绍',
            shadeClose: true,
            shade: 0.8,
            area: ['80%', '90%'],
            content: 'currencyIntroduct/addInput'
        });
    });

    $("#update").click(function () {
        var rows = $("#helpTable").bootstrapTable("getSelections");
        if(rows.length != 1){
            layer.msg('请选择一行执行操作！');
            return
        }
        layer.open({
            type: 2,
            title: '编辑币种介绍',
            shadeClose: true,
            shade: 0.8,
            area: ['80%', '90%'],
            content: 'currencyIntroduct/updateInput?id='+rows[0].id
        });
    });
</script>
</body>
</html>
