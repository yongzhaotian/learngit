<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "�ŵ�׼������";
	//���ҳ�����
	String sType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("type"));
	if(sType==null) sType="";
	System.out.println("----------------------"+sType);
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "StoreApproveList1";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
  
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	doTemp.multiSelectionEnabled=true;
	 doTemp.WhereClause="where  SI.PrimaryApproveTime is not null  and  SI.PrimaryApproveStatus='1' and SI.status='02' "; 
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow	dw
	Vector vTemp = dwTemp.genHTMLDataWindow(sType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6����ݼ�	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			
			{"true","","Button","Э�����","Э�����","PrimaryApprove()","","","","btn_icon_detail",""},
			{"true","All","Button","����","����","exportRetailInfo()","","","","btn_icon_delete",""},
			{"true","All","Button","����","����","importStoreInfo()","","","","btn_icon_delete",""},
			{"true","All","Button","����","����","UndoStoreInfo()","","","","btn_icon_delete",""}, // add by tangyb CCS-992
			{"true","All","Button","����","����","ViewDetail()","","","","btn_icon_detail",""}, // add by tangyb CCS-992
		};
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
    //-- add by ������鹦�� tangyb 20151223 --//
    function ViewDetail(){
    	var sSerialNo = getItemValue(0,getRow(),"SerialNo");
    	var sRegCode=getItemValue(0,getRow(),"REGCODE");
    	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
    		alert("��ѡ��һ����¼��");
    		return;
    	}

    	AsControl.OpenView("/BusinessManage/RetailManage/StoreInfoDetail.jsp","SerialNo="+sSerialNo+"&RegCode="+sRegCode+"&PhaseType=<%=sType%>","_blank");
    	reloadSelf();
    	
    }
    //-- end --//
    
	function exportRetailInfo(){
		amarExport("myiframe0");
		reloadSelf();
	}
	function importStoreInfo(){
	
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0) {
			// ����Excel�� alert("��ѡ���ļ���");
			return;
		}
		
		var retal=RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "dataImportSafApproveStore", "filePath="+sFilePath+",userid="+"<%=CurUser.getUserID()%>"+",orgid="+"<%=CurUser.getOrgID()%>"+",inputdate="+"<%=StringFunction.getTodayNow()%>");
		var sReturn = "";
		var sReturnNo = "";
		if(retal!=null||retal!=" "){
			sReturn = retal.split("@")[0];
			sReturnNo = retal.split("@")[1];
		}
		if(sReturn=="error"){
			alert("����ʧ�ܣ�");
			return;
		}
		
		var rt = RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateRetailRno", "selectSnoIsBuild", "AllSerialNo="+sReturnNo);
		
		if(rt == "S"){
			alert("����ɹ���");
		}else{
			alert("����ʧ�ܣ�");
		}
		
		reloadSelf();
	}

	//-- add by ��ӳ������� tangyb 20151223 --//
	function UndoStoreInfo() {
		var sSeriaslNo = getItemValueArray(0, "SerialNo");
		var sSerialNo = sSeriaslNo[0];
		if (typeof (sSerialNo) == "undefined" || sSerialNo.length == 0) {
			alert("��ѡ��һ����¼��");
			return;
		}

		for (var i = 0; i < sSeriaslNo.length; i++) {
			var sAgreementApproveStatus = RunMethod("���÷���", "GetColValue",
					"Store_info,AGREEMENTAPPROVESTATUS,serialno='" + sSeriaslNo[i] + "'");
			var sSafdePapproveStatus = RunMethod("���÷���", "GetColValue",
					"Store_info,SAFDEPAPPROVESTATUS,serialno='" + sSeriaslNo[i] + "'");
			if ((sAgreementApproveStatus == "1" || sSafdePapproveStatus == "2") || (sAgreementApproveStatus == "2" || sSafdePapproveStatus == "1")) {
				alert(sSeriaslNo[i] + " ��ȫ�������Э�������������ܳ�����");
				return;
			} else if (sAgreementApproveStatus == "4" && sSafdePapproveStatus == "4") {
				RunMethod("PublicMethod", "UpdateColValue", "String@PrimaryApproveStatus@4@String@PrimaryApproveTime@None,store_info,String@serialno@"+ sSeriaslNo[i]);
				RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateRetailRno", "selectSnoIsBuild", "SerialNo=" + sSeriaslNo[i]);
				alert("�����ɹ�");
			}
		}
		reloadSelf();
	}
	//-- end --//

	function PrimaryApprove(){
		//var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sSeriaslNo = getItemValueArray(0,"SerialNo");
		var sRegCode = getItemValueArray(0,"REGCODE");
		var sAgreementApproveStatus = getItemValueArray(0,"AGREEMENTAPPROVESTATUS");
		var sSerialNo=sSeriaslNo[0];
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		for(var i=0;i<sAgreementApproveStatus.length;i++){
			if(sAgreementApproveStatus[i]=="1" ){
				alert(sSeriaslNo[i]+",���ŵ�����ˣ���������");
				return;
			}
		}
		
		AsControl.OpenView("/BusinessManage/RetailManage/StoreInfoDetail1.jsp","SerialNo="+sSeriaslNo+"&RegCode1="+sRegCode,"_blank");

		reloadSelf();
	}

	function initRow() {
		//�����߼��ᵼ����һ�鿨�ٵģ��ֱ��ƶ����ϴ��ŵ�ȷ�Ϻ��������ŵ����鱣�水ť
		/* 
		RunJavaMethodSqlca("com.amarsoft.app.billions.SelectRetailInfo","UpdateStoreConfirLetter","1");
		RunJavaMethodSqlca("com.amarsoft.app.billions.SelectRetailInfo","UpdateStoreEntrustedCollection","1");
		setItemValue(0,0,"STOREMAINCONTRACTPOSITION","�곤");
		 */
	}
	
	$(document).ready(function() {
		AsOne.AsInit();
		init();
		my_load(2, 0, 'myiframe0');
		initRow();

	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
