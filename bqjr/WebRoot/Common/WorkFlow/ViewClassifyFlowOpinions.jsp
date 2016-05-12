<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
    <%
    /*
    Author: cbsu 2009-10-14
    Tester:
    Content: �弶����鿴���ҳ��
    Input Param:
        ObjectType�� �弶�����������("Classify")
        ObjectNo���弶����������ˮ��
        FlowNo��������
        PhaseNo����ǰ�׶κ�
    Output param:
    History Log:
    */
    %>
<%/*~END~*/%>

<%
	//��ȡҳ��������弶�����������("Classify")���弶����������ˮ�ţ����������׶���
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
    String sObjectNo= DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	String sCurFlowNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("FlowNo"));
	String sCurPhaseNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("PhaseNo"));
	
	//����ֵת��Ϊ���ַ���
	if(sObjectType==null)sObjectType="";
	if(sObjectNo==null)sObjectNo="";
	if(sCurFlowNo==null)sCurFlowNo="";
	if(sCurPhaseNo==null)sCurPhaseNo="";
	
    String sSql,sOpinionRightType="",sOpinionRightPhases="",sOpinionRightRoles="",sTempPrivilegePhases="",sPhaseAction="";
    //��Щ�׶��ܿ�
    boolean bRolePrivilege = false;
	boolean bPhasePrivilege = false;
	//�жϵ�ǰ��������׶��Ƿ��ڶ�Ӧ����Ȩ�׶�
	boolean bPhaseMatch = false;
	//��������
	String sFlowNo = "";
	//��ǰ�׶κ�
	String sPhaseNo = "";
	//���鿴�Լ�ǩ����������Ӧ�Ľ׶�
	String sSelfOpinionPhase = "";
	//�˹��϶�����
	String sSelfOpinion = "";
	//�׶�����
	String sPhaseName = "";
	//������
	String sUserName = "";
	//��������������
	String sOrgName = "";
	//�յ�ʱ��
	String sBeginTime = "";
	//���ʱ��
	String sEndTime = "";
	//�ͻ�����
	String sCustomerName = "";
	//ģ�ͷ�����
	String sModeResult = "";
	//�˹��϶����
	String sSelfOpinionReason = "";

	int iTermYear = 0;
	int iTermMonth = 0;
	int iTermDay = 0;
	//�����жϼ�¼�Ƿ����������
	int iCountRecord=0;
	//���ڱ������
	int iRow=0,jRow=0;
	
	ASResultSet rs = null;
	
	//��ȡ���鿴�Լ�ǩ����������Ӧ�Ľ׶�
	sSql = 	" select Attribute6 from FLOW_MODEL "+
			" where FlowNo =:FlowNo and PhaseNo =:PhaseNo ";
	SqlObject so = new SqlObject(sSql);
	so.setParameter("FlowNo",sCurFlowNo).setParameter("PhaseNo",sCurPhaseNo);
	sSelfOpinionPhase = Sqlca.getString(so);
	if(sSelfOpinionPhase == null) sSelfOpinionPhase = "";
	//��ȡ���鿴�Լ�ǩ��������Ϣ
	if(!sSelfOpinionPhase.equals("")){
		sSql = " select FO.CustomerName, getItemName('ClassifyResult',FO.PhaseOpinion) as PhaseOpinion, getItemName('ClassifyResult',FO.PhaseOpinion1) as PhaseOpinion1, FO.PhaseOpinion2, " + //
		       " FT.PhaseName, FT.UserName,FT.OrgName,FT.BeginTime,FT.EndTime " +
		       " from FLOW_OPINION FO, FLOW_TASK FT " + 
		       " where FT.Serialno=FO.SerialNo "+             
               " and (FO.PhaseOpinion is not null) "+
               " and FO.InputUser =:InputUser "+
               " and FT.ObjectNo=:ObjectNo "+
               " and FT.ObjectType=:ObjectType"+
               " and FT.FlowNo =:FlowNo "+
               " and FT.PhaseNo=:PhaseNo ";
        so = new SqlObject(sSql);
        so.setParameter("InputUser",CurUser.getUserID()).setParameter("ObjectNo",sObjectNo)
        .setParameter("ObjectType",sObjectType).setParameter("FlowNo",sCurFlowNo).setParameter("PhaseNo",sCurPhaseNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			sCustomerName = rs.getString("CustomerName");
			sSelfOpinion = rs.getString("PhaseOpinion2");
			sModeResult = rs.getString("PhaseOpinion1");
			sSelfOpinionReason = rs.getString("PhaseOpinion");
			sPhaseName = rs.getString("PhaseName");
			sUserName = rs.getString("UserName");
			sOrgName = rs.getString("OrgName");
			sBeginTime = rs.getString("BeginTime");
			sEndTime = rs.getString("EndTime");
			iCountRecord = iCountRecord + 1;
		}
		rs.getStatement().close();
	}
	
	//������Ա��������� FLOW_OPINION �� ,�����Ҫ��ʾһЩ���������Ҫ�޸�ǩ����������������
	//FLOW_MODEL��ӵĶ�������鿴Ȩ�޵��жϣ�ͨ�� Attribute2	
	sSql =  " select FO.CustomerName, "+         
            " FT.FlowNo,FT.PhaseNo,FT.PhaseName,FT.UserName,FT.OrgName,FT.PhaseAction, "+
            " FT.BeginTime,FT.EndTime,FT.PhaseChoice, getItemName('ClassifyResult',FO.PhaseOpinion) as PhaseOpinion, getItemName('ClassifyResult',FO.PhaseOpinion1) as PhaseOpinion1,FO.PhaseOpinion2, "+
            " FM.Attribute3 as OpinionRightType,FM.Attribute4 as OpinionRightPhases,FM.Attribute5 as OpinionRightRoles "+
            " from FLOW_TASK FT,FLOW_OPINION FO,FLOW_MODEL FM "+
            " where FT.Serialno=FO.SerialNo "+
            " and FT.FlowNo=FM.FlowNo "+
            " and FT.PhaseNo=FM.PhaseNo "+
            " and (FO.PhaseOpinion is not null) "+
            " and FT.ObjectNo=:ObjectNo "+
            " and FT.ObjectType=:ObjectType";
	
	if(sSelfOpinionPhase.equals("")){
		sSql += " ORDER BY FT.SerialNo";
		so = new SqlObject(sSql);
		so.setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);
	}else{
		sSql += " and FT.PhaseNo <> :FT.PhaseNo ORDER BY FT.SerialNo";
		so = new SqlObject(sSql);
		so.setParameter("FT.ObjectNo",sObjectNo)
		.setParameter("FT.ObjectType",sObjectType).setParameter("FT.PhaseNo",sSelfOpinionPhase);
	}
	rs=Sqlca.getASResultSet(so);
%>
<html>
<head>
<title>��������</title>
</head>
<body  leftmargin="0" topmargin="0" class="pagebackground"  >
  <form name="opinion">
  <table width="100%"  height="100%" cellpadding="3" cellspacing="0" border="0" style="overflow:auto;overflow-x:visible;overflow-y:visible">
  	<tr>
  		<!--��ʱ���� 
  		<td>
			<%=HTMLControls.generateButton("ת�������ӱ��","ת�������ӱ��","spreadsheetTransfer(formatContent());",sResourcesPath)%>
		</td> -->
	</tr>
    <%
        
        while (rs.next())
        {
			sOpinionRightType = rs.getString("OpinionRightType");    //�鿴�����ʽ all_except(�ų�һЩ�׶�) none_except(ѡ��һЩ�׶�)
			sOpinionRightPhases = rs.getString("OpinionRightPhases");//��ͬ�鿴�����ʽ��Ӧ�Ľ׶�
			sOpinionRightRoles = rs.getString("OpinionRightRoles");  //����鿴��Ȩ��ɫ
			sPhaseAction = rs.getString("PhaseAction");
			//����ֵת��Ϊ���ַ���
			if(sOpinionRightType == null) sOpinionRightType = "";
			if(sOpinionRightPhases == null) sOpinionRightPhases = "";
			if(sOpinionRightRoles == null) sOpinionRightRoles = "";
			if(sPhaseAction == null) sPhaseAction = "";

			//1���жϸ��û��Ƿ�ӵ����Ȩ��ɫ
			if(sOpinionRightRoles.equals("")) bRolePrivilege = false;
			else{
				ArrayList<String> roles = CurUser.getRoleTable();
				for(int i=0;i<roles.size();i++){
					if(sOpinionRightRoles.indexOf(roles.get(i))>=0){
						bRolePrivilege = true;
						break;
					}
				}
			}
			
			//2���жϵ�ǰ��������׶��Ƿ���ģ�Ͷ�Ӧ����Ȩ�׶�
			if(sOpinionRightPhases.equals("")) bPhaseMatch = false;			
			else{
				int iCountPhases = StringFunction.getSeparateSum(sOpinionRightPhases,",");
				
				String sTempFlowPhase,sTempFlow,sTempPhase;
				for(int i=0;i<iCountPhases;i++){
					sTempFlowPhase = StringFunction.getSeparate(sOpinionRightPhases,",",i+1);					
					if(sTempFlowPhase.indexOf(".")<0) sTempFlowPhase = sCurFlowNo + "." + sTempFlowPhase;					
					if(sTempFlowPhase.equals(sCurFlowNo+"."+sCurPhaseNo)){
						bPhaseMatch = true;
						break;
					}
				}
			}
			
			//3�����ݲ鿴�����ʽ�Ĳ�ͬ���ж��Ƿ������ʾ
			if(sOpinionRightType.equals("") || sOpinionRightType.equals("none_except")){
				bPhasePrivilege = bPhaseMatch;
			}else{
				bPhasePrivilege = !bPhaseMatch;				
			}
			
			//bPhasePrivilege = true; bRolePrivilege = true;
			//4�������ж��Ƿ���ʾ������������Ҫ��ʾ��������ж���һ�����
			//���û��Ƿ������Ȩ��ɫ���ý׶�����Ƿ����ڸ�����ɲ鿴�׶Ρ��ý׶��Ƿ�����			
			if(!bPhasePrivilege && !bRolePrivilege && sPhaseAction.indexOf("��������")<0) continue;
			iCountRecord++;						
    %>
    <tr>
	<td valign="top">
	  <table width=90%  cellpadding="4" cellspacing="0" border="1" bordercolorlight="#666666" bordercolordark="#FFFFFF" >
        <tr id=<%=iRow++%>>
			<td width=50%><b>�׶�����:</b><%=DataConvert.toString(rs.getString("PhaseName"))%><input type=hidden value='�׶����ƣ�<%=DataConvert.toString(rs.getString("PhaseName"))%>' name=<%="R"+String.valueOf(iRow)+"L"%> ></td>
            <td width=50%><b>������:</b><%=DataConvert.toString(rs.getString("UserName"))%><input type=hidden value='�����ˣ�<%=DataConvert.toString(rs.getString("UserName"))%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
        <tr id=<%=iRow++%>>
			<td width=50%><b>��������������:</b><%=DataConvert.toString(rs.getString("OrgName"))%><input type=hidden value='����������������<%=DataConvert.toString(rs.getString("OrgName"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>�ͻ�����:</b><%=DataConvert.toString(rs.getString("CustomerName"))%><input type=hidden value='�ͻ����ƣ�<%=DataConvert.toString(rs.getString("CustomerName"))%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
 
        <tr id=<%=iRow++%>>
            <td width=50%><b>ģ�ͷ�����:</b><%=DataConvert.toString(rs.getString("PhaseOpinion1"))%><input type=hidden value='ģ�ͷ�����:<%=DataConvert.toString(rs.getString("PhaseOpinion1"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>�˹��϶����:</b><%=DataConvert.toString(rs.getString("PhaseOpinion"))%><input type=hidden value='�˹��϶����:<%=DataConvert.toString(rs.getString("PhaseOpinion"))%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
              
        <tr id=<%=iRow++%>>
            <td width=50%><b>�յ�ʱ��:</b><%=DataConvert.toString(rs.getString("BeginTime"))%><input type=hidden value='�յ�ʱ�䣺<%=DataConvert.toString(rs.getString("BeginTime"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>���ʱ��:</b><%=DataConvert.toString(rs.getString("EndTime"))%><input type=hidden value='���ʱ�䣺<%=DataConvert.toString(rs.getString("EndTime"))%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
        
        <tr id=<%=iRow++%>>
            <td  colspan=2 align=center>
                <textarea type=textfield  bgcolor="#FDFDF3" readonly style="width:100%;height:170px;resize: none;">
                     <%="\r\n���϶����ɡ�"+ StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion2")).trim(),"\\r\\n","\r\n")
                     %>
                </textarea>
            <input type=hidden value='<%="\r\n���϶����ɡ�"+StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion2")).trim(),"\\r\\n","\r\n")%>' name=<%="R"+String.valueOf(iRow)+"L"%>>
            <input type=hidden value='amarsoft' name=<%="R"+String.valueOf(iRow)+"R"%>>	<!--�����ж��Ƿ����һ��һ��-->
            </td>
        </tr>        
      </table>
	  </td>
    </tr>
    <tr>
	<td>&nbsp;
	  </td>
    </tr>
    <%
    }
    rs.getStatement().close();
    
    //չ�ֱ����������Լ�ǩ������
    if(!sSelfOpinionPhase.equals(""))
    {
    %>
    <tr>
	<td>
	  <table width=90%  cellpadding="4" cellspacing="0" border="1" bordercolorlight="#666666" bordercolordark="#FFFFFF" >
        <tr id=<%=jRow++%>>
			<td width=50%><b>�׶�����:</b><%=DataConvert.toString(sPhaseName)%><input type=hidden value='�׶����ƣ�<%=DataConvert.toString(sPhaseName)%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>������:</b><%=DataConvert.toString(sUserName)%><input type=hidden value='�����ˣ�<%=DataConvert.toString(sUserName)%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        <tr id=<%=jRow++%>>
			<td width=50%><b>��������������:</b><%=DataConvert.toString(sOrgName)%><input type=hidden value='����������������<%=DataConvert.toString(sOrgName)%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>�ͻ�����:</b><%=DataConvert.toString(sCustomerName)%><input type=hidden value='�ͻ����ƣ�<%=DataConvert.toString(sCustomerName)%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
       
        <tr id=<%=iRow++%>>
            <td width=50%><b>ģ�ͷ�����:</b><%=DataConvert.toString(rs.getString("PhaseOpinion1"))%><input type=hidden value='ģ�ͷ�����:<%=DataConvert.toString(rs.getString("PhaseOpinion1"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>�˹��϶����:</b><%=DataConvert.toString(rs.getString("PhaseOpinion"))%><input type=hidden value='�˹��϶����:<%=DataConvert.toString(rs.getString("PhaseOpinion"))%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>       
       
        <tr id=<%=jRow++%>>
            <td width=50%><b>�յ�ʱ��:</b><%=DataConvert.toString(sBeginTime)%><input type=hidden value='�յ�ʱ�䣺<%=DataConvert.toString(sBeginTime)%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>���ʱ��:</b><%=DataConvert.toString(sEndTime)%><input type=hidden value='���ʱ�䣺<%=DataConvert.toString(sEndTime)%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        
        <tr id=<%=jRow++%>>
            <td  colspan=2 align=center>
                <textarea type=textfield  bgcolor="#FDFDF3" readonly style="width:100%;height:170px;resize: none;">
                     <%="\r\n���϶����ɡ�"+ StringFunction.replace(DataConvert.toString(sSelfOpinion).trim(),"\\r\\n","\r\n")
                     %>
                </textarea>
            <input type=hidden value='<%="\r\n���϶����ɡ�"+StringFunction.replace(DataConvert.toString(sSelfOpinion).trim(),"\\r\\n","\r\n")%>' name=<%="R"+String.valueOf(jRow)+"L"%>>
            <input type=hidden value='amarsoft' name=<%="R"+String.valueOf(jRow)+"R"%>>	<!--�����ж��Ƿ����һ��һ��-->
            </td>
        </tr>        
      </table>
	  </td>
    </tr>
    <tr>
	<td>&nbsp;
	  </td>
    </tr>    
    <%
    }
    %>
	<tr>
  		<!--��ʱ����
  		<td>
			<%=HTMLControls.generateButton("ת�������ӱ��","ת�������ӱ��","spreadsheetTransfer(formatContent());",sResourcesPath)%>
		</td>-->
	</tr>
  </table>
  </form>
</body>
</html>
<%
	//���û���������û���ҵ���Ӧ�Ķ������Զ��ر�
	if (iCountRecord==0||sObjectNo.equals("")){
%>
<body style={color:red}>Ŀǰ��ҵ��û�������Բ鿴�����������</body>
<%
	}
%>
<script type="text/javascript">
function formatContent()
{
	var sContentNew = "",i=0;
	var iRowCount = 1;
	if("<%=sSelfOpinionPhase%>" != "")	iRowCount =<%=jRow%>;
	else iRowCount =<%=iRow%>;

	var iColCount = 2;
	var sHeader = "����ˮ�š�"+"<%=sObjectNo%>";

	sContentNew += "<STYLE>"; 
	sContentNew += ".table {  border: solid; border-width: 0px 0px 1px 1px; border-color: #000000 black #000000 #000000}";
	sContentNew += ".td {  font-size: 9pt;border-color: #000000; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px}.inputnumber {border-style:none;border-width:thin;border-color:#e9e9e9;text-align:right;}.pt16songud{font-family: '����','����';font-size: 16pt;font-weight:bold;text-decoration: none}.myfont{font-family: '����','����';font-size: 9pt;font-weight:bold;text-decoration: none}"
	sContentNew += "</STYLE>";
	
	sContentNew += "<table align=center border=1 cellspacing=0 cellpadding=0 bgcolor=#E4E4E4 bordercolor=#999999 bordercolordark=#FFFFFF >";
	sContentNew += "<tr>";
	sContentNew += "    <td colspan="+iColCount+" align=middle style='color:black;padding-left:2px;background:silver;font-size:18.0pt;font-weight:700;font-family:����;' height=53>ҵ������������</td>";
	sContentNew += "</tr>";
	sContentNew += "<tr>";
	sContentNew += "    <td colspan="+iColCount+" align=left style='background-color:#CCC8EB;color:black;padding-left:2px;'>"+sHeader+"</td>";
	sContentNew += "</tr>";
	
	for(i=1;i<=iRowCount;i++)
	{
		
		if(document.forms["opinion"].elements["R"+i+"R"].value == "amarsoft")
		{   //�����ֻ����һ��һ��
			sContentNew += "<tr height=50 style='mso-height-source:userset;height:38.1pt'>";
			sContentNew += "    <td colspan="+iColCount+" align=left style='background-color:#CCC8EB;color:black;padding-left:2px;mso-font-charset:0;vertical-align:top;text-align:left;'>"+document.forms["opinion"].elements["R"+i+"L"].value+"</td>";
			sContentNew += "</tr>";
		}
		else
		{
			sContentNew += "<tr>";
			sContentNew += "    <td align=left>"+document.forms["opinion"].elements["R"+i+"L"].value+"</td>";
			sContentNew += "    <td align=left>"+document.forms["opinion"].elements["R"+i+"R"].value+"</td>";
			sContentNew += "</tr>";
		}
	}	
	
	sContentNew += "</table>";
	//��ֹ�򵼳�������̫С������EXCELʱ�������
	sContentNew += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	sContentNew += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	sContentNew += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	sContentNew += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	
	return(sContentNew);		
}
</script>
<%@ include file="/IncludeEnd.jsp"%>