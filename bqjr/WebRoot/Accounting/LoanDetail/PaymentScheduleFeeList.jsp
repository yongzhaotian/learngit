<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

	<%
	String PG_TITLE = "���üƻ���Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>

	//�������
	String sSql = "";
	//���ҳ�����
	String objectNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")));
	String objectType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")));
	
	// ����̨���б�
	ASDataObject doTemp = new ASDataObject("PaymentScheduleAcctFeeList",Sqlca);
	
	// ���ò�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20); 	//��������ҳ
	
	Vector vTemp = dwTemp.genHTMLDataWindow(objectNo+","+objectType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath},
		};
	%>


<%@include file="/Resources/CodeParts/List05.jsp"%>

	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	
	function exportAll()
	{
		amarExport("myiframe0");
	}

	</script>


<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>


<%@	include file="/IncludeEnd.jsp"%>