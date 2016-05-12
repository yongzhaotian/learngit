<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.accounting.config.loader.TransactionConfig,com.amarsoft.app.accounting.util.InterestFunctions,com.amarsoft.sadre.app.dict.NameManager,com.amarsoft.dict.als.manage.CodeManager" %>
<%@ include file="/IncludeBegin.jsp"%>
<%
	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sloanNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("loanNo"));
	
	String sInputUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUserID"));
	String sBailUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BailUserID"));
	String sBailOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BailOrgID"));
	String sBailsDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BailsDate"));
	String sBusinessType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessType"));
	//打印业务凭证(扣保证金)
	
	String sBusinessDate = SystemConfig.getBusinessDate();//当前系统日期
	String sYear = sBusinessDate.substring(0,4);//当前年
	String sMonth = sBusinessDate.substring(5,7);//当前月
	String sDay = sBusinessDate.substring(8,10);//当前日
	int sCount = 1;
	
	//创建交易
	AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
	BusinessObject bailInfo = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.bail_info, sObjectNo);//保证金信息
	
%>


<head>
<link rel=Stylesheet href=Resource/stylesheet.css>
</head>


<head>
<link rel=Stylesheet href=Resource/stylesheet.css>
</head>

<table width="621" height="330">
  <tr>
    <td colspan="3" align="right" style="padding-bottom:20px;"><%=sYear%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=sMonth%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=sDay%>&nbsp;</td>
  </tr>
  <tr>
    <td width="259"> 业务内容：&nbsp;<%=sBusinessType %></td>
    <td width="228"> 流水号：&nbsp;<%=sObjectNo %></td>
    <td width="124">&nbsp;</td>
  </tr>
  <tr>
    <td >借据号：&nbsp;<%=sloanNo%></td>
    <td>保证金金额：&nbsp;<%=bailInfo.getDouble("BusinessSum") %>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>币种：&nbsp;<%=CodeManager.getItemName("Currency",bailInfo.getString("Currency"))%></td>
    <td>交易类型：&nbsp;保证金追加</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3">客户名称：&nbsp;<%=bailInfo.getString("BailFromName") %></td>
  </tr>
  <tr>
    <td colspan="3">保证金账号：&nbsp;<%=bailInfo.getString("BailAccout") %></td>
  </tr>
  <tr>
    <td colspan="3">保证金来源账号：&nbsp;<%=bailInfo.getString("BailFromAccout") %></td>
  </tr>
  <tr>
    <td colspan="3">保证金来源账户名称：&nbsp;<%=bailInfo.getString("BailFromName")%></td>
  </tr>
  <tr>
    <td>经办柜员：<%= sInputUserID%> 复核柜员：<%= sBailUserID%></td>
    <td>交易机构：<%= sBailOrgID%>交易码：</td>
    <td>交易时间：<%= sBailsDate%></td>
  </tr>
</table>

<div id='PrintButton'> 
<table width=100%>
    <tr align="center">
        <td align="right" id="print">
            <%=HTMLControls.generateButton("打印","打印审批通知书","javascript: my_Print()",sResourcesPath)%>
        </td>
        <td align="left" id="back">
            <%=HTMLControls.generateButton("返回","返回","javascript: window.close();",sResourcesPath)%>
        </td>
    </tr>
</table>
</div>
<script language=javascript>
		
		function my_Print()
		{
			var print=document.getElementById("PrintButton").innerHTML;
			document.getElementById("PrintButton").innerHTML="";
			window.print();
			var sPrintCount=<%=sCount%>+1;
			document.getElementById("PrintButton").innerHTML=print;
		}
		
		function my_Cancle()
		{
			self.close();
		}		
		
		function beforePrint()
		{
			document.all('PrintButton').style.display='none';
		}
		
		function afterPrint()
		{
			document.all('PrintButton').style.display="";
		}
</script>

<%@	include file="/IncludeEnd.jsp"%>