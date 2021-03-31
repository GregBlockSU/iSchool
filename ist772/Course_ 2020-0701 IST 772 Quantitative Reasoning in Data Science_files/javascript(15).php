var ksu;var klibrary;var kcrop;var kdpwin;var kcapture;var krecord;function openKSUWindow(winurl,wintitle){ksu=dhtmlmodal.open("ksubox","iframe",winurl,wintitle,"width=430px,height=250px,resize=0,scrolling=1,center=1")
ksu.onclose=function(){ksu.hide();window.parent.$('#interVeil').hide();return false;}}
function openKlibraryWindow(winurl,wintitle){klibrary=dhtmlmodal.open("klibrarybox","iframe",winurl,wintitle,"width=635px,height=620px,resize=1,scrolling=1,center=1","recal")
klibrary.onclose=function(){klibrary.hide();ksu.show();return false;}}
function reloadKlibraryWindow(winurl,wintitle){klibrary.load("iframe",winurl,wintitle)}
function openKcropWindow(winurl,wintitle){kcrop=dhtmlwindow.open("kcropbox","iframe",winurl,wintitle,"width=635px,height=520px,resize=0,scrolling=1,center=1","recal");kcrop.onclose=function(){kcrop.hide();return false;}}
function openKDPWindow(winurl,wintitle){kdpwin=dhtmlmodal.open("kdpbox","iframe",winurl,wintitle,"width=427px,height=400px,resize=0,scrolling=1,center=1","recal");LmsApp.keep_focus_kdpbox();kdpwin.onclose=function(){window.parent.$('#interVeil').hide();};}
function openKcaptureWindow(winurl,wintitle){kcapture=dhtmlmodal.open("kcapturebox","iframe",winurl,wintitle,"width=470px,height=370px,resize=0,scrolling=1,center=1","recal")
kcapture.onclose=function(){closekcapture();kcapture.hide();ksu.show();return false;}}
function closekcapture()
{document.getElementById('camera').innerHTML="";}
function openKRecordWindow(winurl,wintitle){krecord=dhtmlwindow.open("krecord","iframe",winurl,wintitle,"width=685px,height=360px,resize=0,scrolling=1,center=1","recal")
krecord.onclose=function(){ksu.show();}}
function openKpresentationWindow(winurl,wintitle){kpresentation=dhtmlwindow.open("kpresentation","iframe",winurl,wintitle,"width=910px,height=510px,resize=0,scrolling=1,center=1","recal")
kpresentation.onclose=function(){}}