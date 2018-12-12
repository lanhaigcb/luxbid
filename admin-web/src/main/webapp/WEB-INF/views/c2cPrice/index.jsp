
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
                    <div class="form-group" style="margin-top:15px">

                        <label class="control-label col-xs-1" for="symbol"
                               style="margin-left: -20px">币种：</label>
                        <div class="col-sm-2">
                            <select onchange="refresh()" id="symbol" name="symbol" class=" form-control">
                                <option value="">请选择</option>
                                <c:forEach var="v" items="${vos}">
                                    <option value="${v.symbol}">${v.symbol}</option>
                                </c:forEach>
                            </select>
                        </div>

                    </div>
                    <table id="exchangeOrderTable" data-height="400" data-mobile-responsive="true">
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

//查询参数
        function queryParams(params) {

            params.symbol = $("#symbol").val();
            return params;
        }

        $("#exchangeOrderTable").bootstrapTable({
            method: 'POST',
            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            url: "c2cPrice/list",
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
                field: 'createTime',
                title: '创建时间',
                width: 50,
                align: 'center'
            }, {
                field: 'name',
                title: '类型',
                width: 50,
                align: 'center'
            }, {
                field: 'value',
                title: '对标单价',
                width: 50,
                align: 'center'
            }, {
                field: 'floatRate',
                title: '浮动范围',
                width: 50,
                align: 'center',
                formatter: function (value, row, index) {
                    var html = "";
                    if(row.name.indexOf('买入价')>=0){
                        html += "+"+row.floatRate+"%";
                    }
                    if(row.name.indexOf('卖出价')>=0){
                        html += "-"+row.floatRate+"%";
                    }
                    return html;
                }
            }, {
                field: 'price',
                title: '价格预览',
                width: 50,
                align: 'center'
            },{
                title: '操作',
                width: 50,
                align: 'center',
                formatter: function (value, row, index) {
                    var html = "";
                        html += "<input type='button' class='btn btn-primary' onclick='update(" + row.id + ")'  value='修改'></input>&nbsp;";
                        if(row.canTrade==true){
                            html += "<input type='button' class='btn btn-danger' onclick='change(" + row.id + ",false)'  value='禁用'></input>";
                        }
                        if(row.canTrade==false){
                            html += "<input type='button' class='btn btn-success' onclick='change(" + row.id + ",true)'  value='启用'></input>";
                        }
                    return html;
                }
            }
            ]
        });




    })(jQuery);



    function update(id) {
        layer.open({
            type: 2,
            title: '编辑单价',
            shadeClose: true,
            shade: 0.8,
            area: ['80%', '90%'],
            content: 'c2cPrice/updateInput?id='+id
        });
    }
    function change(id,enable) {

        layer.confirm('确认修改吗？', {
            btn: ['修改','取消'] //按钮
        }, function(){
            $.ajax({
                type: "POST",
                url: "c2cPrice/enable",
                data: {id: id, enable:enable},
                dataType: "json",
                success: function (data) {
                    layer.msg(data.message);
                    refresh();
                }
            });
        }, function(){
            layer.msg("取消操作");
        });


    }
    function refresh() {
        $("#exchangeOrderTable").bootstrapTable("refresh");
    }
</script>
</body>
</html>
