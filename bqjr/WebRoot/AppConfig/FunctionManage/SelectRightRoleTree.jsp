<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	//获得页面参数
	String sRightPointURL = CurPage.getParameter("RightPointURL"); //权限点URL
	String sRightPointName = CurPage.getParameter("RightPointName"); //权限点名称
	if (sRightPointURL == null) sRightPointURL = "";
	if (sRightPointName == null) sRightPointName = "";
%>
<body leftmargin="0" topmargin="0" style="overflow: hidden;">
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" >
<tr height=1 valign=top >
    <td>
    	<table>
	    	<tr>
	    		<td><%=new Button("确定","保存配置信息","javascript:saveConfig()").getHtmlText()%></td>
    		</tr>
    	</table>
    </td>
</tr>
<tr>
    <td valign="top" >
    	<table width='100%' cellpadding='0' cellspacing='0'>
			<tr>
				<td id="myleft" colspan='3' align=center width=100%>
					<div style="positition:absolute;align:left;height:430px;overflow-y: hide;">
						<iframe name="left" src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0 scrolling=no ></iframe>
					</div>
				</td>
			</tr>
		</table>
    </td>
</tr>
</table>
</body>
<script type="text/javascript">
	setDialogTitle("权限点<font color=#6666cc>(<%=sRightPointName%>)</font>可见角色");
	function saveConfig(){
		var nodes = getCheckedTVItems(); //树图选择的节点
		var roles ="";
		for(var i=0;i<nodes.length;i++){
			roles += nodes[i].id + "@";
		}
		var sReturn = RunJavaMethodTrans("com.amarsoft.app.awe.config.function.action.ManageRoleRela","manageRightRoleRela","RightPointURL=<%=sRightPointURL%>,RelaValues="+roles);
		if(sReturn=="SUCCEEDED"){
			alert("保存成功！");
			top.close();
		}
	}
	
	function startMenu(){
	<%
		HTMLTreeView tviTemp = new HTMLTreeView("配置可见角色","right");
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		tviTemp.TriggerClickEvent=false;
		tviTemp.MultiSelect = true;
		tviTemp.initWithSql("RoleID","RoleName||'('||ROLEID||')' as ShowText","RoleID","","from AWE_ROLE_INFO where RoleStatus ='1'",Sqlca);
		out.println(tviTemp.generateHTMLTreeView());
		
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select RoleID from AWE_ROLE_URL where URL=:URL").setParameter("URL", sRightPointURL));
		//取角色与菜单的关联，以便勾选上已选择项
		while(rs.next()){
	%>
		setCheckTVItem('<%=rs.getString("RoleID")%>', true);
	<%  }
		rs.getStatement().close();%>
	}
	
	startMenu();
	expandNode('root');
</script>
<%@ include file="/IncludeEnd.jsp"%>