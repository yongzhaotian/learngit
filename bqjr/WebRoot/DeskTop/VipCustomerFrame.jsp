<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
	<%
	/*
		Author: FMWu 2004-12-6
		Tester:
		Describe: 关联关系智能搜索;
		Input Param:
			ObjectType: 对象类型(业务阶段)。
			ObjectNo: 对象编号（申请/批复/合同流水号）。
			ContractType: 合同类型
				010 一般担保信息
				020 最高额担保合同
		Output Param:
			ObjectType: 对象类型(业务阶段)。
			ObjectNo: 对象编号（申请/批复/合同流水号）。
			ContractType: 担保类型
				010 一般担保信息
				020 最高额担保合同
		HistoryLog:
	 */
	%>
<%
	String sOrgName ="";
	String sOrgId = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	if (sOrgId==null) {
		sOrgId = CurOrg.getOrgID();
	}
	sOrgName = Sqlca.getString(new SqlObject("select OrgName from ORG_INFO where OrgID =:OrgID").setParameter("OrgID",sOrgId));
%>
<style>
.imgsDrag{
	width:100%;
	height:2px;
	background-color:#777777;
	cursor: s-resize;
}
</style>
<html>
<head>
<title>untitled</title>
</head>
<body class="pagebackground" leftmargin="0" topmargin="0" onload="" >

<table border="1" width="99%" cellspacing="0" cellpadding="0" bordercolor="#BFBFBF" style="border-collapse: collapse" height="12">
	<tr>
	  <td style="border:0px" nowrap>
			<font face="Arial" style="font-size: 9pt" color="#000000" >&nbsp;机构：</font>
			<input id='inputOrgId' type="hidden" name="CurOrgId" value="<%=sOrgId%>">
			<input id='inputOrgName' size="20" name="CurOrgName" value="<%=sOrgName%>" readonly>
	  </td>
	  <td style="border:0px" nowrap>
			 <script>
				 hc_drawButtonWithTip("选择机构","选择机构","selectOrg()","/credit/Resources/1")
			 </script>
	  </td>
	  <td style="border:0px" valign="middle" nowrap>
		<font face="Arial" style="font-size: 9pt" color="#000000" >&nbsp;排序口径：</font>
		<SELECT NAME="SortType" onchange="doSubmit()">
			<Option value="01">表内余额</Option>
			<Option value="02">表外余额</Option>
			<Option value="03">表内外合计</Option>
			<Option value="04">不良余额</Option>
		</SELECT>
	  </td>
	  <td style="border:0px" valign="middle" nowrap>
		<font face="Arial" style="font-size: 9pt" color="#000000" >&nbsp;排位数：</font>
		<SELECT NAME="ListSize" onchange="doSubmit()">
			<Option value="5">5</Option>
			<Option value="10" selected>10</Option>
			<Option value="20">20</Option>
			<Option value="50">50</Option>
		</SELECT>
	  </td>
	</tr>
</table>
<table border="1" width="99%" height="100%" cellspacing="0" cellpadding="0"bordercolor="#BFBFBF" style="border-collapse: collapse">
  <tr> 
    <td id="mytop">
	<B>单户大户清单</B>
	<iframe name="rightup" scrolling="yes" src="<%=sWebRootPath%>/Blank.jsp?TextToShow=请稍等" width=100% height=100% frameborder=0></iframe> 
    </td>
  </tr>
  <tr> 
    <td>
	<div id=divDrag title='可拖拽改变窗口大小' ondrag="dragFrame(event);"><img class=imgsDrag src=<%=sResourcesPath%>/1x1.gif></div>
	<B>集团客户大户清单</B>
	<iframe name="rightdown" scrolling="yes" src="<%=sWebRootPath%>/Blank.jsp?TextToShow=请稍等" width=100% height=100% frameborder=0></iframe> 
    </td>
  </tr>
</table>
</body>
</html>
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
	sSortType = document.all("SortType").value;
	sListSize = document.all("ListSize").value;
	OpenPage("/DeskTop/VipCustomerList.jsp?OrgID="+sOrgId+"&SortType="+sSortType+"&ListSize="+sListSize+"&CustomerType=010","rightup","");
	OpenPage("/DeskTop/VipCustomerList.jsp?OrgID="+sOrgId+"&SortType="+sSortType+"&ListSize="+sListSize+"&CustomerType=020","rightdown","");
}

doSubmit();

function dragFrame(event) {
	if(event.y>100 && event.y<420) { 
		mytop.height=event.y-10;
	}
	if(event.y<100 || event.y>400) {
		window.event.returnValue = false;
	}
}
</script>

<%@ include file="/IncludeEnd.jsp"%>
