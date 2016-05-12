<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
	<%
	/*
		Author: FMWu 2004-12-6
		Tester:
		Describe: ������ϵ��������;
		Input Param:
			ObjectType: ��������(ҵ��׶�)��
			ObjectNo: �����ţ�����/����/��ͬ��ˮ�ţ���
			ContractType: ��ͬ����
				010 һ�㵣����Ϣ
				020 ��߶����ͬ
		Output Param:
			ObjectType: ��������(ҵ��׶�)��
			ObjectNo: �����ţ�����/����/��ͬ��ˮ�ţ���
			ContractType: ��������
				010 һ�㵣����Ϣ
				020 ��߶����ͬ
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
			<font face="Arial" style="font-size: 9pt" color="#000000" >&nbsp;������</font>
			<input id='inputOrgId' type="hidden" name="CurOrgId" value="<%=sOrgId%>">
			<input id='inputOrgName' size="20" name="CurOrgName" value="<%=sOrgName%>" readonly>
	  </td>
	  <td style="border:0px" nowrap>
			 <script>
				 hc_drawButtonWithTip("ѡ�����","ѡ�����","selectOrg()","/credit/Resources/1")
			 </script>
	  </td>
	  <td style="border:0px" valign="middle" nowrap>
		<font face="Arial" style="font-size: 9pt" color="#000000" >&nbsp;����ھ���</font>
		<SELECT NAME="SortType" onchange="doSubmit()">
			<Option value="01">�������</Option>
			<Option value="02">�������</Option>
			<Option value="03">������ϼ�</Option>
			<Option value="04">�������</Option>
		</SELECT>
	  </td>
	  <td style="border:0px" valign="middle" nowrap>
		<font face="Arial" style="font-size: 9pt" color="#000000" >&nbsp;��λ����</font>
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
	<B>�������嵥</B>
	<iframe name="rightup" scrolling="yes" src="<%=sWebRootPath%>/Blank.jsp?TextToShow=���Ե�" width=100% height=100% frameborder=0></iframe> 
    </td>
  </tr>
  <tr> 
    <td>
	<div id=divDrag title='����ק�ı䴰�ڴ�С' ondrag="dragFrame(event);"><img class=imgsDrag src=<%=sResourcesPath%>/1x1.gif></div>
	<B>���ſͻ����嵥</B>
	<iframe name="rightdown" scrolling="yes" src="<%=sWebRootPath%>/Blank.jsp?TextToShow=���Ե�" width=100% height=100% frameborder=0></iframe> 
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
