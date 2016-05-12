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
	
    String sRelativeSerialNo = "",sOperateOrgName = "",sOperateUserName = "",sPhaseOpinion = "123123",sRemark="123123";
	String sBusinessSum="",sBusinessCCYName="",sBusinessTypeName="",sCustomerName="";
    //查询通知书信息
	String sSql = " select BusinessSum,getItemName('Currency',BusinessCurrency) as BusinessCCYName,getBusinessName(BusinessType) as BusinessTypeName,CustomerName,RelativeSerialNo,getOrgName(OperateOrgID) as OperateOrgName,"+
	              " getUserName(OperateUserID) as OperateUserName,Remark"+
	              " from BUSINESS_APPROVE where SerialNo=:SerialNo ";
    ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(rs.next()){
	    sRelativeSerialNo = DataConvert.toString(rs.getString("RelativeSerialNo"));	 
		sOperateOrgName = DataConvert.toString(rs.getString("OperateOrgName"));
		sOperateUserName = DataConvert.toString(rs.getString("OperateUserName"));
		sRemark	= DataConvert.toString(rs.getString("Remark"));	
        sBusinessSum = DataConvert.toMoney(rs.getString("BusinessSum"));
        sBusinessCCYName = DataConvert.toString(rs.getString("BusinessCCYName"));
        sBusinessTypeName= DataConvert.toString(rs.getString("BusinessTypeName"));
        sCustomerName = DataConvert.toString(rs.getString("CustomerName"));
	}
	rs.getStatement().close();	

	//提取意见
	sSql = " select PhaseOpinion "+
           " from FLOW_TASK where SerialNo=:SerialNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(rs.next()){
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
  <h2>信用业务否决通知书</h2>
</center>
  
<table width="80%" border="0" align="center"  bordercolordark='#EEEEEE' bordercolorlight='#CCCCCC'>
  <tr> 
    <td><font face="宋体" size="2"></font></td>
    <td><font face="宋体" size="2"></font></td>
    <td><font face="宋体" size="2"></font></td>
    <td align="right"><font size="2"></font></td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="3"><font face="宋体" size="2"><b>商业银行</b><%=sOperateOrgName%></font></td>
  </tr>
  <tr> 
    <td colspan="5">&nbsp;&nbsp;&nbsp;&nbsp;<font face="宋体" size="2"><b>你行上报的</b><%=sRelativeSerialNo%><b>（审批编号）项目（</b><%=sCustomerName%>、<%=sBusinessTypeName%>、<%=sBusinessCCYName%>、<%=sBusinessSum%>）<b>已收悉，经领导批示，不同意（暂缓）办理该项目。</b></font></td>
  </tr> 
  <tr> 
    <td><font face="宋体" size="2">&nbsp;&nbsp;&nbsp;&nbsp;<b>理由如下：</b></font></td>
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
       <td><%=sRemark%></td>
  </tr>
  <tr> 
    <td><font face="宋体" size="2"></font></td>
    <td><font face="宋体" size="2"></font></td>
    <td><font face="宋体" size="2"></font></td>
    <td><font face="宋体" size="2"></font></td>
    <td><font face="宋体" size="2"></font></td>
  </tr>
  <tr> 
    <td><font face="宋体" size="2"></font></td>
    <td><font face="宋体" size="2"></font></td>
    <td><font face="宋体" size="2"></font></td>
    <td><font face="宋体" size="2"></font></td>
    <td><font face="宋体" size="2"></font></td>
  </tr>
  <tr> 
    <td><font face="宋体" size="2"></font></td>
    <td><font face="宋体" size="2"></font></td>
    <td><font face="宋体" size="2"></font></td>
    <td align="right"><font face="宋体" size="2"><b>下达审批通知书部门：</b></font></td>
    <td><font face="宋体" size="2"></font></td>
  </tr>
  <tr> 
    <td><font face="宋体" size="2"></font></td>
    <td><font face="宋体" size="2"></font></td>
    <td><font face="宋体" size="2"></font></td>
    <td align="right"><font face="宋体" size="2"><b>经办人：</b></font></td>
    <td><%=sOperateUserName%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td align="right"><font face="宋体" size="2"><b>下达时间：</b></font></td>
    <td><%=StringFunction.getToday()%></td>
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
        <tr>
            <td align="right">
                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","打印","打印审批通知书","javascript: my_Print()",sResourcesPath)%>
            </td>
            <td align="left">
                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","返回","返回","javascript: window.close()",sResourcesPath)%>
            </td>
        </tr>
    </table>
</div>

</body>

<%@ include file="/IncludeEnd.jsp"%>

