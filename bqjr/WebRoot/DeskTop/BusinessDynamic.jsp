<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: ҵ��̬
		Input Param:
		Output param:
			sListType 11 ��������
			          12 ��׼����
			          13 �������
			          14 ��ͬ�Ǽ�
			          15 ������Ŵ�����
			          21 ����
			          22 ����
			          23 չ��
			          24 ���
			          25 ����
			          26 ����
			          31 ��������
			          32 ��������
		History Log:
	 */
	%>
<%/*~END~*/%>

<%!
	String [] getMoney1(Transaction Sqlca, String sOrgId, String sDay, String sEndDay) throws Exception {
		int [] iArray = {0,0,0,0,0,0,0};
		String [] sArray = {"0.00","0.00","0.00","0.00","0.00","0.00","0.00"};
		String sSql="";
		String sWhere="";
		String sSortNo=Sqlca.getString(new SqlObject("select SortNo from Org_Info where OrgID=:OrgID").setParameter("OrgID",sOrgId));
		if(sSortNo==null)sSortNo="";

		//�������� ��
		sWhere = " where InputDate >= '"+sDay+"' and InputDate <= '"+sEndDay+"' and BusinessCurrency != ''";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
		sSql = "select count(*) from BUSINESS_APPLY" + sWhere;
		iArray[0] = Integer.parseInt(Sqlca.getString(sSql));
		//�������� ���ϼ�
		sSql = "select sum(BusinessSum) as BusinessSum,BusinessCurrency from BUSINESS_APPLY" + sWhere;
		sSql = "select sum(BusinessSum*getRate(BusinessCurrency,'2004/12/31')/10000) from ("+sSql+" group by BusinessCurrency) B";
		sArray[0] = DataConvert.toMoney(Sqlca.getString(sSql));

		//��׼���� ��
		sWhere = " where InputDate >= '"+sDay+"' and InputDate <= '"+sEndDay+"' and ApproveType='010'";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
		sSql = "select count(*) from BUSINESS_APPROVE" + sWhere;
		iArray[1] = Integer.parseInt(Sqlca.getString(sSql));
		//��׼���� ���ϼ�
		sSql = "select sum(BusinessSum) as BusinessSum,BusinessCurrency from BUSINESS_APPROVE" + sWhere;
		sSql = "select sum(BusinessSum*getRate(BusinessCurrency,'2004/12/31')/10000) from ("+sSql+" group by BusinessCurrency) B";

		sArray[1] = DataConvert.toMoney(Sqlca.getString(sSql));

		//������� ��
		sWhere = " where InputDate >= '"+sDay+"' and InputDate <= '"+sEndDay+"' and ApproveType='020'";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
		sSql = "select count(*) from BUSINESS_APPROVE" + sWhere;
		iArray[2] = Integer.parseInt(Sqlca.getString(sSql));
		//������� ���ϼ�
		sSql = "select sum(BusinessSum) as BusinessSum,BusinessCurrency from BUSINESS_APPROVE" + sWhere;
		sSql = "select sum(BusinessSum*getRate(BusinessCurrency,'2004/12/31')/10000) from ("+sSql+" group by BusinessCurrency) B";
		sArray[2] = DataConvert.toMoney(Sqlca.getString(sSql));

		//��ͬ�Ǽ� ��
		iArray[3] = 0;
		sArray[3] = "0.00";

		//������Ŵ����� ��
		sWhere = " where InputDate >= '"+sDay+"' and InputDate <= '"+sEndDay+"' and BusinessCurrency != '' and ContractSerialNo is not null";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
		sSql = "select count(*) from BUSINESS_PUTOUT" + sWhere;
		iArray[4] = Integer.parseInt(Sqlca.getString(sSql));
		//������Ŵ����� ���ϼ�
		sSql = "select sum(BusinessSum) as BusinessSum,BusinessCurrency from BUSINESS_PUTOUT" + sWhere;
		sSql = "select sum(BusinessSum*getRate(BusinessCurrency,'2004/12/31')/10000) from ("+sSql+" group by BusinessCurrency) B";
		sArray[4] = DataConvert.toMoney(Sqlca.getString(sSql));

		for (int i=0; i < 5; i ++) {
			if (iArray[i] > 0) {
				sArray[i] = "<a href=# onClick=\"viewDetail1('1"+i+"')\"><font color=blue>��"+getSpace(""+iArray[i],3)+"��&nbsp;&nbsp;������ҽ��"+getSpace(sArray[i],24)+"��Ԫ</font></a>";
			}
			else {
				sArray[i] = "��"+getSpace(""+iArray[i],3)+"��&nbsp;&nbsp;������ҽ��"+getSpace(sArray[i],24)+"��Ԫ";
			}
		}
		return sArray;
	}

	String [] getMoney2(Transaction Sqlca, String sOrgId, String sDay, String sEndDay) throws Exception {
		int [] iArray = {0,0,0,0,0,0,0};
		String [] sArray = {"0.00","0.00","0.00","0.00","0.00","0.00","0.00"};
		String sSql="";
		String sWhere="";
		String sSortNo=Sqlca.getString("select SortNo from Org_Info where OrgID='"+sOrgId+"'");
		if(sSortNo==null)sSortNo="";

		//���� ��
		sWhere = " where TransactionFlag = '0' and OccurDate >= '"+sDay+"' and OccurDate <= '"+sEndDay+"' and OccurDirection = '0'";
		if (!sOrgId.equals("9900")) {
			sWhere += " and OrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
		sSql = "select count(*) from BUSINESS_WASTEBOOK" + sWhere;
		iArray[0] = Integer.parseInt(Sqlca.getString(sSql));
		//���� ���ϼ�
		sSql = "select sum(ActualDebitSum) as BusinessSum,Currency from BUSINESS_WASTEBOOK" + sWhere;
		sSql = "select sum(BusinessSum*getRate(Currency,'2004/12/31')/10000) from ("+sSql+" group by Currency) B";
		sArray[0] = DataConvert.toMoney(Sqlca.getString(sSql));

		//���� ��
		sWhere = " where TransactionFlag = '0' and OccurDate >= '"+sDay+"' and OccurDate <= '"+sEndDay+"' and OccurDirection = '1'";
		if (!sOrgId.equals("9900")) {
			sWhere += " and OrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
		sSql = "select count(*) from BUSINESS_WASTEBOOK" + sWhere;
		iArray[1] = Integer.parseInt(Sqlca.getString(sSql));
		//���� ���ϼ�
		sSql = "select sum(ActualCreditSum) as BusinessSum,Currency from BUSINESS_WASTEBOOK" + sWhere;
		sSql = "select sum(BusinessSum*getRate(Currency,'2004/12/31')/10000) from ("+sSql+" group by Currency) B";
		sArray[1] = DataConvert.toMoney(Sqlca.getString(sSql));

		//չ�� ��
		iArray[2] = 0;
		sArray[2] = "0.00";

		//��� ��
		sWhere = " where BusinessType = '1100050' and PutOutDate >= '"+sDay+"' and PutOutDate <= '"+sEndDay+"'  and	 BusinessCurrency != ''";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
		sSql = "select count(*) from BUSINESS_CONTRACT" + sWhere;
		iArray[3] = Integer.parseInt(Sqlca.getString(sSql));

		//��� ���ϼ�
		sSql = "select sum(BusinessSum) as BusinessSum,BusinessCurrency from BUSINESS_CONTRACT" + sWhere;
		sSql = "select sum(BusinessSum*getRate(BusinessCurrency,'2004/12/31')/10000) from ("+sSql+" group by BusinessCurrency) B";
		sArray[3] = DataConvert.toMoney(Sqlca.getString(sSql));

		//���� ��
		sWhere = " where OverdueBalance>0 and Maturity >= '"+sDay+"' and Maturity <= '"+sEndDay+"'";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
		sSql = "select count(*) from BUSINESS_CONTRACT" + sWhere;
		iArray[4] = Integer.parseInt(Sqlca.getString(sSql));

		//���� ���ϼ�
		sSql = "select sum(OverdueBalance) as BusinessSum,BusinessCurrency from BUSINESS_CONTRACT" + sWhere;
		sSql = "select sum(BusinessSum*getRate(BusinessCurrency,'2004/12/31')/10000) from ("+sSql+" group by BusinessCurrency) B";
		sArray[4] = DataConvert.toMoney(Sqlca.getString(sSql));

		//���� ��
		iArray[5] = 0;
		sArray[5] = "0.00";

		for (int i=0; i < 6; i ++) {
			if (iArray[i] > 0) {
				sArray[i] = "<a href=# onClick=\"viewDetail2('2"+i+"')\"><font color=blue>��"+getSpace(""+iArray[i],3)+"��&nbsp;&nbsp;������ҽ��"+getSpace(sArray[i],24)+"��Ԫ</font></a>";
			}
			else {
				sArray[i] = "��"+getSpace(""+iArray[i],3)+"��&nbsp;&nbsp;������ҽ��"+getSpace(sArray[i],24)+"��Ԫ";
			}
		}
		return sArray;
	}

	String [] getMoney3(Transaction Sqlca, String sOrgId, String sToday, String sViewDate) throws Exception {
		int [] iArray = {0,0,0,0,0,0,0};
		String [] sArray = {"0.00","0.00","0.00","0.00","0.00","0.00","0.00"};
		String sSql="";
		String sWhere="";
		String sSortNo=Sqlca.getString("select SortNo from Org_Info where OrgID='"+sOrgId+"'");
		if(sSortNo==null)sSortNo="";

		//�������� ��
		iArray[0] = 0;
		sArray[0] = "0.00";

		//չ������ ��
		sWhere = " where Maturity >= '"+sToday+"' and Maturity <= '"+sViewDate+"'  and BusinessCurrency != ''";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
		sSql = "select count(*) from BUSINESS_CONTRACT" + sWhere;
		iArray[1] = Integer.parseInt(Sqlca.getString(sSql));

		//չ������ ���ϼ�
		sSql = "select sum(BusinessSum) as BusinessSum,BusinessCurrency from BUSINESS_CONTRACT" + sWhere;
		sSql = "select sum(BusinessSum*getRate(BusinessCurrency,'2004/12/31')/10000) from ("+sSql+" group by BusinessCurrency) B";
		sArray[1] = DataConvert.toMoney(Sqlca.getString(sSql));

		for (int i=0; i < 2; i ++) {
			if (iArray[i] > 0) {
				sArray[i] = "<a href=# onClick=\"viewDetail3('3"+i+"')\"><font color=blue>��"+getSpace(""+iArray[i],3)+"��&nbsp;&nbsp;������ҽ��"+getSpace(sArray[i],24)+"��Ԫ</font></a>";
			}
			else {
				sArray[i] = "��"+getSpace(""+iArray[i],3)+"��&nbsp;&nbsp;������ҽ��"+getSpace(sArray[i],24)+"��Ԫ";
			}
		}
		return sArray;
	}


	String getSpace(String s, int len) {
		if (s.length() > 3)
			s = s.substring(0,s.length()-3);
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
	String sToday = StringFunction.getToday();

	if (sOrgId==null) {
		sOrgId = CurOrg.getOrgID();
	}
	sOrgName = Sqlca.getString("select OrgName from ORG_INFO where OrgID = '"+sOrgId+"'");
	String sDay = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DataDate"));
	if (sDay==null) {
		sDay = StringFunction.getRelativeDate(sToday,-1);
	}
	String sEndDay = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("EndDay"));
	if (sEndDay==null) {
		sEndDay = sDay;
	}
	String sViewMonth = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewMonth"));
	if (sViewMonth==null) {
		sViewMonth = "010";
	}
	String sViewDate = "";
	String sViewDescribe = "";
	if(sViewMonth.equals("010"))
	{
		sViewDate = StringFunction.getRelativeDate(sToday,30);
		sViewDescribe = "һ����";
	}
	else if(sViewMonth.equals("020"))
	{
		sViewDate = StringFunction.getRelativeDate(sToday,61);
		sViewDescribe = "������";
	}
	else if(sViewMonth.equals("030"))
	{
		sViewDate = StringFunction.getRelativeDate(sToday,91);
		sViewDescribe = "������";
	}
	
	String [] sMoney1 = getMoney1(Sqlca,sOrgId,sDay,sEndDay);
	String [] sMoney2 = getMoney2(Sqlca,sOrgId,sDay,sEndDay);
	String [] sMoney3 = getMoney3(Sqlca,sOrgId,sToday,sViewDate);
    String sSql ;
%>
<html>
<head>
<title>ÿ��ҵ��̬</title>
<script type="text/javascript">
function viewDetail1(arg1)
{
	sOrgId = "<%=sOrgId%>";
	sDataDate = "<%=sDay%>";
	sEndDay = "<%=sEndDay%>";
	OpenComp("BusinessDynamiclist","/DeskTop/BusinessDynamicList.jsp","OrgID="+sOrgId+"&DataDate="+sDataDate+"&EndDay="+sEndDay+"&ListType="+arg1,"_blank","");
}

function viewDetail2(arg1)
{
	sOrgId = "<%=sOrgId%>";
	sDataDate = "<%=sDay%>";
	sEndDay = "<%=sEndDay%>";
	OpenComp("BusinessDynamiclist","/DeskTop/BusinessDynamicList.jsp","OrgID="+sOrgId+"&DataDate="+sDataDate+"&EndDay="+sEndDay+"&ListType="+arg1,"_blank","");
}

function viewDetail3(arg1)
{
	sOrgId = "<%=sOrgId%>";
	sViewDate = "<%=sViewDate%>";
	OpenComp("BusinessDynamiclist","/DeskTop/BusinessDynamicList.jsp","OrgID="+sOrgId+"&ViewDate="+sViewDate+"&ListType="+arg1,"_blank","");
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

function selectDate()
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

function selectEndDay()
{   sPreValue=document.all("EndDay").value;
	sDataDate = PopPage("/Common/ToolsA/SelectDate.jsp","","dialogWidth:300px;dialogHeight:240px;status:no;center:yes;help:no;minimize:no;maximize:no;statusbar:no;");
	if(sDataDate==null){
		sDataDate=sPreValue;
	}
	else if(sDataDate=="") {
		document.all("EndDay").value = sPreValue;
	}
	else{
		document.all("EndDay").value = sDataDate;
		doSubmit();
	}
}

function doSubmit()
{
	sOrgId = document.all("CurOrgId").value;
	sDataDate = document.all("DataDate").value;
	sEndDay = document.all("EndDay").value;
	sViewMonth = document.all("ViewMonth").value;
  	OpenComp("BusinessDynamic","/DeskTop/BusinessDynamic.jsp","OrgID="+sOrgId+"&DataDate="+sDataDate+"&EndDay="+sEndDay+"&ViewMonth="+sViewMonth,"_self","");
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
          	<font face="Arial" style="font-size: 9pt" color="#000000" >&nbsp;������</font>
          </td>
          <td style="border:0px" valign="middle" align='middle' width='10%'>
				<input id='inputOrgName' size="20" name="CurOrgName" style="border: 1px solid #FFFFFF" value=<%=sOrgName%>  readonly>&nbsp;</font>
    	</td>
		<td style="border:0px" valign="middle" align='middle' width='10%'>
				<input id='inputOrgId' type="hidden" size="20" name="CurOrgId" style="border: 1px solid #FFFFFF" value=<%=sOrgId%> readonly></font>
    	</td>
    	<td style="border:0px" valign="middle" align='left' width='10%' nowrap>
			 <script>
                 hc_drawButtonWithTip("ѡ�����","ѡ�����","selectOrg()","/credit/Resources/1")
             </script>

	  </td>

	<td  style="border:0px" valign="middle" width='40%' align="right" nowrap>
				<font face="Arial" style="font-size: 9pt" color="#000000">��ʼ���ڣ�</font>
	</td>
	<td  style="border:0px" valign="middle" align="right" nowrap>
				<input id='input03' size="10" name="DataDate" style="border: 1px solid #FFFFFF"
				value='<%=sDay%>' readonly>
	</td>
	<td style="border:0px" valign="middle" align='left' width='10%' nowrap>
			<script>
			 hc_drawButtonWithTip("..","..","selectDate()","/credit/Resources/1")
			</script>
	</td>
	
	<td  style="border:0px" valign="middle" width='40%' align="right" nowrap>
				<font face="Arial" style="font-size: 9pt" color="#000000">�������ڣ�</font>
	</td>
	<td  style="border:0px" valign="middle" align="right" nowrap>
				<input id='input04' size="10" name="EndDay" style="border: 1px solid #FFFFFF"
				value='<%=sEndDay%>' readonly>
	</td>
	<td style="border:0px" valign="middle" align='left' width='10%' nowrap>
			<script>
			 hc_drawButtonWithTip("..","..","selectEndDay()","/credit/Resources/1")
			</script>
	</td>
	
	<td  style="border:0px" valign="middle" width='40%' align="right" nowrap>
				<font face="Arial" style="font-size: 9pt" color="#000000">ҵ��չ���ڣ�</font>
	</td>
	<td  style="border:0px" valign="middle" align="right" nowrap>
        <select name="ViewMonth" onChange="doSubmit()">
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'ViewMonth'",1,2,"")%> 
        </select>
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
                          <p><a href="javascript:self.location.reload();">ˢ��</a></p>
                        </td>
                        <td valign="top">
                          <table align='left' border="0" cellspacing="0" cellpadding="4" bordercolordark="#FFFFFF" width="100%" >
				                        <tr>
				                        	<td align="left" colspan="2"></td>
				                        </tr>
				                        <tr >
				                        	<td align="left" colspan="2"  background="<%=sResourcesPath%>/workTipLine.gif">
				                          	<b>ҵ���������</b>&nbsp;
				                        	</td>
				                        </tr>
			                         	<tr>
			                         	   <td align="left" >��������</td>
			                        	   <td align="right" valign="bottom"><%=sMoney1[0]%></td>
										</tr>
			                         	<tr>
			                         	   <td align="left" >��׼����</td>
			                        	   <td align="right" valign="bottom"><%=sMoney1[1]%></td>
										</tr>
			                         	<tr>
			                         	   <td align="left" >�������</td>
			                        	   <td align="right" valign="bottom"><%=sMoney1[2]%></td>
										</tr>
			                         	<tr>
			                         	   <td align="left" >�Ŵ�����</td>
			                        	   <td align="right" valign="bottom"><%=sMoney1[4]%></td>
										</tr>
				                        <tr>
			                         	   <td align="left" colspan="2">��</td>
										</tr>
				                        <tr>
				                        	<td align="left" colspan="2"  background="<%=sResourcesPath%>/workTipLine.gif">
				                          	<b>ҵ�������</b>
											</td>
			                        	</tr>
			                         	<tr>
			                         	   <td align="left" >����</td>
			                        	   <td align="right" valign="bottom"><%=sMoney2[0]%></td>
										</tr>
			                         	<tr>
			                         	   <td align="left" >����</td>
			                        	   <td align="right" valign="bottom"><%=sMoney2[1]%></td>
										</tr>
			                         	<tr>
			                         	   <td align="left" >���</td>
			                        	   <td align="right" valign="bottom"><%=sMoney2[3]%></td>
										</tr>
			                         	<tr>
			                         	   <td align="left" >����</td>
			                        	   <td align="right" valign="bottom"><%=sMoney2[4]%></td>
										</tr>
				                        <tr>
			                         	   <td align="left" colspan="2">��</td>
										</tr>
				                        <tr >
				                        	<td align="left" colspan="2"  background="<%=sResourcesPath%>/workTipLine.gif">
				                          	<b><%=sViewDescribe%>��ҵ�����չ��</b>&nbsp;
				                        	</td>
				                        </tr>
			                         	<tr>
			                         	   <td align="left" >��������</td>
			                        	   <td align="right" valign="bottom"><%=sMoney3[1]%></td>
										</tr>
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
<script type="text/javascript">
	document.all("ViewMonth").value='<%=sViewMonth%>';
</script>

<%@ include file="/IncludeEnd.jsp"%>