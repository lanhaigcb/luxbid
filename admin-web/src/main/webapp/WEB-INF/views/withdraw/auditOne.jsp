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
                    <form class="form-horizontal m-t" method="post" id="addForm" action = "withdraw/auditOne" enctype="multipart/form-data">
                        <input type="hidden" name="id" value="${detail.recId}"/>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">币种：</label>
                            <div class="col-sm-8">
                                <input id="symbol" name="symbol" class="form-control" type="text" value="${detail.symbol}" readonly>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">姓名：</label>
                            <div class="col-sm-8">
                                <input id="name" name="name" class="form-control" type="text" value="${detail.realName}" readonly />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">身份证：</label>
                            <div class="col-sm-8">
                                <input  class="form-control"  name="id_card" id="id_card" value="${detail.idCardNumber}" readonly />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">金额：</label>
                            <div class="col-sm-8">
                                <input id="amount" name="amount" class="form-control" type="text" value="${detail.amount}" readonly/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">提币地址：</label>
                            <div class="col-sm-8">
                                <input id="receiveAddress" name="receiveAddress" class="form-control" type="text" value="${detail.receiveAddress}" readonly/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label">申请时间：</label>
                            <div class="col-sm-8">
                                <input id="applyTime" name="applyTime" class="form-control" type="text" value="<fmt:formatDate value="${detail.applyTime}" pattern="yyyy-MM-dd HH:mm:ss" />" readonly/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label">手续费：</label>
                            <div class="col-sm-8">
                                <input id="fee" name="fee" class="form-control" type="text" value="${detail.fee}" readonly/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label">是否通过：</label>
                            <div class="col-sm-8">
                                <select id="pass" name="pass" class=" form-control">
                                    <option value="">请选择</option>
                                    <option value="true">通过</option>
                                    <option value="false">驳回</option>
                                </select>
                                <p style="color: ${status?"green":"red"}">备付余额: ${balance}${detail.symbol}&nbsp;${status?"余额充足!":"余额不足!"}</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">审核备注：</label>
                            <div class="col-sm-8">
                                <textarea id="note" name="note" class="form-control"></textarea>
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

            var options = {
                beforeSubmit : function() {
                    var pass=$("#pass").val();
                    if(pass == null || pass == ""){
                        layer.msg('请选择是否通过！');
                        return false;
                    }
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