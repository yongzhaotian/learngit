<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	/*
		Content: 预警信息查询页面
	 */
	//定义变量
	String sCustomerType="",sCertType = "";;
%>
<html>
<head> 
<title>请输入查询信息</title>
<script type="text/javascript">
	function newCustomer(){
		var sTime = document.all("time").value;
		var sCustomerName = document.all("CustomerName").value;
		var sCustomerID = document.all("CustomerID").value;
		var sCertID = document.all("CertID").value;
		var sOrgName = document.all("OrgName").value;
		var sUserName = document.all("UserName").value;
		if(sTime =="" && sCustomerName =="" && sCustomerID == "" && sCertID == "" && sOrgName =="" && sUserName =="")
		    return;
		self.returnValue=sTime+"@"+sCustomerName+"@"+sCustomerID+"@"+sCertID+"@"+sOrgName+"@"+sUserName;
		self.close();
	}
</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#DEDFCE">
<br>
  <table align="center" width="329" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr> 
      
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >选择时间区间：</td>
      <td nowarp bgcolor="#F0F1DE" > 
        <select name="time">	   
			<!--<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CustomerType' and ItemNo != '"+sCustomerType+"' and ItemNo like '"+sCustomerType+"%'",1,2,"")%>-->
			<option value=''></option>
			<option value='1'>一周内</option> 
			<option value='2'>十天内</option> 
			<option value='3'>一个月内</option> 	   
        </select>
      </td>
    </tr>
    <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF"  >客户名称：</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="CustomerName" value="" style='width:200px' >
      </td>
    </tr>
    <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF"  >客户编号：</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="CustomerID" value="" >
      </td>
    </tr>
    <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF"  >证件号码：</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="CertID" value="" >
      </td>
    </tr>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >机构名称：</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="OrgName" value="">
      </td>
   </tr>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >人员名称：</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="UserName" value="">
      </td>
   </tr>
   <tr>
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" height="25" >&nbsp;</td>
      <td nowarp bgcolor="#F0F1DE" height="25"> 
        <input type="button" name="next" value="确认" onClick="javascript:newCustomer()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
        <input type="button" name="Cancel" value="取消" onClick="javascript:self.returnValue='_none_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
   </tr>
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>