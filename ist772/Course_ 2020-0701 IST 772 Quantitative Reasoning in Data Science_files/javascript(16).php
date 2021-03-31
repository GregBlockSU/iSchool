KalturaThumbRotator={slices:16,frameRate:1000,timer:null,slice:0,img:new Image(),thumbBase:function(o)
{var path=o.src;if(path==undefined)
{return'error';}
var pos=path.indexOf("/vid_slice");if(pos!=-1)
path=path.substring(0,pos);return path;},change:function(o,i)
{slice=(i+1)%this.slices;var path=this.thumbBase(o);if(path=='error')
{return;}
o.src=path+"/vid_slice/"+i+"/vid_slices/"+this.slices;this.img.src=path+"/vid_slice/"+slice+"/vid_slices/"+this.slices;i=i%this.slices;i++;this.timer=setTimeout(function(){KalturaThumbRotator.change(o,i)},this.frameRate);},start:function(o)
{clearTimeout(this.timer);var path=this.thumbBase(o);this.change(o,1);},end:function(o)
{clearTimeout(this.timer);o.src=this.thumbBase(o);}};