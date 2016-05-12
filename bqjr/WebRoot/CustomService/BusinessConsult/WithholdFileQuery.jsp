<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "代扣文件详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag"));
	String sInputDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("InputDate"));
	
	if (sFlag == null) sFlag = "";
	if (sInputDate == null) sInputDate = "";
	
	String sTempletNoType = "";//模型编号
	if ("1".equals(sFlag)) sTempletNoType="ImportFileEBU";
	else if ("2".equals(sFlag))  sTempletNoType="ImportFileKFT";
	else if ("4".equals(sFlag))  sTempletNoType="ImportFileHBank";
	else  sTempletNoType="ImportReconciliationEBU";

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = sTempletNoType;//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	
	//doTemp.WhereClause += " InputDate="+sInputDate;
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(15);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sInputDate);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","保存","保存记录","saveRecord()",sResourcesPath},
		{"false","","Button","返回","返回列表也面","goBack()",sResourcesPath},
		{"false","","Button","返回xxxx","返回列表也面","selectAreaInfo()",sResourcesPath},
	};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	
	</script>

<script language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	

<%@ include file="/IncludeEnd.jsp"%>
