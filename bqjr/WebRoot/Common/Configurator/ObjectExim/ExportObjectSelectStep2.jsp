<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-28
		Tester:
		Content: ��������ѡ����
		Input Param:

		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������ѡ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	String sSelectedObjectTypes = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("column_selection"));
	String sUpdateUser = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UpdateUser"));
	String sUpdateTimeStart = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UpdateTimeStart"));
	String sUpdateTimeEnd = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UpdateTimeEnd"));
	System.out.println("sSelectedObjectTypes:"+sSelectedObjectTypes);
    if (sSelectedObjectTypes==null) sSelectedObjectTypes="";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	


%>

<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = 
        {
            {"true","","Button","��һ��","��һ��","nextStep()",sResourcesPath},
        };
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%
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
			<%
			String[][] sButtons2ndLine = (String[][])CurPage.getAttribute("Buttons2");
			if(sButtons2ndLine!=null)
			{
				%>
				<tr>
					<td class="buttonback">
							<table>
								<tr>
								<%
								for(int i=0;i<sButtons2ndLine.length;i++){
									if(sButtons2ndLine[i][0]==null || !sButtons2ndLine[i][0].equals("true")) continue;
									%>
									<td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,sButtons2ndLine[i][1],sButtons2ndLine[i][2],sButtons2ndLine[i][3],sButtons2ndLine[i][4],sButtons2ndLine[i][5],sResourcesPath)%></td>
									<%
								}
								%>
								</tr>
							</table>
					</td>
				</tr>
				<%
			}
			%>
	
			</table>
		    </td>
		</tr>
	
		<tr>
		    <td class="ListDWArea">
				<table border='0'  cellpadding='0' cellspacing='4' width='100%' height='100%'  align='center'>
				<form method='POST'  name='customize' action='ExportDataObjects.jsp'>
				<input type=hidden name=CompClientID value="<%=CurComp.getClientID()%>">
				<input type=hidden name=PageClientID value="<%=CurPage.getClientID()%>">
				<tr height=1>
					<td colspan="4">
					�����뵼��·��������"c:\"����<input type="text" name="FilePath" size=30>
					</td>
				</tr>
				<tr><td width='100%' colspan='2'>
				
				<input type='hidden' name='initialString' value='<%=SpecialTools.real2Amarsoft(request.getParameter("iniString"))%>'>
				
				<table width='100%' height='100%' border='1' cellpadding='0' cellspacing='8' bgcolor='#DDDDDD'>

				<tr height=1>
					<td bgcolor='#DDDDDD'>
						<span class='dialog-label'>&nbsp;��ѡȡ�ļ��б�</span>
					</td>
					<td bordercolor='#DDDDDD' width=1>
					</td>
					<td bgcolor='#DDDDDD'>
						<span class='dialog-label'>&nbsp;��ѡȡ�ļ��б�</span>
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
	 <script>
	    function getRealTop(imgElem) 
	    {
	        yPos = eval(imgElem).offsetTop;
	        tempEl = eval(imgElem).offsetParent;
	        while (tempEl != null) 
	        {
	            yPos += tempEl.offsetTop;
	            tempEl = tempEl.offsetParent;
	        }
	        return yPos;
	    }
	</script>



<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
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




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
		selectedCaptionList = new Array;
		selectedNameList = new Array;
		availableCaptionList = new Array;
		availableNameList = new Array;

<%

//��ʼ����ѡ������б�
String sObjectTypes[] = StringFunction.toStringArray(sSelectedObjectTypes,"\r\n");
String sNewSql = "select CatalogSql,CatalogWhere1,CatalogWhere2,CatalogWhere3 from OBJECTTYPE_CATALOG where ObjectType = :ObjectType";

//��ѡ�е�ÿ����������ѭ��ִ��
for(int ot=0;ot<sObjectTypes.length;ot++){
	if(sObjectTypes==null || sObjectTypes.length<=0) continue;
	
	sObjectTypes[ot] = StringFunction.replace(sObjectTypes[ot],"\r\n","");
	sObjectTypes[ot] = StringFunction.replace(sObjectTypes[ot],"\r","");
	sObjectTypes[ot] = StringFunction.replace(sObjectTypes[ot],"\n","");
	
	//ȡ�����Ӧ��sql���
	String sCatalogSql =null,sCatalogWhere1=null,sCatalogWhere2=null,sCatalogWhere3=null;
	SqlObject so = new SqlObject(sNewSql);
	so.setParameter("ObjectType",sObjectTypes[ot]);
	
	ASResultSet rs = Sqlca.getASResultSet(so);
	if(rs.next()){
		sCatalogSql = rs.getString("CatalogSql");
		sCatalogWhere1 = rs.getString("CatalogWhere1");
		sCatalogWhere2 = rs.getString("CatalogWhere2");
		sCatalogWhere3 = rs.getString("CatalogWhere3");
	}
	rs.getStatement().close();
	if(sCatalogSql==null || sCatalogSql.equals("")) continue;
	
	//���where����
	if(sCatalogSql.indexOf("where")<0) sCatalogSql = sCatalogSql + " where 1=1 ";
	if(sUpdateTimeStart!=null && !sUpdateTimeStart.equals("") && sCatalogWhere1!=null && !sCatalogWhere1.equals("")){
		sCatalogWhere1 = StringFunction.replace(sCatalogWhere1,"#UpdateTimeStart",sUpdateTimeStart);
		sCatalogSql  = sCatalogSql + " "+  sCatalogWhere1;
	}
	if(sUpdateTimeEnd!=null && !sUpdateTimeEnd.equals("")){
		sCatalogWhere2 = StringFunction.replace(sCatalogWhere2,"#UpdateTimeEnd",sUpdateTimeEnd);
		sCatalogSql  = sCatalogSql + " "+  sCatalogWhere2;
	}
	if(sUpdateUser!=null && !sUpdateUser.equals("")){
		sCatalogWhere3 = StringFunction.replace(sCatalogWhere3,"#UpdateUser",sUpdateUser);
		sCatalogSql  = sCatalogSql + " "+ sCatalogWhere3;
	}

	String sObjects[][]=null;
	try{
		sObjects = Sqlca.getStringMatrix(sCatalogSql);
	}catch(Exception ex)
	{
		%>alert("�﷨����:<%=sCatalogSql%>");<%
		continue;
	}
	
	for(int i=0;i<sObjects.length;i++){
		%>
		availableCaptionList[availableCaptionList.length]="<%="["+sObjectTypes[ot]+"]"+sObjects[i][1]+" - "+sObjects[i][0]%>";
		availableNameList[availableNameList.length]="<%=sObjectTypes[ot]+"."+sObjects[i][0]%>";
		<%
	}
}
%>
	
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
		

		
		function showAvailableObjects()
		{

			customize.chosen_column_selection.length = 0;
			customize.available_column_selection.options.length = 0;
			
			j=0;
			for (i = 0; i < availableNameList.length; i++)
			{
				eval("customize.available_column_selection.options[" + (j) + "] = new Option(availableCaptionList[" + i + "], availableNameList[" + i + "])");
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
			showAvailableFiles();
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




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	customize.FilePath.value=readCookie("FilePath");
    showAvailableObjects();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
