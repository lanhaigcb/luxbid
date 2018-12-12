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
                                        <label class="control-label col-xs-1" for="customerId"
                                               style="margin-left: -20px">用户ID：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="customerId" name="customerId"
                                                   placeholder="用户ID">
                                        </div>

                                        <%--<label class="control-label col-xs-1" for="status" style="margin-left: -20px">状态：</label>--%>
                                        <%--<div class="col-sm-2">--%>
                                            <%--<select id="status" name="status" class=" form-control">--%>
                                                <%--<option value="">请选择</option>--%>
                                                <%--<c:forEach var="v" items="<%=LoanOrderStatus.values()%>">--%>
                                                    <%--<option value="${v.name()}">${v.toString()}</option>--%>
                                                <%--</c:forEach>--%>
                                            <%--</select>--%>
                                        <%--</div>--%>
                                    </div>

                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-xs-1" for="symbol"
                                               style="margin-left: -20px">币种：</label>
                                        <div class="col-sm-2">
                                            <select id="symbol" name="symbol" class=" form-control">
                                                <option value="">请选择</option>
                                                <c:forEach var="v" items="${products}">
                                                    <option value="${v.symbol}">${v.symbol}</option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                    </div>

                                    <div class="col-sm-2" style="text-align:left;">
                                        <button type="button" style="margin-left:50px" id="search"
                                                class="btn btn-primary">查询
                                        </button>
                                        <%--<button type="button" style="margin-left:10px" id="export" class="btn btn-primary">导出</button>--%>
                                    </div>
                            </div>
                            </form>
                        </div>
                    </div>
                    <%--<table class="table table-bordered">
                        <thead>
                        <tr>
                            <th>统计信息</th>
                        </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td width="200px">&nbsp;&nbsp;成交总价值：<span id="totalAmountCNY"></span></td>
                            </tr>
                        </tbody>
                    </table>--%>
                    <table id="loanOrderTable" data-height="400" data-mobile-responsive="true">
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
    (function ($) {

        $("#datepicker").datepicker({
            keyboardNavigation: !1,
            forceParse: !1,
            autoclose: !0
        });

        $("#search").on("click", function () {
            if (isFirst) {
                isFirst = false;
                $("#loanOrderTable").bootstrapTable({
                    method: 'POST',
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                    url: "loan/list/unwind/",
                    pagination: true,
                    showColumns: true,     //是否显示所有的列1
                    showRefresh: true,     //是否显示刷新按钮
                    sortable: false,      //是否启用排序
                    sortOrder: "asc",     //排序方式
                    queryParams: queryParams,
                    sidePagination: "server",
                    pageSize: 10, //每页的记录行数（*）
                    pageList: [10, 25, 50, 100], //可供选择的每页的行数（*）
                    clickToSelect: true,
                    singleSelect: true,
                    toolbar: "#tableToolbar",
                    height: 500,
                    columns: [{
                        checkbox: true
                    }, {
                        field: 'id',
                        title: 'ID',
                        width: 50,
                        align: 'center'
                    }, {

                        field: 'customerId',
                        title: '用户ID',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'realName',
                        title: '姓名',
                        width: 50,
                        align: 'center'
                    },{
                        field: 'symbol',
                        title: '币种',
                        width: 50,
                        align: 'center'
                    },{
                        field: 'loanAmount',
                        title: '借款总额',
                        width: 50,
                        align: 'center'
                    },{
                        field: 'month',
                        title: '月数',
                        width: 50,
                        align: 'center'
                    },
                        {
                        field: 'rate',
                        title: '月利率',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'coinAmount',
                        title: '抵押数量 ',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'passTime',
                        title: '质押时间',
                        width: 50,
                        align: 'center'
                    }
                        , {
                            field: 'payedAmount',
                            title: '已还利息 ',
                            width: 50,
                            align: 'center'
                        }
                        , {
                            field: 'unwindLoanRate',
                            title: '平仓质押率 ',
                            width: 50,
                            align: 'center'
                        }
                        , {
                            field: 'unwindTime',
                            title: '平仓时间 ',
                            width: 50,
                            align: 'center'
                        },  {
                        field: 'status',
                        title: '订单状态',
                        width: 50,
                        align: 'center',
                        formatter: function (value, row, index) {
                            var html = "";
                            if (row.innerStatus == "UNWIND_NOT_REPAY") {
                                html += "未归还本金";
                            }else if(row.innerStatus== "UNWIND_REPAID"){
                                html += "已归还本金";
                            }
                            return html;
                        }
                    },
                        {
                            title: '操作',
                            width: 50,
                            align: 'center',
                            formatter: function (value, row, index) {
                                var html = "";
                                if (row.innerStatus == "UNWIND_NOT_REPAY") {
                                    html += "<input type='button' class='btn btn-primary' onclick='done(" + row.id + ")'  value='标记已还'>";

                                }
                                return html;
                            }
                        }
                    ]
                });
            } else {
                refresh();
            }
        });


        //查询参数
        function queryParams(params) {
            params.customerId = $("#customerId").val();
            params.status = $("#status").val();
            params.symbol = $("#symbol").val();
            // params.endDate = $("#endDate").val();
            // params.pageSize = params.limit;
            // params.page =params.offset;
            //getTotalAmountCNY();
            return params;
        }


    })(jQuery);



    function done(id) {
        layer.confirm('确认操作吗？', {
            btn: ['确认','取消'] //按钮
        }, function(){
            $.ajax({
                type: "POST",
                url: "loan/unwind/repay",
                data: {id: id},
                dataType: "json",
                success: function (data) {
                    layer.msg("操作成功");
                    refresh();
                }
            });
        }, function(){
            layer.msg("取消操作");
        });


    }

    function code(){

        layer.open({
            type: 2,
            title: '操作',
            shadeClose: true,
            shade: 0.8,
            area: ['30%', '30%'],
            content: 'c2cOrder/op'
        });
    }

    function refresh() {
        $("#loanOrderTable").bootstrapTable("refresh");
    }
</script>
</body>
</html>
