<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: �û���ɫ�б�
	 */
	String PG_TITLE = "�û���ɫ�б�";  
	//���ҳ�����
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
	if (sUserID == null) sUserID = "";

	String sIsCar = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("isCar"));
	if(sIsCar == null) sIsCar = "";
	ARE.getLog().debug("�Ƿ񳵴��û�����isCar="+sIsCar);
	/**
	 * @Action:	 ȡ�����еĽ�ɫ�����жϸ��û��Ƿ��иý�ɫ�����жϸý�ɫ�Ƿ�ΪҶ�ӽ��
	 */	
	String sSql = " select getUserName(UserID),RoleID,getUserName(Grantor), "+
					" getItemName('IsInUse',Status),BeginTime,EndTime "+
					" from USER_ROLE "+
					" where UserID = :UserID";
	String[][] sUserRoleNodes = Sqlca.getStringMatrix(new SqlObject(sSql).setParameter("UserID",sUserID));
	for(int i=0;i<sUserRoleNodes.length;i++){
		for(int j=0;j<sUserRoleNodes[i].length;j++){
			if(sUserRoleNodes[i][j]==null) sUserRoleNodes[i][j]="";
		}
	}
    //ʵ�����û�����
	ASUser o_User = ASUser.getUser(sUserID,Sqlca);		
	//��ȡ��������
	String sOrgLevel = Sqlca.getString(new SqlObject("select OrgLevel from ORG_INFO where OrgID = :OrgID").setParameter("OrgID",o_User.getOrgID()));
	if(sOrgLevel == null) sOrgLevel = "";
	
    sSql = "select RoleID,RoleName from ROLE_INFO where 1=1 ";
    if(sOrgLevel.equals("0")) //��������OrgLevel(0�����У�3�����У�6��֧�У�9������)
    	 sSql += " and (RoleID like '0%' "+	        		
        		 " or RoleID like '8%' or RoleID like '1%' or RoleID like '2%') "+
        		 " and RoleStatus = '1' ";
    if(sOrgLevel.equals("3")) //��������OrgLevel(0�����У�3�����У�6��֧�У�9������)
    	 sSql += " and (RoleID like '2%' "+	        		
        		 " or RoleID like '8%') "+
        		 " and RoleStatus = '1' ";
    if(sOrgLevel.equals("6")) //��������OrgLevel(0�����У�3�����У�6��֧�У�9������)
        sSql += " and (RoleID like '4%' "+
        		" or RoleID like '8%') "+
        		" and RoleStatus = '1' ";
     sSql += " order by RoleID ";
     String[][] asRoleNodes = Sqlca.getStringMatrix(sSql);
     String[][] sRoleNodes = new String[asRoleNodes.length][8];
     for(int i=0;i<sRoleNodes.length;i++){
   		 sRoleNodes[i][0]=asRoleNodes[i][0];
   		 sRoleNodes[i][1]=asRoleNodes[i][1];
   		 sRoleNodes[i][2]="TRUE";
   		 sRoleNodes[i][3]="FALSE";
	   	 sRoleNodes[i][4]=""; //��Ȩ��
         sRoleNodes[i][5]="";
         sRoleNodes[i][6]="";
         sRoleNodes[i][7]="";
     }
     
    for(int i=0;i<sRoleNodes.length;i++){
    	//Is The Node Leaf?
    	for(int j=0;j<sRoleNodes.length;j++){
        	if(i==j) continue;
        	if(sRoleNodes[j][0].startsWith(sRoleNodes[i][0])) sRoleNodes[i][2]="FALSE";
        }
        
        //Has The Node Role?
        for(int j=0;j<sUserRoleNodes.length;j++){
        	if(sRoleNodes[i][0].equals(sUserRoleNodes[j][1])){
                sRoleNodes[i][3]="TRUE";
                sRoleNodes[i][4]=sUserRoleNodes[j][2]; //��Ȩ��
                sRoleNodes[i][5]=sUserRoleNodes[j][3];
                sRoleNodes[i][6]=sUserRoleNodes[j][4];
                sRoleNodes[i][7]=sUserRoleNodes[j][5];
            }
        }
    }
%>
<body leftmargin="0" topmargin="0" onload="" class="ListPage" >
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" >
<tr height=1 align=center>
    <td>�û�&nbsp;&nbsp;<font color=#6666cc>(<%=sUserID%>)</font>&nbsp;&nbsp;���еĽ�ɫ
    </td>
</tr>
<tr height=1 valign=top >
    <td>
    	<table>
	    	<tr>
	    		<td>
	                	<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","����","����Ȩ�޶�����Ϣ","javascript:saveRightConf()",sResourcesPath)%>
	    		</td>
	    		<td>
	                	<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","ȫѡ","ȫѡ","javascript:selectAll()",sResourcesPath)%>
	    		</td>
	    		<td>
	                	<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","ȫ��ѡ","ȫ��ѡ","javascript:selectNone()",sResourcesPath)%>
	    		</td>
	    		<td>
	                	<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","��ѡ","��ѡ","javascript:selectInverse()",sResourcesPath)%>
	    		</td>
	    		<td>
	                	<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","�ָ�","�ָ�","javascript:restore()",sResourcesPath)%>
	    		</td>
    		</tr>
    	</table>
    </td>
</tr>
<tr width=100% align="center" width=90%>
    <td valign="top" >
    <div style="positition:absolute;width:100%;height:100%;overflow:auto">
	<table border="0"  cellspacing="1" cellpadding="4" style="{border:  dash 1px;}">
		<tr height=1 valign=top class="RoleTitle">
		    <td width=3% align=center>&nbsp;</td>
		    <td width=10%>��ɫID</td>
		    <td width=20%>��ɫ����</td>
		    <td width=10%>��Ȩ��</td>
		    <td width=10%>״̬</td>
		    <td width=10%>��ʼ��</td>
		    <td width=10%>������</td>
		</tr>
		<form name=CheckBoxes>
		<%
        int countLeaf=0;
		for(int i=0;i<sRoleNodes.length;i++){
            if (sRoleNodes[i][2].equals("TRUE")){  //�Ƿ�ΪҶ
                ++countLeaf;
                if(sRoleNodes[i][3].equals("TRUE")){  //�Ƿ��н�ɫ
     	%>
			        <tr height=1 valign=top class="RoleLeafCheck">
                        <td align=center>
                            <INPUT ID="checkbox<%=countLeaf%>" TYPE="checkbox" NAME="<%=sRoleNodes[i][0]%>" checked>
                        </td>
                        <td><%=sRoleNodes[i][0]%></td>
                        <td><%=sRoleNodes[i][1]%></td>
                        <td><%=sRoleNodes[i][4]%></td>
                        <td><%=sRoleNodes[i][5]%></td>
                        <td><%=sRoleNodes[i][6]%></td>
                        <td><%=sRoleNodes[i][7]%></td>
                    </tr>
			    <%}else{%>
                    <tr height=1 valign=top class="RoleLeafUncheck">
                        <td align=center>
                            <INPUT ID="checkbox<%=countLeaf%>" TYPE="checkbox" NAME="<%=sRoleNodes[i][0]%>">
                        </td>
                        <td><%=sRoleNodes[i][0]%></td>
                        <td><%=sRoleNodes[i][1]%></td>
                        <td><%=sRoleNodes[i][4]%></td>
                        <td><%=sRoleNodes[i][5]%></td>
                        <td><%=sRoleNodes[i][6]%></td>
                        <td><%=sRoleNodes[i][7]%></td>
                    </tr>
                <%}
		    }else{
		        %>
                <tr height=1 valign=top class="RoleNode">
                    <td>
                        &nbsp;
                    </td>
                    <td><%=sRoleNodes[i][0]%></td>
                    <td><%=sRoleNodes[i][1]%></td>
                    <td><%=sRoleNodes[i][4]%></td>
                    <td><%=sRoleNodes[i][5]%></td>
                    <td><%=sRoleNodes[i][6]%></td>
                    <td><%=sRoleNodes[i][7]%></td>
                </tr>
                <%
		    }
		}
		%>
		</form>
	</table>
	</div>
    </td>
</tr>
</table>
</body>
</html>
<script type="text/javascript">
	function saveRightConf(){
		var iControls = <%=countLeaf%>;
		if(!confirm("ȷ��Ҫ����Խ�ɫ���޸���")){
			return;
		}
		var sRoleIDs = "";
		var iTmp = 1;
		for(iTmp=1;iTmp<=iControls;iTmp++){
			if(document.all["checkbox"+iTmp].checked){
				sRoleIDs = sRoleIDs + document.all["checkbox"+iTmp].name +"@";
			}
		}
		var sReturnMessage = RunJavaMethodSqlca("com.amarsoft.app.awe.config.orguser.action.AddMuchRolesAction","addMuchRoles","UserID=<%=CurUser.getUserID()%>,Action=UPDATE,UsersID=<%=sUserID%>,RolesID="+sRoleIDs);
		alert(sReturnMessage);
	}

	function selectAll(){
		var iControls = <%=countLeaf%>;
		var iTmp = 1;
		for(iTmp=1;iTmp<=iControls;iTmp++){
			document.all["checkbox"+iTmp].checked=true;
		}
	}
	
	function selectNone(){
		var iControls = <%=countLeaf%>;
		var iTmp = 1;
		for(iTmp=1;iTmp<=iControls;iTmp++){
			document.all["checkbox"+iTmp].checked=false;
		}
	}
	
	function selectInverse(){
		var iControls = <%=countLeaf%>;
		var iTmp = 1;
		for(iTmp=1;iTmp<=iControls;iTmp++){
			document.all["checkbox"+iTmp].checked=!document.all["checkbox"+iTmp].checked;
		}
	}
	
	function restore(){
		document.forms["CheckBoxes"].reset();
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>