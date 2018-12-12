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
                    <form class="form-horizontal m-t" method="post" id="updateForm" action = "currency/update" enctype="multipart/form-data">
                        <input id="id" name="id" value="${currency.id}" type="hidden">
                        <input id="image" name="image" value="${currency.image}" type="hidden">
                        <div class="form-group">
                            <div class="form-group">
                                <label class="col-sm-3 control-label">符号：</label>
                                <div class="col-sm-8">
                                    <input id="symbol" name="symbol" class="form-control" type="text" value="${currency.symbol}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">中文名称：</label>
                                <div class="col-sm-8">
                                    <input id="chName" name="chName" class="form-control" type="text" value="${currency.chName}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">图片地址：</label>
                                <div class="col-sm-8">
                                    <input type="file" class="form-control"  name="imageFILE" id="imageFILE">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">精度：</label>
                                <div class="col-sm-8">
                                    <input id="precise" name="precise" class="form-control" type="text" value="${currency.precise}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">允许充币：</label>
                                <div class="col-sm-8">
                                    <select id="allowedRecharge" name="allowedRecharge" class=" form-control">
                                        <option value="">请选择</option>
                                        <option <c:if test="${currency.allowedRecharge==true}">selected="selected"</c:if> value="true">是</option>
                                        <option <c:if test="${currency.allowedRecharge==false}">selected="selected"</c:if> value="false">否</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">允许提币：</label>
                                <div class="col-sm-8">
                                    <select id="allowedWithdraw" name="allowedWithdraw" class=" form-control">
                                        <option value="">请选择</option>
                                        <option <c:if test="${currency.allowedWithdraw==true}">selected="selected"</c:if> value="true">是</option>
                                        <option <c:if test="${currency.allowedWithdraw==false}">selected="selected"</c:if> value="false">否</option>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-3 control-label">允许交易：</label>
                                <div class="col-sm-8">
                                    <select id="allowedTrade" name="allowedTrade" class=" form-control">
                                        <option value="">请选择</option>
                                        <option <c:if test="${currency.allowedTrade==true}">selected="selected"</c:if> value="true">是</option>
                                        <option <c:if test="${currency.allowedTrade==false}">selected="selected"</c:if> value="false">否</option>
                                    </select>
                                </div>
                            </div>


                            <div class="form-group">
                                <label class="col-sm-3 control-label">选择币种系列：</label>
                                <div class="col-sm-4">
                                    <select class="form-control show-tick"  id="series" name="series">
                                        <c:forEach items="${series}" var="seri">
                                            <option value="${seri.symbol}" <c:if test="${currency.series==seri.symbol}">selected="selected"</c:if>>${seri.symbol}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-3 control-label">排序参数：</label>
                                <div class="col-sm-8">
                                    <input id="sortParam" name="tradeSortParam" class="form-control" type="text" value="${currency.tradeSortParam}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">提币手续费数量：</label>
                                <div class="col-sm-8">
                                    <input id="withdrawFee" name="withdrawFee" class="form-control" type="text" value="${currency.withdrawFee}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">提币最小数量：</label>
                                <div class="col-sm-8">
                                    <input id="withdrawTimeLimit" name="withdrawTimeLimit" class="form-control" type="text" value="${currency.withdrawTimeLimit}">
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