<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zywei 2003.9.5
 * Tester:
 *
 * Content: 信用业务审批通知书 
 * Input Param:
 *   		对象编号：ObjectNo
 *              ——通知书流水号:SerialNo     
 * Output param:
 *
 * History Log:  
 *                  
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<html>
<head>
<title>信用业务审批通知书</title>
</head>
<% 
	//页面参数之间的传递一定要用DataConvert.toRealString(iPostChange,只要一个参数)它会自动适应window.open
	//获取对象编号
	String sObjectNo 	  = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	//查询通知书信息
	String sSql = " select RelativeSerialNo,CustomerName,getItemName('Currency',BusinessCurrency) "+
	              " as BusinessCCYName,getBusinessName(BusinessType) as BusinessTypeName, "+
	              " BusinessSum,getItemName('VouchType',VouchType) as VouchTypeName,TermMonth, "+
	              " TermDay,BusinessRate,Purpose,Remark,Describe1,getOrgName(OperateOrgID) as OperateOrgName,"+
	              " getUserName(OperateUserID) as OperateUserName,getUserName(InputUserID) as InputUserName,getItemName('FinishOrg',FinishOrg) "+
	              " as FinishOrgName,UpdateDate from BUSINESS_APPROVE where "+
	              " SerialNo=:SerialNo ";
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	String sRelativeSerialNo = "",sCustomerName = "",sBusinessCCYName = "",sBusinessTypeName = "";
	String sBusinessSum = "",sVouchTypeName = "",sTermMonth = "",sTermDay = "";
	String sBusinessRate = "",sPurpose = "";
	String sRemark = "",sDescribe1="",sOperateOrgName = "",sOperateUserName = "",sUpdateDate = "";
	String sProjectNo = "",sProjectName = "",sSigneeName = "",sFinishOrgName = "";
	String sGuarantyTypeName = "",sGuarantyName = "",sGuarantySum = "",sInputUserName = "";
	if(rs.next())
	{
	    sRelativeSerialNo = DataConvert.toString(rs.getString("RelativeSerialNo"));
	    sCustomerName = DataConvert.toString(rs.getString("CustomerName"));
	    sBusinessCCYName = DataConvert.toString(rs.getString("BusinessCCYName"));
	    sBusinessTypeName = DataConvert.toString(rs.getString("BusinessTypeName"));
	    sBusinessSum = DataConvert.toString(rs.getString("BusinessSum"));
	    sVouchTypeName = DataConvert.toString(rs.getString("VouchTypeName"));
	    sTermMonth = DataConvert.toString(rs.getString("TermMonth"));
	    sTermDay = DataConvert.toString(rs.getString("TermDay"));
	    sBusinessRate = DataConvert.toString(rs.getString("BusinessRate"));
	    sPurpose = DataConvert.toString(rs.getString("Purpose"));
	    sRemark = DataConvert.toString(rs.getString("Remark"));
	    sDescribe1 = DataConvert.toString(rs.getString("Describe1"));
	    sOperateOrgName = DataConvert.toString(rs.getString("OperateOrgName"));
	    sOperateUserName = DataConvert.toString(rs.getString("OperateUserName"));
	    sFinishOrgName = DataConvert.toString(rs.getString("FinishOrgName"));	
	    sUpdateDate  = DataConvert.toString(rs.getString("UpdateDate"));   	  
        sInputUserName  =   DataConvert.toString(rs.getString("InputUserName"));
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
  <h2>信用业务同意通知书</h2>
</center>
  
<table width="90%" border="0" align="center"  bordercolordark='#EEEEEE' bordercolorlight='#CCCCCC'>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td align="right"><b>通知书流水号：</b></td>
    <td><%=sObjectNo%></td>
  </tr>
  <tr> 
    <td colspan="3"><b>商业银行</b><%=sOperateOrgName%></td>
  </tr>
  <tr> 
    <td colspan="5">&nbsp;&nbsp;&nbsp;&nbsp;<b>你行上报的</b><%=sRelativeSerialNo%><b>（申请书流水号）项目已收悉，经领导批示，同意你们按以下条件办理该项目：</b></td>
  </tr>
  <tr> 
    <td><b>客户名称：</b></td>
    <td colspan="4"><%=sCustomerName%></td>
  </tr>
  <tr> 
    <td><b>业务品种：</b></td>
    <td colspan="4"><%=sBusinessTypeName%></td>
  </tr>
  <tr> 
    <td><b>货币种类：</b></td>
    <td colspan="4"><%=sBusinessCCYName%></td>
  </tr>
  <tr> 
    <td><b>金额（元）：</b></td>
    <td colspan="4"><%=sBusinessSum%></td>
  </tr>  
  <tr> 
    <td><b>主要担保方式:</b></td>
    <td colspan="4"><%=sVouchTypeName%></td>
  </tr>
  <tr> 
    <td colspan="5"><b>担保详细情况：</b></td>
  </tr>
  <tr> 
    <td><b>序号</b></td>
    <td><b>担保人名称</b></td>
    <td><b>担保方式</b></td>
    <td><b>抵质押物名称</b></td>
    <td><b>担保金额（折合人民币元）</b></td>
  </tr>
  <%
    int j = 0;
    //查询担保信息
	sSql = " select GD.SigneeName,getItemName('VouchType',GD.GuarantyType) as GuarantyTypeName, "+
	       " GD.GuarantyName,GD.GuarantySum from GUARANTY_DETAIL GD,APPROVE_RELATIVE AR "+
	       " where AR.ObjectType = 'GuarantyDetail' and AR.SerialNo = '"+ sObjectNo +"' "+
	       " and AR.ObjectNo = GD.SerialNo ";
	rs = Sqlca.getASResultSet(sSql);
	while(rs.next())
	{
	    j = j + 1;
	    sSigneeName = DataConvert.toString(rs.getString("SigneeName"));
	    sGuarantyTypeName = DataConvert.toString(rs.getString("GuarantyTypeName"));
	    sGuarantyName = DataConvert.toString(rs.getString("GuarantyName"));
	    sGuarantySum = DataConvert.toString(rs.getString("GuarantySum"));	   
  %>
  <tr> 
    <td><%=j%></td>
    <td><%=sSigneeName%></td>
    <td><%=sGuarantyTypeName%></td>
    <td><%=sGuarantyName%></td>
    <td><%=sGuarantySum%></td>
  </tr>
  <%
    }
    rs.getStatement().close();
  %>
  <tr> 
    <td><b>期限：</b></td>
    <td colspan="4"><%=sTermMonth%><b>个月</b><%=sTermDay%><b>天</b></td>
  </tr>
  <tr> 
    <td><b>月利率（‰）：</b></td>
    <td colspan="4"><%=sBusinessRate%></td>
  </tr>
  <tr> 
    <td><b>用途：</b></td>
    <td colspan="4"><%=sPurpose%></td>
  </tr>
  <tr> 
    <td><b>其他条件和要求：</b></td>
    <td colspan="4"><%=sDescribe1%></td>
  </tr>
  <tr> 
    <td><b>备注：</b></td>
    <td colspan="4"><%=sRemark%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td align="right" width=150px><b>下达审批通知书部门：</b></td>
    <td><%=sFinishOrgName%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td align="right"><b>审查部门经办人员：</b></td>
    <td><%=sInputUserName%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td align="right"><b>经办人：</b></td>
    <td><%=sOperateUserName%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td align="right"><b>下达时间：</b></td>
    <td><%=sUpdateDate%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
<tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
<div id='PrintButton'> 
<table width=100%>
    <tr align="center">
        <td align="right">
            <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","打印","打印审批通知书","javascript: my_Print()",sResourcesPath)%>
        </td>
        <td align="left">
            <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","返回","返回","javascript: window.close();",sResourcesPath)%>
        </td>
    </tr>
</table>
</div>
</body>

<%@ include file="/IncludeEnd.jsp"%>

