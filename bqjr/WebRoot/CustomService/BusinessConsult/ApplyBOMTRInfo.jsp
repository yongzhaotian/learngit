<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String PG_TITLE = "��������";

	String serialNo = DataConvert.toString(DataConvert.toRealString(
			iPostChange, (String)CurPage.getParameter("serialNO"))); //��ˮ��
	String sTempletNo = "BOMTRInfoDetails";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo, Sqlca);
	doTemp.parseFilterData(request, iPostChange);
	CurPage.setAttribute("FilterHTML", doTemp.getFilterHtml(Sqlca));
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "2";   //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);
	
	//����HTMLDataWindow
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