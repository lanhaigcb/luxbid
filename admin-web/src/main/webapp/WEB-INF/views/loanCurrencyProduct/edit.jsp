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
                    <form class="form-horizontal m-t" method="post" id="form" action="loanCurrencyProduct/save">
                        <div class="form-group">
                            <input id="id" name="id" value="${loanCurrencyProductVo.id}" class="form-control" type="hidden">
                            <input id="createTimeStr" name="createTimeStr" value="${loanCurrencyProductVo.createTimeStr}" class="form-control" type="hidden">
                            <label class="col-sm-3 control-label">符号：</label>
                            <div class="col-sm-8">
                                <input id="symbol" name="symbol" value="${loanCurrencyProductVo.symbol}"
                                       class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">精度：</label>
                            <div class="col-sm-8">
                                <input id="precise" name="precise" class="form-control"
                                       value="${loanCurrencyProductVo.precise}" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">最小限额：</label>
                            <div class="col-sm-8">
                                <input id="minLimit" name="minLimit" class="form-control"
                                       value="${loanCurrencyProductVo.minLimit}" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">推荐质押率：</label>
                            <div class="col-sm-8">
                                <input id="recommendLoanRate" name="recommendLoanRate" class="form-control"
                                       value="${loanCurrencyProductVo.recommendLoanRate}" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">最高质押率：</label>
                            <div class="col-sm-8">
                                <input id="maxLoanRate" name="maxLoanRate" class="form-control"
                                       value="${loanCurrencyProductVo.maxLoanRate}" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">预警质押率：</label>
                            <div class="col-sm-8">
                                <input id="warningLoanRate" name="warningLoanRate" class="form-control"
                                       value="${loanCurrencyProductVo.warningLoanRate}" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">平仓质押率：</label>
                            <div class="col-sm-8">
                                <input id="unwindLoanRate" name="unwindLoanRate" class="form-control"
                                       value="${loanCurrencyProductVo.unwindLoanRate}" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">借款时长：</label>
                            <div class="col-sm-8">
                                <input id="months" name="months" class="form-control"
                                       value="${loanCurrencyProductVo.months}" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">违约金利率：</label>
                            <div class="col-sm-8">
                                <input id="breakLoanRate" name="breakLoanRate" class="form-control"
                                       value="${loanCurrencyProductVo.breakLoanRate}" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">抵押资格金额：</label>
                            <div class="col-sm-8">
                                <input id="qualifiedAmount" name="qualifiedAmount" class="form-control"
                                       value="${loanCurrencyProductVo.qualifiedAmount}" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">首期免手续费的资格金额：</label>
                            <div class="col-sm-8">
                                <input id="discountInterestAmount" name="discountInterestAmount" class="form-control"
                                       value="${loanCurrencyProductVo.discountInterestAmount}" type="text">
                            </div>
                        </div>


                        <div class="form-group">
                            <label class="col-sm-3 control-label">是否启用：</label>
                            <div class="col-sm-8">
                                <div class="radio i-checks">
                                    <c:choose>
                                        <c:when test="${empty loanCurrencyProductVo}">
                                            <label><input type="radio" value="true" name="enable" checked="checked"> <i></i>
                                                是</label>
                                            <label><input type="radio" value="false" name="enable"> <i></i> 否</label>
                                        </c:when>
                                        <c:otherwise>
                                            <label><input type="radio" value="true" name="enable" <c:if test="${loanCurrencyProductVo.enable == true}">checked="checked"</c:if>> <i></i>
                                                是</label>
                                            <label><input type="radio" value="false" name="enable" <c:if test="${loanCurrencyProductVo.enable == false}">checked="checked"</c:if>> <i></i> 否</label>
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
                var symbol = $("#symbol").val().trim();
                var precise = $("#precise").val();
                var minLimit = $("#minLimit").val();
                var recommendLoanRate = $("#recommendLoanRate").val();
                var warningLoanRate = $("#warningLoanRate").val();
                var unwindLoanRate = $("#unwindLoanRate").val();
                var months = $("#months").val();
                if (symbol == "") {
                    layer.msg('请输入符号！');
                    return false;
                }
                if (!isRealNum(precise)) {
                    layer.msg("请输入数字格式精度");
                    return false;
                }
                if (!isRealNum(minLimit)) {
                    layer.msg("请输入数字格式最小限额");
                    return false;
                }
                if (!isRealNum(recommendLoanRate)) {
                    layer.msg("请输入数字格式推荐质押率");
                    return false;
                }
                if (!isRealNum(warningLoanRate)) {
                    layer.msg("请输入数字格式预警质押率");
                    return false;
                }
                if (!isRealNum(unwindLoanRate)) {
                    layer.msg("请输入数字格式平仓质押率");
                    return false;
                }
                if (months == "") {
                    layer.msg("请输入借款时长");
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
                $("#bsTable").bootstrapTable("refresh", {url: 'loanCurrencyProduct/list.json'});
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
