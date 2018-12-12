<%@ page import="com.mine.common.enums.WhiteListApplyStatus" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %><!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<%@include file="../common/head-title.jsp"%>
<%@include file="../common/kindeditor.jsp" %>
<script src="theme/js/custom/staff/form-validate-banner.min.js"></script>

<body class="">
<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <form class="form-horizontal m-t" method="post" id="auditWhiteForm" action = "whitelist/pass" enctype="multipart/form-data">
                        <input id="id" name="id" class="form-control" value="${id}" type="hidden">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">审核：</label>
                            <div class="col-sm-8">
                                <select id="exchange" name="pass" class=" form-control">
                                    <option value="">请选择</option>
                                    <option value="1">通过</option>
                                    <option value="0">拒绝</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">申请类型：</label>
                            <div class="col-sm-8">
                                <select id="applyType" name="applyType" class=" form-control">
                                    <option value="">请选择</option>
                                    <option value="EX_FREE">免手续费</option>
                                    <option value="EX_FORBID">交易禁止</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">备注：</label>
                            <div class="col-sm-8">
                                <input id="note" name="note" class="form-control" type="text">
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

</body>
<script>

    $(function (){
        var e="<i class='fa fa-times-circle'></i> ";
        $("#auditWhiteForm").validate({
            rules:{
                note:{required:!0},
                id:{required:!0},
                exchange:{required:!0}
            },
            messages:{
                note:{required:e+"审核备注不能为空"},
                id:{required:e+"用户id不能为空"},
                exchange:{required:e+"审核不能为空"}
            }
        });
        createKindEditor('textarea[name="content"]');
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
        $('#auditWhiteForm').ajaxForm(options);

    });

</script>
</html>