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
                    <form class="form-horizontal m-t" method="post" id="addIntroductForm" action = "currencyIntroduct/add" enctype="multipart/form-data">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">币种：</label>
                            <div class="col-sm-8">
                                <select id="currency" name="currency" class="form-control">
                                    <%--<c:forEach var="v" items="<%=CurrencyType.values()%>" >
                                        <option value="${v.name()}">${v.name()}</option>
                                    </c:forEach>--%>
                                    <c:forEach items="${currencys}" var="currency" >
                                        <option value="${currency.symbol}">${currency.symbol}</option>
                                    </c:forEach>
                                </select>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">国际化类型：</label>
                            <div class="col-sm-8">
                                <select id="bannerType" name="internationalType" class=" form-control">
                                    <option value="">请选择</option>
                                    <option value="zh-CN">中国大陆</option>
                                    <option value="zh-TW">中国台湾</option>
                                    <option value="en-US">美国</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">币种名称：</label>
                            <div class="col-sm-8">
                                <input id="name" name="name" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">币种简介：</label>
                            <div class="col-sm-8">
                                <input id="introduction" name="introduction" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">发行时间：</label>
                            <div class="col-sm-8">
                                <input id="publishTime" name="publishTime" placeholder="yyyy-MM-dd" class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">发行总量：</label>
                            <div class="col-sm-8">
                                <input id="issuedTotal" name="issuedTotal"  class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">流通总量：</label>
                            <div class="col-sm-8">
                                <input id="circulationTotal" name="circulationTotal"  class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">众筹价格：</label>
                            <div class="col-sm-8">
                                <input id="crowdfundingPrice" name="crowdfundingPrice"  class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">白平书链接：</label>
                            <div class="col-sm-8">
                                <input id="whitePaperUrl" name="whitePaperUrl"  class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">区块查询链接：</label>
                            <div class="col-sm-8">
                                <input id="queryBlockUrl" name="queryBlockUrl"  class="form-control" type="text">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">是否可用：</label>
                            <div class="col-sm-8">
                                <select id="enable" name="enable" class=" form-control">
                                    <option value="">请选择</option>
                                    <option value="true">是</option>
                                    <option value="false">否</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">排序参数：</label>
                            <div class="col-sm-8">
                                <input id="sortParam" name="sortParam" class="form-control" type="text">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label">币种详细介绍：</label>
                            <div class="col-sm-8">
                                 <textarea id="content" name="content" required='true' maxlength="5000"
                                           class="easyui-validatebox"
                                           style="width: 830px;float: left;height: 300px"></textarea>
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
            $("#addIntroductForm").validate({
                rules:{
                    name:{required:!0},
                    introduction:{required:!0},
                    htmlTitle:{required:!0},
                    publishTime:{required:!0},
                    enable:{required:!0},
                    sortParam:{required:!0},
                    content:{required:!0},
                    internationalType:{required:!0}
                },
                messages:{
                    name:{required:e+"请输入币种名称"},
                    introduction:{required:e+"请输入币种简介"},
                    publishTime:{required:e+"请输入发行时间"},
                    htmlURL:{required:e+"请输入落地页地址"},
                    enable:{required:e+"请选择是否可用"},
                    sortParam:{required:e+"请输入排序参数"},
                    content:{required:e+"请输入币种详情"},
                    cointernationalTypentent:{required:e+"请选择国际化类型"}
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
            $('#addForm').ajaxForm(options);

        });

    </script>
</html>