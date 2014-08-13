var cookieName = "open-nodes-1";
var nodesToOpen = readCookie(cookieName);

function setNodeOpen(idStr)
{
    if (nodesToOpen == null || nodesToOpen.indexOf(idStr) < 0) {
      if (nodesToOpen == null)
        nodesToOpen = idStr;
      else
        nodesToOpen += "|"+idStr;
      createCookie(cookieName, nodesToOpen, 30);
    }
}

function setNodeClose(idStr)
{
    if (nodesToOpen == null || nodesToOpen.indexOf(idStr) < 0)
        return;
    var splits = nodesToOpen.split("|");
    var n = splits.length;
    var i = 0;
    var newNodesToOpen = "";
    while (i<n) {
    	var idStr1 = splits[i++];
        if (idStr1 != idStr) {
            if (newNodesToOpen == null || newNodesToOpen == "")
                newNodesToOpen = idStr1;
            else
                newNodesToOpen = newNodesToOpen + "|" + idStr1;
        }
    }
    nodesToOpen = newNodesToOpen;
    createCookie(cookieName, nodesToOpen, 30);
}

function toggle(idStr)
{
    var element = document.getElementById(idStr)
    var imgStr = new String(idStr + 'image')
    var image = document.getElementById(imgStr)

    if(element.style.display=="none") {
        element.style.display="";
        image.src="/images/arrow-dn.gif";
        setNodeOpen(idStr);
    }
    else {
        element.style.display="none";
        image.src="/images/arrow-rt.gif";
        setNodeClose(idStr);
    }


}

function open_node(idStr)
{
   if (idStr == "")
   {
   return;
   }

	var element = document.getElementById(idStr)
	var imgStr = new String(idStr + 'image')
	var image = document.getElementById(imgStr)

	if(element && element.style.display=="none")
	{
		element.style.display=""
		image.src="/images/arrow-dn.gif"
	}
}

function open_all_nodes()
{
    if (nodesToOpen == null) return;

    var splits = nodesToOpen.split("|");
    var n = splits.length;
    var i = 0;
    while (i<n) {
    	var idStr = splits[i++];
    	open_node(idStr);
    }

}

function createCookie(name,value,days)
{
	if (days)
	{
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name)
{
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++)
	{
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

function MM_findObj(n, d) { //v3.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document); return x;
}
function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function getCookieVal (offset) {
  var endstr = document.cookie.indexOf (";", offset);
  if (endstr == -1)
    endstr = document.cookie.length;
  return unescape(document.cookie.substring(offset, endstr));
}


