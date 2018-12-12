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
                    <form class="form-horizontal m-t" method="post" id="updateForm" action = "#" enctype="multipart/form-data">
                        <input id="id" name="id" value="${afficheInfo.id}" type="hidden">
                        <input id="publishTime" name="publishTime" value="${afficheInfo.publishTime}" type="hidden">
                        <div class="form-group">
                            <div class="form-group">
                                <label class="col-sm-3 control-label">标题：</label>
                                <div class="col-sm-8">
                                    <input id="title" name="title" class="form-control" type="text" value="${afficheInfo.title}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">公告内容：</label>
                                <div class="col-sm-8">
                                    <textarea id="content" name="content" required='true' maxlength="5000"
                                              class="easyui-validatebox"
                                              style="width: 830px;float: left;height: 300px" >${afficheInfo.content}</textarea>
                                </div>
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
            $('#updateForm').ajaxForm(options);

        });

    </script>
</html>