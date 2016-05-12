var als7_cmenu_body;
var als7_cmenu_shadow;
var als8_cmenu_closer;
function initASContextMenu(menu){
	menu.find(">div").each(function(e){
		var item=$(this);
		if(item.hasClass("menu-sep")){
			item.html("&nbsp;");
		}
		else{
			var text=item.addClass("menu-item").html();
			item.empty().append($("<div class=\"menu-text\"></div>").html(text));
			var iconCls=item.attr("iconCls")||item.attr("icon");
			if(iconCls){
				$("<div class=\"menu-icon\"></div>").addClass(iconCls).appendTo(item);
			}
			item.mouseover(function(e){item.addClass("menu-active");});
			item.mouseout(function(e){item.removeClass("menu-active");});
			item.click(function(e){hideASContextMenu(e,true);});
		}
	});
};
function hideASContextMenu(e,forceClose){
	if(als7_cmenu_body)als7_cmenu_body.hide();
	if(als7_cmenu_shadow)als7_cmenu_shadow.hide();
}
function showASContextMenu(menu,e){
	var iLeft = e.clientX?e.clientX:e.x;
	var iTop = e.clientY?e.clientY:e.y;
	iTop = iTop + document.body.scrollTop;
	menu.css({left:iLeft,top:iTop});
	//创建阴影效果
	if(als7_cmenu_shadow==undefined){
		als7_cmenu_shadow = $("<div class=\"menu-shadow\"></div>").insertAfter(menu);
	}
	als7_cmenu_shadow.css({display:"block",zIndex:99,left:iLeft,top:iTop,width:menu.outerWidth(),height:menu.outerHeight()});
	menu.css("z-index",100);
	menu.show();
}
function isClickOnMe(e){
	if(e.srcElement){
		if (e.srcElement.parentNode==undefined)
			return true;
		if(e.srcElement.parentNode.id==als7_cmenu_body.attr('id') || e.srcElement.parentNode.parentNode.id==als7_cmenu_body.attr('id'))
			return true;
		else
			return false;
	}
	else if(e.target){
		if (e.target.parentNode==undefined)
			return true;
		if(e.target.parentNode.id==als7_cmenu_body.attr('id') || e.target.parentNode.parentNode.id==als7_cmenu_body.attr('id'))
			return true;
		else
			return false;
	}
	else
		return false;
}

function bindASContextMenu(objectid,e){
	e = (e==undefined?event:e);
	if(!als7_cmenu_body){
		als7_cmenu_body = $('#' + objectid);
		initASContextMenu(als7_cmenu_body);			
	}
	if(!isClickOnMe(e))
		showASContextMenu(als7_cmenu_body,e);
}
if(document.addEventListener){
	document.addEventListener("click",documentOnmousedown,false);
}
else{
	document.attachEvent("onclick",documentOnmousedown,false);
}
function documentOnmousedown(e){
	try{
		if(e.srcElement &&( e.srcElement.type=='radio' || e.srcElement.type=='checkbox' || e.srcElement.type=='select-one' || e.srcElement.type=='select-multiple'))
			CHANGED = true;
		else if(e.target &&( e.target.type=='radio' || e.srcElement.target=='checkbox' || e.srcElement.type=='select-one' || e.srcElement.type=='select-multiple'))
			CHANGED = true;
	}
	catch(e){}
	hideASContextMenu(e,true);
}