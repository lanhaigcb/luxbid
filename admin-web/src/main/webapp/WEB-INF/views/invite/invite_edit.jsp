<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                    <form class="form-horizontal m-t" method="post" id="updateConvertForm" action="invite/update" enctype="multipart/form-data">
                        <div class="form-group">
                            <input id="id" name="id" class="form-control" type="hidden" value="${invite.id}">
                            <label class="col-sm-3 control-label">注册奖励币种：</label>
                            <div class="col-sm-4">
                                <select class="form-control show-tick"  id="regSymbol" name="regSymbol">
                                    <option value="" >请选择</option>
                                    <c:forEach items="${currencys}" var="currency">
                                        <option <c:if test="${invite.regSymbol==currency.symbol}">selected="selected"</c:if> value="${currency.symbol}">${currency.symbol}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">注册奖励数量：</label>
                            <div class="col-sm-4">
                                <input id="regAmount" name="regAmount" class="form-control" type="text" value="${invite.regAmount}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">注册奖励总额：</label>
                            <div class="col-sm-4">
                                <input id="registerMax" name="registerMax" class="form-control" type="text" value="${invite.registerMax}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">邀请奖励币种：</label>
                            <div class="col-sm-4">
                                <select class="form-control show-tick"  id="inviteeSymbol" name="inviteeSymbol">
                                    <option value="" >请选择</option>
                                    <c:forEach items="${currencys}" var="currency">
                                        <option <c:if test="${invite.inviteeSymbol==currency.symbol}">selected="selected"</c:if> value="${currency.symbol}">${currency.symbol}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">邀请奖励数量：</label>
                            <div class="col-sm-4">
                                <input id="inviteeAmount" name="inviteeAmount" class="form-control" type="text" value="${invite.inviteeAmount}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">邀请奖励总额：</label>
                            <div class="col-sm-4">
                                <input id="inviteMax" name="inviteMax" class="form-control" type="text" value="${invite.inviteMax}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">页面地址：</label>
                            <div class="col-sm-4">
                                <input id="viewURL" name="viewURL" class="form-control" type="text" value="${invite.viewURL}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">图片地址：</label>
                            <div class="col-sm-4">
                                <input id="imageURL" name="imageURL" class="form-control" type="text" value="${invite.imageURL}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">规则内容：</label>
                            <div class="col-sm-8">
                                 <textarea id="rule" name="rule" required='true' maxlength="5000"
                                           class="easyui-validatebox"
                                           style="width: 800px;float: left;height: 300px">${invite.rule}</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">是否启用：</label>
                            <div class="col-sm-4">
                                <select class="form-control" id="enable" name="enable">
                                    <option <c:if test="${invite.enable==false}">selected="selected"</c:if> value="false">否</option>
                                    <option <c:if test="${invite.enable==true}">selected="selected"</c:if> value="true">是</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">介绍文字：</label>
                            <div class="col-sm-8">
                                 <textarea id="introduction" name="introduction" required='true' maxlength="5000"
                                           class="easyui-validatebox"
                                           style="width: 800px;float: left;height: 50px">${invite.introduction}</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-8 col-sm-offset-3">
                                <button class="btn btn-primary" type="submit">提交</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="theme/js/jquery.min.js?v=2.1.4"></script>
<script src="theme/js/bootstrap.min.js?v=3.3.6"></script>
<script src="theme/js/content.min.js?v=1.0.0"></script>
<script src="theme/js/plugins/validate/jquery.validate.min.js"></script>
<script src="theme/js/plugins/validate/messages_zh.min.js"></script>
<script src="theme/js/plugins/layer/layer.min.js"></script>
<script src="theme/js/jquery.form.js"></script>
<script src="theme/js/custom/staff/form-validate-staff.min.js"></script>
<script src="theme/js/plugins/bootstrap-table/bootstrap-table.min.js"></script>
<script src="theme/js/custom/staff/form-validate-convert.min.js"></script>
</body>

</html>

<script>
    <!--异步提交表单验证提交-->
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
        $('#updateConvertForm').ajaxForm(options);
    });

</script>

