<%@ page contentType="text/html;charset=UTF-8" language="java" %><!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp"%>
<!DOCTYPE html>
<html>
    <%@include file="../common/head-title.jsp"%>
    <%@include file="../common/kindeditor.jsp" %>
    <script src="theme/js/custom/staff/form-validate-affiche.min.js"></script>
<body class="">
<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <form class="form-horizontal m-t" method="post" id="updateForm" action = "affiche/update" enctype="multipart/form-data">
                        <input id="id" name="id" value="${afficheInfo.id}" type="hidden">
                        <div class="form-group">
                            <div class="form-group">
                                <label class="col-sm-3 control-label">标题：</label>
                                <div class="col-sm-8">
                                    <input id="titlle" name="title" class="form-control" type="text" value="${afficheInfo.title}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">公告类型：</label>
                                <div class="col-sm-8">
                                    <select id="noticeType" name="noticeType" class=" form-control">
                                        <option value="NOTICE" <c:if test="${afficheInfo.noticeType=='NOTICE'}">selected="selected"</c:if>>公告</option>
                                        <option value="MEDIA" <c:if test="${afficheInfo.noticeType=='MEDIA'}">selected="selected"</c:if>>媒体</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">客户端类型：</label>
                                <div class="col-sm-8">
                                    <select id="clientType" name="clientType" class=" form-control">
                                        <option value="PC" <c:if test="${afficheInfo.clientType=='PC'}">selected="selected"</c:if>>PC</option>
                                        <option value="APP" <c:if test="${afficheInfo.clientType=='APP'}">selected="selected"</c:if>>APP</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">是否可用：</label>
                                <div class="col-sm-8">
                                    <select id="enable" name="enable" class=" form-control">
                                        <option value="">请选择</option>
                                        <option <c:if test="${afficheInfo.enable==true}">selected="selected"</c:if> value="true">是</option>
                                        <option <c:if test="${afficheInfo.enable==false}">selected="selected"</c:if> value="false">否</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">排序参数：</label>
                                <div class="col-sm-8">
                                    <input id="sortParameter" name="sortParameter" class="form-control" type="text" value="${afficheInfo.sortParameter}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">国际化类型：</label>
                                <div class="col-sm-8">
                                    <select id="internationalType" name="internationalType" class=" form-control">
                                        <option value="">请选择</option>
                                        <option <c:if test="${afficheInfo.internationalType=='zh-CN'}">selected="selected"</c:if> value="zh-CN">中国大陆</option>
                                        <option <c:if test="${afficheInfo.internationalType=='zh-TW'}">selected="selected"</c:if> value="zh-TW">中国台湾</option>
                                        <option <c:if test="${afficheInfo.internationalType=='en-US'}">selected="selected"</c:if> value="en-US">美国</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">图片地址：</label>
                                <div class="col-sm-8">
                                    <input type="file" class="form-control"  name="imageURIFile" id="imageURIFile">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">外部链接地址：</label>
                                <div class="col-sm-8">
                                    <input id="externalLinks" name="externalLinks" class="form-control" type="text" value="${afficheInfo.externalLinks}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">内容：</label>
                                <div class="col-sm-8">
                                     <textarea id="content" name="content" maxlength="4000"
                                               class="easyui-validatebox"  style="width: 830px;float: left;height: 300px" >${afficheInfo.content}</textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">发布时间：</label>
                                <div class="input-daterange col-sm-8" id="datepicker">
                                    <input id="publishTime" name="publishTime" class="form-control" type="text" placeholder="yyyy-MM-dd HH:mm:ss" value="<fmt:formatDate value="${afficheInfo.publishTime}" pattern="yyyy-MM-dd HH:mm:ss"></fmt:formatDate>">
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