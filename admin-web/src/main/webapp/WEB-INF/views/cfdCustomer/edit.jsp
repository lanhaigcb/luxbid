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
                    <form class="form-horizontal m-t" method="post" id="updateForm" action = "cfdCustomer/update" enctype="multipart/form-data">
                        <input id="id" name="id" value="${customer.id}" type="hidden">
                        <div class="form-group">
                            <div class="form-group">
                                <label class="col-sm-3 control-label">现货反佣：</label>
                                <div class="col-sm-8">
                                    <input id="symbol" name="volunteerRate" class="form-control" type="text" value="${customer.volunteerRate}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">合约返佣：</label>
                                <div class="col-sm-8">
                                    <input id="chName" name="cfdRate" class="form-control" type="text" value="${customer.cfdRate}">
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