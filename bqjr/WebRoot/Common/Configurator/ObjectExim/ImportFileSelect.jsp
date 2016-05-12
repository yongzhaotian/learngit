<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 导入文件选择
	 */
	String PG_TITLE = "导入文件选择"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String sButtons[][] = {
	    {"true","","Button","下一步","下一步","nextStep()",sResourcesPath},
	};

	String sPageHead = "";
	String sPageHeadPlacement = "";
	
	if(PG_TITLE.indexOf("@")>=0){
		sPageHead = StringFunction.getSeparate(PG_TITLE,"@",1);
		sPageHeadPlacement = StringFunction.getSeparate(PG_TITLE,"@",2);
	}
%>
	<html>
	<head>
	<title><%=(sPageHeadPlacement.equals("WindowTitle")?sPageHead:"")%></title> 
	</head>
	<body class="ListPage" leftmargin="0" topmargin="0" >
	<div id="CoverTipDiv" style="position:absolute; left:1px; top:1px; width:100%; height:35px; z-index:2; display:none"> 
	 <table width="100%" height="100%" align=center border="0" cellspacing="0" cellpadding="1" bgcolor="#333333">
	    <tr>
	      <td>
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
			<tr> 
			  <td width=1><img class=clockimg src=<%=sResourcesPath%>/1x1.gif width="1" height="1"></td>
			  <td id="CoverTipTD" style="background-color: #FFFFFF;"></td>
			</tr>
			</table>
		</td>
		</tr>
	</table>
	</div>
	<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" id="ListTable">
		<tr height=1>
		    <td id="ListTitle" class="ListTitle"><%=(sPageHeadPlacement.equals("PageTitle")?sPageHead:"")%>
		    </td>
		</tr>
		<script lauguage="javascript">
			<%
			if(sPageHeadPlacement.equals("")){
			%>
				document.getElementById("ListTitle").style.cssText += "display:none";
			<%
			}
			%>
		</script>

		<tr height=1 id="ButtonTR">
			<td id="ListButtonArea" class="ListButtonArea" valign=top>
				<table width=100% height=100% cellspacing="0" cellpadding="0" border="0">
				<tr>
					<td class="buttonback" valign=top>
					    	<table >
							<tr>
							<%
							for(int i=0;i<sButtons.length;i++){
								if(sButtons[i][0]==null || !sButtons[i][0].equals("true")) continue;
								%>
								<td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,sButtons[i][1],sButtons[i][2],sButtons[i][3],sButtons[i][4],sButtons[i][5],sResourcesPath)%></td>
								<%
							}
							%>
							</tr>
	
					    	</table>
					</td>
				</tr>
			</table>
		    </td>
		</tr>
		<tr>
		    <td class="ListDWArea">
				<table border='0'  cellpadding='0' cellspacing='4' width='100%' height='100%'  align='center'>
				<form method='POST'  name='customize' action='ImportDataObjects.jsp'>
				<input type=hidden name=CompClientID value="<%=CurComp.getClientID()%>">
				<input type=hidden name=PageClientID value="<%=CurPage.getClientID()%>">
				<tr height=1>
					<td colspan="4">
					请输入路径（例："c:\"）：<input type="text" name="FilePath" size=30>
					<input onClick="refreshFileList()" type=button value="显示文件">
					<input type="button" style="width:70px"  value="恢复" onClick="javascript:doDefault();">
					</td>
				</tr>
				<tr><td width='100%' colspan='2'>
				
				<input type='hidden' name='initialString' value='<%=SpecialTools.real2Amarsoft(request.getParameter("iniString"))%>'>
				
				<table width='100%' height='100%' border='1' cellpadding='0' cellspacing='8' bgcolor='#DDDDDD'>

				<tr height=1>
					<td bgcolor='#DDDDDD'>
						<span class='dialog-label'>&nbsp;可选取文件列表</span>
					</td>
					<td bordercolor='#DDDDDD' width=1>
					</td>
					<td bgcolor='#DDDDDD'>
						<span class='dialog-label'>&nbsp;已选取文件列表</span>
					</td>
					<td  width=1>
					</td>
				</tr>
				<tr>
					<td align='center'>
						<select name='available_column_selection' onchange='selectionChanged(document.forms["customize"].elements["available_column_selection"],document.forms["customize"].elements["chosen_column_selection"]); '  style='width:100%;height:100%' width='100%' height='100%' multiple='true'> 	
						</select>
					</td>
					<td width=1 align='center' valign='middle'  bordercolor='#DDDDDD'>
						<img border='0' src='<%=sResourcesPath%>/chooser_orange/arrowRight_disabled.gif'alt='Add selected items' onmousedown='pushButton("movefrom_available_column_selection",true);'  onmouseup='pushButton("movefrom_available_column_selection",false);'  onmouseout='pushButton("movefrom_available_column_selection",false);'  onclick='moveSelected(document.forms["customize"].elements["available_column_selection"],document.forms["customize"].elements["chosen_column_selection"]); updateHiddenChooserField(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["column_selection"]); ' name='movefrom_available_column_selection' />
						<br><br>
						<img border='0' src='<%=sResourcesPath%>/chooser_orange/arrowLeft_disabled.gif'alt='Remove selected items' onmousedown='pushButton("movefrom_chosen_column_selection",true);'  onmouseup='pushButton("movefrom_chosen_column_selection",false);'  onmouseout='pushButton("movefrom_chosen_column_selection",false);'  onclick='moveSelected(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["available_column_selection"]); updateHiddenChooserField(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["column_selection"]); ' name='movefrom_chosen_column_selection' />
					</td>
					<td align='center'>
						<select name='chosen_column_selection' onchange='selectionChanged(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["available_column_selection"]); ' size='10'  style='width:100%;height:100%' width='100%' height='100%'  multiple='true' >
						</select>
						<input type='hidden' name='column_selection' value=''>
					</td>
					<td  width='1' align='center' valign='middle' bordercolor='#DDDDDD'>
						<img border='0' src='<%=sResourcesPath%>/chooser_orange/arrowUp_disabled.gif' alt='Shift selected items down' name='shiftup_chosen_column_selection' onmousedown='pushButton("shiftup_chosen_column_selection",true);'  onmouseup='pushButton("shiftup_chosen_column_selection",false);'  onmouseout='pushButton("shiftup_chosen_column_selection",false);'  onclick='shiftSelected(document.forms["customize"].elements["chosen_column_selection"],-1); updateHiddenChooserField(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["column_selection"]);' />
						<br><br>
						<img border='0' src='<%=sResourcesPath%>/chooser_orange/arrowDown_disabled.gif' alt='Shift selected items up' name='shiftdown_chosen_column_selection' onmousedown='pushButton("shiftdown_chosen_column_selection",true);'  onmouseup='pushButton("shiftdown_chosen_column_selection",false);'  onmouseout='pushButton("shiftdown_chosen_column_selection",false);'  onclick='shiftSelected(document.forms["customize"].elements["chosen_column_selection"],1); updateHiddenChooserField(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["column_selection"]);' />
					</td>
				</tr>
				</table>
				</td>
				</tr>
				</form>
				</table>
			</td>
		</tr>
		<tr>
		    <td id="ListBottomArea" class="ListBottomArea">
		    </td>
		</tr>
	<%
	String ShowDetailArea = (String)CurPage.getAttribute("ShowDetailArea");
	if(ShowDetailArea!=null && ShowDetailArea.equalsIgnoreCase("true")){
	%>
		<tr>
		    <td id="ListHorizontalBar" class="ListHorizontalBar">
				<div id=divDrag title='Drag to resize' style="z-index:0; CURSOR: url('<%=sResourcesPath%>/ve_split.cur') " ondrag="if(true) {ListBottomArea.style.display='block';ButtonTR.style.display='block';FilterButtonTd.style.display='block';ListTitle.style.display='block';ListDetailAreaTD.height=ListTable.offsetTop+ListTable.offsetHeight-event.y;}">
					<img class=imgDrag src=/amarbank6_webconfigurator/Resources/1/1x1.gif width="1" height="1">
				</div>
		    </td>
		</tr>
		<tr>
		    <td id="ListDetailAreaTD" class="ListDetailAreaTD"><iframe name="ListDetailFrame" width=100% height=100% frameborder=0></iframe>
		    </td>
		</tr>
	<%
	}
	%>
	</table>
	</body>
	</html>
<script type="text/javascript">
	function getRealTop(imgElem){
		yPos = eval(imgElem).offsetTop;
		tempEl = eval(imgElem).offsetParent;
		while (tempEl != null){
			yPos += tempEl.offsetTop;
			tempEl = tempEl.offsetParent;
	    }
		return yPos;
	}
	function selectFilesToImport(){
		var sFileList = ShowFolderFileList("c:\\");
		alert(sFileList);
	}
	
	function nextStep(){
		//alert(document.forms("customize").column_selection.value);
		document.forms("customize").submit();
	}
</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
		selectedCaptionList = new Array;
		selectedNameList = new Array;
		availableCaptionList = new Array;
		availableNameList = new Array;
	
		function cloneOption(option) 
		{
		  var out = new Option(option.text,option.value);
		  out.selected = option.selected;
		  out.defaultSelected = option.defaultSelected;
		  return out;
		}
		function shiftSelected(chosen,howFar) 
		{
		  var opts = chosen.options;
		  var newopts = new Array(opts.length);
		  var start; var end; var incr;
		  if (howFar > 0) 
		  {
		    start = 0; end = newopts.length; incr = 1; 
		  } 
		  else 
		  {
		    start = newopts.length - 1; end = -1; incr = -1; 
		  }
		  for(var sel=start; sel != end; sel+=incr) 
		  {
		    if (opts[sel].selected) 
		    {
		      setAtFirstAvailable(newopts,cloneOption(opts[sel]),sel+howFar,-incr);
		    }
		  }
		  for(var uns=start; uns != end; uns+=incr) 
		  {
		    if (!opts[uns].selected) 
		    {
		      setAtFirstAvailable(newopts,cloneOption(opts[uns]),start,incr);
		    }
		  }
		  opts.length = 0;   
		  for(i=0; i<newopts.length; i++) 
		  {
		     opts[opts.length] = newopts[i]; 
		  }
		}
		function setAtFirstAvailable(array,obj,startIndex,incr) 
		{
		  if (startIndex < 0) startIndex = 0;
		  if (startIndex >= array.length) startIndex = array.length -1;
		  for(var xxx=startIndex; xxx>= 0 && xxx<array.length; xxx += incr) 
		  {
		    if (array[xxx] == null) 
		    {
		      array[xxx] = obj; 
		      return; 
		    }
		  }
		}
		function moveSelected(from,to) 
		{
		  newTo = new Array();
		  for(i=0; i<to.options.length; i++) 
		  {
		    newTo[newTo.length] = cloneOption(to.options[i]);
		    newTo[newTo.length-1].selected = false;
		  }
		  
		  for(i=0; i<from.options.length; i++) 
		  {
		    if (from.options[i].selected) 
		    {
		      newTo[newTo.length] = cloneOption(from.options[i]);
		      from.options[i] = null;
		      i--;
		    }
		  }
		  
		  to.options.length = 0;
		  for(i=0; i<newTo.length; i++) 
		  {    
		    to.options[to.options.length] = newTo[i];
		  }
		  selectionChanged(to,from);
		}
		
		
		function updateHiddenChooserField(chosen,hidden) 
		{
		  hidden.value='';
		  var opts = chosen.options;
		  for(var i=0; i<opts.length; i++) 
		  {
		    hidden.value = hidden.value + opts[i].value+'\n';
		  }
		  
		}
		
		function selectionChanged(selectedElement,unselectedElement) 
		{
		  for(i=0; i<unselectedElement.options.length; i++) 
		  {
		    unselectedElement.options[i].selected=false;
		  }
		  form = selectedElement.form; 
		  enableButton("movefrom_"+selectedElement.name,
		               (selectedElement.selectedIndex != -1));
		  enableButton("movefrom_"+unselectedElement.name,
		               (unselectedElement.selectedIndex != -1));
		  enableButton("shiftdown_"+selectedElement.name,
		               (selectedElement.selectedIndex != -1));
		  enableButton("shiftup_"+selectedElement.name,
		               (selectedElement.selectedIndex != -1));
		  enableButton("shiftdown_"+unselectedElement.name,
		               (unselectedElement.selectedIndex != -1));
		  enableButton("shiftup_"+unselectedElement.name,
		               (unselectedElement.selectedIndex != -1));
		}
		function enableButton(buttonName,enable) 
		{
		  var img = document.images[buttonName]; 
		  if (img == null) return; 
		  var src = img.src; 
		  var und = src.lastIndexOf("_disabled.gif"); 
		  if (und != -1) 
		  { 
		    if (enable) img.src = src.substring(0,und)+".gif"; 
		  } 
		  else 
		  { 
		    if (!enable) 
		    {
		      var gif = src.lastIndexOf("_clicked.gif"); 
		      if (gif == -1) gif = src.lastIndexOf(".gif"); 
		      img.src = src.substring(0,gif)+"_disabled.gif";
		    }
		  }
		}
		function pushButton(buttonName,push) 
		{
		  var img = document.images[buttonName]; 
		  if (img == null) return; 
		  	var src = img.src; 
		  	var und = src.lastIndexOf("_disabled.gif"); 
		  if (und != -1) return false; 
		  	und = src.lastIndexOf("_clicked.gif"); 
		  if (und == -1) 
		  { 
		    var gif = src.lastIndexOf(".gif");
		    if (push) img.src = src.substring(0,gif)+"_clicked.gif"; 
		  }
		  else 
		  { 
		    if (!push) img.src = src.substring(0,und)+".gif"; 
		  }
		}
		
		function doCancel()
		{	
			self.returnValue="";
			window.close();
		}


		function getFolderFileList(folderspec)
		{
		   var fso, f, f1, fc, s;
		   var fileList = new Array();
		   var i=0;
		   fso = new ActiveXObject("Scripting.FileSystemObject");
		   f = fso.GetFolder(folderspec);
		   fc = new Enumerator(f.files);
		   s = "";
		   for (; !fc.atEnd(); fc.moveNext())
		   {
			  s += fc.item();
			  s += "<br>";
			  fileList[i++] = fc.item()
		   }
		   return(fileList);
		}
		

		function showServerFiles()
		{
			var filePath = customize.FilePath.value;
			if(filePath=="") filePath="c:\\";
			sReturn = PopPageAjax("/Common/Configurator/ObjectExim/popGetFileListAjax.jsp?FilePath="+filePath,"","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
			if( typeof(sReturn)== 'undefined' || sReturn.length == 0 || sReturn == "failed" )
			{
				alert("获取"+filePath+"目录下文件出错！");
				return;
			}
			var defaultFileList = getSplitArray(sReturn);
			customize.chosen_column_selection.length = 0;
			customize.available_column_selection.options.length = 0;
			
			j=0;
			for (i = 0; i < defaultFileList.length; i++)
			{
				eval("customize.available_column_selection.options[" + (j) + "] = new Option(defaultFileList[" + i + "], defaultFileList[" + i + "])");
				j=j+1;
			}
		}
		
		function showAvailableFiles()
		{
			var filePath = customize.FilePath.value;
			if(filePath=="") filePath="c:\\";
			var defaultFileList = getFolderFileList(filePath);
			customize.chosen_column_selection.length = 0;
			customize.available_column_selection.options.length = 0;
			
			j=0;
			for (i = 0; i < defaultFileList.length; i++)
			{
				eval("customize.available_column_selection.options[" + (j) + "] = new Option(defaultFileList[" + i + "], defaultFileList[" + i + "])");
				j=j+1;
			}
			/*
			j=0;
			for (i = 0; i < selectedNameList.length; i++)
			{
				eval("customize.available_column_selection.options[" + (j) + "] = new Option(selectedCaptionList[" + i + "], selectedNameList[" + i + "])");
				j=j+1;
			}
			*/
			
		}
		
		function doDefault()
		{
			var defaultFileList = getFolderFileList("c:\\program files\\");
			customize.chosen_column_selection.length = 0;
			customize.available_column_selection.options.length = 0;
			
			j=0;
			for (i = 0; i < defaultFileList.length; i++)
			{
				eval("customize.chosen_column_selection.options[" + (j) + "] = new Option(defaultFileList[" + i + "], defaultFileList[" + i + "])");
				j=j+1;
			}
			/*
			j=0;
			for (i = 0; i < selectedNameList.length; i++)
			{
				eval("customize.available_column_selection.options[" + (j) + "] = new Option(selectedCaptionList[" + i + "], selectedNameList[" + i + "])");
				j=j+1;
			}
			*/
			
		}
		
		function refreshFileList(){
			//showAvailableFiles();
			showServerFiles();
			writeCookie("FilePath",customize.FilePath.value, 240);
		}
		
		function writeCookie(name, value, hours)
	{
	  var expire = "";
	  if(hours != null)
	  {
	    expire = new Date((new Date()).getTime() + hours * 3600000);
	    expire = "; expires=" + expire.toGMTString();
	  }
	  document.cookie = name + "=" + escape(value) + expire;
	}
	function readCookie(name)
	{
	  var cookieValue = "";
	  var search = name + "=";
	  if(document.cookie.length > 0)
	  { 
	    offset = document.cookie.indexOf(search);
	    if (offset != -1)
	    { 
	      offset += search.length;
	      end = document.cookie.indexOf(";", offset);
	      if (end == -1) end = document.cookie.length;
	      cookieValue = unescape(document.cookie.substring(offset, end))
	    }
	  }
	  return cookieValue;
	}
			
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	customize.FilePath.value=readCookie("FilePath");
	showServerFiles();
    //showAvailableFiles();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
