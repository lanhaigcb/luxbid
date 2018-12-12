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
                    <form class="form-horizontal m-t" method="post" id="addForm" action = "mytokenCurrency/add" enctype="multipart/form-data">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">注册币种：</label>
                            <div class="col-sm-8">
                                <select class="form-control show-tick"  id="symbol" name="symbol">
                                    <option value="">请选择</option>
                                    <c:forEach items="${currencys}" var="currency">
                                        <option value="${currency.symbol}">${currency.symbol}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">币种英文全名：</label>
                            <div class="col-sm-8">
                                <input id="name" name="name" placeholder="必填" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">币种logo 地址：</label>
                            <div class="col-sm-8">
                                <input id="logo_url" name="logo_url" placeholder="必填" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">币种官方地址：</label>
                            <div class="col-sm-8">
                                <input id="website" name="website" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">官方GitHub账号：</label>
                            <div class="col-sm-8">
                                <input id="github" name="github" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">币种在explorer对应地址：</label>
                            <div class="col-sm-8">
                                <input id="explorer_url" name="explorer_url" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">币种在coinmarketcap上对应的url地址：</label>
                            <div class="col-sm-8">
                                <input id="coinmarketcap_url" name="coinmarketcap_url" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">合约地址：</label>
                            <div class="col-sm-8">
                                <input id="contact_address" name="contact_address" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">twitter账号：</label>
                            <div class="col-sm-8">
                                <input id="twitter" name="twitter" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">facebook账号：</label>
                            <div class="col-sm-8">
                                <input id="facebook" name="facebook" class="form-control" type="text">
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