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
                    <form class="form-horizontal m-t" method="post" id="updateIdcardForm" action="idAudit/update"
                          enctype="multipart/form-data">
                        <input id="id" name="id" value="${info.id}" type="hidden">
                        <div class="form-group">





                            <div class="form-group">
                                <label class="col-sm-3 control-label">邀请人ID：</label>
                                <div class="col-sm-8">
                                    <input id="inviterId" name="realName" class="form-control" type="text"
                                           contenteditable="false" value="${customerVo.inviter}" disabled>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-3 control-label">用户名：</label>
                                <div class="col-sm-8">
                                    <input id="realName" name="realName" class="form-control" type="text"
                                           contenteditable="false" value="${info.realName}" disabled>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-3 control-label">身份证：</label>
                                <div class="col-sm-8">
                                    <input id="idcardNumber" name="idcardNumber" class="form-control" type="text"
                                           contenteditable="false" value="${info.idcardNumber}" disabled>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">图片：</label>
                                <div class="col-sm-8">
                                    <c:forEach items="${info.pics}" var="iterm" varStatus="status">
                                        <img src="${iterm.toString()}" width="800px"/>
                                    </c:forEach>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">是否审核通过：</label>
                                <div class="col-sm-8">
                                    <select id="audit" name="audit" class=" form-control">
                                        <option value="">请选择</option>
                                        <option value="true">是</option>
                                        <option value="false">否</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">审核备注选项：</label>
                                <div class="col-sm-8">
                                    <select id="slList" name="slList" class=" form-control" onchange="selectShow()">
                                        <option value="">请选择</option>
                                        <option value="通过">通过</option>
                                        <option value="照片包含其他标识水印">照片包含其他标识水印</option>
                                        <option value="身份证过期">身份证过期</option>
                                        <option value="信息错误，图片信息不一致">信息错误，图片信息不一致</option>
                                        <option value="有P图痕迹">有P图痕迹</option>
                                        <option value="照片模糊,身份证信息不全">照片模糊,身份证信息不全</option>
                                        <option value="无手持“BIHUEX+名字+日期”字条">无手持“BIHUEX+名字+日期”字条</option>
                                        <option value="未成年，65岁以上">未成年，65岁以上</option>
                                        <label class="col-sm-3 control-label">审核备注内容：</label>
                                    </select>
                                    <textarea name="note" id="note" value=""></textarea>
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

    function selectShow() {
        document.getElementById("note").value = document.getElementById("slList").value;
    }

    $(function () {


        var e = "<i class='fa fa-times-circle'></i> ";
        $("#updateIdcardForm").validate({
            rules: {
                note: {required: !0},
                audit: {required: !0}
            },
            messages: {
                note: {required: e + "审核备注不能为空"},
                audit: {required: e + "请选择是否审核通过"}
            }
        });
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
        $('#updateIdcardForm').ajaxForm(options);

    });

</script>
</html>