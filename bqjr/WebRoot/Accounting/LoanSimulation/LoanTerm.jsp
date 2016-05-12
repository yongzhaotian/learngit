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
<title>咨询贷款期限</title> 
</head>
<body class="pagebackground" leftmargin="0" topmargin="0" onload="" >
<form name="frm">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> 
   <td height="1"> 
     <table id=table0 cols=3 border=0 cellpadding=0 cellspacing=0>
       <tr> 
         <td nowrap class="groupboxheader">
          	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;咨询贷款期限&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
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
			贷款种类：
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
		    贷款分类：
		</td>	
	</tr>
	<tr>		
		<td align=center width=100%>
		<select disabled=true name="LoanCatolog" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:110pt;height:13pt'>
   
   	     	
		<option selected=true value="3">商业性贷款</option>
        <option  value="1">公积金贷款</option>
		</select>
		</td>
	</tr>	
 -->		
	<tr>
		<td width=100% align=center>
		   贷款总金额(元)：
		</td>
	</tr>
	<tr>		
		<td width=100% align=center>
		  <input  value="" type=text name="LoanSum" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1>
		</td>  
	</tr>	   
	
	<tr>
		<td width=100% align=center>
		   期还款本息额(元)：
		</td>
	</tr>
	<tr>		
		<td width=100% align=center>
		  <input  value="" type=text name="LoanMonthPay" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1>
		</td>  
	</tr>	 
	
	<tr>
		<td width=100% align=center>
		   贷款期利率(‰)：
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
		  <td align=right><%=HTMLControls.generateButton("计算","进行贷款计算","javascript:Calculate()",sResourcesPath)%></td>
          <td><%=HTMLControls.generateButton("清空","清空","javascript:Cancel()",sResourcesPath)%></td>
    </tr>	
</table>   
<p><p><p><p>
<table width=100% align=center> 
    <tr width=100% align=center>
    	  <td width=100% align=center>
    	    贷款期限:
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
        alert("你的贷款总金额不能为空！");
        return;
    }
    if (document.frm.LoanMonthPay.value=="")
    {
        alert("你的贷款期还款本息额不能为空！");
        return;
    }
    if (document.frm.LoanMonthRate.value=="")
    {
        alert("你的贷款期利率不能为空！");
        return;
    }
    if (reg_Num(document.frm.LoanSum.value)!=1)
    {
    	alert("你的贷款总金额应该为数字！");
    	return;
    
    }
    if (reg_Num(document.frm.LoanMonthPay.value)!=1)
    {
    	alert("你的贷款期还款本息额应该为数字！");
    	return;
    
    }
    if (reg_Num(document.frm.LoanMonthRate.value)!=1)
    {
    	alert("你的贷款期利率应该为数字！");
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

function reg_Int(str)//是整数,返回true.
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

function reg_Num(str)//是数字,返回true.
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