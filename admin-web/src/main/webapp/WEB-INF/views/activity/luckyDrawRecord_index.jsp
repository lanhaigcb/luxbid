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
                                        <label class="control-label col-xs-1" for="account" style="margin-left: -20px">帐号：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="account" name="account" placeholder="手机号或邮箱">
                                        </div>
                                        <label class="control-label col-xs-1" for="symbol" style="margin-left: -20px">币种：</label>
                                        <div class="col-sm-2">
                                            <select id="symbol" name="symbol" class=" form-control">
                                                <option value="">请选择</option>
                                                <c:forEach items="${listCurrencyVo}" var="v" >
                                                    <option value="${v.symbol}">${v.symbol}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <label class="control-label col-xs-1" for="activityName" style="margin-left: -20px">方案名称：</label>
                                        <div class="col-sm-2">
                                            <select id="activityName" name="activityName" class=" form-control">
                                                <option value="">请选择</option>
                                                <c:forEach items="${listActivityVo}" var="v" >
                                                    <option value="${v.activityName}">${v.activityName}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-xs-1" for="datepicker" style="margin-left: -20px">发放时间：</label>
                                        <div class="col-sm-3" style="text-align:left;">
                                            <div class="input-daterange input-group" id="datepicker">
                                                <input type="text" class="input-sm form-control" name="giveOutTimeStartDate" id="createTimeStartDate" value="" />
                                                <span class="input-group-addon">到</span>
                                                <input type="text" class="input-sm form-control" name="giveOutTimeEndDate" id ="createTimeEndDate" value="" />
                                            </div>
                                        </div>
                                        <div class="col-sm-2" style="text-align:left;">
                                            <button type="button" style="margin-left:50px" id="search" class="btn btn-primary">查询</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <table class="table table-bordered" id="statTab" style="display: none">
                            <thead>
                            <tr>
                                <th colspan="10">统计信息</th>
                            </tr>
                            </thead>
                            <tbody id="statId">
                            </tbody>
                        </table>
                        <table id="bsTable" data-height="400" data-mobile-responsive="true">
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <!-- End Panel Other -->
    </div>
</div>
<script type="text/javascript" charset="UTF-8">
    var isFirst = true;
    (function($){

        $("#datepicker").datepicker({
            keyboardNavigation:!1,
            forceParse:!1,
            autoclose:!0
        });

        $("#search").on("click",function(){
            if (isFirst) {
                isFirst = false;
                $("#bsTable").bootstrapTable({
                    method: 'POST',
                    contentType:"application/x-www-form-urlencoded; charset=UTF-8",
                    url:"luckyDrawRecord/list",
                    pagination:true,
                    showColumns: true,     //是否显示所有的列1
                    showRefresh: true,     //是否显示刷新按钮
                    sortable: false,      //是否启用排序
                    sortOrder: "asc",     //排序方式
                    queryParams:queryParams,
                    sidePagination: "server",
                    pageSize : 10, //每页的记录行数（*）
                    pageList : [ 10, 25, 50, 100 ], //可供选择的每页的行数（*）
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
                    },{
                        field: 'account',
                        title: '帐号',
                        width:50,
                        align:'center'
                    }, {
                        field: 'activityName',
                        title: '方案名称',
                        width:60,
                        align:'center'
                    }, {
                        field: 'symbol',
                        title: '币种',
                        width:50,
                        align:'center'
                    },  {
                        field: 'awardNum',
                        title: '数量',
                        width:50,
                        align:'center'
                    },  {
                        field: 'createTime',
                        title: '发送时间',
                        width:60,
                        align:'center'
                    }
                    ]
                });
            } else {
                refresh();
            }
        });




        //查询参数
        function queryParams(params) {
            params.account = $("#account").val();
            params.symbol = $("#symbol").val();
            params.activityName = $("#activityName").val();
            params.createTimeStartDate = $("#createTimeStartDate").val();
            params.createTimeEndDate = $("#createTimeEndDate").val();
            params.pageSize = params.limit;
            params.page =params.offset;
            getStatInfo();
            return params;
        }
    })(jQuery);

    function getStatInfo(){
        $("#statTab").show();
        $.ajax({
            type: "GET",
            url: "luckyDrawRecord/getStatInfo",
            data: {account:$("#account").val(), symbol:$("#symbol").val(), activityName:$("#activityName").val()
                , createTimeStartDate:$("#createTimeStartDate").val(), createTimeEndDate:$("#createTimeEndDate").val()},
            dataType: "json",
            contentType:"application/x-www-form-urlencoded; charset=UTF-8",
            success: function(data){
                var str="<tr>";
                if(data.length>0){
                    for(var i=0;i<data.length;i++){
                        if((i+1)%8==0){
                            str += "</tr><tr>";
                            str += "<td>"+data[i].symbol+"："+data[i].awardNum+"</td>";
                        }else{
                            str+="<td>"+data[i].symbol+"："+data[i].awardNum+"</td>";
                        }
                    }
                }
                str+="</tr>";
                $("#statId").html(str);
            }
        });
    }

    function refresh(){
        $("#bsTable").bootstrapTable("refresh");
    }
</script>
</body>
</html>
