<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "�û���ɫ������"; // ��������ڱ��� <title> PG_TITLE </title>

	String sTempletNo="AuditUserChangeList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);	
	
	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	if(!doTemp.haveReceivedFilterCriteria()) 
	  doTemp.WhereClause+=" and BeginTime like '"+StringFunction.getToday()+"%' and userID='"+CurUser.getUserID()+"'";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(40); 	//��������ҳ
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				
	String sButtons[][] = {};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>
<%@include file="/IncludeEnd.jsp"%>