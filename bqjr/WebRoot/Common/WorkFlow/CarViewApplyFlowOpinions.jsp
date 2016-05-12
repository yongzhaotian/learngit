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
 				xhgao 2009/06/26   ����ת�������ӱ��Ĺ���
 				fwang 2009/08/10  �޸ĵ��������Ϊ��ʱ����ʾ��Ϣ��ʽ
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
	String isApprove = DataConvert.toRealString(iPostChange,CurPage.getParameter("Flag"));//�Ƿ������˲鿴���
	//����ֵת��Ϊ���ַ���
	if(sObjectType==null)sObjectType="";
	if(sObjectNo==null)sObjectNo="";
	if(sCurFlowNo==null)sCurFlowNo="";
	if(sCurPhaseNo==null)sCurPhaseNo="";
	if(isApprove==null) isApprove="";
	
	
	if( sObjectType.equals("ApproveOpinion") )//ת����������
		sObjectType="CreditApply";
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
	String sCustomerName = "";
	String sBusinessCurrencyName = "";
	String sRateFloatTypeName = "";
	double dBusinessSum = 0.0;
	double dBaseRate = 0.0;
	double dRateFloat = 0.0;
	double dBusinessRate = 0.0;
	double dBailSum = 0.0;
	double dBailRatio = 0.0;
	double dPdgRatio = 0.0;
	double dPdgSum = 0.0;
	int iTermYear = 0;
	int iTermMonth = 0;
	int iTermDay = 0;
	int iCountRecord=0;//�����жϼ�¼�Ƿ����������
	int iRow=0,jRow=0;//���ڱ������
	
	ASResultSet rs = null;
	String sTableName ="BUSINESS_APPLY",sBusinessTypeName="";
	if(sObjectType.equals("BusinessContract"))	sTableName = "BUSINESS_CONTRACT";
	else if(sObjectType.equals("ApproveApply"))	sTableName = "BUSINESS_APPROVE";
	else if(sObjectType.equals("PutOutApply"))	sTableName = "BUSINESS_PUTOUT";
	sSql =  " select getBusinessName(BusinessType) as BusinessTypeName from "+sTableName+" where SerialNo=:SerialNo ";
	SqlObject so = new SqlObject(sSql).setParameter("SerialNo",sObjectNo);
	rs = Sqlca.getASResultSet(so);
	if(rs.next()){
		sBusinessTypeName = DataConvert.toString(rs.getString("BusinessTypeName"));
	}
	rs.getStatement().close();
	
	//��ȡ���鿴�Լ�ǩ����������Ӧ�Ľ׶�
	sSql = 	" select Attribute6 from FLOW_MODEL "+
			" where FlowNo =:FlowNo and PhaseNo =:PhaseNo ";
	sSelfOpinionPhase = Sqlca.getString(new SqlObject(sSql).setParameter("FlowNo",sCurFlowNo).setParameter("PhaseNo",sCurPhaseNo));
	if(sSelfOpinionPhase == null) sSelfOpinionPhase = "";
	//��ȡ���鿴�Լ�ǩ��������Ϣ
	if(!sSelfOpinionPhase.equals("")){
		sSql =  " select FO.CustomerName,getItemName('Currency',FO.BusinessCurrency) as BusinessCurrencyName, "+
				" FO.BusinessSum,FO.TermYear,FO.TermMonth,FO.TermDay,FO.BaseRate,FO.RateFloat,FO.BusinessRate, "+
				" getItemName('RateFloatType',FO.RateFloatType) as RateFloatTypeName,FO.BailSum,FO.BailRatio, "+
				" FO.PdgRatio,FO.PdgSum,FO.PhaseOpinion,FO.PhaseOpinion1,FT.PhaseName,FT.UserName,FT.OrgName,FT.BeginTime,FT.EndTime "+
				" from FLOW_TASK FT,FLOW_OPINION FO "+
				" where FT.Serialno=FO.SerialNo "+				
				" and (FO.PhaseOpinion is not null) "+
				" and FO.InputUser =:InputUser "+
				" and FT.ObjectNo=:ObjectNo "+
				" and FT.ObjectType=:ObjectType"+
				" and FT.FlowNo =:FlowNo "+
				" and FT.PhaseNo=:PhaseNo ";
		so = new SqlObject(sSql);
		so.setParameter("InputUser",CurUser.getUserID()).setParameter("ObjectNo",sObjectNo).
		setParameter("ObjectType",sObjectType).setParameter("FlowNo",sCurFlowNo).setParameter("PhaseNo",sCurPhaseNo);	
		rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			sCustomerName = rs.getString("CustomerName");
			sBusinessCurrencyName = rs.getString("BusinessCurrencyName");
			dBusinessSum = rs.getDouble("BusinessSum");
			dBaseRate = rs.getDouble("BaseRate");
			sRateFloatTypeName = rs.getString("RateFloatTypeName");
			dRateFloat = rs.getDouble("RateFloat");
			dBusinessRate = rs.getDouble("BusinessRate");			
			dBailSum = rs.getDouble("BailSum");
			dBailRatio = rs.getDouble("BailRatio");
			dPdgRatio = rs.getDouble("PdgRatio");
			dPdgSum = rs.getDouble("PdgSum");			
			iTermYear = rs.getInt("TermYear");
			iTermMonth = rs.getInt("TermMonth");
			iTermDay = rs.getInt("TermDay");
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
	sSql = 	" select FO.CustomerName,getItemName('Currency',FO.BusinessCurrency) as BusinessCurrencyName, "+
			" FO.BusinessSum,FO.TermYear,FO.TermMonth,FO.TermDay,FO.BaseRate,FO.RateFloat,FO.BusinessRate, "+
			" getItemName('RateFloatType',FO.RateFloatType) as RateFloatTypeName,FO.BailSum,FO.BailRatio, "+
			" FO.PdgRatio,FO.PdgSum,FT.FlowNo,FT.PhaseNo,FT.PhaseName,FT.UserName,FT.OrgName,FT.PhaseAction, "+
			" FT.BeginTime,FT.EndTime,FT.PhaseChoice,FO.PhaseOpinion,FO.PhaseOpinion1,FO.PhaseOpinion2,FO.PhaseOpinion3, "+
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
		sSql += " and FT.PhaseNo <> :PhaseNo ORDER BY FT.SerialNo";
		so = new SqlObject(sSql);
		so.setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType).setParameter("PhaseNo",sSelfOpinionPhase);
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
		while (rs.next()){
			sOpinionRightType = rs.getString("OpinionRightType");    //�鿴�����ʽ all_except(�ų�һЩ�׶�) none_except(ѡ��һЩ�׶�)
			sOpinionRightPhases = rs.getString("OpinionRightPhases");//��ͬ�鿴�����ʽ��Ӧ�Ľ׶�
			sOpinionRightRoles = rs.getString("OpinionRightRoles");  //����鿴��Ȩ��ɫ
			sPhaseAction = rs.getString("PhaseAction");
			String sDoNo = "";
			//�����ʾ����
			String sFlowNo1 = rs.getString("FlowNo");
			String sPhaseNo1 = rs.getString("PhaseNo");
			String str = Sqlca.getString("select PHASEDESCRIBE from FLOW_MODEL where flowNo='"+sFlowNo1+"' and PhaseNo='"+sPhaseNo1+"' and PHASEDESCRIBE is not null  ");
			if( ! StringX.isEmpty(str)){
				String[] strs = StringX.parseArray(str);
				for(String s: strs){
					String tempStr = s.replace(" ", "");
					if(tempStr.substring(0, 4).equalsIgnoreCase("DONO")){
						sDoNo = tempStr.substring(5);
					}
				}
			}
			//
// 			String sOpinon = Sqlca.getString("select ItemName from Code_library where codeno = (select Coleditsource from dataobject_library where dono = '"+sDoNo+"' and Colheader = '�������') and ItemNo = '"+rs.getString("PhaseOpinion")+"'");
			String sOpinon = rs.getString("PhaseOpinion");
			sOrgName = rs.getString("OrgName");
			String sOpinon1 = rs.getString("PhaseOpinion1");//�ڲ����ֻ�������˲��ܿ���
			sCustomerName = Sqlca.getString(new SqlObject("select CustomerNAme from Business_Contract where SerialNo ='"+sObjectNo+"'"));
			
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
			
			//��������������
			String sOpinionName = "";
			
    %>
    <tr>
	<td valign="top">
	  <table width=90%  cellpadding="0" cellspacing="0"  class="dialog_table" align="center">
        <tr id=<%=iRow++%>>
			<td width=50%><b>�׶�����:</b><%=DataConvert.toString(rs.getString("PhaseName"))%><input type=hidden value='�׶����ƣ�<%=DataConvert.toString(rs.getString("PhaseName"))%>' name=<%="R"+String.valueOf(iRow)+"L"%> ></td>
            <td width=50%><b>������:</b><%=DataConvert.toString(rs.getString("UserName"))%><input type=hidden value='�����ˣ�<%=DataConvert.toString(rs.getString("UserName"))%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
         <tr id=<%=jRow++%>>
			<td width=50%><b>��������������:</b><%=DataConvert.toString(sOrgName)%><input type=hidden value='����������������<%=DataConvert.toString(sOrgName)%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>�ͻ�����:</b><%=DataConvert.toString(sCustomerName)%><input type=hidden value='�ͻ����ƣ�<%=DataConvert.toString(sCustomerName)%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        <tr id=<%=iRow++%>>
            <td width=50%><b>�յ�ʱ��:</b><%=DataConvert.toString(rs.getString("BeginTime"))%><input type=hidden value='�յ�ʱ�䣺<%=DataConvert.toString(rs.getString("BeginTime"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>���ʱ��:</b><%=DataConvert.toString(rs.getString("EndTime"))%><input type=hidden value='���ʱ�䣺<%=DataConvert.toString(rs.getString("EndTime"))%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
        
        <tr id=<%=iRow++%>>
            <td  colspan=2 align=center>
                <%
                ARE.getLog().debug("�Ƿ������˲鿴�����־Approve="+isApprove);
                if("Approve".equalsIgnoreCase(isApprove)){ %>
                 <textarea type=textfield  bgcolor="#FDFDF3" readonly style='width:100%;height:100px;resize: none;'>
                     <%="\r\n���ڲ������"+StringFunction.replace(DataConvert.toString(sOpinon1).trim(),"\\r\\n","\r\n")
                     %>
                </textarea>
                <textarea type=textfield  bgcolor="#FDFDF3" readonly style='width:100%;height:100px;resize: none;'>
                     <%="\r\n���ⲿ�����"+StringFunction.replace(DataConvert.toString(sOpinon).trim(),"\\r\\n","\r\n")
                     %>
                </textarea>
            <input type=hidden value='<%="\r\n���ڲ������"+StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion")).trim(),"\\r\\n","\r\n")%>' name=<%="R"+String.valueOf(iRow)+"L"%>>
            <input type=hidden value='<%="\r\n���ⲿ�����"+StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion1")).trim(),"\\r\\n","\r\n")%>' name=<%="R"+String.valueOf(iRow)+"L"%>>
            <%}else{ %>
              <textarea type=textfield  bgcolor="#FDFDF3" readonly style='width:100%;height:100px;resize: none;'>
                     <%="\r\n�������"+StringFunction.replace(DataConvert.toString(sOpinon).trim(),"\\r\\n","\r\n")
                     %>
                </textarea>
            <input type=hidden value='<%="\r\n�������"+StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion")).trim(),"\\r\\n","\r\n")%>' name=<%="R"+String.valueOf(iRow)+"L"%>>
            <%} %>
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
   if(!sSelfOpinionPhase.equals("")){
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
        <tr id=<%=jRow++%>>
			<td width=50%><b>ҵ�����:</b><%=DataConvert.toString(sBusinessCurrencyName)%><input type=hidden value='ҵ����֣�<%=DataConvert.toString(sBusinessCurrencyName)%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>������(Ԫ):</b><%=dBusinessSum%><input type=hidden value='������(Ԫ)��<%=dBusinessSum%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        <tr id=<%=jRow++%>>
			<td width=50%><b>����(��):</b><%=iTermMonth%><input type=hidden value='����(��)��<%=iTermMonth%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>��(��):</b><%=iTermDay%><input type=hidden value='��(��)��<%=iTermDay%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        <tr id=<%=jRow++%>>
			<td width=50%><b>��׼������(%):</b><%=dBaseRate%><input type=hidden value='��׼������(��)��<%=dBaseRate%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>���ʸ�����ʽ:</b><%=DataConvert.toString(sRateFloatTypeName)%><input type=hidden value='ִ��������(��)��<%=dBusinessRate%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        <tr id=<%=jRow++%>>
			<td width=50%><b>���ʸ���ֵ:</b><%=dRateFloat%><input type=hidden value='���ʸ���ֵ��<%=dRateFloat%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>ִ��������(��):</b><%=dBusinessRate%><input type=hidden value='ִ��������(��)��<%=dBusinessRate%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        <tr id=<%=jRow++%>>
			<td width=50%><b>��֤����(Ԫ):</b><%=dBailSum%><input type=hidden value='��֤����(Ԫ)��<%=dBailSum%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>��֤�����(%):</b><%=dBailRatio%><input type=hidden value='��֤�����(��)��<%=dBailRatio%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        <tr id=<%=jRow++%>>
			<td width=50%><b>�����ѽ��(Ԫ):</b><%=dPdgSum%><input type=hidden value='�����ѽ��(Ԫ)��<%=dPdgSum%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>��������(��):</b><%=dPdgRatio%><input type=hidden value='��������(��)��<%=dPdgRatio%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        <tr id=<%=jRow++%>>
            <td width=50%><b>�յ�ʱ��:</b><%=DataConvert.toString(sBeginTime)%><input type=hidden value='�յ�ʱ�䣺<%=DataConvert.toString(sBeginTime)%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>���ʱ��:</b><%=DataConvert.toString(sEndTime)%><input type=hidden value='���ʱ�䣺<%=DataConvert.toString(sEndTime)%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        
        <tr id=<%=jRow++%>>
            <td  colspan=2 align=center>
                <textarea type=textfield  bgcolor="#FDFDF3" readonly style="width:100%;height:170px;resize: none;">
                     <%="\r\n�������"+ StringFunction.replace(DataConvert.toString(sSelfOpinion).trim(),"\\r\\n","\r\n")
                     %>
                </textarea>
            <input type=hidden value='<%="\r\n�������"+StringFunction.replace(DataConvert.toString(sSelfOpinion).trim(),"\\r\\n","\r\n")%>' name=<%="R"+String.valueOf(jRow)+"L"%>>
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
	else	iRowCount =<%=iRow%>;

	var iColCount = 2;
	var sHeader = "��ҵ��Ʒ�֡�"+"<%=sBusinessTypeName%>"+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+" ����ˮ�š�"+"<%=sObjectNo%>";

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
	
	for(i=1;i<=iRowCount;i++){
		if(document.forms["opinion"].elements["R"+i+"R"].value == "amarsoft"){	//�����ֻ����һ��һ��
			sContentNew += "<tr height=50 style='mso-height-source:userset;height:38.1pt'>";
			sContentNew += "    <td colspan="+iColCount+" align=left style='background-color:#CCC8EB;color:black;padding-left:2px;mso-font-charset:0;vertical-align:top;text-align:left;'>"+document.forms["opinion"].elements["R"+i+"L"].value+"</td>";
			sContentNew += "</tr>";
		}else{
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