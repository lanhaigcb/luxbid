<%@ page import="com.mine.common.enums.BannerTerminalType" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %><!DOCTYPE html>
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
                    <form class="form-horizontal m-t" method="post" id="addForm" action = "banner/add" enctype="multipart/form-data">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">名称：</label>
                            <div class="col-sm-8">
                                <input id="name" name="name" class="form-control" type="text">
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
                                <input id="htmlURL" name="htmlURL" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">落地页标题：</label>
                            <div class="col-sm-8">
                                <input id="htmlTitle" name="htmlTitle" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">是否可用：</label>
                            <div class="col-sm-8">
                                <select id="enable" name="enable" class=" form-control">
                                    <option value="">请选择</option>
                                    <option value="true">是</option>
                                    <option value="false">否</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">结束时间：</label>
                            <div class="input-daterange col-sm-8" id="datepicker">
                                <input id="endTime" name="endTime" class="form-control" type="text" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">排序参数：</label>
                            <div class="col-sm-8">
                                <input id="sortParameter" name="sortParameter" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">终端：</label>
                            <div class="col-sm-8">
                                <select id="terminalType" name="terminalType" class=" form-control">
                                    <c:forEach items="<%=BannerTerminalType.values()%>" var="v">
                                        <option value="${v.name()}">${v.name()}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">国际化类型：</label>
                            <div class="col-sm-8">
                                <select id="bannerType" name="internationalType" class=" form-control">
                                    <option value="">请选择</option>
                                        <option value="zh-cn">中国大陆</option>
                                        <option value="zh-tw">中国台湾</option>
                                        <option value="en-us">美国</option>
                                </select>
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
            $('#addForm').ajaxForm(options);

        });

    </script>
</html>