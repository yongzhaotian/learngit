<!--create by bxzhou at 2003.08.14-->
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
  double MonthPay=0.0D;
  double MonthRate=0.0D;
  double LoanSum=0.0D;
  int    Term=0;
  
  String sMonthPay="";
  String sMonthRate="";
  String sTerm="";
%>
<html>
<head>
<title>咨询按揭金额</title> 
</head>
<body class="pagebackground" leftmargin="0" topmargin="0" onload="" >
<form name=frm action="LoanSum.jsp">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr> 
        <td height="1"> 
          <table id=table0 cols=3 border=0 cellpadding=0 cellspacing=0>
            <tr> 
              <td nowrap class="groupboxheader">
               	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;咨询按揭金额&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
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
		<select name="LoanType" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:110pt;height:13pt' onchange="CalRate();">
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
		<select disabled=true name="LoanCatolog" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:110pt;height:13pt' onChange="CalRate();">
   
   	     	
		<option selected=true value="3">商业性贷款</option>
        <option  value="1">公积金贷款</option>
		</select>
		</td>
	</tr>	
-->		
	<tr>
		<td width=100% align=center>
		   贷款期限(月)：
		</td>
	</tr>
	<tr>		
		<td width=100% align=center>
		  <input  value="" type=text name="LoanTerm" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1 >
		</td>  
	</tr>	   
	
	<tr>
		<td width=100% align=center>
		   月还款本息额(元)：
		</td>
	</tr>
	<tr>		
		<td width=100% align=center>
		  <input  value="" type=text name="LoanMonthPay" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1 onblur="CalRate();">
		</td>  
	</tr>	 
	
	<tr>
		<td width=100% align=center>
		   贷款月利率(‰)：
		</td>
	</tr>
	<tr>		
		<td width=100% align=center>
		  <input  value="" type=text name="LoanMonthRate" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1 onChange2="CalRate();">
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
    	    贷款总金额(元):
    	  </td>
    </tr>
	<tr width=100% align=center>		  
    	  <td width=100% align=center>
		  <input  value="" readonly=true type=text name="LoanSum" style='FONT-SIZE: 9pt;border-style:groove;text-align:right;width:90pt;height:13pt'  size=1 >
		  </td> 
    </tr> 
</table>

</form>
</body>
</html>



<script>

function Calculate()
{   
    if (document.frm.LoanTerm.value=="")
    {
        alert("你的贷款期限不能为空！");
        return;
    }
    if (document.frm.LoanMonthPay.value=="")
    {
        alert("你的贷款月还款本息额不能为空！");
        return;
    }
    if (document.frm.LoanMonthRate.value=="")
    {
        alert("你的贷款月利率不能为空！");
        return;
    }
    if (reg_Int(document.frm.LoanTerm.value)!=1)
    {
    	alert("你的贷款期限应该为整数！");
    	return;
    
    }
    if (reg_Num(document.frm.LoanMonthPay.value)!=1)
    {
    	alert("你的贷款月还款本息额应该为数字！");
    	return;
    
    }
    if (reg_Num(document.frm.LoanMonthRate.value)!=1)
    {
    	alert("你的贷款月利率应该为数字！");
    	return;
    
    }
    
    if (parseFloat(document.frm.LoanTerm.value)<=0)
    {
        alert("你的贷款期限不能为零！");
        return;
    }
    if (parseFloat(document.frm.LoanMonthPay.value)<=0)
    {
        alert("你的贷款月还款本息额不能为零！");
        return;
    }
    if (parseFloat(document.frm.LoanMonthRate.value)<=0)
    {
        alert("你的贷款月利率不能为零！");
        return;
    }
    
	sMonthPay = parseFloat(document.frm.LoanMonthPay.value);
	sMonthRate = parseFloat(document.frm.LoanMonthRate.value);
	sTerm = parseFloat(document.frm.LoanTerm.value);
    var rtValue = PopPage("/Accounting/LoanSimulation/GetResultSum.jsp?MonthPay="+sMonthPay+"&MonthRate="+sMonthRate+"&Term="+sTerm+"&rand="+randomNumber(),"","dialogWidth=18;dialogHeight=13;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
	document.frm.LoanSum.value = rtValue;
}

function CalRate()
{

    if (reg_Int(document.frm.LoanTerm.value)!=1)
    {
    	alert("你的贷款期限应该为整数！");
    	return;
    }
    /*
    if (document.frm.LoanTerm.value!="")
    {
    	var LoanType,LoanSubType;
	    LoanType=document.frm.LoanType.value;
	    LoanSubType=document.frm.LoanCatolog.value;
	    sTerm = document.frm.LoanTerm.value;
	    var rtValue = PopPage("/CreditManage/CreditConsult/CalTools/GetLoanRate.jsp?LoanType="+LoanType+"&LoanSubType="+LoanSubType+"&Term="+sTerm+"&rand="+randomNumber(),"","dialogWidth=18;dialogHeight=13;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
	    if(rtValue == "false")
	    {
	    	alert("无该业务品种或期限的对应利率，请手工调整！");
	    	document.frm.LoanMonthRate.focus();
	    	return;
	    }
	    else
	    {
	    	document.frm.LoanMonthRate.value = rtValue;
	    }
	}	
	*/
}

function Cancel()
{
   document.frm.LoanMonthRate.value=""; 
   document.frm.LoanMonthPay.value=""; 
   document.frm.LoanTerm.value=""; 
   document.frm.LoanSum.value="";
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
	if (Letters.indexOf(CheckChar) == -1)
	{
	return false;
	}
	}
	return 1;
}
</script>
<%@ include file="/IncludeEnd.jsp"%>