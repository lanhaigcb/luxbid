<%@ page import="com.mine.common.enums.ActivityStatus" %>
<%@ page import="com.mine.common.enums.InternationType" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<%@include file="../common/head-title.jsp" %>
<script src="theme/js/custom/staff/form-validate-banner.min.js"></script>

<body class="">
<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <form class="form-horizontal m-t" method="post" id="addForm" action="act/update"
                          enctype="multipart/form-data">
                        <input type="hidden" name="id" value="${vo.id}"/>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">标题：</label>
                            <div class="col-sm-8">
                                <input id="title" name="title" class="form-control" type="text" value="${vo.title}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">图片地址：</label>
                            <div class="col-sm-8">
                                <input type="file" class="form-control" name="imageURIFile" id="imageURIFile">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">落地页地址：</label>
                            <div class="col-sm-8">
                                <input id="url" name="url" class="form-control" type="text" value="${vo.url}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label">是否显示：</label>
                            <div class="col-sm-8">
                                <select id="show" name="show" class=" form-control">
                                    <option <c:if test="${vo.show==true}">selected="selected"</c:if> value="true">是</option>
                                    <option <c:if test="${vo.show==false}">selected="selected"</c:if> value="false">否</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label">开始时间：</label>
                            <div class="input-daterange col-sm-8" id="start_datepicker">
                                <input id="startTime" name="startTime" class="form-control" type="text" placeholder="yyyy-MM-dd HH:mm:ss"
                                       value="<fmt:formatDate value="${vo.startTime}" pattern="yyyy-MM-dd HH:mm:ss" />"/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label">结束时间：</label>
                            <div class="input-daterange col-sm-8" id="end_datepicker">
                                <input id="endTime" name="endTime" class="form-control" type="text" placeholder="yyyy-MM-dd HH:mm:ss"
                                       value="<fmt:formatDate value="${vo.endTime}" pattern="yyyy-MM-dd HH:mm:ss" />"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">排序参数：</label>
                            <div class="col-sm-8">
                                <input id="sortParameter" name="sortParameter" class="form-control" type="text"
                                       value="${vo.sortParameter}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label">规则：</label>
                            <div class="col-sm-8">
                                <input id="rule" name="rule" class="form-control" type="text" value="${vo.rule}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label">国际化类型：</label>
                            <div class="col-sm-8">
                                <div class="col-sm-8">
                                    <select id="internationType" name="internationType" class=" form-control">
                                        <c:forEach items="<%=InternationType.values()%>" var="v">
                                            <option value="${v.name()}" <c:if test="${vo.internationType eq v}">selected</c:if> >${v.toString()}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label">活动状态：</label>
                            <div class="col-sm-8">
                                <div class="col-sm-8">
                                    <select id="activityStatus" name="activityStatus" class=" form-control">
                                        <c:forEach items="<%=ActivityStatus.values()%>" var="v">
                                            <option value="${v.name()}" <c:if test="${vo.activityStatus eq v}">selected</c:if>>${v.toString()}</option>
                                        </c:forEach>
                                    </select>
                                </div>
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

    $(function () {

        var options = {
            beforeSubmit: function () {
            },
            error: function () {
                layer.msg('请求错误！');
            },
            success: function (data) {
                layer.msg(data.message);
                if (data.result) {
                    parent.refresh();
                    var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                    parent.layer.close(index); //再执行关闭
                }
            }
        };
        $('#addForm').ajaxForm(options);

    });

</script>
</html>