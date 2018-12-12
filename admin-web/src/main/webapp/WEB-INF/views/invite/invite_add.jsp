<%@ page contentType="text/html;charset=UTF-8" language="java" %><!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="b" %>
<%@include file="../common/taglib.jsp"%>
<!DOCTYPE html>
<html>
    <%@include file="../common/head-title.jsp"%>
    <%@include file="../common/kindeditor.jsp" %>
    <script src="theme/js/custom/staff/form-validate-invite.min.js"></script>
<body class="">
<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <form class="form-horizontal m-t" method="post" id="addConvertForm" action = "invite/add" enctype="multipart/form-data">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">注册奖励币种：</label>
                            <div class="col-sm-4">
                                <select class="form-control show-tick"  id="regSymbol" name="regSymbol">
                                    <option value="" >请选择</option>
                                    <c:forEach items="${currencys}" var="currency">
                                        <option value="${currency.symbol}">${currency.symbol}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">注册奖励数量：</label>
                            <div class="col-sm-4">
                                <input id="regAmount" name="regAmount" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">注册奖励总额：</label>
                            <div class="col-sm-4">
                                <input id="registerMax" name="registerMax" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">邀请奖励币种：</label>
                            <div class="col-sm-4">
                                <select class="form-control show-tick"  id="inviteeSymbol" name="inviteeSymbol">
                                    <option value="" >请选择</option>
                                    <c:forEach items="${currencys}" var="currency">
                                        <option value="${currency.symbol}">${currency.symbol}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">邀请奖励数量：</label>
                            <div class="col-sm-4">
                                <input id="inviteeAmount" name="inviteeAmount" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">邀请奖励总额：</label>
                            <div class="col-sm-4">
                                <input id="inviteMax" name="inviteMax" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">页面地址：</label>
                            <div class="col-sm-4">
                                <input id="viewURL" name="viewURL" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">图片地址：</label>
                            <div class="col-sm-4">
                                <input id="imageURL" name="imageURL" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">规则内容：</label>
                            <div class="col-sm-8">
                                 <textarea id="rule" name="rule" required='true' maxlength="5000"
                                           class="easyui-validatebox"
                                           style="width: 800px;float: left;height: 300px"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">是否启用：</label>
                            <div class="col-sm-4">
                                <select class="form-control" id="enable" name="enable">
                                    <option value="false">不启用</option>
                                    <option value="true">启用</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">介绍文字：</label>
                            <div class="col-sm-8">
                                 <textarea id="introduction" name="introduction" required='true' maxlength="5000"
                                           class="easyui-validatebox"
                                           style="width: 800px;float: left;height: 50px"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-4 col-sm-offset-3">
                                <button class="btn btn-primary" type="submit">提交</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="theme/js/custom/staff/form-validate-staff.min.js"></script>

</body>

</html>

<script>
    $(function (){
        createKindEditor('textarea[name="rule"]');
        var options = {
            beforeSubmit : function() {

            },
            error : function() {
                layer.msg('请求错误！');
            },
            success : function(data) {
                layer.msg(data.message);
                if(data.result){
                    parent.refresh();
                    var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                    parent.layer.close(index); //再执行关闭
                }
            }
        };
        $('#addConvertForm').ajaxForm(options);
    });

</script>
