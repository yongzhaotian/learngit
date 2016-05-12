<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: xuzhang 2005.1.24
 * Tester:
 *
 * Content: 打印信用业务审批否决通知书 
 * Input Param:
 *   		对象编号：ObjectNo
 *              ——通知书流水号:SerialNo     
 * Output param:
 *
 * History Log:  zywei 2006/04/05 完善代码
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
	//页面参数之间的传递一定要用DataConvert.toRealString(iPostChange,只要一个参数)它会自动适应window_open
	//获取对象编号
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	
    String sRelativeSerialNo = "",sOperateOrgName = "",sOperateUserName = "",sPhaseOpinion = "",sApproveOpinion="";
	String sBusinessSum="",sBusinessCurrencyName="",sBusinessTypeName="",sCustomerName="",sFinishOrgName = "";
    //查询通知书信息
	String sSql = 	" select BusinessSum,getItemName('Currency',BusinessCurrency) as BusinessCurrencyName, "+
					" getBusinessName(BusinessType) as BusinessTypeName,CustomerName,RelativeSerialNo, "+
					" getItemName('FinishOrg',FinishOrg) as FinishOrgName,getOrgName(OperateOrgID) as OperateOrgName,"+
	              	" getUserName(OperateUserID) as OperateUserName,ApproveOpinion"+
	              	" from BUSINESS_APPROVE where SerialNo=:SerialNo ";
    ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(rs.next())
	{
	    sRelativeSerialNo = DataConvert.toString(rs.getString("RelativeSerialNo"));	 
		sFinishOrgName = DataConvert.toString(rs.getString("FinishOrgName"));
		sOperateOrgName = DataConvert.toString(rs.getString("OperateOrgName"));
		sOperateUserName = DataConvert.toString(rs.getString("OperateUserName"));
		sApproveOpinion	= DataConvert.toString(rs.getString("ApproveOpinion"));	
		sBusinessSum ="金额:"+ DataConvert.toMoney(rs.getString("BusinessSum"))+"圆";
		sBusinessCurrencyName ="币种："+ DataConvert.toString(rs.getString("BusinessCurrencyName"));
		sBusinessTypeName= DataConvert.toString(rs.getString("BusinessTypeName"));
		sCustomerName = DataConvert.toString(rs.getString("CustomerName"));
	}
	rs.getStatement().close();	

	//提取意见
	sSql = " select PhaseOpinion from FLOW_TASK where SerialNo=:SerialNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(rs.next())
	{
		sPhaseOpinion = DataConvert.toString(rs.getString(1));	       	    
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
  
<table class=table1 width='640' align=center border=0 cellspacing=0 cellpadding=2 bgcolor=white  bordercolordark='#EEEEEE' bordercolorlight='#CCCCCC'>
  <tr> 
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="3"><font face="宋体" size="3"><b><%=sOperateOrgName%></b></font></td>
  </tr>
  <tr> 
    <td colspan="3">&nbsp;&nbsp;&nbsp;&nbsp;<font face="宋体" size="3"><b>你行上报的</b><%=sRelativeSerialNo%><b>（审批编号）项目（</b><%=sCustomerName%>、<%=sBusinessTypeName%>、<%=sBusinessCurrencyName%>、<%=sBusinessSum%>）<b>已收悉，经领导批示，不同意（暂缓）办理该项目。</b></font></td>
  </tr> 
  <tr> 
    <td  colspan="3" width=25% ><font face="宋体" size="3"><b>理由如下：</b></font></td>
  </tr>
  <tr> 
       <td colspan="3"><font face="宋体" size="3">&nbsp;&nbsp;&nbsp;&nbsp;<%=sApproveOpinion%></font></td>
  </tr>
  <tr> 
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr> 
   <td colspan="3">&nbsp;</td>
  </tr>
  <tr> 
    <tr> 
  	<td width=30%>&nbsp;</td>
    <td align="right" width=40%><font face="宋体" size="3"><b>下达审批通知书部门：</b></font></td>
    <td><font face="宋体" size="2"><%=sFinishOrgName%></font></td>
  </tr>
  <tr> 
  	<td>&nbsp;</td>
    <td align="right"><font face="宋体" size="3"><b>经办客户经理：</b></font></td>
    <td><font face="宋体" size="3"><%=sOperateUserName%></font>&nbsp;</td>
  </tr>
  <tr> 
  	<td>&nbsp;</td>
    <td align="right"><font face="宋体" size="3"><b>下达时间：</b></font></td>
    <td><font face="宋体" size="3"><%=StringFunction.getToday()%></font></td>
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
        <tr>
            <td align="right">
                <%=HTMLControls.generateButton("打印","打印审批通知书","javascript: my_Print()",sResourcesPath)%>
            </td>
            <td align="left">
                <%=HTMLControls.generateButton("返回","返回","javascript: window.close()",sResourcesPath)%>
            </td>
        </tr>
    </table>
</div>

</body>

<%@ include file="/IncludeEnd.jsp"%>

