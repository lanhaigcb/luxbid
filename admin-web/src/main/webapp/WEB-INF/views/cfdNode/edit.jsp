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
                    <form class="form-horizontal m-t" method="post" id="updateForm" action = "cfdNode/update" enctype="multipart/form-data">
                        <input id="id" name="id" value="${cfdNode.id}" type="hidden">
                        <div class="form-group">
                            <div class="form-group">
                                <label class="col-sm-3 control-label">手续费反佣比例：</label>
                                <div class="col-sm-8">
                                    <input id="feeReturnRate" name="feeReturnRate" class="form-control" type="text" value="${cfdNode.feeReturnRate}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">持仓费返佣比例：</label>
                                <div class="col-sm-8">
                                    <input id="positionRate" name="positionRate" class="form-control" type="text" value="${cfdNode.positionRate}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">预警率：</label>
                                <div class="col-sm-8">
                                    <input id="warningRate" name="warningRate" class="form-control" type="number" value="${cfdNode.warningRate}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">转移率：</label>
                                <div class="col-sm-8">
                                    <input id="transferRate" name="transferRate" class="form-control" type="number" value="${cfdNode.transferRate}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">平仓率：</label>
                                <div class="col-sm-8">
                                    <input id="unwindRate" name="unwindRate" class="form-control" type="text" value="${cfdNode.unwindRate}">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-3 control-label">节点名称：</label>
                                <div class="col-sm-8">
                                    <input id="name" name="name" class="form-control" type="text" value="${cfdNode.name}">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-3 control-label">上级节点：</label>
                                <div class="col-sm-8">
                                    <select id="parentId" name="parentId" class=" form-control">
                                        <option value="">请选择</option>
                                        <c:forEach items="${specialCfdNodes}" var="specialCfdNode">
                                            <option value="${specialCfdNode.id}">${specialCfdNode.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-3 control-label">用户id：</label>
                                <div class="col-sm-8">
                                    <input id="adminId" name="adminId" class="form-control" type="text" value="${cfdNode.adminId}">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-3 control-label">节点类型：</label>
                                <div class="col-sm-8">
                                    <select id="cfdNodeType" name="cfdNodeType" class=" form-control">
                                        <option value="">请选择</option>
                                        <c:forEach items="${cfdNodeTypes}" var="cfdNodeType">
                                            <option value="${cfdNodeType.key}">${cfdNodeType.value}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-3 control-label">超级节点：</label>
                                <div class="col-sm-8">
                                    <select id="promoterId" name="promoterId" class=" form-control">
                                        <option value="">请选择</option>
                                        <c:forEach items="${superCfdNodes}" var="superCfdNode">
                                            <option value="${superCfdNode.id}">${superCfdNode.name}</option>
                                        </c:forEach>
                                    </select>
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