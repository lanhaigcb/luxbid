<%@ page import="com.mine.common.enums.MobileOsType" %>
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
                    <form class="form-horizontal m-t" method="post" id="versionUpdateAddForm" action = "versionUpdate/add" enctype="multipart/form-data">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">最新版本号：</label>
                            <div class="col-sm-8">
                                <input id="newVersion" name="newVersion" placeholder="正整数" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">最低版本号：</label>
                            <div class="col-sm-8">
                                <input id="lowVersion" name="lowVersion" placeholder="正整数" class="form-control" type="text">
                            </div>
                        </div>

                        <%--<div class="form-group">
                            <label class="col-sm-3 control-label">上传安装包：</label>
                            <div class="col-sm-8">
                                <input id="uploadFile" name="file"  class="form-control" type="file">
                            </div>
                        </div>--%>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">系统类型：</label>
                            <div class="col-sm-8">
                                <select id="osType" name="osType" class=" form-control">
                                    <option value="">请选择</option>
                                    <c:forEach items="<%=MobileOsType.values()%>" var="v">
                                        <option value="${v.name()}">${v.name()}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">下载链接：</label>
                            <div class="col-sm-8">
                                <input id="url" name="url" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">渠道：</label>
                            <div class="col-sm-8">
                                <input id="versionInfo" name="versionInfo" class="form-control" type="text" placeholder="IOS不上传">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-8 col-sm-offset-3">
                                <button class="btn btn-primary" type="submit">提交</button>
                            </div>
                        </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
    <script>

        $(function (){
            var e="<i class='fa fa-times-circle'></i> ";
            $("#versionUpdateAddForm").validate({
                rules:{
                    newVersion:{required:!0},
                    lowVersion:{required:!0},
                    osType:{required:!0},
                    url:{required:!0}
                },
                messages:{
                    newVersion:{required:e+"最新版本号不能为空"},
                    lowVersion:{required:e+"最低版本号不能为空"},
                    osType:{required:e+"系统类型不能为空"},
                    url:{required:e+"下载链接不能为空"}
                }
            });



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
            $('#versionUpdateAddForm').ajaxForm(options);

        });

    </script>
</html>