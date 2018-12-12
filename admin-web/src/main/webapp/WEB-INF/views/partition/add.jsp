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
                    <form class="form-horizontal m-t" method="post" id="addPartitionForm" action = "exchangePartition/add" enctype="multipart/form-data">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">分区名称：</label>
                            <div class="col-sm-8">
                                <input id="name" name="name" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">选择分区：</label>
                            <div class="col-sm-8">
                                <select class="form-control" id="type" name="type">
                                    <c:forEach items="${types}" var="type">
                                        <option value="${type.name()}" title="${type.toString()}" >${type.toString()}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label">排序参数：</label>
                            <div class="col-sm-8">
                                <input id="sortParameter" name="sortParameter" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">分区介绍：</label>
                            <div class="col-sm-8">
                                 <textarea id="introduce" name="introduce" required='true' maxlength="5000"
                                           class="easyui-validatebox"
                                           style="width: 830px;float: left;height: 300px"></textarea>
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
            $("#addPartitionForm").validate({
                rules:{
                    name:{required:!0},
                    sortParameter:{required:!0},
                    enable:{required:!0},
                    introduce:{required:!0}
                },
                messages:{
                    name:{required:e+"分区名不能为空"},
                    sortParameter:{required:e+"排序参数不能为空"},
                    enable:{required:e+"是否可用不能为空"},
                    introduce:{required:e+"分区介绍不能为空"}
                }
            });
            createKindEditor('textarea[name="introduce"]');
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
            $('#addPartitionForm').ajaxForm(options);

        });

    </script>
</html>