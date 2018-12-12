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



        $("#exchangeOrderTable").bootstrapTable({
            method: 'POST',
            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            url: "c2cLimit/list",
            pagination: true,
            showColumns: true,     //是否显示所有的列1
            showRefresh: true,     //是否显示刷新按钮
            sortable: false,      //是否启用排序
            sortOrder: "asc",     //排序方式
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
                title: '限制值',
                width: 50,
                align: 'center'
            },{
                title: '操作',
                width: 50,
                align: 'center',
                formatter: function (value, row, index) {
                    var html = "";
                        html += "<input type='button' class='btn btn-primary' onclick='update(" + row.id + ")'  value='修改'></input>&nbsp;";

                    return html;
                }
            }
            ]
        });




    })(jQuery);



    function update(id) {
        layer.open({
            type: 2,
            title: '编辑限制值',
            shadeClose: true,
            shade: 0.8,
            area: ['80%', '90%'],
            content: 'c2cLimit/updateInput?id='+id
        });
    }

    function refresh() {
        $("#exchangeOrderTable").bootstrapTable("refresh");
    }
</script>
</body>
</html>
