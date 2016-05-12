// OBJ_NODE - 定义结点对象
// ID = 每个结点的绝对标记
// NAME = 菜单上显示的结点名称
// PARENTID = 父结点的标记
// TYPE = 可以是文档，文件夹或者根结点
// URL = 结点对应的连接
// ALTIMAGE = 16x16 GIF文件(不用于文件夹folders)
// POSITION = 结点的位置
// TARGET = 需要在Frame打开时，为空表示在当前页面打开。
//   _top 表示整页面打开。

var nodes = new Array();
var myCurIndex = 0;
var myTriggerClickEvent = false; //是否需要整个treeview的Click事件 TreeViewOnClick();
var nodePosition = 0;
var myMultiSelect = false; // 是否有选择框

function obj_node(id,name,value,parentID,type,url,altImage,position,target) {
	this.id = amarsoft2Html(id);
	this.name = amarsoft2Html(name); 
	this.value = amarsoft2Html(value);	
	this.parentID = amarsoft2Html(parentID);
	this.type = type.toLowerCase();
	this.url = amarsoft2Html(url);
	this.altImage = amarsoft2Html(altImage);
	this.position = position;
	this.target = amarsoft2Html(target);
	// 0 未选，1 已选，2 有子节点选择
	// this.checked = 0;不给初始化，可以使用setCheckTVItem设置
}

function setCheckTVItem(sID, check){
	if(!myMultiSelect || sID == 'root') return;
	var flag = check == true;
	var span = $("span[multil=true]", $('#'+sID+', #'+sID+'minu, #'+sID+'plus', left.document));
	span.removeClass().addClass(flag ? "multiSelected" : "multiSelect");

	for(var i = 0; i < nodes.length; i++){
		if(nodes[i].id == sID){
			nodes[i].checked = flag ? 1 : 0;
			if(arguments[2] != true){
				setCheckTVParent(nodes[i]);
			}
		}
		if(nodes[i].parentID != sID) continue;
		setCheckTVItem(nodes[i].id, flag, true);
	}
}

function setCheckTVParent(node){
	if(!node || !node.parentID || node.parentID == 'root') return;
	var parentMultiBox = $("span[multil=true]", $('#'+node.parentID+'minu, #'+node.parentID+'plus', left.document));

	var flag1 = false; // 有已选节点
	var flag2 = false; // 有半选节点
	var flag3 = false; // 有未选节点
	for(var i = 0; i < nodes.length; i++){
		if(nodes[i].parentID == node.parentID){
			if(nodes[i].checked == 1) flag1 = true;
			else if(nodes[i].checked == 2) flag2 = true;
			else flag3 = true;
			if(flag2 || (flag1 && flag3)) break;
		}
	}

	var checked = 0;
	if(flag2 || (flag1 && flag3)){ // 半选
		if(parentMultiBox.hasClass("notAllChildMultiSelect")) return;
		checked = 2;
		parentMultiBox.removeClass().addClass("notAllChildMultiSelect");
	}else if(flag1){ // 全选
		if(parentMultiBox.hasClass("multiSelected")) return;
		checked = 1;
		parentMultiBox.removeClass().addClass("multiSelected");
	}else if(flag3 && !flag2){ // 全不选
		if(parentMultiBox.hasClass("multiSelect")) return;
		parentMultiBox.removeClass().addClass("multiSelect");
	}else return; // 本来就没子节点
	
	var parentNode = null;
	for(var i = 0; i < nodes.length; i++){
		if(nodes[i].id == node.parentID){
			parentNode = nodes[i];
			break;
		}
	}
	if(!parentNode) return;
	parentNode["checked"] = checked;
	setCheckTVParent(parentNode);
}

function getCheckedTVItems(){
	var checked = new Array();
	if(!myMultiSelect) return checked;
	for(var i = 0; i < nodes.length; i++){
		if(nodes[i].checked == 1){
			checked.push(nodes[i]);
		}
	}
	return checked;
}

function clickTVCheckbox(index, obj){
	var flag = !$(obj).hasClass("multiSelected");
	setCheckTVItem(nodes[index].id, flag);
}

function getCurTVItem() {
	return nodes[myCurIndex];
}	

//设置指定ID的节点的显示值
function setItemName(sID, sName) {
	iIndex = getItemIndex(sID);
	nodes[iIndex].name = sName;
	if (iIndex != -1) {
		if (nodes[iIndex].type == 'folder') {
			left.document.getElementById('textplus'+iIndex).innerText = sName;
			left.document.getElementById('textminu'+iIndex).innerText = sName;
		} else
			left.document.getElementById('text' + iIndex).innerText = sName;
	}
}	

function getItemName(sID) {
	iIndex = getItemIndex(sID);
	return nodes[iIndex].name;
}

function getItem(sID) {
	iIndex = getItemIndex(sID);
	return nodes[iIndex];
}

function addItem(id,name,value,parentID,type,url,altImage,position,target) {	
	nodes[nodePosition] = new obj_node(id,name,value,parentID,type,url,altImage,position,target);
	nodePosition = nodePosition + 1;
}	

function getItemIndex(id) {
	var i=0,iIndex=-1;
	while (i <= nodePosition - 1 && iIndex == -1) {
		if(id==nodes[i].id) iIndex=i;
		i++;
	}	
	return iIndex;
}	

function expandNode(id) {
	iIndex = getItemIndex(id);
	
	if (iIndex!=-1) flex2(iIndex,'plus');
}	

function closeNode(id) {
	iIndex = getItemIndex(id);

	if (iIndex!=-1) flex2(iIndex,'minu');
}	

function selectItem(id) {
	var index = getItemIndex(id);
	if (index!=-1){
		expandFoldersToNode(nodes[index].id,10);
		if(nodes[index].url.trim().indexOf("javascript")==0 || nodes[index].url.trim().indexOf("Javascript")==0){
			var sTempScript = nodes[index].url.trim().substring(11);
			if(sTempScript.indexOf("parent.")==0 || sTempScript.indexOf("parent.")==0){
				sTempScript = sTempScript.substring(7);
			}
			eval(parent.html2Real(sTempScript));//eval();
		}
		click_change(index);		
	}
}

//check if the node is the current subtree's end element
function ifMax(id) {
	var i = 0;
	var max = true;
	while (i < nodePosition && max == true) {
		if(nodes[i].parentID==id) max = false;
		i++;
	}
	//alert(nodes[currentIndex].id+" is max? "+max);
	return max;
}

//check if the index1 is in the branch of index2
function isSub(index1, index2) {
	var result = false;
	var i = index1;
	
	while (i != -1 && nodes[i].parentID != 'root' && result == false) {
		if(nodes[i].parentID==nodes[index2].id) result = true;
		i = getItemIndex(nodes[i].parentID);		
	}

	return result;
}	

function imageAppearance(currentIndex) {
	var appearanceStr = new String("");
	if (nodes[currentIndex].type == 'root') {
		if (nodes[currentIndex].altImage == '') 
			appearanceStr = 'img-globe';
		else 
			appearanceStr = nodes[currentIndex].altImage;
	}
	if (nodes[currentIndex].type == 'folder') {
		i=0;
		var ifEnd = ifMax(nodes[currentIndex].id);
		appearanceStr = addStringToStart('','img-folder');
		if (ifEnd == true) {
			appearanceStr = addStringToStart(appearanceStr,'gray_arrow|');
			appearanceStr = addStringToStart(appearanceStr,'&');
			appearanceStr = addStringToStart(appearanceStr,'gray_arrow|img-folder');
		} else {
			appearanceStr = addStringToStart(appearanceStr,'gray_arrow|');
			appearanceStr = addStringToStart(appearanceStr,'&');
			appearanceStr = addStringToStart(appearanceStr,'back_arrow|img-folder');
		}
	}
	if (nodes[currentIndex].type == 'page') {
		i=0;
		var ifEnd = ifMax(nodes[currentIndex].id);
		if (nodes[currentIndex].altImage == '') 
			appearanceStr = 'img-page';
		else 
			appearanceStr = nodes[currentIndex].altImage;
		if (ifEnd == true) 
			appearanceStr = addStringToStart(appearanceStr,'1x1.gif|');
		else 
			appearanceStr = addStringToStart(appearanceStr,'1x1.gif|');
	}
	return appearanceStr;
}

function drawMenu() {
	drawMenu2(left.document);
}

function click_change(index) {
	if (myCurIndex > 0) {
		try{
			eval("left.document.all().className=''");
		} catch (e) {
		}
	}

	if (nodes[myCurIndex].type == 'folder') {
		left.document.getElementById('span'+myCurIndex+'plus').className='';
		left.document.getElementById('span'+myCurIndex+'minu').className='';
	}else   left.document.getElementById('span'+myCurIndex).className='';
		
	if (nodes[index].type == 'folder') {
		left.document.getElementById('span'+index+'plus').className='node_hoverCls';
		left.document.getElementById('span'+index+'minu').className='node_hoverCls';
	}else   left.document.getElementById('span'+index).className='node_hoverCls';
		
	myCurIndex = index;

	//如果指定了Click后续事件，则调用当前
 	if (myTriggerClickEvent==true) TreeViewOnClick();

	//parent.parent.location=url;
}

// add by hwang 20090601 树图双击响应函数
function doubleclick() {		
	if (myTriggerClickEvent==true && typeof TreeViewOnDBLClick == 'function') TreeViewOnDBLClick();
}

function addStringToStart(existingString, addition) {
	newString = addition + existingString;
	return newString;
}

function stringUpToBar(sString) {
	var lengthOfString = sString.length;
	var mycurrentIndex = 0;
	var newString = '';
	var finished = false;
	while (finished == false) {
		if (mycurrentIndex == lengthOfString) 
		finished = true;
		else {
			if (sString.charAt(mycurrentIndex) == '|') 
				finished = true;
			else 
				newString = newString + sString.charAt(mycurrentIndex);
			mycurrentIndex = mycurrentIndex + 1;
		}
		if (mycurrentIndex == lengthOfString) {finished = true;}
	}
	return newString;
}

	
function twoArrays(x1, x2, y1, y2) {
	//var node = tryArray(x1,x2);
	//var sortnode = tryArray(y1,y2);

	for (var i = 0; i < x1; i++) {
		for (var j = 0; j < x2; j++) {
			nodes[i][j] = "node"+i+j;
			//alert(nodes[i][j]);	
		}	
	}

	for (var i = 0; i < y1; i++) {
		for (var j = 0; j < y2; j++) {
			sortnodes[i][j] = nodes[i];
			//alert(sortnodes[i][j]);	
		}	
	}
}

//判断是否叶结点
function hasChild(nodeid){
	for(var i=0;i<nodes.length;i++){
		if(nodes[i].parentID==nodeid) return false;
	}
	return true;
}

//根据名称找到节点
function getNodeIDByName(sName){
	for(var i=0;i<nodes.length;i++){
		if(nodes[i].name.indexOf(sName)>=0) return nodes[i].id;
	}
	return null;
}

function selectItemByName(sName) {
	id=getNodeIDByName(sName);
	selectItem(id);
}

function expandFoldersToNode(id, iGenerations) {
	var iCurGenerations = iGenerations-1;
	if(iCurGenerations<0) return;
	var iIndex = getItemIndex(id);

	//先展开父层级
	if (typeof(nodes[iIndex].parentID)!="undefined" && nodes[iIndex].parentID!=null && nodes[iIndex].parentID!="")
	{
		expandFoldersToNode(nodes[iIndex].parentID,iCurGenerations);
	}
	//再展开自己
	//alert(id+":"+nodes[iIndex].type);
	if(nodes[iIndex].type=="folder"){
		try{
			//closeNode(id); 
			expandNode(id);
		}catch(e){
			//alert(e.message+" ..... "+id);
		}
	}else{
		return;
	}
}

function setTDStyle(obj, myIndex) {
	if (nodes[myIndex].type == "root") {
		obj.className = "rootTDCls";
//		obj.bgColor = '#E3E3E3';
//		obj.borderColorLight  = '#099999';
//		obj.bordercolordark = '#FFFFFF';
	} else if (nodes[myIndex].type == "folder") {
		obj.className = "folderTDCls";
//		obj.bgColor = '#EBEBEB';
//		obj.borderColorLight  = '#099999';
//		obj.borderColorDark = '#FFFFFF';
	} else if (nodes[myIndex].type == "page") {
		obj.className = "pageTDCls";
//		obj.bgColor = '#F5F5F5';
//		obj.borderColorLight  = '#F5F5F5';
//		obj.borderColorDark = '#F5F5F5';
	}	
}

function showTVSearch(){
	var obj = $("#search", left.document);
	if(obj.is(":visible")){
		obj.hide();
		return;
	}
	$("tr:first", obj).unbind().mousedown(function(e){
		var offset = $(this).offset();
		$(left.document).mousemove(move).mouseup(up);
		function move(e1){
			obj.css({
				"left" : e1.clientX - e.clientX + offset.left,
				"top" : e1.clientY - e.clientY + offset.top
			});
		}
		function up(){
			$(left.document).unbind("mousemove", move).unbind("mouseup", up);
		}
	});
	$("input:text", obj.show()).focus();
}

function _searchTVItem(e){
	e = e || left.event;
	if(e.keyCode != 13) return;
	searchTVItem($("input:button[value='确定']", $("#search", left.document)));
}

function searchTVItem(obj){
	var search = $("input:text", $("#search", left.document));
	searchText = search.val();
	if(!searchText) return;
	
	var searchNodes = new Array();
	for(var i = 0; i < nodes.length; i++){
		if(nodes[i].id == "root") continue;
		if(nodes[i].name.indexOf(searchText) > -1){
			searchNodes.push(nodes[i]);
		}
	}

	var prev = $(obj).next().unbind("click");
	var num = prev.next().text(1);
	var allnum = num.next().text("/ "+searchNodes.length);
	var next = allnum.next().unbind("click");
	prev.attr("disabled", true);
	if(searchNodes.length < 2) next.attr("disabled", true);
	else next.attr("disabled", false);
	if(searchNodes.length < 1){
		num.text(0);
		return;
	}
	try{selectItem(searchNodes[0].id);}catch(e){}
	prev.add(next).each(function(){
		$.event.remove(this);
		$.removeData(this);
	});
	
	var currnum = 1;
	next.bind("click", function(){
		if(currnum >= searchNodes.length) return;
		try{selectItem(searchNodes[currnum++].id);}catch(e){}
		num.text(currnum);
		if(currnum >= searchNodes.length) $(this).attr("disabled", true);
		prev.attr("disabled", false);
	});
	prev.bind("click", function(){
		if(currnum <= 1) return;
		try{selectItem(searchNodes[--currnum - 1].id);}catch(e){}
		num.text(currnum);
		if(currnum <= 1) $(this).attr("disabled", true);
		next.attr("disabled", false);
	});
}

function setQuick(){
	var args = arguments;
	var keys = {};
	$(left.document).keydown(function(e){
		keys[e.keyCode] = true;
		var flag = true;
		for(var i = 0; i < args.length - 1; i++){
			if(!keys[args[i]]){
				flag = false;
				break;
			}
		}
		if(flag && typeof args[args.length - 1] == "function"){
			keys = {};
			(args[args.length - 1])();
		}
    }).keyup(function(e){
    	delete keys[e.keyCode];
    });
}

function drawMenu2(myDocument) {
	//判断是否有重复的id
	var sTemp = new Array(), sTemp2 = new Array();
	var j=0;
	for(var i=0;i<nodes.length;i++) sTemp[j++]=nodes[i].id;
	sTemp2 = sTemp.sort();
	for (var i = 0; i < nodes.length - 1; i++) {
		if (sTemp2[i] == sTemp2[i + 1]) {
			alert("ID("+sTemp2[i]+")重复!");
		}
	}
	
	//var lengthOfArray = nodePosition;
	var currentIndex = 0;
	//var trBgColor = "#E3E3E3";
	
	//add by xdhou in 2008/04/10 for kick visit root
	if(backgroundDirectory=="") backgroundDirectory = imageDirectory;
	if(backgroundImage=="") backgroundImage = "1x1.gif";
		
	myDocument.writeln("<HTML>");
	myDocument.writeln("<head>");
	myDocument.writeln("<style type='text/css'> .pt9song{font-size: 9pt;cursor:pointer} </style>");
	myDocument.writeln("<META http-equiv=Content-Type content='text/html; charset=gb2312'>");
	myDocument.writeln("<link rel='stylesheet' href='"+imageDirectory+"/Style.css'>");
	myDocument.writeln("<link rel='stylesheet' href='"+sSkinPath+"/css/Style.css'>");
	myDocument.writeln("</head>");
	myDocument.writeln("<BODY style='overflow: hidden;' oncontextmenu='javascript:return false;' leftmargin='0' rightmargin='0' topmargin='0' BACKGROUND='" + backgroundDirectory + "/" + backgroundImage + "' BGCOLOR='" + backgroundColor + "' LINK='" + linkColor + "' VLINK='" + linkColor + "'>");
	myDocument.writeln("<div  class='groupboxmaxcontent'  style='position:absolute;overflow: auto;'> ");
	myDocument.writeln("<table id=tabTreeview border='0' cellspacing='0' cellpadding='0' width='100%'>");
	myDocument.writeln("</table></div>");
	myDocument.writeln("<div id='search' style='display: none; position: absolute; left: 10; top: 30; border: 2px solid #959cff; background-color: #eee;'>");
	myDocument.writeln("<table cellspacing='0' cellpadding='0'>");
	myDocument.writeln("<tr><td style='padding:2px; background-color:#959cff; font-weight: bold; cursor:default;' align='center' title='拖拽'>查询</td></tr>");
	myDocument.writeln("<tr><td style='padding:5px;'>");
	myDocument.writeln("<input style='width: 100%;' onkeydown=parent._searchTVItem(event) />");
	myDocument.writeln("</td></tr>");
	myDocument.writeln("<tr><td nowrap align='center' style='padding:5px;'>");
	myDocument.writeln("<input type='button' value='确定' onclick=parent.searchTVItem(this) />");
	myDocument.writeln("<input type='button' value='上一个' disabled />");
	myDocument.writeln("<span>0</span>");
	myDocument.writeln("<span>/ 0</span>");
	myDocument.writeln("<input type='button' value='下一个' disabled />");
	myDocument.writeln("<input type='button' value='取消' onclick=javascript:document.getElementById('search').style.display='none'; />");
	myDocument.writeln("</td></tr>");
	myDocument.writeln("</table>");
	myDocument.writeln("</div>");
	myDocument.writeln("</BODY>");
	myDocument.close();	

	//first draw root
	drawNode2(myDocument,currentIndex,currentIndex,-1);
	
	//then draw level 1 
	drawSubTree2(myDocument,currentIndex);
	
	//alert(myDocument.body.innerHTML);
}

function drawSubTree2(myDocument, currentIndex) {
	var myID = "";
	if(currentIndex==0) 
		myID = "root";
	else
		myID = nodes[currentIndex].id+"plus";
		
	var curTRObj = myDocument.getElementById(myID);
	var curPos = curTRObj.rowIndex+1;

	//逐个生成子树	
	for (var ik = 1; ik < nodes.length; ik++) {
		if(nodes[ik].parentID==nodes[currentIndex].id) 
			curPos = drawNode2(myDocument,ik,ik,curPos);
	}		
}

function drawNode2(myDocument, currentIndex, spanID, myPos) {
	var imageSequence = imageAppearance(currentIndex);
	var nodeID = nodes[currentIndex].id;
	var multiSelectClass = nodes[currentIndex].checked == 1 ? "multiSelected" : nodes[currentIndex].checked == 2 ? "notAllChildMultiSelect" : "multiSelect";
	var check = nodes[currentIndex].id != 'root' && myMultiSelect;
	var ifShow = 'none';
	//if(nodes[currentIndex].id == 'root') ifShow = '';
	if (nodes[currentIndex].type == 'folder') {
		var arrayImage = imageSequence.split('&');
		
		var sss=new Array(),jjj=0;
		var newTRObj = myDocument.getElementById("tabTreeview").insertRow(myPos);
		newTRObj.id = nodeID+"minu";
		newTRObj.style.display = "none";
		var newTDObj = newTRObj.insertCell(0);
		setTDStyle(newTDObj,currentIndex);
		
		sss[jjj++]=("\t<table id='table"+spanID+"' width=100% border='0' cellspacing='0' cellpadding='0' >");
		sss[jjj++]=("\t<tr id='span"+spanID+"plus') >");
		sss[jjj++]=("\t<td nowrap ondblclick=parent.flex2("+currentIndex+",'minu') >" );
		sss[jjj++]=writeImageSequence2(currentIndex,arrayImage[0]);
		//sss[jjj++]=("\t&nbsp;");
		if (nodes[currentIndex].type == 'root') 
			nodeName = nodes[currentIndex].name;
		else 
			nodeName = nodes[currentIndex].name;
		if (nodes[currentIndex].target == '') 
			var nodeTarget = 'PageFrame';
		else 
			nodeTarget = nodes[currentIndex].target;
		
		if(check) sss[jjj++]="<span multil=true class='"+multiSelectClass+"' onclick='javascript:parent.clickTVCheckbox("+currentIndex+", this);'>&nbsp;</span>";
		if (nodes[currentIndex].url == '')
		  // modify by hwang 20090601 增加双击事件"ondblclick=parent.doubleclick()" 
			sss[jjj++]=("\t<A id=textplus"+currentIndex+" class='pt9song' ondblclick=parent.doubleclick()  onClick=parent.click_change("+currentIndex+") title='"+nodeName+"' >" + nodeName + "</A></td></tr></table>");
		else
		  // modify by hwang 20090601 增加双击事件"ondblclick=parent.doubleclick()"
			sss[jjj++]=("\t<A id=textplus"+currentIndex+" class='pt9song' HREF='" + nodes[currentIndex].url + "' TARGET='" + nodeTarget + "'  ondblclick=parent.doubleclick() onClick=parent.click_change("+currentIndex+") title='"+nodeName+"' >" + nodeName + "</A></td></tr></table>");
		
		newTDObj.innerHTML = sss.join('');		
		
		var ss2=new Array(),jj2=0;
		var newTR2Obj = myDocument.getElementById("tabTreeview").insertRow(myPos+1);
		newTR2Obj.style.display = ifShow;
		newTR2Obj.id = nodeID+"plus";
		var newTD2Obj = newTR2Obj.insertCell(0);
		setTDStyle(newTD2Obj,currentIndex);
		
		ss2[jj2++]=("\t<table id='table"+spanID+"' width=100% border='0' cellspacing='0' cellpadding='0' >");
		ss2[jj2++]=("\t<tr id='span"+spanID+"minu'  )>");
		ss2[jj2++]=("\t<td nowrap ondblclick=parent.flex2("+currentIndex+",'plus') >" );
		ss2[jj2++]=writeImageSequence2(currentIndex,arrayImage[1]);
		//ss2[jj2++]=("\t&nbsp;");
		if (nodes[currentIndex].type == 'root') 
			nodeName = nodes[currentIndex].name;
		else 
			nodeName = nodes[currentIndex].name;
		if (nodes[currentIndex].target == '') 
			var nodeTarget = 'PageFrame';
		else 
			nodeTarget = nodes[currentIndex].target;
		
		if(check) ss2[jj2++]="<span  multil=true class='"+multiSelectClass+"' onclick='javascript:parent.clickTVCheckbox("+currentIndex+", this);'>&nbsp;</span>";
		if (nodes[currentIndex].url == '') 
			// modify by hwang 20090601 增加双击事件"ondblclick=parent.doubleclick()"
			ss2[jj2++]=("\t<A id=textminu"+currentIndex+" class='pt9song' ondblclick=parent.doubleclick()  onClick=parent.click_change("+currentIndex+") title='"+nodeName+"' >" + nodeName + "</A></td></tr></table>");
		else
			// modify by hwang 20090601 增加双击事件"ondblclick=parent.doubleclick()"
			ss2[jj2++]=("\t<A id=textminu"+currentIndex+" class='pt9song' HREF='" + nodes[currentIndex].url + "' TARGET='" + nodeTarget + "' ondblclick=parent.doubleclick()  onClick=parent.click_change("+currentIndex+") title='"+nodeName+"' >" + nodeName + "</A></td></tr></table>");
		
		newTD2Obj.innerHTML = ss2.join('');
		
		return myPos+2;
	} else {
		var sss=new Array(),jjj=0;
		var newTRObj = myDocument.getElementById("tabTreeview").insertRow(myPos);
		newTRObj.style.display = ifShow;
		newTRObj.id = nodeID;
		var newTDObj = newTRObj.insertCell(0);
		setTDStyle(newTDObj,currentIndex);
		
		sss[jjj++]=("\t<table id='table"+spanID+"' width=100% border='0' cellspacing='0' cellpadding='0' >");
		sss[jjj++]=("\t<tr id='span"+spanID+"' >");
		sss[jjj++]=("\t<td nowrap ondblclick=''>" );
		sss[jjj++]=writeImageSequence2(currentIndex,imageSequence);
		//sss[jjj++]=("\t&nbsp;");
		if (nodes[currentIndex].type == 'root') 
			nodeName = nodes[currentIndex].name;
		else 
			nodeName = nodes[currentIndex].name;
		if (nodes[currentIndex].target == '') 
			var nodeTarget = 'PageFrame';
		else 
			nodeTarget = nodes[currentIndex].target;
		
		if(check) sss[jjj++]="<span multil=true class='"+multiSelectClass+"' onclick='javascript:parent.clickTVCheckbox("+currentIndex+", this);'>&nbsp;</span>";
		if (nodes[currentIndex].url == '') {
			// modify by hwang 20090601 增加双击事件"ondblclick=parent.doubleclick()"
			sss[jjj++]=("\t<A id=text"+currentIndex+" class='pt9song'  ondblclick=parent.doubleclick() onClick=parent.click_change("+currentIndex+") title='"+nodeName+"' >" + nodeName + "</A></td></tr></table>");
		} else
			// modify by hwang 20090601 增加双击事件"ondblclick=parent.doubleclick()"
			sss[jjj++]=("\t<A id=text"+currentIndex+" class='pt9song' HREF='" + nodes[currentIndex].url + "' TARGET='" + nodeTarget + "'  ondblclick=parent.doubleclick() onClick=parent.click_change("+currentIndex+") title='"+nodeName+"' >" + nodeName + "</A></td></tr></table>");
			
		newTDObj.innerHTML = sss.join('');
		return myPos+1;
	}
}

function writeImageSequence2(currentIndex, sequence) {
	var s2=new Array(),j2=0;
		
	iIndex = currentIndex;
	while (nodes[iIndex].parentID != 'root' && nodes[iIndex].parentID != '') {
		s2[j2++]=("\t<IMG SRC='" + imageDirectory + "/19x19.gif' ALIGN=TEXTTOP>");
		iIndex = getItemIndex(nodes[iIndex].parentID);
	}
	
	var finished = false;
	var imageSeq = sequence;
	while (finished == false) {
		if (imageSeq == '') 
			finished = true;
		else {  
			imageString = stringUpToBar(imageSeq);
			if (imageString.length == imageSeq.length) 
				imageSeq = '';
			else 
				imageSeq = imageSeq.substring(imageString.length + 1,imageSeq.length);
			if ((imageString == 'gray_arrow')) {
				//var leftstr = left.name;
				s2[j2++]=("\t<A class='pt9song' onclick=parent.flex2("+currentIndex+",'plus')><IMG SRC='" + imageDirectory + "/1x1.gif' class='node_icon " + imageString + "' ALIGN=TEXTTOP BORDER=0></A>");
			} else {
				if ((imageString == 'back_arrow')) {
					//var leftstr = left.name;
					s2[j2++]=("\t<A class='pt9song' onclick=parent.flex2("+currentIndex+",'minu')><IMG SRC='" + imageDirectory + "/1x1.gif' class='node_icon " + imageString + "' ALIGN=TEXTTOP BORDER=0></A>");
				} else {
					if (imageString == 'img-globe') {
						s2[j2++]=("\t<IMG SRC='" + imageDirectory + "/1x1.gif', class='node_icon " + imageString + "'>");
					}else if (imageString == '1x1.gif') {
						s2[j2++]=("\t<IMG SRC='" + imageDirectory + "/" + imageString + "' ALIGN=TEXTTOP>");
					} else {
						s2[j2++]=("\t<IMG SRC='" + imageDirectory + "/1x1.gif', class='node_icon " + imageString + "' ALIGN=TEXTTOP>");
					}
				}
			}
		}
	}
	return s2.join('');
}

function flex2(currentIndex, checkStr) {
	var i;
	var currentID = nodes[currentIndex].id;
	var checkStrBrother;
	if(checkStr=='plus')	checkStrBrother = 'minu';
	else	checkStrBrother = 'plus';
	
	if (currentID != 'root') {
		left.document.getElementById(currentID + checkStr).style.display = "none";
		left.document.getElementById(currentID + checkStrBrother).style.display = "";
	}

	for (i = 1; i < nodes.length; i++) {
		if (checkStr == 'plus') {
			//show his son
			if (nodes[i].parentID == currentID) {
				if( (nodes[i].type == 'folder' && left.document.getElementById(nodes[i].id+'plus')==null ) ||	
				    (nodes[i].type != 'folder' && left.document.getElementById(nodes[i].id)==null ) )
					drawSubTree2(left.document,currentIndex);
				if (nodes[i].type == 'folder') {
					if(left.document.getElementById(nodes[i].id+'minu').style.display!="")  //add this for not show two in 2006/06/16,2008/04/10
						left.document.getElementById(nodes[i].id+'plus').style.display="";
				} else 
					left.document.getElementById(nodes[i].id).style.display="";
			}	
			
			// if level is first , show all his sub child
			/*
			if (nodes[currentIndex].parentID=='root' && isSub(i,currentIndex))
			{
				if (nodes[i].type == 'folder')
				{
					left.document.getElementById(nodes[i].id+'minu').style.display="";
					left.document.getElementById(nodes[i].id+'plus').style.display="none";
				}	
				else left.document.getElementById(nodes[i].id).style.display="";
			}
			*/
		} else {
			//hide all his sub child
			if (isSub(i, currentIndex)) {
				if (nodes[i].type == 'folder') {
					try {					
					left.document.getElementById(nodes[i].id+'plus').style.display="none";
					}catch(e) {}
					try {					
					left.document.getElementById(nodes[i].id+'minu').style.display="none";
					}catch(e) {}
				}else 
					try {					
					left.document.getElementById(nodes[i].id).style.display="none";
					}catch(e) {}
			}	
		}
	}
	
	if (currentID!='root') scroll(0,left.document.getElementById(currentID+checkStr).offsetTop-100);
}

function obj_nodeYX(id,name,value,parentID,type,url,altImage,position,target) {
	 this.id = amarsoft2Html(id);
	 
	 /*jqcao:为实现树图节点HTML样式自定义*/
	 //this.name = amarsoft2Html(name);
	 this.name = name;
	 
	 this.value = amarsoft2Html(value); 
	 this.parentID = amarsoft2Html(parentID);
	 this.type = type.toLowerCase();
	 this.url = amarsoft2Html(url);
	 this.altImage = amarsoft2Html(altImage);
	 this.position = position;
	 this.target = amarsoft2Html(target);
	 // 0 未选，1 已选，2 有子节点选择
	 // this.checked = 0;不给初始化，可以使用setCheckTVItem设置
	}

function addItemYX(id,name,value,parentID,type,url,altImage,position,target) { 
	 nodes[nodePosition] = new obj_nodeYX(id,name,value,parentID,type,url,altImage,position,target);
	 nodePosition = nodePosition + 1;
}
