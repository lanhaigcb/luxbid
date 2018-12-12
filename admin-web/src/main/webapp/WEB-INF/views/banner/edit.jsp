<%@ page import="com.mine.common.enums.BannerTerminalType" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
                    <form class="form-horizontal m-t" method="post" id="updateForm" action = "banner/update" enctype="multipart/form-data">
                        <input id="id" name="id" value="${banner.id}" type="hidden">
                        <input id="createTime" name="createTime" value="${banner.createTime}" type="hidden">
                        <input id="imageURI" name="imageURI" value="${banner.imageURI}" type="hidden">
                        <div class="form-group">
                            <div class="form-group">
                                <label class="col-sm-3 control-label">名称：</label>
                                <div class="col-sm-8">
                                    <input id="name" name="name" class="form-control" type="text" value="${banner.name}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">图片地址：</label>
                                <div class="col-sm-8">
                                    <input type="file" class="form-control"  name="imageURIFile" id="imageURIFile">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">落地页地址：</label>
                                <div class="col-sm-8">
                                    <input id="htmlURL" name="htmlURL" class="form-control" type="text" value="${banner.htmlURL}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">落地页标题：</label>
                                <div class="col-sm-8">
                                    <input id="htmlTitle" name="htmlTitle" class="form-control" type="text" value="${banner.htmlTitle}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">是否可用：</label>
                                <div class="col-sm-8">
                                    <select id="enable" name="enable" class=" form-control">
                                        <option value="">请选择</option>
                                        <option <c:if test="${banner.enable==true}">selected="selected"</c:if> value="true">是</option>
                                        <option <c:if test="${banner.enable==false}">selected="selected"</c:if> value="false">否</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">结束时间：</label>
                                <div class="col-sm-8 input-daterange" id="datepicker">
                                    <input id="endTime" name="endTime" class="form-control" type="text" placeholder="yyyy-MM-dd" value="<fmt:formatDate value="${banner.endTime}" pattern="yyyy-MM-dd"></fmt:formatDate>">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">排序参数：</label>
                                <div class="col-sm-8">
                                    <input id="sortParameter" name="sortParameter" class="form-control" type="text" value="${banner.sortParameter}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">终端：</label>
                                <div class="col-sm-8">
                                    <select id="terminalType" name="terminalType" class=" form-control">
                                        <c:forEach items="<%=BannerTerminalType.values()%>" var="v">
                                            <option value="${v.name()}" <c:if test="${banner.terminalType eq v}">selected</c:if> >${v.name()}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">国际化类型：</label>
                                <div class="col-sm-8">
                                    <select id="bannerType" name="internationalType" class=" form-control">
                                        <option value="">请选择</option>
                                        <option <c:if test="${banner.internationalType=='zh-CN'}">selected="selected"</c:if> value="zh-CN">中国大陆</option>
                                        <option <c:if test="${banner.internationalType=='zh-TW'}">selected="selected"</c:if> value="zh-TW">中国台湾</option>
                                        <option <c:if test="${banner.internationalType=='en-US'}">selected="selected"</c:if> value="en-US">美国</option>
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

        $("#datepicker").datepicker({
            keyboardNavigation: !1,
            forceParse: !1,
            autoclose: !0,
        });

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