<!--create by bxzhou at 2003.08.14-->
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
  double MonthPay=0.0D;
  double MonthRate=0.0D;
  double Sum=0.0D;
  
  
  String sMonthPay ="";
  String sMonthRate ="";
  String sSum = "";

%>
<html>
<head>
<title>��ѯ��������</title> 
</head>
<body class="pagebackground" leftmargin="0" topmargin="0" onload="" >
<form name="frm">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> 
   <td height="1"> 
     <table id=table0 cols=3 border=0 cellpadding=0 cellspacing=0>
       <tr> 
         <td nowrap class="groupboxheader">
          	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��ѯ��������&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
         <td nowrap><img class=groupboxcornerimg src=<%=sResourcesPath%>/1x1.gif width="1" height="1" name="Image1"></td>
       </tr>
     </table>
   </td>
 </tr>
 </table>
<p><p><p><p><p><p><p><p><p><p><p>
<table width=100%>
<!-- 
	<tr width=100%>
		<td width=100% align=center>
			�������ࣺ
		</td>
	</tr>
	<tr>	
		<td align=center width=100%>
		<select name="LoanType" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:110pt;height:13pt'>
<%
    	String sSql = "select TypeNo,TypeName from Business_Type";
  		ASResultSet rs = Sqlca.getASResultSet(sSql);
   	    while(rs.next())
   	    {
%>   	    
   	     	
		<option  value="<%=rs.getString("TypeNo")%>"><%=rs.getString("TypeName")%></option>
<%
        }
        rs.getStatement().close();
%>
		</select>
		</td>
	</tr>
	
	<tr>
		<td width=100% align=center>
		    ������ࣺ
		</td>	
	</tr>
	<tr>		
		<td align=center width=100%>
		<select disabled=true name="LoanCatolog" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:110pt;height:13pt'>
   
   	     	
		<option selected=true value="3">��ҵ�Դ���</option>
        <option  value="1">���������</option>
		</select>
		</td>
	</tr>	
 -->		
	<tr>
		<td width=100% align=center>
		   �����ܽ��(Ԫ)��
		</td>
	</tr>
	<tr>		
		<td width=100% align=center>
		  <input  value="" type=text name="LoanSum" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1>
		</td>  
	</tr>	   
	
	<tr>
		<td width=100% align=center>
		   �ڻ��Ϣ��(Ԫ)��
		</td>
	</tr>
	<tr>		
		<td width=100% align=center>
		  <input  value="" type=text name="LoanMonthPay" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1>
		</td>  
	</tr>	 
	
	<tr>
		<td width=100% align=center>
		   ����������(��)��
		</td>
	</tr>
	<tr>		
		<td width=100% align=center>
		  <input  value="" type=text name="LoanMonthRate" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1>
		</td>  
	</tr>
</table>
<p><p><p><p>
<table width=100% align=center>	
	<tr>
		  <td align=right><%=HTMLControls.generateButton("����","���д������","javascript:Calculate()",sResourcesPath)%></td>
          <td><%=HTMLControls.generateButton("���","���","javascript:Cancel()",sResourcesPath)%></td>
    </tr>	
</table>   
<p><p><p><p>
<table width=100% align=center> 
    <tr width=100% align=center>
    	  <td width=100% align=center>
    	    ��������:
    	  </td>
    </tr>
	<tr width=100% align=center>		  
    	  <td width=100% align=center>
		  <input  value="" readonly=true type=text name="LoanTerm" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1>
		 </td> 
    </tr> 
</table>
</form>
</body>

</html>


<script>

function Calculate()
{   
    if (document.frm.LoanSum.value=="")
    {
        alert("��Ĵ����ܽ���Ϊ�գ�");
        return;
    }
    if (document.frm.LoanMonthPay.value=="")
    {
        alert("��Ĵ����ڻ��Ϣ���Ϊ�գ�");
        return;
    }
    if (document.frm.LoanMonthRate.value=="")
    {
        alert("��Ĵ��������ʲ���Ϊ�գ�");
        return;
    }
    if (reg_Num(document.frm.LoanSum.value)!=1)
    {
    	alert("��Ĵ����ܽ��Ӧ��Ϊ���֣�");
    	return;
    
    }
    if (reg_Num(document.frm.LoanMonthPay.value)!=1)
    {
    	alert("��Ĵ����ڻ��Ϣ��Ӧ��Ϊ���֣�");
    	return;
    
    }
    if (reg_Num(document.frm.LoanMonthRate.value)!=1)
    {
    	alert("��Ĵ���������Ӧ��Ϊ���֣�");
    	return;
    
    }
	sMonthPay = document.frm.LoanMonthPay.value;
	sMonthRate = document.frm.LoanMonthRate.value;
	sSum = document.frm.LoanSum.value;
    var rtValue = PopPage("/Accounting/LoanSimulation/GetResultTerm.jsp?MonthPay="+sMonthPay+"&MonthRate="+sMonthRate+"&Sum="+sSum+"&rand="+randomNumber(),"","dialogWidth=18;dialogHeight=13;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
	document.frm.LoanTerm.value = rtValue;
}


function Cancel()
{
   document.frm.LoanMonthRate.value=""; 
   document.frm.LoanMonthPay.value=""; 
   document.frm.LoanSum.value=""; 
   document.frm.LoanTerm.value=""; 
}

function reg_Int(str)//������,����true.
{
	var Letters = "1234567890";
	for (i=0;i<str.length;i++)
	{
		var CheckChar = str.charAt(i);
		if (Letters.indexOf(CheckChar) == -1)
		{
			return false;
		}
	}
	return 1;
}

function reg_Num(str)//������,����true.
{
	var Letters = "1234567890.";
	for (i=0;i<str.length;i++)
	{
	var CheckChar = str.charAt(i);
	if (Letters.indexOf(CheckChar) == -1){return false;}
	}
	return 1;
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>