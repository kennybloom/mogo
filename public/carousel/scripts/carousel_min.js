/**
 * Copyright (c) 2006-2007, Bill W. Scott. All rights reserved.
 * This work is licensed under the Creative Commons Attribution 2.5 License. To view a copy 
 * of this license, visit http://creativecommons.org/licenses/by/2.5/ or send a letter to 
 * Creative Commons, 543 Howard Street, 5th Floor, San Francisco, California, 94105, USA.
 * This work was created by Bill Scott (billwscott.com, looksgoodworkswell.com).
 * The only attribution I require is to keep this notice of copyright & license 
 * in this original source file.
 * Version 0.5.1 - 06.03.2007
 */


YAHOO.namespace("extension");YAHOO.extension.Carousel=function(carouselElementID,carouselCfg){this.init(carouselElementID,carouselCfg);};YAHOO.extension.Carousel.prototype={UNBOUNDED_SIZE:1000000,init:function(carouselElementID,carouselCfg){var oThis=this;this.getCarouselItem=this.getItem;var carouselListClass="carousel-list";var carouselClipRegionClass="carousel-clip-region";var carouselNextClass="carousel-next";var carouselPrevClass="carousel-prev";this.carouselElemID=carouselElementID;this.carouselElem=YAHOO.util.Dom.get(carouselElementID);this.prevEnabled=true;this.nextEnabled=true;this.cfg=new YAHOO.util.Config(this);this.cfg.addProperty("orientation",{value:"horizontal",handler:function(type,args,carouselElem){oThis.orientation=args[0];oThis.reload();},validator:function(orientation){if(typeof orientation=="string"){return("horizontal,vertical".indexOf(orientation.toLowerCase())!=-1);}else{return false;}}});this.cfg.addProperty("size",{value:this.UNBOUNDED_SIZE,handler:function(type,args,carouselElem){oThis.size=args[0];oThis.reload();},validator:oThis.cfg.checkNumber});this.cfg.addProperty("numVisible",{value:3,handler:function(type,args,carouselElem){oThis.numVisible=args[0];oThis.load();},validator:oThis.cfg.checkNumber});this.cfg.addProperty("firstVisible",{value:1,handler:function(type,args,carouselElem){oThis.moveTo(args[0]);},validator:oThis.cfg.checkNumber});this.cfg.addProperty("scrollInc",{value:3,handler:function(type,args,carouselElem){oThis.scrollInc=args[0];},validator:oThis.cfg.checkNumber});this.cfg.addProperty("animationSpeed",{value:0.25,handler:function(type,args,carouselElem){oThis.animationSpeed=args[0];},validator:oThis.cfg.checkNumber});this.cfg.addProperty("animationMethod",{value:YAHOO.util.Easing.easeOut,handler:function(type,args,carouselElem){oThis.animationMethod=args[0];}});this.cfg.addProperty("animationCompleteHandler",{value:null,handler:function(type,args,carouselElem){if(oThis.animationCompleteEvt){oThis.animationCompleteEvt.unsubscribe(oThis.animationCompleteHandler,oThis);}
oThis.animationCompleteHandler=args[0];if(oThis._isValidObj(oThis.animationCompleteHandler)){oThis.animationCompleteEvt=new YAHOO.util.CustomEvent("onAnimationComplete",oThis);oThis.animationCompleteEvt.subscribe(oThis.animationCompleteHandler,oThis);}}});this.cfg.addProperty("autoPlay",{value:0,handler:function(type,args,carouselElem){oThis.autoPlay=args[0];if(oThis.autoPlay>0)
oThis.startAutoPlay();else
oThis.stopAutoPlay();}});this.cfg.addProperty("wrap",{value:false,handler:function(type,args,carouselElem){oThis.wrap=args[0];},validator:oThis.cfg.checkBoolean});this.cfg.addProperty("navMargin",{value:0,handler:function(type,args,carouselElem){oThis.navMargin=args[0];},validator:oThis.cfg.checkNumber});this.cfg.addProperty("prevElementID",{value:null,handler:function(type,args,carouselElem){if(oThis.carouselPrev){YAHOO.util.Event.removeListener(oThis.carouselPrev,"click",oThis._scrollPrev);}
oThis.prevElementID=args[0];if(oThis.prevElementID==null){oThis.carouselPrev=YAHOO.util.Dom.getElementsByClassName(carouselPrevClass,"div",oThis.carouselElem)[0];}else{oThis.carouselPrev=YAHOO.util.Dom.get(oThis.prevElementID);}
YAHOO.util.Event.addListener(oThis.carouselPrev,"click",oThis._scrollPrev,oThis);}});this.cfg.addProperty("prevElement",{value:null,handler:function(type,args,carouselElem){if(oThis.carouselPrev){YAHOO.util.Event.removeListener(oThis.carouselPrev,"click",oThis._scrollPrev);}
oThis.prevElementID=args[0];if(oThis.prevElementID==null){oThis.carouselPrev=YAHOO.util.Dom.getElementsByClassName(carouselPrevClass,"div",oThis.carouselElem)[0];}else{oThis.carouselPrev=YAHOO.util.Dom.get(oThis.prevElementID);}
YAHOO.util.Event.addListener(oThis.carouselPrev,"click",oThis._scrollPrev,oThis);}});this.cfg.addProperty("nextElementID",{value:null,handler:function(type,args,carouselElem){if(oThis.carouselNext){YAHOO.util.Event.removeListener(oThis.carouselNext,"click",oThis._scrollNext);}
oThis.nextElementID=args[0];if(oThis.nextElementID==null){oThis.carouselNext=YAHOO.util.Dom.getElementsByClassName(carouselNextClass,"div",oThis.carouselElem);}else{oThis.carouselNext=YAHOO.util.Dom.get(oThis.nextElementID);}
if(oThis.carouselNext){YAHOO.util.Event.addListener(oThis.carouselNext,"click",oThis._scrollNext,oThis);}}});this.cfg.addProperty("nextElement",{value:null,handler:function(type,args,carouselElem){if(oThis.carouselNext){YAHOO.util.Event.removeListener(oThis.carouselNext,"click",oThis._scrollNext);}
oThis.nextElementID=args[0];if(oThis.nextElementID==null){oThis.carouselNext=YAHOO.util.Dom.getElementsByClassName(carouselNextClass,"div",oThis.carouselElem);}else{oThis.carouselNext=YAHOO.util.Dom.get(oThis.nextElementID);}
if(oThis.carouselNext){YAHOO.util.Event.addListener(oThis.carouselNext,"click",oThis._scrollNext,oThis);}}});this.cfg.addProperty("loadInitHandler",{value:null,handler:function(type,args,carouselElem){if(oThis.loadInitHandlerEvt){oThis.loadInitHandlerEvt.unsubscribe(oThis.loadInitHandler,oThis);}
oThis.loadInitHandler=args[0];if(oThis.loadInitHandlerEvt){oThis.loadInitHandlerEvt=new YAHOO.util.CustomEvent("onLoadInit",oThis);oThis.loadInitHandlerEvt.subscribe(oThis.loadInitHandler,oThis);}}});this.cfg.addProperty("loadNextHandler",{value:null,handler:function(type,args,carouselElem){if(oThis.loadNextHandlerEvt){oThis.loadNextHandlerEvt.unsubscribe(oThis.loadNextHandler,oThis);}
oThis.loadNextHandler=args[0];if(oThis.loadNextHandlerEvt){oThis.loadNextHandlerEvt=new YAHOO.util.CustomEvent("onLoadNext",oThis);oThis.loadNextHandlerEvt.subscribe(oThis.loadNextHandler,oThis);}}});this.cfg.addProperty("loadPrevHandler",{value:null,handler:function(type,args,carouselElem){if(oThis.loadPrevHandlerEvt){oThis.loadPrevHandlerEvt.unsubscribe(oThis.loadPrevHandler,oThis);}
oThis.loadPrevHandler=args[0];if(oThis.loadPrevHandlerEvt){oThis.loadPrevHandlerEvt=new YAHOO.util.CustomEvent("onLoadPrev",oThis);oThis.loadPrevHandlerEvt.subscribe(oThis.loadPrevHandler,oThis);}}});this.cfg.addProperty("prevButtonStateHandler",{value:null,handler:function(type,args,carouselElem){if(oThis.prevButtonStateHandler){oThis.prevButtonStateHandlerEvt.unsubscribe(oThis.prevButtonStateHandler,oThis);}
oThis.prevButtonStateHandler=args[0];if(oThis.prevButtonStateHandler){oThis.prevButtonStateHandlerEvt=new YAHOO.util.CustomEvent("onPrevButtonStateChange",oThis);oThis.prevButtonStateHandlerEvt.subscribe(oThis.prevButtonStateHandler,oThis);}}});this.cfg.addProperty("nextButtonStateHandler",{value:null,handler:function(type,args,carouselElem){if(oThis.nextButtonStateHandler){oThis.nextButtonStateHandlerEvt.unsubscribe(oThis.nextButtonStateHandler,oThis);}
oThis.nextButtonStateHandler=args[0];if(oThis.nextButtonStateHandler){oThis.nextButtonStateHandlerEvt=new YAHOO.util.CustomEvent("onNextButtonStateChange",oThis);oThis.nextButtonStateHandlerEvt.subscribe(oThis.nextButtonStateHandler,oThis);}}});if(carouselCfg){this.cfg.applyConfig(carouselCfg);}
this.scrollInc=this.cfg.getProperty("scrollInc");this.navMargin=this.cfg.getProperty("navMargin");this.loadInitHandler=this.cfg.getProperty("loadInitHandler");this.loadNextHandler=this.cfg.getProperty("loadNextHandler");this.loadPrevHandler=this.cfg.getProperty("loadPrevHandler");this.prevButtonStateHandler=this.cfg.getProperty("prevButtonStateHandler");this.nextButtonStateHandler=this.cfg.getProperty("nextButtonStateHandler");this.animationCompleteHandler=this.cfg.getProperty("animationCompleteHandler");this.size=this.cfg.getProperty("size");this.wrap=this.cfg.getProperty("wrap");this.animationMethod=this.cfg.getProperty("animationMethod");this.orientation=this.cfg.getProperty("orientation");this.nextElementID=this.cfg.getProperty("nextElementID");if(!this.nextElementID)
this.nextElementID=this.cfg.getProperty("nextElement");this.prevElementID=this.cfg.getProperty("prevElementID");if(!this.prevElementID)
this.prevElementID=this.cfg.getProperty("prevElement");this.autoPlay=this.cfg.getProperty("autoPlay");this.autoPlayTimer=null;this.numVisible=this.cfg.getProperty("numVisible");this.firstVisible=this.cfg.getProperty("firstVisible");this.priorFirstVisible=this.firstVisible;this.lastVisible=this.firstVisible;this.lastPrebuiltIdx=0;this.currSize=0;this.carouselList=YAHOO.util.Dom.getElementsByClassName(carouselListClass,"ul",this.carouselElem)[0];if(this.nextElementID==null){this.carouselNext=YAHOO.util.Dom.getElementsByClassName(carouselNextClass,"div",this.carouselElem)[0];}else{this.carouselNext=YAHOO.util.Dom.get(this.nextElementID);}
if(this.prevElementID==null){this.carouselPrev=YAHOO.util.Dom.getElementsByClassName(carouselPrevClass,"div",this.carouselElem)[0];}else{this.carouselPrev=YAHOO.util.Dom.get(this.prevElementID);}
this.clipReg=YAHOO.util.Dom.getElementsByClassName(carouselClipRegionClass,"div",this.carouselElem)[0];if(this.isVertical()){YAHOO.util.Dom.addClass(this.carouselList,"carousel-vertical");}
this.scrollNextAnim=new YAHOO.util.Motion(this.carouselList,this.scrollNextParams,this.cfg.getProperty("animationSpeed"),this.animationMethod);this.scrollPrevAnim=new YAHOO.util.Motion(this.carouselList,this.scrollPrevParams,this.cfg.getProperty("animationSpeed"),this.animationMethod);if(this.carouselNext){YAHOO.util.Event.addListener(this.carouselNext,"click",this._scrollNext,this);}
if(this.carouselPrev){YAHOO.util.Event.addListener(this.carouselPrev,"click",this._scrollPrev,this);}
if(this.loadInitHandler){this.loadInitHandlerEvt=new YAHOO.util.CustomEvent("onLoadInit",this);this.loadInitHandlerEvt.subscribe(this.loadInitHandler,this);}
if(this.loadNextHandler){this.loadNextHandlerEvt=new YAHOO.util.CustomEvent("onLoadNext",this);this.loadNextHandlerEvt.subscribe(this.loadNextHandler,this);}
if(this.loadPrevHandler){this.loadPrevHandlerEvt=new YAHOO.util.CustomEvent("onLoadPrev",this);this.loadPrevHandlerEvt.subscribe(this.loadPrevHandler,this);}
if(this.animationCompleteHandler){this.animationCompleteEvt=new YAHOO.util.CustomEvent("onAnimationComplete",this);this.animationCompleteEvt.subscribe(this.animationCompleteHandler,this);}
if(this.prevButtonStateHandler){this.prevButtonStateHandlerEvt=new YAHOO.util.CustomEvent("onPrevButtonStateChange",this);this.prevButtonStateHandlerEvt.subscribe(this.prevButtonStateHandler,this);}
if(this.nextButtonStateHandler){this.nextButtonStateHandlerEvt=new YAHOO.util.CustomEvent("onNextButtonStateChange",this);this.nextButtonStateHandlerEvt.subscribe(this.nextButtonStateHandler,this);}
YAHOO.util.Event.onAvailable(this.carouselElemID+"-item-1",this._calculateSize,this);this._loadInitial();},clear:function(){this.moveTo(1);this._removeChildrenFromNode(this.carouselList);this.stopAutoPlay();this.priorFirstVisible=this.firstVisible=1;this.lastVisible=1;this.lastPrebuiltIdx=0;this.currSize=0;this.size=this.cfg.getProperty("size");},reload:function(numVisible){if(this._isValidObj(numVisible)){this.numVisible=numVisible;}
this.clear();YAHOO.util.Event.onAvailable(this.carouselElemID+"-item-1",this._calculateSize,this);this._loadInitial();},load:function(){YAHOO.util.Event.onAvailable(this.carouselElemID+"-item-1",this._calculateSize,this);this._loadInitial();},addItem:function(idx,innerHTMLOrElem,itemClass){var liElem=this.getItem(idx);if(!this._isValidObj(liElem)){liElem=this._createItem(idx,innerHTMLOrElem);this.carouselList.appendChild(liElem);}else if(this._isValidObj(liElem.placeholder)){var newLiElem=this._createItem(idx,innerHTMLOrElem);this.carouselList.replaceChild(newLiElem,liElem);liElem=newLiElem;}
if(this._isValidObj(itemClass)){YAHOO.util.Dom.addClass(liElem,itemClass);}
if(this.isVertical())
setTimeout(function(){liElem.style.display="block";},1);return liElem;},insertBefore:function(refIdx,innerHTML){if(refIdx<1){refIdx=1;}
var insertionIdx=refIdx-1;if(insertionIdx>this.lastPrebuiltIdx){this._prebuildItems(this.lastPrebuiltIdx,refIdx);}
var liElem=this._insertBeforeItem(refIdx,innerHTML);if(this.firstVisible>insertionIdx||this.lastVisible<this.size){if(this.nextEnabled===false){this._enableNext();}}
return liElem;},insertAfter:function(refIdx,innerHTML){if(refIdx>this.size){refIdx=this.size;}
var insertionIdx=refIdx+1;if(insertionIdx>this.lastPrebuiltIdx){this._prebuildItems(this.lastPrebuiltIdx,insertionIdx+1);}
var liElem=this._insertAfterItem(refIdx,innerHTML);if(insertionIdx>this.size){this.size=insertionIdx;if(this.nextEnabled===false){this._enableNext();}}
if(this.firstVisible>insertionIdx||this.lastVisible<this.size){if(this.nextEnabled===false){this._enableNext();}}
return liElem;},scrollNext:function(){this._scrollNext(null,this);this.autoPlayTimer=null;if(this.autoPlay!==0){this.autoPlayTimer=this.startAutoPlay();}},scrollPrev:function(){this._scrollPrev(null,this);},scrollTo:function(newStart){this._position(newStart,true);},moveTo:function(newStart){this._position(newStart,false);},startAutoPlay:function(interval){if(this._isValidObj(interval)){this.autoPlay=interval;}
if(this.autoPlayTimer!==null){return this.autoPlayTimer;}
var oThis=this;var autoScroll=function(){oThis.scrollNext();};this.autoPlayTimer=setTimeout(autoScroll,this.autoPlay);return this.autoPlayTimer;},stopAutoPlay:function(){if(this.autoPlayTimer!==null){clearTimeout(this.autoPlayTimer);this.autoPlayTimer=null;}},isVertical:function(){return(this.orientation!="horizontal");},isItemLoaded:function(idx){var liElem=this.getItem(idx);if(this._isValidObj(liElem)&&!this._isValidObj(liElem.placeholder)){return true;}
return false;},getItem:function(idx){var elemName=this.carouselElemID+"-item-"+idx;var liElem=YAHOO.util.Dom.get(elemName);return liElem;},show:function(){YAHOO.util.Dom.setStyle(this.carouselElem,"display","block");this.calculateSize();},hide:function(){YAHOO.util.Dom.setStyle(this.carouselElem,"display","none");},calculateSize:function(){var ulKids=this.carouselList.childNodes;var li=null;for(var i=0;i<ulKids.length;i++){li=ulKids[i];if(li.tagName=="LI"||li.tagName=="li"){break;}}
var pl=this._getStyleVal(li,"paddingLeft");var pr=this._getStyleVal(li,"paddingRight");var ml=this._getStyleVal(li,"marginLeft");var mr=this._getStyleVal(li,"marginRight");var liPaddingWidth=pl+pr+ml+mr;YAHOO.util.Dom.removeClass(this.carouselList,"carousel-vertical");YAHOO.util.Dom.removeClass(this.carouselList,"carousel-horizontal");if(this.isVertical()){YAHOO.util.Dom.addClass(this.carouselList,"carousel-vertical");var pt=this._getStyleVal(li,"paddingTop");var pb=this._getStyleVal(li,"paddingBottom");var mt=this._getStyleVal(li,"marginTop");var mb=this._getStyleVal(li,"marginBottom");var liPaddingHeight=pt+pb+mt+mb;var ulPaddingHeight=this._getStyleVal(this.carouselList,"paddingTop")+
this._getStyleVal(this.carouselList,"paddingBottom")+
this._getStyleVal(this.carouselList,"marginTop")+
this._getStyleVal(this.carouselList,"marginBottom");var liHeight=this._getStyleVal(li,"height",true);this.scrollAmountPerInc=(liHeight+liPaddingHeight);var liWidth=this._getStyleVal(li,"width");this.clipReg.style.width=(liWidth+liPaddingWidth)+"px";this.clipReg.style.height=(this.scrollAmountPerInc*this.numVisible+ulPaddingHeight)+"px";this.carouselElem.style.width=(liWidth+liPaddingWidth)+"px";var currY=YAHOO.util.Dom.getY(this.carouselList);YAHOO.util.Dom.setY(this.carouselList,currY-this.scrollAmountPerInc*(this.firstVisible-1));}else{YAHOO.util.Dom.addClass(this.carouselList,"carousel-horizontal");var liWidth=li.offsetWidth;this.scrollAmountPerInc=(liWidth+liPaddingWidth);this.carouselElem.style.width=((this.scrollAmountPerInc*this.numVisible)+this.navMargin*2)+"px";this.clipReg.style.width=(this.scrollAmountPerInc*this.numVisible)+"px";var currX=YAHOO.util.Dom.getX(this.carouselList);YAHOO.util.Dom.setX(this.carouselList,currX-this.scrollAmountPerInc*(this.firstVisible-1));}},_getStyleVal:function(li,style,returnFloat){var styleValStr=YAHOO.util.Dom.getStyle(li,style);var styleVal=returnFloat?parseFloat(styleValStr):parseInt(styleValStr,10);if(style=="height"&&isNaN(styleVal)){styleVal=li.offsetHeight;}else if(isNaN(styleVal)){styleVal=0;}
return styleVal;},_calculateSize:function(me){me.calculateSize();YAHOO.util.Dom.setStyle(me.carouselElem,"visibility","visible");},_removeChildrenFromNode:function(node)
{if(!this._isValidObj(node))
{return;}
var len=node.childNodes.length;while(node.hasChildNodes())
{node.removeChild(node.firstChild);}},_prebuildLiElem:function(idx){var liElem=document.createElement("li");liElem.id=this.carouselElemID+"-item-"+idx;liElem.placeholder=true;this.carouselList.appendChild(liElem);this.lastPrebuiltIdx=(idx>this.lastPrebuiltIdx)?idx:this.lastPrebuiltIdx;},_createItem:function(idx,innerHTMLOrElem){var liElem=document.createElement("li");liElem.id=this.carouselElemID+"-item-"+idx;if(typeof(innerHTMLOrElem)==="string"){liElem.innerHTML=innerHTMLOrElem;}else{liElem.appendChild(innerHTMLOrElem);}
return liElem;},_insertAfterItem:function(refIdx,innerHTMLOrElem){return this._insertBeforeItem(refIdx+1,innerHTMLOrElem);},_insertBeforeItem:function(refIdx,innerHTMLOrElem){var refItem=this.getItem(refIdx);if(this.size!=this.UNBOUNDED_SIZE){this.size+=1;}
for(var i=this.lastPrebuiltIdx;i>=refIdx;i--){var anItem=this.getItem(i);if(this._isValidObj(anItem)){anItem.id=this.carouselElemID+"-item-"+(i+1);}}
var liElem=this._createItem(refIdx,innerHTMLOrElem);var insertedItem=this.carouselList.insertBefore(liElem,refItem);this.lastPrebuiltIdx+=1;return liElem;},insertAfterEnd:function(innerHTMLOrElem){return this.insertAfter(this.size,innerHTMLOrElem);},_position:function(newStart,showAnimation){if(newStart>this.firstVisible){var inc=newStart-this.firstVisible;this._scrollNextInc(this,inc,showAnimation);}else{var dec=this.firstVisible-newStart;this._scrollPrevInc(this,dec,showAnimation);}},_scrollNext:function(e,carousel){if(carousel.scrollNextAnim.isAnimated()){return false;}
var currEnd=carousel.firstVisible+carousel.numVisible-1;if(carousel.wrap&&currEnd==carousel.size){carousel.scrollTo(1);}else if(e!==null){carousel.stopAutoPlay();carousel._scrollNextInc(carousel,carousel.scrollInc,(carousel.cfg.getProperty("animationSpeed")!==0));}else{carousel._scrollNextInc(carousel,carousel.scrollInc,(carousel.cfg.getProperty("animationSpeed")!==0));}},_scrollNextInc:function(carousel,inc,showAnimation){var currFirstVisible=carousel.firstVisible;var newEnd=carousel.firstVisible+inc+carousel.numVisible-1;newEnd=(newEnd>carousel.size)?carousel.size:newEnd;var newStart=newEnd-carousel.numVisible+1;inc=newStart-carousel.firstVisible;carousel.priorFirstVisible=carousel.firstVisible;carousel.firstVisible=newStart;if((carousel.prevEnabled===false)&&(carousel.firstVisible>1)){carousel._enablePrev();}
if((carousel.nextEnabled===true)&&(newEnd==carousel.size)){carousel._disableNext();}
if(inc>0){if(carousel._isValidObj(carousel.loadNextHandler)){carousel.lastVisible=carousel.firstVisible+carousel.numVisible-1;carousel.currSize=(carousel.lastVisible>carousel.currSize)?carousel.lastVisible:carousel.currSize;var alreadyCached=carousel._areAllItemsLoaded(currFirstVisible,carousel.lastVisible);carousel.loadNextHandlerEvt.fire(carousel.firstVisible,carousel.lastVisible,alreadyCached);}
if(showAnimation){var nextParams={points:{by:[-carousel.scrollAmountPerInc*inc,0]}};if(carousel.isVertical()){nextParams={points:{by:[0,-carousel.scrollAmountPerInc*inc]}};}
carousel.scrollNextAnim=new YAHOO.util.Motion(carousel.carouselList,nextParams,carousel.cfg.getProperty("animationSpeed"),carousel.animationMethod);if(carousel._isValidObj(carousel.animationCompleteHandler)){carousel.scrollNextAnim.onComplete.subscribe(this._handleAnimationComplete,[carousel,"next"]);}
carousel.scrollNextAnim.animate();}else{if(carousel.isVertical()){var currY=YAHOO.util.Dom.getY(carousel.carouselList);YAHOO.util.Dom.setY(carousel.carouselList,currY-carousel.scrollAmountPerInc*inc);}else{var currX=YAHOO.util.Dom.getX(carousel.carouselList);YAHOO.util.Dom.setX(carousel.carouselList,currX-carousel.scrollAmountPerInc*inc);}}}
return false;},_handleAnimationComplete:function(type,args,argList){var carousel=argList[0];var direction=argList[1];carousel.animationCompleteEvt.fire(direction);},_areAllItemsLoaded:function(first,last){var itemsLoaded=true;for(var i=first;i<=last;i++){var liElem=this.getItem(i);if(!this._isValidObj(liElem)){this._prebuildLiElem(i);itemsLoaded=false;}else if(this._isValidObj(liElem.placeholder)){itemsLoaded=false;}}
return itemsLoaded;},_prebuildItems:function(first,last){for(var i=first;i<=last;i++){var liElem=this.getItem(i);if(!this._isValidObj(liElem)){this._prebuildLiElem(i);}}},_scrollPrev:function(e,carousel){if(carousel.scrollPrevAnim.isAnimated()){return false;}
carousel._scrollPrevInc(carousel,carousel.scrollInc,(carousel.cfg.getProperty("animationSpeed")!==0));},_scrollPrevInc:function(carousel,dec,showAnimation){var currLastVisible=carousel.lastVisible;var newStart=carousel.firstVisible-dec;newStart=(newStart<=1)?1:(newStart);var newDec=carousel.firstVisible-newStart;carousel.priorFirstVisible=carousel.firstVisible;carousel.firstVisible=newStart;if((carousel.prevEnabled===true)&&(carousel.firstVisible==1)){carousel._disablePrev();}
if((carousel.nextEnabled===false)&&((carousel.firstVisible+carousel.numVisible-1)<carousel.size)){carousel._enableNext();}
if(newDec>0){if(carousel._isValidObj(carousel.loadPrevHandler)){carousel.lastVisible=carousel.firstVisible+carousel.numVisible-1;carousel.currSize=(carousel.lastVisible>carousel.currSize)?carousel.lastVisible:carousel.currSize;var alreadyCached=carousel._areAllItemsLoaded(carousel.firstVisible,currLastVisible);carousel.loadPrevHandlerEvt.fire(carousel.firstVisible,carousel.lastVisible,alreadyCached);}
if(showAnimation){var prevParams={points:{by:[carousel.scrollAmountPerInc*newDec,0]}};if(carousel.isVertical()){prevParams={points:{by:[0,carousel.scrollAmountPerInc*newDec]}};}
carousel.scrollPrevAnim=new YAHOO.util.Motion(carousel.carouselList,prevParams,carousel.cfg.getProperty("animationSpeed"),carousel.animationMethod);if(carousel._isValidObj(carousel.animationCompleteHandler)){carousel.scrollPrevAnim.onComplete.subscribe(this._handleAnimationComplete,[carousel,"prev"]);}
carousel.scrollPrevAnim.animate();}else{if(carousel.isVertical()){var currY=YAHOO.util.Dom.getY(carousel.carouselList);YAHOO.util.Dom.setY(carousel.carouselList,currY+
carousel.scrollAmountPerInc*newDec);}else{var currX=YAHOO.util.Dom.getX(carousel.carouselList);YAHOO.util.Dom.setX(carousel.carouselList,currX+
carousel.scrollAmountPerInc*newDec);}}}
return false;},_loadInitial:function(){this.lastVisible=this.firstVisible+this.numVisible-1;this.currSize=(this.lastVisible>this.currSize)?this.lastVisible:this.currSize;if(this.firstVisible==1){this._disablePrev();}
if(this.lastVisible==this.size){this._disableNext();}
if(this._isValidObj(this.loadInitHandler)){var alreadyCached=this._areAllItemsLoaded(1,this.lastVisible);this.loadInitHandlerEvt.fire(1,this.lastVisible,alreadyCached);}
if(this.autoPlay!==0){this.autoPlayTimer=this.startAutoPlay();}},_disablePrev:function(){this.prevEnabled=false;if(this._isValidObj(this.prevButtonStateHandlerEvt)){this.prevButtonStateHandlerEvt.fire(false,this.carouselPrev);}
if(this._isValidObj(this.carouselPrev)){YAHOO.util.Event.removeListener(this.carouselPrev,"click",this._scrollPrev);}},_enablePrev:function(){this.prevEnabled=true;if(this._isValidObj(this.prevButtonStateHandlerEvt)){this.prevButtonStateHandlerEvt.fire(true,this.carouselPrev);}
if(this._isValidObj(this.carouselPrev)){YAHOO.util.Event.addListener(this.carouselPrev,"click",this._scrollPrev,this);}},_disableNext:function(){if(this.wrap){return;}
this.nextEnabled=false;if(this._isValidObj(this.nextButtonStateHandlerEvt)){this.nextButtonStateHandlerEvt.fire(false,this.carouselNext);}
if(this._isValidObj(this.carouselNext)){YAHOO.util.Event.removeListener(this.carouselNext,"click",this._scrollNext);}},_enableNext:function(){this.nextEnabled=true;if(this._isValidObj(this.nextButtonStateHandlerEvt)){this.nextButtonStateHandlerEvt.fire(true,this.carouselNext);}
if(this._isValidObj(this.carouselNext)){YAHOO.util.Event.addListener(this.carouselNext,"click",this._scrollNext,this);}},_isValidObj:function(obj){if(null==obj){return false;}
if("undefined"==typeof(obj)){return false;}
return true;}};