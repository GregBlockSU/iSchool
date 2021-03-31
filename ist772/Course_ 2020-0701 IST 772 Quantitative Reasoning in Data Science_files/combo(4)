/*
Copyright (c) 2010, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/yui/license.html
version: 3.2.0
build: 2676
*/
YUI.add("event-custom-base",function(E){E.Env.evt={handles:{},plugins:{}};(function(){var F=0,G=1;E.Do={objs:{},before:function(I,K,L,M){var J=I,H;if(M){H=[I,M].concat(E.Array(arguments,4,true));J=E.rbind.apply(E,H);}return this._inject(F,J,K,L);},after:function(I,K,L,M){var J=I,H;if(M){H=[I,M].concat(E.Array(arguments,4,true));J=E.rbind.apply(E,H);}return this._inject(G,J,K,L);},_inject:function(H,J,K,M){var N=E.stamp(K),L,I;if(!this.objs[N]){this.objs[N]={};}L=this.objs[N];if(!L[M]){L[M]=new E.Do.Method(K,M);K[M]=function(){return L[M].exec.apply(L[M],arguments);};}I=N+E.stamp(J)+M;L[M].register(I,J,H);return new E.EventHandle(L[M],I);},detach:function(H){if(H.detach){H.detach();}},_unload:function(I,H){}};E.Do.Method=function(H,I){this.obj=H;this.methodName=I;this.method=H[I];this.before={};this.after={};};E.Do.Method.prototype.register=function(I,J,H){if(H){this.after[I]=J;}else{this.before[I]=J;}};E.Do.Method.prototype._delete=function(H){delete this.before[H];delete this.after[H];};E.Do.Method.prototype.exec=function(){var J=E.Array(arguments,0,true),K,I,N,L=this.before,H=this.after,M=false;for(K in L){if(L.hasOwnProperty(K)){I=L[K].apply(this.obj,J);if(I){switch(I.constructor){case E.Do.Halt:return I.retVal;case E.Do.AlterArgs:J=I.newArgs;break;case E.Do.Prevent:M=true;break;default:}}}}if(!M){I=this.method.apply(this.obj,J);}for(K in H){if(H.hasOwnProperty(K)){N=H[K].apply(this.obj,J);if(N&&N.constructor==E.Do.Halt){return N.retVal;}else{if(N&&N.constructor==E.Do.AlterReturn){I=N.newRetVal;}}}}return I;};E.Do.AlterArgs=function(I,H){this.msg=I;this.newArgs=H;};E.Do.AlterReturn=function(I,H){this.msg=I;this.newRetVal=H;};E.Do.Halt=function(I,H){this.msg=I;this.retVal=H;};E.Do.Prevent=function(H){this.msg=H;};E.Do.Error=E.Do.Halt;})();var D="after",B=["broadcast","monitored","bubbles","context","contextFn","currentTarget","defaultFn","defaultTargetOnly","details","emitFacade","fireOnce","async","host","preventable","preventedFn","queuable","silent","stoppedFn","target","type"],C=9,A="yui:log";E.EventHandle=function(F,G){this.evt=F;this.sub=G;};E.EventHandle.prototype={each:function(F){F(this);if(E.Lang.isArray(this.evt)){E.Array.each(this.evt,function(G){G.each(F);});}},detach:function(){var F=this.evt,H=0,G;if(F){if(E.Lang.isArray(F)){for(G=0;G<F.length;G++){H+=F[G].detach();}}else{F._delete(this.sub);H=1;}}return H;},monitor:function(F){return this.evt.monitor.apply(this.evt,arguments);}};E.CustomEvent=function(F,G){G=G||{};this.id=E.stamp(this);this.type=F;this.context=E;this.logSystem=(F==A);this.silent=this.logSystem;this.subscribers={};this.afters={};this.preventable=true;this.bubbles=true;this.signature=C;this.subCount=0;this.afterCount=0;this.applyConfig(G,true);};E.CustomEvent.prototype={hasSubs:function(F){var I=this.subCount,G=this.afterCount,H=this.sibling;if(H){I+=H.subCount;G+=H.afterCount;}if(F){return(F=="after")?G:I;}return(I+G);},monitor:function(H){this.monitored=true;var G=this.id+"|"+this.type+"_"+H,F=E.Array(arguments,0,true);F[0]=G;return this.host.on.apply(this.host,F);},getSubs:function(){var H=E.merge(this.subscribers),F=E.merge(this.afters),G=this.sibling;if(G){E.mix(H,G.subscribers);E.mix(F,G.afters);}return[H,F];},applyConfig:function(G,F){if(G){E.mix(this,G,F,B);}},_on:function(J,H,G,F){if(!J){this.log("Invalid callback for CE: "+this.type);}var I=new E.Subscriber(J,H,G,F);if(this.fireOnce&&this.fired){if(this.async){setTimeout(E.bind(this._notify,this,I,this.firedWith),0);}else{this._notify(I,this.firedWith);}}if(F==D){this.afters[I.id]=I;this.afterCount++;}else{this.subscribers[I.id]=I;this.subCount++;}return new E.EventHandle(this,I);},subscribe:function(H,G){var F=(arguments.length>2)?E.Array(arguments,2,true):null;return this._on(H,G,F,true);},on:function(H,G){var F=(arguments.length>2)?E.Array(arguments,2,true):null;if(this.host){this.host._monitor("attach",this.type,{args:arguments});}return this._on(H,G,F,true);},after:function(H,G){var F=(arguments.length>2)?E.Array(arguments,2,true):null;return this._on(H,G,F,D);},detach:function(J,H){if(J&&J.detach){return J.detach();}var G,I,K=0,F=E.merge(this.subscribers,this.afters);for(G in F){if(F.hasOwnProperty(G)){I=F[G];if(I&&(!J||J===I.fn)){this._delete(I);K++;}}}return K;},unsubscribe:function(){return this.detach.apply(this,arguments);},_notify:function(I,H,F){this.log(this.type+"->"+"sub: "+I.id);var G;G=I.notify(H,this);if(false===G||this.stopped>1){this.log(this.type+" cancelled by subscriber");return false;}return true;},log:function(G,F){if(!this.silent){}},fire:function(){if(this.fireOnce&&this.fired){this.log("fireOnce event: "+this.type+" already fired");return true;}else{var F=E.Array(arguments,0,true);this.fired=true;this.firedWith=F;if(this.emitFacade){return this.fireComplex(F);}else{return this.fireSimple(F);}}},fireSimple:function(F){this.stopped=0;this.prevented=0;if(this.hasSubs()){var G=this.getSubs();this._procSubs(G[0],F);this._procSubs(G[1],F);}this._broadcast(F);return this.stopped?false:true;},fireComplex:function(F){F[0]=F[0]||{};return this.fireSimple(F);},_procSubs:function(I,G,F){var J,H;for(H in I){if(I.hasOwnProperty(H)){J=I[H];if(J&&J.fn){if(false===this._notify(J,G,F)){this.stopped=2;}if(this.stopped==2){return false;}}}}return true;},_broadcast:function(G){if(!this.stopped&&this.broadcast){var F=E.Array(G);F.unshift(this.type);if(this.host!==E){E.fire.apply(E,F);}if(this.broadcast==2){E.Global.fire.apply(E.Global,F);}}},unsubscribeAll:function(){return this.detachAll.apply(this,arguments);},detachAll:function(){return this.detach();},_delete:function(F){if(F){if(this.subscribers[F.id]){delete this.subscribers[F.id];this.subCount--;}if(this.afters[F.id]){delete this.afters[F.id];this.afterCount--;}}if(this.host){this.host._monitor("detach",this.type,{ce:this,sub:F});}if(F){delete F.fn;delete F.context;}}};E.Subscriber=function(H,G,F){this.fn=H;this.context=G;this.id=E.stamp(this);this.args=F;};E.Subscriber.prototype={_notify:function(J,H,I){var F=this.args,G;switch(I.signature){case 0:G=this.fn.call(J,I.type,H,J);
break;case 1:G=this.fn.call(J,H[0]||null,J);break;default:if(F||H){H=H||[];F=(F)?H.concat(F):H;G=this.fn.apply(J,F);}else{G=this.fn.call(J);}}if(this.once){I._delete(this);}return G;},notify:function(G,I){var J=this.context,F=true;if(!J){J=(I.contextFn)?I.contextFn():I.context;}if(E.config.throwFail){F=this._notify(J,G,I);}else{try{F=this._notify(J,G,I);}catch(H){E.error(this+" failed: "+H.message,H);}}return F;},contains:function(G,F){if(F){return((this.fn==G)&&this.context==F);}else{return(this.fn==G);}}};(function(){var K=E.Lang,J=":",H="|",N="~AFTER~",M=E.Array,F=E.cached(function(L){return L.replace(/(.*)(:)(.*)/,"*$2$3");}),O=E.cached(function(L,P){if(!P||!K.isString(L)||L.indexOf(J)>-1){return L;}return P+J+L;}),I=E.cached(function(Q,S){var P=Q,R,T,L;if(!K.isString(P)){return P;}L=P.indexOf(N);if(L>-1){T=true;P=P.substr(N.length);}L=P.indexOf(H);if(L>-1){R=P.substr(0,(L));P=P.substr(L+1);if(P=="*"){P=null;}}return[R,(S)?O(P,S):P,T,P];}),G=function(L){var P=(K.isObject(L))?L:{};this._yuievt=this._yuievt||{id:E.guid(),events:{},targets:{},config:P,chain:("chain" in P)?P.chain:E.config.chain,bubbling:false,defaults:{context:P.context||this,host:this,emitFacade:P.emitFacade,fireOnce:P.fireOnce,queuable:P.queuable,monitored:P.monitored,broadcast:P.broadcast,defaultTargetOnly:P.defaultTargetOnly,bubbles:("bubbles" in P)?P.bubbles:true}};};G.prototype={once:function(){var L=this.on.apply(this,arguments);L.each(function(P){if(P.sub){P.sub.once=true;}});return L;},on:function(S,X,Q){var a=I(S,this._yuievt.config.prefix),d,e,P,i,Z,Y,g,U=E.Env.evt.handles,R,L,V,h=E.Node,b,W,T;this._monitor("attach",a[1],{args:arguments,category:a[0],after:a[2]});if(K.isObject(S)){if(K.isFunction(S)){return E.Do.before.apply(E.Do,arguments);}d=X;e=Q;P=M(arguments,0,true);i=[];if(K.isArray(S)){T=true;}R=S._after;delete S._after;E.each(S,function(j,f){if(K.isObject(j)){d=j.fn||((K.isFunction(j))?j:d);e=j.context||e;}var c=(R)?N:"";P[0]=c+((T)?j:f);P[1]=d;P[2]=e;i.push(this.on.apply(this,P));},this);return(this._yuievt.chain)?this:new E.EventHandle(i);}Y=a[0];R=a[2];V=a[3];if(h&&(this instanceof h)&&(V in h.DOM_EVENTS)){P=M(arguments,0,true);P.splice(2,0,h.getDOMNode(this));return E.on.apply(E,P);}S=a[1];if(this instanceof YUI){L=E.Env.evt.plugins[S];P=M(arguments,0,true);P[0]=V;if(h){b=P[2];if(b instanceof E.NodeList){b=E.NodeList.getDOMNodes(b);}else{if(b instanceof h){b=h.getDOMNode(b);}}W=(V in h.DOM_EVENTS);if(W){P[2]=b;}}if(L){g=L.on.apply(E,P);}else{if((!S)||W){g=E.Event._attach(P);}}}if(!g){Z=this._yuievt.events[S]||this.publish(S);g=Z._on(X,Q,(arguments.length>3)?M(arguments,3,true):null,(R)?"after":true);}if(Y){U[Y]=U[Y]||{};U[Y][S]=U[Y][S]||[];U[Y][S].push(g);}return(this._yuievt.chain)?this:g;},subscribe:function(){return this.on.apply(this,arguments);},detach:function(X,Z,L){var d=this._yuievt.events,S,U=E.Node,b=U&&(this instanceof U);if(!X&&(this!==E)){for(S in d){if(d.hasOwnProperty(S)){d[S].detach(Z,L);}}if(b){E.Event.purgeElement(U.getDOMNode(this));}return this;}var R=I(X,this._yuievt.config.prefix),W=K.isArray(R)?R[0]:null,e=(R)?R[3]:null,T,a=E.Env.evt.handles,c,Y,V,Q,P=function(k,h,j){var g=k[h],l,f;if(g){for(f=g.length-1;f>=0;--f){l=g[f].evt;if(l.host===j||l.el===j){g[f].detach();}}}};if(W){Y=a[W];X=R[1];c=(b)?E.Node.getDOMNode(this):this;if(Y){if(X){P(Y,X,c);}else{for(S in Y){if(Y.hasOwnProperty(S)){P(Y,S,c);}}}return this;}}else{if(K.isObject(X)&&X.detach){X.detach();return this;}else{if(b&&((!e)||(e in U.DOM_EVENTS))){V=M(arguments,0,true);V[2]=U.getDOMNode(this);E.detach.apply(E,V);return this;}}}T=E.Env.evt.plugins[e];if(this instanceof YUI){V=M(arguments,0,true);if(T&&T.detach){T.detach.apply(E,V);return this;}else{if(!X||(!T&&U&&(X in U.DOM_EVENTS))){V[0]=X;E.Event.detach.apply(E.Event,V);return this;}}}Q=d[R[1]];if(Q){Q.detach(Z,L);}return this;},unsubscribe:function(){return this.detach.apply(this,arguments);},detachAll:function(L){return this.detach(L);},unsubscribeAll:function(){return this.detachAll.apply(this,arguments);},publish:function(Q,R){var P,V,L,U,T=this._yuievt,S=T.config.prefix;Q=(S)?O(Q,S):Q;this._monitor("publish",Q,{args:arguments});if(K.isObject(Q)){L={};E.each(Q,function(X,W){L[W]=this.publish(W,X||R);},this);return L;}P=T.events;V=P[Q];if(V){if(R){V.applyConfig(R,true);}}else{U=T.defaults;V=new E.CustomEvent(Q,(R)?E.merge(U,R):U);P[Q]=V;}return P[Q];},_monitor:function(R,L,S){var P,Q=this.getEvent(L);if((this._yuievt.config.monitored&&(!Q||Q.monitored))||(Q&&Q.monitored)){P=L+"_"+R;S.monitored=R;this.fire.call(this,P,S);}},fire:function(R){var V=K.isString(R),Q=(V)?R:(R&&R.type),U,P,T=this._yuievt.config.prefix,S,L=(V)?M(arguments,1,true):arguments;Q=(T)?O(Q,T):Q;this._monitor("fire",Q,{args:L});U=this.getEvent(Q,true);S=this.getSibling(Q,U);if(S&&!U){U=this.publish(Q);}if(!U){if(this._yuievt.hasTargets){return this.bubble({type:Q},L,this);}P=true;}else{U.sibling=S;P=U.fire.apply(U,L);}return(this._yuievt.chain)?this:P;},getSibling:function(L,Q){var P;if(L.indexOf(J)>-1){L=F(L);P=this.getEvent(L,true);if(P){P.applyConfig(Q);P.bubbles=false;P.broadcast=0;}}return P;},getEvent:function(P,L){var R,Q;if(!L){R=this._yuievt.config.prefix;P=(R)?O(P,R):P;}Q=this._yuievt.events;return Q[P]||null;},after:function(Q,P){var L=M(arguments,0,true);switch(K.type(Q)){case"function":return E.Do.after.apply(E.Do,arguments);case"array":case"object":L[0]._after=true;break;default:L[0]=N+Q;}return this.on.apply(this,L);},before:function(){return this.on.apply(this,arguments);}};E.EventTarget=G;E.mix(E,G.prototype,false,false,{bubbles:false});G.call(E);YUI.Env.globalEvents=YUI.Env.globalEvents||new G();E.Global=YUI.Env.globalEvents;})();},"3.2.0",{requires:["oop"]});YUI.add("event-custom-complex",function(A){(function(){var C,E,B=A.CustomEvent.prototype,D=A.EventTarget.prototype;A.EventFacade=function(G,F){G=G||{};this.details=G.details;this.type=G.type;this._type=G.type;this.target=G.target;this.currentTarget=F;this.relatedTarget=G.relatedTarget;this.stopPropagation=function(){G.stopPropagation();
this.stopped=1;};this.stopImmediatePropagation=function(){G.stopImmediatePropagation();this.stopped=2;};this.preventDefault=function(){G.preventDefault();this.prevented=1;};this.halt=function(H){G.halt(H);this.prevented=1;this.stopped=(H)?2:1;};};B.fireComplex=function(N){var O=A.Env._eventstack,J,F,L,G,M,R,H,Q=this,P=Q.host||Q,K,I;if(O){if(Q.queuable&&Q.type!=O.next.type){Q.log("queue "+Q.type);O.queue.push([Q,N]);return true;}}else{A.Env._eventstack={id:Q.id,next:Q,silent:Q.silent,stopped:0,prevented:0,bubbling:null,type:Q.type,afterQueue:new A.Queue(),defaultTargetOnly:Q.defaultTargetOnly,queue:[]};O=A.Env._eventstack;}H=Q.getSubs();Q.stopped=(Q.type!==O.type)?0:O.stopped;Q.prevented=(Q.type!==O.type)?0:O.prevented;Q.target=Q.target||P;R=new A.EventTarget({fireOnce:true,context:P});Q.events=R;if(Q.preventedFn){R.on("prevented",Q.preventedFn);}if(Q.stoppedFn){R.on("stopped",Q.stoppedFn);}Q.currentTarget=P;Q.details=N.slice();Q.log("Firing "+Q.type);Q._facade=null;J=Q._getFacade(N);if(A.Lang.isObject(N[0])){N[0]=J;}else{N.unshift(J);}if(H[0]){Q._procSubs(H[0],N,J);}if(Q.bubbles&&P.bubble&&!Q.stopped){I=O.bubbling;O.bubbling=Q.type;if(O.type!=Q.type){O.stopped=0;O.prevented=0;}M=P.bubble(Q);Q.stopped=Math.max(Q.stopped,O.stopped);Q.prevented=Math.max(Q.prevented,O.prevented);O.bubbling=I;}if(Q.defaultFn&&!Q.prevented&&((!Q.defaultTargetOnly&&!O.defaultTargetOnly)||P===J.target)){Q.defaultFn.apply(P,N);}Q._broadcast(N);if(H[1]&&!Q.prevented&&Q.stopped<2){if(O.id===Q.id||Q.type!=P._yuievt.bubbling){Q._procSubs(H[1],N,J);while((K=O.afterQueue.last())){K();}}else{O.afterQueue.add(function(){Q._procSubs(H[1],N,J);});}}Q.target=null;if(O.id===Q.id){L=O.queue;while(L.length){F=L.pop();G=F[0];O.next=G;G.fire.apply(G,F[1]);}A.Env._eventstack=null;}M=!(Q.stopped);if(Q.type!=P._yuievt.bubbling){O.stopped=0;O.prevented=0;Q.stopped=0;Q.prevented=0;}return M;};B._getFacade=function(){var F=this._facade,I,H,G=this.details;if(!F){F=new A.EventFacade(this,this.currentTarget);}I=G&&G[0];if(A.Lang.isObject(I,true)){H={};A.mix(H,F,true,E);A.mix(F,I,true);A.mix(F,H,true,E);F.type=I.type||F.type;}F.details=this.details;F.target=this.originalTarget||this.target;F.currentTarget=this.currentTarget;F.stopped=0;F.prevented=0;this._facade=F;return this._facade;};B.stopPropagation=function(){this.stopped=1;A.Env._eventstack.stopped=1;this.events.fire("stopped",this);};B.stopImmediatePropagation=function(){this.stopped=2;A.Env._eventstack.stopped=2;this.events.fire("stopped",this);};B.preventDefault=function(){if(this.preventable){this.prevented=1;A.Env._eventstack.prevented=1;this.events.fire("prevented",this);}};B.halt=function(F){if(F){this.stopImmediatePropagation();}else{this.stopPropagation();}this.preventDefault();};D.addTarget=function(F){this._yuievt.targets[A.stamp(F)]=F;this._yuievt.hasTargets=true;};D.getTargets=function(){return A.Object.values(this._yuievt.targets);};D.removeTarget=function(F){delete this._yuievt.targets[A.stamp(F)];};D.bubble=function(R,O,M){var K=this._yuievt.targets,N=true,S,P=R&&R.type,G,J,L,H,F=M||(R&&R.target)||this,Q=A.Env._eventstack,I;if(!R||((!R.stopped)&&K)){for(J in K){if(K.hasOwnProperty(J)){S=K[J];G=S.getEvent(P,true);H=S.getSibling(P,G);if(H&&!G){G=S.publish(P);}I=S._yuievt.bubbling;S._yuievt.bubbling=P;if(!G){if(S._yuievt.hasTargets){S.bubble(R,O,F);}}else{G.sibling=H;G.target=F;G.originalTarget=F;G.currentTarget=S;L=G.broadcast;G.broadcast=false;G.emitFacade=true;N=N&&G.fire.apply(G,O||R.details||[]);G.broadcast=L;G.originalTarget=null;if(G.stopped){break;}}S._yuievt.bubbling=I;}}}return N;};C=new A.EventFacade();E=A.Object.keys(C);})();},"3.2.0",{requires:["event-custom-base"]});YUI.add("event-custom",function(A){},"3.2.0",{use:["event-custom-base","event-custom-complex"]});/*
Copyright (c) 2010, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/yui/license.html
version: 3.2.0
build: 2676
*/
YUI.add("attribute-base",function(C){C.State=function(){this.data={};};C.State.prototype={add:function(O,Y,f){var e=this.data;e[Y]=e[Y]||{};e[Y][O]=f;},addAll:function(O,d){var Y;for(Y in d){if(d.hasOwnProperty(Y)){this.add(O,Y,d[Y]);}}},remove:function(O,Y){var e=this.data;if(e[Y]&&(O in e[Y])){delete e[Y][O];}},removeAll:function(O,e){var Y=this.data;C.each(e||Y,function(f,d){if(C.Lang.isString(d)){this.remove(O,d);}else{this.remove(O,f);}},this);},get:function(O,Y){var e=this.data;return(e[Y]&&O in e[Y])?e[Y][O]:undefined;},getAll:function(O){var e=this.data,Y;C.each(e,function(f,d){if(O in e[d]){Y=Y||{};Y[d]=f[O];}},this);return Y;}};var K=C.Object,F=C.Lang,L=C.EventTarget,X=".",U="Change",N="getter",M="setter",P="readOnly",Z="writeOnce",V="initOnly",c="validator",H="value",Q="valueFn",E="broadcast",S="lazyAdd",J="_bypassProxy",b="added",B="initializing",I="initValue",W="published",T="defaultValue",A="lazy",R="isLazyAdd",G,a={};a[P]=1;a[Z]=1;a[N]=1;a[E]=1;function D(){var d=this,O=this.constructor.ATTRS,Y=C.Base;d._ATTR_E_FACADE={};L.call(d,{emitFacade:true});d._conf=d._state=new C.State();d._stateProxy=d._stateProxy||null;d._requireAddAttr=d._requireAddAttr||false;if(O&&!(Y&&d instanceof Y)){d.addAttrs(this._protectAttrs(O));}}D.INVALID_VALUE={};G=D.INVALID_VALUE;D._ATTR_CFG=[M,N,c,H,Q,Z,P,S,E,J];D.prototype={addAttr:function(Y,O,e){var f=this,h=f._state,g,d;e=(S in O)?O[S]:e;if(e&&!f.attrAdded(Y)){h.add(Y,A,O||{});h.add(Y,b,true);}else{if(!f.attrAdded(Y)||h.get(Y,R)){O=O||{};d=(H in O);if(d){g=O.value;delete O.value;}O.added=true;O.initializing=true;h.addAll(Y,O);if(d){f.set(Y,g);}h.remove(Y,B);}}return f;},attrAdded:function(O){return !!this._state.get(O,b);},modifyAttr:function(Y,O){var d=this,f,e;if(d.attrAdded(Y)){if(d._isLazyAttr(Y)){d._addLazyAttr(Y);}e=d._state;for(f in O){if(a[f]&&O.hasOwnProperty(f)){e.add(Y,f,O[f]);if(f===E){e.remove(Y,W);}}}}},removeAttr:function(O){this._state.removeAll(O);},get:function(O){return this._getAttr(O);},_isLazyAttr:function(O){return this._state.get(O,A);},_addLazyAttr:function(Y){var d=this._state,O=d.get(Y,A);d.add(Y,R,true);d.remove(Y,A);this.addAttr(Y,O);},set:function(O,d,Y){return this._setAttr(O,d,Y);},reset:function(O){var d=this,Y;if(O){if(d._isLazyAttr(O)){d._addLazyAttr(O);}d.set(O,d._state.get(O,I));}else{Y=d._state.data.added;C.each(Y,function(e,f){d.reset(f);},d);}return d;},_set:function(O,d,Y){return this._setAttr(O,d,Y,true);},_getAttr:function(d){var e=this,i=d,f=e._state,g,O,h,Y;if(d.indexOf(X)!==-1){g=d.split(X);d=g.shift();}if(e._tCfgs&&e._tCfgs[d]){Y={};Y[d]=e._tCfgs[d];delete e._tCfgs[d];e._addAttrs(Y,e._tVals);}if(e._isLazyAttr(d)){e._addLazyAttr(d);}h=e._getStateVal(d);O=f.get(d,N);if(O&&!O.call){O=this[O];}h=(O)?O.call(e,h,i):h;h=(g)?K.getValue(h,g):h;return h;},_setAttr:function(d,g,O,e){var k=true,Y=this._state,h=this._stateProxy,m=Y.data,j,n,o,f,i,l;if(d.indexOf(X)!==-1){n=d;o=d.split(X);d=o.shift();}if(this._isLazyAttr(d)){this._addLazyAttr(d);}j=(!m.value||!(d in m.value));if(h&&d in h&&!this._state.get(d,J)){j=false;}if(this._requireAddAttr&&!this.attrAdded(d)){}else{i=Y.get(d,Z);l=Y.get(d,B);if(!j&&!e){if(i){k=false;}if(Y.get(d,P)){k=false;}}if(!l&&!e&&i===V){k=false;}if(k){if(!j){f=this.get(d);}if(o){g=K.setValue(C.clone(f),o,g);if(g===undefined){k=false;}}if(k){if(l){this._setAttrVal(d,n,f,g);}else{this._fireAttrChange(d,n,f,g,O);}}}}return this;},_fireAttrChange:function(h,g,e,d,O){var j=this,f=h+U,Y=j._state,i;if(!Y.get(h,W)){j.publish(f,{queuable:false,defaultTargetOnly:true,defaultFn:j._defAttrChangeFn,silent:true,broadcast:Y.get(h,E)});Y.add(h,W,true);}i=(O)?C.merge(O):j._ATTR_E_FACADE;i.type=f;i.attrName=h;i.subAttrName=g;i.prevVal=e;i.newVal=d;j.fire(i);},_defAttrChangeFn:function(O){if(!this._setAttrVal(O.attrName,O.subAttrName,O.prevVal,O.newVal)){O.stopImmediatePropagation();}else{O.newVal=this.get(O.attrName);}},_getStateVal:function(O){var Y=this._stateProxy;return Y&&(O in Y)&&!this._state.get(O,J)?Y[O]:this._state.get(O,H);},_setStateVal:function(O,d){var Y=this._stateProxy;if(Y&&(O in Y)&&!this._state.get(O,J)){Y[O]=d;}else{this._state.add(O,H,d);}},_setAttrVal:function(m,l,i,g){var o=this,j=true,d=o._state,e=d.get(m,c),h=d.get(m,M),k=d.get(m,B),n=this._getStateVal(m),Y=l||m,f,O;if(e){if(!e.call){e=this[e];}if(e){O=e.call(o,g,Y);if(!O&&k){g=d.get(m,T);O=true;}}}if(!e||O){if(h){if(!h.call){h=this[h];}if(h){f=h.call(o,g,Y);if(f===G){j=false;}else{if(f!==undefined){g=f;}}}}if(j){if(!l&&(g===n)&&!F.isObject(g)){j=false;}else{if(d.get(m,I)===undefined){d.add(m,I,g);}o._setStateVal(m,g);}}}else{j=false;}return j;},setAttrs:function(O,Y){return this._setAttrs(O,Y);},_setAttrs:function(Y,d){for(var O in Y){if(Y.hasOwnProperty(O)){this.set(O,Y[O]);}}return this;},getAttrs:function(O){return this._getAttrs(O);},_getAttrs:function(e){var g=this,j={},f,Y,O,h,d=(e===true);e=(e&&!d)?e:K.keys(g._state.data.added);for(f=0,Y=e.length;f<Y;f++){O=e[f];h=g.get(O);if(!d||g._getStateVal(O)!=g._state.get(O,I)){j[O]=g.get(O);}}return j;},addAttrs:function(O,Y,d){var e=this;if(O){e._tCfgs=O;e._tVals=e._normAttrVals(Y);e._addAttrs(O,e._tVals,d);e._tCfgs=e._tVals=null;}return e;},_addAttrs:function(Y,d,e){var g=this,O,f,h;for(O in Y){if(Y.hasOwnProperty(O)){f=Y[O];f.defaultValue=f.value;h=g._getAttrInitVal(O,f,g._tVals);if(h!==undefined){f.value=h;}if(g._tCfgs[O]){delete g._tCfgs[O];}g.addAttr(O,f,e);}}},_protectAttrs:function(Y){if(Y){Y=C.merge(Y);for(var O in Y){if(Y.hasOwnProperty(O)){Y[O]=C.merge(Y[O]);}}}return Y;},_normAttrVals:function(O){return(O)?C.merge(O):null;},_getAttrInitVal:function(O,Y,e){var f,d;if(!Y[P]&&e&&e.hasOwnProperty(O)){f=e[O];}else{f=Y[H];d=Y[Q];if(d){if(!d.call){d=this[d];}if(d){f=d.call(this);}}}return f;},_getAttrCfg:function(O){var d,Y=this._state.data;if(Y){d={};C.each(Y,function(e,f){if(O){if(O in e){d[f]=e[O];}}else{C.each(e,function(h,g){d[g]=d[g]||{};d[g][f]=h;});}});}return d;}};C.mix(D,L,false,null,1);C.Attribute=D;},"3.2.0",{requires:["event-custom"]});/*
Copyright (c) 2010, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/yui/license.html
version: 3.2.0
build: 2676
*/
YUI.add("base-base",function(B){var I=B.Object,K=B.Lang,J=".",G="destroy",R="init",Q="initialized",H="destroyed",D="initializer",N="bubbleTargets",E="_bubbleTargets",C=Object.prototype.constructor,M="deep",S="shallow",P="destructor",A=B.Attribute;function F(){A.call(this);var L=B.Plugin&&B.Plugin.Host;if(this._initPlugins&&L){L.call(this);}if(this._lazyAddAttrs!==false){this._lazyAddAttrs=true;}this.name=this.constructor.NAME;this._eventPrefix=this.constructor.EVENT_PREFIX||this.constructor.NAME;this.init.apply(this,arguments);}F._ATTR_CFG=A._ATTR_CFG.concat("cloneDefaultValue");F.NAME="base";F.ATTRS={initialized:{readOnly:true,value:false},destroyed:{readOnly:true,value:false}};F.prototype={init:function(L){this._yuievt.config.prefix=this._eventPrefix;this.publish(R,{queuable:false,fireOnce:true,defaultTargetOnly:true,defaultFn:this._defInitFn});this._preInitEventCfg(L);this.fire(R,{cfg:L});return this;},_preInitEventCfg:function(O){if(O){if(O.on){this.on(O.on);}if(O.after){this.after(O.after);}}var T,L,V,U=(O&&N in O);if(U||E in this){V=U?(O&&O.bubbleTargets):this._bubbleTargets;if(K.isArray(V)){for(T=0,L=V.length;T<L;T++){this.addTarget(V[T]);}}else{if(V){this.addTarget(V);}}}},destroy:function(){this.publish(G,{queuable:false,fireOnce:true,defaultTargetOnly:true,defaultFn:this._defDestroyFn});this.fire(G);this.detachAll();return this;},_defInitFn:function(L){this._initHierarchy(L.cfg);if(this._initPlugins){this._initPlugins(L.cfg);}this._set(Q,true);},_defDestroyFn:function(L){this._destroyHierarchy();if(this._destroyPlugins){this._destroyPlugins();}this._set(H,true);},_getClasses:function(){if(!this._classes){this._initHierarchyData();}return this._classes;},_getAttrCfgs:function(){if(!this._attrs){this._initHierarchyData();}return this._attrs;},_filterAttrCfgs:function(V,O){var T=null,L,U=V.ATTRS;if(U){for(L in U){if(U.hasOwnProperty(L)&&O[L]){T=T||{};T[L]=O[L];delete O[L];}}}return T;},_initHierarchyData:function(){var T=this.constructor,O=[],L=[];while(T){O[O.length]=T;if(T.ATTRS){L[L.length]=T.ATTRS;}T=T.superclass?T.superclass.constructor:null;}this._classes=O;this._attrs=this._aggregateAttrs(L);},_aggregateAttrs:function(Y){var V,Z,U,L,a,O,X,T=F._ATTR_CFG,W={};if(Y){for(O=Y.length-1;O>=0;--O){Z=Y[O];for(V in Z){if(Z.hasOwnProperty(V)){U=B.mix({},Z[V],true,T);L=U.value;X=U.cloneDefaultValue;if(L){if((X===undefined&&(C===L.constructor||K.isArray(L)))||X===M||X===true){U.value=B.clone(L);}else{if(X===S){U.value=B.merge(L);}}}a=null;if(V.indexOf(J)!==-1){a=V.split(J);V=a.shift();}if(a&&W[V]&&W[V].value){I.setValue(W[V].value,a,L);}else{if(!a){if(!W[V]){W[V]=U;}else{B.mix(W[V],U,true,T);}}}}}}}return W;},_initHierarchy:function(W){var T=this._lazyAddAttrs,X,Y,Z,U,O,V=this._getClasses(),L=this._getAttrCfgs();for(Z=V.length-1;Z>=0;Z--){X=V[Z];Y=X.prototype;if(X._yuibuild&&X._yuibuild.exts){for(U=0,O=X._yuibuild.exts.length;U<O;U++){X._yuibuild.exts[U].apply(this,arguments);}}this.addAttrs(this._filterAttrCfgs(X,L),W,T);if(Y.hasOwnProperty(D)){Y.initializer.apply(this,arguments);}}},_destroyHierarchy:function(){var V,O,U,L,T=this._getClasses();for(U=0,L=T.length;U<L;U++){V=T[U];O=V.prototype;if(O.hasOwnProperty(P)){O.destructor.apply(this,arguments);}}},toString:function(){return this.constructor.NAME+"["+B.stamp(this)+"]";}};B.mix(F,A,false,null,1);F.prototype.constructor=F;B.Base=F;},"3.2.0",{requires:["attribute-base"]});YUI.add("base-pluginhost",function(C){var A=C.Base,B=C.Plugin.Host;C.mix(A,B,false,null,1);A.plug=B.plug;A.unplug=B.unplug;},"3.2.0",{requires:["base-base","pluginhost"]});YUI.add("base-build",function(D){var B=D.Base,A=D.Lang,C;B._build=function(F,L,P,T,S,O){var U=B._build,G=U._ctor(L,O),J=U._cfg(L,O),R=U._mixCust,N=J.aggregates,E=J.custom,I=G._yuibuild.dynamic,M,K,H,Q;if(I&&N){for(M=0,K=N.length;M<K;++M){H=N[M];if(L.hasOwnProperty(H)){G[H]=A.isArray(L[H])?[]:{};}}}for(M=0,K=P.length;M<K;M++){Q=P[M];D.mix(G,Q,true,null,1);R(G,Q,N,E);G._yuibuild.exts.push(Q);}if(T){D.mix(G.prototype,T,true);}if(S){D.mix(G,U._clean(S,N,E),true);R(G,S,N,E);}G.prototype.hasImpl=U._impl;if(I){G.NAME=F;G.prototype.constructor=G;}return G;};C=B._build;D.mix(C,{_mixCust:function(G,F,I,H){if(I){D.aggregate(G,F,true,I);}if(H){for(var E in H){if(H.hasOwnProperty(E)){H[E](E,G,F);}}}},_tmpl:function(E){function F(){F.superclass.constructor.apply(this,arguments);}D.extend(F,E);return F;},_impl:function(H){var K=this._getClasses(),J,F,E,I,L,G;for(J=0,F=K.length;J<F;J++){E=K[J];if(E._yuibuild){I=E._yuibuild.exts;L=I.length;for(G=0;G<L;G++){if(I[G]===H){return true;}}}}return false;},_ctor:function(E,F){var G=(F&&false===F.dynamic)?false:true,H=(G)?C._tmpl(E):E;H._yuibuild={id:null,exts:[],dynamic:G};return H;},_cfg:function(E,F){var G=[],J={},I,H=(F&&F.aggregates),L=(F&&F.custom),K=E;while(K&&K.prototype){I=K._buildCfg;if(I){if(I.aggregates){G=G.concat(I.aggregates);}if(I.custom){D.mix(J,I.custom,true);}}K=K.superclass?K.superclass.constructor:null;}if(H){G=G.concat(H);}if(L){D.mix(J,F.cfgBuild,true);}return{aggregates:G,custom:J};},_clean:function(K,J,G){var I,F,E,H=D.merge(K);for(I in G){if(H.hasOwnProperty(I)){delete H[I];}}for(F=0,E=J.length;F<E;F++){I=J[F];if(H.hasOwnProperty(I)){delete H[I];}}return H;}});B.build=function(G,E,H,F){return C(G,E,H,null,null,F);};B.create=function(E,H,G,F,I){return C(E,H,G,F,I);};B.mix=function(E,F){return C(null,E,F,null,null,{dynamic:false});};B._buildCfg={custom:{ATTRS:function(J,H,F){H.ATTRS=H.ATTRS||{};if(F.ATTRS){var G=F.ATTRS,I=H.ATTRS,E;for(E in G){if(G.hasOwnProperty(E)){I[E]=I[E]||{};D.mix(I[E],G[E],true);}}}}},aggregates:["_PLUG","_UNPLUG"]};},"3.2.0",{requires:["base-base"]});YUI.add("base",function(A){},"3.2.0",{use:["base-base","base-pluginhost","base-build"]});/*
Copyright (c) 2010, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/yui/license.html
version: 3.2.0
build: 2676
*/
YUI.add("event-synthetic",function(b){var h=b.Env.evt.dom_map,d=b.Array,g=b.Lang,j=g.isObject,c=g.isString,e=b.Selector.query,i=function(){};function f(l,k){this.handle=l;this.emitFacade=k;}f.prototype.fire=function(q){var k=d(arguments,0,true),o=this.handle,p=o.evt,m=o.sub,r=m.context,l=m.filter,n=q||{};if(this.emitFacade){if(!q||!q.preventDefault){n=p._getFacade();if(j(q)&&!q.preventDefault){b.mix(n,q,true);k[0]=n;}else{k.unshift(n);}}n.type=p.type;n.details=k.slice();if(l){n.container=p.host;}}else{if(l&&j(q)&&q.currentTarget){k.shift();}}m.context=r||n.currentTarget||p.host;p.fire.apply(p,k);m.context=r;};function a(){this._init.apply(this,arguments);}b.mix(a,{Notifier:f,getRegistry:function(q,p,n){var o=q._node,m=b.stamp(o),l="event:"+m+p+"_synth",k=h[m]||(h[m]={});if(!k[l]&&n){k[l]={type:"_synth",fn:i,capture:false,el:o,key:l,domkey:m,notifiers:[],detachAll:function(){var r=this.notifiers,s=r.length;while(--s>=0){r[s].detach();}}};}return(k[l])?k[l].notifiers:null;},_deleteSub:function(l){if(l&&l.fn){var k=this.eventDef,m=(l.filter)?"detachDelegate":"detach";this.subscribers={};this.subCount=0;k[m](l.node,l,this.notifier,l.filter);k._unregisterSub(l);delete l.fn;delete l.node;delete l.context;}},prototype:{constructor:a,_init:function(){var k=this.publishConfig||(this.publishConfig={});this.emitFacade=("emitFacade" in k)?k.emitFacade:true;k.emitFacade=false;},processArgs:i,on:i,detach:i,delegate:i,detachDelegate:i,_on:function(m,o){var n=[],k=m[2],q=o?"delegate":"on",l,p;l=(c(k))?e(k):d(k);if(!l.length&&c(k)){p=b.on("available",function(){b.mix(p,b[q].apply(b,m),true);},k);return p;}b.each(l,function(t){var u=m.slice(),r,s;t=b.one(t);if(t){r=this.processArgs(u,o);if(o){s=u.splice(3,1)[0];}u.splice(0,4,u[1],u[3]);if(!this.preventDups||!this.getSubs(t,m,null,true)){p=this._getNotifier(t,u,r,s);this[q](t,p.sub,p.notifier,s);n.push(p);}}},this);return(n.length===1)?n[0]:new b.EventHandle(n);},_getNotifier:function(n,q,o,m){var s=new b.CustomEvent(this.type,this.publishConfig),p=s.on.apply(s,q),r=new f(p,this.emitFacade),l=a.getRegistry(n,this.type,true),k=p.sub;p.notifier=r;k.node=n;k.filter=m;k._extra=o;b.mix(s,{eventDef:this,notifier:r,host:n,currentTarget:n,target:n,el:n._node,_delete:a._deleteSub},true);l.push(p);return p;},_unregisterSub:function(m){var k=a.getRegistry(m.node,this.type),l;if(k){for(l=k.length-1;l>=0;--l){if(k[l].sub===m){k.splice(l,1);break;}}}},_detach:function(m){var r=m[2],p=(c(r))?e(r):d(r),q,o,k,n,l;m.splice(2,1);for(o=0,k=p.length;o<k;++o){q=b.one(p[o]);if(q){n=this.getSubs(q,m);if(n){for(l=n.length-1;l>=0;--l){n[l].detach();}}}}},getSubs:function(l,q,k,n){var r=a.getRegistry(l,this.type),s=[],m,p,o;if(r){if(!k){k=this.subMatch;}for(m=0,p=r.length;m<p;++m){o=r[m];if(k.call(this,o.sub,q)){if(n){return o;}else{s.push(r[m]);}}}}return s.length&&s;},subMatch:function(l,k){return !k[1]||l.fn===k[1];}}},true);b.SyntheticEvent=a;b.Event.define=function(m,l,o){if(!l){l={};}var n=(j(m))?m:b.merge({type:m},l),p,k;if(o||!b.Node.DOM_EVENTS[n.type]){p=function(){a.apply(this,arguments);};b.extend(p,a,n);k=new p();m=k.type;b.Node.DOM_EVENTS[m]=b.Env.evt.plugins[m]={eventDef:k,on:function(){return k._on(d(arguments));},delegate:function(){return k._on(d(arguments),true);},detach:function(){return k._detach(d(arguments));}};}return k;};},"3.2.0",{requires:["node-base","event-custom"]});/*
Copyright (c) 2010, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/yui/license.html
version: 3.2.0
build: 2676
*/
YUI.add("event-mouseenter",function(c){function b(h,d){var g=h.currentTarget,f=h.relatedTarget;if(g!==f&&!g.contains(f)){d.fire(h);}}var a={proxyType:"mouseover",on:function(f,d,e){d.onHandle=f.on(this.proxyType,b,null,e);},detach:function(e,d){d.onHandle.detach();},delegate:function(g,e,f,d){e.delegateHandle=c.delegate(this.proxyType,b,g,d,null,f);},detachDelegate:function(e,d){d.delegateHandle.detach();}};c.Event.define("mouseenter",a,true);c.Event.define("mouseleave",c.merge(a,{proxyType:"mouseout"}),true);},"3.2.0",{requires:["event-synthetic"]});/*
Copyright (c) 2010, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/yui/license.html
version: 3.2.0
build: 2676
*/
YUI.add("event-resize",function(a){(function(){var c,b,e="window:resize",d=function(f){if(a.UA.gecko){a.fire(e,f);}else{if(b){b.cancel();}b=a.later(a.config.windowResizeDelay||40,a,function(){a.fire(e,f);});}};a.Env.evt.plugins.windowresize={on:function(h,g){if(!c){c=a.Event._attach(["resize",d]);}var f=a.Array(arguments,0,true);f[0]=e;return a.on.apply(a,f);}};})();},"3.2.0",{requires:["node-base"]});YUI.add('moodle-block_navigation-navigation', function(Y){

/**
 * A 'actionkey' Event to help with Y.delegate().
 * The event consists of the left arrow, right arrow, enter and space keys.
 * More keys can be mapped to action meanings.
 * actions: collapse , expand, toggle, enter.
 *
 * This event is delegated to branches in the navigation tree.
 * The on() method to subscribe allows specifying the desired trigger actions as JSON.
 *
 * Todo: This could be centralised, a similar Event is defined in blocks/dock.js
 */
Y.Event.define("actionkey", {
   // Webkit and IE repeat keydown when you hold down arrow keys.
    // Opera links keypress to page scroll; others keydown.
    // Firefox prevents page scroll via preventDefault() on either
    // keydown or keypress.
    _event: (Y.UA.webkit || Y.UA.ie) ? 'keydown' : 'keypress',

    _keys: {
        //arrows
        '37': 'collapse',
        '39': 'expand',
        //(@todo: lrt/rtl/M.core_dock.cfg.orientation decision to assign arrow to meanings)
        '32': 'toggle',
        '13': 'enter'
    },

    _keyHandler: function (e, notifier, args) {
        if (!args.actions) {
            var actObj = {collapse:true, expand:true, toggle:true, enter:true};
        } else {
            var actObj = args.actions;
        }
        if (this._keys[e.keyCode] && actObj[this._keys[e.keyCode]]) {
            e.action = this._keys[e.keyCode];
            notifier.fire(e);
        }
    },

    on: function (node, sub, notifier) {
        // subscribe to _event and ask keyHandler to handle with given args[0] (the desired actions).
        if (sub.args == null) {
            //no actions given
            sub._detacher = node.on(this._event, this._keyHandler,this, notifier, {actions:false});
        } else {
            sub._detacher = node.on(this._event, this._keyHandler,this, notifier, sub.args[0]);
        }
    },

    detach: function (node, sub, notifier) {
        //detach our _detacher handle of the subscription made in on()
        sub._detacher.detach();
    },

    delegate: function (node, sub, notifier, filter) {
        // subscribe to _event and ask keyHandler to handle with given args[0] (the desired actions).
        if (sub.args == null) {
            //no actions given
            sub._delegateDetacher = node.delegate(this._event, this._keyHandler,filter, this, notifier, {actions:false});
        } else {
            sub._delegateDetacher = node.delegate(this._event, this._keyHandler,filter, this, notifier, sub.args[0]);
        }
    },

    detachDelegate: function (node, sub, notifier) {
        sub._delegateDetacher.detach();
    }
});

var EXPANSIONLIMIT_EVERYTHING = 0,
    EXPANSIONLIMIT_COURSE     = 20,
    EXPANSIONLIMIT_SECTION    = 30,
    EXPANSIONLIMIT_ACTIVITY   = 40;


/**
 * Navigation tree class.
 *
 * This class establishes the tree initially, creating expandable branches as
 * required, and delegating the expand/collapse event.
 */
var TREE = function(config) {
    TREE.superclass.constructor.apply(this, arguments);
}
TREE.prototype = {
    /**
     * The tree's ID, normally its block instance id.
     */
    id : null,
    /**
     * Initialise the tree object when its first created.
     */
    initializer : function(config) {
        this.id = config.id;

        var node = Y.one('#inst'+config.id);

        // Can't find the block instance within the page
        if (node === null) {
            return;
        }

        // Delegate event to toggle expansion
        var self = this;
        Y.delegate('click', function(e){self.toggleExpansion(e);}, node.one('.block_tree'), '.tree_item.branch');
        Y.delegate('actionkey', function(e){self.toggleExpansion(e);}, node.one('.block_tree'), '.tree_item.branch');

        // Gather the expandable branches ready for initialisation.
        var expansions = [];
        if (config.expansions) {
            expansions = config.expansions;
        } else if (window['navtreeexpansions'+config.id]) {
            expansions = window['navtreeexpansions'+config.id];
        }
        // Establish each expandable branch as a tree branch.
        for (var i in expansions) {
            new BRANCH({
                tree:this,
                branchobj:expansions[i],
                overrides : {
                    expandable : true,
                    children : [],
                    haschildren : true
                }
            }).wire();
            M.block_navigation.expandablebranchcount++;
        }

        // Call the generic blocks init method to add all the generic stuff
        if (this.get('candock')) {
            this.initialise_block(Y, node);
        }
    },
    /**
     * This is a callback function responsible for expanding and collapsing the
     * branches of the tree. It is delegated to rather than multiple event handles.
     */
    toggleExpansion : function(e) {
        // First check if they managed to click on the li iteslf, then find the closest
        // LI ancestor and use that

        if (e.target.test('a') && (e.keyCode == 0 || e.keyCode == 13)) {
            // A link has been clicked (or keypress is 'enter') don't fire any more events just do the default.
            e.stopPropagation();
            return;
        }

        // Makes sure we can get to the LI containing the branch.
        var target = e.target;
        if (!target.test('li')) {
            target = target.ancestor('li')
        }
        if (!target) {
            return;
        }

        // Toggle expand/collapse providing its not a root level branch.
        if (!target.hasClass('depth_1')) {
            if (e.type == 'actionkey') {
                switch (e.action) {
                    case 'expand' :
                        target.removeClass('collapsed');
                        break;
                    case 'collapse' :
                        target.addClass('collapsed');
                        break;
                    default :
                        target.toggleClass('collapsed');
                }
                e.halt();
            } else {
                target.toggleClass('collapsed');
            }
        }

        // If the accordian feature has been enabled collapse all siblings.
        if (this.get('accordian')) {
            target.siblings('li').each(function(){
                if (this.get('id') !== target.get('id') && !this.hasClass('collapsed')) {
                    this.addClass('collapsed');
                }
            });
        }

        // If this block can dock tell the dock to resize if required and check
        // the width on the dock panel in case it is presently in use.
        if (this.get('candock')) {
            M.core_dock.resize();
            var panel = M.core_dock.getPanel();
            if (panel.visible) {
                panel.correctWidth();
            }
        }
    }
}
// The tree extends the YUI base foundation.
Y.extend(TREE, Y.Base, TREE.prototype, {
    NAME : 'navigation-tree',
    ATTRS : {
        instance : {
            value : null
        },
        candock : {
            validator : Y.Lang.isBool,
            value : false
        },
        accordian : {
            validator : Y.Lang.isBool,
            value : false
        },
        expansionlimit : {
            value : 0,
            setter : function(val) {
                return parseInt(val);
            }
        }
    }
});
if (M.core_dock && M.core_dock.genericblock) {
    Y.augment(TREE, M.core_dock.genericblock);
}

/**
 * The tree branch class.
 * This class is used to manage a tree branch, in particular its ability to load
 * its contents by AJAX.
 */
var BRANCH = function(config) {
    BRANCH.superclass.constructor.apply(this, arguments);
}
BRANCH.prototype = {
    /**
     * The node for this branch (p)
     */
    node : null,
    /**
     * A reference to the ajax load event handlers when created.
     */
    event_ajaxload : null,
    event_ajaxload_actionkey : null,
    /**
     * Initialises the branch when it is first created.
     */
    initializer : function(config) {
        if (config.branchobj !== null) {
            // Construct from the provided xml
            for (var i in config.branchobj) {
                this.set(i, config.branchobj[i]);
            }
            var children = this.get('children');
            this.set('haschildren', (children.length > 0));
        }
        if (config.overrides !== null) {
            // Construct from the provided xml
            for (var i in config.overrides) {
                this.set(i, config.overrides[i]);
            }
        }
        // Get the node for this branch
        this.node = Y.one('#', this.get('id'));
        // Now check whether the branch is not expandable because of the expansionlimit
        var expansionlimit = this.get('tree').get('expansionlimit');
        var type = this.get('type');
        if (expansionlimit != EXPANSIONLIMIT_EVERYTHING &&  type >= expansionlimit && type <= EXPANSIONLIMIT_ACTIVITY) {
            this.set('expandable', false);
            this.set('haschildren', false);
        }
    },
    /**
     * Draws the branch within the tree.
     *
     * This function creates a DOM structure for the branch and then injects
     * it into the navigation tree at the correct point.
     */
    draw : function(element) {

        var isbranch = (this.get('expandable') || this.get('haschildren'));
        var branchli = Y.Node.create('<li></li>');
        var link = this.get('link');
        var branchp = Y.Node.create('<p class="tree_item"></p>').setAttribute('id', this.get('id'));
        if (!link) {
            //add tab focus if not link (so still one focus per menu node).
            // it was suggested to have 2 foci. one for the node and one for the link in MDL-27428.
            branchp.setAttribute('tabindex', '0');
        }
        if (isbranch) {
            branchli.addClass('collapsed').addClass('contains_branch');
            branchp.addClass('branch');
        }

        // Prepare the icon, should be an object representing a pix_icon
        var branchicon = false;
        var icon = this.get('icon');
        if (icon && (!isbranch || this.get('type') == 40)) {
            branchicon = Y.Node.create('<img alt="" />');
            branchicon.setAttribute('src', M.util.image_url(icon.pix, icon.component));
            branchli.addClass('item_with_icon');
            if (icon.alt) {
                branchicon.setAttribute('alt', icon.alt);
            }
            if (icon.title) {
                branchicon.setAttribute('title', icon.title);
            }
            if (icon.classes) {
                for (var i in icon.classes) {
                    branchicon.addClass(icon.classes[i]);
                }
            }
        }

        if (!link) {
            if (branchicon) {
                branchp.appendChild(branchicon);
            }
            branchp.append(this.get('name'));
        } else {
            var branchlink = Y.Node.create('<a title="'+this.get('title')+'" href="'+link+'"></a>');
            if (branchicon) {
                branchlink.appendChild(branchicon);
            }
            branchlink.append(this.get('name'));
            if (this.get('hidden')) {
                branchlink.addClass('dimmed');
            }
            branchp.appendChild(branchlink);
        }

        branchli.appendChild(branchp);
        element.appendChild(branchli);
        this.node = branchp;
        return this;
    },
    /**
     * Attaches required events to the branch structure.
     */
    wire : function() {
        this.node = this.node || Y.one('#'+this.get('id'));
        if (!this.node) {
            return false;
        }
        if (this.get('expandable')) {
            this.event_ajaxload = this.node.on('ajaxload|click', this.ajaxLoad, this);
            this.event_ajaxload_actionkey = this.node.on('actionkey', this.ajaxLoad, this);
        }
        return this;
    },
    /**
     * Gets the UL element that children for this branch should be inserted into.
     */
    getChildrenUL : function() {
        var ul = this.node.next('ul');
        if (!ul) {
            ul = Y.Node.create('<ul></ul>');
            this.node.ancestor().append(ul);
        }
        return ul;
    },
    /**
     * Load the content of the branch via AJAX.
     *
     * This function calls ajaxProcessResponse with the result of the AJAX
     * request made here.
     */
    ajaxLoad : function(e) {
        if (e.type == 'actionkey' && e.action != 'enter') {
            e.halt();
        } else {
            e.stopPropagation();
        }
        if (e.type = 'actionkey' && e.action == 'enter' && e.target.test('A')) {
            this.event_ajaxload_actionkey.detach();
            this.event_ajaxload.detach();
            return true; // no ajaxLoad for enter
        }

        if (this.node.hasClass('loadingbranch')) {
            return true;
        }

        this.node.addClass('loadingbranch');

        var params = {
            elementid : this.get('id'),
            id : this.get('key'),
            type : this.get('type'),
            sesskey : M.cfg.sesskey,
            instance : this.get('tree').get('instance')
        };

        Y.io(M.cfg.wwwroot+'/lib/ajax/getnavbranch.php', {
            method:'POST',
            data:  build_querystring(params),
            on: {
                complete: this.ajaxProcessResponse
            },
            context:this
        });
        return true;
    },
    /**
     * Processes an AJAX request to load the content of this branch through
     * AJAX.
     */
    ajaxProcessResponse : function(tid, outcome) {
        this.node.removeClass('loadingbranch');
        this.event_ajaxload.detach();
        this.event_ajaxload_actionkey.detach();
        try {
            var object = Y.JSON.parse(outcome.responseText);
            if (object.children && object.children.length > 0) {
                var coursecount = 0;
                for (var i in object.children) {
                    if (typeof(object.children[i])=='object') {
                        if (object.children[i].type == 20) {
                            coursecount++;
                        }
                        this.addChild(object.children[i]);
                    }
                }
                if (this.get('type') == 10 && coursecount >= M.block_navigation.courselimit) {
                    this.addViewAllCoursesChild(this);
                }
                this.get('tree').toggleExpansion({target:this.node});
                return true;
            }
        } catch (ex) {
            // If we got here then there was an error parsing the result
        }
        // The branch is empty so class it accordingly
        this.node.replaceClass('branch', 'emptybranch');
        return true;
    },
    /**
     * Turns the branch object passed to the method into a proper branch object
     * and then adds it as a child of this branch.
     */
    addChild : function(branchobj) {
        // Make the new branch into an object
        var branch = new BRANCH({tree:this.get('tree'), branchobj:branchobj});
        if (branch.draw(this.getChildrenUL())) {
            branch.wire();
            var count = 0, i, children = branch.get('children');
            for (i in children) {
                // Add each branch to the tree
                if (children[i].type == 20) {
                    count++;
                }
                if (typeof(children[i])=='object') {
                    branch.addChild(children[i]);
                }
            }
            if (branch.get('type') == 10 && count >= M.block_navigation.courselimit) {
                this.addViewAllCoursesChild(branch);
            }
        }
        return true;
    },

    /**
     * Add a link to view all courses in a category
     */
    addViewAllCoursesChild: function(branch) {
        branch.addChild({
            name : M.str.moodle.viewallcourses,
            title : M.str.moodle.viewallcourses,
            link : M.cfg.wwwroot+'/course/category.php?id='+branch.get('key'),
            haschildren : false,
            icon : {'pix':"i/navigationitem",'component':'moodle'}
        });
    }
}
Y.extend(BRANCH, Y.Base, BRANCH.prototype, {
    NAME : 'navigation-branch',
    ATTRS : {
        tree : {
            validator : Y.Lang.isObject
        },
        name : {
            value : '',
            validator : Y.Lang.isString,
            setter : function(val) {
                return val.replace(/\n/g, '<br />');
            }
        },
        title : {
            value : '',
            validator : Y.Lang.isString
        },
        id : {
            value : '',
            validator : Y.Lang.isString,
            getter : function(val) {
                if (val == '') {
                    val = 'expandable_branch_'+M.block_navigation.expandablebranchcount;
                    M.block_navigation.expandablebranchcount++;
                }
                return val;
            }
        },
        key : {
            value : null
        },
        type : {
            value : null
        },
        link : {
            value : false
        },
        icon : {
            value : false,
            validator : Y.Lang.isObject
        },
        expandable : {
            value : false,
            validator : Y.Lang.isBool
        },
        hidden : {
            value : false,
            validator : Y.Lang.isBool
        },
        haschildren : {
            value : false,
            validator : Y.Lang.isBool
        },
        children : {
            value : [],
            validator : Y.Lang.isArray
        }
    }
});

/**
 * This namespace will contain all of the contents of the navigation blocks
 * global navigation and settings.
 * @namespace
 */
M.block_navigation = M.block_navigation || {
    /** The number of expandable branches in existence */
    expandablebranchcount:1,
    courselimit : 20,
    instance : null,
    /**
     * Add new instance of navigation tree to tree collection
     */
    init_add_tree:function(properties) {
        if (properties.courselimit) {
            this.courselimit = properties.courselimit;
        }
        if (M.core_dock) {
            M.core_dock.init(Y);
        }
        new TREE(properties);
    }
};

}, '@VERSION@', {requires:['base', 'core_dock', 'io', 'node', 'dom', 'event-custom', 'event-delegate', 'json-parse']});
