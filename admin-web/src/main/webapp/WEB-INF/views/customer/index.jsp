<%@ taglib prefix="fn" uri="/func" %>
<%@ page import="com.mine.common.enums.IdInfoStatus" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<%@include file="../common/head-title.jsp" %>
<body class="gray-bg">
<div class="wrapper wrapper-content animated fadeInRight">
    <!-- Panel Other -->
    <fn:func url="customer/index">
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
                                            <label class="control-label col-xs-1" for="id" style="margin-left: -20px">用户ID：</label>
                                            <div class="col-sm-2">
                                                <input type="text" class="form-control" id="id" placeholder="用户id">
                                            </div>
                                            <label class="control-label col-xs-1" for="mobile"
                                                   style="margin-left: -20px">手机号：</label>
                                            <div class="col-sm-2">
                                                <input type="text" class="form-control" id="mobile" placeholder="手机号">
                                            </div>
                                            <label class="control-label col-xs-1" for="email"
                                                   style="margin-left: -20px">邮箱：</label>
                                            <div class="col-sm-2">
                                                <input type="text" class="form-control" id="email" placeholder="邮箱">
                                            </div>
                                            <label class="control-label col-xs-1" for="inviteCode"
                                                   style="margin-left: -20px">邀请码：</label>
                                            <div class="col-sm-2">
                                                <input type="text" class="form-control" id="inviteCode"
                                                       placeholder="邀请码">
                                            </div>
                                        </div>
                                        <div class="form-group" style="margin-top:15px">
                                            <label class="control-label col-xs-1" for="channelId"
                                                   style="margin-left: -20px">渠道号：</label>
                                            <div class="col-sm-2">
                                                <input type="text" class="form-control" id="channelId"
                                                       placeholder="渠道号">
                                            </div>
                                            <label class="control-label col-xs-1" for="isProject"
                                                   style="margin-left: -20px">项目方：</label>
                                            <div class="col-sm-2">
                                                <select id="isProject" name="isProject" class=" form-control">
                                                    <option value="">请选择</option>
                                                    <option value="1">是</option>
                                                    <option value="0">否</option>
                                                </select>
                                            </div>
                                            <label class="control-label col-xs-1" for="idInfoValues"
                                                   style="margin-left: -20px">实名：</label>
                                            <div class="col-sm-2">
                                                <select id="idInfoValues" name="idInfoValues" class=" form-control">
                                                    <option value="">请选择</option>
                                                    <c:forEach var="v" items="<%=IdInfoStatus.values()%>">
                                                        <option value="${v.name()}">${v.toString()}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <label class="control-label col-xs-1" for="rechargeStatus"
                                                   style="margin-left: -20px">入金：</label>
                                            <div class="col-sm-2">
                                                <select id="rechargeStatus" name="rechargeStatus" class=" form-control">
                                                    <option value="">请选择</option>
                                                    <option value="1">是</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group" style="margin-top:15px">
                                            <label class="control-label col-xs-1" for="enable"
                                                   style="margin-left: -20px">状态：</label>
                                            <div class="col-sm-2">
                                                <select id="enable" name="enable" class=" form-control">
                                                    <option value="">请选择</option>
                                                    <option value="1">是</option>
                                                    <option value="0">否</option>
                                                </select>
                                            </div>

                                            <label class="control-label col-xs-1" for="regTimeStartDate"
                                                   style="margin-left: -20px;margin-top: 10px">注册时间：</label>
                                            <div class="col-sm-3" style="text-align:left;margin-top: 10px">
                                                <div class="input-daterange input-group" id="datepicker">
                                                    <input type="text" class="input-sm form-control" name="c"
                                                           id="regTimeStartDate" value=""/>
                                                    <span class="input-group-addon">到</span>
                                                    <input type="text" class="input-sm form-control"
                                                           name="regTimeEndDate" id="regTimeEndDate" value=""/>
                                                </div>
                                            </div>
                                            <label class="control-label col-xs-1" for="lastLoginTimeStartDate"
                                                   style="margin-left: -20px;margin-top: 10px">最后登录时间：</label>
                                            <div class="col-sm-3" style="text-align:left;margin-top: 10px">
                                                <div class="input-daterange input-group" id="datepicker2">
                                                    <input type="text" class="input-sm form-control"
                                                           name="lastLoginTimeStartDate" id="lastLoginTimeStartDate"
                                                           value=""/>
                                                    <span class="input-group-addon">到</span>
                                                    <input type="text" class="input-sm form-control"
                                                           name="lastLoginTimeEndDate" id="lastLoginTimeEndDate"
                                                           value=""/>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" style="margin-top:15px">
                                            <label class="control-label col-xs-1" for="regType"
                                                   style="margin-left: -20px">注册类型：</label>
                                            <div class="col-sm-2">
                                                <select id="regType" name="regType" class=" form-control">
                                                    <option value="">请选择</option>
                                                    <option value="MOBILE">手机</option>
                                                    <option value="EMAIL">邮箱</option>
                                                </select>
                                            </div>
                                            <label class="control-label col-xs-1" for="auditTimeStartDate"
                                                   style="margin-left: -20px;margin-top: 10px">实名时间：</label>
                                            <div class="col-sm-3" style="text-align:left;margin-top: 10px">
                                                <div class="input-daterange input-group" id="datepicker3">
                                                    <input type="text" class="input-sm form-control"
                                                           name="auditTimeStartDate"
                                                           id="auditTimeStartDate" value=""/>
                                                    <span class="input-group-addon">到</span>
                                                    <input type="text" class="input-sm form-control"
                                                           name="auditTimeEndDate"
                                                           id="auditTimeEndDate" value=""/>
                                                </div>
                                            </div>
                                            <div class="col-sm-2" style="text-align:left;margin-top: 10px">
                                                <button type="button" style="margin-left:10px" id="search"
                                                        class="btn btn-primary">查询
                                                </button>
                                                <fn:func url="customer/manage/export">
                                                    <button type="button" style="margin-left:10px" id="export"
                                                            class="btn btn-primary">导出
                                                    </button>
                                                </fn:func>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                            <div class="btn-group" id="customTableToolbar" role="group">
                                <fn:func url="customer/manage/detail">
                                    <button type="button" id="detailButton" class="btn btn-outline btn-default">
                                        <i class="glyphicon glyphicon-search" aria-hidden="true"></i>详情
                                    </button>
                                </fn:func>
                                <fn:func url="customer/manage/enable">
                                    <button type="button" id="enableButton" class="btn btn-outline btn-default">
                                        <i class="glyphicon glyphicon-ok" aria-hidden="true"></i>启用
                                    </button>
                                </fn:func>
                                <fn:func url="customer/manage/disable">
                                    <button type="button" id="disableButton" class="btn btn-outline btn-default">
                                        <i class="glyphicon glyphicon-trash" aria-hidden="true"></i>禁用
                                    </button>
                                    <button type="button" id="whiteFlagButton" class="btn btn-outline btn-default">
                                        <i class="glyphicon glyphicon-search" aria-hidden="true"></i>申请白名单
                                    </button>
                                </fn:func>
                                <fn:func url="customer/isProject">
                                    <button type="button" id="isProjectButton" class="btn btn-outline btn-default">
                                        <i class="glyphicon glyphicon-ok" aria-hidden="true"></i>设为项目方
                                    </button>
                                </fn:func>
                                <fn:func url="customer/makeAPIKEY">
                                    <button type="button" id="makeAPIKEYButton" class="btn btn-outline btn-default">
                                        <i class="glyphicon glyphicon-ok" aria-hidden="true"></i>生成APIKEY
                                    </button>
                                    <button type="button" id="findAPIKEYButton" class="btn btn-outline btn-default">
                                        <i class="glyphicon glyphicon-search" aria-hidden="true"></i>查询APIKEY
                                    </button>
                                    <button type="button" id="initRedisApiKey" class="btn btn-outline btn-default">
                                        <i class="glyphicon glyphicon-search" aria-hidden="true"></i>初始化APIKEY
                                    </button>
                                </fn:func>
                                <fn:func url="customer/sendMessage">
                                    <button type="button" id="sendMessageButton" class="btn btn-outline btn-default">
                                        <i class="glyphicon glyphicon-comment" aria-hidden="true"></i>发送消息
                                    </button>
                                </fn:func>
                            </div>
                            <table id="customTable" data-height="400" data-mobile-responsive="true">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <!-- End Panel Other -->
        </div>
    </fn:func>
</div>
<script type="text/javascript" charset="UTF-8">
    //        var isFirst = true;
    (function ($) {
        $("#datepicker").datepicker({
            keyboardNavigation: !1,
            forceParse: !1,
            autoclose: !0
        });
        $("#datepicker2").datepicker({
            keyboardNavigation: !1,
            forceParse: !1,
            autoclose: !0
        });
        $("#datepicker3").datepicker({
            keyboardNavigation: !1,
            forceParse: !1,
            autoclose: !0
        });

        //查询参数
        function queryParams(params) {
            params.id = $("#id").val();
            params.mobile = $("#mobile").val();
            params.email = $("#email").val();
            params.inviteCode = $("#inviteCode").val();
            params.channelId = $("#channelId").val();
            params.projectVal = $("#isProject").val();
            params.idInfoValues = $("#idInfoValues").val();
            params.rechargeStatus = $("#rechargeStatus").val();
            params.enable = $("#enable").val();
            params.regTimeStartDate = $("#regTimeStartDate").val();
            params.regTimeEndDate = $("#regTimeEndDate").val();
            params.lastLoginTimeStartDate = $("#lastLoginTimeStartDate").val();
            params.lastLoginTimeEndDate = $("#lastLoginTimeEndDate").val();
            params.auditTimeStartDate = $("#auditTimeStartDate").val();
            params.auditTimeEndDate = $("#auditTimeEndDate").val();
            params.regType = $("#regType").val();
            params.limit = params.limit;
            params.offset = params.offset;
            return params;
        }

        $("#customTable").bootstrapTable({
            url: "customer/list",
            pagination: true,
            method: 'POST',
            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            showColumns: false,     //是否显示所有的列
            showRefresh: false,     //是否显示刷新按钮
            sortable: false,      //是否启用排序
            sortOrder: "asc",     //排序方式
            queryParams: queryParams,
            sidePagination: "server",
            clickToSelect: true,
            singleSelect: false,
            toolbar: "#customTableToolbar",
            height: 550,
            pageSize: 10, //每页的记录行数（*）
            pageList: [10, 25, 50, 100], //可供选择的每页的行数（*）
            columns: [{
                checkbox: true
            }, {
                field: 'id',
                title: 'ID',
                width: 50,
                align: 'center'
            }, {
                field: 'regTime',
                title: '注册时间',
                width: 100,
                align: 'center'
            }, {
                field: 'channelId',
                title: '渠道号',
                width: 30,
                align: 'center'
            }, {
                field: 'mobile',
                title: '手机号',
                width: 100,
                align: 'center'
            }, {
                field: 'email',
                title: '邮箱',
                width: 100,
                align: 'center'
            }, {
                field: 'inviteCode',
                title: '邀请码',
                width: 50,
                align: 'center'
            }, {
                field: 'rechargeStatus',
                title: '入金',
                width: 50,
                align: 'center',
                formatter: function (value, row, index) {
                    if (value) {
                        return '<span style="color: green;">是</span>';
                    } else {
                        return '<span style="color: red;">否</span>';
                    }
                }
            }, {
                field: 'idInfoStatus',
                title: '实名',
                width: 50,
                align: 'center',
                formatter: function (value, row, index) {
                    if (value == '审核通过') {
                        return '<span style="color: green;">' + value + '</span>';
                    } else if (value == '待审核') {
                        return '<span style="color: orange;">' + value + '</span>';
                    } else if (value == '未提交') {
                        return '<span style="color: grey;">' + value + '</span>';
                    } else {
                        return '<span style="color: red;">' + value + '</span>';
                    }
                }
            }, {
                field: 'auditTime',
                title: '实名时间',
                width: 100,
                align: 'center'
            }, {
                field: 'project',
                title: '项目方',
                width: 30,
                align: 'center',
                formatter: function (value, row, index) {
                    if (value) {
                        return '<span style="color: green;">是</span>';
                    } else {
                        return '<span style="color: red;">否</span>';
                    }
                }
            }, {
                field: 'enable',
                title: '启用',
                width: 30,
                align: 'center',
                formatter: function (value, row, index) {
                    if (value) {
                        return '<span style="color: green;">是</span>';
                    } else {
                        return '<span style="color: red;">否</span>';
                    }
                }
            }, {
                field: 'lastLoginTime',
                title: '最后登录时间',
                width: 100,
                align: 'center'
            }
            ]
        });

        $("#search").on("click", function () {
            refresh()
        });

        var urlEncode = function (param) {
            var str = "";
            for (var index in param) {
                if (index != 'undefined') {
                    str = str + index + "=" + param[index] + "&";
                }
            }
            return str.substring(0, str.length - 1);
        };

        $("#export").click(function () {
            var params = {};
            params = queryParams(params);

            var url = urlEncode(params);
            console.log(url);
            window.location.href = "customer/export?" + url;

        });
    })(jQuery);

    //移除或添加到白名单
    function removeOrAddWhiteList(id) {
        $.ajax({
            url: 'customer/addOrRemoveWhiteList?id=' + id,
            success: function (data) {
                if (data.result) {
                    swal("设置成功！", "", "success");
                }
                refresh();
            },
            error: function () {
                swal("设置失败！", "请求错误。", "error");
            }
        })
    }


    //刷新
    function refresh() {
        $("#customTable").bootstrapTable("refresh");
    }

    $("#detailButton").click(function () {
        var rows = $("#customTable").bootstrapTable("getSelections");
        if (rows.length != 1) {
            layer.msg('请选择一行执行操作！');
            return
        }
        layer.open({
            title: '用户详情',
            type: 2,
            fix: false, //不固定
            maxmin: true,
            area: ['85%', '85%'],
            content: 'customer/detail?customerId=' + rows[0].id
        });
    });

    $("#enableButton").click(function () {
        var rows = $("#customTable").bootstrapTable("getSelections");
        if (rows.length != 1) {
            layer.msg('请选择一行执行操作！');
            return
        }
        $.ajax({
            url: "customer/updateStatus",
            data: {customerId: rows[0].id, enable: true},
            success: function (data) {
                if (data.result) {
                    swal("启用成功！", "您已经设置了这条信息。", "success");
                } else {
                    swal("设置失败！", "设置中出现问题：" + data.message, "warning");
                }
                refresh();
            },
            error: function () {
                swal("设置失败！", "请求错误。", "error");
            }
        });
    });

    $("#updateButton").click(function () {
        var rows = $("#customTable").bootstrapTable("getSelections");
        if (rows.length != 1) {
            layer.msg('请选择一行执行操作！');
            return
        }
        layer.open({
            title: '用户资金调整',
            type: 2,
            fix: false, //不固定
            maxmin: true,
            area: ['60%', '65%'],
            content: 'customer/text/updateInput?customerId=' + rows[0].id
        });
    });

    $("#whiteFlagButton").click(function () {
        var rows = $("#customTable").bootstrapTable("getSelections");
        if (rows.length != 1) {
            layer.msg('请选择一行执行操作！');
            return
        }
        layer.open({
            title: '申请白名单',
            type: 2,
            fix: false, //不固定
            maxmin: true,
            area: ['60%', '65%'],
            content: 'customer/addWhiteInput?customerId=' + rows[0].id
        });
    });

    $("#makeAPIKEYButton").click(function () {
        var rows = $("#customTable").bootstrapTable("getSelections");
        if (rows.length != 1) {
            layer.msg('请选择一行执行操作！');
            return
        }
        $.ajax({
            url: "customer/makeAPIKEY",
            data: {customerId: rows[0].id},
            success: function (data) {
                if (data.result) {
                    swal("设置成功！", "您已经设置了这条信息。", "success");
                } else {
                    swal("设置失败！", "设置中出现问题：" + data.message, "warning");
                }
                refresh();
            },
            error: function () {
                swal("设置失败！", "请求错误。", "error");
            }
        });
    });


    $("#findAPIKEYButton").click(function () {
        var rows = $("#customTable").bootstrapTable("getSelections");
        if (rows.length != 1) {
            layer.msg('请选择一行执行操作！');
            return
        }
        layer.open({
            title: '查询ApiKey',
            type: 2,
            fix: false,
            maxmin: true,
            area: ['85%', '85%'],
            content: 'customer/findApiKey?customerId=' + rows[0].id
        });
    });

    $("#initRedisApiKey").click(function () {
        $.ajax({
            url: "customer/initRedisApiKey",
            data: {},
            success: function (data) {
                if (data.result) {
                    swal("初始化成功！", "您已经初始化了APIKEY。", "success");
                } else {
                    swal("初始化失败！", "初始化出现问题：" + data.message, "warning");
                }
                refresh();
            },
            error: function () {
                swal("初始化失败！", "请求错误。", "error");
            }
        });
    });

    $("#disableButton").click(function () {
        var rows = $("#customTable").bootstrapTable("getSelections");
        if (rows.length != 1) {
            layer.msg('请选择一行执行操作！');
            return
        }
        $.ajax({
            url: "customer/updateStatus",
            data: {customerId: rows[0].id, enable: false},
            success: function (data) {
                if (data.result) {
                    swal("禁用成功！", "您已经设置了这条信息。", "success");
                } else {
                    swal("设置失败！", "设置中出现问题：" + data.message, "warning");
                }
                refresh();
            },
            error: function () {
                swal("设置失败！", "请求错误。", "error");
            }
        });
    });

    $("#isProjectButton").click(function () {
        var rows = $("#customTable").bootstrapTable("getSelections");
        if (rows.length != 1) {
            layer.msg('请选择一行执行操作！');
            return
        }
        $.ajax({
            url: "customer/isProject",
            data: {customerId: rows[0].id},
            success: function (data) {
                if (data.result) {
                    swal("设置成功！", "您已经设置了这条信息。", "success");
                } else {
                    swal("设置失败！", "设置中出现问题：" + data.message, "warning");
                }
                refresh();
            },
            error: function () {
                swal("设置失败！", "请求错误。", "error");
            }
        });
    });

    $("#sendMessageButton").click(function () {
        var rows = $("#customTable").bootstrapTable("getSelections");
        if (rows.length == 0) {
            layer.msg('请选择用户！');
            return
        }
        var customerId = "";
        for (var i = 0; i < rows.length; i++) {
            if (customerId == "") {
                customerId = rows[i].id;
            } else {
                customerId = customerId + "," + rows[i].id;
            }
        }
        layer.open({
            title: '发送信息',
            type: 2,
            fix: false, //不固定
            maxmin: true,
            area: ['60%', '65%'],
            content: 'customer/sendMessage?customerId=' + customerId
        });
    });


</script>
</body>
</html>
