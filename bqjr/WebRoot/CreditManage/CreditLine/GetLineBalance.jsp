<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.creditline.bizlets.*"%>
<%@ page import="com.amarsoft.biz.bizlet.Bizlet"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hwang 2009-06-22
		Tester:
		Describe: ȡ������
		Input Param:
			LineNo:���Э���(��ȵĺ�ͬ��ˮ��)
		Output Param:
			
		HistoryLog:
			
	 */
	%>
<%/*~END~*/%> 


<% 
//��ò�����������ˮ�š��������͡������š��ͻ����͡��ͻ�ID
String sLineNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LineNo"));
String sSql="";
double dLineBalance = 0.0;//������
//����ֵת���ɿ��ַ���
if(sLineNo == null) sLineNo = "";	

//ȡ������
Bizlet bzGetCreditLineBalance = new GetCreditLineBalance();
bzGetCreditLineBalance.setAttribute("LineNo",sLineNo);
String sCreditBalance=(String)bzGetCreditLineBalance.run(Sqlca);
dLineBalance = Double.valueOf(sCreditBalance).doubleValue();
	
	
%>
<html>



<body bgcolor="#EAEAEA" >
<table align="center">
	<tr>
		<td><font size='5' color='blue'>������</font></td>
	</tr>
</table></br>
<table border="0" width="100%" id="table1" cellspacing="0" cellpadding="0" bordercolordark="#000000">	
	<tr>
		<td width="200">&nbsp;&nbsp;&nbsp;&nbsp;�����</td>
		<td><%=DataConvert.toMoney(dLineBalance)%></td>
	</tr>	
</table><br><br>
<table valign="bottom" width="100%" border="0" cellspacing="0" cellpadding="3"  bordercolordark="#FFFFFF">
		<tr>
			<td align = center> 
		    	<input type="button" style="width:50px"  value=" ��  �� " class="button" onclick="javascipt: self.close();">
		    </td>
	    </tr>
</table>

</body>

</html>



<%@ include file="/IncludeEnd.jsp"%>