<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "ԭ�ظ������";

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ReconsiderList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","���ݵ���","���ݵ���","ImportRecord()",sResourcesPath},
		};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">


	//����ԭ�ظ�������
	function ImportRecord(){
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0) {
			// ����Excel�� 
			alert("��ѡ���ļ���");
			return;
		}

		//����ԭ�ظ��������¼
		RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "ImportReconsiderInfo", "filePath="+sFilePath+",userid="+"<%=CurUser.getUserID()%>,inputdate="+"<%=StringFunction.getTodayNow()%>");
		reloadSelf();
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>