<%@ page contentType="text/html;charset=UTF-8" language="java" %><!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="b" %>
<%@include file="../common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<%@include file="../common/head-title.jsp"%>
<%@include file="../common/kindeditor.jsp" %>
<script src="theme/js/custom/staff/form-validate-awardConfig.min.js"></script>
<body class="">
<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <form class="form-horizontal m-t" method="post" id="addConvertForm" action = "activityConfig/save" enctype="multipart/form-data">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">奖励币种：</label>
                            <div class="col-sm-4">
                                <select class="form-control show-tick"  id="currencyId" name="currencyId" value="${activityConfigVo.currencyId}">
                                    <c:forEach items="${listCurrencyVo}" var="v">
                                        <option <c:if test="${activityConfigVo.currencyId==v.id}">selected="selected"</c:if> value="${v.id}">${v.symbol}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">奖励数量：</label>
                            <div class="col-sm-4">
                                <input id="awardNum" name="awardNum" class="form-control" type="text" value="${activityConfigVo.awardNum}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">奖励概率：</label>
                            <div class="col-sm-4">
                                <input id="prob" name="prob" class="form-control" type="text" value="${activityConfigVo.prob}">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-4 col-sm-offset-3">
                                <c:choose>
                                    <c:when test="${empty activityConfigVo}">
                                        <input id="activityId" name="activityId" class="form-control" type="hidden" value="${activityId}">
                                    </c:when>
                                    <c:otherwise>
                                        <input id="activityId" name="activityId" class="form-control" type="hidden" value="${activityConfigVo.activityId}">
                                    </c:otherwise>
                                </c:choose>
                                <input id="id" name="id" class="form-control" type="hidden" value="${activityConfigVo.id}">
                                <input id="status" name="status" class="form-control" type="hidden" value="${activityConfigVo.status}">
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
