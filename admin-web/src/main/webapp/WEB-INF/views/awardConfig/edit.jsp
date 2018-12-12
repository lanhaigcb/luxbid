<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                    <form class="form-horizontal m-t" method="post" id="updateConvertForm" action = "awardConfig/update" enctype="multipart/form-data">
                        <div class="form-group">
                            <input id="id" name="id" class="form-control" type="hidden" value="${awardConfigVo.id}">
                            <label class="col-sm-3 control-label">奖励活动名称：</label>
                            <div class="col-sm-4">
                                <input id="awardConfigName" name="awardConfigName" class="form-control" type="text" value="${awardConfigVo.awardConfigName}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">奖励币种：</label>
                            <div class="col-sm-4">
                                <select class="form-control show-tick"  id="symbol" name="symbol">
                                    <option value="" >请选择</option>
                                    <c:forEach items="${currencys}" var="currency">
                                        <option <c:if test="${awardConfigVo.symbol==currency.symbol}">selected="selected"</c:if> value="${currency.symbol}">${currency.symbol}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">奖励预算总数量：</label>
                            <div class="col-sm-4">
                                <input id="awardNumTotal" name="awardNumTotal" class="form-control" type="text" value="${awardConfigVo.awardNumTotal}">
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

