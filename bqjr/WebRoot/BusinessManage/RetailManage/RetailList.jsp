<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
	//���ҳ�����
	String sModify =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Modify"));
	if(sModify == null) sModify = "";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "RetailList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		//  ����  ����  �ر�  ��ʱ�ر�  ȡ���ر�
		{"false","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����鿴","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","����","����","activeRetail()",sResourcesPath},
		{"true","","Button","�ر�","�ر�","closeRetail()",sResourcesPath},
		{"true","","Button","��ʱ�ر�","��ʱ�ر�","amomentCloseRetail()",sResourcesPath},
		{"true","","Button","ȡ���ر�","ȡ���ر�","cancelCloseRetail()",sResourcesPath},
		{"true","","Button","excel�̻�����","excel�̻�����","ExcelImport()",sResourcesPath},
		{"true","","Button","excel֧�д��뵼��","excel֧�д��뵼��","ExcelImportBank()",sResourcesPath},
		{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","����EXCEL","����EXCEL","exportExcel()",sResourcesPath},

	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	//Excel����������	
	function exportExcel(){
		amarExport("myiframe0");
	}

	<%/*~[Describe=ȡ���ر�������;InputParam=��;OutPutParam=��;] added by tbzeng 2014/02/26~*/%>
	function cancelCloseRetail() {
		openColseDate="<%=DateX.format(new java.util.Date(), "yyyy/MM/dd HH:mm:ss")%>";
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		//����״̬Ϊ�رջ���ʱ�رյ������̣�ͨ��ȡ���رտɽ�״̬����Ϊ����;
		//ȡ���ر�������ʱ�����µ��ŵ�״̬�������Զ����£����ֹ������ŵ�״̬���޸ġ�
		var sStatus = getItemValue(0, getRow(), "STATUS");
		if (sStatus=="07") {
			var tipVal = "ȷ��Ҫȡ���ر������̣�" + getItemValue(0, getRow(), "RNAME");
			if (confirm(tipVal)) {
				sReturn = RunMethod("���÷���","UpdateColValue","Retail_Info,Status,05,SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
					alert("ȡ���ر�������ʧ�ܣ�");
					return;			
				}else{
					RunMethod("���÷���","UpdateColValue","Retail_Info,openColseName,<%=CurUser.getUserID()%>, SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
					RunMethod("ModifyNumber","GetModifyNumber","Retail_Info,openColseDate='"+openColseDate+"',SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				}
				reloadSelf();
			}
		} else {
			alert("��ʱ�ر�״̬�����̲�����ȡ���رգ�");
			return;
		}
	}

	<%/*~[Describe=��ʱ�ر�������;InputParam=��;OutPutParam=��;] added by tbzeng 2014/02/26~*/%>
	function amomentCloseRetail() {
		openColseDate="<%=DateX.format(new java.util.Date(), "yyyy/MM/dd HH:mm:ss")%>";
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		//����״̬Ϊ����������̣��ɽ�����ʱ�رա������̹رջ���ʱ�ر�ʱ�����������ŵ����йرջ���ʱ�رա�
		var sStatus = getItemValue(0, getRow(), "STATUS");
		if (sStatus == "05") {
			var tipVal = "��ȷ��Ҫ��ʱ�ر������̣�" + getItemValue(0, getRow(), "RNAME");
			if (confirm(tipVal)) {
				sReturn = RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "temporayCloseRetail", "serialNo="+getItemValue(0, 0, "SERIALNO"));
				if(sReturn == "Fail") {				
					alert("��ʱ�ر�������ʧ�ܣ�");
					return;			
				}else{
					RunMethod("���÷���","UpdateColValue","Retail_Info,openColseName,<%=CurUser.getUserID()%>, SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
					RunMethod("ModifyNumber","GetModifyNumber","Retail_Info,openColseDate='"+openColseDate+"',SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				}
				reloadSelf();
			}
		} else {
			alert("����״̬�����̲�������ʱ�رգ�");
			return;
		}
	}

	<%/*~[Describe=�ر�������;InputParam=��;OutPutParam=��;] added by tbzeng 2014/02/26~*/%>
	function closeRetail() {
		openColseDate="<%=DateX.format(new java.util.Date(), "yyyy/MM/dd HH:mm:ss")%>";
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		//����״̬Ϊ�������ʱ�رյ������̣��ɽ���رա�����״̬������;
		var sStatus = getItemValue(0, getRow(), "STATUS");
		if (sStatus=="05" || sStatus=="07") {
			var tipVal = "ȷ��Ҫ�ر������̣�" + getItemValue(0, getRow(), "RNAME");
			if (confirm(tipVal)) {

				var sReturn = RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "closeRetail", "serialNo="+getItemValue(0, 0, "SERIALNO"));

				if(sReturn == "Fail") {				
					alert("�ر�������ʧ�ܣ�");
					return;			
				}else{
					RunMethod("���÷���","UpdateColValue","Retail_Info,openColseName,<%=CurUser.getUserID()%>, SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
					RunMethod("ModifyNumber","GetModifyNumber","Retail_Info,openColseDate='"+openColseDate+"',SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				}
				reloadSelf();
			}
		} else {
			alert("�������ʱ�ر�״̬�����̲�����رգ�");
			return;
		}
	}

	<%/*~[Describe=����������;InputParam=��;OutPutParam=��;] added by tbzeng 2014/02/26~*/%>
	function activeRetail() {
		openColseDate="<%=DateX.format(new java.util.Date(), "yyyy/MM/dd HH:mm:ss")%>";
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		var sStatus = getItemValue(0, getRow(), "STATUS");
		if (sStatus == "03") {
			var tipVal = "��ȷ��Ҫ����������\n"+"�����̱�ţ�" + getItemValue(0, getRow(), "RNO")+"\n���ƣ�" + getItemValue(0, getRow(), "RNAME");
			if (confirm(tipVal)) {
				sReturn = RunMethod("���÷���","UpdateColValue","Retail_Info,Status,05, SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
					alert("�����̼���ʧ�ܣ�");
					return;			
				}else{
					RunMethod("���÷���","UpdateColValue","Retail_Info,openColseName,<%=CurUser.getUserID()%>, SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
					RunMethod("ModifyNumber","GetModifyNumber","Retail_Info,openColseDate='"+openColseDate+"',SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				}
			}
			reloadSelf();
		}else {
			alert("׼��״̬�����̲������");
			return;
		}
	}

	function newRecord(){
		AsControl.OpenView("/FrameCase/ExampleInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/BusinessManage/RetailManage/RetailInfoTab.jsp","RSerialNo="+sSerialNo+"&Modify=<%=sModify%>","_blank","");
		reloadSelf();
	}
	
	
	//excel����
	function ExcelImport(){
		
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0) {
			// ����Excel�� alert("��ѡ���ļ���");
			return;
		}
		
		RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "dataImportRetailInfo", "filePath="+sFilePath+",userid="+"<%=CurUser.getUserID()%>"+",orgid="+"<%=CurUser.getOrgID()%>"+",inputdate="+"<%=StringFunction.getTodayNow()%>");
		
		//RunMethod("BlackListModel","delAddressMulti","");
		reloadSelf();
		
		
		
	}
	
	function ExcelImportBank(){
		
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0) {
			// ����Excel�� alert("��ѡ���ļ���");
			return;
		}
		
		RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "dataImportBankInfo", "filePath="+sFilePath+",userid="+"<%=CurUser.getUserID()%>"+",orgid="+"<%=CurUser.getOrgID()%>"+",inputdate="+"<%=StringFunction.getTodayNow()%>");
		
		//RunMethod("BlackListModel","delAddressMulti","");
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