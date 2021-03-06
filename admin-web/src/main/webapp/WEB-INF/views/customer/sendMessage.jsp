<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<%@include file="../common/head-title.jsp" %>
<%@include file="../common/kindeditor.jsp" %>
<script src="theme/js/custom/staff/form-validate-banner.min.js"></script>

<body class="">
<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <form class="form-horizontal m-t" method="post" id="form" action="customer/saveMessage"
                          enctype="multipart/form-data">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">内容：</label>
                            <div class="col-sm-8">
                                <input id="content" name="content" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-8 col-sm-offset-3">
                                <input type="hidden" name="customerId" value="${customerId}">
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

    $(function () {
        var options = {
            beforeSubmit: function () {
                var content = $("#content").val();
                if (content.length > 200) {
                    layer.msg('内容不可超过200字！');
                    return false;
                }
                if (content.length = 0 || content.trim() == "") {
                    layer.msg('请输入内容');
                    return false;
                }
            },
            error: function () {
                layer.msg('请求错误！');
            },
            success: function (data) {
                layer.msg(data.message);
                if (data.result) {
                    //parent.refresh();
                    var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                    parent.layer.close(index); //再执行关闭
                }
            }
        };
        $('#form').ajaxForm(options);

    });

</script>
</html>