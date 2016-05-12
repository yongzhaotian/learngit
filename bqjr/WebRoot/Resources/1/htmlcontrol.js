//var sHCResourcesPath = "/amarbank6/Resources/1";
var sHCResourcesPath = sResourcesPath;
var iCurButtonID = 1;


/***button*/

/**显示一个button*/

function hc_drawButton(buttonID, buttonText, onclickScript, displayType){
		var result="";
		result += "<span id='"+buttonID+"' onclick=\""+onclickScript+"\">"+"\r";
		result += "<table id='"+buttonID+"_button_frame' cellspacing=0 cellpadding=0 border=0><tr>"+"\r";
		result += "<td id='"+buttonID+"_button_left' class='"+displayType+"buttonleft' width='8'><img src='"+sHCResourcesPath+"/button"+displayType+"_left.gif' width='8' height='16'  border='0'></td>"+"\r";
 		result += "<td id='"+buttonID+"_button_middle' class='"+displayType+"button' valign='bottom' align='center'><span id='"+buttonID+"_button_text' class='"+displayType+"buttontext' style='cursor:pointer;'>"+buttonText+"</span></td>"+"\r";
 		result += "<td id='"+buttonID+"_button_right' class='"+displayType+"buttonright' width='8'><img src='"+sHCResourcesPath+"/button"+displayType+"_right.gif' width='8' height='16'  border='0'></td>"+"\r";
 		result += "</tr></table></span>"+"\r";
		
		document.write(result);
		
}

function hc_drawButtonWithTip(sText,sTips,sScript,ssHCResourcesPath){
	hc_drawButtonWithTip(sText,sTips,sScript,ssHCResourcesPath,"");
}

function hc_drawButtonWithTip(sText,sTips,sScript,ssHCResourcesPath,iconCls){
		if(typeof(iconCls) == "undefined" || iconCls.length == 0){
			if (sText.indexOf("新增") >= 0) iconCls = "btn_icon_add";
			if (sText.indexOf("详情") >= 0) iconCls = "btn_icon_detail";
			if (sText.indexOf("删除") >= 0) iconCls = "btn_icon_delete";
			if (sText.indexOf("提交") >= 0) iconCls = "btn_icon_submit";
			if (sText.indexOf("保存") >= 0) iconCls = "btn_icon_save";
		}
	
		var result="";
		result += "<span id='button"+iCurButtonID+"' title='"+sTips+"' onclick=\""+sScript+"\" ";
 		result += " onMouseOver=\"overButton("+iCurButtonID+");\" ";
 		result += " onMouseOut=\"outButton("+iCurButtonID+");\" ";
 		result += " onMouseDown=\"downButton("+iCurButtonID+");\" ";
 		result += " onMouseUp=\"upButton("+iCurButtonID+");\" ";
		result += ">"+"\r";
		result += "<table id='buttontable"+iCurButtonID+"' cellspacing=0 cellpadding=0 border=0><tr>"+"\r";
		result += "<td id='buttonlefttd"+iCurButtonID+"' class='buttonleft'><img  class='buttonleftimg'  id='buttonimageleft"+iCurButtonID+"' src='"+ssHCResourcesPath+"/1x1.gif' width='1' height='1' boder='0'></td>"+"\r";
 		result += "<td id='buttonmiddletd1"+iCurButtonID+"' nowrap class='button' >";
 		result += "<div class=\"";
 		if(typeof(iconCls)!= "undefined" && iconCls.length != 0){
			result += iconCls;
		}
		result += "\"></div></td><td id='buttonmiddletd2"+iCurButtonID+"' class='button' nowrap>";
 		result +=  sText + "</td>"+"\r";
 		result += "<td id='buttonrighttd"+iCurButtonID+"' class='buttonright'><img  class='buttonrightimg' id='buttonimageright"+iCurButtonID+"' src='"+ssHCResourcesPath+"/1x1.gif' width='1' height='1' boder='0'></td>"+"\r";
 		result += "</tr></table></span>"+"\r";

		document.write(result);
		//alert(result);
		iCurButtonID++;
}

function drawImgButton(sClassName,sTips,sScript,ssHCResourcesPath){
		var result="";
		result += " <img src=\""+ssHCResourcesPath+"/1x1.gif\" class=\""+sClassName+"\" id='button"+iCurButtonID+"' title='"+sTips+"' alt='"+sTips+"' onclick=\""+sScript+"\" ";
 		result += " onMouseOver=\"overImgButton(this,'"+sClassName+"');\" ";
 		result += " onMouseOut=\"outImgButton(this,'"+sClassName+"');\" ";
 		result += " onMouseDown=\"javascript:this.className='"+sClassName+"_down'\" ";
 		result += " onMouseUp=\"javascript:this.className='"+sClassName+"_hover'\" ";
		result += "/> ";
		document.write(result);
		iCurButtonID++;
}

function overButton(iButtonID){
	//加入超时控制，防止闪屏
    setTimeout(function overButtonIn(){
		document.getElementById('buttonmiddletd1'+iButtonID).className='buttonHover';
		document.getElementById('buttonmiddletd2'+iButtonID).className='buttonHover';
		document.getElementById('buttonimageleft'+iButtonID).className='buttonleftimgHover';
		document.getElementById('buttonimageright'+iButtonID).className='buttonrightimgHover';
	}, 1); 
}

function outButton(iButtonID){
	//加入超时控制，防止闪屏
    setTimeout(function outButtonIn(){
		document.getElementById('buttonmiddletd1'+iButtonID).className='button';
		document.getElementById('buttonmiddletd2'+iButtonID).className='button';
		document.getElementById('buttonimageleft'+iButtonID).className='buttonleftimg';
		document.getElementById('buttonimageright'+iButtonID).className='buttonrightimg';
	}, 1); 
}

function overImgButton(obj,cname){
	//加入超时控制，防止闪屏
    setTimeout(function overImgButtonIn(){
		obj.className=cname+'_hover';
	}, 1); 
}

function outImgButton(obj,cname){
	//加入超时控制，防止闪屏
    setTimeout(function outImgButtonIn(){
		obj.className=cname;
	}, 1); 
}

function downButton(iButtonID){
	document.getElementById('buttonmiddletd1'+iButtonID).className='buttonDown';
	document.getElementById('buttonmiddletd2'+iButtonID).className='buttonDown';
	document.getElementById('buttonimageleft'+iButtonID).className='buttonleftimgDown';
	document.getElementById('buttonimageright'+iButtonID).className='buttonrightimgDown';
	
}
function upButton(iButtonID){
	document.getElementById('buttonmiddletd1'+iButtonID).className='buttonHover';
	document.getElementById('buttonmiddletd2'+iButtonID).className='buttonHover';
	document.getElementById('buttonimageleft'+iButtonID).className='buttonleftimgHover';
	document.getElementById('buttonimageright'+iButtonID).className='buttonrightimgHover';
	
}

/**显示一组button*/
function hc_drawButtons(buttons, displayType){
		document.write("<table cellspacing=0 cellpadding=0 border=0><tr><td>&nbsp;</td>"+"\r");
		for(var i=0; i<buttons.length; i++){
			document.write("<td>"+"\r");
			hc_drawButton(buttons[i][0],buttons[i][1],buttons[i][2],displayType);
			document.write("<td>&nbsp;&nbsp;</td>"+"\r");
 			document.write("</td>"+"\r");
 		}
		document.write("</tr></table>"+"\r");
		
}



/**显示一个inputbox*/
function hc_drawInputbox(name, header, colspan, tag, readonly, defaultValue){
		document.write("<td nowrap align='left' valign='bottom'>&nbsp;&nbsp;<span class='ibheader'>"+ header +"</span></td>"+"\r");
		document.write("<td nowrap valign='bottom' class='ibcontent' colspan='"+(colspan-1)+"' ><input class='inputbox' "+readonly+" name='"+name+"' value='"+defaultValue+"'></td>"+"\r");
}

function hc_drawMemoInputbox(name, header, colspan, tag, readonly, defaultValue){
		document.write("<td nowrap align='left' valign='top'>&nbsp;&nbsp;<span  class='ibheader1'>"+ header +"</span></td>"+"\r");
		document.write("<td nowrap valign='bottom' class='ibcontent' colspan='"+(colspan-1)+"' ><textarea rows='6' class='inputbox' "+readonly+" name='"+name+"' value='"+defaultValue+"'></textarea></td>"+"\r");
		
}

function hc_drawDateInputbox(name, header, colspan, tag, readonly, defaultValue){
		document.write("<td nowrap align='left' valign='bottom'>&nbsp;&nbsp;<span class='ibheader'>"+ header +"</span></td>"+"\r");
		document.write("<td nowrap valign='bottom' class='ibcontent' colspan='"+(colspan-1)+"' ><input class='inputbox' "+readonly+" name='"+name+"' value='"+defaultValue+"'></td>"+"\r");
		
}


/**显示freeform*/
function hc_drawFreeForm(obj,width,totalColumns,defaultColspan,defaultColspanForLongType,defaultPosition){
		document.write("<table cellspacing=0 cellpadding=0 border=0 width='"+width+"'>"+"\r");
		var remainColumns = 0;
		var colwidth;
		
		var a = width.replace("%","");
		
		if(a<=100){
			colwidth = (a/totalColumns);
			colwidth = colwidth +"%";
		}else{
			colwidth = a/totalColumns;	
		}
		 
		
				
		document.write("<tr>");
		for(var j=0; j<totalColumns; j++){
			document.write("<td width='"+colwidth+"'></td>");
		}
		document.write("</tr>");
		
		
		for(var j=0; j<obj.length; j++){
			//取得colspan
			temp=obj[j][3];
			if(temp==""){
				colspan = defaultColspan;
			}else{
				colspan = temp;
			}

			//取得position
			temp=obj[j][4];
			if(temp==""){
				position = defaultPosition;
			}else{
				position = temp;
			}

			//显示<tr>
			if ((position=="NEWROW")||(position=="FULLROW")||(colspan > remainColumns)){
				if (remainColumns > 0){
					document.write("<td colspan='"+remainColumns+"'>&nbsp;</td></tr>"+"\r");
				}
				remainColumns = totalColumns;
				document.write("<tr height='8'></tr><tr>");
			}

			//显示内容
			if(obj[j][2]=="string"){
				hc_drawInputbox(obj[j][0], obj[j][1], colspan, obj[j][5],obj[j][6],obj[j][7]);
				remainColumns = remainColumns -colspan;
			}
			if(obj[j][2]=="memo"){
				hc_drawMemoInputbox(obj[j][0], obj[j][1], colspan, obj[j][5],obj[j][6],obj[j][7]);
				remainColumns = remainColumns -colspan;
			}
			if(obj[j][2]=="date"){
				hc_drawInputbox(obj[j][0], obj[j][1], colspan, obj[j][5],obj[j][6],obj[j][7]);
				remainColumns = remainColumns -colspan;
			}
			if(obj[j][2]=="dropdownlist"){
				hc_drawInputbox(obj[j][0], obj[j][1], colspan, obj[j][5],obj[j][6],obj[j][7]);
				remainColumns = remainColumns -colspan;
			}

			//显示</tr>
			
			if (position=="FULLROW"){
				if (remainColumns > 0){
					document.write("<td colspan='"+remainColumns+"'>&nbsp;</td></tr>"+"\r");
				}
				remainColumns=0;
			}
		}

		document.write("</table>");
}

/**显示一组tab*/		
function hc_drawTab(tabID, tabStrip,selectedStrip){
		
		document.write("<table id='"+tabID+"'cellspacing=0 cellpadding=0 border=0><tr>"+"\r");

		

		document.write("</tr><tr>"+"\r");
		for(var i=0; i<tabStrip.length; i++){
			var a1="";
			var a2="";
			var rowspan="3";
			
			if(i==(selectedStrip-1)){
				a2="on";
			}else{
				a2="off";
			}
			if(i==(selectedStrip)){
				a1="on";
			}else{
				a1="off";
			}
			if(i==0){
				a1="fr";
				rowspan="2";
			}
			
			document.write("<td rowspan="+rowspan+"><img class='tab"+a1+a2+"'  src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");
			document.write("<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");
			if(i==(tabStrip.length-1)){
				document.write("<td rowspan=2><img class='tab"+a2+"bk'  src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");
			}
			
		}
		document.write("</tr><tr>"+"\r");
		for(var i=0; i<tabStrip.length; i++){
			var selected="";
			if(i==(selectedStrip-1)){
				selected="sel";
			}else{
				selected="desel";
			}
			document.write("<td class='tab"+selected+"' nowrap><span class='tabtext' onclick=\""+tabStrip[i][2]+"\">"+tabStrip[i][1]+"</span></td>"+"\r");

		}
	
		document.write("</tr><tr>"+"\r");
		for(var i=0; i<tabStrip.length; i++){
			if(i==0){
				if(i==(selectedStrip-1)){
					document.write("<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");		
				}else{
					document.write("<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");		
				}
			}
			if(i==(selectedStrip-1)){
				document.write("<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");		
			}else{
				document.write("<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");		
			}	
			if(i==(tabStrip.length-1)){
				if(i==(selectedStrip-1)){
					document.write("<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");		
				}else{
					document.write("<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");		
				}	
			}			
		}

		document.write("</tr></table>"+"\r");

	}


	function hc_drawTabToIframe(tabID, tabStrip,selectedStrip,sObject){
		
		
		sObject.document.clear();
		sObject.document.close();
		
		sObject.document.write("<html>"+"\r");
		sObject.document.write("<head>"+"\r");
		sObject.document.write("<link rel='stylesheet' href='"+sHCResourcesPath+"/Style.css'>"+"\r");
		sObject.document.write("<META HTTP-EQUIV='Content-Type' CONTENT='text/html; charset=gb2312'>"+"\r");

//		/*
		sObject.document.write("<style>\r");
				sObject.document.write("img.tabonoff \r {\r height:19px; \rwidth:24px;\r background-image:url("+sHCResourcesPath+"/tab/onoff.gif);\r}");
				sObject.document.write("img.taboffon { height:19px;	width:24px;	background-image:url("+sHCResourcesPath+"/tab/offon.gif);}\r");
				sObject.document.write("img.taboffoff { height:19px;width:24px;	background-image:url("+sHCResourcesPath+"/tab/offoff.gif);}\r");
				sObject.document.write("img.taboffbk{height:18px;width:14px;background-image:url("+sHCResourcesPath+"/tab/bkoff.gif);}\r");
				sObject.document.write("img.tabonbk{height:18px;width:14px;	background-image:url("+sHCResourcesPath+"/tab/bkon.gif);}\r");
				sObject.document.write("img.tabfroff{height:18px;width:28px;background-image:url("+sHCResourcesPath+"/tab/froff.gif);}\r");
				sObject.document.write("img.tabfron{height:18px;width:28px;background-image:url("+sHCResourcesPath+"/tab/fron.gif);}\r");
				sObject.document.write(".tabdesel{background-color:#C4C4C4;}\r");
				sObject.document.write(".tabsel{background-color:#DCDCDC;}\r");
				sObject.document.write(".tabline1{background-color:#DCDCDC;}\r");
				sObject.document.write(".tabline{background-color:#FFFFFF;}\r");
				sObject.document.write(".tabtext{cursor:pointer;}\r");
				sObject.document.write(".tabcontent{border-top: #DCDCDC 1px solid;border-bottom: #AAAAAA 2px solid;border-left: #FFFFFF 1px solid;border-right: #AAAAAA 2px solid;background-color:#DEDEC8;}\r");
				sObject.document.write(".tabbar{background-image:url("+sHCResourcesPath+"/tab/barback.gif);height: 1 px;}\r");
		sObject.document.write("</style>\r");
//		*/
		sObject.document.write("</head>"+"\r");		
		sObject.document.write("<body class='pagebackground' leftmargin='0' topmargin='0'  background='"+sHCResourcesPath+"/tab/barback.gif'>"+"\r");
		//sObject.document.write("<Tbody>"+"\r");
		sObject.document.write("<table id='"+tabID+"' cellspacing=0 cellpadding=0 border=0  align='left' valign='bottom'><tr>"+"\r");

		

		sObject.document.write("</tr><tr>"+"\r");
		for(var i=0; i<tabStrip.length; i++){
			var a1="";
			var a2="";
			var rowspan="3";
			
			if(i==(selectedStrip-1)){
				a2="on";
			}else{
				a2="off";
			}
			if(i==(selectedStrip)){
				a1="on";
			}else{
				a1="off";
			}
			if(i==0){
				a1="fr";
				rowspan="2";
			}
			
			sObject.document.write("<td    rowspan="+rowspan+"><img class='tab"+a1+a2+"'  src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");
			sObject.document.write("<td   class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");
			if(i==(tabStrip.length-1)){
				sObject.document.write("<td rowspan=2 ><img class='tab"+a2+"bk'  src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");
			}
			
		}
		sObject.document.write("</tr><tr>"+"\r");
		for(var i=0; i<tabStrip.length; i++){
			var selected="";
			if(i==(selectedStrip-1)){
				selected="sel";
			}else{
				selected="desel";
			}
			sObject.document.write("<td  class='tab"+selected+"' nowrap><span class='tabtext' onclick=\""+tabStrip[i][2]+"\">"+tabStrip[i][1]+"</span></td>"+"\r");

		}
	
		sObject.document.write("</tr><tr>"+"\r");
		for(var i=0; i<tabStrip.length; i++){
			if(i==0){
				if(i==(selectedStrip-1)){
					sObject.document.write("<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");		
				}else{
					sObject.document.write("<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");		
				}	
				
			}
			if(i==(selectedStrip-1)){
				sObject.document.write("<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");		
			}else{
				sObject.document.write("<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");		
			}	
			if(i==(tabStrip.length-1)){
				if(i==(selectedStrip-1)){
					sObject.document.write("<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");		
				}else{
					sObject.document.write("<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r");		
				}	
			}			
		}

		sObject.document.write("</tr></table>"+"\r");
		//sObject.document.write("</Tbody>"+"\r");
		sObject.document.write("</body>\r");
		sObject.document.write("</html>\r");
		//alert(sObject.document.src);
	} 

	function hc_drawTabToTable(tabID, tabStrip,selectedStrip,sObject){
		
		sObject.innerHTML="";
		sInnerHTML = "";
		sInnerHTML= sInnerHTML + "<table id='"+tabID+"' cellspacing=0 cellpadding=0 border=0  align='left' valign='bottom'>"+"\r";
		sInnerHTML= sInnerHTML + "<tr>"+"\r";
		
		for(var i=0; i<tabStrip.length; i++){
			var a1="";
			var a2="";
			var rowspan="3";
			
			if(i==(selectedStrip-1)){
				a2="on";
			}else{
				a2="off";
			}
			if(i==(selectedStrip)){
				a1="on";
			}else{
				a1="off";
			}
			if(i==0){
				a1="fr";
				rowspan="2";
			}
			
			sInnerHTML= sInnerHTML + "<td rowspan="+rowspan+"><img class='tab"+a1+a2+"'  src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
			sInnerHTML= sInnerHTML + "<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
			
			if(i==(tabStrip.length-1)){
				sInnerHTML= sInnerHTML + "<td rowspan=2 ><img class='tab"+a2+"bk'  src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
			}
			
		}
		sInnerHTML= sInnerHTML + "</tr><tr>"+"\r";
		
		for(var i=0; i<tabStrip.length; i++){
			var selected="";
			if(i==(selectedStrip-1)){
				selected="sel";
			}else{
				selected="desel";
			}
			sInnerHTML= sInnerHTML + "<td  class='tab"+selected+"' nowrap><span class='tabtext' onclick=\""+tabStrip[i][2]+"\">"+tabStrip[i][1]+"</span></td>"+"\r";

		}
	
		sInnerHTML= sInnerHTML + "</tr><tr>"+"\r";
		
		for(var i=0; i<tabStrip.length; i++){
			if(i==0){
				if(i==(selectedStrip-1)){
					sInnerHTML= sInnerHTML + "<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
				}else{
					sInnerHTML= sInnerHTML + "<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
				}	
			}
			if(i==(selectedStrip-1)){
				sInnerHTML= sInnerHTML + "<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
			}else{
				sInnerHTML= sInnerHTML + "<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
			}	
			if(i==(tabStrip.length-1)){
				if(i==(selectedStrip-1)){
					sInnerHTML= sInnerHTML + "<td class='tabline1'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
				}else{
					sInnerHTML= sInnerHTML + "<td class='tabline'><img src='"+sHCResourcesPath+"/1x1.gif'></td>"+"\r";
				}	
			}			
		}

		sInnerHTML= sInnerHTML +"</tr></table>"+"\r";
		sObject.innerHTML=sInnerHTML;
	} 
	
	function drawHtmlToObject(oObject,sHtml){
		oObject.innerHTML="";
		oObject.innerHTML=sHtml;
	}
