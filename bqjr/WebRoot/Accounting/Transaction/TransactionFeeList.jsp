<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	String PG_TITLE = "������ȡ�����б����"; // ��������ڱ��� <title> PG_TITLE </title>
%>

<%
	//���ҳ�����,��������ˮ��
	String parentTransSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParentTransSerialNo"));
	if(parentTransSerialNo == null) parentTransSerialNo = "";
%>

<%
	//����DW����
	String sTempletNo = "Transaction_Fee";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo, sTempletFilter, Sqlca);
	//���ӹ�����	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����ҳ����ʾ������
	dwTemp.setPageSize(10);
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(parentTransSerialNo);
	for(int i=0;i<vTemp.size();i++)out.print((String)vTemp.get(i));

%>


<%
	String sButtons[][] = {
			{"true","All","Button","����","����","saveRecord()",sResourcesPath}
	};
%> 

<%@include file="/Resources/CodeParts/List05.jsp"%>

<script language=javascript>

	/*~[Describe=���ݱ���;InputParam=��;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		if(!vI_all("myiframe0")) return;
		as_save("myiframe0",sPostEvents);
	}
</script>
	
	<script language=javascript>	
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	</script>	


<%@ include file="/IncludeEnd.jsp"%>
