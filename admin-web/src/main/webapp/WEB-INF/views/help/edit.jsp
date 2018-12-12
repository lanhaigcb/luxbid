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
                    <form class="form-horizontal m-t" method="post" id="updateForm" action = "help/update" enctype="multipart/form-data">
                        <input id="id" name="id" value="${categoryVo.id}" type="hidden">
                        <div class="form-group">
                            <div class="form-group">
                                <label class="col-sm-3 control-label">分类：</label>
                                <div class="col-sm-8">
                                    <input id="category" name="category" class="form-control" type="text" value="${categoryVo.category}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">是否可用：</label>
                                <div class="col-sm-8">
                                    <select id="enable" name="enable" class=" form-control">
                                        <option value="">请选择</option>
                                        <option <c:if test="${categoryVo.enable==true}">selected="selected"</c:if> value="true">是</option>
                                        <option <c:if test="${categoryVo.enable==false}">selected="selected"</c:if> value="false">否</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">排序参数：</label>
                                <div class="col-sm-8">
                                    <input id="sortParam" name="sortParam" class="form-control" type="text" value="${categoryVo.sortParam}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">国际化类型：</label>
                                <div class="col-sm-8">
                                    <select id="internationalType" name="internationalType" class=" form-control">
                                        <option value="">请选择</option>
                                        <option <c:if test="${categoryVo.internationalType=='zh-CN'}">selected="selected"</c:if> value="zh-CN">中国大陆</option>
                                        <option <c:if test="${categoryVo.internationalType=='zh-TW'}">selected="selected"</c:if> value="zh-TW">中国台湾</option>
                                        <option <c:if test="${categoryVo.internationalType=='en-US'}">selected="selected"</c:if> value="en-US">美国</option>
                                    </select>
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