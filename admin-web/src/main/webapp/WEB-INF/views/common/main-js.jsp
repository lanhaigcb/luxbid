<script src="theme/js/jquery.min.js?v=2.1.4"></script>
<script src="theme/js/bootstrap.min.js?v=3.3.6"></script>
<script src="theme/js/content.min.js?v=1.0.0"></script>
<!--表格-->
<script src="theme/js/plugins/bootstrap-table/bootstrap-table.min.js"></script>
<script src="theme/js/plugins/bootstrap-table/locale/bootstrap-table-zh-CN.min.js"></script>
<!--弹出层框架-->
<script src="theme/js/plugins/layer/layer.js"></script>
<script src="theme/js/plugins/sweetalert/sweetalert.min.js"></script>
<!--树结构-->
<script src="theme/js/plugins/treeview/bootstrap-treeview.js"></script>
<!--Jquery验证框架-->
<script src="theme/js/plugins/validate/jquery.validate.min.js"></script>
<script src="theme/js/plugins/validate/messages_zh.min.js"></script>
<!--Jquery表单提交-->
<script src="theme/js/jquery.form.js"></script>
<script src="theme/js/plugins/datapicker/bootstrap-datepicker.js"></script>

<script src="theme/js/plugins/iCheck/icheck.min.js"></script>

<!--时间插件-->
<script type="text/javascript" src="theme/plugins/bootstrap/js/bootstrap-datetimepicker.js" charset="UTF-8"></script>
<script type="text/javascript" src="theme/plugins/bootstrap/js/bootstrap-datetimepicker.fr.js" charset="UTF-8"></script>

<script type="text/javascript" src="theme/js/bootstrap-select.js" charset="UTF-8"></script>
<%--<script src="https://cdn.bootcss.com/bootstrap-select/2.0.0-beta1/js/bootstrap-select.js"></script>--%>



<script>
    $(document).ready(function(){$(".i-checks").iCheck({checkboxClass:"icheckbox_square-green",radioClass:"iradio_square-green",})});

    function getPreMonthDay(date){
        var yesterday_milliseconds=date.getTime()-1000*60*60*24;
        var yesterday = new Date();
        yesterday.setTime(yesterday_milliseconds);

        var strYear = yesterday.getFullYear();
        var strDay = yesterday.getDate();
        var strMonth = yesterday.getMonth()+1;
        if(strMonth<10)
        {
            strMonth="0"+strMonth;
        }
        if(strDay<10)
        {
            strDay="0"+strDay;
        }
        datastr = strYear+"-"+strMonth+"-"+strDay;
        return datastr;
    }
    function getAfterMonthDay(date){
        var yesterday_milliseconds=date.getTime()+1000*60*60*24;
        var yesterday = new Date();
        yesterday.setTime(yesterday_milliseconds);

        var strYear = yesterday.getFullYear();
        var strDay = yesterday.getDate();
        var strMonth = yesterday.getMonth()+1;
        if(strMonth<10)
        {
            strMonth="0"+strMonth;
        }
        if(strDay<10)
        {
            strDay="0"+strDay;
        }
        datastr = strYear+"-"+strMonth+"-"+strDay;
        return datastr;
    }

    function getNowMonthDay(date){
        var yesterday_milliseconds=date.getTime();
        var yesterday = new Date();
        yesterday.setTime(yesterday_milliseconds);

        var strYear = yesterday.getFullYear();
        var strDay = yesterday.getDate();
        var strMonth = yesterday.getMonth()+1;
        if(strMonth<10)
        {
            strMonth="0"+strMonth;
        }
        if(strDay<10)
        {
            strDay="0"+strDay;
        }
        datastr = strYear+"-"+strMonth+"-"+strDay;
        return datastr;
    }
</script>


