var pw={version:"0.2.5"};!function(){pw.util={guid:function(){return"xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g,function(t){var e=16*Math.random()|0,n="x"==t?e:3&e|8;return n.toString(16)})},dup:function(t){return JSON.parse(JSON.stringify(t))}};var t=[];pw.init={register:function(e){t.push(e)}},document.addEventListener("DOMContentLoaded",function(){t.forEach(function(t){t()})});var e=["data-scope","data-prop"],i=["SELECT"],o=["AREA","BASE","BASEFONT","BR","HR","INPUT","IMG","LINK","META"];pw.node={value:function(t){return"INPUT"===t.tagName?"checkbox"===t.type?!!t.checked&&(!t.value||t.value):t.value:"TEXTAREA"===t.tagName?t.value:"SELECT"===t.tagName?t.value:t.textContent.trim()},significant:function(t,e){t===document&&(t=document.getElementsByTagName("body")[0]),void 0===e&&(e=[]);var n,i;return(n=pw.node.isSignificant(t))?(i=[],e.push([{node:n[0],type:n[1]},i])):i=e,pw.node.toA(t.children).forEach(function(t){pw.node.significant(t,i)}),e},isSignificant:function(t){var n=e.find(function(e){return t.hasAttribute(e)});return!!n&&[t,n.split("-")[1]]},mutable:function(t){pw.node.significant(t).flatten().filter(function(t){return pw.node.isMutable(t.node)}).map(function(t){return t.node})},isMutable:function(t){var e=t.tagName;return"FORM"===e||"INPUT"===e&&!t.disabled},trigger:function(t,e,n){var i=document.createEvent("Event");i.initEvent(t,!0,!0),e._evtData=n,e.dispatchEvent(i)},replaceEventListener:function(t,e,n){e.removeEventListener(t),e.addEventListener(t,n)},inForm:function(t){if("FORM"===t.tagName)return!0;var e=t.parentNode;return e&&e!==document?pw.node.inForm(e):void 0},component:function(t){if(t.getAttribute("data-ui"))return t;var e=t.parentNode;return e&&e!==document?pw.node.component(e):void 0},scope:function(t){if(t.getAttribute("data-scope"))return t;var e=t.parentNode;return e&&e!==document?pw.node.scope(e):void 0},scopeName:function(t){if(t.getAttribute("data-scope"))return t.getAttribute("data-scope");var e=t.parentNode;return e&&e!==document?pw.node.scopeName(e):void 0},prop:function(t){if(t.getAttribute("data-prop"))return t;var e=t.parentNode;return e&&e!==document?pw.node.prop(e):void 0},propName:function(t){if(t.getAttribute("data-prop"))return t.getAttribute("data-prop");var e=t.parentNode;return e&&e!==document?pw.node.propName(e):void 0},versionName:function(t){if(t.hasAttribute("data-version"))return t.getAttribute("data-version")},invoke:function(t,e){e.call(t)},invokeWithData:function(t,e,n){pw.node.isNodeList(t)&&(t=pw.node.toA(t)),t=Array.ensure(t),e=Array.ensure(e),t.forEach(function(t,i){n.call(t,e[i])})},match:function(t,e){pw.node.isNodeList(t)&&(t=pw.node.toA(t)),t=Array.ensure(t),e=Array.ensure(e);var i=e.reduce(function(t,e,i){var o=n[i]||n[n.length-1],r=o.cloneNode(!0);return o.parentNode.insertBefore(r),t.concat([r])},[]);return t.forEach(function(t){t.parentNode.removeChild(t)}),i},repeat:function(t,e,n){pw.node.invokeWithData(pw.node.match(t,e),e,n)},bind:function(t,e,n){var i=pw.node.findBindings(e)[0];pw.node.invokeWithData(e,t,function(t){t&&(t.id&&this.setAttribute("data-id",t.id),pw.node.bindDataToScope(t,i,e),"undefined"!=typeof n&&n.call(this,t))})},apply:function(t,e,n){var i=pw.node.match(e,t);return pw.node.bind(t,i,n),i},findBindings:function(t){var e=[];return pw.node.breadthFirst(t,function(){var t=this,n=t.getAttribute("data-scope");if(n){var i=[];pw.node.breadthFirst(t,function(){var e=this;if(t==e||!e.getAttribute("data-scope")){var n=e.getAttribute("data-prop");n&&i.push({prop:n,doc:e})}}),e.push({scope:n,props:i,doc:t})}}),e},bindDataToScope:function(t,e,n){t&&e&&e.props.forEach(function(e){k=e.prop,v=t[k],v||(v=""),"object"==typeof v?(pw.node.bindValueToNode(v.__content,e.doc),pw.node.bindAttributesToNode(v.__attrs,e.doc)):pw.node.bindValueToNode(v,e.doc)})},bindAttributesToNode:function(t,e){var n=pw.attrs.init(pw.view.init(e));for(var i in t){var o=t[i];"function"==typeof o&&(o=o.call(e.getAttribute(i))),o?o instanceof Array&&o[0]instanceof Array?o.forEach(function(t){n[t[0]](i,t[1])}):n.set(i,o):n.remove(i)}},bindValueToNode:function(t,e){pw.node.isTagWithoutValue(e)||("INPUT"===e.tagName&&"checkbox"===e.type?t===!0||e.value&&t===e.value?e.checked=!0:e.checked=!1:"TEXTAREA"===e.tagName||pw.node.isSelfClosingTag(e)?e.value=t:(t||""===t)&&(e.innerHTML=t))},isTagWithoutValue:function(t){return i.indexOf(t.tagName)!=-1},isSelfClosingTag:function(t){return o.indexOf(t.tagName)!=-1},breadthFirst:function(t,e){for(var n=[t];n.length>0;){var i=n.shift();if(i){"object"==typeof i&&"nodeType"in i&&1===i.nodeType&&i.cloneNode&&e.call(i);var o=i.childNodes;if(o)for(var r=0;r<o.length;r++)n.push(o[r])}}},isNodeList:function(t){return"undefined"!=typeof t.length},byAttr:function(t,e,n){return pw.node.all(t).filter(function(t){var i=t.getAttribute(e);return null!==i&&("undefined"==typeof n||i==n)})},setAttr:function(t,e,n){"style"===e?n.pairs().forEach(function(e){t.style[e[0]]=e[1]}):("class"===e&&(n=n.join(" ")),"checked"===e&&(n=n?"checked":"",t.checked=n),t.setAttribute(e,n))},all:function(t){var e=[];return t?(document!==t&&e.push(t),e.concat(pw.node.toA(t.getElementsByTagName("*")))):e},before:function(t,e){t.parentNode.insertBefore(e,t)},after:function(t,e){t.parentNode.insertBefore(e,t.nextSibling)},replace:function(t,e){t.parentNode.replaceChild(e,t)},append:function(t,e){t.appendChild(e)},prepend:function(t,e){t.insertBefore(e,t.firstChild)},remove:function(t){t.parentNode.removeChild(t)},clear:function(t){for(;t.firstChild;)pw.node.remove(t.firstChild)},title:function(t,e){var n;(n=t.getElementsByTagName("title")[0])&&(n.innerText=e)},toA:function(t){return t?Array.prototype.slice.call(t):[]},serialize:function(t){var e,n,i,o,r,a,c={};return t.querySelectorAll("input, select, textarea").forEach(function(t){e=c,i=t.name.split("["),o=i[i.length-1],i.forEach(function(i){n=pw.node.value(t),"]"==i&&(r[a]instanceof Array||(r[a]=[]),n&&r[a].push(n)),i!=o&&(n={}),i=i.replace("]",""),""!=i&&"_method"!=i&&(e[i]||(e[i]=n),r=e,a=i,e=e[i])})}),c}},pw.attrs={init:function(t){return new a(pw.collection.init(t))}};var r={hash:["style"],bool:["selected","checked","disabled","readonly","multiple"],mult:["class"]},a=function(t){this.views=t.views};a.prototype={findType:function(t){return r.hash.indexOf(t)>-1?"hash":r.bool.indexOf(t)>-1?"bool":r.mult.indexOf(t)>-1?"mult":"text"},findValue:function(t,e){switch(e){case"class":return t.node.classList;case"style":return t.node.style}return"bool"===this.findType(e)?t.node.hasAttribute(e):t.node.getAttribute(e)},set:function(t,e){this.views.forEach(function(n){pw.node.setAttr(n.node,t,e)})},remove:function(t){this.views.forEach(function(e){e.node.removeAttribute(t)})},ensure:function(t,e){this.views.forEach(function(n){var i=this.findValue(n,t);if("class"===t)i.contains(e)||i.add(e);else if("style"===t)Object.keys(e).forEach(function(t){n.node.style[t]=e[t]});else if("bool"===this.findType(t))n.node.hasAttribute(t)||pw.node.setAttr(n.node,t,t);else{var i=n.node.getAttribute(t)||"";i.match(e)||pw.node.setAttr(n.node,t,i+e)}},this)},deny:function(t,e){this.views.forEach(function(n){var i=this.findValue(n,t);"class"===t?i.contains(e)&&i.remove(e):"style"===t?Object.keys(e).forEach(function(t){n.node.style[t]=n.node.style[t].replace(e[t],"")}):"bool"===this.findType(t)?n.node.hasAttribute(t)&&n.node.removeAttribute(t):pw.node.setAttr(n.node,t,n.node.getAttribute(t).replace(e,""))},this)},insert:function(t,e){this.views.forEach(function(n){var i=this.findValue(n,t);switch(t){case"class":i.add(e);break;default:pw.node.setAttr(n.node,t,i+e)}},this)}},pw.state={build:function(t,e){var n;return t.reduce(function(t,i){return(n=pw.state.buildForNode(i,e))&&t.push(n),t},[])},buildForNode:function(t,e){var n=t[0],i={};if("scope"===n.type)i.id=n.node.getAttribute("data-id"),i.scope=n.node.getAttribute("data-scope");else if("prop"===n.type&&e)return void(e[n.node.getAttribute("data-prop")]=pw.node.value(n.node));return i.__nested=pw.state.build(t[1],i),i},init:function(t,e){return new c(t,e)}};var c=function(t){this.node=t,this.snapshots=[],this.update()};c.prototype={update:function(){this.snapshots.push(pw.state.build(pw.node.significant(this.node)))},diffNode:function(t){return t.hasAttribute("data-ui")?{__nested:pw.state.build(pw.node.significant(t))}:pw.state.build(pw.node.significant(pw.node.scope(t)))[0]},revert:function(){var t=pw.util.dup(this.snapshots[0]);return this.snapshots=[t],t},rollback:function(){return this.snapshots.pop(),this.current()},node:function(t){return this.current.flatten().find(function(e){return e.scope===t.scope&&e.id===t.id})},append:function(t){var e=this.copy();e.push(t),this.snapshots.push(e)},prepend:function(t){var e=this.copy();e.unshift(t),this.snapshots.push(e)},remove:function(t){var e=this.copy(),n=e.find(function(e){return e.id===t.id});n&&(e.splice(e.indexOf(n),1),this.snapshots.push(e))},copy:function(){return pw.util.dup(this.current())},current:function(){return this.snapshots[this.snapshots.length-1]},initial:function(){return this.snapshots[0]}},pw.view={init:function(t){return new s(t)},fromStr:function(t){var e="div";(t.match(/^<tr/)||t.match(/^<tbody/))&&(e="table");var n=document.createElement(e);return n.innerHTML=t,pw.view.init(n.childNodes[0])}};var s=function(t){this.node=t};s.prototype={clone:function(){return pw.view.init(this.node.cloneNode(!0))},title:function(t){pw.node.title(this.node,t)},text:function(t){this.node.innerText=t},html:function(t){this.node.innerHTML=t},component:function(t){return pw.collection.init(pw.node.byAttr(this.node,"data-ui",t).reduce(function(t,e){return t.concat(pw.view.init(e))},[]),this)},attrs:function(){return pw.attrs.init(this)},invoke:function(t){pw.node.invoke(this.node,t)},match:function(t){pw.node.match(this.node,t)},invokeWithData:function(t,e){pw.node.invokeWithData(this.node,t,e)},repeat:function(t,e){pw.node.repeat(this.node,t,e)},bind:function(t,e){pw.node.bind(t,this.node,e)},apply:function(t,e){pw.node.apply(t,this.node,e)},use:function(t,e){var n=this;if(this.node.getAttribute("data-version")!=t){this.node.setAttribute("data-version",t);var i={scope:pw.node.scope(this.node).getAttribute("data-scope"),version:t};window.socket.fetchView(i,function(t){t.node.setAttribute("data-channel",n.node.getAttribute("data-channel")),pw.node.replace(n.node,t.node),n.node=t.node,e()})}else e()},setEndpoint:function(t){return this.endpoint=t,this},first:function(){return this},length:function(){return 1}},["scope","prop"].forEach(function(t){s.prototype[t]=function(e){return pw.collection.init(pw.node.byAttr(this.node,"data-"+t,e).reduce(function(t,e){return t.concat(pw.view.init(e))},[]),this,e)}}),["remove","clear","versionName"].forEach(function(t){s.prototype[t]=function(){return pw.node[t](this.node)}}),["after","before","replace","append","prepend","insert"].forEach(function(t){s.prototype[t]=function(e){return pw.node[t](this.node,e.node)}}),pw.collection={init:function(t,e,n){return t instanceof u?t:(t.constructor!==Array&&(t=[t]),new u(t,e,n))},fromNodes:function(t,e,n){return pw.collection.init(t.map(function(t){return pw.view.init(t)}),e,n)}};var u=function(t,e,n){this.views=t,this.parent=e,this._scope=n};u.prototype={clone:function(){return pw.collection.init(this.views.map(function(t){return t.clone()}))},last:function(){return this.views[this.length()-1]},first:function(){return this.views[0]},removeView:function(t){var e=this.views.indexOf(t);e>-1&&this.views.splice(e,1)[0].remove()},addView:function(t){var e=[];t instanceof u?e=t.views:e.push(t),this.length()>0?e.forEach(function(t){pw.node.after(this.last().node,t.node)},this):this.parent&&e.forEach(function(t){this.parent.append(t)},this),this.views=this.views.concat(e)},order:function(t){t.forEach(function(t){if(t){var e=this.views[i],n=e.node.getAttribute("data-id");if(n&&n!=t.toString()){e.node.parentNode.appendChild(e.node);var i=this.views.indexOf(e);this.views.splice(i,1),this.views.push(e)}}},this)},length:function(){return this.views.length},attrs:function(){return pw.attrs.init(this.views)},append:function(t){t=Array.ensure(t);var e=this.last();return this.views.push(e.append(t)),e},prepend:function(t){t=Array.ensure(t);var e=t.map(function(t){var e=this.first().prepend(t);return this.views.push(e),e},this);return pw.collection.init(e)},invoke:function(t){pw.node.invoke(this.views,t)},invokeWithData:function(t,e){t=Array.ensure(t),this.views.forEach(function(n,i){e.call(n,t[i])})},match:function(t,e){if(t=Array.ensure(t),0===t.length)return this.remove(),e.call(this);var n,i;if(this.views[0]&&(n=this.views[0].clone(),i=this.views[0].node.parentNode),this.views.slice(0).forEach(function(e){var n=e.node.getAttribute("data-id");return!n&&t[0].id?void this.removeView(e):void(n&&(t.find(function(t){return t.id&&t.id.toString()===n})||this.removeView(e)))},this),!(t.length>this.length()))return e.call(this);var o=this;return this.endpoint.template(this,function(r){return r||(r=n.clone(),o.parent=pw.view.init(i)),t.forEach(function(t){if(!o.views.find(function(e){return e.node.getAttribute("data-id")===(t.id||"").toString()})){var e=r.clone();e instanceof u&&(e=e.views[0]),e.node.setAttribute("data-id",t.id),o.addView(e),pw.component.findAndInit(e.node)}},o),e.call(o)}),this},repeat:function(t,e){this.match(t,function(){this.invokeWithData(t,e)})},bind:function(t,e){return this.invokeWithData(t,function(t){this.bind(t),"undefined"!=typeof e&&e.call(this,t)}),this},apply:function(t,e){this.match(t,function(){var n;this.order(t.map(function(t){if(n=t.id)return n.toString()})),this.bind(t,e)})},version:function(t,e){this.match(t,function(){this.invokeWithData(t,e)})},setEndpoint:function(t){return this.endpoint=t,this},use:function(t,e){1==this.length()?this.views[0].use(t,e):console.log("Not sure how to call `use` on a collection with more than one view")}},["scope","prop","component"].forEach(function(t){u.prototype[t]=function(e){return pw.collection.init(this.views.reduce(function(n,i){return n.concat(i[t](e).views)},[]))}}),["remove","clear","text","html"].forEach(function(t){u.prototype[t]=function(e){this.views.forEach(function(n){n[t](e)})}}),pw.init.register(function(){pw.component.findAndInit(document.querySelectorAll("body")[0])});var d={},p={},f={},h={};pw.component={init:function(t,e){return new l(t,e)},resetChannels:function(){p={}},findAndInit:function(t){pw.node.byAttr(t,"data-ui").forEach(function(t){if(!t._ui){var e=t.getAttribute("data-ui"),n=d[e]||pw.component.init;h[e]||(h[e]=[]);var i=t.getAttribute("data-channel"),o=t.getAttribute("data-config"),r=pw.view.init(t),a=h[e].length,c=new n(r,pw.component.buildConfigObject(o),e,a);c.init(r,o,e),pw.component.registerForChannel(c,i),h[e].push(c),t._ui=!0}})},push:function(t){var e=t.channel,n=t.payload,i=n.instruct;(p[e]||[]).forEach(function(t){i?t.instruct(e,i):t.message(e,n)})},register:function(t,e){var n=l.prototype;Object.getOwnPropertyNames(n).forEach(function(t){e.prototype[t]=n[t]}),d[t]=e},buildConfigObject:function(t){return t?t.split(";").reduce(function(t,e){var n=e.trim().split(":");return t[n[0].trim()]=n[1].trim(),t},{}):{}},registerForChannel:function(t,e){p[e]||(p[e]=[]),p[e].push(t)},registerForBroadcast:function(t,e,n){f[t]||(f[t]=[]),f[t].push([e,n])},deregisterForBroadcast:function(t,e){var n=f[t],i=n.find(function(t){return t[1]==e}),o=n.indexOf(i);n.splice(o,1)},broadcast:function(t,e){(f[t]||[]).forEach(function(t){t[0].call(t[1],e)})}};var l=function(t,e,n){};l.prototype={init:function(t,e,n){var i=t.node;this.view=t,this.node=i,this.config=e,this.name=n,this.templates={};var o=this;if(pw.node.toA(i.querySelectorAll(":scope > *[data-template]")).forEach(function(t){var e=t.cloneNode(!0);pw.node.remove(t);var n=e.getAttribute("data-scope");this.templates[n]?this.templates[n].views.push(pw.view.init(e)):this.templates[n]=pw.collection.init(pw.view.init(e)),e.removeAttribute("data-template")},this),this.state=pw.state.init(this.node),this.dCb){var r=pw.node.component(this.node.parentNode);r&&(r.addEventListener("mutated",function(t){o.transform(o.dCb(t.target._evtData))}),o.transform(o.dCb(pw.state.init(r).current())))}var a=function(t){var e=pw.node.scope(t.target);e&&(t.preventDefault(),o.mutated(e))};i.addEventListener("submit",a),i.addEventListener("change",function(t){pw.node.inForm(t.target)||a(t)}),this.inited&&this.inited()},listen:function(t,e){pw.component.registerForBroadcast(t,e,this)},ignore:function(t){pw.component.deregisterForBroadcast(t,this)},bubble:function(t,e){var n=pw.node.component(this.node.parentNode);(f[t]||[]).forEach(function(t){t[1].node==n&&t[0].call(t[1],e)})},trickle:function(t,e){var n=f[t]||[];pw.node.toA(this.node.getElementsByTagName("*")).forEach(function(t){n.forEach(function(n){n[1].node==t&&n[0].call(n[1],e)})})},instruct:function(t,e){this.endpoint=pw.instruct;var n=this.state.current();if(1===n.length){var i=this.view.scope(n[0].scope),o=i.views[0].node;if("empty"===o.getAttribute("data-version")){var r=this;return void pw.instruct.template(i,function(t){var n=o.parentNode;n.replaceChild(t.node,o),e.forEach(function(t){r[t[0]](t[1])})})}}e.forEach(function(t){this[t[0]](t[1])},this)},message:function(t,e){},mutated:function(t){this.mutation(this.state.diffNode(t)),this.state.update(),pw.node.trigger("mutated",this.node,this.state.current())},mutation:function(t){},transform:function(t){this._transform(t)},_transform:function(t){t&&(t.length>0?this.view.scope(t[0].scope).setEndpoint(this.endpoint||this).apply(t):pw.node.breadthFirst(this.view.node,function(){this.hasAttribute("data-scope")&&pw.node.remove(this)}),pw.node.trigger("mutated",this.node,this.state.current()))},revert:function(){this.transform(this.state.revert())},rollback:function(){this.transform(this.state.rollback())},template:function(t,e){var n;(n=this.templates[t.scope])&&e(n)},remove:function(t){this.state.remove(t),this.transform(this.state.current())},append:function(t){this.state.append(t),this.transform(this.state.current())},prepend:function(t){this.state.prepend(t),this.transform(this.state.current())},parent:function(){var t=pw.node.scope(this.node);if(t)return pw.state.init(t).current()[0]},dependent:function(t){this.dCb=t}},pw.init.register(function(){pw.socket.init({cb:function(t){window.socket=t,pw.component.broadcast("socket:available")}})}),pw.socket={init:function(t){return pw.socket.connect(t.host,t.port,t.protocol,t.connId,t.cb)},connect:function(t,e,n,i,o){if("undefined"==typeof t&&(t=window.location.hostname),"undefined"==typeof e&&(e=window.location.port),"undefined"==typeof n&&(n=window.location.protocol),"undefined"==typeof i&&(i=document.getElementsByTagName("body")[0].getAttribute("data-socket-connection-id")),i){var r="";return"http:"===n?r+="ws://":"https:"===n&&(r+="wss://"),r+=t,e&&(r+=":"+e),r+="/?socket_connection_id="+i,new w(r,o)}}};var w=function(t,e){var n=this;this.callbacks={},this.url=t,this.initCb=e,this.ws=new WebSocket(t),this.id=t.split("socket_connection_id=")[1];var i;this.ws.onmessage=function(t){pw.component.broadcast("socket:loaded");var e=JSON.parse(t.data);if(e.id){var i=n.callbacks[e.id];if(i)return void i.call(this,e)}n.message(e)},this.ws.onclose=function(t){console.log("socket closed"),clearInterval(i),n.reconnect()},this.ws.onopen=function(t){console.log("socket open"),n.initCb&&n.initCb(n),i=setInterval(function(){n.send({action:"ping"})},3e4)}};w.prototype={send:function(t,e){pw.component.broadcast("socket:loading"),t.id=pw.util.guid(),t.input||(t.input={}),t.input.socket_connection_id=this.id,this.callbacks[t.id]=e,this.ws.send(JSON.stringify(t))},message:function(t){console.log("received message"),console.log(t);var e='*[data-channel="'+t.channel+'"]';if(t.channel&&"component"===t.channel.split(":")[0])return void pw.component.push(t);var n=pw.node.toA(document.querySelectorAll(e));0!==n.length&&pw.instruct.process(pw.collection.fromNodes(n,e),t,this)},reconnect:function(){var t=this;t.wait?t.wait*=1.25:t.wait=100,console.log("reconnecting socket in "+t.wait+"ms"),setTimeout(function(){pw.socket.init({cb:t.initCb})},t.wait)},fetchView:function(t,e){var n;if(window.location.hash){var i=window.location.hash.split("#:")[1].split("/");i.shift(),n=i.join("/")}else n=window.location.pathname+window.location.search;this.send({action:"fetch-view",lookup:t,uri:n},function(t){var n=pw.view.fromStr(t.body);n.node?(n.node.removeAttribute("data-id"),e(n)):e()})}},pw.instruct={process:function(t,e,n){1===t.length()&&"empty"===t.views[0].node.getAttribute("data-version")?pw.instruct.fetchView(e,n,t.views[0].node):pw.instruct.perform(t,e.payload)},fetchView:function(t,e,n){e.fetchView({channel:t.channel},function(e){if(e){var i=n.parentNode;i.replaceChild(e.node,n);var o='*[data-channel="'+t.channel+'"]',r=pw.node.toA(i.querySelectorAll(o));pw.instruct.perform(pw.collection.fromNodes(r,o),t.payload)}else console.log("trouble fetching view :(")})},template:function(t,e){var n={};if(!t||!t.first())return e();var i=t.first().node;if(i.hasAttribute("data-channel"))n.channel=t.first().node.getAttribute("data-channel");else{if(!i.hasAttribute("data-ui")||!i.hasAttribute("data-scope"))return void e();n.component=pw.node.component(i).getAttribute("data-ui"),n.scope=i.getAttribute("data-scope")}window.socket.fetchView(n,function(t){e(t)})},perform:function(t,e,n){function i(e,n){var i=n[0],r=n[1],c=n[2];if("with"===i&&(i="invoke"),"for"===i&&(i="invokeWithData"),!t[i])return void console.log("could not find method named: "+i);if("invoke"==i||"invokeWithData"==i||"bind"==i||"repeat"==i||"apply"==i||"version"==i){var s=t.length(),u=0,d=function(){u++,u==s&&o()};return void t.setEndpoint(a)[i].call(t,r,function(t){pw.instruct.perform(this,c[r.indexOf(t)],d)})}if("attrs"==i)return a.performAttr(t.attrs(),c),void o();if("use"==i)return t.setEndpoint(a),void t.use(r,o);var p=t[i].call(t,r);return c instanceof Array?void pw.instruct.perform(p,c,o):(p&&(t=p),void o())}function o(){c<e.length?i(t,e[c++]):r()}function r(){n?n():pw.component.findAndInit(t.node)}var a=this;e=e||[];var c=0;o()},performAttr:function(t,e){e.forEach(function(e){var n=e[0],i=e[1],o=e[2];i?t.set(n,i):t[o[0][0]](n,o[0][1])})}},Array.prototype.flatten||(Array.prototype.flatten=function(){return this.reduce(function(t,e){return t.concat(Array.isArray(e)?e.flatten():e)},[])}),Array.prototype.find||(Array.prototype.find=function(t){if(null==this)throw new TypeError("Array.prototype.find called on null or undefined");if("function"!=typeof t)throw new TypeError("predicate must be a function");for(var e,n=Object(this),i=n.length>>>0,o=arguments[1],r=0;r<i;r++)if(e=n[r],t.call(o,e,r,n))return e}),Array.ensure=function(t){return t instanceof Array?t:[t]},NodeList.prototype.forEach=Array.prototype.forEach,Object.prototype.pairs||Object.defineProperty(Object.prototype,"pairs",{value:function(){return Object.keys(this).map(function(t){return[t,this[t]]},this)},enumerable:!1}),function(t,e){try{t.querySelector(":scope body")}catch(n){["querySelector","querySelectorAll"].forEach(function(n){var i=e[n];e[n]=function(e){if(/(^|,)\s*:scope/.test(e)){var o=this.id;this.id="ID_"+Date.now(),e=e.replace(/((^|,)\s*):scope/g,"$1#"+this.id);var r=t[n](e);return this.id=o,r}return i.call(this,e)}})}}(window.document,Element.prototype),"function"==typeof define&&define.amd?define(pw):"object"==typeof module&&module.exports?module.exports=pw:this.pw=pw}();
