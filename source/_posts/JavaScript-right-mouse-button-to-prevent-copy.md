---
title: javascript禁止鼠标右键防止拷贝
date: 2014-06-28 20:03:17
tags: javascript
---
在使用TurnJs的时候，为了防止其他用户直接复制杂志的图片，需要加入禁止右键的功能，以下列出常用的方法

* 禁止鼠标左右键代码/禁止网页选中/禁止另存为
```
<body oncontextmenu="return false" onselectstart="return false">
<noscript><iframe src="/*.html>";</iframe></noscript>
<script>
function stop(){
return false;
}
document.oncontextmenu=stop;
</script>
```
<!--more-->

* 禁止鼠标左右键
```
<SCRIPT language=javascript>
<!--
if (window.Event)
document.captureEvents(Event.MOUSEUP);
function nocontextmenu(){
event.cancelBubble = true
event.returnValue = false;
return false;
}
function norightclick(e){
if (window.Event){
if (e.which == 2 || e.which == 3)
return false;
}
else
if (event.button == 2 || event.button == 3){
event.cancelBubble = true
event.returnValue = false;
return false;
}
}
document.oncontextmenu = nocontextmenu; // for IE5+
document.onmousedown = norightclick; // for all others
//-->
</SCRIPT>
```
* 禁止选中代码

```
<SCRIPT language=JavaScript>
document.oncontextmenu=new Function("event.returnValue=false;");
document.onselectstart=new Function("event.returnValue=false;");
</SCRIPT>
```
* 禁止另存为

```
 <noscript>
 <iframe src="/*.htm"></iframe>
</noscript>

```
* 防拷贝/复制代码
`<body leftmargin=0 topmargin=0 >`

* 禁止选择文本
```
<script type="text/javascript">
var omitformtags=["input", "textarea", "select"]
omitformtagsomitformtags=omitformtags.join("|")
function disableselect(e){
if (omitformtags.indexOf(e.target.tagName.toLowerCase())==-1)
return false
}
function reEnable(){
return true
}
if (typeof document.onselectstart!="undefined")
document.onselectstart=new Function ("return false")
else{
document.onmousedown=disableselect
document.onmouseup=reEnable
}
</script>
```
* 禁止网页另存为
`<noscript><iframe src="/*.html>";</iframe></noscript>`

* 禁止选择文本
```
<script type="text/javascript">

var omitformtags=["input", "textarea", "select"]

omitformtagsomitformtags=omitformtags.join("|")

function disableselect(e){
if (omitformtags.indexOf(e.target.tagName.toLowerCase())==-1)
return false
}

function reEnable(){
return true
}

if (typeof document.onselectstart!="undefined")
document.onselectstart=new Function ("return false")
else{
document.onmousedown=disableselect
document.onmouseup=reEnable
}
</script>
```
* 禁用右键
```
<script>
function stop(){
return false;
}
document.oncontextmenu=stop;
</script>
```
* 真正的鼠标右键屏蔽
```
<script language="JavaScript">
<!--

if (window.Event)
 document.captureEvents(Event.MOUSEUP);

function nocontextmenu()
{
event.cancelBubble = true
event.returnValue = false;

return false;
}

function norightclick(e)
{
if (window.Event)
{
 if (e.which == 2 || e.which == 3)
 return false;
}
else
 if (event.button == 2 || event.button == 3)
 {
 event.cancelBubble = true
 event.returnValue = false;
 return false;
 }

}

document.oncontextmenu = nocontextmenu; // for IE5+
document.onmousedown = norightclick; // for all others
//-->
</script>
```

