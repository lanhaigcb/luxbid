<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<%@include file="../common/head-title.jsp" %>
<body class="">
<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <form class="form-horizontal m-t" method="post" id="form" action="loanAmountRate/save">
                        <div class="form-group">
                            <input id="id" name="id" value="${loanAmountRateVo.id}" class="form-control" type="hidden">
                            <input id="createTimeStr" name="createTimeStr" value="${loanAmountRateVo.createTimeStr}" class="form-control" type="hidden">
                            <label class="col-sm-3 control-label">产品名称：</label>
                            <div class="col-sm-8">
                                <select id="productId" name="productId" class=" form-control"">
                                    <option value="">请选择</option>
                                    <c:forEach items="${listLoanCurrencyProductVo}" var="vo">
                                        <option value="${vo.id}" <c:if test="${vo.id == loanAmountRateVo.productId}">selected="true"</c:if>>${vo.symbol}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">利率对应最低金额：</label>
                            <div class="col-sm-8">
                                <input id="minLimit" name="minLimit" class="form-control"
                                       value="${loanAmountRateVo.minLimit}" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">利率对应最高金额：</label>
                            <div class="col-sm-8">
                                <input id="maxLimit" name="maxLimit" class="form-control"
                                       value="${loanAmountRateVo.maxLimit}" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">利率：</label>
                            <div class="col-sm-8">
                                <input id="rate" name="rate" class="form-control"
                                       value="${loanAmountRateVo.rate}" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">是否启用：</label>
                            <div class="col-sm-8">
                                <div class="radio i-checks">
                                    <c:choose>
                                        <c:when test="${empty loanAmountRateVo}">
                                            <label><input type="radio" value="true" name="enable" checked="checked"> <i></i>
                                                是</label>
                                            <label><input type="radio" value="false" name="enable"> <i></i> 否</label>
                                        </c:when>
                                        <c:otherwise>
                                            <label><input type="radio" value="true" name="enable" <c:if test="${loanAmountRateVo.enable == true}">checked="checked"</c:if>> <i></i>
                                                是</label>
                                            <label><input type="radio" value="false" name="enable" <c:if test="${loanAmountRateVo.enable == false}">checked="checked"</c:if>> <i></i> 否</label>
                                        </c:otherwise>
                                    </c:choose>
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
    <!--异步提交表单验证提交-->
    $(function () {
        var options = {
            beforeSubmit: function () {
                var productId = $("#productId").val().trim();
                var minLimit = $("#minLimit").val();
                var maxLimit = $("#maxLimit").val();
                var rate = $("#rate").val();
                if (productId == "") {
                    layer.msg('请选择 产品！');
                    return false;
                }
                if (!isRealNum(minLimit)) {
                    layer.msg("请输入数字格式 利率对应最低金额");
                    return false;
                }
                if (!isRealNum(maxLimit)) {
                    layer.msg("请输入数字格式 利率对应最高金额");
                    return false;
                }
                if (!isRealNum(rate)) {
                    layer.msg("请输入数字格式 利率");
                    return false;
                }
            },
            error: function () {
                layer.msg('请求错误！');
            },
            success: function (data) {

                layer.msg(data.message);
                if (data.result) {
                    var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引

                    parent.refresh();
                    parent.layer.close(index); //再执行关闭
                }
                $("#bsTable").bootstrapTable("refresh", {url: 'loanAmountRate/list.json'});
            }
        };
        $('#form').ajaxForm(options);

    });

    function isRealNum(val) {
        if (val === "" || val == null) {
            return false;
        }
        if (!isNaN(val)) {
            return true;
        } else {
            return false;
        }
    }

</script>
</html>
