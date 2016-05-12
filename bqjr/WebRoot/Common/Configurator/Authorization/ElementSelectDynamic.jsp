<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.app.als.sadre.widget.Describes"%>
<%@page import="com.amarsoft.sadre.app.misc.DynamicDescribe"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: 选择查询结果要显示的数据项
		Input Param:
			--type：
			--iniString：分组列表值
		Output Param:
			
		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>


<%
	//获得页面参数，类型、类型名称、分组显示值
	String type       = DataConvert.toString(CurPage.getParameter("type"));
	String iniString  = SpecialTools.amarsoft2Real(CurPage.getParameter("iniString"));
	if(iniString==null) iniString = "";
	ARE.getLog().debug("type="+type);
	ARE.getLog().debug("iniString="+iniString);
	
	//-----------TreeView的初始化
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"选择信息列表","right");
	tviTemp.TriggerClickEvent=true;		
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	
	
	DynamicDescribe element = (DynamicDescribe)Describes.getElement(type, Sqlca);
	tviTemp = element.getRootTree(Sqlca,tviTemp);
	
%>

<%/*~END~*/%>
<html>

<head>
	<meta http-equiv='Expires' content='-10'>
	<meta http-equiv='Pragma'  content='No-cache'>
	<meta http-equiv='Cache-Control', 'private'>
	<meta http-equiv="Expires" content="-10">
	<meta http-equiv="Pragma" content="No-cache">
	<meta http-equiv="Cache-Control", "private">
	<title>字段选择器</title>
	
<script language="javascript">
	function startMenu() 
	{
	<%
		out.println(tviTemp.generateHTMLTreeView());
	%>
		expandNode('root');	
	}
</script>
</head>

<body leftmargin="0" topmargin="0">

<table border='0'  cellpadding='0' cellspacing='4' width='100%' bgcolor='#FFFFFF' align='center'>
<tr><td width='100%' colspan='2'>

<form method='POST'  name='customize'>
<input type='hidden' name='initialString' value='<%=SpecialTools.amarsoft2Real(request.getParameter("iniString"))%>'>
<table width='100%' border='0' cellpadding='0' cellspacing='4' bgcolor='#DDDDDD'>
  <tr>
    <td width="30%">&nbsp;</td>
    <td width="30%">可选取字段列表</td>
    <td width="5%">&nbsp;</td>
    <td width="30%">已选取字段列表</td>
    <td width="5%">&nbsp;</td>
  </tr>
<tr>
	<td bgcolor="#FFFFFF">
	<div id="TreeDiv" style="height:280px;width:180px;overflow:scroll;"><iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe></div>
	</td>
	<td align='center'>
		<select name='available_column_selection' 
			onchange='selectionChanged(document.forms["customize"].elements["available_column_selection"],document.forms["customize"].elements["chosen_column_selection"]); ' 
			size='18'  style='width:100%;' multiple='multiple'> 
		</select>
	</td>
	<td align='center' valign='middle'  bordercolor='#DDDDDD'>
		<input type="button" id="toRight" value=" &gt;&gt; " alt="右移" onclick="javascript:moveSelected(document.forms['customize'].elements['available_column_selection'],document.forms['customize'].elements['chosen_column_selection']); updateHiddenChooserField(document.forms['customize'].elements['chosen_column_selection'],document.forms['customize'].elements['column_selection']);"/>
		<br><br>
		<input type="button" id="toLeft" value=" &lt;&lt; " alt="左移" onclick="javascript:moveSelected(document.forms['customize'].elements['chosen_column_selection'],document.forms['customize'].elements['available_column_selection']); updateHiddenChooserField(document.forms['customize'].elements['chosen_column_selection'],document.forms['customize'].elements['column_selection']);"/>
	</td>
	<td align='center'>
		<select name='chosen_column_selection' onchange='selectionChanged(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["available_column_selection"]); ' 
			size='18'  style='width:100%;' multiple='multiple' >
		</select>
		<input type='hidden' name='column_selection' value=''>
	</td>
	<td align='center' valign='middle' bordercolor='#DDDDDD'>
		<input type="button" id="toUp" value="▲" alt="上移" onclick="javascript:shiftSelected(document.forms['customize'].elements['chosen_column_selection'],-1); updateHiddenChooserField(document.forms['customize'].elements['chosen_column_selection'],document.forms['customize'].elements['column_selection']);"/>
		<br><br>
        <input type="button" id="toDown" value="▼" alt="下移" onclick="javascript:shiftSelected(document.forms['customize'].elements['chosen_column_selection'],1); updateHiddenChooserField(document.forms['customize'].elements['chosen_column_selection'],document.forms['customize'].elements['column_selection']);"/>
	</td>
	</tr>
</table>
</form>
	</td>
	</tr>

  <tr height=1>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan=4 width="100%" >
			<table>
				<tr >
                    <td width="70%" align="right">
                         <input type="button" id="confirm" value="&nbsp;确&nbsp;定&nbsp;" alt="确定" onclick="javascript:doQuery();"/>
                    <td width="10%" align="center">
                         <input type="button" id="cancle" value="&nbsp;取&nbsp;消&nbsp;" alt="取消" onclick="javascript:doCancel();"/>
                    <td width="10%" align="left">
				         <input type="button" id="clear" value="&nbsp;清&nbsp;空&nbsp;" alt="清空" onclick="javascript:doClear();"/>
				</tr>
			</table>
		</td>
	</tr>
</table>

</body>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script language="JavaScript">
	var objForm = document.forms["customize"];
	var elmChsn = objForm.elements["chosen_column_selection"];
	var elmAvlb = objForm.elements["available_column_selection"];

	function TreeViewOnClick()
	{		
		var sType = getCurTVItem().type;
		if(sType == "root")
		{
			buff.ReturnString.value = "root";
		}else
		{
			if(sType == "page")
			{
				var sSelected = getSelectedElements(); 
				var sValue = getCurTVItem().value;
				var sChildren = RunMethod("PublicMethod","AuthorSubSelection","<%=type%>,"+sValue+","+sSelected);
				if(typeof sChildren != 'undefined'){
					clearSubSelection();
					eval(sChildren);
				}

			}else
			{
				alert("页节点信息不能选择，请重新选择！");
			}
		}
	}
	
	function getSelectedElements(){		//获取已经选择的选项
		var selectedVar = "";
		var opts = elmChsn.options;
		for(var i=0; i<opts.length; i++){
			if(i==0){
				selectedVar += opts[i].value;
			}else{
				selectedVar += ","+opts[i].value;
			}
		}
		return escape(selectedVar);
	}
    function clearSubSelection(){
    	var opts = elmAvlb.options;
    	if(opts.length>0) opts.length=0 ;
    }

  	//---------------------定义按钮事件--------------------------
    
	/*~[Describe=列表框;InputParam=无;OutPutParam=无;]~*/
	function cloneOption(option) 
	{
	  var out = new Option(option.text,option.value);
	  out.selected = option.selected;
	  out.defaultSelected = option.defaultSelected;
	  out.title=option.title;
	  return out;
	}
    
	/*~[Describe=选择列;InputParam=无;OutPutParam=无;]~*/
 	function shiftSelected(chosen,howFar) 
 	{
		var opts = chosen.options;
		var newopts = new Array(opts.length);
		var start; var end; var incr;
		if (howFar > 0) {
		  start = 0; end = newopts.length; incr = 1; 
		} else {
		  start = newopts.length - 1; end = -1; incr = -1; 
		}
		for(var sel=start; sel != end; sel+=incr) {
		  if (opts[sel].selected) {
		    setAtFirstAvailable(newopts,cloneOption(opts[sel]),sel+howFar,-incr);
		  }
		}
		for(var uns=start; uns != end; uns+=incr) {
		  if (!opts[uns].selected) {
		    setAtFirstAvailable(newopts,cloneOption(opts[uns]),start,incr);
		  }
		}
		 opts.length = 0;   for(i=0; i<newopts.length; i++) {
		  opts[opts.length] = newopts[i]; 
		}
	}
	
	function setAtFirstAvailable(array,obj,startIndex,incr) {
	  if (startIndex < 0) startIndex = 0;
	  if (startIndex >= array.length) startIndex = array.length -1;
	  for(var xxx=startIndex; xxx>= 0 && xxx<array.length; xxx += incr) {
	    if (array[xxx] == null) {
	      array[xxx] = obj; 
	      return; 
	    }
	  }
	}
	
	/*~[Describe=移动选择;InputParam=无;OutPutParam=无;]~*/
	function moveSelected(from,to) {
	  newTo = new Array();
	  for(i=0; i<to.options.length; i++) {
	    newTo[newTo.length] = cloneOption(to.options[i]);
	    newTo[newTo.length-1].selected = false;
	  }
	  
	  for(i=0; i<from.options.length; i++) {
	    if (from.options[i].selected) {
	      newTo[newTo.length] = cloneOption(from.options[i]);
	      from.options[i] = null;
	      i--;
	    }
	  }
	  
	  to.options.length = 0;
	  for(i=0; i<newTo.length; i++) {
	    to.options[to.options.length] = newTo[i];
	  }
	  selectionChanged(to,from);
	}

	function updateHiddenChooserField(chosen,hidden) {
	  hidden.value='';
	  var opts = chosen.options;
	  for(var i=0; i<opts.length; i++) {
	    hidden.value = hidden.value + opts[i].value+'\n';
	  }
	  
	}

	/*~[Describe=选择改变;InputParam=无;OutPutParam=无;]~*/
	function selectionChanged(selectedElement,unselectedElement) {
	  for(i=0; i<unselectedElement.options.length; i++) {
	    unselectedElement.options[i].selected=false;
	  }
	  form = selectedElement.form; 
	  enableButton("movefrom_"+selectedElement.name,(selectedElement.selectedIndex != -1));
	  enableButton("movefrom_"+unselectedElement.name,(unselectedElement.selectedIndex != -1));
	  enableButton("shiftdown_"+selectedElement.name,(selectedElement.selectedIndex != -1));
	  enableButton("shiftup_"+selectedElement.name,(selectedElement.selectedIndex != -1));
	  enableButton("shiftdown_"+unselectedElement.name,(unselectedElement.selectedIndex != -1));
	  enableButton("shiftup_"+unselectedElement.name,(unselectedElement.selectedIndex != -1));
	}
	
	/*~[Describe=按钮可用;InputParam=无;OutPutParam=无;]~*/
	function enableButton(buttonName,enable) {
	  var img = document.images[buttonName]; 
	  if (img == null) return; 
	  var src = img.src; 
	  var und = src.lastIndexOf("_disabled.gif"); 
	  if (und != -1) { 
	    if (enable) img.src = src.substring(0,und)+".gif"; 
	  } else { 
	    if (!enable) {
	      var gif = src.lastIndexOf("_clicked.gif"); 
	      if (gif == -1) gif = src.lastIndexOf(".gif"); 
	      img.src = src.substring(0,gif)+"_disabled.gif";
	    }
	  }
	}
	
	/*~[Describe=按下按钮;InputParam=无;OutPutParam=无;]~*/
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
		}else 
		{ 
			if (!push) img.src = src.substring(0,und)+".gif"; 
		}
	}
	
	function doClear(){
		self.returnValue="_CLEAR_";
		self.close();
	}
	
	/*~[Describe=取消;InputParam=无;OutPutParam=无;]~*/
	function doCancel()
	{	
		self.returnValue="_CANCEL_";
		self.close();
	}
	
	/*~[Describe=确定;InputParam=无;OutPutParam=无;]~*/			
	function doQuery()
	{
		if(elmChsn.length == 0){
			alert("请选择要字段列表！");
			return;
		}
		
		var selectedId   = "";
		var selectedName = "";
		var vReportCount = elmChsn.length;
		
		for(var i=0; i<vReportCount;i++ ){
			var vId = elmChsn.options[i].value;
			var vName= elmChsn.options[i].text;
			selectedId += (i==0?"":",")+vId;			//第一个元素不添加分隔符
			selectedName += (i==0?"":",")+vName;		//
		}
		
		self.returnValue=(selectedId+"@"+selectedName);
		self.close();
	}
	
	
	var selectedCaptionList  = new Array;
	var selectedNameList 	 = new Array;
<%
	//----------已选择的选项得的预处理
	String[] arraySelected = iniString.split(",");	
	int countSltd = 0;
	for(int i=0; i<arraySelected.length; i++){
		if(arraySelected[i]==null || arraySelected[i].length()==0) continue;
		
		String sItemName = element.getName(arraySelected[i]);
		out.println("selectedCaptionList[" + countSltd + "] = '" + sItemName + "';");
		out.println("selectedNameList[" + countSltd + "] = '" + arraySelected[i] + "';");
		
		//---------------生成下拉选项html元素
		out.println("eval(\"elmChsn.options[" + countSltd + "] = new Option('"+sItemName+"','"+arraySelected[i]+"')\");");
		//---------------End
		countSltd++;
	}
%>

	startMenu();
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
