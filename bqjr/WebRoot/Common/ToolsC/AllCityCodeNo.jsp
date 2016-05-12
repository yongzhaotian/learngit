<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<script type="text/javascript">
	var availableRoleNameList = new Array;
	var availableRoleIDList = new Array;
	var selectedRoleNameList = new Array;
	var selectedRoleIDList = new Array;
<%
	/* String queryStr = " SELECT RoleID,RoleName FROM AWE_ROLE_INFO WHERE length(RoleID)>1 and RoleStatus = '1' order by SortNo";
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
	rs.getStatement().close(); */
%>
</script>
<head>
	<title>所有城市选择</title>
</head>
<body bgcolor="#E4E4E4" scroll="no">
<form name="chooseform">
<table align="center" width="100%">
	<tr>
		
		<td width='100%'>
			<table width='100%' border='1' cellpadding='0' cellspacing='0' bgcolor='#DDDDDD'>
				<tr>
					<td colspan="1"><span>选取所要添加的城市</span></td>
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
	
	<tr height=1>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan=4>
			<table width="100%">
				<tr>
					
					<td width="25%" align="right">
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
	
	function inArray(search, array) {
		for (var i in array) {
			if (array[i]==search) {
				return true;
			}
		}
		return false;
	}
   
	function doConfig(){

   		var nodes = getCheckedTVItems(); //树图标识的节点
   		if(nodes.length == 0){
   			alert("请选择要选择的城市！");
   			return;
   		} 
   		
   		var vReturn1 = "";
   		var arryInclude = ['11','12','15','31','50'];
   		for(var i=0;i<nodes.length;i++){
   			var nodeId = nodes[i].id;
   			if (nodeId.length==2 && !inArray(nodeId, arryInclude)) continue;
   			if (nodeId.length==2) nodeId = nodeId + "0000";
   			else if (nodeId.length==4) nodeId = nodeId + "00";
   			vReturn1 += nodeId + "@";
   			//vReturn2 += nodes[i].name + "@";
   		}
   		
   		vReturn1 = vReturn1.replace(/@/g, ",");
   		vReturn1 = vReturn1.substring(0, vReturn1.length-1);
   		self.returnValue=vReturn1;
   		
	    top.close();
	}
	
	function doDefault(){
		/* chooseform.role_available.options.length = 0;
		chooseform.role_chosen.options.length = 0;
		var j = 0;
		for(var i = 0; i < availableRoleIDList.length; i++){
			eval("chooseform.role_available.options[" + j + "] = new Option(availableRoleNameList[" + i + "], availableRoleIDList[" + i + "])");
			j++;
		}
		
		j = 0; */
	
	}
	
	function startMenu(){
	<%
		HTMLTreeView tviTemp = new HTMLTreeView("角色授权菜单","right");
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		tviTemp.MultiSelect = true;
		tviTemp.initWithSql("SortNo","ItemName","SortNo","","from code_library where codeno='AreaCode' and isinuse='1' and (length(SortNo)!=6 and substr(SortNo,1,2) not in ('11','12','15','31','50') or SortNo in ('11','12','15','31','50'))",Sqlca);
		out.println(tviTemp.generateHTMLTreeView());
	%>
	}
	
	startMenu();
	expandNode('root');
	doDefault();
</script>
<%@ include file="/IncludeEnd.jsp"%>