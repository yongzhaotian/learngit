<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "�����ļ�����"; // ��������ڱ��� <title> PG_TITLE </title>
	
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag"));
	String sInputDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("InputDate"));
	
	if (sFlag == null) sFlag = "";
	if (sInputDate == null) sInputDate = "";
	
	String sTempletNoType = "";//ģ�ͱ��
	if ("1".equals(sFlag)) sTempletNoType="ImportFileEBU";
	else if ("2".equals(sFlag))  sTempletNoType="ImportFileKFT";
	else if ("4".equals(sFlag))  sTempletNoType="ImportFileHBank";
	else  sTempletNoType="ImportReconciliationEBU";

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = sTempletNoType;//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	
	//doTemp.WhereClause += " InputDate="+sInputDate;
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(15);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sInputDate);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","����","�����¼","saveRecord()",sResourcesPath},
		{"false","","Button","����","�����б�Ҳ��","goBack()",sResourcesPath},
		{"false","","Button","����xxxx","�����б�Ҳ��","selectAreaInfo()",sResourcesPath},
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
