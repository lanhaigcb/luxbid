<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<%@include file="../common/head-title.jsp" %>
<head>
    <title>Title</title>
    <style type="text/css">
        *{
            margin:0;
            padding: 0;
            box-sizing: border-box;
        }
        html{
            width: 100%;
            height: 100%;
            font-size: 16px;
        }
        body{
            width: 100%;
            height: 100%;
            -moz-user-select: none; /*火狐*/ /*禁止用户在页面选择文字*/
            -webkit-user-select: none; /*webkit浏览器*/
            -ms-user-select: none; /*IE10*/
            -khtml-user-select: none; /*早期浏览器*/
            user-select: none;
        }
        .code{
            width: 400px;
            margin:0 auto;
        }
        .input-val{
            width: 295px;
            background: #ffffff;
            height: 2.8rem;
            padding: 0 2%;
            border-radius: 5px;
            border: none;
            border: 1px solid rgba(0,0,0,.2);
            font-size: 1.0625rem;
        }
        #canvas{
            float:right;
            display: inline-block;
            border:1px solid #ccc;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn{
            width: 100px;
            height: 40px;
            background: #f1f1f1;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin: 20px auto 0;
            display: block;
            font-size: 1.2rem;
            color: cornflowerblue;
            cursor: pointer;
        }
    </style>

</head>
<body>
<div class="code">
    <input type="text" value="" placeholder="请输入验证码（不区分大小写）" class="input-val" />
    <canvas id="canvas" width="100" height="43"></canvas>
    <button id="btn" class="btn btn-primary">${suborder}</button>

    <input value="${id}" type="hidden" id="id">
    <input value="${type}" type="hidden" id="type">
</div>

<script type="text/javascript">
    $(function(){

        var show_num = [];
        draw(show_num);

        $("#canvas").on('click',function(){
            draw(show_num);
        })
        $("#btn").on('click',function(){
            document.getElementById('btn').disabled=true;
            var id = $("#id").val();
            var type = $("#type").val();
            var val = $(".input-val").val().toLowerCase();
            var num = show_num.join("");
            if(val==''){
                alert('请输入验证码！');
                document.getElementById('btn').disabled=false;
            }else if(val == num){
                $("#btn").attr('disabled', 'disabled');
                if(type=="cancel"){
                    $.ajax({
                        type: "POST",
                        url: "c2cOrder/cancel",
                        data: {id: id},
                        dataType: "json",
                        success: function (data) {
                            layer.msg('操作成功', {
                                time: 1000, //1s后自动关闭
                            }, function () {
                                parent.refresh();
                                var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                                parent.layer.close(index); //再执行关闭
                            });
                        }
                    });
                } else if(type=="done"){
                    $.ajax({
                        type: "POST",
                        url: "c2cOrder/done",
                        data: {id: id},
                        dataType: "json",
                        success: function (data) {
                            layer.msg('操作成功', {
                                time: 1000, //1s后自动关闭
                            }, function () {
                                parent.refresh();
                                var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                                parent.layer.close(index); //再执行关闭
                            });

                        }
                    });
                }

                // $(".input-val").val('');
                // draw(show_num);

            }else{
                alert('验证码错误！请重新输入！');
                document.getElementById('btn').disabled=false;
                $(".input-val").val('');
                draw(show_num);
            }
        })
    })

    function draw(show_num) {
        var canvas_width=$('#canvas').width();
        var canvas_height=$('#canvas').height();
        var canvas = document.getElementById("canvas");//获取到canvas的对象，演员
        var context = canvas.getContext("2d");//获取到canvas画图的环境，演员表演的舞台
        canvas.width = canvas_width;
        canvas.height = canvas_height;
        //var sCode = "A,B,C,E,F,G,H,J,K,L,M,N,P,Q,R,S,T,W,X,Y,Z,1,2,3,4,5,6,7,8,9,0";
        var sCode = "1,2,3,4,5,6,7,8,9,0";
        var aCode = sCode.split(",");
        var aLength = aCode.length;//获取到数组的长度

        for (var i = 0; i <= 3; i++) {
            var j = Math.floor(Math.random() * aLength);//获取到随机的索引值
            //var deg = Math.random() * 30 * Math.PI / 180;//产生0~30之间的随机弧度
            var txt = aCode[j];//得到随机的一个内容
            show_num[i] = txt.toLowerCase();
            var x = 10 + i * 20;//文字在canvas上的x坐标
            //var y = 20 + Math.random() * 8;//文字在canvas上的y坐标
            var y = 28;
            context.font = "bold 23px 微软雅黑";

            context.translate(x, y);
            //context.rotate(deg);

            //context.fillStyle = randomColor();
            context.fillText(txt, 0, 0);

            //context.rotate(-deg);
            context.translate(-x, -y);
        }
        /*for (var i = 0; i <= 5; i++) { //验证码上显示线条
            context.strokeStyle = randomColor();
            context.beginPath();
            context.moveTo(Math.random() * canvas_width, Math.random() * canvas_height);
            context.lineTo(Math.random() * canvas_width, Math.random() * canvas_height);
            context.stroke();
        }
        for (var i = 0; i <= 30; i++) { //验证码上显示小点
            context.strokeStyle = randomColor();
            context.beginPath();
            var x = Math.random() * canvas_width;
            var y = Math.random() * canvas_height;
            context.moveTo(x, y);
            context.lineTo(x + 1, y + 1);
            context.stroke();
        }*/
    }

    /*function randomColor() {//得到随机的颜色值
        var r = Math.floor(Math.random() * 256);
        var g = Math.floor(Math.random() * 256);
        var b = Math.floor(Math.random() * 256);
        return "rgb(" + r + "," + g + "," + b + ")";
    }*/
</script>

</body>
</html>
