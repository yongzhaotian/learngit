<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: byhu 2004.12.21
 * Tester:
 *
 * Content: 查看审批详情
 * Input Param:
 *      ObjectType: 对象类型
 *          CreditApply: 申请
 *          ApproveApply: 最终审批意见
 *          PutOutApply:  出帐
 *      ObjectNo:   对象编号
 *		FlowNo：流程号
 *		PhaseNo：阶段号
 * Output param:
 *
 * History Log: zywei 2006/02/22 增加查看自己签署的意见（背靠背签署）
 				xhgao 2009/06/26   增加转出至电子表格的功能
 				fwang 2009/08/10  修改当审批意见为空时，提示信息方式
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//获取页面参数
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
    String sObjectNo= DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	String sCurFlowNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("FlowNo"));
	String sCurPhaseNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("PhaseNo"));
	
	//获取最新的字段数据
	String sSql1 = "select Max(SerialNo) as SerialNo from FLow_Task where ObjectNo =:ObjectNo and FlowNo =:FlowNo";
	String sSerialNo = Sqlca.getString(new SqlObject(sSql1)
			.setParameter("ObjectNo", sObjectNo).setParameter("FlowNo", sCurFlowNo));
	sSql1 = "select PhaseNo from Flow_Task where ObjectNo =:ObjectNo and FlowNo =:FlowNo and SerialNo =:SerialNo";
	sCurPhaseNo = Sqlca.getString(new SqlObject(sSql1)
			.setParameter("ObjectNo", sObjectNo).setParameter("FlowNo", sCurFlowNo).setParameter("SerialNo", sSerialNo));
	
	//将空值转化为空字符串
	if(sObjectType==null)sObjectType="";
	if(sObjectNo==null)sObjectNo="";
	if(sCurFlowNo==null)sCurFlowNo="";
	if(sCurPhaseNo==null)sCurPhaseNo="";
	if( sObjectType.equals("ApproveOpinion") )//转换对象类型
		sObjectType="CreditApply";
    String sSql,sOpinionRightType="",sOpinionRightPhases="",sOpinionRightRoles="",sTempPrivilegePhases="",sPhaseAction="";
	boolean bRolePrivilege = false; //哪些阶段能看
	boolean bPhasePrivilege = false;//
	boolean bPhaseMatch = false;//判断当前意见所处阶段是否在对应的特权阶段

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
	int iCountRecord=0;//用于判断记录是否有审批意见
	int iRow=0,jRow=0;//用于标记行数
	
	ASResultSet rs = null;
	String sTableName ="BUSINESS_APPLY",sBusinessTypeName="";
	if(sObjectType.equals("CreditApply"))	sTableName = "BUSINESS_CONTRACT";
	else if(sObjectType.equals("ApproveApply"))	sTableName = "BUSINESS_APPROVE";
	else if(sObjectType.equals("PutOutApply"))	sTableName = "BUSINESS_PUTOUT";
	sSql =  " select getBusinessName(BusinessType) as BusinessTypeName from "+sTableName+" where SerialNo=:SerialNo ";
	SqlObject so = new SqlObject(sSql).setParameter("SerialNo",sObjectNo);
	rs = Sqlca.getASResultSet(so);
	if(rs.next()){
		sBusinessTypeName = DataConvert.toString(rs.getString("BusinessTypeName"));
	}
	rs.getStatement().close();
	
	//获取仅查看自己签署的意见所对应的阶段
	sSql = 	" select Attribute6 from FLOW_MODEL "+
			" where FlowNo =:FlowNo and PhaseNo =:PhaseNo ";
	sSelfOpinionPhase = Sqlca.getString(new SqlObject(sSql).setParameter("FlowNo",sCurFlowNo).setParameter("PhaseNo",sCurPhaseNo));
	if(sSelfOpinionPhase == null) sSelfOpinionPhase = "";
	//获取仅查看自己签署的意见信息
	if(!sSelfOpinionPhase.equals("")){
		sSql =  " select FO.CustomerName,getItemName('Currency',FO.BusinessCurrency) as BusinessCurrencyName, "+
				" FO.BusinessSum,FO.TermYear,FO.TermMonth,FO.TermDay,FO.BaseRate,FO.RateFloat,FO.BusinessRate, "+
				" getItemName('RateFloatType',FO.RateFloatType) as RateFloatTypeName,FO.BailSum,FO.BailRatio, "+
				" FO.PdgRatio,FO.PdgSum,FO.PhaseOpinion,FT.PhaseName,FT.UserName,FT.OrgName,FT.BeginTime,FT.EndTime "+
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
	
	//各级人员意见保存在 FLOW_OPINION 中 ,如果需要显示一些其他意见需要修改签署意见界面进行配套
	//FLOW_MODEL添加的读于意见查看权限的判断，通过 Attribute2,
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
<title>审批详情</title>
</head>
<body  leftmargin="0" topmargin="0" class="pagebackground"  >
  <form name="opinion">
  <table width=90%  cellpadding="0" cellspacing="0"  class="dialog_table" align="center" style="overflow:auto;overflow-x:visible;overflow-y:visible">
    <%
		while (rs.next()){
			sOpinionRightType = rs.getString("OpinionRightType");    //查看意见方式 all_except(排除一些阶段) none_except(选择一些阶段)
			sOpinionRightPhases = rs.getString("OpinionRightPhases");//不同查看意见方式对应的阶段
			sOpinionRightRoles = rs.getString("OpinionRightRoles");  //意见查看特权角色
			sPhaseAction = rs.getString("PhaseAction");
			String sDoNo = "";
			//意见显示中文
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
			String sCodeNo = "";
			//家庭成员外呼核查   意见选项
			/* if ("0080".equals(sPhaseNo1) && "WF_HARD".equals(sFlowNo1) && "HomePhoneInfoOpinionInfo".equalsIgnoreCase(sDoNo)) {
				sCodeNo = "FamilyMemberPhoneInfoCheck";
			}else{ */
				//sCodeNo = Sqlca.getString("select Coleditsource from dataobject_library where dono = '"+sDoNo+"' and Colheader = '意见详情'");//update CCS-550 合同有效性检查 审批有问 (1、在合同有效性检查页面中选择审批意见后，无法查看到审批意见) by rqiao 20150312
			//}

			// 人工审核
			/* String sBqPhaseName = Sqlca.getString(new SqlObject("SELECT PHASENAME FROM FLOW_MODEL WHERE FLOWNO=:FLOWNO AND PHASENO=:PHASENO AND PHASENAME IS NOT NULL")
				.setParameter("FLOWNO", sFlowNo1).setParameter("PHASENO", sPhaseNo1));
			if ("NCIIC信息人工检查".equals(sBqPhaseName) || "NCIIC信息人工核查".equals(sBqPhaseName)) {
				sCodeNo = "NCIICMunallChick2";
			} */
			//
			//String sOpinon = Sqlca.getString("select ItemName from Code_library where codeno = '"+sCodeNo+"' and ItemNo = '"+rs.getString("PhaseOpinion")+"'");//update CCS-550 合同有效性检查 审批有问 (1、在合同有效性检查页面中选择审批意见后，无法查看到审批意见) by rqiao 20150312
			//rs.getString("PhaseOpinion");
			
			//add CCS-550 合同有效性检查 审批有问 (1、在合同有效性检查页面中选择审批意见后，无法查看到审批意见) by rqiao 20150312
			String sColeditsource = "",sColName = "";
			String sOpinion_ItemName = "",sOpinon = "";
			ASResultSet rs_code = Sqlca.getASResultSet("select Coleditsource,ColName from Dataobject_Library where dono = '"+sDoNo+"' and coleditsourcetype = 'Code'");
			while(rs_code.next())
			{
				sColeditsource = rs_code.getString("Coleditsource");
				if(null == sColeditsource) sColeditsource = "";
				sColName = rs_code.getString("ColName");
				if(null == sColName) sColName = "";
				sOpinion_ItemName = Sqlca.getString("select ItemName from Code_library where codeno = '"+sColeditsource+"' and ItemNo = '"+rs.getString(sColName)+"'");
				if(null == sOpinion_ItemName) sOpinion_ItemName = "";
				if(!"".equals(sOpinion_ItemName))
				{
					sOpinon += sOpinion_ItemName+" \r\n";
				}
			}
			rs_code.getStatement().close();
			//end CCS-550 合同有效性检查 审批有问 (1、在合同有效性检查页面中选择审批意见后，无法查看到审批意见) by rqiao 20150312
			
			//将空值转化为空字符串
			if(sOpinionRightType == null) sOpinionRightType = "";
			if(sOpinionRightPhases == null) sOpinionRightPhases = "";
			if(sOpinionRightRoles == null) sOpinionRightRoles = "";
			if(sPhaseAction == null) sPhaseAction = "";

			//1、判断该用户是否拥有特权角色
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
			
			//2、判断当前意见所处阶段是否在模型对应的特权阶段
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
			
			//3、根据查看意见方式的不同，判断是否可以显示
			if(sOpinionRightType.equals("") || sOpinionRightType.equals("none_except")){
				bPhasePrivilege = bPhaseMatch;
			}else{
				bPhasePrivilege = !bPhaseMatch;				
			}
			
			//bPhasePrivilege = true; bRolePrivilege = true;
			//4、最终判断是否显示意见，如果不需要显示，则继续判断下一条意见
			//该用户是否具有特权角色、该阶段意见是否属于该意见可查看阶段、该阶段是否属于			
			if(!bPhasePrivilege && !bRolePrivilege && sPhaseAction.indexOf("补充资料")<0) continue;
			iCountRecord++;			
			
			//将意见翻译成中文
			String sOpinionName = "";
			
			if(rs.getString("PhaseName").startsWith("PBOC")){
				sOpinon = "PBOC已核查！";
			}
			
    %>
	  
        <tr id=<%=iRow++%>>
			<td  colspan="2" width=100%><b>阶段名称:</b><%=DataConvert.toString(rs.getString("PhaseName"))%><input type=hidden value='阶段名称：<%=DataConvert.toString(rs.getString("PhaseName"))%>' name=<%="R"+String.valueOf(iRow)+"L"%> ></td>
        </tr>
        <tr id=<%=iRow++%>>
            <td  colspan=2 >
                <%="\r\n【意见】"+StringFunction.replace(DataConvert.toString(sOpinon).trim(),"\\r\\n","\r\n")
                     %>
            </td>
        </tr>        
      
    <%
    }
    rs.getStatement().close();
    %>
    </table>
  </form>
</body>
</html>
<%
	//如果没有意见或者没有找到对应的对象，则自动关闭
	if (iCountRecord==0||sObjectNo.equals("")){
%>
<body style={color:red}>目前此业务还没有您可以查看的审批意见！</body>
<%
	}
%>
<script type="text/javascript">

</script>
<%@ include file="/IncludeEnd.jsp"%>