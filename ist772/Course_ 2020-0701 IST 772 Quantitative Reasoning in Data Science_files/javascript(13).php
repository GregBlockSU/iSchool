function popconference_admin(PopURL,w,h){var l=1;var t=1;if(w===undefined){w=screen.availWidth;}
else{l=(screen.availWidth-w)/2;}
if(h===undefined){h=screen.availHeight;}
else{t=(screen.availHeight-h)/2;}
var winname='session';var options='scrollbars=1,resizable,dependant,fullscreen'
var newwin=window.open(PopURL,winname,'width='+w+',height='+h+',left='+l+',top='+t+','+options)
if(window.focus){newwin.focus()}
return newwin;}
function popconference(PopURL,target,w,h){var l=1;var t=1;if(w===undefined){w=screen.availWidth;}
else{l=(screen.availWidth-w)/2;}
if(h===undefined){h=screen.availHeight;}
else{t=(screen.availHeight-h)/2;}
if(target===undefined)
var winname='livesession';else var winname=target;var options='scrollbars=1,resizable,dependant,fullscreen'
var newwin=window.open(PopURL,winname,'width='+w+',height='+h+',left='+l+',top='+t+','+options)
if(window.focus){newwin.focus()}
return newwin;}
function watch_recording(recording_api_url){$.ajax({url:recording_api_url,type:'get',success:function(data,textStatus,jqXHR){popconference(data.join_url,'recording');},error:function(jqXHR,textStatus,errorThrown){console.log('The following error occured: '+
textStatus,errorThrown);alert("An error has occurred when attempting to watch the recording.");}});}
function edit_profile(editprofileurl){document.location.href=editprofileurl;}
function delete_group(delgroupurl){var r=confirm("Do you really want to delete this group?");if(r==true)
{document.location.href=delgroupurl;}}
function checkAll(obj,frm,objname){objchks=frm[objname];for(i=0;i<objchks.length;i++){objchks[i].checked=obj.checked;}}
function parse_intvalue(value){return parseInt(value,10);}
function getCheckedValue(radioObj){if(!radioObj)
return"";var radioLength=radioObj.length;if(radioLength==undefined)
if(radioObj.checked)
return radioObj.value;else
return"";for(var i=0;i<radioLength;i++){if(radioObj[i].checked){return radioObj[i].value;}}
return"";}
function showResumeMsg(){Ext.Msg.alert('Not Published','This user has not published a resume.');}
function showLivesessionGradePopUP(value){if(value==-7||value==-8){}
else{Ext.MessageBox.buttonText.yes='Yes';Ext.MessageBox.buttonText.no='<span style="text-decoration:underline;font-weight:bold;color:#000">No</span>';Ext.MessageBox.getDialog().defaultButton=2;Ext.MessageBox.show({title:'Please confirm',msg:'You have selected a non auto gradable grade. This means the current LS activity will have to be manually graded. Do you wish to continue?',buttons:Ext.MessageBox.YESNO,scope:this,animEl:this.tree,icon:Ext.MessageBox.QUESTION,fn:function(btn,text){if(btn=='yes'){}else{document.getElementById('id_grade').value=-7;}}})}}