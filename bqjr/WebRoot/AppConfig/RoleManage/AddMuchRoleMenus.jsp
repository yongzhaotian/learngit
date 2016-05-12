<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<script type="text/javascript">
	var availableRoleNameList = new Array;
	var availableRoleIDList = new Array;
	var selectedRoleNameList = new Array;
	var selectedRoleIDList = new Array;
<%
	String queryStr = " SELECT RoleID,RoleName FROM AWE_ROLE_INFO WHERE length(RoleID)>1 and RoleStatus = '1' order by SortNo";
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject(queryStr));
	int num = 0;
	while(rs.next()){
		String roleID = rs.getString("RoleID");
		String roleName = rs.getString("RoleName");
		String displayName = roleID +"   "+roleName;
		out.println("availableRoleNameList[" + num + "] = '" + displayName + "';\r");
		out.println("availableRoleIDList[" + num + "] = '" + roleID + "';\r");
		num++;
	}
	rs.getStatement().close();
%>
</script>
<head>
	<title>主菜单角色授权</title>
</head>
<body bgcolor="#E4E4E4" scroll="no">
<form name="chooseform">
<table align="center" width="100%">
	<tr>
		<td width='50%'>
			<table width='100%' border='1' cellpadding='0' cellspacing='5' bgcolor='#DDDDDD'>
				<tr>
					<td colspan="2"><span>选取要配置的角色</span></td>
				</tr>
				<tr>
					<td colspan="2" bgcolor='#DDDDDD'><span class='dialog-label'>可配置的角色列表</span></td>
				</tr>
				<tr>
					<td colspan="2" align='center'>
						<select name='role_available' onchange='selectionChanged(document.forms["chooseform"].elements["role_available"],document.forms["chooseform"].elements["role_chosen"]);' size='12' style='width:100%;' multiple='true'> 
						</select>
					</td>
				</tr>
				<tr>
					<td align='right' valign='middle' bordercolor='#DDDDDD'>
						<%=HTMLControls.generateButton("▼","移入","javascript:moveSelected(document.forms['chooseform'].elements['role_available'],document.forms['chooseform'].elements['role_chosen']);updateHiddenChooserField(document.forms['chooseform'].elements['role_chosen'],document.forms['chooseform'].elements['report']);",sResourcesPath)%>
					</td>
					<td width='32' align='center' valign='middle' bordercolor='#DDDDDD'>
						<%=HTMLControls.generateButton("▲","移出","javascript:moveSelected(document.forms['chooseform'].elements['role_chosen'],document.forms['chooseform'].elements['role_available']);updateHiddenChooserField(document.forms['chooseform'].elements['role_chosen'],document.forms['chooseform'].elements['report']);",sResourcesPath)%>
					</td>
				</tr>
				<tr>
					<td colspan="2" bgcolor='#DDDDDD'><span class='dialog-label'>将配置的角色列表</span></td>
				</tr>
				<tr>
					<td colspan="2" align='center'>
						<select name='role_chosen' onchange='selectionChanged(document.forms["chooseform"].elements["role_chosen"],document.forms["chooseform"].elements["role_available"]);' size='12' style='width:100%;' multiple='true'>
						</select>
						<input type='hidden' name='report' value=''>
					</td>
				</tr>
			</table>
		</td>
		<td width='50%'>
			<table width='100%' border='1' cellpadding='0' cellspacing='0' bgcolor='#DDDDDD'>
				<tr>
					<td colspan="1"><span>选取要配置的菜单</span></td>
				</tr>
				<tr>
					<td id="myleft" colspan='3' align=center width=100%>
						<div style="positition:absolute;align:left;height:510px;overflow-y: hide;">
							<iframe name="left" src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0 scrolling=no ></iframe>
						</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
		<table>
			<tr>
				<td>
					<span>选取配置方式：</span>
				</td>
				<td>
					<select name="configtype">
						<option selected value='1' >增量配置</option>
						<option value='2' >覆盖配置</option>
					</select>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr height=1>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan=4>
			<table width="100%">
				<tr>
					<td width="25%" align="right">
					<%=HTMLControls.generateButton("&nbsp;恢&nbsp;复&nbsp;","恢复","javascript:doDefault();",sResourcesPath)%></td>
					<td width="25%" align="center">
					<%=HTMLControls.generateButton("&nbsp;确&nbsp;定&nbsp;","确定","javascript:doConfig();",sResourcesPath)%></td>
					<td width="25%" align="left">
					<%=HTMLControls.generateButton("&nbsp;取&nbsp;消&nbsp;","取消","javascript:self.returnValue='_none_';self.close();",sResourcesPath)%></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
<script type="text/javascript">
	function cloneOption(option){
		var out = new Option(option.text,option.value);
		out.selected = option.selected;
		out.defaultSelected = option.defaultSelected;
		return out;
	}
	
	function moveSelected(from,to){
		newTo = new Array();
		for(i=0; i<to.options.length; i++){
			newTo[newTo.length] = cloneOption(to.options[i]);
			newTo[newTo.length-1].selected = false;
		}
		
		for(i=0; i<from.options.length; i++){
			if (from.options[i].selected){
				newTo[newTo.length] = cloneOption(from.options[i]);
				from.options[i] = null;
				i--;
			}
		}
		to.options.length = 0;
		for(i=0; i<newTo.length; i++){
			to.options[to.options.length] = newTo[i];
		}
		selectionChanged(to,from);
	}
   
	function updateHiddenChooserField(chosen,hidden){
		hidden.value='';
		var opts = chosen.options;
		for(var i=0; i<opts.length; i++){
			hidden.value = hidden.value + opts[i].value+'\n';
		}
	}
   
	function selectionChanged(selectedElement,unselectedElement){
		for(var i=0; i<unselectedElement.options.length; i++){
			unselectedElement.options[i].selected=false;
		}
		form = selectedElement.form;
	}
   
	function doConfig(){
		var configType = chooseform.configtype.value; //配置方式
		var configTypeName = "增量配置";
		if(configType !="1") configTypeName = "覆盖配置";
		
   		if(chooseform.role_chosen.length == 0){
   			alert("请选择要配置的角色！");
   			return;
   		}
   		
   		var vReturn = "";
   		for(var i=0; i<chooseform.role_chosen.length;i++ ){
   			var vTemp = chooseform.role_chosen.options[i].value;
               vReturn += vTemp+"@";
   		}
   		
   		var nodes = getCheckedTVItems(); //树图标识的节点
   		if(nodes.length == 0){
   			alert("请选择要配置的菜单！");
   			return;
   		}
   		
   		var vReturn1 = "";
   		for(var i=0;i<nodes.length;i++){
   			vReturn1 += nodes[i].id + "@";
   		}
   		
		if(confirm("您确定以【"+configTypeName+"】方式给所选的角色授权主菜单吗？")){
    		var sReturn = RunJavaMethodSqlca("com.amarsoft.app.awe.config.role.action.AddMuchRoleMenusAction","addMuchRoleMenus","ConfigType="+configType+",RoleIDs="+vReturn+",MenuIDs="+vReturn1);
			if(sReturn =="SUCCEEDED"){
				alert("批量配置下属菜单成功！");
			}else{
				alert("批量配置下属菜单失败！");
			}
			top.close();
	    }
	}
	
	function doDefault(){
		chooseform.role_available.options.length = 0;
		chooseform.role_chosen.options.length = 0;
		var j = 0;
		for(var i = 0; i < availableRoleIDList.length; i++){
			eval("chooseform.role_available.options[" + j + "] = new Option(availableRoleNameList[" + i + "], availableRoleIDList[" + i + "])");
			j++;
		}
		
		j = 0;
	}
	
	function startMenu(){
	<%
		HTMLTreeView tviTemp = new HTMLTreeView("角色授权菜单","right");
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		tviTemp.MultiSelect = true;
		tviTemp.initWithSql("MenuID","MenuName","MenuID","","from AWE_MENU_INFO where IsInUse='1'",Sqlca);
		out.println(tviTemp.generateHTMLTreeView());
	%>
	}
	
	startMenu();
	expandNode('root');
	doDefault();
</script>
<%@ include file="/IncludeEnd.jsp"%>