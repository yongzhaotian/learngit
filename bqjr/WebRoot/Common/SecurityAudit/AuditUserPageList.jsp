<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "ҳ�����ʱ����־"; // ��������ڱ��� <title> PG_TITLE </title>
	
	String sToday=StringFunction.getToday();
	String sTempletNo="AuditUserPageList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);	
	
	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1 = 2 "; //�������������ν���ҳ���ʱ���Զ���ѯ
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(40); 	//��������ҳ

	Vector vTemp = dwTemp.genHTMLDataWindow(sToday);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				
	String sButtons[][] = {
		{"true","","PlainText","���ڱ�ҳ��������������ͨ����ѯ������ѯ","���ڱ�ҳ��������������ͨ����ѯ������ѯ","style={color:red}",sResourcesPath}		
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>
<%@include file="/IncludeEnd.jsp"%>