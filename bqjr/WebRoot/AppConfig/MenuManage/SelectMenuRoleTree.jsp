<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	//���ҳ�����
	String sMenuID = CurPage.getParameter("MenuID"); //�˵����
	String sMenuName =  CurPage.getParameter("MenuName"); //�˵�����
	if (sMenuID == null) sMenuID = "";
	if (sMenuName == null) sMenuName = "";
%>
<body leftmargin="0" topmargin="0" style="overflow: hidden;">
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" >
<tr height=1 valign=top >
    <td>
    	<table>
	    	<tr>
	    		<td><%=HTMLControls.generateButton("ȷ��","����Ȩ�޶�����Ϣ","javascript:saveConfig()",sResourcesPath)%></td>
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
	setDialogTitle("�˵���<font color=#6666cc>(<%=sMenuName%>)</font>�ɼ���ɫ");
	function saveConfig(){
		var nodes = getCheckedTVItems(); //��ͼѡ��Ľڵ�
		var roles ="";
		for(var i=0;i<nodes.length;i++){
			roles += nodes[i].id + "@";
		}
		var sReturn = RunJavaMethodSqlca("com.amarsoft.app.awe.config.role.action.ManageRoleMenuRela","addMenuRoles","MenuID=<%=sMenuID%>,RelaValues="+roles);
		if(sReturn=="SUCCEEDED"){
			alert("����ɹ���");
			top.close();
		}
	}
	
	function startMenu(){
	<%
		HTMLTreeView tviTemp = new HTMLTreeView("���ò˵��ɼ���ɫ","right");
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		tviTemp.TriggerClickEvent=false;
		tviTemp.MultiSelect = true;
		tviTemp.initWithSql("RoleID","RoleName||'('||ROLEID||')' as ShowText","RoleID","","from AWE_ROLE_INFO where RoleStatus ='1'",Sqlca);
		out.println(tviTemp.generateHTMLTreeView());
		
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select RoleID from AWE_ROLE_MENU where MenuID=:MenuID").setParameter("MenuID", sMenuID));
		//ȡ��ɫ��˵��Ĺ������Ա㹴ѡ����ѡ����
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