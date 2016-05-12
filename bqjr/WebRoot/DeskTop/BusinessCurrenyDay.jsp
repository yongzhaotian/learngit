<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: 当日业务情况
		Input Param:
		Output param:
		History Log:
	 */
	%>
<%/*~END~*/%>

<%!
	String [] getCount1(Transaction Sqlca, String sOrgId, String sDay) throws Exception {
		int [] iArray = {0,0,0,0,0,0,0};
		String [] sArray = {"0.00","0.00","0.00","0.00","0.00","0.00","0.00"};
		String [] sMoneyArray = {"","","","","","",""};
		String sSql="";
		String sWhere="";
		String sSortNo=Sqlca.getString("select SortNo from Org_Info where OrgID='"+sOrgId+"'");
		if(sSortNo==null)sSortNo="";

		//新增申请 笔
		sWhere = " where InputDate = '"+sDay+"' and BusinessCurrency != ''";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
		sSql = "select count(*) from BUSINESS_APPLY" + sWhere;
		iArray[0] = Integer.parseInt(Sqlca.getString(sSql));

		if (iArray[0] > 0) {
			ASResultSet rs = null;

			sSql = "select BusinessCurrency,count(BusinessSum) as BCount, sum(BusinessSum) as BusinessSum from BUSINESS_APPLY" + sWhere;
			sSql = "select BusinessCurrency,getItemname('Currency',BusinessCurrency) as Currency,BCount,BusinessSum from ("+sSql+" group by BusinessCurrency) B";
			rs = Sqlca.getASResultSet(sSql);
			while (rs.next())
			{ 
				String sb=rs.getString("BusinessCurrency");
				String sc=rs.getString("Currency");
				String sm=getSpace(DataConvert.toMoney(rs.getString("BusinessSum")),24);
				String bcount = rs.getString("BCount");
				sMoneyArray[0]+="<tr><td>&nbsp;&nbsp;"+sc+"</td><td align=right><a href=# onClick=\"viewDetail2('10','"+sb+"')\"><font color=blue>"+bcount+"笔&nbsp;&nbsp;金额合计"+sm+"元</font></a></td></tr>";
			}
			rs.getStatement().close(); 
		}

		//批准申请 笔
		sWhere = " where InputDate = '"+sDay+"' and ApproveType='010'";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
		sSql = "select count(*) from BUSINESS_APPROVE" + sWhere;
		iArray[1] = Integer.parseInt(Sqlca.getString(sSql));

		if (iArray[1] > 0) {
			ASResultSet rs = null;

			sSql = "select BusinessCurrency,count(BusinessSum) as BCount, sum(BusinessSum) as BusinessSum from BUSINESS_APPROVE" + sWhere;
			sSql = "select BusinessCurrency,getItemname('Currency',BusinessCurrency) as Currency,BCount,BusinessSum from ("+sSql+" group by BusinessCurrency) B";
			rs = Sqlca.getASResultSet(sSql);
			while (rs.next())
			{ 
				String sb=rs.getString("BusinessCurrency");
				String sc=rs.getString("Currency");
				String sm=getSpace(DataConvert.toMoney(rs.getString("BusinessSum")),24);
				String bcount = rs.getString("BCount");
				sMoneyArray[1]+="<tr><td>&nbsp;&nbsp;"+sc+"</td><td align=right><a href=# onClick=\"viewDetail2('11','"+sb+"')\"><font color=blue>"+bcount+"笔&nbsp;&nbsp;金额合计"+sm+"元</font></a></td></tr>";
			}
			rs.getStatement().close(); 
		}

		//否决申请 笔
		sWhere = " where InputDate = '"+sDay+"' and ApproveType='020'";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
		sSql = "select count(*) from BUSINESS_APPROVE" + sWhere;
		iArray[2] = Integer.parseInt(Sqlca.getString(sSql));

		if (iArray[2] > 0) {
			ASResultSet rs = null;

			sSql = "select BusinessCurrency,count(BusinessSum) as BCount, sum(BusinessSum) as BusinessSum from BUSINESS_APPROVE" + sWhere;
			sSql = "select BusinessCurrency,getItemname('Currency',BusinessCurrency) as Currency,BCount,BusinessSum from ("+sSql+" group by BusinessCurrency) B";
			rs = Sqlca.getASResultSet(sSql);
			while (rs.next())
			{ 
				String sb=rs.getString("BusinessCurrency");
				String sc=rs.getString("Currency");
				String sm=getSpace(DataConvert.toMoney(rs.getString("BusinessSum")),24);
				String bcount = rs.getString("BCount");
				sMoneyArray[2]+="<tr><td>&nbsp;&nbsp;"+sc+"</td><td align=right><a href=# onClick=\"viewDetail2('12','"+sb+"')\"><font color=blue>"+bcount+"笔&nbsp;&nbsp;金额合计"+sm+"元</font></a></td></tr>";
			}
			rs.getStatement().close(); 
		}

		//合同登记 笔
		sWhere = " where InputDate = '"+sDay+"' and BusinessCurrency != ''";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
		sSql = "select count(*) from BUSINESS_CONTRACT" + sWhere;
		iArray[3] = Integer.parseInt(Sqlca.getString(sSql));

		if (iArray[3] > 0) {
			ASResultSet rs = null;

			sSql = "select BusinessCurrency,count(BusinessSum) as BCount, sum(BusinessSum) as BusinessSum from BUSINESS_CONTRACT" + sWhere;
			sSql = "select BusinessCurrency,getItemname('Currency',BusinessCurrency) as Currency,BCount,BusinessSum from ("+sSql+" group by BusinessCurrency) B";
			rs = Sqlca.getASResultSet(sSql);
			while (rs.next())
			{ 
				String sb=rs.getString("BusinessCurrency");
				String sc=rs.getString("Currency");
				String sm=getSpace(DataConvert.toMoney(rs.getString("BusinessSum")),24);
				String bcount = rs.getString("BCount");
				sMoneyArray[3]+="<tr><td>&nbsp;&nbsp;"+sc+"</td><td align=right><a href=# onClick=\"viewDetail2('13','"+sb+"')\"><font color=blue>"+bcount+"笔&nbsp;&nbsp;金额合计"+sm+"元</font></a></td></tr>";
			}
			rs.getStatement().close(); 
		}

		//新提出放贷申请 笔
		sWhere = " where InputDate = '"+sDay+"' and BusinessCurrency != '' and ContractSerialNo is not null";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
		sSql = "select count(*) from BUSINESS_PUTOUT" + sWhere;
		iArray[4] = Integer.parseInt(Sqlca.getString(sSql));

		if (iArray[4] > 0) {
			ASResultSet rs = null;

			sSql = "select BusinessCurrency,count(BusinessSum) as BCount, sum(BusinessSum) as BusinessSum from BUSINESS_PUTOUT" + sWhere;
			sSql = "select BusinessCurrency,getItemname('Currency',BusinessCurrency) as Currency,BCount,BusinessSum from ("+sSql+" group by BusinessCurrency) B";
			rs = Sqlca.getASResultSet(sSql);
			while (rs.next())
			{ 
				String sb=rs.getString("BusinessCurrency");
				String sc=rs.getString("Currency");
				String sm=getSpace(DataConvert.toMoney(rs.getString("BusinessSum")),24);
				String bcount = rs.getString("BCount");
				sMoneyArray[4]+="<tr><td>&nbsp;&nbsp;"+sc+"</td><td align=right><a href=# onClick=\"viewDetail2('14','"+sb+"')\"><font color=blue>"+bcount+"笔&nbsp;&nbsp;金额合计"+sm+"元</font></a></td></tr>";
			}
			rs.getStatement().close(); 
		}

		for (int i=0; i < 5; i ++) {
			if (iArray[i] > 0) {
				sArray[i] = "（<a href=# onClick=\"viewDetail1('1"+i+"')\"><font color=blue>"+iArray[i]+"笔</font></a>）</td></tr>";
				sArray[i] += sMoneyArray[i];
			}
			else {
				sArray[i] = "（"+iArray[i]+"笔）</td></tr>"+"<tr><td>&nbsp;&nbsp无</td><td</td></tr>";
			}
		}
		return sArray;
	}

	String getSpace(String s, int len) {
		if (s.length() > len)
			return s;
		for (int i=s.length(); i < len; i ++)
			s = "&nbsp;"+s;
		return s;
	}
%>

<%
	String sOrgName ="";
	String sOrgId = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	if (sOrgId==null) {
		sOrgId = CurOrg.getOrgID();
	}
	sOrgName = Sqlca.getString("select OrgName from ORG_INFO where OrgID = '"+sOrgId+"'");
	String sDay = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DataDate"));
	if (sDay==null) {
		sDay = StringFunction.getToday();
	}

	String [] sMoney1 = getCount1(Sqlca,sOrgId,sDay);
    String sSql ;
%>
<html>
<head>
<title>当日业务情况</title>
<script type="text/javascript">
function viewDetail1(arg1)
{
	sOrgId = "<%=sOrgId%>";
	sDataDate = "<%=sDay%>";
	sEndDay = sDataDate;
	OpenComp("BusinessDynamiclist","/DeskTop/BusinessDynamicList.jsp","OrgID="+sOrgId+"&DataDate="+sDataDate+"&EndDay="+sEndDay+"&ListType="+arg1,"_blank","");
}

function viewDetail2(arg1,arg2)
{
	sOrgId = "<%=sOrgId%>";
	sDataDate = "<%=sDay%>";
	sEndDay = sDataDate;
	OpenComp("BusinessDynamiclist","/DeskTop/BusinessDynamicList.jsp","OrgID="+sOrgId+"&DataDate="+sDataDate+"&EndDay="+sEndDay+"&ListType="+arg1+"&Currency="+arg2,"_blank","");
}

function selectOrg()
{
	sReturn = selectObjectInfo("Org","OrgID=<%=CurOrg.getOrgID()%>","dialogWidth=20;dialogHeight=30;center:yes;status:no;statusbar:no");
	if (sReturn=="_CLEAR_" || sReturn=="_CANCEL_") {
		return;
	}
	if(typeof(sReturn)!="undefined" && sReturn!="")
	{
		sReturns = sReturn.split('@');
		sID=sReturns[0];
		sName =sReturns[1];
		document.all("CurOrgId").value=sID;
		document.all("CurOrgName").value=sName;
		doSubmit();
	}
}

function selectDataDate()
{   sPreValue=document.all("DataDate").value;
	sDataDate = PopPage("/Common/ToolsA/SelectDate.jsp","","dialogWidth:300px;dialogHeight:240px;status:no;center:yes;help:no;minimize:no;maximize:no;statusbar:no;");
	if(sDataDate==null){
		sDataDate=sPreValue;
	}
	else if(sDataDate=="") {
		document.all("DataDate").value = sPreValue;
	}
	else{
		document.all("DataDate").value = sDataDate;
		doSubmit();
	}
}

function doSubmit()
{
	sOrgId = document.all("CurOrgId").value;
  	OpenComp("BusinessCurrenyDay","/DeskTop/BusinessCurrenyDay.jsp","OrgID="+sOrgId+"&DataDate="+sDataDate,"_self","");
}
</script>
<link rel="stylesheet" href="Style.css">
</head>
<body class="pagebackground" leftmargin="0" topmargin="0" id="mybody">
<table border="0" width="100%" cellspacing="0" cellpadding="0">
  <tr>
    <td width="100%" height="20">
      <table border="1" width="99%" cellspacing="0" cellpadding="0" bordercolor="#BFBFBF" style="border-collapse: collapse" height="30">

	  <form name="frmOrg" method="POST"  action="LoanInfo.jsp?CompClientID=">
        <tr>
          <td style="border:0px" valign="middle" width="50" nowrap>
          	<font face="Arial" style="font-size: 9pt" color="#000000" >&nbsp;机构：</font>
          </td>
          <td style="border:0px" valign="middle" align='middle' width='10%'>
				<input id='inputOrgName' size="20" name="CurOrgName" style="border: 1px solid #FFFFFF" value=<%=sOrgName%>  readonly>&nbsp;&nbsp;</font>
    	</td>
		<td style="border:0px" valign="middle" align='middle' width='10%'>
				<input id='inputOrgId' type="hidden" size="20" name="CurOrgId" style="border: 1px solid #FFFFFF" value=<%=sOrgId%> readonly>&nbsp;&nbsp;</font>
    	</td>
    	<td style="border:0px" valign="middle" align='left' width='10%' nowrap>
			 <script>
                 hc_drawButtonWithTip("选择机构","选择机构","selectOrg()","/credit/Resources/1")
             </script>

	  </td>

	<td  style="border:0px" valign="middle" width='40%' align="right" nowrap>
				<font face="Arial" style="font-size: 9pt" color="#000000">日期：	</font>
	</td>
	<td  style="border:0px" valign="middle" align="right" nowrap>
				<input id='input03' size="10" name="DataDate" style="border: 1px solid #FFFFFF"
				value='<%=sDay%>' readonly>
				&nbsp;
	</td>
	<td style="border:0px" valign="middle" align='left' width='10%' nowrap>
			<script>
			 hc_drawButtonWithTip("..","..","selectDataDate()","/credit/Resources/1")
			</script>
	</td>
	</tr>
      </form>
      </table>
    </td>

  </tr>
  <tr><td height='2'></td></tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
 <tr valign="top">
    <td>
      <div id="Layer1" style="position:absolute;width:100%; height:100%; z-index:1; overflow: auto">
        <table align='center' cellspacing=0 cellpadding=0 border=0 width=95% height="95%">
          <tr>
            <td align='center' valign='top'>
              <table border=0 width='100%' height='100%'>
                <tr>
                  <td valign='top'>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="12%" valign="top" align="center">
                          <p><br>
                            <br>
                            </p>
                          <p><a href="javascript:self.location.reload();">刷新</a></p>
                        </td>
                        <td valign="top">
                          <table align='left' border="0" cellspacing="0" cellpadding="4" bordercolordark="#FFFFFF" width="100%" >
				                        <tr>
				                        	<td align="left" colspan="2"></td>
				                        </tr>
				                        <tr>
				                        	<td align="left" colspan="2"  background="<%=sResourcesPath%>/workTipLine.gif">
				                          	<b>新增申请</b><%=sMoney1[0]%>
				                        <tr>
				                        	<td align="left" colspan="2"  background="<%=sResourcesPath%>/workTipLine.gif">
				                          	<b>批准申请</b><%=sMoney1[1]%>
				                        <tr>
				                        	<td align="left" colspan="2"  background="<%=sResourcesPath%>/workTipLine.gif">
				                          	<b>否决申请</b><%=sMoney1[2]%>
				                        <tr>
				                        	<td align="left" colspan="2"  background="<%=sResourcesPath%>/workTipLine.gif">
				                          	<b>合同登记</b><%=sMoney1[3]%>
				                        <tr>
				                        	<td align="left" colspan="2"  background="<%=sResourcesPath%>/workTipLine.gif">
				                          	<b>新提出放贷申请</b><%=sMoney1[4]%>
                          </table>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </div>
    </td>
  </tr>
</table>

</body>
</html>

<%@ include file="/IncludeEnd.jsp"%>