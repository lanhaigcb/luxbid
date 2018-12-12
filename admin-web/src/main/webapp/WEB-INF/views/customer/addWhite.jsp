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
                    <form class="form-horizontal m-t" method="post" id="addWhiteForm" action = "customer/addWhiteList" enctype="multipart/form-data">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">用户帐号：</label>
                            <div class="col-sm-8">
                                <input id="customerId" name="customerId" value="${customerId}" class="form-control" type="hidden">
                                <c:if test="${customer.regType == 'MOBILE'}">
                                    <input id="account" name="account" value="${customer.mobile}" class="form-control" type="text">
                                </c:if>
                                <c:if test="${customer.regType == 'EMAIL'}">
                                    <input id="account" name="account" value="${customer.email}" class="form-control" type="text">
                                </c:if>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">交易对：</label>
                            <div class="col-sm-8">
                                <select id="exchange" name="exchangeId" class=" form-control">
                                    <option value="">请选择</option>
                                    <c:forEach items="${voList}" var="v" >
                                        <option value="${v.id}">${v.symbol}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">申请备注：</label>
                            <div class="col-sm-8">
                                <input id="note" name="note" class="form-control" type="text">
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
            $("#addWhiteForm").validate({
                rules:{
                    note:{required:!0},
                    customerId:{required:!0},
                    exchange:{required:!0}
                },
                messages:{
                    note:{required:e+"审核备注不能为空"},
                    customerId:{required:e+"用户id不能为空"},
                    exchange:{required:e+"交易对不能为空"}
                }
            });
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
            $('#addWhiteForm').ajaxForm(options);

        });

    </script>
</html>