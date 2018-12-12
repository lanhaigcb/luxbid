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
                    <form class="form-horizontal m-t" method="post" id="addForm" action = "cfdNode/add" enctype="multipart/form-data">

                        <div class="form-group">
                            <label class="col-sm-3 control-label">手续费反佣比例：</label>
                            <div class="col-sm-8">
                                <input id="feeReturnRate" name="feeReturnRate" class="form-control" type="text" value="">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">持仓费返佣比例：</label>
                            <div class="col-sm-8">
                                <input id="positionRate" name="positionRate" class="form-control" type="text" value="">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">预警率：</label>
                            <div class="col-sm-8">
                                <input id="warningRate" name="warningRate" class="form-control" type="number" value="">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">转移率：</label>
                            <div class="col-sm-8">
                                <input id="transferRate" name="transferRate" class="form-control" type="number" value="">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">平仓率：</label>
                            <div class="col-sm-8">
                                <input id="unwindRate" name="unwindRate" class="form-control" type="text" value="">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label">日利率：</label>
                            <div class="col-sm-8">
                                <input id="dayRate" name="dayRate" class="form-control" type="text" value="">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">手续费率：</label>
                            <div class="col-sm-8">
                                <input id="feeRate" name="feeRate" class="form-control" type="text" value="">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">对冲订单手续费率：</label>
                            <div class="col-sm-8">
                                <input id="feeHedgeRate" name="feeHedgeRate" class="form-control" type="text" value="">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">买涨点差：</label>
                            <div class="col-sm-8">
                                <input id="riseSpread" name="riseSpread" class="form-control" type="text" value="">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">买跌点差：</label>
                            <div class="col-sm-8">
                                <input id="fallSpread" name="fallSpread" class="form-control" type="text" value="">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label">节点名称：</label>
                            <div class="col-sm-8">
                                <input id="name" name="name" class="form-control" type="text" value="">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">是否可用：</label>
                            <div class="col-sm-8">
                                <select id="enable" name="enable" class=" form-control">
                                    <option value="1">可用</option>
                                    <option value="0">不可用</option>
                                </select>
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
                                <input id="adminId" name="adminId" class="form-control" type="text" value="">
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