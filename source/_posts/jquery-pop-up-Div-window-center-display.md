---
title: jQuery弹出Div窗口居中显示、滚动跟随、关闭按钮以及几秒后自动消失
date: 2014-06-18 13:23:02
tags: [jQuery,javascript]
---
要实现一个弹出窗口，在弹出窗口中进行操作，例如帐号的注册，或者用户登录，需要弹出一个窗口。

<!--more-->

```html
 <DIV id="closeLayer"  onClick="closeMe()"><IMG src="jiuye/close.gif" width="15" height="13"></DIV>  
  <div id ="jiuye"><img src="jiuye/jiuye1.jpg" id="jiuyeImage" style="cursor:hand"/></div>  
  <style type="text/css">  
  #jiuye{  
      position:absolute;  
      left:16px;  
      top:129px;  
      width:600px;  
      height:540px;  
      z-index:1;  
        
  }  
  #closeLayer{  
      position:absolute;      
      left:580px;     
      top:143px;      
      width:24px;     
      height:19px;  
      z-index:2;  
  }  
  </style>  
<script src="jiuye/jquery-1.7.0.js" type="text/javascript"></script>  
<script type="text/javascript">  
    
function closeMe(){  
    document.getElementById("closeLayer").style.display="none";  
    document.getElementById("jiuye").style.display="none";  
    $(window).unbind();  
}  
  // 居中  
function center() {  
    var obj=$("#jiuye");  
    var closeObj=$("#closeLayer");  
    var screenWidth = $(window).width(), screenHeight = $(window).height(); //当前浏览器窗口的 宽高  
    var scrolltop = $(document).scrollTop();//获取当前窗口距离页面顶部高度  
    var objLeft = (screenWidth - obj.width())/2 ;  
    var objTop = (screenHeight - obj.height())/2 + scrolltop;  
    obj.css({left: objLeft + 'px', top: objTop + 'px','display': 'block'});  
      
    var closeObjLeft = (screenWidth + obj.width())/2-closeObj.width()-2 ;  
    var closeObjTop = (screenHeight - obj.height())/2 + scrolltop+12;  
    closeObj.css({left: closeObjLeft + 'px', top: closeObjTop + 'px','display': 'block'});  
    //浏览器窗口大小改变时  
    $(window).resize(function() {  
    screenWidth = $(window).width();  
    screenHeight = $(window).height();  
    scrolltop = $(document).scrollTop();  
    objLeft = (screenWidth - obj.width())/2 ;  
    objTop = (screenHeight - obj.height())/2 + scrolltop;  
    obj.css({left: objLeft + 'px', top: objTop + 'px','display': 'block'});  
    var closeObjLeft = (screenWidth + obj.width())/2-closeObj.width()-2 ;  
    var closeObjTop = (screenHeight - obj.height())/2 + scrolltop+12;  
    closeObj.css({left: closeObjLeft + 'px', top: closeObjTop + 'px','display': 'block'});  
    });  
    //浏览器有滚动条时的操作、  
    $(window).scroll(function() {  
    screenWidth = $(window).width();  
    screenHeight = $(window).height();  
    scrolltop = $(document).scrollTop();  
    objLeft = (screenWidth - obj.width())/2 ;  
    objTop = (screenHeight - obj.height())/2 + scrolltop;  
    obj.css({left: objLeft + 'px', top: objTop + 'px','display': 'block'});  
    var closeObjLeft = (screenWidth + obj.width())/2-closeObj.width()-2 ;  
    var closeObjTop = (screenHeight - obj.height())/2 + scrolltop+12;  
    closeObj.css({left: closeObjLeft + 'px', top: closeObjTop + 'px','display': 'block'});  
    });  
}   
center();  
$('#closeLayer').show(300).delay(3000).fadeOut("slow");  
$('#jiuye').show(300).delay(3000).fadeOut("slow",function(){     
   //隐藏时把元素删除     
  $(window).unbind();  
});     
</script>  

```