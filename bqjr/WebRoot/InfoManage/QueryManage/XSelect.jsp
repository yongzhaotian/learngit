<%@ page import="com.amarsoft.xquery.*,org.w3c.dom.*"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	/*
		Describe: ѡ���ѯ���Ҫ��ʾ��������
		Input Param:
			--type�����Ͷ���ΪAll
			--nametype:�������� ����Ϊ2
			--iniString�������б�ֵ
	 */
%>
<script type="text/javascript">
	selectedCaptionList = new Array;
	selectedNameList = new Array;
	availableCaptionList = new Array;
	availableNameList = new Array;
<%
   //�������
	String listItem[];//--�б�������ʾ����
	String name,value;//--��ʾ���ơ���ʾֵ
	String num;//--������
	int columnsLength;//--�г���
	String scope="";//--��Χ
	String header[][];//--ͷ����
	boolean needScope = false;//--�����ͱ���
	boolean needCheckInitString = false;//--�����ͱ���
	
	String columns[]=new String[1];//--������
	//���ҳ����������͡��������ơ�������ʾֵ
	XQuery query      = new XQuery((String)session.getAttribute("xmlPath"),(String)session.getAttribute("queryType"));
	String type       = DataConvert.toRealString(iPostChange,CurPage.getParameter("type"));
	String nametype   = DataConvert.toRealString(iPostChange,CurPage.getParameter("nametype"));
	String iniString  = DataConvert.toRealString(iPostChange,CurPage.getParameter("iniString"));
	String disableString  = DataConvert.toRealString(iPostChange,CurPage.getParameter("disableString"));
	if(iniString==null) iniString="";
	if(disableString==null) disableString="";
	Vector list = query.getAllColumnsList();
	if(iniString.trim().length()!=0){
		columns = StringFunction.toStringArray(iniString,"|");
		needCheckInitString = true; 
		for(int i=0; i<columns.length; i++){
			num = (new Integer(i)).toString();	
			out.println("availableNameList["+num+"]='"+columns[i]+"';"+"\r");	
		}
	}
	if((request.getParameter("scope")!=null)&&!request.getParameter("scope").equals("*")){
		scope  = DataConvert.toRealString(iPostChange,CurPage.getParameter("scope"));
		needScope = true;	
	}
	
	int j=0;
	int k=0;
	
	for(int i=0; i<list.size(); i++){
		listItem = (String[])list.get(i);
		name = listItem[1]+"- "+listItem[5];

		if(nametype=="2"){
			value = listItem[8];	
		}else{
			value = listItem[7];
		}

		if(StringFunction.getOccurTimesIgnoreCase(listItem[6],type)>0||type.equalsIgnoreCase("all")){
			if((!needScope&&disableString.indexOf(listItem[3])<0)||StringFunction.getOccurTimesIgnoreCase(scope,value.replaceAll(" as "+listItem[4],""))>0){
				if(needCheckInitString&&StringFunction.getOccurTimesIgnoreCase(iniString,value.replaceAll(" as "+listItem[4],""))>0){
					for(int s=0; s<columns.length; s++){
						num = (new Integer(s)).toString();
						if(value.trim().equals(columns[s].trim())){
							out.println("availableCaptionList["+num+"]='"+name+"';"+"\r");	
						}
					}
				}else{
					num = (new Integer(j)).toString();		
					out.println("selectedCaptionList["+num+"]='"+name+"';"+"\r");
					out.println("selectedNameList["+num+"]='"+value+"';"+"\r");	
					j=j+1;	
				}
			}
		}
	}
	out.println("</script>");
%>
</script>
<html>
<head>
<meta http-equiv='Expires' content='-10'>
<meta http-equiv='Pragma'  content='No-cache'>
<meta http-equiv='Cache-Control', 'private'>
<meta http-equiv="Expires" content="-10">
<meta http-equiv="Pragma" content="No-cache">
<meta http-equiv="Cache-Control", "private">
<title>�ֶ�ѡ����</title>
</head>
<body leftmargin="0" topmargin="0">
<table border='0'  cellpadding='0' cellspacing='4' width='100%' bgcolor='#FFFFFF' align='center'>
	<tr><td width='100%' colspan='2'>
	<form method='POST'  name='customize'>
	<input type='hidden' name='initialString' value='<%=SpecialTools.amarsoft2Real(request.getParameter("iniString"))%>'>
	<table width='100%' border='1' cellpadding='0' cellspacing='8' bgcolor='#DDDDDD'>
		<tr>
			<td bgcolor='#DDDDDD'>
				<span class='dialog-label'>&nbsp;��ѡȡ�ֶ��б�</span>
			</td>
			<td bordercolor='#DDDDDD'>
			</td>
			<td bgcolor='#DDDDDD'>
				<span class='dialog-label'>&nbsp;��ѡȡ�ֶ��б�</span>
			</td>
			<td>
			</td>
		</tr>
		<tr><td align='center' width="48%">
			<select name='available_column_selection' onchange='selectionChanged(document.forms["customize"].elements["available_column_selection"],document.forms["customize"].elements["chosen_column_selection"]); ' size='13'  style='width:100%;' width='100%' multiple='true'> 
			</select>
			</td>
			<td align='center' valign='middle'  bordercolor='#DDDDDD'>
			<img border='0' src='<%=sResourcesPath%>/chooser_orange/arrowRight_disabled.gif'alt='Add selected items' onmousedown='pushButton("movefrom_available_column_selection",true);'  onmouseup='pushButton("movefrom_available_column_selection",false);'  onmouseout='pushButton("movefrom_available_column_selection",false);'  onclick='moveSelected(document.forms["customize"].elements["available_column_selection"],document.forms["customize"].elements["chosen_column_selection"]); updateHiddenChooserField(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["column_selection"]); ' name='movefrom_available_column_selection' /><br><br><img border='0' src='<%=sResourcesPath%>/chooser_orange/arrowLeft_disabled.gif'alt='Remove selected items' onmousedown='pushButton("movefrom_chosen_column_selection",true);'  onmouseup='pushButton("movefrom_chosen_column_selection",false);'  onmouseout='pushButton("movefrom_chosen_column_selection",false);'  onclick='moveSelected(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["available_column_selection"]); updateHiddenChooserField(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["column_selection"]); ' name='movefrom_chosen_column_selection' /></td>
			<td align='center' width="48%">
			<select name='chosen_column_selection' onchange='selectionChanged(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["available_column_selection"]); ' size='13'  style='width:100%;' width='100%' multiple='true' >
			</select>
			<input type='hidden' name='column_selection' value=''>
			</td>
			<td  width='1' align='center' valign='middle' bordercolor='#DDDDDD'><img border='0' src='<%=sResourcesPath%>/chooser_orange/arrowUp_disabled.gif' alt='Shift selected items down' name='shiftup_chosen_column_selection' onmousedown='pushButton("shiftup_chosen_column_selection",true);'  onmouseup='pushButton("shiftup_chosen_column_selection",false);'  onmouseout='pushButton("shiftup_chosen_column_selection",false);'  onclick='shiftSelected(document.forms["customize"].elements["chosen_column_selection"],-1); updateHiddenChooserField(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["column_selection"]);' /><br><br><img border='0' src='<%=sResourcesPath%>/chooser_orange/arrowDown_disabled.gif' alt='Shift selected items up' name='shiftdown_chosen_column_selection' onmousedown='pushButton("shiftdown_chosen_column_selection",true);'  onmouseup='pushButton("shiftdown_chosen_column_selection",false);'  onmouseout='pushButton("shiftdown_chosen_column_selection",false);'  onclick='shiftSelected(document.forms["customize"].elements["chosen_column_selection"],1); updateHiddenChooserField(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["column_selection"]);' /></td>
		</tr>
	</table>
	</form>
	</td></tr>
  	<tr>
    	<td align='right'>
        <input type="button" style="width:70px"  value="ȷ ��" onclick="javascript:doQuery();">	
        <input type="button" style="width:70px"  value="ȡ ��" onclick="javascript:doCancel();">
        <input type="button" style="width:70px"  value="�� ��" onclick="javascript:doDefault();">	   
    	</td>
  	</tr>
</table>
</body>
<script type="text/javascript">
	/*~[Describe=�б��;]~*/
	function cloneOption(option){
	  var out = new Option(option.text,option.value);
	  out.selected = option.selected;
	  out.defaultSelected = option.defaultSelected;
	  return out;
	}
	/*~[Describe=ѡ����;]~*/
 	function shiftSelected(chosen,howFar){
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
	/*~[Describe=�ƶ�ѡ��;]~*/
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

	/*~[Describe=ѡ��ı�;]~*/
	function selectionChanged(selectedElement,unselectedElement) {
	  for(i=0; i<unselectedElement.options.length; i++) {
	    unselectedElement.options[i].selected=false;
	  }
	  form = selectedElement.form; 
	  enableButton("movefrom_"+selectedElement.name, (selectedElement.selectedIndex != -1));
	  enableButton("movefrom_"+unselectedElement.name, (unselectedElement.selectedIndex != -1));
	  enableButton("shiftdown_"+selectedElement.name, (selectedElement.selectedIndex != -1));
	  enableButton("shiftup_"+selectedElement.name, (selectedElement.selectedIndex != -1));
	  enableButton("shiftdown_"+unselectedElement.name, (unselectedElement.selectedIndex != -1));
	  enableButton("shiftup_"+unselectedElement.name, (unselectedElement.selectedIndex != -1));
	}
	/*~[Describe=��ť����;]~*/
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
	/*~[Describe=���°�ť;]~*/
	function pushButton(buttonName,push) {
		var img = document.images[buttonName]; 
		if (img == null) return; 
		var src = img.src; 
		var und = src.lastIndexOf("_disabled.gif"); 
		if (und != -1) return false; 
		und = src.lastIndexOf("_clicked.gif"); 
		if (und == -1) {
			var gif = src.lastIndexOf(".gif");
			if (push) img.src = src.substring(0,gif)+"_clicked.gif"; 
		}else{
			if (!push) img.src = src.substring(0,und)+".gif"; 
		}
	}
	/*~[Describe=ȡ��;]~*/
	function doCancel(){
		self.returnValue="";
		self.close();
	}
	
	/*~[Describe=֧��ESC�ر�ҳ��;]~*/
	document.onkeydown = function(){
		if(event.keyCode==27){
			doCancel();
		}
	};

	/*~[Describe=ȷ��;]~*/			
	function doQuery(){
		text="";
		value="";
		var sQueryType ="<%=(String)session.getAttribute("queryType")%>";
		for (i=0; i < customize.chosen_column_selection.length; i++){
			id = i+1;
			if (i==0){
				text= ""+id+".   "+customize.chosen_column_selection.options[i].text;
				value= customize.chosen_column_selection.options[i].value;
			}else{
				text= text+"\r"+""+id+".   "+customize.chosen_column_selection.options[i].text;
				value= value+"|"+customize.chosen_column_selection.options[i].value;
			}
		}
	
		returnValue =text+"@"+value;
		self.returnValue=returnValue;
		self.close();
	}

	/*~[Describe=�ָ�;]~*/
	function doDefault(){
		customize.chosen_column_selection.length = 0;
		customize.available_column_selection.options.length = 0;
	
		j=0;
		for (i = 0; i < availableNameList.length; i++){
			eval("customize.chosen_column_selection.options[" + (j) + "] = new Option(availableCaptionList[" + i + "], availableNameList[" + i + "])");
			j=j+1;
		}
		
		j=0;
		for (i = 0; i < selectedNameList.length; i++){
			eval("customize.available_column_selection.options[" + (j) + "] = new Option(selectedCaptionList[" + i + "], selectedNameList[" + i + "])");
			j=j+1;
		}
	}
	
	doDefault();
</script>
<%@ include file="/IncludeEnd.jsp"%>