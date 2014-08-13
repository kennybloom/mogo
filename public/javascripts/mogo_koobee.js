var appname = navigator.appName;

function home_content_onClick(programName, channelId, categoryId, programId, programDesc, programUrl, note, externalId, syndicationId, list_type, parent_category_id)
{
    var urlArray = programUrl.split('|');
    var url = urlArray[0];
    var urlText = urlArray[1];
	
	document.getElementById('curr_video_channel_id').value = channelId;
	document.getElementById('curr_video_category_id').value = categoryId;
	document.getElementById('curr_video_program_id').value = programId;

	try {		
		programframe.set_image_highlite(programId);  
	}
	catch (err) {
	}

	programName = programName.replace("~", "'");

  if (syndicationId == '1' || syndicationId == '2' || externalId == '')	{
		//alert("/mogo/play_video/" + channelId + "-" + categoryId + "-" + programId + "-" + note);
		videoframe.location.href = "/mogo/play_video/" + channelId + "-" + categoryId + "-" + programId + "-" + note;
  }
  else {
		videoframe.location.href = "http://uiplayer.uitv.com/UiPlayer/fplay.aspx?id=" + externalId + "&pid=80120001&size=415*360";
  }
	nextvideoframe.location.href = "/mogo/next_video/" + list_type + "-" + channelId + "-" + categoryId + "-" + programId + "-" + parent_category_id;

	var name = navigator.appName;

	if (programDesc == '') {
		programDesc = programName;
	}
	programDesc = "<p>" + programDesc + "</p>"
	
	//programUrl = 'http://www.mogo.com.cn';
	if (url == '') {
		url = "<div id='program-more-inactive'>更多 &gt;</div>"
	}
	else {
		url = "<a href='" + url + "' target='_new'>更多&nbsp;&gt;</a>"
	}
	
	$('#program-description').html(programDesc);
	$('#program-more').html(url);

	relatedVideo = "home_goRelated('" + programId + "'); return false;";
	
	relatedVideo = "<a href='#bottom' onclick=" + relatedVideo + ">&lt;&nbsp;相關視頻</a>"

	$('#program-go-channel').html(relatedVideo);

	home_refreshAds(channelId);
}

function content_onClick(programName, channelId, categoryId, programId, programDesc, programUrl, note, externalId, syndicationId, list_type, parent_category_id)
{
    var urlArray = programUrl.split('|');
    var url = urlArray[0];
    var urlText = urlArray[1];
	
	parent.document.getElementById('curr_video_channel_id').value = channelId;
	parent.document.getElementById('curr_video_category_id').value = categoryId;
	parent.document.getElementById('curr_video_program_id').value = programId;

	try {		
		parent.frames.programframe.set_image_highlite(programId);  
	}
	catch (err) {
	}

	programName = programName.replace("~", "'");

  if (syndicationId == '1' || syndicationId == '2' || externalId == '')	{
		//alert("/mogo/play_video/" + channelId + "-" + categoryId + "-" + programId + "-" + note);
		parent.frames.videoframe.location.href = "/mogo/play_video/" + channelId + "-" + categoryId + "-" + programId + "-" + note;
  }
  else {
		parent.frames.videoframe.location.href = "http://uiplayer.uitv.com/UiPlayer/fplay.aspx?id=" + externalId + "&pid=80120001&size=415*360";
  }
	parent.frames.nextvideoframe.location.href = "/mogo/next_video/" + list_type + "-" + channelId + "-" + categoryId + "-" + programId + "-" + parent_category_id;

	var name = navigator.appName;

	if (programDesc == '') {
		programDesc = programName;
	}
	programDesc = "<p>" + programDesc + "</p>"
	
	//programUrl = 'http://www.mogo.com.cn';
	if (url == '') {
		url = "<div id='program-more-inactive'>更多 &gt;</div>"
	}
	else {
		url = "<a href='" + url + "' target='_new'>更多&nbsp;&gt;</a>"
	}
	
	parent.$('#program-description').html(programDesc);
	parent.$('#program-more').html(url);

	relatedVideo = "home_goRelated('" + programId + "'); return false;";
	
	relatedVideo = "<a href='#bottom' onclick=" + relatedVideo + ">&lt;&nbsp;相關視頻</a>"

	parent.$('#program-go-channel').html(relatedVideo);

	refreshAds(channelId);
}

function category_onClick(url)
{
		parent.frames.programframe.location.href = url;
}

function goSearch()
{
  var k = document.getElementById('searchkey');
  if(!k.value){
    alert('请输入查询内容');
    return;
  }
  
 		var url = encodeURI("/mogo/list_programs/search-" + k.value);
    parent.frames.programframe.location.href = url;

}

function home_goRelated(programId)
{
 		var url = encodeURI("/mogo/list_programs/related-" + programId);
    programframe.location.href = url;
}

function goRelated(programId)
{
 		var url = encodeURI("/mogo/list_programs/related-" + programId);
    parent.frames.programframe.location.href = url;
}

function goEmbed(){

	var iMyWidth;
	var iMyHeight;
	//half the screen width minus half the new window width (plus 5 pixel borders).
	iMyWidth = (window.screen.width/2) - (250 + 10);
	
	//half the screen height minus half the new window height (plus title and status bars).
	iMyHeight = (window.screen.height/2) - (255 + 50);

//  channelId = parent.document.getElementById('curr_video_channel_id').value;
//  categoryId = parent.document.getElementById('curr_video_category_id').value;
//  programId = parent.document.getElementById('curr_video_program_id').value;
  channelId = document.getElementById('curr_video_channel_id').value;
  categoryId = document.getElementById('curr_video_category_id').value;
  programId = document.getElementById('curr_video_program_id').value;
  
  if(programId == null || programId == ''){
    alert('请选择想要嵌入的节目');
    return;
  }
  
  window.open('/mogo/embed_video?channelId=' + channelId + '&categoryId=' + categoryId + '&programId=' + programId,'视频嵌入','top=' + iMyHeight + ', left=' + iMyWidth + ',height=510,width=500,toolbar=no,scrollbars=no,z-look=true');
}

function goComingSoon(){
  window.open('/mogo/coming_soon','建设中','top=200,left=350,height=220,width=500,toolbar=no,scrollbars=no,z-look=true');
}

function goBBS(){
	var iMyWidth;
	var iMyHeight;
	//half the screen width minus half the new window width (plus 5 pixel borders).
	iMyWidth = (window.screen.width/2) - (200 + 10);
	
	//half the screen height minus half the new window height (plus title and status bars).
	iMyHeight = (window.screen.height/2) - (250 + 50);
	
	window.open('/mogo/bbs','mogo','top=' + iMyHeight + ', left=' + iMyWidth + ',height=500,width=400,toolbar=no,scrollbars=no,z-look=true');

	//goUrl('http://www.douban.com/group/mogo/');
}

function goPartners(){
	var iMyWidth;
	var iMyHeight;
	//half the screen width minus half the new window width (plus 5 pixel borders).
	iMyWidth = (window.screen.width/2) - (225 + 10);
	
	//half the screen height minus half the new window height (plus title and status bars).
	iMyHeight = (window.screen.height/2) - (200 + 50);
	
  	window.open('/mogo/partners','mogo','top=' + iMyHeight + ', left=' + iMyWidth + ',height=550,width=550,toolbar=no,scrollbars=yes,z-look=true');
}

function goUrl(url){
  window.open(url, '', 'fullscreen=yes, scrollbars=yes, status=yes, toolbar=yes, location=yes, menubar=yes, directories=yes, resizable=yes');
}

function home_refreshAds(channelId)
{
	// Refresh ad frames

	ad_frame_skyscraper_top_right_120x600.location.href = "/mogo/show_ad_skyscraper_top_right_120x600/" + channelId;

/*
	parent.frames.ad_frame_top_banner_728x90.location.href = "/mogo/show_ad_top_banner_728x90/" + channelId;
	parent.frames.ad_frame_square_250x250.location.href = "/mogo/show_ad_square_250x250/" + channelId;
	parent.frames.ad_frame_rectangle_336x280.location.href = "/mogo/show_ad_rectangle_336x280/" + channelId;

	parent.frames.ad_frame_top_left_120x90.location.href = "/mogo/show_ad_top_left_120x90/" + channelId;
	parent.frames.ad_frame_skyscraper_top_left_120x600.location.href = "/mogo/show_ad_skyscraper_top_left_120x600/" + channelId;
	parent.frames.ad_frame_skyscraper_bottom_left_120x600.location.href = "/mogo/show_ad_skyscraper_bottom_left_120x600/" + channelId;
	parent.frames.ad_frame_vertical_left_120x240.location.href = "/mogo/show_ad_vertical_left_120x240/" + channelId;

	parent.frames.ad_frame_top_right_120x90.location.href = "/mogo/show_ad_top_right_120x90/" + channelId;
	parent.frames.ad_frame_skyscraper_top_right_120x600.location.href = "/mogo/show_ad_skyscraper_top_right_120x600/" + channelId;
	parent.frames.ad_frame_skyscraper_bottom_right_120x600.location.href = "/mogo/show_ad_skyscraper_bottom_right_120x600/" + channelId;
	parent.frames.ad_frame_vertical_right_120x240.location.href = "/mogo/show_ad_vertical_right_120x240/" + channelId;
*/
}

function refreshAds(channelId)
{
	// Refresh ad frames

	parent.frames.ad_frame_skyscraper_top_right_120x600.location.href = "/mogo/show_ad_skyscraper_top_right_120x600/" + channelId;

/*
	parent.frames.ad_frame_top_banner_728x90.location.href = "/mogo/show_ad_top_banner_728x90/" + channelId;
	parent.frames.ad_frame_square_250x250.location.href = "/mogo/show_ad_square_250x250/" + channelId;
	parent.frames.ad_frame_rectangle_336x280.location.href = "/mogo/show_ad_rectangle_336x280/" + channelId;

	parent.frames.ad_frame_top_left_120x90.location.href = "/mogo/show_ad_top_left_120x90/" + channelId;
	parent.frames.ad_frame_skyscraper_top_left_120x600.location.href = "/mogo/show_ad_skyscraper_top_left_120x600/" + channelId;
	parent.frames.ad_frame_skyscraper_bottom_left_120x600.location.href = "/mogo/show_ad_skyscraper_bottom_left_120x600/" + channelId;
	parent.frames.ad_frame_vertical_left_120x240.location.href = "/mogo/show_ad_vertical_left_120x240/" + channelId;

	parent.frames.ad_frame_top_right_120x90.location.href = "/mogo/show_ad_top_right_120x90/" + channelId;
	parent.frames.ad_frame_skyscraper_top_right_120x600.location.href = "/mogo/show_ad_skyscraper_top_right_120x600/" + channelId;
	parent.frames.ad_frame_skyscraper_bottom_right_120x600.location.href = "/mogo/show_ad_skyscraper_bottom_right_120x600/" + channelId;
	parent.frames.ad_frame_vertical_right_120x240.location.href = "/mogo/show_ad_vertical_right_120x240/" + channelId;
*/
}

function get_url_param( name )
{
  name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
  var regexS = "[\\?&]"+name+"=([^&#]*)";
  var regex = new RegExp( regexS );
  var results = regex.exec( window.location.href );
  if( results == null )
    return "";
  else
    return results[1];
}

