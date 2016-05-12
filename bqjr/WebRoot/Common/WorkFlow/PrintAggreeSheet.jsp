<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: xuzhang 2005.1.24
 * Tester:
 *
 * Content: 打印信用业务审批同意通知书 
 * Input Param:
 *   		对象编号：ObjectNo
 *              ——通知书流水号:SerialNo     
 * Output param:
 *
 * History Log: zywei 2006/04/05 完善代码 
 *                  
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	if(sObjectNo == null) sObjectNo = "";

	//查询通知书信息
	String sSql = " select RelativeSerialNo,CustomerName,getItemName('Currency',BusinessCurrency) "+
	              " as BusinessCurrencyName,getBusinessName(BusinessType) as BusinessTypeName,Warrantor, "+
	              " BusinessSum,getItemName('VouchType',VouchType) as VouchTypeName,TermMonth, "+
	              " TermDay,LGTerm,BusinessRate,PdgRatio,Purpose,Direction,getItemName('IndustryType',Direction) as DirectionName, "+
	              " getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,getItemName('YesOrNo',LowRisk) "+
	              " as LowRiskName,ApproveOpinion,Describe1,getOrgName(OperateOrgID) as OperateOrgName,"+
	              " getUserName(OperateUserID) as OperateUserName,getUserName(InputUserID) as InputUserName,getItemName('FinishOrg',FinishOrg) "+
	              " as FinishOrgName,UpdateDate from BUSINESS_APPROVE where "+
	              " SerialNo=:SerialNo ";
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	String sRelativeSerialNo = "",sCustomerName = "",sBusinessCurrencyName = "",sBusinessTypeName = "";
	String sBusinessSum = "",sVouchTypeName = "",sTermMonth = "",sTermDay = "",sLGTerm = "";
	String sBusinessRate = "",sPdgRatio = "",sPurpose = "",sDirectionName = "",sClassifyResult = "";
	String sLowRiskName = "",sApproveOpinion = "",sDescribe1="",sOperateOrgName = "",sOperateUserName = "",sUpdateDate = "";
	String sApplicantName = "",sProjectNo = "",sProjectName = "",sSigneeName = "",sFinishOrgName = "";
	String sGuarantyTypeName = "",sGuarantyName = "",sGuarantySum = "",sInputUserName = "",sWarrantor = "";
	if(rs.next())
	{
	    sRelativeSerialNo = DataConvert.toString(rs.getString("RelativeSerialNo"));
	    sCustomerName = DataConvert.toString(rs.getString("CustomerName"));
	    sBusinessCurrencyName = DataConvert.toString(rs.getString("BusinessCurrencyName"));
	    sBusinessTypeName = DataConvert.toString(rs.getString("BusinessTypeName"));
	    sBusinessSum = DataConvert.toMoney(rs.getString("BusinessSum"));
	    sVouchTypeName = DataConvert.toString(rs.getString("VouchTypeName"));
	    sTermMonth = DataConvert.toString(rs.getString("TermMonth"));
	    sTermDay = DataConvert.toString(rs.getString("TermDay"));
	    sLGTerm = DataConvert.toString(rs.getString("LGTerm"));
	    sBusinessRate = DataConvert.toMoney(rs.getString("BusinessRate"));
	    sPdgRatio = DataConvert.toMoney(rs.getString("PdgRatio"));
	    sPurpose = DataConvert.toString(rs.getString("Purpose"));
	    sDirectionName = DataConvert.toString(rs.getString("DirectionName"));
	    sClassifyResult = DataConvert.toString(rs.getString("ClassifyResult"));
	    sLowRiskName = DataConvert.toString(rs.getString("LowRiskName"));
	    sApproveOpinion = DataConvert.toString(rs.getString("ApproveOpinion"));
	    sDescribe1 = DataConvert.toString(rs.getString("Describe1"));
	    sOperateOrgName = DataConvert.toString(rs.getString("OperateOrgName"));
	    sOperateUserName = DataConvert.toString(rs.getString("OperateUserName"));
	    sFinishOrgName = DataConvert.toString(rs.getString("FinishOrgName"));	
	    sUpdateDate  = DataConvert.toString(rs.getString("UpdateDate"));   	  
      	sInputUserName  =   DataConvert.toString(rs.getString("InputUserName"));
      	sWarrantor = DataConvert.toString(rs.getString("Warrantor"));
	}
	rs.getStatement().close();
	//查询客户集合
	sSql = " select BA.ApplicantName from APPROVE_RELATIVE AR,BUSINESS_APPLICANT BA " +
           " where AR.ObjectType='BusinessApplicant' and AR.ObjectNo=BA.SerialNo "+
           " and AR.SerialNo=:SerialNo ";
    rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
    while(rs.next()){
		sApplicantName = sApplicantName+rs.getString("ApplicantName")+",";
	}
	
	if(sApplicantName.length() > 0){
		sApplicantName = sApplicantName.substring(0,sApplicantName.length()-1);
	}
	rs.getStatement().close();
	
	//保证人
	sSql =  " select GC.GuarantorName,getItemName('GuarantyType',GC.GuarantyType) "+
			" from GUARANTY_CONTRACT GC where exists (select AR.ObjectNo "+
			" from APPROVE_RELATIVE AR where AR.ObjectNo = GC.SerialNo "+
			" and AR.objecttype='GuarantyuContract' and AR.serialno=:serialno) "+
			" order by GC.GuarantyType";
	String sGuarantorName = "";
	rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("serialno",sObjectNo));
	while(rs.next())
	{
		sGuarantorName += rs.getString(1)+"-"+rs.getString(2)+"<br>";
	}
	
	rs.getStatement().close();		
	//抵质押物名称
	sSql  = " select getItemName('GuarantyList',GI.GuarantyType) from GUARANTY_INFO GI "+
			" where exists ( select GR.GuarantyID from GUARANTY_RELATIVE GR " +
			" where GR.GuarantyID = GI.GuarantyID and GR.ObjectType='ApproveApply' "+
			" and GR.ObjectNo =:ObjectNo) and (GI.GuarantyType = '050' "+
			" or GI.GuarantyType = '060')";
	rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("ObjectNo",sObjectNo));	
	while(rs.next()){
		sGuarantyName = rs.getString(1);
		if(sGuarantyName == null) sGuarantyName = "";
		else sGuarantyName += "&nbsp;&nbsp;";
	}
	rs.getStatement().close();	
	
%>

<script type="text/javascript">
		
		function my_Print()
		{
			window.print();
		}
		
		function my_Cancle()
		{
			self.close();
		}		
		
		function beforePrint()
		{
			document.getElementById('PrintButton').style.display='none';
		}
		
		function afterPrint()
		{
			document.getElementById('PrintButton').style.display="";
		}
</script>

<body onbeforeprint="beforePrint()"  onafterprint="afterPrint()">
<center>
  <h2>XXX银行授信业务审批通知书</h2>
</center>
  
<table class=table1 width='640' align=center border=0 cellspacing=0 cellpadding=2 bgcolor=white bordercolordark='#EEEEEE' bordercolorlight='#CCCCCC'>
  <tr> 
    <td colspan="3" align="right"><font face="宋体" size="3"><b>通知书编号：<%=sObjectNo%></b></font></td>
  </tr>
  <tr> 
    <td colspan="3"><font face="宋体" size="3"><b><%=sOperateOrgName%></b></font></td>
  </tr>
  <tr> 
    <td colspan="3"><font face="宋体" size="3">&nbsp;&nbsp;&nbsp;&nbsp;<b>你行上报的</b><%=sRelativeSerialNo%><b>（申请书流水号）项目已收悉，经领导批示，同意你们按以下条件办理该项目：</b></font>&nbsp;</td>
  </tr>
  <tr> 
    <td width=25% align=left ><font face="宋体" size="3"><b>客户名称：</b></font></td>
    <td colspan="2" width=60% align=left ><font face="宋体" size="3"><%=sCustomerName%></font>&nbsp;</td>
  </tr>
  <tr> 
    <td><font face="宋体" size="3"><b>包含其它客户：</b></font></td>
    <td colspan="2"><font face="宋体" size="3"><%=sApplicantName%></font>&nbsp;</td>
  </tr>
  <tr> 
    <td><font face="宋体" size="3"><b>业务种类：</b></font></td>
    <td colspan="2"><font face="宋体" size="3"><%=sBusinessTypeName%></font>&nbsp;</td>
  </tr>
  <tr> 
    <td><font face="宋体" size="3"><b>货币种类：</b></font></td>
    <td colspan="2"><font face="宋体" size="3"><%=sBusinessCurrencyName%></font>&nbsp;</td>
  </tr>
  <tr> 
    <td><font face="宋体" size="3"><b>金额（元）：</b></font></td>
    <td colspan="2"><font face="宋体" size="3"><%=sBusinessSum%></font>&nbsp;</td>
  </tr>  
  <tr> 
    <td><font face="宋体" size="3"><b>主要担保方式:</b></font></td>
    <td colspan="2"><font face="宋体" size="3"><%=sVouchTypeName%></font>&nbsp;</td>
  </tr>
  <tr> 
    <td><font face="宋体" size="3"><b>保证人:</b></font></td>
    <td colspan="2"><font face="宋体" size="3"><%=sWarrantor%></font>&nbsp;</td>
  </tr>
  <tr> 
    <td><font face="宋体" size="3"><b>抵质押物:</b></font></td>
    <td colspan="2"><font face="宋体" size="3"><%=sGuarantyName%></font>&nbsp;</td>
  </tr>
  <tr> 
    <td><font face="宋体" size="3"><b>期限：</b></font></td>
    <td colspan="2"><font face="宋体" size="3"><%=sTermMonth%><b>个月</b><%=sTermDay%><b>天</b></font></td>
  </tr>
  <tr> 
    <td><font face="宋体" size="3"><b>付款期限天数：</b></font></td>
    <td colspan="2"><font face="宋体" size="3"><%=sLGTerm%></font>&nbsp;</td>
  </tr>
  <tr> 
    <td><font face="宋体" size="3"><b>用途：</b></font></td>
    <td colspan="2"><font face="宋体" size="3"><%=sPurpose%></font>&nbsp;</td>
  </tr>
  <tr> 
    <td><font face="宋体" size="3"><b>风险分类：</b></font></td>
    <td colspan="2"><font face="宋体" size="3"><%=sClassifyResult%></font>&nbsp;</td>
  </tr>
  <tr> 
    <td><font face="宋体" size="3"><b>其他条件和要求：</b></font></td>
    <td colspan="2"><font face="宋体" size="3"><%=sDescribe1%></font>&nbsp;</td>
  </tr>
  <tr> 
    <td><font face="宋体" size="3"><b>最终审批意见：</b></font></td>
    <td colspan="2"><font face="宋体" size="3"><%=sApproveOpinion%></font>&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr> 
  	<td>&nbsp;</td>
    <td align="right" width=30%><font face="宋体" size="3"><b>下达审批通知书部门：</b></font></td>
    <td><font face="宋体" size="3"><%=sFinishOrgName%></font>&nbsp;</td>
  </tr>
  <tr> 
  	<td>&nbsp;</td>
    <td align="right"><font face="宋体" size="3"><b>经办客户经理：</b></font></td>
    <td><font face="宋体" size="3"><%=sOperateUserName%></font>&nbsp;</td>
  </tr>
  <tr> 
  	<td>&nbsp;</td>
    <td align="right"><font face="宋体" size="3"><b>下达时间：</b></font></td>
    <td><font face="宋体" size="3"><%=sUpdateDate%></font>&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
<tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
<div id='PrintButton'> 
<table width=100%>
    <tr align="center">
        <td align="right">
            <%=HTMLControls.generateButton("打印","打印审批通知书","javascript: my_Print()",sResourcesPath)%>
        </td>
        <td align="left">
            <%=HTMLControls.generateButton("返回","返回","javascript: window.close();",sResourcesPath)%>
        </td>
    </tr>
</table>
</div>
</body>
<%@ include file="/IncludeEnd.jsp"%>

