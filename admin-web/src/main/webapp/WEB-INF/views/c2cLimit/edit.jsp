<%@ page contentType="text/html;charset=UTF-8" language="java" %><!DOCTYPE html>
<%@include file="../common/taglib.jsp"%>
<!DOCTYPE html>
<html>
    <%@include file="../common/head-title.jsp"%>
    <script src="theme/js/custom/staff/form-validate-banner.min.js"></script>
<body class="">
<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <form class="form-horizontal m-t" method="post" id="updateForm" action = "c2cLimit/update" enctype="multipart/form-data">
                        <input id="id" name="id" value="${limit.id}" type="hidden">
                        <div class="form-group">

                            <div class="form-group">
                                <label class="col-sm-3 control-label">中文名称：</label>
                                <div class="col-sm-8">
                                    <input id="name" name="name" class="form-control" readonly type="text" value="${limit.name}">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-3 control-label">限制值：</label>
                                <div class="col-sm-8">
                                    <input id="value" name="value" class="form-control" type="text" value="${limit.value}">
                                </div>
                            </div>

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
            $('#updateForm').ajaxForm(options);

        });

    </script>
</html>