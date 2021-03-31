var dhtmlwindow={imagefiles:['windowfiles/min.gif','windowfiles/close.gif','windowfiles/restore.gif','windowfiles/resize.gif'],ajaxbustcache:true,ajaxloadinghtml:'<b>Loading Page. Please wait...</b>',minimizeorder:0,zIndexvalue:100002,tobjects:[],lastactivet:{},init:function(t){var domwindow=document.createElement("div")
domwindow.id=t
domwindow.className="dhtmlwindow"
var domwindowdata=''
domwindowdata='<div class="drag-handle" id="drag-handle">'
domwindowdata+='DHTML Window <div class="drag-controls"><!--<img src="'+M.cfg.wwwroot+'/local/wall/js/'+this.imagefiles[0]+'" title="Minimize" />//--><img src="'+M.cfg.wwwroot+'/local/wall/js/'+this.imagefiles[1]+'" title="Close" /></div>'
domwindowdata+='</div>'
domwindowdata+='<div class="drag-contentarea"></div>'
domwindowdata+='<div class="drag-statusarea"><div class="drag-resizearea" style="background: transparent url('+M.cfg.wwwroot+'/local/wall/js/'+this.imagefiles[3]+') top right no-repeat;">&nbsp;</div></div>'
domwindowdata+='</div>'
domwindow.innerHTML=domwindowdata
document.getElementById("dhtmlwindowholder").appendChild(domwindow)
var t=document.getElementById(t)
var divs=t.getElementsByTagName("div")
for(var i=0;i<divs.length;i++){if(/drag-/.test(divs[i].className))
t[divs[i].className.replace(/drag-/,"")]=divs[i]}
t.handle._parent=t
t.resizearea._parent=t
t.controls._parent=t
t.onclose=function(){return true}
t.onmousedown=function(){dhtmlwindow.setfocus(this)}
t.handle.onmousedown=dhtmlwindow.setupdrag
t.resizearea.onmousedown=dhtmlwindow.setupdrag
t.controls.onclick=dhtmlwindow.enablecontrols
t.show=function(){dhtmlwindow.show(this)}
t.hide=function(){dhtmlwindow.hide(this)}
t.close=function(){dhtmlwindow.close(this)}
t.setSize=function(w,h){dhtmlwindow.setSize(this,w,h)}
t.moveTo=function(x,y){dhtmlwindow.moveTo(this,x,y)}
t.isResize=function(bol){dhtmlwindow.isResize(this,bol)}
t.isScrolling=function(bol){dhtmlwindow.isScrolling(this,bol)}
t.load=function(contenttype,contentsource,title){dhtmlwindow.load(this,contenttype,contentsource,title)}
this.tobjects[this.tobjects.length]=t
return t},open:function(t,contenttype,contentsource,title,attr,recalonload){var d=dhtmlwindow
function getValue(Name){var config=new RegExp(Name+"=([^,]+)","i")
return(config.test(attr))?parseInt(RegExp.$1):0}
if(document.getElementById(t)==null)
t=this.init(t)
else
t=document.getElementById(t)
this.setfocus(t)
t.setSize(getValue(("width")),(getValue("height")))
var xpos=getValue("center")?"middle":getValue("left")
var ypos=getValue("center")?"middle":getValue("top")
if(typeof recalonload!="undefined"&&recalonload=="recal"&&this.scroll_top==0){if(window.attachEvent&&!window.opera)
this.addEvent(window,function(){setTimeout(function(){t.moveTo(xpos,ypos)},400)},"load")
else
this.addEvent(window,function(){t.moveTo(xpos,ypos)},"load")}
t.isResize(getValue("resize"))
t.isScrolling(getValue("scrolling"))
t.style.visibility="visible"
t.style.display="block"
t.contentarea.style.display="block"
t.moveTo(xpos,ypos)
t.load(contenttype,contentsource,title)
if(t.state=="minimized"&&t.controls.firstChild.title=="Restore"){t.controls.firstChild.setAttribute("src",dhtmlwindow.imagefiles[0])
t.controls.firstChild.setAttribute("title","Minimize")
t.state="fullview"}
return t},setSize:function(t,w,h){t.style.width=Math.max(parseInt(w),150)+"px"
t.contentarea.style.height=Math.max(parseInt(h),100)+"px"},moveTo:function(t,x,y){this.getviewpoint()
t.style.left=(x=="middle")?this.scroll_left+(this.docwidth-t.offsetWidth)/2+"px":this.scroll_left+parseInt(x)+"px"
t.style.top=(y=="middle")?this.scroll_top+(this.docheight-t.offsetHeight)/2+"px":this.scroll_top+parseInt(y)+"px"},isResize:function(t,bol){t.statusarea.style.display=(bol)?"block":"none"
t.resizeBool=(bol)?1:0},isScrolling:function(t,bol){t.contentarea.style.overflow=(bol)?"auto":"hidden"},load:function(t,contenttype,contentsource,title){if(t.isClosed){alert("DHTML Window has been closed, so no window to load contents into. Open/Create the window again.")
return}
var contenttype=contenttype.toLowerCase()
if(typeof title!="undefined")
t.handle.firstChild.nodeValue=title
if(contenttype=="inline")
t.contentarea.innerHTML=contentsource
else if(contenttype=="div"){var inlinedivref=document.getElementById(contentsource)
t.contentarea.innerHTML=(inlinedivref.defaultHTML||inlinedivref.innerHTML)
if(!inlinedivref.defaultHTML)
inlinedivref.defaultHTML=inlinedivref.innerHTML
inlinedivref.innerHTML=""
inlinedivref.style.display="none"}
else if(contenttype=="iframe"){t.contentarea.style.overflow="hidden"
if(!t.contentarea.firstChild||t.contentarea.firstChild.tagName!="IFRAME")
t.contentarea.innerHTML='<iframe src="" style="margin:0; padding:0; width:100%; height: 100%; border:none;" name="_iframe-'+t.id+'"></iframe>'
window.frames["_iframe-"+t.id].location.replace(contentsource)}
else if(contenttype=="ajax"){this.ajax_connect(contentsource,t)}
t.contentarea.datatype=contenttype},setupdrag:function(e){var d=dhtmlwindow
var t=this._parent
d.etarget=this
var e=window.event||e
d.initmousex=e.clientX
d.initmousey=e.clientY
d.initx=parseInt(t.offsetLeft)
d.inity=parseInt(t.offsetTop)
d.width=parseInt(t.offsetWidth)
d.contentheight=parseInt(t.contentarea.offsetHeight)
if(t.contentarea.datatype=="iframe"){t.style.backgroundColor="#F8F8F8"
t.contentarea.style.visibility="hidden"}
document.onmousemove=d.getdistance
document.onmouseup=function(){if(t.contentarea.datatype=="iframe"){t.contentarea.style.backgroundColor="white"
t.contentarea.style.visibility="visible"}
d.stop()}
return false},getdistance:function(e){var d=dhtmlwindow
var etarget=d.etarget
var e=window.event||e
d.distancex=e.clientX-d.initmousex
d.distancey=e.clientY-d.initmousey
if(etarget.className=="drag-handle")
d.move(etarget._parent,e)
else if(etarget.className=="drag-resizearea")
d.resize(etarget._parent,e)
return false},getviewpoint:function(){var ie=document.all&&!window.opera
var domclientWidth=document.documentElement&&parseInt(document.documentElement.clientWidth)||100000
this.standardbody=(document.compatMode=="CSS1Compat")?document.documentElement:document.body
this.scroll_top=(ie)?this.standardbody.scrollTop:window.pageYOffset
this.scroll_left=(ie)?this.standardbody.scrollLeft:window.pageXOffset
this.docwidth=(ie)?this.standardbody.clientWidth:(/Safari/i.test(navigator.userAgent))?window.innerWidth:Math.min(domclientWidth,window.innerWidth-16)
this.docheight=(ie)?this.standardbody.clientHeight:window.innerHeight},rememberattrs:function(t){this.getviewpoint()
t.lastx=parseInt((t.style.left||t.offsetLeft))-dhtmlwindow.scroll_left
t.lasty=parseInt((t.style.top||t.offsetTop))-dhtmlwindow.scroll_top
t.lastwidth=parseInt(t.style.width)},move:function(t,e){t.style.left=dhtmlwindow.distancex+dhtmlwindow.initx+"px"
t.style.top=dhtmlwindow.distancey+dhtmlwindow.inity+"px"},resize:function(t,e){t.style.width=Math.max(dhtmlwindow.width+dhtmlwindow.distancex,150)+"px"
t.contentarea.style.height=Math.max(dhtmlwindow.contentheight+dhtmlwindow.distancey,100)+"px"},enablecontrols:function(e){var d=dhtmlwindow
var sourceobj=window.event?window.event.srcElement:e.target
if(/Minimize/i.test(sourceobj.getAttribute("title")))
d.minimize(sourceobj,this._parent)
else if(/Restore/i.test(sourceobj.getAttribute("title")))
d.restore(sourceobj,this._parent)
else if(/Close/i.test(sourceobj.getAttribute("title")))
d.close(this._parent)
return false},minimize:function(button,t){dhtmlwindow.rememberattrs(t)
button.setAttribute("src",dhtmlwindow.imagefiles[2])
button.setAttribute("title","Restore")
t.state="minimized"
t.contentarea.style.display="none"
t.statusarea.style.display="none"
if(typeof t.minimizeorder=="undefined"){dhtmlwindow.minimizeorder++
t.minimizeorder=dhtmlwindow.minimizeorder}
t.style.left="10px"
t.style.width="200px"
var windowspacing=t.minimizeorder*10
t.style.top=dhtmlwindow.scroll_top+dhtmlwindow.docheight-(t.handle.offsetHeight*t.minimizeorder)-windowspacing+"px"},restore:function(button,t){dhtmlwindow.getviewpoint()
button.setAttribute("src",dhtmlwindow.imagefiles[0])
button.setAttribute("title","Minimize")
t.state="fullview"
t.style.display="block"
t.contentarea.style.display="block"
if(t.resizeBool)
t.statusarea.style.display="block"
t.style.left=parseInt(t.lastx)+dhtmlwindow.scroll_left+"px"
t.style.top=parseInt(t.lasty)+dhtmlwindow.scroll_top+"px"
t.style.width=parseInt(t.lastwidth)+"px"},close:function(t){try{var closewinbol=t.onclose()}
catch(err){var closewinbol=true}
finally{if(typeof closewinbol=="undefined"){var closewinbol=true}}
if(closewinbol){if(t.state!="minimized")
dhtmlwindow.rememberattrs(t)
if(window.frames["_iframe-"+t.id])
window.frames["_iframe-"+t.id].location.replace("about:blank")
else
t.contentarea.innerHTML=""
t.style.display="none"
t.isClosed=true}
$('#interVeil').css('display','none');return closewinbol},setopacity:function(targetobject,value){if(!targetobject)
return
if(targetobject.filters&&targetobject.filters[0]){if(typeof targetobject.filters[0].opacity=="number")
targetobject.filters[0].opacity=value*100
else
targetobject.style.filter="alpha(opacity="+value*100+")"}
else if(typeof targetobject.style.MozOpacity!="undefined")
targetobject.style.MozOpacity=value
else if(typeof targetobject.style.opacity!="undefined")
targetobject.style.opacity=value},setfocus:function(t){this.zIndexvalue++
t.style.zIndex=this.zIndexvalue
t.isClosed=false
this.setopacity(this.lastactivet.handle,0.5)
this.setopacity(t.handle,1)
this.lastactivet=t},show:function(t){if(t.isClosed){alert("DHTML Window has been closed, so nothing to show. Open/Create the window again.")
return}
if(t.lastx)
dhtmlwindow.restore(t.controls.firstChild,t)
else
t.style.display="block"
this.setfocus(t)
t.state="fullview"},hide:function(t){t.style.display="none"},ajax_connect:function(url,t){var page_request=false
var bustcacheparameter=""
if(window.XMLHttpRequest)
page_request=new XMLHttpRequest()
else if(window.ActiveXObject){try{page_request=new ActiveXObject("Msxml2.XMLHTTP")}
catch(e){try{page_request=new ActiveXObject("Microsoft.XMLHTTP")}
catch(e){}}}
else
return false
t.contentarea.innerHTML=this.ajaxloadinghtml
page_request.onreadystatechange=function(){dhtmlwindow.ajax_loadpage(page_request,t)}
if(this.ajaxbustcache)
bustcacheparameter=(url.indexOf("?")!=-1)?"&"+new Date().getTime():"?"+new Date().getTime()
page_request.open('GET',url+bustcacheparameter,true)
page_request.send(null)},ajax_loadpage:function(page_request,t){if(page_request.readyState==4&&(page_request.status==200||window.location.href.indexOf("http")==-1)){t.contentarea.innerHTML=page_request.responseText}},stop:function(){dhtmlwindow.etarget=null
document.onmousemove=null
document.onmouseup=null},addEvent:function(target,functionref,tasktype){var tasktype=(window.addEventListener)?tasktype:"on"+tasktype
if(target.addEventListener)
target.addEventListener(tasktype,functionref,false)
else if(target.attachEvent)
target.attachEvent(tasktype,functionref)},cleanup:function(){for(var i=0;i<dhtmlwindow.tobjects.length;i++){dhtmlwindow.tobjects[i].handle._parent=dhtmlwindow.tobjects[i].resizearea._parent=dhtmlwindow.tobjects[i].controls._parent=null}
window.onload=null}}
document.write('<div id="dhtmlwindowholder"><span style="display:none">.</span></div>')
window.onunload=dhtmlwindow.cleanup
if(typeof dhtmlwindow=="undefined")
alert('ERROR: Modal Window script requires all files from "DHTML Window widget" in order to work!')
var dhtmlmodal={veilstack:0,open:function(t,contenttype,contentsource,title,attr,recalonload){var d=dhtmlwindow
this.interVeil=document.getElementById("interVeil")
this.veilstack++
this.loadveil()
if(recalonload=="recal"&&d.scroll_top==0)
d.addEvent(window,function(){dhtmlmodal.adjustveil()},"load")
var t=d.open(t,contenttype,contentsource,title,attr,recalonload)
t.controls.onclick=function(){dhtmlmodal.close(this._parent,true)}
t.show=function(){dhtmlmodal.show(this)}
return t},loadveil:function(){var d=dhtmlwindow
d.getviewpoint()
this.docheightcomplete=(d.standardbody.offsetHeight>d.standardbody.scrollHeight)?d.standardbody.offsetHeight:d.standardbody.scrollHeight
this.interVeil.style.width=d.docwidth+"px"
this.interVeil.style.height=this.docheightcomplete+"px"
this.interVeil.style.left=0
this.interVeil.style.top=0
this.interVeil.style.visibility="visible"
this.interVeil.style.display="block"},adjustveil:function(){if(this.interVeil&&this.interVeil.style.display=="block")
this.loadveil()},closeveil:function(){this.veilstack--
if($(ksu).length===0){this.interVeil.style.display="none"}else if($(ksu).attr('style').indexOf('display: none')>-1){this.interVeil.style.display="none"}},close:function(t,forceclose){try{var closewinbol=t.onclose()}
catch(err){var closewinbol=true}
finally{if(typeof closewinbol=="undefined"){var closewinbol=true}}
if(closewinbol){if(t.state!="minimized")
dhtmlwindow.rememberattrs(t)
if(window.frames["_iframe-"+t.id])
window.frames["_iframe-"+t.id].location.replace("about:blank")
else
t.contentarea.innerHTML=""
t.style.display="none"
t.isClosed=true}
this.closeveil();return closewinbol},show:function(t){dhtmlmodal.veilstack++
dhtmlmodal.loadveil()
dhtmlwindow.show(t)}}
document.write('<div id="interVeil"></div>')
dhtmlwindow.addEvent(window,function(){if(typeof dhtmlmodal!="undefined")dhtmlmodal.adjustveil()},"resize")