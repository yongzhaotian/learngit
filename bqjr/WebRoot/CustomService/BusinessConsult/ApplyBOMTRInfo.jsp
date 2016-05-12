<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String PG_TITLE = "申请详情";

	String serialNo = DataConvert.toString(DataConvert.toRealString(
			iPostChange, (String)CurPage.getParameter("serialNO"))); //流水号
	String sTempletNo = "BOMTRInfoDetails";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo, Sqlca);
	doTemp.parseFilterData(request, iPostChange);
	CurPage.setAttribute("FilterHTML", doTemp.getFilterHtml(Sqlca));
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "2";   //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(serialNo);
	for(int i = 0; i < vTemp.size(); i++) {
		out.print((String)vTemp.get(i));
	}
	
	String sButtons[][] = {};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	bFreeFormMultiCol = true;
	my_load(2, 0, 'myiframe0');
</script>
<%@ include file="/IncludeEnd.jsp"%>