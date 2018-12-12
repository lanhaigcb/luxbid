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
                    <div class="btn-group hidden-xs" id="tableToolbar" role="group">
                            <button type="button" id="add" class="btn btn-outline btn-default">
                                <i class="glyphicon glyphicon-plus" aria-hidden="true">添加银行卡</i>
                            </button>
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



        $("#exchangeOrderTable").bootstrapTable({
            method: 'POST',
            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            url: "c2cBankcard/list",
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
                field: 'bankName',
                title: '银行名',
                width: 50,
                align: 'center'
            }, {
                field: 'subBankName',
                title: '支行',
                width: 50,
                align: 'center'
            }, {
                field: 'cardNumber',
                title: '卡号',
                width: 50,
                align: 'center'
            }, {
                field: 'cardOwner',
                title: '持卡人',
                width: 50,
                align: 'center'
            }, {
                field: 'symbol',
                title: '币种',
                width: 50,
                align: 'center'
            }, {
                field: 'createTime',
                title: '创建时间',
                width: 50,
                align: 'center'
            }, {
                field: 'enable',
                title: '是否可用',
                width: 50,
                align: 'center',
                formatter: function (value, row, index) {
                    if(row.enable==true){
                        return "<font color='green'>是</font>"
                    } else {
                        return "<font color='red'>否</font>"
                    }
                }
            }, {
                title: '操作',
                width: 50,
                align: 'center',
                formatter: function (value, row, index) {
                    var html = "";
                        if(row.enable==true){
                            html += "<input type='button' class='btn btn-danger' onclick='change(" + row.id + ",false)'  value='禁用' />&nbsp;";
                        }
                        if(row.enable==false){
                            html += "<input type='button' class='btn btn-success' onclick='change(" + row.id + ",true)'  value='启用' />&nbsp;";
                        }
                    html += "<input type='button' class='btn btn-primary' onclick='update(" + row.id + ")'  value='修改' />";
                    return html;
                }
            }
            ]
        });




    })(jQuery);

    $("#add").click(function () {
        layer.open({
            type: 2,
            title: '添加银行卡',
            shadeClose: true,
            shade: 0.8,
            area: ['80%', '90%'],
            content: 'c2cBankcard/addInput'
        });
    });

    function update(id) {
        layer.open({
            type: 2,
            title: '编辑银行卡',
            shadeClose: true,
            shade: 0.8,
            area: ['80%', '90%'],
            content: 'c2cBankcard/updateInput?id='+id
        });
    }

    function change(id,enable) {

        layer.confirm('确认修改吗？', {
            btn: ['修改','取消'] //按钮
        }, function(){
            $.ajax({
                type: "POST",
                url: "c2cBankcard/enable",
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
