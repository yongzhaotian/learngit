<%@page import="com.amarsoft.app.billions.CommonConstans"%>
<%@page import="org.apache.poi.hssf.usermodel.*"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "������Ʒ";
	//���ҳ�����
	String sSSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SSerialNo"));
	String sSNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNo"));
	String sStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Status"));
	String sFlag =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("sFlag"));

	
	if(sSSerialNo == null) sSSerialNo = "";
	if(sSNo == null) sSNo = "";
	if(sFlag == null) sFlag = ""; 

	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "StoreProductList";//ģ�ͱ��StoreProductList
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled=true;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(30);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		//  ����  ����  �ر�  ��ʱ�ر�  ȡ���ر�
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
		{"true","","Button","����Ӷ������","����Ӷ������","commissionFeeSet()",sResourcesPath},
		{"true","","Button","��������","��������","batchImport()",sResourcesPath},
	};
	
	//add CCS-884 �ر�״̬���ر��水ť tangyb 20150720
	if("06".equals(sStatus)){
		sButtons[0][0]="false";
		sButtons[2][0]="false";
		sButtons[3][0]="false";
		sButtons[4][0]="false";
	}
	if("CountAndCheck".equals(sFlag)){
		sButtons[0][0] ="false";
		sButtons[1][0] ="false";
		sButtons[2][0] ="false";
		sButtons[3][0] ="false";
		sButtons[4][0] ="false";	
	}	
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	function batchImport() {
		
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0) {
			// ����Excel�� alert("��ѡ���ļ���");
			return;
		}
		
		RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "dataImport", "filePath="+sFilePath);
	}

	function commissionFeeSet() {
		
		var sSerialNoS = getItemValueArray(0,"SERIALNO");
		var sSerialNo = sSerialNoS[0];
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.PopView("/BusinessManage/StoreManage/FeeCommissionInfo.jsp", "SerialNo="+sSerialNo+"&SerialNoS="+sSerialNoS, "dialogWidth=360px;dialogHeight=320px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}

	function newRecord(){
		AsControl.OpenView("/BusinessManage/StoreManage/ProductInfo.jsp","SSerialNo=<%=sSSerialNo %>&SNo=<%=sSNo%>","_self","");
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
		reloadSelf();
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0, getRow(), "SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/BusinessManage/StoreManage/ProductInfo.jsp","SerialNo="+sSerialNo+"&SSerialNo=<%=sSSerialNo %>&ActionType=<%=CommonConstans.VIEW_DETAIL%>&Status=<%=sStatus %>","_blank","");
		reloadSelf();
	}
	
	<%/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/%>
	function openWithObjectViewer(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.OpenObject("Example",sExampleId,"001");//ʹ��ObjectViewer����ͼ001��Example��
	}

	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>