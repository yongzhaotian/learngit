<%@page import="com.amarsoft.dict.als.manage.NameManager"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   wmzhu 2013/10/11
		Tester:
		Content:  打印通用凭证
		Input Param:

	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义变量，获取参数;]~*/%>
<%
		String sSerialNo = DataConvert.toRealString(iPostChange,(String) CurPage.getParameter("SerialNo"));//交易流水号
		if(sSerialNo == null) sSerialNo = "";
		String sCheckAccountNo = "";//扎帐序号
		String sHostNo = "";//主机编号
		String sOldHostNo = "";//原主机编号
		String sLogID = "";//日志号
		String sTransCode = "";//交易码
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
	<input type=button value='打印设置' onclick="WebBrowser1.ExecWB(8,1)">
	<input type=button value='打印预览' onclick="WebBrowser1.ExecWB(7,1)">
	<input type=button value=' 打  印 ' onclick="WebBrowser1.ExecWB(6,1)">
	<input type=button value=' 返  回 ' onclick="goBack()">
	</div>
	<table width='600'  hidden="200">
	<tr><td colspan="3"></td></tr>
	<tr><td colspan="3"></td></tr>
	<tr><td colspan="3"></td></tr>
	<tr><td colspan="3"></td></tr>
	<tr>
	<td colspan="3" align="center"><h2><span></span>通用凭证</h2></td>
	</tr>
	<tr><td colspan="3"></td></tr>
	<tr><td colspan="3"></td></tr>
	<tr>
	<td colspan="3" align="center" style="font-size: 18"><%=sToday.substring(0,4)+" 年 "+sToday.substring(5,7)+" 月 "+sToday.substring(8,10)+" 日"   %></td>
	</tr>
	<tr><td colspan="3"></td></tr>
	<tr><td colspan="3"></td></tr>
	<tr><td colspan="3"></td></tr>
	<tr><td colspan="3"></td></tr>
	
			<tr>
				<td class="fontStyle"  id="tdStyle">扎帐序号：<%=sCheckAccountNo==null?"&nbsp;": sCheckAccountNo%></td>
				<td id="tdStyle"></td>
				<td class=fontStyle id="tdStyle">附件____张</td>
			</tr>
			<tr><td colspan="3"></td></tr>
			<tr><td colspan="3"></td></tr>
			<tr>
				<td class=fontStyle id="tdStyle">主机流水号：<%=sHostNo==null?"&nbsp;":sHostNo %></td>
				<td class=fontStyle id="tdStyle">原主机流水号：<%=sOldHostNo==null?"&nbsp;":sOldHostNo %></td>
				<td></td>
			</tr>
			<tr><td colspan="3"></td></tr>
			<tr><td colspan="3"></td></tr>
			<tr>
				<td class=fontStyle>日&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;期：<%=StringFunction.getTodayNow() %> </td>
				<td class=fontStyle>日&nbsp;&nbsp;&nbsp;志&nbsp;&nbsp;&nbsp;号：<%=sLogID==null?"&nbsp;":sLogID %></td>
				<td class=fontStyle>交&nbsp;&nbsp;易&nbsp;&nbsp;码：<%=sTransCode==null?"&nbsp;":sTransCode %></td>
			</tr>
			<tr><td colspan="3"></td></tr>
			<tr><td colspan="3"></td></tr>
			<tr>
				<td class=fontStyle>终&nbsp;&nbsp;端&nbsp;&nbsp;号：</td>
				<td class=fontStyle>授&nbsp;权&nbsp;柜&nbsp;员：<%=sApproveUser==null?"":NameManager.getUserName(sApproveUser)%></td>
				<td class=fontStyle>柜&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;员：<%=CurUser.getUserName() %></td>
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