<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "���û����¼�б�"; // ��������ڱ��� <title> PG_TITLE </title>

	String templetFilter="1=1";
	String templetNo;
	//����������
	
	//���ҳ�����
	String objectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String objectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));//��ݱ��
	if(objectType==null) objectType="";
	if(objectNo == null) objectNo="";

	String sTemplete = "FeeRecordList";
    ASDataObject doTemp = new ASDataObject(sTemplete,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪFreeform���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	//��ģ��Ӧ����Datawindow
	Vector vTemp = dwTemp.genHTMLDataWindow(objectType+","+objectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
	};
	%> 

<%@include file="/Resources/CodeParts/List05.jsp"%>

<script language=javascript>
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	


<%@ include file="/IncludeEnd.jsp"%>
