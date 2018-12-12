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
                    <form class="form-horizontal m-t" method="post" id="addForm" action = "exchange/add" enctype="multipart/form-data">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">交易币种：</label>
                            <div class="col-sm-8">
                                <select class="form-control show-tick"  id="baseCurrencyId" name="baseCurrencyId">
                                    <option value="">请选择</option>
                                    <c:forEach items="${currencys}" var="currency">
                                        <option value="${currency.id}">${currency.symbol}&nbsp;(${currency.chName})</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">对标币种：</label>
                            <div class="col-sm-8">
                                <select class="form-control show-tick"  id="quoteCurrencyId" name="quoteCurrencyId">
                                    <option value="">请选择</option>
                                    <c:forEach items="${currencys}" var="currency">
                                        <option value="${currency.id}">${currency.symbol}&nbsp;(${currency.chName})</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">交易手续费率：</label>
                            <div class="col-sm-8">
                                <input id="exRate" name="exRate" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">交易最小单笔金额：</label>
                            <div class="col-sm-8">
                                <input id="minTradeLimit" name="minTradeLimit" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">是否显示：</label>
                            <div class="col-sm-8">
                                <select id="show" name="show" class=" form-control">
                                    <option value="">请选择</option>
                                    <option value="true">是</option>
                                    <option value="false">否</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">是否使用外部K线：</label>
                            <div class="col-sm-8">
                                <select id="outKline" name="outKline" class=" form-control">
                                    <option value="">请选择</option>
                                    <option value="true">是</option>
                                    <option value="false">否</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">排序参数：</label>
                            <div class="col-sm-8">
                                <input id="orderParameter" name="orderParameter" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">选择分区：</label>
                            <div class="col-sm-8">
                                <select class="form-control" id="partitionType" name="partitionType">
                                    <c:forEach items="${types}" var="type">
                                        <option value="${type.name()}" title="${type.toString()}" >${type.toString()}</option>
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