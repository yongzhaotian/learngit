<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   ndeng  2005.05.23
		Tester:
		Content: �������������ѯҳ��
		Input Param:

		Output param:

		History Log: 

	 */
	%>
<%/*~END~*/%>


<html>
<head> 
<title>�������ѯ��Ϣ</title>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������

	
	//����������	

	//���ҳ�����	

	%>
<%/*~END~*/%>


<script type="text/javascript">

	function newCustomer()
	{
		var sApproveType = document.all("ApproveType").value;
		var sApplyTime = document.all("ApplyTime").value;
		var sApplyTime2 = document.all("ApplyTime2").value;
		var sApproveTime = document.all("ApproveTime").value;
		var sApproveTime2 = document.all("ApproveTime2").value;
		var sCustomerID = document.all("CustomerID").value;
		var sCustomerName = document.all("CustomerName").value;
		var sType = document.all("Type").value;
		var sCurrency = document.all("Currency").value;
		var sSum = document.all("Sum").value;
		var sSum2 = document.all("Sum2").value;
		var sApplySerialNo = document.all("ApplySerialNo").value;
		var sApproveSerialNo = document.all("ApproveSerialNo").value;
		var sIsFirst = document.all("IsFirst").value;
		
		if(sApproveType =="" && sApplyTime =="" && sApplyTime2 =="" && sApproveTime == "" && sApproveTime2 == "" && sCustomerID == "" && sCustomerName =="" && sType =="" && sCurrency == "" && sSum == "" && sSum2 == "" && sApplySerialNo =="" && sApproveSerialNo =="" && sIsFirst =="")
		    return;
		if(sSum != "")
		{
		    if(checkSum(sSum))
		    {
    		    alert("���Ӧ���������֣�");
    		    return;
		    } 
		}
		if(sSum2 != "")
		{
		    if(checkSum(sSum2))
		    {
    		    alert("���Ӧ���������֣�");
    		    return;
		    } 
		}
		if(sApplyTime != "")
		{
		      if(!isdate_YYYYMMDD(sApplyTime))
		      {
		          alert("������ڸ�ʽ���벻��ȷ���밴YYYY/MM/DD�ĸ�ʽ���룡");
		          return;
		      }  
		}
		if(sApplyTime2 != "")
		{
		      if(!isdate_YYYYMMDD(sApplyTime2))
		      {
		          alert("������ڸ�ʽ���벻��ȷ���밴YYYY/MM/DD�ĸ�ʽ���룡");
		          return;
		      }  
		}
		if(sApproveTime != "")
		{
		      if(!isdate_YYYYMMDD(sApproveTime))
		      {
		          alert("�������ڸ�ʽ���벻��ȷ���밴YYYY/MM/DD�ĸ�ʽ���룡");
		          return;
		      }  
		}
		if(sApproveTime2 != "")
		{
		      if(!isdate_YYYYMMDD(sApproveTime2))
		      {
		          alert("�������ڸ�ʽ���벻��ȷ���밴YYYY/MM/DD�ĸ�ʽ���룡");
		          return;
		      }  
		}
		self.returnValue=sApproveType+"@"+sApplyTime+"@"+sApplyTime2+"@"+sApproveTime+"@"+sApproveTime2+"@"+sCustomerID+"@"+sCustomerName+"@"+sType+"@"+sCurrency+"@"+sSum+"@"+sSum2+"@"+sApplySerialNo+"@"+sApproveSerialNo+"@"+sIsFirst;
		self.close();
	}
	//Ч�����Ƿ������� ����true��������������ַ�
	function checkSum(sSum)
	{
		var bhavechar = false;	//�����ֶ��Ƿ�����ַ�
		for(var i=0;i<=sSum.length-1;i++)
		{
			s_tmp = sSum.substring(i,i+1);
			if(s_tmp>"9" || s_tmp<"0")
			{
				bhavechar=true;		//�����ַ�		
			}
		}
		return 	bhavechar;	
	}
    function isdate_YYYYMMDD(strDate){
	   var intYear;
	   var intMonth;
	   var intDay;
	  
	   if(strDate.length!=10) return false;
	   if(strDate.charAt(4) != '/' || strDate.charAt(7) != '/') return false;
	   intYear = strDate.substring(0,4);
	   intMonth = strDate.substring(5,7);
	   intDay = strDate.substring(8,10);	   
	   if(isNaN(intYear)||isNaN(intMonth)||isNaN(intDay)) return false;
	   	   
	   if(intYear>9999||intYear<0) return false;
	   
	   if(intMonth>11||intMonth<0) return false;
	   
	   if (intDay>30||intDay<0) return false;
	   
	   return true;
	}
</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>
<body bgcolor="#DEDFCE">
<br>
  <table align="center" width="350" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr> 
      
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >��������������ͣ�</td>
      <td nowarp bgcolor="#F0F1DE" > 
        <select name="ApproveType">	   
			<option value=''></option>
			<option value='1'>ͬ�������������</option> 
			<option value='2'>��������������</option>   
        </select>
      </td>
    </tr>
    <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF"  >���ʱ��(YYYY/MM/DD)��</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="ApplyTime" value="" style='width:80px'> �� <input type='text' name="ApplyTime2" value="" style='width:80px'>
      </td>
    </tr>
    <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF"  >����ʱ��(YYYY/MM/DD)��</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="ApproveTime" value="" style='width:80px'> �� <input type='text' name="ApproveTime2" value="" style='width:80px'>
      </td>
    </tr>
    <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF"  >�ͻ��ţ�</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="CustomerID" value="" >
      </td>
    </tr>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >�ͻ����ƣ�</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="CustomerName" value="" style='width:200px'>
      </td>
   </tr>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >ҵ��Ʒ�֣�</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="Type" value="">
      </td>
   </tr>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >���֣�</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <select name="Currency">	
            <option value=''></option>   
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'Currency'",1,2,"")%>
        </select>
      </td>
   </tr>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >���(Ԫ)��</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="Sum" value="" style='width:80px'> �� <input type='text' name="Sum2" value="" style='width:80px'>
      </td>
   </tr>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >������ˮ�ţ�</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="ApplySerialNo" value="">
      </td>
   </tr>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >�������������ˮ�ţ�</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="ApproveSerialNo" value="">
      </td>
   </tr>
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >�Ƿ��ױʣ�</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <select name="IsFirst">	
            <option value=''></option>
            <%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'YesOrNo'",1,2,"")%>
        </select>
      </td>
   </tr>
   <tr>
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" height="25" >&nbsp;</td>
      <td nowarp bgcolor="#F0F1DE" height="25"> 
        <input type="button" name="next" value="ȷ��" onClick="javascript:newCustomer()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
        
        <input type="button" name="Cancel" value="ȡ��" onClick="javascript:self.returnValue='_none_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
   </tr>
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>