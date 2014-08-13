var pageNum=-1;
var pageIndex=-1;
var showIndex=-1;
var itemList=[];
var wonderful=null;

function addSwf(url,w,h){
//url="http://converse.com.cn/lyrics/swf//videoPlayer/embedVideoPlayerSmall.swf?clip=http://converse.com.cn/blog/video/CR_09_promo_0814_final_31sec.flv";
//url="images/embedVideoPlayerSmall.swf?clip="+url;
//url="http://converse.com.cn/lyrics/swf//videoPlayer/embedVideoPlayerSmall.swf?clip="+url;
url="images/embedVideoPlayerSmall.swf?clip="+url;
//url="http://vampire.dp2u.com/embedVideoPlayerSmall.swf?clip="+url;

	//alert(url);
	 var str=' <object width="'+w+'" height="'+h+'" data="'+url+'" type="application/x-shockwave-flash"><param name="allowfullscreen" value="true" /><param name="allowscriptaccess" value="always" /><param name="wmode" value="transparent" /><param name="src" value="'+url+'" /> <embed src="'+url+'" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="'+w+'" height="'+h+'"></embed></object>';
	 
	 return(str);
}
// JavaScript Document
function processRequest(XML_Http_Request){
	//alert("rrrrr");
    var results = XML_Http_Request.responseXML;

    var title = null;
    var item = null;
    var link = null;
	itemList=[];
	var obj=null;
    var wonderfulshow = results.getElementsByTagName("wonderfulshow");
	wonderful={};
	wonderful.title=readXmlNode(wonderfulshow[0].getElementsByTagName("title")[0]);
	wonderful.pubDate=readXmlNode(wonderfulshow[0].getElementsByTagName("pubDate")[0]);
	wonderful.link=readXmlNode(wonderfulshow[0].getElementsByTagName("link")[0]);
	wonderful.flv=readXmlNode(wonderfulshow[0].getElementsByTagName("flv")[0]);
	wonderful.author=readXmlNode(wonderfulshow[0].getElementsByTagName("author")[0]);
	wonderful.description=readXmlNode(wonderfulshow[0].getElementsByTagName("description")[0]);

	
	var storys = results.getElementsByTagName("storys");
    var items = results.getElementsByTagName("item");
	  //alert("items="+items.length);
    for(var i = 0; i <items.length; i++) {
        item = items[i];
		obj={};
		
		obj.index=i;
		obj.id=readXmlNode(item.getElementsByTagName("id")[0]);
		obj.title=readXmlNode(item.getElementsByTagName("title")[0]);
		obj.author=readXmlNode(item.getElementsByTagName("author")[0]);
		
		obj.image=readXmlNode(item.getElementsByTagName("image")[0]);
		
		obj.pubDate=readXmlNode(item.getElementsByTagName("pubDate")[0]);
		//alert("111");
		obj.brief=readXmlNode(item.getElementsByTagName("brief")[0]);
		obj.description=readText(readXmlNode(item.getElementsByTagName("description")[0]));
        //link=item.getElementsByTagName("link")[0].firstChild.nodeValue;
		//alert(obj.title);
		itemList.push(obj);
		
		
    }
	
	//alert("test="+itemList[0].title);
}

function initShow(){
	//page1_item_2
	// 
	var i;
	var str="Pages";
	
	pageNum=Math.ceil(itemList.length/3);
	initContent();
	
	for(i=0;i<pageNum;i++){
		str+='<a href="####" onClick="showPage(0,'+i+')">'+(i+1)+'</a>';
	}
	//alert("11="+document.getElementById("page1_right_content"));
	document.getElementById("page1_pages").innerHTML=str;
	str='<div id="page1_right_content">';
	str+='<div id="page1_right_date">'+wonderful.pubDate+'</div>';
    str+='<div id="page1_right_title">'+wonderful.title+'</div>';
    str+='<div id="page1_right_swf">'+ addSwf(wonderful.flv,356,290)+'</div>';
    str+='<div id="page1_right_des">'+wonderful.description+'</div>';
    str+='<div id="page1_right_author">'+wonderful.author+'</div></div>';
	document.getElementById("page1_right_content").innerHTML=str;
	//wonderful
	
	document.getElementById("page1_right_more").innerHTML='<a href="'+wonderful.link+'" target="_blank"><img src="images/more.jpg"></a>';
	//alert("ccccccccc");
	showPage(0,0);
		
}
function getStoryOne(obj){
	var str='<div class="page1_left_image"><a href="####" onClick="showPage(1,'+obj.index+')"><img src="'+obj.image+'" width="150" height="116"></a></div>';
        str+=' <div class="page1_left_copy">';
			str+='<div class="page1_left_date">'+obj.pubDate+'</div>';
			str+='<div class="page1_left_title"><a href="####" onClick="showPage(1,'+obj.index+')">'+obj.title+'</a></div>';
			str+='<div class="page1_left_des">'+obj.brief+'</div>';
			str+='<div class="page1_left_author">'+obj.author+'</div>';
			str+='<div class="page1_left_more"><a href="####" onClick="showPage(1,'+obj.index+')"><img src="images/more.jpg" width="45" height="17"></a></div>';
        str+='</div>';
		//alert("str="+str);
	return(str);
}
//
function setSoryMore(id){
	var obj=itemList[id];
	var str='<div id="page2_left_content"><div id="page2_left_title">'+obj.title+'</div>';
		str+= '<div id="page2_left_date">'+obj.pubDate+'</div>';
        str+=obj.description
		str+= '<div id="page2_left_author">'+obj.author+'</div></div>';
        document.getElementById("page2_left_content").innerHTML=str; 
		//alert(str);
		//document.getElementById("page2_left_content").innerHTML=str;  
}
function getStoryRightOne(obj){
	var str='<div class="page2_right_one"><div class="page2_right_bg"><div class="page2_right_bg_bg"><div class="page2_right_one_image">';
         str+='<a href="####" onClick="showPage(1,'+obj.index+')"><img src="'+obj.image+'" width="112" height="85"></a></div><div class="page2_right_one_content">';
           str+='<div class="page2_right_one_date">'+obj.pubDate+'</div>';
           str+='<div class="page2_right_one_title"><a href="####" onClick="showPage(1,'+obj.index+')">'+obj.title+'</a></div>';
            str+='<div class="page2_right_one_author">'+obj.author+'</div>';
             str+='<div class="page2_right_one_des">'+obj.brief+'</div>';
            str+='<div class="page2_right_one_more"><a href="####" onClick="showPage(1,'+obj.index+')"><img src="images/more2.jpg" width="45" height="17"></a></div> </div></div></div></div>';
		//alert("str="+str);
	return(str);
}
function showPage(page,index){
		var i;
		var n;
		var str;
		if(page==0){
			
			Element.show('page1');
			Element.hide('page2');
			if(pageIndex!=index && index<pageNum && pageNum>=0){
				
				pageIndex=index;
				n=index*3;
				
				if(n<itemList.length){
				
					document.getElementById("page1_item_0").innerHTML=getStoryOne(itemList[n]);
				}else{
					
					document.getElementById("page1_item_0").innerHTML="&nbsp;";
				}
				n=index*3+1;
				if(n<itemList.length){
					document.getElementById("page1_item_1").innerHTML=getStoryOne(itemList[n]);
				}else{
					document.getElementById("page1_item_1").innerHTML="&nbsp;";
				}
				n=index*3+2;
				if(n<itemList.length){
					document.getElementById("page1_item_2").innerHTML=getStoryOne(itemList[n]);
				}else{
					document.getElementById("page1_item_2").innerHTML="&nbsp;";
				}

			}
		}else{
			 Element.show('page2');
			Element.hide('page1');
			if(showIndex!=index && index<itemList.length && pageNum>=0){
				showIndex=index;
				str="";
				for(i=0;i<4;i++){
					if(i<itemList.length){
						str+=getStoryRightOne(itemList[i]);
					}
				}
				document.getElementById("page2_storys").innerHTML=str;
				setSoryMore(index);
			}
		}
}
function readXmlNode(item){
	if(item.childNodes.length>1){
		return(item.childNodes[1].nodeValue);
	}else if(item.childNodes.length>0){
		return(item.firstChild.nodeValue);
	}else{
		return("");
	}
}

function readText(str){
	//indexOf();
	var i;
	var temList;
	var temList2;
	var ll;
	var list=str.split("{!#");
	for(i=1;i<list.length;i++){
		temList=list[i].split("#!}");
		if(temList.length<2){
			temList[0]="{!#"+list[i];
		}else{
			temList[0]='<div class="page2_left_image"><img src="'+temList[0]+'"/></div>';
		}
		list[i]=temList.join("");
	}
	str=list.join("");
	
	list=str.split("{?#");
	for(i=1;i<list.length;i++){
		temList=list[i].split("#?}");
		if(temList.length<2){
			temList[0]="{!#"+list[i];
		}else{
			ll=temList[0].split(",");
			if(!ll[1])ll[1]=428;
			if(!ll[2])ll[2]=348;
			//parseInt(ll[1]),parseInt(ll[2])+26
			temList[0]='<div class="page2_left_flv">'+addSwf(ll[0],428,348)+'</div>';
		}
		list[i]=temList.join("");
	}
	str=list.join("");
	
	
	list=str.split("<div");
	list[0]='<div class="page2_left_copy"><pre>'+list[0]+'</pre></div>';
	for(i=1;i<list.length;i++){
		//list[i]=list[i];
		temList=list[i].split("</div>");
		temList[0]='<div'+temList[0]+'</div>';
		temList2=temList.slice(1,temList.length);
		list[i]=temList[0]+'<div class="page2_left_copy"><pre>'+temList2.join("</div>")+'</pre></div>';
	}
	str=list.join("");
	
	return(str);
}
function initContent(){
	var str;
	str='<div id="page1">';
    str+='<div id="page1_right">';
        str+='	<div id="page1_right_topbar"><img src="images/jc.jpg" width="57" height="19"></div>';
            
      str+=' 	   <div id="page1_right_content"></div>';
       str+='    <div id="page1_right_more">';
   			 
       str+='     </div>';
    str+='	 </div>';
    	str+=' <div id="page1_left">';
      str+='  	<div id="topbar"><img src="images/story.jpg" width="85" height="19"></div>';
   	 str+=' <div class="page1_left_one">';
   	str+='	<div class="page1_left_one_bg">';
       str+='	  <div class="page1_left_one_content"  id="page1_item_0"></div>';
   		str+='</div>';
      str+='          </div>';

      	str+='	<div class="page1_left_one">';
   		str+='<div class="page1_left_one_bg">';
       str+='	  <div class="page1_left_one_content"  id="page1_item_1"></div>';
   	str+='	</div>';
         str+='       </div>';
 
       str+='		<div class="page1_left_one">';
   		str+='<div class="page1_left_one_bg">';
      str+=' 	  <div class="page1_left_one_content"  id="page1_item_2"></div>';
   		str+='</div>';
       str+='         </div>';
		str+='	<div id="page1_pages">';
            
        str+='    </div>';

       str+=' </div>';
       
   str+=' </div>';
   str+=' <div style="clear:both"></div>';
    str+='<!---end page1 -->';
   str+=' <div id="page2">';
    str+='	<div id="page2_right">';
     str+='   	<div id="page2_right_topbar">';
    str+='        	<img src="images/tuijian.jpg">';
     str+='       </div>';
     str+='     <div id="page2_storys"></div>';
       str+='         <div id="page2_more">';
      str+='          	<a href="####" onClick="showPage(0,0);"><img src="images/readmore.jpg"></a>';
      str+='          </div>';
          
      str+='  </div>';
    	str+='<div id="page2_left">';
       str+='<div id="topbar"><div id="page2_backlist"><a href="####"  onClick="showPage(0,0);">返回列表</a></div><div id="page2_topBar_image"><img src="images/story.jpg" width="85" height="19"></div></div>';
	   // 	<div id="topbar"><img src="images/story.jpg" width="85" height="19"></div>
       str+='	  <div id="page2_left_content"></div>';
    str+='	</div>';
        
   str+=' </div>';
	document.getElementById("content").innerHTML=str;

}
function send_Request(url)
{
		
    var request_url =url;//璺ㄥ煙鐨勮瘽,闇€瑕佸啓涓€涓唬鐞?
    var request_pars = null;
    var myAjax = new Ajax.Request(
        request_url,
        {
            method:'get',
            parameters:request_pars,
            asynchronous:true,       //true---寮傛;false---鍚屾.榛樿涓簍rue
            onComplete:processRequest
        }    
    );
}
var myGlobalHandlers = {
    onCreate:function (){
        Element.show('systemWorking');
    },
    onComplete:function (){
        if(Ajax.activeRequestCount == 0){
            Element.hide('systemWorking');
			initShow();
			
        }
    }
};
Ajax.Responders.register(myGlobalHandlers);
 