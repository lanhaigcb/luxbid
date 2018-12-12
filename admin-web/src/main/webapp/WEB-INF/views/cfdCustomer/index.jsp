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

                                        <label class="control-label col-xs-1" for="id"  style="margin-left: -20px">客户归属：</label>
                                        <div class="col-sm-2">
                                            <input type="text"  class="form-control" id="inviteeId" placeholder="代理人Id">
                                        </div>
                                        <label class="control-label col-xs-1" for="id" style="margin-left: 0px">id：</label>
                                        <div class="col-sm-2">
                                            <input type="text"  class="form-control" id="id" placeholder="id信息">
                                        </div>
                                        <label class="control-label col-xs-1" for="mobile" style="margin-left: -40px">手机：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="mobile" placeholder="手机信息">
                                        </div>

                                    </div>
                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-xs-1" for="email" style="margin-left: -20px">邮箱地址：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="email" placeholder="邮箱地址">
                                        </div>
                                        <label class="control-label col-xs-1" for="volunteerStatus" style="margin-left: 0px">是否代理：</label>
                                        <div class="col-sm-2">
                                            <select id="volunteerStatus" name="volunteerStatus" class=" form-control">
                                                <option value="" selected="selected">请选择</option>
                                                <option value="YES">是代理</option>
                                                <option value="NO">非代理</option>
                                                <option value="APPLYING">申请中</option>
                                            </select>
                                        </div>
                                        <label class="control-label col-xs-1" for="idInfoStatus" style="margin-left: 0px">是否实名：</label>
                                        <div class="col-sm-2">
                                            <select id="idInfoStatus" name="idInfoStatus" class=" form-control">
                                                <option value="" selected="selected">请选择</option>
                                                <option value="UNSUBMIT">未提交</option>
                                                <option value="WAITING">待审核</option>
                                                <option value="PASS">审核通过</option>
                                                <option value="NOT_PASS">审核不通过</option>
                                            </select>
                                        </div>

                                    </div>
                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-xs-1" for="regTime" style="margin-left: -20px">注册时间：</label>
                                        <div class="col-sm-3" style="text-align:left;">
                                            <div class="input-daterange input-group" id="regTime">
                                                <input type="text" class="input-sm form-control"  id="regStartDate" value="" />
                                                <span class="input-group-addon">到</span>
                                                <input type="text" class="input-sm form-control"  id ="regEndDate" value="" />
                                            </div>
                                        </div>
                                        <label class="control-label col-xs-1" for="lastLoginTime" style="margin-left: 0px">最后登录时间：</label>
                                        <div class="col-sm-3" style="text-align:left;">
                                            <div class="input-daterange input-group" id="lastLoginTime">
                                                <input type="text" class="input-sm form-control"  id="lastStartDate" value="" />
                                                <span class="input-group-addon">到</span>
                                                <input type="text" class="input-sm form-control"  id ="lastEndDate" value="" />
                                            </div>
                                        </div>
                                        <label class="control-label col-xs-1" for="inviteCode" style="margin-left: -40px">邀请码：</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="inviteCode" placeholder="邀请码">
                                        </div>

                                    </div>

                                    <div class="form-group" style="margin-top:15px">
                                        <label class="control-label col-xs-1" for="nodeId" style="margin-left: -20px">隶属节点：</label>
                                        <div class="col-sm-2">
                                            <select id="nodeId" name="nodeId" class=" form-control">
                                                <option value="" selected="selected">请选择</option>
                                                <c:forEach items="${nodes}" var="node">
                                                    <option value="${node.id}">${node.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-sm-1" style="text-align:left;">
                                            <button type="button" id="search" class="btn btn-primary">查询</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <div class="btn-group hidden-xs" id="tableToolbar" role="group">
                            <fn:func url="cfdCustomer/updateIndex">
                                <button type="button" id="update" class="btn btn-outline btn-default">
                                    <i class="glyphicon glyphicon-pencil" aria-hidden="true">编辑用户信息</i>
                                </button>
                            </fn:func>
                            <button type="button" id="btnEnableAgent" class="btn btn-outline btn-default" >
                                <i class="glyphicon glyphicon glyphicon-ok-sign" aria-hidden="true">启用代理</i>
                            </button>
                            <button type="button" id="btnDisEnableAgent" class="btn btn-outline btn-default">
                                <i class="glyphicon  glyphicon glyphicon-remove-sign" aria-hidden="true">禁用代理</i>
                            </button>
                        </div>
                    <table id="currencyTable" data-height="400" data-mobile-responsive="true">
                    </table>
                </div>
            </div>
        </div>
    </div>
    <!-- End Panel Other -->
    </div>
</div>
    <script type="text/javascript" charset="UTF-8">
        function table() {
            $("#currencyTable").bootstrapTable({
                method: 'POST',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                url: "cfdCustomer/list",
                pagination: true,
                showColumns: true,     //是否显示所有的列1
                showRefresh: true,     //是否显示刷新按钮
                sortable: false,      //是否启用排序
                sortOrder: "asc",     //排序方式
                queryParams: queryParams,
                sidePagination: "server",
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
                    field: 'mobile',
                    title: '手机号码信息',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'email',
                    title: '邮箱信息',
                    width: 50,
                    align: 'center'
                }, {
                    field: 'volunteerStatusString',
                    title: '代理',
                    width: 20,
                    align: 'center',
                    formatter: function (value, index, row) {
                        if ("YES" == value) return "是代理";
                        if ("NO" == value) return "非代理";
                        if ("APPLYING" == value) return "申请中";
                    }
                }, {
                    field: 'volunteerNumber',
                    title: '代理号',
                    width: 50,
                    align: 'center'
                },

                    {
                        field: 'inviteeId',
                        title: '代理人ID',
                        width: 50,
                        align: 'center'
                    },

                    {
                        field: 'inviteCode',
                        title: '邀请码',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'idInfoStatusString',
                        title: '实名状态',
                        width: 50,
                        align: 'center',
                        formatter: function (value, index, row) {
                            if ("UNSUBMIT" == value) return "未提交";
                            if ("WAITING" == value) return "待审核";
                            if ("PASS" == value) return "通过审核";
                            if ("NOT_PASS" == value) return "未通过";
                        }
                    }, {
                        field: 'cfdRate',
                        title: '合约反佣',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'volunteerRate',
                        title: '现货返佣',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'nodeName',
                        title: '隶属节点',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'regTime',
                        title: '注册时间',
                        width: 50,
                        align: 'center'
                    }, {
                        field: 'lastLoginTime',
                        title: '最后登录时间',
                        width: 50,
                        align: 'center'
                    }
                ]
            });
        }

        $("#lastLoginTime").datepicker({
            keyboardNavigation: !1,
            forceParse: !1,
            autoclose: !0
        });
        $("#regTime").datepicker({
            keyboardNavigation: !1,
            forceParse: !1,
            autoclose: !0
        });

        //查询参数
        function queryParams(params) {
            params.id = $("#id").val();
            params.mobile = $("#mobile").val();
            params.email = $("#email").val();
            params.inviteeId=$("#inviteeId").val();
            params.volunteerStatus = $("#volunteerStatus").val();
            params.idInfoStatus = $("#idInfoStatus").val();
            params.regStartDate = $("#regStartDate").val();
            params.regEndDate = $("#regEndDate").val();
            params.lastStartDate = $("#lastStartDate").val();
            params.inviteCode = $("#inviteCode").val();
            params.nodeId = $("#nodeId").val();
            params.lastEndDate = $("#lastEndDate").val();

            return params;
        }

        (function($){

            table();
            $("#search").on("click",function(){
                refresh()
            });
        })(jQuery);

        function refresh(){
            $("#currencyTable").bootstrapTable('destroy');
            table();

            //$("#currencyTable").bootstrapTable("refresh");
        }



        $("#update").click(function () {
            var rows = $("#currencyTable").bootstrapTable("getSelections");
            if(rows.length != 1){
                layer.msg('请选择一行执行操作！');
                return
            }
            layer.open({
                type: 2,
                title: '编辑用户信息',
                shadeClose: true,
                shade: 0.8,
                area: ['80%', '90%'],
                content: 'cfdCustomer/updateIndex?id='+rows[0].id
            });
        });


        $("#btnEnableAgent,#btnDisEnableAgent").bind("click",function (){

            var rows = $("#currencyTable").bootstrapTable("getSelections");
            if(rows.length != 1){
                layer.msg('请选择一行执行操作！');
                return
            }

            if(confirm("确定要操作？"))
            {
                var status=$(this).attr("id")=="btnEnableAgent"?"YES":"NO";

                $.post("cfdCustomer/enableAgent",{customerId:rows[0].id,status:status},function () {
                    refresh();
                })
            }
        });

    </script>
</body>
</html>
