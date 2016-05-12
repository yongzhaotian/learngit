<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<link rel="stylesheet" href="<%=sResourcesPath%>/css/tabs.css">
<script type='text/javascript' src='<%=sResourcesPath%>/js/plugins/tabstrip-1.0.js'></script>
<%
	/*
		Author:  --
		Tester:	
		Content: --�ͻ����񱨱����
		Input Param:
                 CustomerID��--�ͻ���
                 Term --�����������²������ݣ�
                    ReportCount ��--���������
                    AccountMonth1��--���������
                    Scope��--����Χ
	 */
   	//���ҳ��������ͻ����롢Term�����Ĳ������������������������¡�����Χ��
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sTerm       = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Term"));
	sTerm = sTerm.replace('@','&');
%>
<html>
<head>
	<title>�ṹ����</title>
</head>
<body leftmargin="0" topmargin="0" class="pagebackground" style="margin:0;padding:0;";>
<div id="tabdiv" style="border:0px solid #F00;z-index:-1;width:100%;height:100%;padding:0,0.5%">&nbsp;</div>
</body>
</html>

<script type="text/javascript">
$(document).ready(function(){
	parent.document.title="�ṹ����";
	$("#TitleDiv").hide();
	//top.document.getElementById("TitleDiv").style.display = "none";
	var tabCompent = new TabStrip("TrendTab","TrendInfo","tab","#tabdiv");
	tabCompent.setSelectedItem("0");
	tabCompent.setIsCache(false);
	<%
		String sFinanceBelong = "";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select FinanceBelong from ENT_INFO where CustomerID= :CustomerID").setParameter("CustomerID",sCustomerID));
		if(rs.next()) sFinanceBelong = rs.getString(1);	
		rs.getStatement().close();
		
		String sReportNo = "", sReportName = "";
		int iCount = 0;
		String sSql = "select ReportNo,ReportName from FINANCE_CATALOG where FINANCE_CATALOG.BelongIndustry =:BelongIndustry"+" order by ReportNo";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("BelongIndustry",sFinanceBelong));
		while(rs.next()) {
			sReportNo = rs.getString(1);
			sReportName = rs.getString(2);
			if(Double.parseDouble(sReportNo.substring(3,4))> 2) break;
			String script = "OpenComp('StructureDetail','/CustomerManage/FinanceAnalyse/StructureDetail.jsp','CustomerID="+sCustomerID+"&ReportNo="+sReportNo+""+sTerm+"')";
			out.println("tabCompent.addDataItem('"+iCount+"',\""+sReportName+"\", \""+script+"\",true,false);");
			iCount++;
		}
		rs.getStatement().close();
	%>
	tabCompent.initTab();
});
</script>
<%@ include file="/IncludeEnd.jsp"%>