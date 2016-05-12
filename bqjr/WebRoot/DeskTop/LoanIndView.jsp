<%
/**
 * Title:	表内外贷款业务结构信息
 * Description:	通过表内外标志声明表内外业务，生成业务结构图标
 *
 * @author zllin@amarsoft.com
 * @version 1.0 Mar 23,2005
 *          Tester:
 *          History Log: 1、
 *					2、
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<html>
<head >
<title></title>
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style>
<link href="Style.css">
</head>
<body bgcolor="#DCDCDC" scroll="yes">
<%
class HandelArray{
	int iCount;
	public HandelArray(ASResultSet rs)
		throws Exception{
		iCount = rs.getRowCount();
	}
	
	public String[][] get2DArray() 
		throws Exception{
		String[][] sArray = new String[iCount][2];
		return sArray;
	}

	public String[] get1DArray() 
		throws Exception{
		String[] sArray = new String[iCount];
		return sArray;
	}
}
%>
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
	String sSortNo=Sqlca.getString(new SqlObject("select SortNo from Org_Info where OrgID=':OrgID").setParameter("OrgID",sOrgId));
	if(sSortNo==null)sSortNo="";
	sOrgName = Sqlca.getString(new SqlObject("select OrgName from ORG_INFO where OrgID = '"+sOrgId+"'").setParameter("OrgID",sOrgId));

	String sDataDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DataDate"));
	if (sDataDate==null) {
		sDataDate = StringFunction.getToday();
	}

	/*表内外标志*/
	String sInOutFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("InOutFlag"));
	if(sInOutFlag == null) sInOutFlag = "1";

	String[][] sEisGraph = null,sTmpArray = null;
	String[][] sResult1 = null;
	String[][] sResult2 = null;
	String[][] sResult3 = null;
	String[][] sResult4 = null;
	String[] sSerialNo1 = null;
	String[] sSerialNo2 = null;
	String[] sSerialNo3 = null;
	String[] sSerialNo4 = null;
	int iCounter = 0;
	int iPointer = 0;
	
	String sShowPoint = "1,2,3,4";
	String sSql = "";
	/*表内外业务品种过滤*/
	String sInOutSQL = "";
	if(sInOutFlag.equals("1")){
		sInOutSQL = " AND OffSheetFlag in ('EntOn','IndOn') ";
	}else{
		sInOutSQL = " AND OffSheetFlag in ('EntOff','IndOff') ";
	}
	String sTitle = "";
	String sXaxis = "";
	String sZaxis = "";
	String sChartType = "";
	if(sShowPoint.indexOf("1") > -1){
		String sOrgNames = "";
		String sOrgBalance = "";
		sXaxis="0";     
		sZaxis="I";     
		sChartType="18";
		sTitle = "贷款结构(按机构分布)";
		sSql = "SELECT OrgID,OrgName from ORG_INFO WHERE RelativeOrgID=:RelativeOrgID";
		ASResultSet resultset = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("RelativeOrgID",sOrgId));
		HandelArray ha = new HandelArray(resultset);
		sResult1 = ha.get2DArray();
		sSerialNo1 = ha.get1DArray();
		
		while(resultset.next()){
			String sTempID = resultset.getString("OrgID");
			String sTempName = resultset.getString("OrgName");
			sOrgNames += sTempName+"\t";

			sSql = "SELECT SUM(balance)/10000 AS SumTotal FROM BUSINESS_CONTRACT "
			+"    WHERE InputOrgID in ((select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')"
			+ sInOutSQL
			+"    AND InputDate <= '"+sDataDate+"' ";

			String sTempSum = Sqlca.getString(sSql);
			sOrgBalance += sTempSum+"\t";
			
			sSerialNo1[iPointer] = sTempID;
			sResult1[iPointer][0] = sTempName;
			sResult1[iPointer][1] =sTempSum;

			iPointer++;
		}
		resultset.getStatement().close();

		iCounter++;
		sEisGraph=new String[iCounter][5];
		sEisGraph[iCounter-1][0]=sOrgId;
		sEisGraph[iCounter-1][1]=sXaxis;
		sEisGraph[iCounter-1][2]=sZaxis;
		sEisGraph[iCounter-1][3]=sChartType;
		String sSeriaoNo=String.valueOf(100+iCounter);
		sSeriaoNo=sSeriaoNo.substring(sSeriaoNo.length()-2);

		sEisGraph[iCounter-1][4]="changeOwcLayout("+sChartType+",ChartSpace"+sSeriaoNo+",\"Title"+sSeriaoNo+"\",\""+sOrgNames+"\",\""+sOrgBalance+"\",\"test\",\""+sTitle+"\");";
		ha = null;
	}

	if(sShowPoint.indexOf("2") > -1){
		String sItemNames = "";
		String sOrgBalance = "";
		sXaxis="0";     
		sZaxis="I";     
		sChartType="18";
		sTitle = "贷款结构(按担保方式)";
		sSql = "SELECT SUBSTRING(ISNULL(Vouchtype,'005'),1,3) AS ItemCode,"
			+" getItemName('VouchType',SUBSTRING(ISNULL(Vouchtype,'005'),1,3)) as ItemName, "
			+" SUM (Balance)/10000 as SumTotal  "
			+" FROM BUSINESS_CONTRACT"
			+" WHERE InputOrgID in (select OrgID from ORG_INFO where SortNo like :SortNo') "
			+ sInOutSQL
			+" AND InputDate <= :DataDate   "
			+" GROUP BY SUBSTRING (ISNULL(VouchType,'005'),1,3) ";
		ASResultSet resultset = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SortNo",sSortNo+"%").setParameter("DataDate",sDataDate));
		iPointer = 0;
		HandelArray ha = new HandelArray(resultset);
		sResult2 = ha.get2DArray();
		sSerialNo2 = ha.get1DArray();
		while(resultset.next()){
			sItemNames += resultset.getString("ItemName")+"\t";
			sOrgBalance += resultset.getString("SumTotal")+"\t";

			sSerialNo2[iPointer] = resultset.getString("ItemCode");
			sResult2[iPointer][0] = resultset.getString("ItemName");
			sResult2[iPointer][1] = resultset.getString("SumTotal");
			iPointer++;
		}
		resultset.getStatement().close();

		iCounter++;

		sTmpArray=new String[iCounter][5];
		System.arraycopy(sEisGraph,0,sTmpArray,0,sEisGraph.length);

		sTmpArray[iCounter-1][0]=sOrgId;

		sTmpArray[iCounter-1][1]=sXaxis;
		sTmpArray[iCounter-1][2]=sZaxis;
		sTmpArray[iCounter-1][3]=sChartType;
		String sSeriaoNo=String.valueOf(100+iCounter);
		sSeriaoNo=sSeriaoNo.substring(sSeriaoNo.length()-2);

		sTmpArray[iCounter-1][4]="changeOwcLayout("+sChartType+",ChartSpace"+sSeriaoNo+",\"Title"+sSeriaoNo+"\",\""+sItemNames+"\",\""+sOrgBalance+"\",\"test\",\""+sTitle+"\");";
			sEisGraph=new String[iCounter][5];
			for (int i=0;i<iCounter;i++)
				sEisGraph[i]=sTmpArray[i];
		ha = null;
	}

	if(sShowPoint.indexOf("3") > -1){
		String sBusinessName = "";
		String sOrgBalance = "";
		sXaxis="T";     
		sZaxis="I";     
		sChartType="18";
		sTitle = "贷款结构(按贷款品种)";
		
		sSql = "SELECT SUBSTRING(ISNULL(BusinessType,'1010'),1,4) AS ItemCode,"
			+" getBusinessName(SUBSTRING(ISNULL(BusinessType,'1010'),1,4)) as Typename, "
			+" SUM (Balance)/10000 as SumTotal  "
			+" FROM BUSINESS_CONTRACT"
			+" WHERE InputOrgID in (select OrgID from ORG_INFO where SortNo like :SortNo') "
			+ sInOutSQL
			+" AND InputDate <= :DataDate  "
			+" GROUP BY SUBSTRING (ISNULL(BusinessType,'1010'),1,4) ";

		ASResultSet resultset = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SortNo",sSortNo+"%").setParameter("DataDate",sDataDate));
		iPointer = 0;
		HandelArray ha = new HandelArray(resultset);
		sResult3 = ha.get2DArray();
		sSerialNo3 = ha.get1DArray();
		while(resultset.next()){
			sBusinessName += resultset.getString("Typename")+"\t";
			sOrgBalance += resultset.getString("SumTotal")+"\t";

			sSerialNo3[iPointer] = resultset.getString("ItemCode");
			sResult3[iPointer][0] = resultset.getString("Typename");
			sResult3[iPointer][1] = resultset.getString("SumTotal");
			iPointer++;
		}
		resultset.getStatement().close();

		iCounter++;

		sTmpArray=new String[iCounter][5];
		System.arraycopy(sEisGraph,0,sTmpArray,0,sEisGraph.length);

		sTmpArray[iCounter-1][0]=sOrgId;
		sTmpArray[iCounter-1][1]=sXaxis;
		sTmpArray[iCounter-1][2]=sZaxis;
		sTmpArray[iCounter-1][3]=sChartType;
		String sSeriaoNo=String.valueOf(100+iCounter);
		sSeriaoNo=sSeriaoNo.substring(sSeriaoNo.length()-2);
		sTmpArray[iCounter-1][4]="changeOwcLayout("+sChartType+",ChartSpace"+sSeriaoNo+",\"Title"+sSeriaoNo+"\",\""+sBusinessName+"\",\""+sOrgBalance+"\",\"业务品种\",\""+sTitle+"\");";
			sEisGraph=new String[iCounter][5];
			for (int i=0;i<iCounter;i++)
				sEisGraph[i]=sTmpArray[i];
		ha = null;
	}

	if(sShowPoint.indexOf("4") > -1){
		String sIndustrytypeNames = "";
		String sOrgBalance = "";
		sXaxis="0";     
		sZaxis="I";     
		sChartType="18";
		sTitle = "贷款结构(按行业分布)";
		
		sSql = "SELECT SUBSTRING(ISNULL(Direction,'A'),1,1) AS ItemCode,"
			+" getItemName('IndustryType',SUBSTRING(ISNULL(Direction,'A'),1,1)) as ItemName, "
			+" SUM (Balance)/10000 as SumTotal  "
			+" FROM BUSINESS_CONTRACT"
			+" WHERE InputOrgID in (select OrgID from ORG_INFO where SortNo like :SortNo) "
			+ sInOutSQL
			+" AND InputDate <= :DataDate  "
			+" GROUP BY SUBSTRING (ISNULL(Direction,'A'),1,1) ";
		ASResultSet resultset = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SortNo",sSortNo+"%").setParameter("DataDate",sDataDate));
		iPointer = 0;
		HandelArray ha = new HandelArray(resultset);
		sResult4 = ha.get2DArray();
		sSerialNo4 = ha.get1DArray();
		while(resultset.next()){
			sIndustrytypeNames += resultset.getString("ItemName")+"\t";
			sOrgBalance += resultset.getString("SumTotal")+"\t";

			sSerialNo4[iPointer] = resultset.getString("ItemCode");
			sResult4[iPointer][0] = resultset.getString("ItemName");
			sResult4[iPointer][1] = resultset.getString("SumTotal");
			iPointer++;
		}
		resultset.getStatement().close();

		iCounter++;

		sTmpArray=new String[iCounter][5];
		System.arraycopy(sEisGraph,0,sTmpArray,0,sEisGraph.length);

		sTmpArray[iCounter-1][0]=sOrgId;
		sTmpArray[iCounter-1][1]=sXaxis;
		sTmpArray[iCounter-1][2]=sZaxis;
		sTmpArray[iCounter-1][3]=sChartType;
		String sSeriaoNo=String.valueOf(100+iCounter);
		sSeriaoNo=sSeriaoNo.substring(sSeriaoNo.length()-2);
		sTmpArray[iCounter-1][4]="changeOwcLayout("+sChartType+",ChartSpace"+sSeriaoNo+",\"Title"+sSeriaoNo+"\",\""+sIndustrytypeNames+"\",\""+sOrgBalance+"\",\"test\",\""+sTitle+"\");";

		sEisGraph=new String[iCounter][5];
		for (int i=0;i<iCounter;i++)
			sEisGraph[i]=sTmpArray[i];
		ha = null;
	}

%>

<script type="text/javascript" src="Resources/1/htmlcontrol.js"></script>
<link rel="stylesheet" href="Resources/Style.css">
<div id="Layer1" style="position:absolute;width:100%; height:100%; z-index:1; overflow: auto">
<table border="0" width="100%" cellspacing="0" cellpadding="0">
  <tr>
    <td width="100%" height="20">
      <table border="1" width="99%" cellspacing="0" cellpadding="0" bordercolor="#BFBFBF" style="border-collapse: collapse" height="30">
      
	  <form name="frmOrg" method="POST">
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
				value='<%=sDataDate%>' readonly>
				&nbsp;
	</td>
	<td style="border:0px" valign="middle" align='left' width='10%' nowrap>		
	<script type="text/javascript">
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
<%
	int iPerRowNum=2,iNeedNewLine=iPerRowNum;
	if (sEisGraph!=null){
		for (int i=0;i<sEisGraph.length;i++){
			if (i>=iNeedNewLine){
				out.println("</tr><tr>");
				iNeedNewLine=iNeedNewLine+iPerRowNum;
			}
			String sSeriaoNo=String.valueOf(100+i+1);
			sSeriaoNo=sSeriaoNo.substring(sSeriaoNo.length()-2);
%>
	    <td width='50%' id='ChartObject<%=sSeriaoNo%>'  style="display:yes">
	    	<table width='100%' border=0 cellspacing="0" cellpadding="0">
	    	<tr>
		    <td align='left' width='100%'>
		    	<table id='ChartTable<%=sSeriaoNo%>' border="0" width="98%" cellspacing="0" cellpadding="0"><tr><td>
		    		<object classid="clsid:0002E556-0000-0000-C000-000000000046" style="display:yes" id="ChartSpace<%=sSeriaoNo%>" width="100%" height="180"></object>
		    	</td></tr></table>	
		    </td>
	        </tr>
		<tr>
		    <td align='left' valign='top'  id="chart<%=sSeriaoNo%>" status="1" style="cursor: pointer;display:yes" onclick="javascript:ChangeSize('chart<%=sSeriaoNo%>');" >
		    	<table id='ChartTitle<%=sSeriaoNo%>' border="0" width="98%" cellspacing="0" cellpadding="0" bgcolor='#000000' onmouseover="javascript:ChangeChartTitleColor('chart<%=sSeriaoNo%>','1');" onmouseout="javascript:ChangeChartTitleColor('chart<%=sSeriaoNo%>','2');"><tr><td align='middle'  nowrap id="Title<%=sSeriaoNo%>">
		    		<font face="Arial" style="font-size: 9pt" color="#FFFFFF">&nbsp;</font>
		    	</td></td></table>	
		    </td>
	        </tr>
	        </table>
	    </td>
<%
		}
		for (int i=sEisGraph.length-1;i<iNeedNewLine;i++){
%>
	    <td width='50%' >
	    	&nbsp;
	    </td>
<%
		}
	}
%>
  </tr>
</table>
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
  	OpenComp("LoanIndView","/DeskTop/LoanIndView.jsp","OrgID="+sOrgId+"&DataDate="+sDataDate+"&InOutFlag=<%=sInOutFlag%>","_self","");
}

function viewSubDetailInfo(sNo,sTypeNo)
{
	OpenComp("SubDetailInfo","/DeskTop/SubDetailInfo.jsp","InOutFlag=<%=sInOutFlag%>&OrgID=<%=sOrgId%>&DataDate=<%=sDataDate%>&ObjectNo="+sNo+"&TypeNo="+sTypeNo,"_self","");
}
</script>
<script type="text/javascript">
	var vPreRow=-1;

	function changeOwcLayout(vOwcType,objName,objTitleName,vCategories,vValues,vCaptions,vTitles)
	{
		var values;

		objName.Clear();
		objName.Interior.Color="#DCDCDC";
		objName.Border.Color = "#000000";
		objName.Charts.Add();
		
		var axs = objName.Charts(0).Axes(1);
			axs.Font.Name = "Arial";
		axs.Font.Size = 8;
		
		var axs = objName.Charts(0).Axes(0);
			axs.Font.Name = "Arial";
		axs.Font.Size = 8;

		objName.Charts(0).HasLegend = 1;	//显示图例

		var c = objName.Constants;
		var categories= vCategories;
		if ((vOwcType==0 || vOwcType==1 || vOwcType==47 || vOwcType==48) || (vOwcType==3 || vOwcType==4 || vOwcType==51 || vOwcType==52) || (vOwcType==8 || vOwcType==9 || vOwcType==56) || (vOwcType==30 || vOwcType==62) || (vOwcType==32 || vOwcType==33) || (vOwcType==21))	{	//柱状图(0/1/47/48)、条状图(3/4/51/52)、折线图(8/9/56)、面积图(30/62)、圆环图(32/33)、散点图(21)
			//获取柱子数

			var sSperator="@|@";
			var arrValues=vValues.split(sSperator);
			var iPillarCounter=arrValues.length;
			var arrCaptions=vCaptions.split("\t");
			
			for (var i=0;i<iPillarCounter;i++){
				objName.Charts(0).SeriesCollection.Add();
			}
	
			objName.Charts(0).Type = vOwcType;

			//鼠标移到柱形上出现的提示信息
			var vXaxis=c.chDimCategories;
			var vYaxis=c.chDimValues;
			if (vOwcType==21){	//散点图(21)
				vXaxis=c.chDimXValues;
				vYaxis=c.chDimYValues;
			}
			for (var i=0;i<iPillarCounter;i++){
				objName.Charts(0).SeriesCollection(i).Caption = arrCaptions[i];
				objName.Charts(0).SeriesCollection(i).SetData(vXaxis, c.chDataLiteral, categories);
				values = arrValues[i];
				objName.Charts(0).SeriesCollection(i).SetData(vYaxis, c.chDataLiteral, values);
			}
			
			objName.Charts(0).Legend.Position = 4;	//自动(0)、上(1)、下(2)、左(3)、右(4)
		}else if ((vOwcType==18 || vOwcType==19 || vOwcType==58 || vOwcType==59)){		//饼图(18/19/58/59)
			objName.Charts(0).SeriesCollection.Add();

			objName.Charts(0).Type = vOwcType;

			objName.Charts(0).SeriesCollection(0).Caption = vCaptions;

			objName.Charts(0).SeriesCollection(0).SetData(c.chDimCategories, c.chDataLiteral, categories);

			values = vValues;
			objName.Charts(0).SeriesCollection(0).SetData(c.chDimValues, c.chDataLiteral, values);
			
			objName.Charts(0).Legend.Position = 4;	//自动(0)、上(1)、下(2)、左(3)、右(4)
		}
		document.all(objTitleName).innerHTML="<font face='Arial' style='font-size: 9pt' color='#FFFFFF'>"+vTitles+"</font>";		
	}
			
	function ChangeChartTitleColor(selectedChart,t){
			var selectedChartSpace;
			var selectedChartObject;
			var selectedChartTable;
			var selectedChartTitle;

			selectedChartSpace = selectedChart.replace('chart','ChartSpace');
			selectedChartObject = selectedChart.replace('chart','ChartObject');
			selectedChartTable = selectedChart.replace('chart','ChartTable');
			selectedChartTitle = selectedChart.replace('chart','ChartTitle');
			
			if (t=='1'){
				document.all(selectedChartTitle).bgColor='#222222';
				document.all(selectedChartSpace).Interior.Color="#F0F0F0";
			}else{
				document.all(selectedChartTitle).bgColor='#000000';
				document.all(selectedChartSpace).Interior.Color="#DCDCDC";
			}
	}
	
	function ChangeSize(selectedChart){
			
			var selectedChartSpace;
			var selectedChartObject;
			var selectedChartTable;
			var selectedChartTitle;
			
			var showDataStatus="0";	//是否同时显示数据表
			selectedChartSpace = selectedChart.replace('chart','ChartSpace');
			selectedChartObject = selectedChart.replace('chart','ChartObject');
			selectedChartTable = selectedChart.replace('chart','ChartTable');
			selectedChartTitle = selectedChart.replace('chart','ChartTitle');
			selectedDataTable = selectedChart.replace('chart','DataTable');
			
			if (document.all(selectedChart).status=='1'){
					
					document.all(selectedChart).status='2';
					<%
					for (int i=0;i<sEisGraph.length;i++){
						String sSeriaoNo=String.valueOf(100+i+1);
						sSeriaoNo=sSeriaoNo.substring(sSeriaoNo.length()-2);
						out.println("document.all('Chart"+sSeriaoNo+"').style.display='none';");
						out.println("document.all('ChartObject"+sSeriaoNo+"').style.display='none';");
					}
					%>
					document.all(selectedChart).style.display='';
					document.all(selectedChartObject).style.display='';

					document.all(selectedChart).width='200%';
					document.all(selectedChartObject).width='100%';
					document.all(selectedChartTable).width='100%';
					document.all(selectedChartTitle).width='100%';
					document.all(selectedChartSpace).height='240';

					if (showDataStatus=='0'){
						document.all(selectedDataTable).style.display = ''
					}
			}
			else{
					document.all(selectedChart).status='1';
					document.all(selectedChartObject).width='50%';
					document.all(selectedChart).width='50%';
					document.all(selectedChartSpace).height='150';
					<%
					for (int i=0;i<sEisGraph.length;i++){
						String sSeriaoNo=String.valueOf(100+i+1);
						sSeriaoNo=sSeriaoNo.substring(sSeriaoNo.length()-2);
						out.println("document.all('Chart"+sSeriaoNo+"').style.display='';");
						out.println("document.all('ChartObject"+sSeriaoNo+"').style.display='';");
					}
					%>
					document.all(selectedChartSpace).Border.color="#000000";
					document.all(selectedChartTable).width='98%';
					document.all(selectedChartTitle).width='98%';
					if (showDataStatus=='0'){
						document.all(selectedDataTable).style.display = 'none';
					}
			}
	}
</script>

      <table id="DataTable01" scroll="yes" border="2" width="99%" cellspacing="0" cellpadding="0" bordercolor="#333333" style="border-collapse: collapse" height="100">
        <tr>
          <td nowrap width="20%" bgcolor="#BFBFBF" height="16" style="border:1px solid #909090; "><p align="center"><font face="Arial" style="font-size: 9pt" color="#000000">&nbsp;机构名称</font></td>
          <td nowrap width="20%" align="center" bgcolor="#BFBFBF" height="16" style="border:1px solid #909090; "><font face="Arial" style="font-size: 9pt" color="#000000">&nbsp;余额(万元)</font></td>
        </tr>
<%
	/*按机构统计*/
	for(int i = 0; i < sResult1.length; i++){
%>
        <tr>
          <td nowrap width="40%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='left'><font face="Arial" style="font-size: 9pt" color="#000000">
		  <a href="javascript:viewSubDetailInfo('01','<%=sSerialNo1[i]%>')" ><%=sResult1[i][0]%>&nbsp;</td>
          <td nowrap width="40%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult1[i][1])%>&nbsp;</td>
        </tr>
<%
	}
%>
      </table>

      <table id="DataTable02" scroll="yes" border="2" width="99%" cellspacing="0" cellpadding="0" bordercolor="#333333" style="border-collapse: collapse" height="100">
        <tr>
          <td nowrap width="20%" bgcolor="#BFBFBF" height="16" style="border:1px solid #909090; "><p align="center"><font face="Arial" style="font-size: 9pt" color="#000000">&nbsp;担保方式</font></td>
          <td nowrap width="20%" align="center" bgcolor="#BFBFBF" height="16" style="border:1px solid #909090; "><font face="Arial" style="font-size: 9pt" color="#000000">&nbsp;余额(万元)</font></td>
        </tr>
<%
	/*按担保方式统计*/
	for(int i = 0; i < sResult2.length; i++){
%>
        <tr>
          <td nowrap width="40%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='left'><font face="Arial" style="font-size: 9pt" color="#000000">
		  <a href="javascript:viewSubDetailInfo('02','<%=sSerialNo2[i]%>')" ><%=sResult2[i][0]%>&nbsp;</td>
          <td nowrap width="40%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult2[i][1])%>&nbsp;</td>
        </tr>
<%
	}
%>
      </table>

      <table id="DataTable03" scroll="yes" border="2" width="99%" cellspacing="0" cellpadding="0" bordercolor="#333333" style="border-collapse: collapse" height="100">
        <tr>
          <td nowrap width="20%" bgcolor="#BFBFBF" height="16" style="border:1px solid #909090; "><p align="center"><font face="Arial" style="font-size: 9pt" color="#000000">&nbsp;贷款品种</font></td>
          <td nowrap width="20%" align="center" bgcolor="#BFBFBF" height="16" style="border:1px solid #909090; "><font face="Arial" style="font-size: 9pt" color="#000000">&nbsp;余额(万元)</font></td>
        </tr>
<%
	/*按业务品种统计*/
	for(int i = 0; i < sResult3.length; i++){
%>
        <tr>
          <td nowrap width="40%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='left'><font face="Arial" style="font-size: 9pt" color="#000000">
		  <a href="javascript:viewSubDetailInfo('03','<%=sSerialNo3[i]%>')" >
		  <%=sResult3[i][0]%>&nbsp;</td>
          <td nowrap width="40%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult3[i][1])%>&nbsp;</td>
        </tr>
<%
	}
%>
      </table>

      <table id="DataTable04" scroll="yes" border="2" width="99%" cellspacing="0" cellpadding="0" bordercolor="#333333" style="border-collapse: collapse" height="100">
        <tr>
          <td nowrap width="20%" bgcolor="#BFBFBF" height="16" style="border:1px solid #909090; "><p align="center"><font face="Arial" style="font-size: 9pt" color="#000000">&nbsp;行业</font></td>
          <td nowrap width="20%" align="center" bgcolor="#BFBFBF" height="16" style="border:1px solid #909090; "><font face="Arial" style="font-size: 9pt" color="#000000">&nbsp;余额(万元)</font></td>
        </tr>
<%
	/*按国标行业分类统计*/
	for(int i = 0; i < sResult4.length; i++){
%>
        <tr>
          <td nowrap width="40%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='left'><font face="Arial" style="font-size: 9pt" color="#000000">
		  <a href="javascript:viewSubDetailInfo('04','<%=sSerialNo4[i]%>')"><%=sResult4[i][0]%>&nbsp;</td>
          <td nowrap width="40%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult4[i][1])%>&nbsp;</td>
        </tr>
<%
	}
%>
      </table>

</body>
</html>
<script type="text/javascript">
	document.all('dataTable01').style.display='none';
	document.all('dataTable02').style.display='none';
	document.all('dataTable03').style.display='none';
	document.all('dataTable04').style.display='none';
</script>
<script type="text/javascript">
<%
for (int i=0;i<sEisGraph.length;i++){
	out.println(sEisGraph[i][4]);
}
%>
</script>
<%@ include file="/IncludeEnd.jsp"%>
