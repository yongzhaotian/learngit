<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.app.als.sadre.widget.Describes"%>
<%@page import="com.amarsoft.sadre.app.misc.*"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: ѡ���ѯ���Ҫ��ʾ��������
		Input Param:
			--type��
			--iniString�������б�ֵ
		Output Param:
			
		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>

<script language="javascript">
<%

	//���ҳ����������͡��������ơ�������ʾֵ
	String type       = DataConvert.toString(CurPage.getParameter("type"));
	String iniString  = SpecialTools.amarsoft2Real(CurPage.getParameter("iniString"));
	if(iniString==null) iniString = "";
	ARE.getLog().debug("type="+type);
	ARE.getLog().debug("iniString="+iniString);
		
	//----------��ѡ���ѡ��õ�Ԥ����
	String[] arraySelected = iniString.split(",");	
	Set selectedItem = new HashSet();
	for(int i=0; i<arraySelected.length; i++){
		selectedItem.add(arraySelected[i]);			//����Set�б�����߲���Ч��
	}
	
%>

</script>
<%/*~END~*/%>
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
<tr>
	<td align='center' width="40%">
		<select name='available_column_selection' 
			onchange='selectionChanged(document.forms["customize"].elements["available_column_selection"],document.forms["customize"].elements["chosen_column_selection"]); ' 
			size='18'  style='width:100%;' multiple='multiple'> 
		</select>
	</td>
	<td align='center' valign='middle'  bordercolor='#DDDDDD' width="10%">
		<%//=new Button(">>","����","javascript:moveSelected(document.forms['customize'].elements['available_column_selection'],document.forms['customize'].elements['chosen_column_selection']); updateHiddenChooserField(document.forms['customize'].elements['chosen_column_selection'],document.forms['customize'].elements['column_selection']);").getHtmlText() %>
		<input type="button" id="toRight" value=" &gt;&gt; " alt="����" onclick="javascript:moveSelected(document.forms['customize'].elements['available_column_selection'],document.forms['customize'].elements['chosen_column_selection']); updateHiddenChooserField(document.forms['customize'].elements['chosen_column_selection'],document.forms['customize'].elements['column_selection']);"/>
		<br><br>
	    <%//=new Button("<<","����","javascript:moveSelected(document.forms['customize'].elements['chosen_column_selection'],document.forms['customize'].elements['available_column_selection']); updateHiddenChooserField(document.forms['customize'].elements['chosen_column_selection'],document.forms['customize'].elements['column_selection']);").getHtmlText() %>
	    <input type="button" id="toLeft" value=" &lt;&lt; " alt="����" onclick="javascript:moveSelected(document.forms['customize'].elements['chosen_column_selection'],document.forms['customize'].elements['available_column_selection']); updateHiddenChooserField(document.forms['customize'].elements['chosen_column_selection'],document.forms['customize'].elements['column_selection']);"/>
	</td>
	<td align='center' width="40%">
		<select name='chosen_column_selection' onchange='selectionChanged(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["available_column_selection"]); ' 
			size='18'  style='width:100%;' multiple='multiple' >
		</select>
		<input type='hidden' name='column_selection' value=''>
	</td>
	<td align='center' valign='middle' bordercolor='#DDDDDD' width="10%">
		<%//=new Button(" �� ","����","javascript:shiftSelected(document.forms['customize'].elements['chosen_column_selection'],-1); updateHiddenChooserField(document.forms['customize'].elements['chosen_column_selection'],document.forms['customize'].elements['column_selection']);").getHtmlText() %>
		<input type="button" id="toUp" value="��" alt="����" onclick="javascript:shiftSelected(document.forms['customize'].elements['chosen_column_selection'],-1); updateHiddenChooserField(document.forms['customize'].elements['chosen_column_selection'],document.forms['customize'].elements['column_selection']);"/>
		<br><br>
        <%//=new Button(" �� ","����","javascript:shiftSelected(document.forms['customize'].elements['chosen_column_selection'],1); updateHiddenChooserField(document.forms['customize'].elements['chosen_column_selection'],document.forms['customize'].elements['column_selection']);").getHtmlText() %>
        <input type="button" id="toDown" value="��" alt="����" onclick="javascript:shiftSelected(document.forms['customize'].elements['chosen_column_selection'],1); updateHiddenChooserField(document.forms['customize'].elements['chosen_column_selection'],document.forms['customize'].elements['column_selection']);"/>
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
                         <input type="button" id="confirm" value="&nbsp;ȷ&nbsp;��&nbsp;" alt="ȷ��" onclick="javascript:doQuery();"/>
                    <td width="10%" align="center">
                         <input type="button" id="cancle" value="&nbsp;ȡ&nbsp;��&nbsp;" alt="ȡ��" onclick="javascript:doCancel();"/>
                    <td width="10%" align="left">
				         <input type="button" id="clear" value="&nbsp;��&nbsp;��&nbsp;" alt="���" onclick="javascript:doClear();"/>
				</tr>
			</table>
		</td>
	</tr>
</table>

</body>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script language="JavaScript">
	var objForm = document.forms["customize"];
	var elmChsn = objForm.elements["chosen_column_selection"];
	var elmAvlb = objForm.elements["available_column_selection"];
    //---------------------���尴ť�¼�--------------------------//
	/*~[Describe=�б��;InputParam=��;OutPutParam=��;]~*/
	function cloneOption(option) 
	{
	  var out = new Option(option.text,option.value);
	  out.selected = option.selected;
	  out.defaultSelected = option.defaultSelected;
	  out.title=option.title;
	  return out;
	}
    
	/*~[Describe=ѡ����;InputParam=��;OutPutParam=��;]~*/
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
	
	/*~[Describe=�ƶ�ѡ��;InputParam=��;OutPutParam=��;]~*/
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

	/*~[Describe=ѡ��ı�;InputParam=��;OutPutParam=��;]~*/
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
	
	/*~[Describe=��ť����;InputParam=��;OutPutParam=��;]~*/
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
	
	/*~[Describe=���°�ť;InputParam=��;OutPutParam=��;]~*/
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
	
	/*~[Describe=ȡ��;InputParam=��;OutPutParam=��;]~*/
	function doCancel()
	{	
		self.returnValue="_CANCEL_";
		self.close();
	}
	
	/*~[Describe=ȷ��;InputParam=��;OutPutParam=��;]~*/			
	function doQuery()
	{
		if(elmChsn.length == 0){
			alert("��ѡ��Ҫ�ֶ��б�");
			return;
		}
		
		var selectedId   = "";
		var selectedName = "";
		var vReportCount = elmChsn.length;
		
		for(var i=0; i<vReportCount;i++ ){
			var vId = elmChsn.options[i].value;
			var vName= elmChsn.options[i].text;
			selectedId += (i==0?"":",")+vId;			//��һ��Ԫ�ز���ӷָ���
			selectedName += (i==0?"":",")+vName;		//
		}
		
		self.returnValue=(selectedId+"@"+selectedName);
		self.close();
	}
	
	
	var selectedCaptionList  = new Array;
	var selectedNameList 	 = new Array;
	var availableCaptionList = new Array;
	var availableNameList 	 = new Array;
<%
	
	String sItemId = "";
	String sItemName = "";
	
	DescElement element = Describes.getElement(type, Sqlca);
	List valueList = element.getValueList(CurPage);
	if(valueList!=null){
		//default items display 
		int countAvlb = 0;
		int countSltd = 0;
		Iterator tk = valueList.iterator();
		while(tk.hasNext()){
			//sItemId 	= (String)tk.next();				//ItemId
			//sItemName 	= (String)valueList.get(sItemId);	//ItemName
			SelectOption tmpOption = (SelectOption)tk.next();
			sItemId 	= tmpOption.getId();			//ItemId
			sItemName 	= tmpOption.getValue();			//ItemName
			
			if(selectedItem.contains(sItemId)){		//����Ѿ�����,�����������֣�����������
				out.println("selectedCaptionList[" + countSltd + "] = '" + sItemName + "';");
				out.println("selectedNameList[" + countSltd + "] = '" + sItemId + "';");
				
				//---------------��������ѡ��htmlԪ��
				out.println("eval(\"elmChsn.options[" + countSltd + "] = new Option('"+sItemName+"','"+sItemId+"')\");");
				if(tmpOption.getTitle().length()>0) out.println("eval(\"elmChsn.options[" + countSltd + "].title='"+tmpOption.getTitle()+"'\");");
				//---------------End
				countSltd++;
				continue;
			}
			
			out.println("availableCaptionList[" + countAvlb + "] = '" + sItemName + "';");
			out.println("availableNameList[" + countAvlb + "] = '" + sItemId + "';");
			
			//---------------��������ѡ��htmlԪ��
			out.println("eval(\"elmAvlb.options[" + countAvlb + "] = new Option('"+sItemName+"','"+sItemId+"')\");");
			if(tmpOption.getTitle().length()>0) out.println("eval(\"elmAvlb.options[" + countAvlb + "].title='"+tmpOption.getTitle()+"'\");");
			//---------------End
			countAvlb++;
		}
	}
%>
	
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
