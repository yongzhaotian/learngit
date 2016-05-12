<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.creditline.bizlets.*"%>
<%@ page import="com.amarsoft.biz.bizlet.Bizlet"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hwang 2009-06-22
		Tester:
		Describe: 取额度余额
		Input Param:
			LineNo:额度协议号(额度的合同流水号)
		Output Param:
			
		HistoryLog:
			
	 */
	%>
<%/*~END~*/%> 


<% 
//获得参数：申请流水号、对象类型、对象编号、客户类型、客户ID
String sLineNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LineNo"));
String sSql="";
double dLineBalance = 0.0;//额度余额
//将空值转化成空字符串
if(sLineNo == null) sLineNo = "";	

//取额度余额
Bizlet bzGetCreditLineBalance = new GetCreditLineBalance();
bzGetCreditLineBalance.setAttribute("LineNo",sLineNo);
String sCreditBalance=(String)bzGetCreditLineBalance.run(Sqlca);
dLineBalance = Double.valueOf(sCreditBalance).doubleValue();
	
	
%>
<html>



<body bgcolor="#EAEAEA" >
<table align="center">
	<tr>
		<td><font size='5' color='blue'>额度余额</font></td>
	</tr>
</table></br>
<table border="0" width="100%" id="table1" cellspacing="0" cellpadding="0" bordercolordark="#000000">	
	<tr>
		<td width="200">&nbsp;&nbsp;&nbsp;&nbsp;额度余额：</td>
		<td><%=DataConvert.toMoney(dLineBalance)%></td>
	</tr>	
</table><br><br>
<table valign="bottom" width="100%" border="0" cellspacing="0" cellpadding="3"  bordercolordark="#FFFFFF">
		<tr>
			<td align = center> 
		    	<input type="button" style="width:50px"  value=" 关  闭 " class="button" onclick="javascipt: self.close();">
		    </td>
	    </tr>
</table>

</body>

</html>



<%@ include file="/IncludeEnd.jsp"%>