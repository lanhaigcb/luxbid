<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="b" %>
<!DOCTYPE html>
<html>
<head>
    <b:base></b:base>
    <title>H+ 后台主题UI框架 - Bootstrap Table</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="keywords" content="H+后台主题,后台bootstrap框架,会员中心主题,后台HTML,响应式后台">
    <meta name="description" content="H+是一个完全响应式，基于Bootstrap3最新版本开发的扁平化主题，她采用了主流的左右两栏式布局，使用了Html5+CSS3等现代技术">

    <link rel="shortcut icon" href="favicon.ico"> <link href="theme/css/bootstrap.min14ed.css?v=3.3.6" rel="stylesheet">
    <link href="theme/css/font-awesome.min93e3.css?v=4.4.0" rel="stylesheet">
    <link href="theme/css/plugins/bootstrap-table/bootstrap-table.min.css" rel="stylesheet">
    <link href="theme/css/animate.min.css" rel="stylesheet">
    <link href="theme/css/style.min862f.css?v=4.1.0" rel="stylesheet">

</head>

<body class="white-bg">
<div class="wrapper wrapper-content animated fadeInRight">
    <!-- Panel Other -->
    <div class="col-sm-12">
        <div class="ibox float-e-margins">
            <div class="ibox-tools">
                <button class="btn btn-primary " type="button" id ="submit"><i class="fa fa-check"></i>&nbsp;提交</button>
                <button class="btn btn-warning " type="button" id="cancel"><i class="fa fa-warning"></i> <span class="bold">取消</span></button>
            </div>
            <div class="ibox-content">
                <div class="col-sm-12">
                    <div id="menu_tree" class="test"></div>
                </div>
                <div class="clearfix"></div>
            </div>
        </div>
    </div>
</div>
<script src="theme/js/jquery.min.js?v=2.1.4"></script>
<script src="theme/js/bootstrap.min.js?v=3.3.6"></script>
<script src="theme/js/content.min.js?v=1.0.0"></script>
<script src="theme/js/plugins/bootstrap-table/bootstrap-table.min.js"></script>
<script src="theme/js/plugins/bootstrap-table/bootstrap-table-mobile.min.js"></script>
<script src="theme/js/plugins/bootstrap-table/locale/bootstrap-table-zh-CN.min.js"></script>
<script src="theme/js/plugins/treeview/bootstrap-treeview.js"></script>
<script type="text/javascript" charset="UTF-8">

    //数据封装到tree中
    var data = getFunctionByID(1);
    $("#menu_tree").treeview({  icon: "glyphicon glyphicon-stop",
        selectedIcon: "glyphicon glyphicon-stop",
        color:"#428bca",
        selectable: true,
        state: {
            checked: true,
            disabled: true,
            expanded: true,
            selected: true
        },
        showCheckbox:true,
        multiSelect:false,
        data:data,
        onNodeChecked:function(event,o){
            console.log(o.nodeId)
            if(o.nodeId == 0){
                $('#menu_tree').treeview('checkAll');
            }else{
                checkNodes(o);
            }
        },
        onNodeUnchecked:function(event,o){
            console.log(o.nodeId)
            if(o.nodeId == 0){
                $('#menu_tree').treeview('uncheckAll');
            }else {
                uncheckNodes(o);
            }

        },
    });
    $(function () {

        //var nodes=$("#menu_tree").treeview("getEnabled",0);
        //initCheckNode();
    })

    function initCheckNode() {
        var list=${functions};

        for (var i=0;i<list.length;i++){
            $("#menu_tree").treeview('checkNode', [ list[0].id, { silent: true } ]);
        }
    }

    function checkNodes(node){

        $('#menu_tree').treeview('checkNode', [ node.parentId, { silent: true } ]);
        var nodes = node.nodes;
        if(nodes!=null) {
            for (var k = 0; k < nodes.length; k++) {
                $('#menu_tree').treeview('checkNode', [nodes[k].nodeId, {silent: true}]);
                checkNodes(nodes[k]);
            }
        }
    }


    function uncheckNodes(node){

        var target = false;

        var parentNode =  $('#menu_tree').treeview('getNode', node.parentId);
        var parentNodes = parentNode.nodes;

        for(var k = 0; k < parentNodes.length; k++){
            if(parentNodes[k].state.checked){
                target = true
            }
        }

        if(!target){
            $('#menu_tree').treeview('uncheckNode', [ node.parentId, { silent: true } ]);
        }

        var nodes = node.nodes;
        if(nodes!=null){
            for(var k = 0; k < nodes.length; k++){
                $('#menu_tree').treeview('toggleNodeChecked', [ nodes[k].nodeId, { silent: true } ]);
                uncheckNodes(nodes[k]);
            }
        }
    }

    function getFunctionByID(parentId){
        var menus;
        $.ajax({
            url:"staffRole/tree.json?staffRoleId=${staffRole.id}",
            data:{parentId:parentId},
            async:false,
            success: function (data) {
                menus = data.treeVos;
                console.log(menus);
            },
            error: function () {
                layer.msg('请求错误！');
            }
        });

        return menus;
    }

    var ids = '';
    function getIds(nodes){

        if(nodes!=null) {
            for (var k = 0; k < nodes.length; k++) {
                if (k>0){
                    ids += ',';
                }
                ids += nodes[k].tag;
            }
        }
        return ids;
    }

    $("#submit").on("click",function(){
        var nodes = $("#menu_tree").treeview("getChecked");
        $.ajax({
            url:"staffRole/authorityUpdate",
            data:{ids:getIds(nodes),staffRoleId:${staffRole.id}},
            async:false,
            success: function (data) {
                //layer.msg(data.message);
                if(data.result){
                    var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                    parent.layer.close(index); //再执行关闭
                }
            },
            error: function () {
                layer.msg('请求错误！');
            }
        });
    });

    $("#cancel").on("click",function(){
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index); //再执行关闭
    });
</script>

</body>
</html>
