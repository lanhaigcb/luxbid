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
                    <form class="form-horizontal m-t" method="post" id="addConvertForm" action = "activity/save" enctype="multipart/form-data">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">方案名称：</label>
                            <div class="col-sm-4">
                                <input id="activityName" name="activityName" class="form-control" type="text" value="${activityVo.activityName}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">抽奖次数：</label>
                            <div class="col-sm-4">
                                <input id="lotteryNumber" name="lotteryNumber" class="form-control" type="text" value="${activityVo.lotteryNumber}">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-4 col-sm-offset-3">
                                <input id="id" name="id" class="form-control" type="hidden" value="${activityVo.id}">
                                <input id="enable" name="enable" class="form-control" type="hidden" value="${activityVo.enable}">
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
