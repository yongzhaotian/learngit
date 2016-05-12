<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:kfb 2005-03-10
 * Tester:
 *
 * Content: 选择查询结果要显示的数据项
 * Input Param:
 *
 * Output param:
 *
 * History Log: 
 *              
 */ 
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<script type="text/javascript">
selectedCaptionList = new Array;
selectedNameList = new Array;
availableCaptionList = new Array;
availableNameList = new Array;




</script>

<html>

<head>
<meta http-equiv='Expires' content='-10'>
<meta http-equiv='Pragma'  content='No-cache'>
<meta http-equiv='Cache-Control', 'private'>
<meta http-equiv="Expires" content="-10">
<meta http-equiv="Pragma" content="No-cache">
<meta http-equiv="Cache-Control", "private">
<title></title>
</head>
<%

	String sRoleID         =request.getParameter("RoleID");
	String sUserID         =request.getParameter("UserID");
	String sToUserID      =request.getParameter("ToUserID");
	String sFromOrgID    =request.getParameter("FromOrgID");
	
	
	String sAction = DataConvert.toRealString(iPostChange,(String)request.getParameter("Action"));
	String sSql = "";
	String sFlag="False",sRightID="";
	ASResultSet rs = null;

	//角色赋予用户
	if(sAction!=null && sAction.equals("UserRole")){
		sSql = "select a.RoleID as RoleID,b.RoleName as RoleName  from   User_Role a,Role_info b where  a.RoleID = b.RoleID and  a.UserID =:UserID1 "+
		         " and a.RoleID not in (select c.RoleID from User_Role c,Role_info d where  c.RoleID = d.RoleID and  c.UserID =:UserID2) " ;//原来列表框的数据
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("UserID1",sUserID).setParameter("UserID2",sToUserID));
		int num=0;
		while(rs.next()){
			out.println("<script>");
			out.println("selectedCaptionList["+num+"]='"+rs.getString("RoleName")+"';"+"\r");	
			out.println("selectedNameList["+num+"]='"+rs.getString("RoleID")+"';"+"\r");	
			num++;
			out.println("</script>");
		}
		rs.getStatement().close();
		
		sSql = "select a.RoleID as RoleID,b.RoleName as RoleName  from   User_Role a,Role_info b where  a.RoleID = b.RoleID and  a.UserID =:UserID and a.Remark='1' " ;//转换后列表框的数据
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("UserID",sToUserID));
		int inum=0;
		while(rs.next()){
			sRoleID=rs.getString("RoleID");
			if(sRoleID==null)sRoleID="";
			else if(sRoleID.equals("000")){
			    sFlag="True";
			}
			out.println("<script>");
			out.println("availableCaptionList["+inum+"]='"+rs.getString("RoleName")+"';"+"\r");	
			out.println("availableNameList["+inum+"]='"+rs.getString("RoleID")+"';"+"\r");	
			inum++;
			out.println("</script>");
		}
		rs.getStatement().close();
	}
%>

<body leftmargin="0" topmargin="0">
<table border='0'  cellpadding='0' cellspacing='4' width='100%' bgcolor='#FFFFFF' align='center'>
<tr><td width='100%' colspan='2'>

<form method='POST'  name='customize'>
<input type='hidden' name='initialString' value='<%=SpecialTools.amarsoft2Real(request.getParameter("iniString"))%>'>

<table width='100%' border='1' cellpadding='0' cellspacing='8' bgcolor='#DDDDDD'>
<tr>
	<%
	    if(sAction!=null && (sAction.equals("UserRight")||sAction.equals("RoleRight")))
	    {
	%>
	<td bgcolor='#DDDDDD'>
		<span class='dialog-label'>&nbsp;可赋予权限列表</span>
	</td>
	<td bordercolor='#DDDDDD'>
	</td>
	<td bgcolor='#DDDDDD'>
		<span class='dialog-label'>&nbsp;已赋予权限列表</span>
	</td>
	<%
	    }
	    else
	    {
	%>
	<td bgcolor='#DDDDDD'>
		<span class='dialog-label'>&nbsp;可赋予角色列表</span>
	</td>
	<td bordercolor='#DDDDDD'>
	</td>
	<td bgcolor='#DDDDDD'>
		<span class='dialog-label'>&nbsp;已赋予角色列表</span>
	</td>
	<%
	    }
	%>
	
	<td>
	</td>
</tr>
	<tr><td align='center'>
	<select name='available_column_selection' onchange='selectionChanged(document.forms["customize"].elements["available_column_selection"],document.forms["customize"].elements["chosen_column_selection"]); ' size='10'  style='width:100%;' width='100%' multiple='true'> 
	
	</select>
	</td>
	<td align='center' valign='middle'  bordercolor='#DDDDDD'>
	<%if(sFlag.equals("False")){%>
	<img border='0' src='<%=sResourcesPath%>/chooser_orange/arrowRight_disabled.gif'alt='Add selected items' onmousedown='pushButton("movefrom_available_column_selection",true);'  onmouseup='pushButton("movefrom_available_column_selection",false);'  onmouseout='pushButton("movefrom_available_column_selection",false);'  onclick='moveSelected(document.forms["customize"].elements["available_column_selection"],document.forms["customize"].elements["chosen_column_selection"]); updateHiddenChooserField(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["column_selection"]); ' name='movefrom_available_column_selection' /><br><br>
	<%}%>
	<img border='0' src='<%=sResourcesPath%>/chooser_orange/arrowLeft_disabled.gif'alt='Remove selected items' onmousedown='pushButton("movefrom_chosen_column_selection",true);'  onmouseup='pushButton("movefrom_chosen_column_selection",false);'  onmouseout='pushButton("movefrom_chosen_column_selection",false);'  onclick='moveSelected(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["available_column_selection"]); updateHiddenChooserField(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["column_selection"]); ' name='movefrom_chosen_column_selection' />
	</td>
	<td align='center'>
	<select name='chosen_column_selection' onchange='selectionChanged(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["available_column_selection"]); ' size='10'  style='width:100%;' width='100%' multiple='true' >
	</select>
	<input type='hidden' name='column_selection' value=''>
	</td>
	<td  width='1' align='center' valign='middle' bordercolor='#DDDDDD'><img border='0' src='<%=sResourcesPath%>/chooser_orange/arrowUp_disabled.gif' alt='Shift selected items down' name='shiftup_chosen_column_selection' onmousedown='pushButton("shiftup_chosen_column_selection",true);'  onmouseup='pushButton("shiftup_chosen_column_selection",false);'  onmouseout='pushButton("shiftup_chosen_column_selection",false);'  onclick='shiftSelected(document.forms["customize"].elements["chosen_column_selection"],-1); updateHiddenChooserField(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["column_selection"]);' /><br><br><img border='0' src='<%=sResourcesPath%>/chooser_orange/arrowDown_disabled.gif' alt='Shift selected items up' name='shiftdown_chosen_column_selection' onmousedown='pushButton("shiftdown_chosen_column_selection",true);'  onmouseup='pushButton("shiftdown_chosen_column_selection",false);'  onmouseout='pushButton("shiftdown_chosen_column_selection",false);'  onclick='shiftSelected(document.forms["customize"].elements["chosen_column_selection"],1); updateHiddenChooserField(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["column_selection"]);' /></td></tr></table>
	</td></tr>

  <tr>
    <td align='left'>
      
    </td>
    <td align='right'>
      <input type="button" style="width:50px"  value="恢 复" onclick="javascript:doDefault();">
       <input type="button" style="width:50px"  value="确 定" onclick="javascript:doQuery();">		   
      <input type="button" style="width:50px"  value="取 消" onclick="javascript:doCancel();">
    </td>
  </tr>
</table>
</form>
</body>


<script type="text/javascript">

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


function selectionChanged(selectedElement,unselectedElement) {
  for(i=0; i<unselectedElement.options.length; i++) {
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
  } else { 
      if (!push) img.src = src.substring(0,und)+".gif"; 
  }
}

function doCancel(){	
	self.returnValue="";
	window.close();
}

	
			
function doQuery(){
	text="";
	value="";
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
    	
	self.returnValue=text+"@"+value;
    
	sReturn = PopPageAjax("/SystemManage/SynthesisManage/UpdateRoleActionAjax.jsp?Action=<%=StringEscapeUtils.escapeSql(sAction)%>&FromOrgID=<%=StringEscapeUtils.escapeSql(sFromOrgID)%>&ToUserID=<%=StringEscapeUtils.escapeSql(sToUserID)%>&RoleID=<%=StringEscapeUtils.escapeSql(sRoleID)%>&UserID=<%=StringEscapeUtils.escapeSql(sUserID)%>&Value="+value+"&rand="+randomNumber(),"","dialogWidth=35;dialogheight=17;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");

	if (typeof(sReturn)!= "undefined" && sReturn == "TRUE")
	{
	  if(<%=sAction.equals("UserRole")%>)
	  {
	    alert("角色赋予成功！");
	  }else
	  {
	    alert("权限赋予成功！");
	  }
	}else{
		if(<%=sAction.equals("UserRole")%>)
		  {
		    alert("角色赋予失败！");
		  }else
		  {
		    alert("权限赋予失败！");
		  }
	}
	window.close();
	
}


function doDefault(){
	customize.chosen_column_selection.length = 0;
	customize.available_column_selection.options.length = 0;
	
	j=0;
	for (i = 0; i < availableNameList.length; i++)
	{
		eval("customize.chosen_column_selection.options[" + (j) + "] = new Option(availableCaptionList[" + i + "], availableNameList[" + i + "])");
		j=j+1;
	}
	
	j=0;
	for (i = 0; i < selectedNameList.length; i++)
	{
		eval("customize.available_column_selection.options[" + (j) + "] = new Option(selectedCaptionList[" + i + "], selectedNameList[" + i + "])");
		j=j+1;
	}
	
}

doDefault();
</script>


<%@ include file="/IncludeEnd.jsp"%>
