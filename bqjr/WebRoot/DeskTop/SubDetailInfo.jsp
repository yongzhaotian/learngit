<%
/*
 * Copyright (c) 1999-2005 Amarsoft, Inc.
 * 3103 No.800 Quyang Rd. Shanghai,P.R. China
 * All Rights Reserved.
 *
 * This software is the confidential and proprietary information
 * of Amarsoft, Inc. You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms
 * of the license agreement you entered into with Amarsoft.
 */
%>
<%
/**
 * FileName SubDetailInfo.jsp
 * Title:	在基础数据上的再次向下钻取
 * Description:	因为展示字段数量少且内容相似，众多页面可以公用一个页面。
 *
 * @author zllin@amarsoft.com
 * @version 1.0 Mar 23,2005
 *          Tester:
 *          History Log: 1、
 *					2、
 */
%>
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

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*查询图标元素编号*/
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectNo==null) sObjectNo="01";
	/*查询参数如机构，业务品种等*/
	String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	if(sTypeNo==null) sTypeNo="@@@@";
	/*查询数据日期*/
	String sDataDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DataDate"));
	if(sDataDate == null) sDataDate = StringFunction.getToday();
	/*表内外标志*/
	String sInOutFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("InOutFlag"));
	if(sInOutFlag == null) sInOutFlag = "1";		//默认表内

	/*查询机构*/
	String sOrgId = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	if (sOrgId==null) {
		sOrgId = CurOrg.getOrgID();
	}

	/*表内外业务品种过滤*/
	String sInOutSQL = "";
	if(sInOutFlag.equals("1")){
		sInOutSQL = " AND OffSheetFlag in ('EntOn','IndOn') ";
	}else{
		sInOutSQL = " AND OffSheetFlag in ('EntOff','IndOff') ";
	}

	String sSql = "";
	String sTitle = "";
	String sLen = "";
	HashMap mapsCode = new HashMap();
	SqlObject so = null;
	String sNewSql = "";

	int iObjectNo = Integer.parseInt(sObjectNo);
	switch(iObjectNo){
		case 1:
			/*按机构统计*/
			String sSortNo=Sqlca.getString(new SqlObject("select SortNo from Org_Info where OrgID=:OrgID").setParameter("OrgID",sTypeNo));
			if(sSortNo==null)sSortNo="";
			sTitle = "机构名称";
			
			sSql = "SELECT InputOrgID as TypeNo,getOrgName(InputOrgID) AS TypeName, "
			+" SUM(balance)/10000 AS TotalBalance  "
			+" FROM BUSINESS_CONTRACT "
			+" WHERE InputOrgID in (select OrgID from ORG_INFO where SortNo like :SortNo)"
			+ sInOutSQL
			+" AND InputDate <= :DataDate "
			+" GROUP BY InputOrgID ";
			so = new SqlObject(sSql);
			so.setParameter("SortNo",sSortNo+"%");
			so.setParameter("DataDate",sDataDate);
			break;
		case 2:
			/*按担保方式统计*/
			mapsCode.put("3","5");
			mapsCode.put("5","7");
			mapsCode.put("7","7");
			sTitle = "担保方式";
			sLen = String.valueOf(sTypeNo.length());
			sSortNo=Sqlca.getString(new SqlObject("select SortNo from Org_Info where OrgID=:OrgID").setParameter("OrgID",sOrgId));
			if(sSortNo==null)sSortNo="";

			sSql = "SELECT SUBSTRING(VouchType,1,"+mapsCode.get(sLen)+") AS TypeNo,"
				+" getItemName('VouchType',SUBSTRING(Vouchtype,1,"+mapsCode.get(sLen)+")) as TypeName, "
				+" SUM (Balance)/10000 as TotalBalance  "
				+" FROM BUSINESS_CONTRACT"
				+" WHERE InputOrgID in (select OrgID from ORG_INFO where SortNo like :SortNo) "
				+ sInOutSQL
				+" AND InputDate <= :DataDate  "
				+" AND VouchType like :TypeNo"
				+" GROUP BY SUBSTRING (VouchType,1,"+mapsCode.get(sLen)+")";
			so = new SqlObject(sSql);
			so.setParameter("SortNo",sSortNo+"%");
			so.setParameter("DataDate",sDataDate);
			so.setParameter("TypeNo",sTypeNo+"%");
			/*释放HashMap Obj*/
			mapsCode = null;
			break;
		case 3:
			/*按业务品种统计*/
			mapsCode.put("4","7");
			mapsCode.put("7","10");
			mapsCode.put("10","10");
			sLen = String.valueOf(sTypeNo.length());
			sSortNo=Sqlca.getString(new SqlObject("select SortNo from Org_Info where OrgID=:OrgID").setParameter("OrgID",sOrgId));
			if(sSortNo==null)sSortNo="";

			sTitle = "业务品种";
			sSql = "SELECT SUBSTRING(BusinessType,1,"+mapsCode.get(sLen)+") AS TypeNo,"
				+" getBusinessName(SUBSTRING(BusinessType,1,"+mapsCode.get(sLen)+")) as TypeName, "
				+" SUM (Balance)/10000 as TotalBalance  "
				+" FROM BUSINESS_CONTRACT"
				+" WHERE InputOrgID in (select OrgID from ORG_INFO where SortNo like :SortNo) "
				+ sInOutSQL
				+" AND InputDate <= :DataDate "
				+" AND BusinessType like :TypeNo"
				+" GROUP BY SUBSTRING (BusinessType,1,"+mapsCode.get(sLen)+")";
			so = new SqlObject(sSql);
			so.setParameter("SortNo",sSortNo+"%");
			so.setParameter("DataDate",sDataDate);
			so.setParameter("TypeNo",sTypeNo+"%");
			mapsCode = null;
			break;
		case 4:
			/*按国标行业分类统计*/
			//A  A01 A011 A0111   length = 1,3,4
			mapsCode.put("1","3");
			mapsCode.put("3","4");
			mapsCode.put("4","5");
			mapsCode.put("5","5");

			sLen = String.valueOf(sTypeNo.length());
			sTitle = "行业分类";
			sSortNo=Sqlca.getString(new SqlObject("select SortNo from Org_Info where OrgID=:OrgID").setParameter("OrgID",sOrgId));
			if(sSortNo==null)sSortNo="";

			sSql = "SELECT SUBSTRING(Direction,1,"+mapsCode.get(sLen)+") AS TypeNo,"
				+" getItemName('IndustryType',SUBSTRING(Direction,1,"+mapsCode.get(sLen)+")) as TypeName, "
				+" SUM (Balance)/10000 as TotalBalance  "
				+" FROM BUSINESS_CONTRACT"
				+" WHERE InputOrgID in (select OrgID from ORG_INFO where SortNo like :SortNo) "
				+ sInOutSQL
				+" AND InputDate <= :DataDate  "
				+" AND Direction like :TypeNo"
				+" GROUP BY SUBSTRING (Direction,1,"+mapsCode.get(sLen)+")";
			so = new SqlObject(sSql);
			so.setParameter("SortNo",sSortNo+"%");
			so.setParameter("DataDate",sDataDate);
			so.setParameter("TypeNo",sTypeNo+"%");
			/*释放资源*/
			mapsCode = null;
			break;
	}
	ASResultSet asrs = Sqlca.getASResultSet(so);
	HandelArray ha = new HandelArray(asrs);
	String[][] sResult = ha.get2DArray();
	String[] sRelativeNo = ha.get1DArray();
	String[][] sEisGraph = null;
	String sXaxis,sZaxis,sChartType="";
	String sTypeName = "";
	String sTypeValue = "";
	int iCounter = 0;
	int iPointer = 0;
	ha = null;
	while(asrs.next()){
		sTypeName += asrs.getString("TypeName")+"\t";
		sTypeValue += asrs.getString("TotalBalance")+"\t";
		sRelativeNo[iPointer] = asrs.getString("TypeNo");
		sResult[iPointer][0] = asrs.getString("TypeName");
		sResult[iPointer][1] = asrs.getString("TotalBalance");
		iPointer++;
	}
	asrs.getStatement().close();

	sXaxis="0";     
	sZaxis="I";     
	sChartType="58";
	iCounter++;
	sEisGraph=new String[iCounter][5];
	sEisGraph[iCounter-1][0] = sOrgId;
	sEisGraph[iCounter-1][1] = sXaxis;
	sEisGraph[iCounter-1][2] = sZaxis;
	sEisGraph[iCounter-1][3] = sChartType;
	String sSerialNo=String.valueOf(100+iCounter);
	sSerialNo=sSerialNo.substring(sSerialNo.length()-2);
	sEisGraph[iCounter-1][4]="changeOwcLayout("+sChartType+",ChartSpace"+sSerialNo+",\"Title"+sSerialNo+"\",\""+sTypeName+"\",\""+sTypeValue+"\",\""+sTypeName+"\",\""+sTitle+"\");";
%>
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
<script type="text/javascript" src="Resources/1/htmlcontrol.js"></script>
<link rel="stylesheet" href="Resources/Style.css">
<table border="0" width="100%" cellspacing="0" cellpadding="0">
  <tr>
<%
	int iPerRowNum=3,iNeedNewLine=iPerRowNum;
	if (sEisGraph!=null){
		for (int i=0;i<sEisGraph.length;i++){
			if (i>=iNeedNewLine){
				out.println("</tr><tr>");
				iNeedNewLine=iNeedNewLine+iPerRowNum;
			}
			String sSeriaoNo=String.valueOf(100+i+1);
			sSeriaoNo=sSeriaoNo.substring(sSeriaoNo.length()-2);
%>
	    <td width='33%' id='ChartObject<%=sSeriaoNo%>'  style="display:yes">
	    	<table width='100%' border=0 cellspacing="0" cellpadding="0">
	    	<tr>
		    <td align='left' width='100%'>
		    	<table id='ChartTable<%=sSeriaoNo%>' border="0" width="98%" cellspacing="0" cellpadding="0"><tr><td>
		    		<object classid="clsid:0002E556-0000-0000-C000-000000000046" style="display:yes" id="ChartSpace<%=sSeriaoNo%>" width="100%" height="150"></object>
		    	</td></tr></table>	
		    </td>
	        </tr>
		<tr>
		    <td align='left' valign='top'  id="chart<%=sSeriaoNo%>" status="1" style="cursor:pointer;display:yes" onload = "javascript:initChart();" >
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
	    <td width='33%' >
	    	&nbsp;
	    </td>
<%
		}
	}
%>
  </tr>
</table>
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
				;//alert(categories);
				;//alert(arrValues[i]);
				objName.Charts(0).SeriesCollection(i).Caption = arrCaptions[i];
				objName.Charts(0).SeriesCollection(i).SetData(vXaxis, c.chDataLiteral, categories);
				values = arrValues[i];
				objName.Charts(0).SeriesCollection(i).SetData(vYaxis, c.chDataLiteral, values);
			}
			
			//objName.HasChartSpaceLegend = true;
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

	/*初始化*/
	document.all('Chart01').style.display='';
	document.all('Chart01').width='300%';
	document.all('ChartObject01').width='100%';
	document.all('ChartTable01').width='100%';
	document.all('ChartTitle01').width='100%';
	document.all('ChartSpace01').height='240';
	var lasttrack = "";
	function radiocheck(radioname){
		if(lasttrack=="")
			lasttrack = radioname;
		if(lasttrack != radioname){
			document.all(lasttrack).checked = false;
			lasttrack = radioname;
		}
		document.all(radioname).checked = true;
		document.all("radiovalue").value = document.all(radioname).value;
	}

	function viewBusinessList(){
		var sRadioValue = document.all("radiovalue").value;
		if(typeof(sRadioValue)=="undefined"||sRadioValue==""){
			alert("请选择记录。");
			return;
		}
		/*页面参数*/
		var sCustomerID="";
		var sVouchType="";
		var sBusinessType="";
		var sCreditLevel="";
		var sDirection="";
		var sTypeValue = sRadioValue.split("@");
		switch(parseInt(sTypeValue[0])){
			case 1:
				/*按机构统计*/
				sOrgId = sTypeValue[1];
				break;
			case 2:
				/*按担保方式统计*/
				sVouchType = sTypeValue[1];
				break;
			case 3:
				/*按业务品种统计*/
				sBusinessType = sTypeValue[1];
				break;
			case 4:
				/*按国标行业分类统计*/
				sDirection = sTypeValue[1];
				//alert(sDirection);
				break;
		}
		OpenComp("BusinessTypeList","/DeskTop/BusinessTypeList.jsp","InOutFlag=<%=sInOutFlag%>&OrgID=<%=sOrgId%>&InputDate=<%=sDataDate%>&VouchType="+sVouchType+"&BusinessType="+sBusinessType+"&Direction="+sDirection,"_blank","");
	}
function viewSubDetailInfo(sNo,sTypeNo)
{
	OpenComp("SubDetailInfo","/DeskTop/SubDetailInfo.jsp","InOutFlag=<%=sInOutFlag%>&OrgID=<%=sOrgId%>&DataDate=<%=sDataDate%>&ObjectNo="+sNo+"&TypeNo="+sTypeNo,"_self","");
}
</script>

<div id="Layer1" style="position:absolute;width:100%; height:100%; z-index:1; overflow: auto">
      <table id="DataTable01" scroll="yes" border="2" width="99%" cellspacing="0" cellpadding="0" bordercolor="#333333" style="border-collapse: collapse" height="100">
		<tr>
		  <td nowrap width="10%"></td>
          <td nowrap width="40%" bgcolor="#BFBFBF" height="16" style="border:1px solid #909090; "><p align="center"><font face="Arial" style="font-size: 9pt" color="#000000">&nbsp;<%=sTitle%></font></td>
          <td nowrap width="50%" align="center" bgcolor="#BFBFBF" height="16" style="border:1px solid #909090; "><font face="Arial" style="font-size: 9pt" color="#000000">&nbsp;余额(万元)</font></td>
		  <td><input name = "radiovalue" type="hidden" value = ""></td>
        </tr>
<%
	for(int i = 0; i < sResult.length; i++){
%>
        <tr>
		  <td nowrap width="10%"><input type = radio name="Radio<%=sRelativeNo[i]%>" value = "<%=sObjectNo+"@"+sRelativeNo[i]%>" onclick = "javascript:radiocheck('Radio<%=sRelativeNo[i]%>');"></td>
          <td nowrap width="40%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='left'><font face="Arial" style="font-size: 9pt" color="#000000">
		  <a href="javascript:viewSubDetailInfo('<%=sObjectNo%>','<%=sRelativeNo[i]%>')" ><%=sResult[i][0]%>&nbsp;</td>
          <td nowrap width="50%" style="border:1px solid #C0C0C0; " height="15" bgcolor="#FFFFFF" align='right'><font face="Arial" style="font-size: 9pt" color="#000000"><%=toMoneyZero(sResult[i][1])%> &nbsp;</td>
        </tr>
<%
	}
%>
	<tr>
    	<td style="border:0px" valign="middle" align='left' width='10%' nowrap colspan =3>		
			 <script>
                 hc_drawButtonWithTip("查看项下业务明细","查看项下业务明细","javascript:viewBusinessList()","/credit/Resources/1")
             </script>
		</td>
		<td style="border:0px" valign="middle" align='left' width='10%' nowrap colspan =3>		
			 <script>
                 hc_drawButtonWithTip("返回","返回","javascript:window.history.back()","/credit/Resources/1")
             </script>
		</td>
	</tr>
      </table>
</div>
</body>
</html>
<script type="text/javascript">
<%
for (int i=0;i<sEisGraph.length;i++){
	out.println(sEisGraph[i][4]);
}
%>
</script>
<%@ include file="/IncludeEnd.jsp"%>