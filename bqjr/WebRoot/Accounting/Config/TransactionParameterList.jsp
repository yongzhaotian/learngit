<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

	<%
	String PG_TITLE = "����ģ�������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	
	String attribute1 =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("attribute1"));
	if(attribute1==null) attribute1="";

	ASDataObject doTemp = new ASDataObject("TransactionParameterList",Sqlca);//���׶�Ӧ������Ҫ��ģ��
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(50);
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(attribute1);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		
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
