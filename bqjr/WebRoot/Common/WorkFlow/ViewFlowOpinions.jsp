<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: byhu 2004.12.21
 * Tester:
 *
 * Content: �鿴��������
 * Input Param:
 *      ObjectType: ��������
 *          CreditApply: ����
 *          ApproveApply: �����������
 *          PutOutApply:  ����
 *      ObjectNo:   ������
 *		FlowNo�����̺�
 *		PhaseNo���׶κ�
 * Output param:
 *
 * History Log: zywei 2006/02/22 ���Ӳ鿴�Լ�ǩ��������������ǩ��
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//��ȡҳ�����
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
	boolean bRolePrivilege = false; //��Щ�׶��ܿ�
	boolean bPhasePrivilege = false;//
	boolean bPhaseMatch = false;//�жϵ�ǰ��������׶��Ƿ��ڶ�Ӧ����Ȩ�׶�

	String sFlowNo = "";
	String sPhaseNo = "";
	String sSelfOpinionPhase = "";
	String sSelfOpinion = "";
	String sPhaseName = "";
	String sUserName = "";
	String sOrgName = "";
	String sBeginTime = "";
	String sEndTime = "";
	int iCountRecord=0;//�����жϼ�¼�Ƿ����������

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
		sSql =  " select FO.PhaseOpinion,FT.PhaseName,FT.UserName, "+
				" FT.OrgName,FT.BeginTime,FT.EndTime "+
				" from FLOW_TASK FT,FLOW_OPINION FO "+
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
			sSelfOpinion = rs.getString("PhaseOpinion");
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
	//FLOW_MODEL��ӵĶ�������鿴Ȩ�޵��жϣ�ͨ�� Attribute2,
	sSql = 	" select FT.FlowNo,FT.PhaseNo,FT.PhaseName,FT.UserName,FT.OrgName,FT.PhaseAction,FT.BeginTime, "+
			" FT.EndTime,FT.PhaseChoice,FO.PhaseOpinion,FO.PhaseOpinion1,FO.PhaseOpinion2,FO.PhaseOpinion3, "+
			" FM.Attribute3 as OpinionRightType,FM.Attribute4 as OpinionRightPhases,FM.Attribute5 as OpinionRightRoles "+
			" from FLOW_TASK FT,FLOW_OPINION FO,FLOW_MODEL FM "+
			" where FT.Serialno=FO.SerialNo "+
			" and FT.FlowNo=FM.FlowNo "+
			" and FT.PhaseNo=FM.PhaseNo "+
			" and (FO.PhaseOpinion is not null) "+
			" and FT.ObjectNo=:ObjectNo "+
			" and FT.ObjectType=:ObjectType ";
	if(sSelfOpinionPhase.equals("")){
		sSql += " ORDER BY FT.SerialNo";
		so = new SqlObject(sSql);
		so.setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);	
	}else{
		sSql += " and FT.PhaseNo <> :PhaseNo ORDER BY FT.SerialNo";
		so = new SqlObject(sSql);
		so.setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType)
		.setParameter("PhaseNo",sSelfOpinionPhase);
	}
	rs=Sqlca.getASResultSet(so);
%>
<html>
<head>
<title>��������</title>
</head>
<body leftmargin="0" topmargin="0" class="pagebackground">
  <table width="100%" cellpadding="3" cellspacing="0" border="0" >
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
	<td>
	  <table width=90%  cellpadding="4" cellspacing="0" border="1" bordercolorlight="#666666" bordercolordark="#FFFFFF" >
        <tr>
            <td colspan=2 bgcolor="#CCCCCC">
                <b>�׶�����:</b><%=DataConvert.toString(rs.getString("PhaseName"))%>&nbsp;&nbsp;
                <b>������:</b><%=DataConvert.toString(rs.getString("UserName"))%>&nbsp;&nbsp;
                <b>��������������:</b><%=DataConvert.toString(rs.getString("OrgName"))%>&nbsp;&nbsp;
            </td>
        </tr>
        <tr>
            <td width=50%><b>�յ�ʱ��:</b><%=DataConvert.toString(rs.getString("BeginTime"))%>
            <td width=50%><b>���ʱ��:</b><%=DataConvert.toString(rs.getString("EndTime"))%></td>
        </tr>
        
        <tr>
            <td  colspan=2 align=center>
                <textarea type=textfield  bgcolor="#FDFDF3" readonly style="width:100%;height:170px;resize: none;">
                     <%="\r\n�������"+ StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion")).trim(),"\\r\\n","\r\n")
                     %>
                </textarea>
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
        <tr>
            <td colspan=2 bgcolor="#CCCCCC">
                <b>�׶�����:</b><%=DataConvert.toString(sPhaseName)%>&nbsp;&nbsp;
                <b>������:</b><%=DataConvert.toString(sUserName)%>&nbsp;&nbsp;
                <b>��������������:</b><%=DataConvert.toString(sOrgName)%>&nbsp;&nbsp;
            </td>
        </tr>
        <tr>
            <td width=50%><b>�յ�ʱ��:</b><%=DataConvert.toString(sBeginTime)%>
            <td width=50%><b>���ʱ��:</b><%=DataConvert.toString(sEndTime)%></td>
        </tr>
        
        <tr>
            <td  colspan=2 align=center>
                <textarea type=textfield  bgcolor="#FDFDF3" readonly style="width:100%;height:170px;resize: none;">
                     <%="\r\n�������"+ StringFunction.replace(DataConvert.toString(sSelfOpinion).trim(),"\\r\\n","\r\n")
                     %>
                </textarea>
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
 
  </table>
</body>
</html>
<%
	//���û���������û���ҵ���Ӧ�Ķ������Զ��ر�
	if (iCountRecord==0||sObjectNo.equals("")){
%>
<script>
    alert("Ŀǰ��ҵ��û�������Բ鿴�����������");
</script>
<%
	}
%>
<%@ include file="/IncludeEnd.jsp"%>