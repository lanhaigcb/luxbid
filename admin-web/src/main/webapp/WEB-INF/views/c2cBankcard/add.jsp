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
                    <form class="form-horizontal m-t" method="post" id="addForm" action = "c2cBankcard/add" enctype="multipart/form-data">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">银行名：</label>
                            <div class="col-sm-8">
                                <select id="bankName" name="bankName" class=" form-control">
                                    <option value="">请选择</option>
                                    <c:forEach items="${banks}" var="bank">
                                        <option value="${bank.bankName}">${bank.bankName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">支行名称：</label>
                            <div class="col-sm-8">
                                <input id="subBankName" name="subBankName" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">卡号：</label>
                            <div class="col-sm-8">
                                <input id="cardNumber" name="cardNumber" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">持卡人：</label>
                            <div class="col-sm-8">
                                <input id="cardOwner" name="cardOwner" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">币种：</label>
                            <div class="col-sm-8">
                                <select id="symbol" name="symbol" class=" form-control">
                                    <option value="">请选择</option>
                                    <c:forEach items="${currencys}" var="currency">
                                        <option value="${currency.symbol}">${currency.symbol}</option>
                                    </c:forEach>
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