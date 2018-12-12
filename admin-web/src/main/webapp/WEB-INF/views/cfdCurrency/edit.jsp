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
                    <form class="form-horizontal m-t" method="post" id="updateForm" action = "cfdCurrency/update" enctype="multipart/form-data">
                        <input id="id" name="id" value="${cfdCurrency.id}" type="hidden">
                        <input id="image" name="image" value="${cfdCurrency.image}" type="hidden">
                        <div class="form-group">
                            <div class="form-group">
                                <label class="col-sm-3 control-label">符号：</label>
                                <div class="col-sm-8">
                                    <input id="symbol" name="symbol" class="form-control" type="text" value="${cfdCurrency.symbol}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">中文名称：</label>
                                <div class="col-sm-8">
                                    <input id="chName" name="chName" class="form-control" type="text" value="${cfdCurrency.chName}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">图片地址：</label>
                                <div class="col-sm-8">
                                    <img src="${cfdCurrency.image}" height="200" width="200">
                                    <input type="file" class="form-control"  name="imageFILE" id="imageFILE">

                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">精度：</label>
                                <div class="col-sm-8">
                                    <input id="precise" name="precise" class="form-control" type="number" value="${cfdCurrency.precise}">
                                </div>
                            </div>
                           <%-- <div class="form-group">
                                <label class="col-sm-3 control-label">杠杆：</label>
                                <div class="col-sm-8">
                                    <input id="leverage" name="leverage" class="form-control" type="number" value="${cfdCurrency.leverage}">
                                </div>
                            </div>--%>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">日利率：</label>
                                <div class="col-sm-8">
                                    <input id="dayRate" name="dayRate" class="form-control" type="text" value="${cfdCurrency.dayRate}">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-3 control-label">手续费率：</label>
                                <div class="col-sm-8">
                                    <input id="feeRate" name="feeRate" class="form-control" type="number" value="${cfdCurrency.feeRate}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">选择币种系列：</label>
                                <div class="col-sm-4">
                                    <select class="form-control show-tick"  id="currencyId" name="currencyId">
                                        <c:forEach items="${currency}" var="currency">
                                            <option value="${currency.id}" <c:if test="${currency.id==cfdCurrency.currencyId}">selected="selected"</c:if>>${currency.symbol}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">单笔交易最小限额：</label>
                                <div class="col-sm-8">
                                    <input id="tradeMinLimit" name="tradeMinLimit" class="form-control" type="number" value="${cfdCurrency.tradeMinLimit}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">单笔交易最大限额：</label>
                                <div class="col-sm-8">
                                    <input id="tradeMaxLimit" name="tradeMaxLimit" class="form-control" type="number" value="${cfdCurrency.tradeMaxLimit}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">最大持仓量：</label>
                                <div class="col-sm-8">
                                    <input id="maxPositionLimit" name="maxPositionLimit" class="form-control" type="number" value="${cfdCurrency.maxPositionLimit}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">买涨点差：</label>
                                <div class="col-sm-8">
                                    <input id="riseSpread" name="riseSpread" class="form-control" type="number" value="${cfdCurrency.riseSpread}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">买跌点差：</label>
                                <div class="col-sm-8">
                                    <input id="fallSpread" name="fallSpread" class="form-control" type="number" value="${cfdCurrency.fallSpread}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">是否可用：</label>
                                <div class="col-sm-8">
                                    <select class="form-control show-tick"  id="enable" name="enable">
                                        <option value="true" <c:if test="${cfdCurrency.enable==true}">selected="selected"</c:if>>可用</option>
                                        <option value="false"<c:if test="${cfdCurrency.enable==false}">selected="selected"</c:if>>禁用</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group hidden" >
                                <label class="col-sm-3 control-label">创建时间：</label>
                                <div class="col-sm-8 input-daterange" id="datepicker">
                                    <input id="createTime" name="createTime" class="form-control" type="text" placeholder="yyyy-MM-dd HH:mm:ss" value="<fmt:formatDate value="${cfdCurrency.createTime}" pattern="yyyy-MM-dd HH:mm:ss"></fmt:formatDate>">
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