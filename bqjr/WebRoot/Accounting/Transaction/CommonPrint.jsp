<%@page import="com.amarsoft.dict.als.manage.NameManager"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   wmzhu 2013/10/11
		Tester:
		Content:  ��ӡͨ��ƾ֤
		Input Param:

	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=�����������ȡ����;]~*/%>
<%
		String sSerialNo = DataConvert.toRealString(iPostChange,(String) CurPage.getParameter("SerialNo"));//������ˮ��
		if(sSerialNo == null) sSerialNo = "";
		String sCheckAccountNo = "";//�������
		String sHostNo = "";//�������
		String sOldHostNo = "";//ԭ�������
		String sLogID = "";//��־��
		String sTransCode = "";//������
		String sApproveUser = "";
		
		
		ASResultSet rs = null;
		String sSql = "select * from ACCT_TRANSACTION where SerialNo=:serialNo";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("serialNo",sSerialNo));
		if(rs.next()){
			sCheckAccountNo = rs.getString("CheckAccountNo");
			sHostNo = rs.getString("HostSerialNo");
			sOldHostNo = rs.getString("CORERETURNSERIALNO");
			sLogID = rs.getString("LogID");
			sTransCode = rs.getString("TransCode");
			sApproveUser = rs.getString("InputUserID");
		}
		rs.close();
		String sToday = StringFunction.getToday();
%>
<html>
<style>
	.fontStyle{font-size: 14;}
	td {
	width: 
}
</style>
<body onbeforePrint="beforePrint()"  onafterprint="afterPrint()">
<object ID='WebBrowser1' WIDTH=0 HEIGHT=0 border=1  style="display:none" CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2' > </object>
<div id='PrintButton'>
	<input type=button value='��ӡ����' onclick="WebBrowser1.ExecWB(8,1)">
	<input type=button value='��ӡԤ��' onclick="WebBrowser1.ExecWB(7,1)">
	<input type=button value=' ��  ӡ ' onclick="WebBrowser1.ExecWB(6,1)">
	<input type=button value=' ��  �� ' onclick="goBack()">
	</div>
	<table width='600'  hidden="200">
	<tr><td colspan="3"></td></tr>
	<tr><td colspan="3"></td></tr>
	<tr><td colspan="3"></td></tr>
	<tr><td colspan="3"></td></tr>
	<tr>
	<td colspan="3" align="center"><h2><span></span>ͨ��ƾ֤</h2></td>
	</tr>
	<tr><td colspan="3"></td></tr>
	<tr><td colspan="3"></td></tr>
	<tr>
	<td colspan="3" align="center" style="font-size: 18"><%=sToday.substring(0,4)+" �� "+sToday.substring(5,7)+" �� "+sToday.substring(8,10)+" ��"   %></td>
	</tr>
	<tr><td colspan="3"></td></tr>
	<tr><td colspan="3"></td></tr>
	<tr><td colspan="3"></td></tr>
	<tr><td colspan="3"></td></tr>
	
			<tr>
				<td class="fontStyle"  id="tdStyle">������ţ�<%=sCheckAccountNo==null?"&nbsp;": sCheckAccountNo%></td>
				<td id="tdStyle"></td>
				<td class=fontStyle id="tdStyle">����____��</td>
			</tr>
			<tr><td colspan="3"></td></tr>
			<tr><td colspan="3"></td></tr>
			<tr>
				<td class=fontStyle id="tdStyle">������ˮ�ţ�<%=sHostNo==null?"&nbsp;":sHostNo %></td>
				<td class=fontStyle id="tdStyle">ԭ������ˮ�ţ�<%=sOldHostNo==null?"&nbsp;":sOldHostNo %></td>
				<td></td>
			</tr>
			<tr><td colspan="3"></td></tr>
			<tr><td colspan="3"></td></tr>
			<tr>
				<td class=fontStyle>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ڣ�<%=StringFunction.getTodayNow() %> </td>
				<td class=fontStyle>��&nbsp;&nbsp;&nbsp;־&nbsp;&nbsp;&nbsp;�ţ�<%=sLogID==null?"&nbsp;":sLogID %></td>
				<td class=fontStyle>��&nbsp;&nbsp;��&nbsp;&nbsp;�룺<%=sTransCode==null?"&nbsp;":sTransCode %></td>
			</tr>
			<tr><td colspan="3"></td></tr>
			<tr><td colspan="3"></td></tr>
			<tr>
				<td class=fontStyle>��&nbsp;&nbsp;��&nbsp;&nbsp;�ţ�</td>
				<td class=fontStyle>��&nbsp;Ȩ&nbsp;��&nbsp;Ա��<%=sApproveUser==null?"":NameManager.getUserName(sApproveUser)%></td>
				<td class=fontStyle>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ա��<%=CurUser.getUserName() %></td>
			</tr>
	</table>
</body>
</html>
<script type="text/javascript">

function beforePrint(){
	document.all('PrintButton').style.display='none';
}
	
function afterPrint(){
	document.all('PrintButton').style.display="";
}
	function goBack(){
		self.close();
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>