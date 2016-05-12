
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%!
//由于DataConvert.toMoney对0返回"",该函数返回"0.00"
public String toMoneyZero(String dSum){
	String sSum = DataConvert.toMoney(dSum);
	if(sSum.equals(""))
		return "0.00";
	else
		return sSum;
}
%>
<%
	String sOrgName ="";
	String sOrgId = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	if (sOrgId==null) {
		sOrgId = CurOrg.getOrgID();
	}
	String sSortNo=Sqlca.getString(new SqlObject("select SortNo from Org_Info where OrgID=:OrgID").setParameter("OrgID",sOrgId));
	if(sSortNo==null)sSortNo="";
	sOrgName = Sqlca.getString(new SqlObject("select OrgName from ORG_INFO where OrgID = :OrgID").setParameter("OrgID",sOrgId));

	String sDataDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DataDate"));
	if (sDataDate==null) {
		sDataDate = StringFunction.getToday();
	}
%>
<html>
<head >
<title></title>
<script type="text/javascript" src="Resources/1/htmlcontrol.js"></script>
<link rel="stylesheet" href="Resources/Style.css">
</head>
<body bgcolor="#DCDCDC">

<script type="text/javascript"> 
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

function doSubmit()
{
	sOrgId = document.all("CurOrgId").value;
	sDataDate = document.all("DataDate").value;
  	OpenComp("LoanQuanlity","/DeskTop/LoanQuanlity.jsp","OrgID="+sOrgId+"&DataDate="+sDataDate,"_self","");
}

function viewBusinessList(sC5, sC4){
	OpenComp("BusinessTypeList","/DeskTop/BusinessTypeList.jsp","OrgID=<%=sOrgId%>&InputDate=<%=sDataDate%>&ClassifyResult="+sC5+"&Class4Result="+sC4,"_blank","");
}
</script>

<%
	//检索统计指标数据
	String[][] sResult=
	{
		{" ","0.00","0.00","0.00","0.00","0.00"},
		{" ","0.00","0.00","0.00","0.00","0.00"},
		{" ","0.00","0.00","0.00","0.00","0.00"},
		{" ","0.00","0.00","0.00","0.00","0.00"},
		{" ","0.00","0.00","0.00","0.00","0.00"},
		{" ","0.00","0.00","0.00","0.00","0.00"}
	};

	String[][] sResult1=
	{
		{" ","0.00","0.00","0.00","0.00","0.00"},
		{" ","0.00","0.00","0.00","0.00","0.00"},
		{" ","0.00","0.00","0.00","0.00","0.00"},
		{" ","0.00","0.00","0.00","0.00","0.00"},
		{" ","0.00","0.00","0.00","0.00","0.00"},
		{" ","0.00","0.00","0.00","0.00","0.00"}
	};

	String sOrgNames="";
	String sValueYear="";
	String sAddValueYear="",sAddValueMonth="";
	String sAddRateYear="",sAddRateMonth="";
	
	String sValueYear1="";
	String sAddValueYear1="",sAddValueMonth1="";
	String sAddRateYear1="",sAddRateMonth1="";


	String sAddValueY1,sAddValueY2,sAddValueY3,sAddValueY4,sAddValueY5;
	String sAddValueM1,sAddValueM2,sAddValueM3,sAddValueM4,sAddValueM5;
	
	int iCount=0;
	sResult[0][0]="正常";
	sResult[1][0]="关注";
	sResult[2][0]="次级";
	sResult[3][0]="损失";
	sResult[4][0]="可疑";

	
	double bal1,bal2,bal3,bal4,bal5;
	bal1=bal2=bal3=bal4=bal5=0.00;
	double LYbal1,LYbal2,LYbal3,LYbal4,LYbal5,LMbal1,LMbal2,LMbal3,LMbal4,LMbal5;
	LYbal1=LYbal2=LYbal3=LYbal4=LYbal5=0.00;
	LMbal1=LMbal2=LMbal3=LMbal4=LMbal5=0.00;
	ASResultSet rs = null;
	double LYRate1,LYRate2,LYRate3,LYRate4,LYRate5,LMRate1,LMRate2,LMRate3,LMRate4,LMRate5;
	LYRate1=LYRate2=LYRate3=LYRate4=LYRate5=0.00;
	LMRate1=LMRate2=LMRate3=LMRate4=LMRate5=0.00;
	
	String sSql="select "+
	"sum(isnull(ClassifySum1,0)) as BAL01,"+
	"sum(isnull(ClassifySum2,0)) as BAL02,"+
	"sum(isnull(ClassifySum3,0)) as BAL03,"+
	"sum(isnull(ClassifySum4,0)) as BAL04,"+
	"sum(isnull(ClassifySum5,0)) as BAL05,"+
	
	"sum(isnull(ClassifySum1,0)) as LMbal01,"+
	"sum(isnull(ClassifySum2,0)) as LMbal02,"+
	"sum(isnull(ClassifySum3,0)) as LMbal03,"+
	"sum(isnull(ClassifySum4,0)) as LMbal04,"+
	"sum(isnull(ClassifySum5,0)) as LMbal05,"+
	
	"sum(isnull(ClassifySum1,0)) as LYbal01,"+
	"sum(isnull(ClassifySum2,0)) as LYbal02,"+
	"sum(isnull(ClassifySum3,0)) as LYbal03,"+
	"sum(isnull(ClassifySum4,0)) as LYbal04,"+
	"sum(isnull(ClassifySum5,0)) as LYbal05 "
	+" FROM BUSINESS_CONTRACT"
	+" WHERE InputOrgID in ((select OrgID from ORG_INFO where SortNo like :SortNo) "
	+" AND InputDate <= :DataDate ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SortNo",sSortNo+"%").setParameter("DataDate",sDataDate));
	while(rs.next()){
		
		sResult[0][1]=rs.getString("bal01");
		sResult[1][1]=rs.getString("bal02");
		sResult[2][1]=rs.getString("bal03");
		sResult[3][1]=rs.getString("bal04");
		sResult[4][1]=rs.getString("bal05");
		
		
		bal1=rs.getDouble("bal01");
		bal2=rs.getDouble("bal02");
		bal3=rs.getDouble("bal03");
		bal4=rs.getDouble("bal04");
		bal5=rs.getDouble("bal05");
		
		LYbal1=rs.getDouble("LYbal01");
		LYbal2=rs.getDouble("LYbal02");
		LYbal3=rs.getDouble("LYbal03");
		LYbal4=rs.getDouble("LYbal04");
		LYbal5=rs.getDouble("LYbal05");
		
		LMbal1=rs.getDouble("LMbal01");
		LMbal2=rs.getDouble("LMbal02");
		LMbal3=rs.getDouble("LMbal03");
		LMbal4=rs.getDouble("LMbal04");
		LMbal5=rs.getDouble("LMbal05");
	
		if(bal1>0.00){
			LYRate1=(bal1-LYbal1)/bal1;
			LMRate1=(bal1-LMbal1)/bal1;
		}
		if(bal2>0.00){
			LYRate2=(bal2-LYbal2)/bal2;
			LMRate2=(bal2-LMbal2)/bal2;
		}
		if(bal3>0.00){	
			LYRate3=(bal3-LYbal3)/bal3;
			LMRate3=(bal3-LMbal3)/bal3;
		}
		if(bal4>0.00){
			LYRate4=(bal4-LYbal4)/bal4;
			LMRate4=(bal4-LMbal4)/bal4;
		}
		if(bal5>0.00){
			LYRate5=(bal5-LYbal5)/bal5;
			LMRate5=(bal5-LMbal5)/bal5;
		}
		
		sAddValueY1=Double.toString(bal1-LYbal1);
		sAddValueY2=Double.toString(bal2-LYbal2);
		sAddValueY3=Double.toString(bal3-LYbal3);
		sAddValueY4=Double.toString(bal4-LYbal4);
		sAddValueY5=Double.toString(bal5-LYbal5);
		
		sAddValueM1=Double.toString(bal1-LMbal1);
		sAddValueM2=Double.toString(bal2-LMbal2);
		sAddValueM3=Double.toString(bal3-LMbal3);
		sAddValueM4=Double.toString(bal4-LMbal4);
		sAddValueM5=Double.toString(bal5-LMbal5);
		
		sResult[0][2]=sAddValueY1;
		sResult[1][2]=sAddValueY2;
		sResult[2][2]=sAddValueY3;
		sResult[3][2]=sAddValueY4;
		sResult[4][2]=sAddValueY5;

		sResult[0][4]=sAddValueM1;
		sResult[1][4]=sAddValueM2;
		sResult[2][4]=sAddValueM3;
		sResult[3][4]=sAddValueM4;
		sResult[4][4]=sAddValueM5;

		sResult[0][3]=Double.toString(LYRate1);
		sResult[1][3]=Double.toString(LYRate2);
		sResult[2][3]=Double.toString(LYRate3);
		sResult[3][3]=Double.toString(LYRate4);
		sResult[4][3]=Double.toString(LYRate5);

		sResult[0][5]=Double.toString(LMRate1);
		sResult[1][5]=Double.toString(LMRate2);
		sResult[2][5]=Double.toString(LMRate3);
		sResult[3][5]=Double.toString(LMRate4);
		sResult[4][5]=Double.toString(LMRate5);

		sValueYear=rs.getString("bal01")+"\t"+rs.getString("bal02")+"\t"+rs.getString("bal03")+"\t"+rs.getString("bal04")+"\t"+rs.getString("bal05");
		sAddValueMonth=sAddValueM1+"\t"+sAddValueM2+"\t"+sAddValueM3+"\t"+sAddValueM4+"\t"+sAddValueM5;
		sAddValueYear=sAddValueY1+"\t"+sAddValueY2+"\t"+sAddValueY3+"\t"+sAddValueY4+"\t"+sAddValueY5;
		sAddRateMonth=LMRate1+"\t"+LMRate2+"\t"+LMRate3+"\t"+LMRate4+"\t"+LMRate5;
		sAddRateYear=LYRate1+"\t"+LYRate2+"\t"+LYRate3+"\t"+LYRate4+"\t"+LYRate5;
				
	}
	rs.getStatement().close();

	sValueYear1="";
	sAddValueYear1="";
	sAddValueMonth1="";
	sAddRateYear1="";
	sAddRateMonth1="";
	iCount=0;
	
	sResult1[0][0]="正常";
	sResult1[1][0]="逾期";
	sResult1[2][0]="呆滞";
	sResult1[3][0]="呆帐";

	/*sSql="select "+
	"sum(isnull(NormalBalance,0)) as BAL01,"+
	"sum(isnull(OverdueBalance,0)) as BAL02,"+
	"sum(isnull(DullBalance,0)) as BAL03,"+
	"sum(isnull(BadBalance,0)) as BAL04,"+
	
	"sum(isnull(NormalBalance,0)) as LMbal01,"+
	"sum(isnull(OverdueBalance,0)) as LMbal02,"+
	"sum(isnull(DullBalance,0)) as LMbal03,"+
	"sum(isnull(BadBalance,0)) as LMbal04,"+
	
	"sum(isnull(NormalBalance,0)) as LYbal01,"+
	"sum(isnull(OverdueBalance,0)) as LYbal02,"+
	"sum(isnull(DullBalance,0)) as LYbal03,"+
	"sum(isnull(BadBalance,0)) as LYbal04 "
	+" FROM BUSINESS_CONTRACT"
	+" WHERE InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%') "
	+" AND InputDate <= '" + sDataDate + "' ";*/
	sSql="select "+
	"sum(isnull(NormalBalance,0)) as BAL01,"+
	"sum(isnull(OverdueBalance,0)) as BAL02,"+
	"sum(isnull(DullBalance,0)) as BAL03,"+
	"sum(isnull(BadBalance,0)) as BAL04,"+
	
	"sum(isnull(NormalBalance,0)) as LMbal01,"+
	"sum(isnull(OverdueBalance,0)) as LMbal02,"+
	"sum(isnull(DullBalance,0)) as LMbal03,"+
	"sum(isnull(BadBalance,0)) as LMbal04,"+
	
	"sum(isnull(NormalBalance,0)) as LYbal01,"+
	"sum(isnull(OverdueBalance,0)) as LYbal02,"+
	"sum(isnull(DullBalance,0)) as LYbal03,"+
	"sum(isnull(BadBalance,0)) as LYbal04 "
	+" FROM BUSINESS_CONTRACT"
	+" WHERE InputOrgID in (select OrgID from ORG_INFO where SortNo like :SortNo) "
	+" AND InputDate <= :DataDate  ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SortNo",sSortNo+"%").setParameter("DataDate",sDataDate));
	while(rs.next()){
		
		sResult1[0][1]=rs.getString("bal01");
		sResult1[1][1]=rs.getString("bal02");
		sResult1[2][1]=rs.getString("bal03");
		sResult1[3][1]=rs.getString("bal04");
		
		
		bal1=rs.getDouble("bal01");
		bal2=rs.getDouble("bal02");
		bal3=rs.getDouble("bal03");
		bal4=rs.getDouble("bal04");
		
		LYbal1=rs.getDouble("LYbal01");
		LYbal2=rs.getDouble("LYbal02");
		LYbal3=rs.getDouble("LYbal03");
		LYbal4=rs.getDouble("LYbal04");
		
		LMbal1=rs.getDouble("LMbal01");
		LMbal2=rs.getDouble("LMbal02");
		LMbal3=rs.getDouble("LMbal03");
		LMbal4=rs.getDouble("LMbal04");
	
		if(bal1>0.00){
			LYRate1=(bal1-LYbal1)/bal1;
			LMRate1=(bal1-LMbal1)/bal1;
		}
		if(bal2>0.00){
			LYRate2=(bal2-LYbal2)/bal2;
			LMRate2=(bal2-LMbal2)/bal2;
		}
		if(bal3>0.00){	
			LYRate3=(bal3-LYbal3)/bal3;
			LMRate3=(bal3-LMbal3)/bal3;
		}
		if(bal4>0.00){
			LYRate4=(bal4-LYbal4)/bal4;
			LMRate4=(bal4-LMbal4)/bal4;
		}
	
		sAddValueY1=Double.toString(bal1-LYbal1);
		sAddValueY2=Double.toString(bal2-LYbal2);
		sAddValueY3=Double.toString(bal3-LYbal3);
		sAddValueY4=Double.toString(bal4-LYbal4);
		
		sAddValueM1=Double.toString(bal1-LMbal1);
		sAddValueM2=Double.toString(bal2-LMbal2);
		sAddValueM3=Double.toString(bal3-LMbal3);
		sAddValueM4=Double.toString(bal4-LMbal4);
		
		sResult1[0][2]=sAddValueY1;
		sResult1[1][2]=sAddValueY2;
		sResult1[2][2]=sAddValueY3;
		sResult1[3][2]=sAddValueY4;

		sResult1[0][4]=sAddValueM1;
		sResult1[1][4]=sAddValueM2;
		sResult1[2][4]=sAddValueM3;
		sResult1[3][4]=sAddValueM4;

		sResult1[0][3]=Double.toString(LYRate1);
		sResult1[1][3]=Double.toString(LYRate2);
		sResult1[2][3]=Double.toString(LYRate3);
		sResult1[3][3]=Double.toString(LYRate4);

		sResult1[0][5]=Double.toString(LMRate1);
		sResult1[1][5]=Double.toString(LMRate2);
		sResult1[2][5]=Double.toString(LMRate3);
		sResult1[3][5]=Double.toString(LMRate4);

		sValueYear1=rs.getString("bal01")+"\t"+rs.getString("bal02")+"\t"+rs.getString("bal03")+"\t"+rs.getString("bal04");
		sAddValueMonth1=sAddValueM1+"\t"+sAddValueM2+"\t"+sAddValueM3+"\t"+sAddValueM4;
		sAddValueYear1=sAddValueY1+"\t"+sAddValueY2+"\t"+sAddValueY3+"\t"+sAddValueY4;
		sAddRateMonth1=LMRate1+"\t"+LMRate2+"\t"+LMRate3+"\t"+LMRate4;
		sAddRateYear1=LYRate1+"\t"+LYRate2+"\t"+LYRate3+"\t"+LYRate4;
	}
	rs.getStatement().close();				
%>
<script type="text/javascript" src="Resources/1/htmlcontrol.js"></script>
<link rel="stylesheet" href="Resources/Style.css">
<div id="Layer1" style="position:absolute;width:100%; height:430%; z-index:1; overflow: auto">

<table border="0" width="100%" cellspacing="0" cellpadding="0">
  <tr>
    <td width="100%" height="20">
      <table border="1" width="99%" cellspacing="0" cellpadding="0" bordercolor="#BFBFBF" style="border-collapse: collapse" height="30">
      
	  <form name="frmOrg" method="POST"  action="LoanQuanlity.jsp?CompClientID=">
        <tr>
          <td style="border:0px" valign="middle" width="70" nowrap>
          	<font face="Arial" style="font-size: 9pt" color="#000000" >&nbsp;机构：</font>
          </td>
          <td style="border:0px" valign="middle" align='middle' width='10%'>	
				<input id='inputOrgName' size="40" name="CurOrgName" style="border: 1px solid #FFFFFF" value=<%=sOrgName%>  readonly>&nbsp;&nbsp;</font>
    	</td>
		<td style="border:0px" valign="middle" align='middle' width='10%'>	
				<input id='inputOrgId' type="hidden" size="40" name="CurOrgId" style="border: 1px solid #FFFFFF" value=<%=sOrgId%> readonly>&nbsp;&nbsp;</font>
    	</td>
    	<td style="border:0px" valign="middle" align='left' width='10%' nowrap>		
			 <script>
                  hc_drawButtonWithTip("选择机构","选择机构","selectOrg()","/credit/Resources/1")
             </script>
				
	  </td>			
	 
	<td  style="border:0px" valign="middle" width='40%' align="right" nowrap>
				<font face="Arial" style="font-size: 9pt" color="#000000">数据截止日期：</font>
	</td>
	<td  style="border:0px" valign="middle" align="right" nowrap>			
				<input id='input03' size="20" name="DataDate" style="border: 1px solid #FFFFFF"
				value='<%=sDataDate%>' readonly> &nbsp;
	</td>
	<td style="border:0px" valign="middle" align='left' width='10%' nowrap>		
			<script>
			  hc_drawButtonWithTip("..","..","selectDate()","/credit/Resources/1")
			</script>
	</td>
	</tr>
      </form> 

      </table>
    </td>
    
  </tr>
  <tr><td height='2'></td></tr>
</table>



<table border="0" width="99%" cellspacing="0" cellpadding="0">
  <tr>
    <td height='2'></td>
  </tr>
</table>

<table border="0" width="99%" cellspacing="0" cellpadding="0">
  <tr>
    <td align='left'  width='33%' id='ChartObject01'  style="display:yes">
    	<table id='ChartTable01' border="0" width="98%" cellspacing="0" cellpadding="0"><tr><td>
    		<object classid="clsid:0002E556-0000-0000-C000-000000000046" style="display:yes" id="ChartSpace01" width="100%" height="170"></object></td>
    	</td></td></table>	
    </td>
    <td align='middle'  width='33%' id='ChartObject02'  style="display:yes" >
    	<table id='ChartTable02' border="0" width="98%" cellspacing="0" cellpadding="0"><tr><td>
    		<object classid="clsid:0002E556-0000-0000-C000-000000000046" style="display:yes" id="ChartSpace02" width="100%" height="170"></object></td>
    	</td></td></table>	
    </td>
    <td align='right'  width='34%' id='ChartObject03'  style="display:yes" >
    	<table id='ChartTable03' border="0" width="98%" cellspacing="0" cellpadding="0"><tr><td>
    		<object classid="clsid:0002E556-0000-0000-C000-000000000046" style="display:yes" id="ChartSpace03" width="100%" height="170"></object></td>
    	</td></td></table>	
    </td>
  </tr>
   <tr>
   <td align='left' valign='top'  id="chart01" status="1" style="cursor:pointer;display:yes" onclick="javascript:ChangeSize('chart01');" >
    	<table id='ChartTitle01' border="0" width="98%" cellspacing="0" cellpadding="0" bgcolor='#000000' onmouseover="javascript:ChangeChartTitleColor('chart01','1');" onmouseout="javascript:ChangeChartTitleColor('chart01','2');"><tr><td align='middle'  nowrap>
    		<font face="Arial" style="font-size: 9pt" color="#FFFFFF">五级分类详情</font><div>
    	</td></td></table>	
    </td>
    <td align='middle' valign='top'  id="chart02" status="1" style="cursor:pointer;display:yes" onclick="javascript:ChangeSize('chart02');" >
    	<table id='ChartTitle02' border="0" width="98%" cellspacing="0" cellpadding="0" bgcolor='#000000' onmouseover="javascript:ChangeChartTitleColor('chart02','1');" onmouseout="javascript:ChangeChartTitleColor('chart02','2');"><tr><td align='middle'  nowrap>
    		<font face="Arial" style="font-size: 9pt" color="#FFFFFF">五级分类详情(比年初)</font>
    	</td></td></table>	
    </td>
    <td align='right' valign='top'  id="chart03" status="1" style="cursor:pointer;display:yes" onclick="javascript:ChangeSize('chart03');" >
    	<table id='ChartTitle03' border="0" width="98%" cellspacing="0" cellpadding="0" bgcolor='#000000' onmouseover="javascript:ChangeChartTitleColor('chart03','1');" onmouseout="javascript:ChangeChartTitleColor('chart03','2');"><tr><td align='middle'  nowrap>
    		<font face="Arial" style="font-size: 9pt" color="#FFFFFF">五级分类详情(比月初)</font>
    	</td></td></table>	
    </td>
  </tr>
   <tr>
    <td align='left' width='33%'height='5'>
    	<table border="0" width="98%" cellspacing="0" cellpadding="0"><tr><td>
    		
    	</td></td></table>	
    </td>
    <td align='middle' width='33%'>
    	<table border="0" width="98%" cellspacing="0" cellpadding="0"><tr><td>
    		
    	</td></td></table>	
    </td>
    <td align='right' width='34%'>
    	<table border="0" width="98%" cellspacing="0" cellpadding="0"><tr><td>
    		
    	</td></td></table>	
    </td>
  </tr>
   <tr>
    <td align='left' id='ChartObject04'  style="display:yes">
    	<table id='ChartTable04' border="0" width="98%" cellspacing="0" cellpadding="0"><tr><td>
    		<object classid="clsid:0002E556-0000-0000-C000-000000000046" style="display:yes" id="ChartSpace04" width="100%" height="170"></object></td>
    	</td></td></table>	
    </td>
    <td align='middle' id='ChartObject05'  style="display:yes">
    	<table id='ChartTable05' border="0" width="98%" cellspacing="0" cellpadding="0"><tr><td>
    		<object classid="clsid:0002E556-0000-0000-C000-000000000046" style="display:yes" id="ChartSpace05" width="100%" height="170"></object></td>
    	</td></td></table>	
    </td>
    <td align='right' id='ChartObject06'  style="display:yes">
    	<table id='ChartTable06' border="0" width="98%" cellspacing="0" cellpadding="0"><tr><td>
    		<object classid="clsid:0002E556-0000-0000-C000-000000000046" style="display:yes" id="ChartSpace06" width="100%" height="170"></object></td>
    	</td></td></table>	
    </td>
  </tr>
   <tr>
    <td align='left'  valign='top'  id="chart04" status="1" style="cursor:pointer;display:yes" onclick="javascript:ChangeSize('chart04');" >
    	<table  id='ChartTitle04' border="0" width="98%" cellspacing="0" cellpadding="0" bgcolor='#000000' onmouseover="javascript:ChangeChartTitleColor('chart04','1');" onmouseout="javascript:ChangeChartTitleColor('chart04','2');"><tr><td align='middle'  nowrap>
    		<font face="Arial" style="font-size: 9pt" color="#FFFFFF">四级分类详情</font>
    	</td></td></table>
    </td>
    <td align='middle'  valign='top'  id="chart05" status="1" style="cursor:pointer;display:yes" onclick="javascript:ChangeSize('chart05');" >
    	<table id='ChartTitle05' border="0" width="98%" cellspacing="0" cellpadding="0" bgcolor='#000000' onmouseover="javascript:ChangeChartTitleColor('chart05','1');" onmouseout="javascript:ChangeChartTitleColor('chart05','2');"><tr><td align='middle'  nowrap>
    		<font face="Arial" style="font-size: 9pt" color="#FFFFFF">四级分类详情(比年初)</font>
    	</td></td></table>	
    </td>
    <td align='right'   valign='top'  id="chart06" status="1" style="cursor:pointer;display:yes" onclick="javascript:ChangeSize('chart06');" >
    	<table id='ChartTitle06' border="0" width="98%" cellspacing="0" cellpadding="0" bgcolor='#000000' onmouseover="javascript:ChangeChartTitleColor('chart06','1');" onmouseout="javascript:ChangeChartTitleColor('chart06','2');"><tr><td align='middle'  nowrap>
    		<font face="Arial" style="font-size: 9pt" color="#FFFFFF">四级分类详情(比月初)</font>
    	</td></td></table>		
    </td>
  </tr>
</table>

<script type="text/javascript">
	sTopStatus="";
	function setTopStatus(sStatusText){
		sTopStatus = top.status;
		top.status = sStatusText;
	}
	function restoreTopStatus(){
		top.status = sTopStatus;
	}

	function changeOwcLayout01()
	{
		ChartSpace01.Clear();
		ChartSpace01.Charts.Add();
		var c = ChartSpace01.Constants;		
		categories = "正常"+"\t"+"关注"+"\t"+"次级"+"\t"+"损失"+"\t"+"可疑";
		
		ChartSpace01.Charts(0).SeriesCollection.Add();		
		ChartSpace01.Charts(0).HasTitle = true;
		ChartSpace01.Charts(0).Title.Font.Size=10;
		ChartSpace01.Charts(0).Title.Font.Name="宋体";
		ChartSpace01.Charts(0).Title.Caption ="五级分类";
		
		ChartSpace01.Charts(0).Type = c.chChartTypePie;
		ChartSpace01.Charts(0).SeriesCollection(0).SetData(c.chDimCategories, c.chDataLiteral, categories);
		
		
		values = '<%=sValueYear%>';
		
		ChartSpace01.Charts(0).SeriesCollection(0).SetData(c.chDimValues, c.chDataLiteral, values);
				
		ChartSpace01.Charts(0).SeriesCollection(0).Points(0).Interior.Color="darkblue";
		ChartSpace01.Charts(0).SeriesCollection(0).Points(0).Border.Color=c.chColorNone;
		ChartSpace01.Charts(0).SeriesCollection(0).Points(1).Interior.Color="orange";
		ChartSpace01.Charts(0).SeriesCollection(0).Points(1).Border.Color=c.chColorNone;
					
		ChartSpace01.HasChartSpaceLegend = true;
		ChartSpace01.ChartSpaceLegend.Font.Name = "Arial";
		ChartSpace01.ChartSpaceLegend.Position = c.chLegendPositionBottom;
			
	}
	
	function changeOwcLayout02()
	{
		ChartSpace02.Charts.Add();
		var c = ChartSpace02.Constants;		
		categories = "正常"+"\t"+"关注"+"\t"+"次级"+"\t"+"损失"+"\t"+"可疑";
		ChartSpace02.Charts(0).SeriesCollection.Add();	
		ChartSpace02.Charts(0).SeriesCollection.Add();	
		
		ChartSpace02.Charts(0).HasTitle = true;
		ChartSpace02.Charts(0).Title.Font.Size=10;
		ChartSpace02.Charts(0).Title.Font.Name="宋体";
		ChartSpace02.Charts(0).Title.Caption ="比年初增长情况";
		
		
		values = '<%=sAddValueYear%>';
		
		ChartSpace02.Charts(0).SeriesCollection(0).SetData(c.chDimCategories, c.chDataLiteral, categories);
		ChartSpace02.Charts(0).SeriesCollection(0).SetData(c.chDimValues, c.chDataLiteral, values);
		ChartSpace02.Charts(0).SeriesCollection(0).Caption="余额增长绝对值";
		
		values = '<%=sAddRateYear%>';
		ChartSpace02.Charts(0).SeriesCollection(1).Type=c.chChartTypeLine;
		ChartSpace02.Charts(0).SeriesCollection(1).SetData(c.chDimCategories, c.chDataLiteral, categories);
		ChartSpace02.Charts(0).SeriesCollection(1).SetData(c.chDimValues, c.chDataLiteral, values);
		ChartSpace02.Charts(0).SeriesCollection(1).Caption="余额增长率";
			
		ChartSpace02.HasChartSpaceLegend = true;
		ChartSpace02.ChartSpaceLegend.Font.Name = "宋体";
		ChartSpace02.ChartSpaceLegend.Font.Size = 8;
		ChartSpace02.ChartSpaceLegend.Position = c.chLegendPositionBottom;
	}
	
	
	
	function changeOwcLayout03()
	{
		ChartSpace03.Charts.Add();
		var c = ChartSpace03.Constants;		
		categories = "正常"+"\t"+"关注"+"\t"+"次级"+"\t"+"损失"+"\t"+"可疑";
		ChartSpace03.Charts(0).SeriesCollection.Add();	
		ChartSpace03.Charts(0).SeriesCollection.Add();	
		
		ChartSpace03.Charts(0).HasTitle = true;
		ChartSpace03.Charts(0).Title.Font.Size=10;
		ChartSpace03.Charts(0).Title.Font.Name="宋体";
		ChartSpace03.Charts(0).Title.Caption ="比月初增长情况";
			
	
		values = '<%=sAddValueMonth%>';
		
		ChartSpace03.Charts(0).SeriesCollection(0).SetData(c.chDimCategories, c.chDataLiteral, categories);
		ChartSpace03.Charts(0).SeriesCollection(0).SetData(c.chDimValues, c.chDataLiteral, values);
		ChartSpace03.Charts(0).SeriesCollection(0).Caption="余额增长绝对值";
		
		values = '<%=sAddRateMonth%>';
		ChartSpace03.Charts(0).SeriesCollection(1).Type=c.chChartTypeLine;
		ChartSpace03.Charts(0).SeriesCollection(1).SetData(c.chDimCategories, c.chDataLiteral, categories);
		ChartSpace03.Charts(0).SeriesCollection(1).SetData(c.chDimValues, c.chDataLiteral, values);
		ChartSpace03.Charts(0).SeriesCollection(1).Caption="余额增长率";
			
		ChartSpace03.HasChartSpaceLegend = true;
		ChartSpace03.ChartSpaceLegend.Font.Name = "宋体";
		ChartSpace03.ChartSpaceLegend.Font.Size = 8;
		ChartSpace03.ChartSpaceLegend.Position = c.chLegendPositionBottom;
	}
	
	function changeOwcLayout04()
	{
		var categories;
		var values;

		ChartSpace04.Clear();
		ChartSpace04.Charts.Add();
		var c = ChartSpace04.Constants;		
		categories = "正常"+"\t"+"逾期"+"\t"+"呆滞" +"\t"+"呆帐";
				
		ChartSpace04.Charts(0).SeriesCollection.Add();		
		ChartSpace04.Charts(0).HasTitle = true;
		ChartSpace01.Charts(0).Title.Font.Size=10;
		ChartSpace04.Charts(0).Title.Font.Name="宋体";
		ChartSpace04.Charts(0).Title.Caption ="四级分类";
		
		
		values = '<%=sValueYear1%>';
		
		
		ChartSpace04.Charts(0).Type = c.chChartTypePie;
		ChartSpace04.Charts(0).SeriesCollection(0).SetData(c.chDimCategories, c.chDataLiteral, categories);
		
		ChartSpace04.Charts(0).SeriesCollection(0).SetData(c.chDimValues, c.chDataLiteral, values);
		ChartSpace04.Charts(0).SeriesCollection(0).Caption = "贷款余额百分比";
				
		ChartSpace04.Charts(0).SeriesCollection(0).Points(0).Interior.Color="darkblue";
		ChartSpace04.Charts(0).SeriesCollection(0).Points(0).Border.Color=c.chColorNone;
		ChartSpace01.Charts(0).SeriesCollection(0).Points(1).Interior.Color="orange";
		ChartSpace04.Charts(0).SeriesCollection(0).Points(1).Border.Color=c.chColorNone;
					
		ChartSpace04.HasChartSpaceLegend = true;
		ChartSpace04.ChartSpaceLegend.Font.Name = "Arial";
		//ChartSpace01.ChartSpaceLegend.Font.Size = 8;
		ChartSpace04.ChartSpaceLegend.Position = c.chLegendPositionBottom;
	}
	
	function changeOwcLayout05()
	{
		var categories;
		var values;
		
		ChartSpace05.Clear();
		ChartSpace05.Charts.Add();
		
		var c = ChartSpace05.Constants;		
		categories = "正常"+"\t"+"逾期"+"\t"+"呆滞" +"\t"+"呆帐";
		ChartSpace05.Charts(0).SeriesCollection.Add();	
		ChartSpace05.Charts(0).SeriesCollection.Add();	
		
		ChartSpace05.Charts(0).HasTitle = true;
		ChartSpace05.Charts(0).Title.Font.Size=10;
		ChartSpace05.Charts(0).Title.Font.Name="宋体";
		ChartSpace05.Charts(0).Title.Caption ="比年初增长情况";
		
		values = '<%=sAddValueYear1%>';
				
		ChartSpace05.Charts(0).SeriesCollection(0).SetData(c.chDimCategories, c.chDataLiteral, categories);
		ChartSpace05.Charts(0).SeriesCollection(0).SetData(c.chDimValues, c.chDataLiteral, values);
		ChartSpace05.Charts(0).SeriesCollection(0).Caption="余额增长绝对值";
		
		values = '<%=sAddRateYear1%>';
		ChartSpace05.Charts(0).SeriesCollection(1).Type=c.chChartTypeLine;
		ChartSpace05.Charts(0).SeriesCollection(1).SetData(c.chDimCategories, c.chDataLiteral, categories);
		ChartSpace05.Charts(0).SeriesCollection(1).SetData(c.chDimValues, c.chDataLiteral, values);
		ChartSpace05.Charts(0).SeriesCollection(1).Caption="余额增长率";
			
		ChartSpace05.HasChartSpaceLegend = true;
		ChartSpace05.ChartSpaceLegend.Font.Name = "宋体";
		ChartSpace05.ChartSpaceLegend.Font.Size = 8;
		ChartSpace05.ChartSpaceLegend.Position = c.chLegendPositionBottom;    		
    		
	}
	
	function changeOwcLayout06()
	{
		var categories;
		var values;

		
		ChartSpace06.Clear();
		ChartSpace06.Charts.Add();
		
		var c = ChartSpace06.Constants;		
		categories = "正常"+"\t"+"逾期"+"\t"+"呆滞" +"\t"+"呆帐";
		ChartSpace06.Charts(0).SeriesCollection.Add();	
		ChartSpace06.Charts(0).SeriesCollection.Add();	
		
		ChartSpace06.Charts(0).HasTitle = true;
		ChartSpace06.Charts(0).Title.Font.Size=10;
		ChartSpace06.Charts(0).Title.Font.Name="宋体";
		ChartSpace06.Charts(0).Title.Caption ="比月初增长情况";
		
		values = '<%=sAddValueMonth1%>';

		ChartSpace06.Charts(0).SeriesCollection(0).SetData(c.chDimCategories, c.chDataLiteral, categories);
		ChartSpace06.Charts(0).SeriesCollection(0).SetData(c.chDimValues, c.chDataLiteral, values);
		ChartSpace06.Charts(0).SeriesCollection(0).Caption="余额增长绝对值";
		
		values = '<%=sAddRateMonth1%>';
		ChartSpace06.Charts(0).SeriesCollection(1).Type=c.chChartTypeLine;
		ChartSpace06.Charts(0).SeriesCollection(1).SetData(c.chDimCategories, c.chDataLiteral, categories);
		ChartSpace06.Charts(0).SeriesCollection(1).SetData(c.chDimValues, c.chDataLiteral, values);
		ChartSpace06.Charts(0).SeriesCollection(1).Caption="余额增长率";
			
		ChartSpace06.HasChartSpaceLegend = true;
		ChartSpace06.ChartSpaceLegend.Font.Name = "宋体";
		ChartSpace06.ChartSpaceLegend.Font.Size = 8;
		ChartSpace06.ChartSpaceLegend.Position = c.chLegendPositionBottom;
	}
	
	function ChangeChartType(){
		var c = ChartSpace.Constants;

		for(var iTemp = 0 ; iTemp <= 5 ; iTemp ++){
			ChartSpace.Charts(iTemp).Type = frmOrg.ChartType.value;
		}
	}
	
	function ChangeChartTitleColor(selectedChart){
			var selectedChartSpace;
			var selectedChartObject;
			var selectedChartTable;
			var selectedChartTitle;
			
			selectedChartSpace = selectedChart.replace('chart','ChartSpace');
			selectedChartObject = selectedChart.replace('chart','ChartObject');
			selectedChartTable = selectedChart.replace('chart','ChartTable');
			selectedChartTitle = selectedChart.replace('chart','ChartTitle');
			
			document.all(selectedChartTitle).bgColor='#222222';
			document.all(selectedChartSpace).Interior.Color="#F0F0F0";
	}
	
	function ChangeSize(selectedChart){
			var selectedChartSpace;
			var selectedChartObject;
			var selectedChartTable;
			var selectedChartTitle;
			var selectedDataTable;
			
			var showDataStatus="0";	//是否同时显示数据表
			selectedChartSpace = selectedChart.replace('chart','ChartSpace');
			selectedChartObject = selectedChart.replace('chart','ChartObject');
			selectedChartTable = selectedChart.replace('chart','ChartTable');
			selectedChartTitle = selectedChart.replace('chart','ChartTitle');
			selectedDataTable = selectedChart.replace('chart','ChartDataTable');
			
			if (document.all(selectedChart).status=='1'){
					
					document.all(selectedChart).status='2';
					document.all('Chart01').style.display='none';
					document.all('Chart02').style.display='none';
					document.all('Chart03').style.display='none';
					document.all('Chart04').style.display='none';
					document.all('Chart05').style.display='none';
					document.all('Chart06').style.display='none';
					document.all('ChartObject01').style.display='none';
					document.all('ChartObject02').style.display='none';
					document.all('ChartObject03').style.display='none';
					document.all('ChartObject04').style.display='none';
					document.all('ChartObject05').style.display='none';
					document.all('ChartObject06').style.display='none';
					document.all(selectedChart).style.display='';
					document.all(selectedChartObject).style.display='';
					document.all(selectedChart).width='300%';
					document.all(selectedChartTable).width='100%';
					document.all(selectedChartTitle).width='100%';
					document.all(selectedChartSpace).height='250';
					document.all(selectedDataTable).style.display='';
			}
			else{
					document.all(selectedChart).status='1';
					document.all(selectedChart).width='33%';
					document.all(selectedChartSpace).height='170';
					document.all('Chart01').style.display='';
					document.all('Chart02').style.display='';
					document.all('Chart03').style.display='';
					document.all('Chart04').style.display='';
					document.all('Chart05').style.display='';
					document.all('Chart06').style.display='';
					document.all('ChartObject01').style.display='';
					document.all('ChartObject02').style.display='';
					document.all('ChartObject03').style.display='';
					document.all('ChartObject04').style.display='';
					document.all('ChartObject05').style.display='';
					document.all('ChartObject06').style.display='';
					document.all(selectedChartSpace).Border.color="#000000";
					document.all(selectedChartTable).width='98%';
					document.all(selectedChartTitle).width='98%';
					document.all(selectedDataTable).style.display='none';
			}
		
	}
	
	function changebgcolor(objectno){
		document.all(objectno).style.backggcolor='#000000';
	}
	
	function changeChartType(selectedChart){
			var selectedChartSpace;
			var selectedChartObject;
			var selectedChartTable;
			var selectedChartTitle;
			
			var showDataStatus="0";	//是否同时显示数据表
			selectedChartSpace = selectedChart.replace('chart','ChartSpace');
			selectedChartObject = selectedChart.replace('chart','ChartObject');
			selectedChartTable = selectedChart.replace('chart','ChartTable');
			selectedChartTitle = selectedChart.replace('chart','ChartTitle');
			
			if(document.all(selectedChartSpace).Charts(0).Type >58){
				document.all(selectedChartSpace).Charts(0).Type	= 0;
				return;
			}else{
				document.all(selectedChartSpace).Charts(0).Type	= document.all(selectedChartSpace).Charts(0).Type+1;
				return;
			}
			
			if(document.all(selectedChartSpace).Charts(0).Type==6){
				document.all(selectedChartSpace).Charts(0).Type	= 29;
				return;
			}
			
			if(document.all(selectedChartSpace).Charts(0).Type==29){
				document.all(selectedChartSpace).Charts(0).Type	= 30;
				return;
			}
			
			if(document.all(selectedChartSpace).Charts(0).Type==30){
				document.all(selectedChartSpace).Charts(0).Type	= 46;
				return;
			}
			
			if(document.all(selectedChartSpace).Charts(0).Type==46){
				document.all(selectedChartSpace).Charts(0).Type	= 50;
				return;
			}
			
			if(document.all(selectedChartSpace).Charts(0).Type==50){
				document.all(selectedChartSpace).Charts(0).Type	= 54;
				return;
			}
			
			if(document.all(selectedChartSpace).Charts(0).Type==54){
				document.all(selectedChartSpace).Charts(0).Type	= 58;
				return;
			}
			
			if(document.all(selectedChartSpace).Charts(0).Type==58){
				
				document.all(selectedChartSpace).Charts(0).Type	= 0;
				return;
			}
	}
</script>

<script type="text/javascript">
	changeOwcLayout01();
	changeOwcLayout02();
	changeOwcLayout03();
	changeOwcLayout04();
	changeOwcLayout05();
	changeOwcLayout06();
</script>

<table id="ChartDataTable01" border="0" width="100%" cellspacing="0" cellpadding="0" >
  <tr>
    <td width="100%">
      <table border="2" width="99%" cellspacing="0" cellpadding="0" bordercolor="#333333" style="border-collapse: collapse" height="100">
        <tr>
          <td nowrap width="20%" bgcolor="#BFBFBF" height="16" style="border:1px solid #909090; "><p align="center"><font face="Arial" style="font-size: 9pt" color="#000000">&nbsp;五级分类[本币]</font></td>
          <td nowrap width="20%" align="center" bgcolor="#BFBFBF" height="16" style="border:1px solid #909090; "><font face="Arial" style="font-size: 9pt" color="#000000">&nbsp;余额(元)</font></td>
          <td nowrap width="20%" align="center" bgcolor="#BFBFBF" height="16" style="border:1px solid #909090; "><font face="Arial" style="font-size: 9pt" color="#000000">&nbsp;比上年余额增加</font></td>
          <td nowrap width="20%" align="center" bgcolor="#BFBFBF" height="16" style="border:1px solid #909090; "><font face="Arial" style="font-size: 9pt" color="#000000">&nbsp;比上年增长率</font></td>
          <td nowrap width="20%" align="center" bgcolor="#BFBFBF" height="16" style="border:1px solid #909090; "><font face="Arial" style="font-size: 9pt" color="#000000">&nbsp;比上月余额增加</font></td>
          <td nowrap width="20%" align="center" bgcolor="#BFBFBF" height="16" style="border:1px solid #909090; "><font face="Arial" style="font-size: 9pt" color="#000000">&nbsp;比上月增长率</font></td>
        </tr>
        <tr>
          <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#EEEEEE" onmouseover="javascript:this.bgColor='#CCCCCC';" onmouseout="javascript:this.bgColor='#EEEEEE';" ><font face="Arial" style="font-size: 9pt" color="#000000"><a  href="javascript:viewBusinessList('01','')" >&nbsp;<u><%=sResult[0][0]%></u></a></font></td>
          <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[0][1])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[0][2])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[0][3])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[0][4])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[0][5])%>&nbsp;</td>
      	</tr>
        <tr>  
          <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#EEEEEE" onmouseover="javascript:this.bgColor='#CCCCCC';" onmouseout="javascript:this.bgColor='#EEEEEE';" ><font face="Arial" style="font-size: 9pt" color="#000000"><a  href="javascript:viewBusinessList('02','')" >&nbsp;<u><%=sResult[1][0]%></u></a></font></td>
          <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[1][1])%>&nbsp;</td>
        <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[1][2])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[1][3])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[1][4])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[1][5])%>&nbsp;</td>
      	</tr>
        <tr>
          <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#EEEEEE" onmouseover="javascript:this.bgColor='#CCCCCC';" onmouseout="javascript:this.bgColor='#EEEEEE';" ><font face="Arial" style="font-size: 9pt" color="#000000"><a  href="javascript:viewBusinessList('03','')" >&nbsp;<u><%=sResult[2][0]%></u></a></font></td>
          <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[2][1])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[2][2])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[2][3])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[2][4])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[2][5])%>&nbsp;</td>
     	</tr>
        <tr>
          <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#EEEEEE" onmouseover="javascript:this.bgColor='#CCCCCC';" onmouseout="javascript:this.bgColor='#EEEEEE';" ><font face="Arial" style="font-size: 9pt" color="#000000"><a  href="javascript:viewBusinessList('04','')" >&nbsp;<u><%=sResult[3][0]%></u></a></font></td>
          <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[3][1])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[3][2])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[3][3])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[3][4])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[3][5])%>&nbsp;</td>
      	</tr>
        <tr> 
          <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#EEEEEE" onmouseover="javascript:this.bgColor='#CCCCCC';" onmouseout="javascript:this.bgColor='#EEEEEE';" ><font face="Arial" style="font-size: 9pt" color="#000000"><a  href="javascript:viewBusinessList('05','')" >&nbsp;<u><%=sResult[4][0]%></u></a></font></td>
          <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[4][1])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[4][2])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[4][3])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[4][4])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[4][5])%>&nbsp;</td>
     	</tr>
      </table>
    </td>
  </tr>
</table>

<table id="ChartDataTable02" border="0" width="100%" cellspacing="0" cellpadding="0" >
  <tr>
    <td width="100%">
      <table border="2" width="99%" cellspacing="0" cellpadding="0" bordercolor="#333333" style="border-collapse: collapse" height="100">
      </table>
    </td>  
  </tr>
</table>

<table id="ChartDataTable03" border="0" width="100%" cellspacing="0" cellpadding="0" >
  <tr>
    <td width="100%">
      <table border="2" width="99%" cellspacing="0" cellpadding="0" bordercolor="#333333" style="border-collapse: collapse" height="100">
      </table>
    </td>  
  </tr>
</table>

<table id="ChartDataTable05" border="0" width="100%" cellspacing="0" cellpadding="0" >
  <tr>
    <td width="100%">
      <table border="2" width="99%" cellspacing="0" cellpadding="0" bordercolor="#333333" style="border-collapse: collapse" height="100">
      </table>
    </td>  
  </tr>
</table>

<table id="ChartDataTable06" border="0" width="100%" cellspacing="0" cellpadding="0" >
  <tr>
    <td width="100%">
      <table border="2" width="99%" cellspacing="0" cellpadding="0" bordercolor="#333333" style="border-collapse: collapse" height="100">
      </table>
    </td>  
  </tr>
</table>

<table id="ChartDataTable04" border="0" width="100%" cellspacing="0" cellpadding="0" >
  <tr>
    <td width="100%">  
      <table border="2" width="99%" cellspacing="0" cellpadding="0" bordercolor="#333333" style="border-collapse: collapse" height="100">
        <tr>
          <td nowrap width="20%" bgcolor="#BFBFBF" height="16" style="border:1px solid #909090; "><p align="center"><font face="Arial" style="font-size: 9pt" color="#000000">&nbsp;四级分类[本币]</font></td>
          <td nowrap width="20%" align="center" bgcolor="#BFBFBF" height="16" style="border:1px solid #909090; "><font face="Arial" style="font-size: 9pt" color="#000000">&nbsp;余额</font></td>
          <td nowrap width="20%" align="center" bgcolor="#BFBFBF" height="16" style="border:1px solid #909090; "><font face="Arial" style="font-size: 9pt" color="#000000">&nbsp;比上年余额增加</font></td>
          <td nowrap width="20%" align="center" bgcolor="#BFBFBF" height="16" style="border:1px solid #909090; "><font face="Arial" style="font-size: 9pt" color="#000000">&nbsp;比上年增长率</font></td>
          <td nowrap width="20%" align="center" bgcolor="#BFBFBF" height="16" style="border:1px solid #909090; "><font face="Arial" style="font-size: 9pt" color="#000000">&nbsp;比上月余额增加</font></td>
          <td nowrap width="20%" align="center" bgcolor="#BFBFBF" height="16" style="border:1px solid #909090; "><font face="Arial" style="font-size: 9pt" color="#000000">&nbsp;比上月增长率</font></td>
       </tr>
        <tr>

          <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#EEEEEE" onmouseover="javascript:this.bgColor='#CCCCCC';" onmouseout="javascript:this.bgColor='#EEEEEE';" ><font face="Arial" style="font-size: 9pt" color="#000000"><a  href="javascript:viewBusinessList('','01')" >&nbsp;<u><%=sResult1[0][0]%></u></a></font></td>
          <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult1[0][1])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult1[0][2])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult1[0][3])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult1[0][4])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult1[0][5])%>&nbsp;</td>
      	</tr>
        <tr>  
          <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#EEEEEE" onmouseover="javascript:this.bgColor='#CCCCCC';" onmouseout="javascript:this.bgColor='#EEEEEE';" ><font face="Arial" style="font-size: 9pt" color="#000000"><a  href="javascript:viewBusinessList('','02')" >&nbsp;<u><%=sResult1[1][0]%></u></a></font></td>
          <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult1[1][1])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult1[1][2])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult1[1][3])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult1[1][4])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult1[1][5])%>&nbsp;</td>
        <tr>
          <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#EEEEEE" onmouseover="javascript:this.bgColor='#CCCCCC';" onmouseout="javascript:this.bgColor='#EEEEEE';" ><font face="Arial" style="font-size: 9pt" color="#000000"><a  href="javascript:viewBusinessList('','03')" >&nbsp;<u><%=sResult1[2][0]%></u></a></font></td>
          <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult1[2][1])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult1[2][2])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult1[2][3])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult1[2][4])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult1[2][5])%>&nbsp;</td>
        <tr>
          <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#EEEEEE" onmouseover="javascript:this.bgColor='#CCCCCC';" onmouseout="javascript:this.bgColor='#EEEEEE';" ><font face="Arial" style="font-size: 9pt" color="#000000"><a  href="javascript:viewBusinessList('','04')" >&nbsp;<u><%=sResult1[3][0]%></u></a></font></td>
          <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult1[3][1])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult1[3][2])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult1[3][3])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult1[3][4])%>&nbsp;</td>
         <td nowrap width="20%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult1[3][5])%>&nbsp;</td>
      </table>
    </td>
    
  </tr>
</table>

<script type="text/javascript">
	document.all('ChartDataTable01').style.display='none';
	document.all('ChartDataTable04').style.display='none';
</script>
</div>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>