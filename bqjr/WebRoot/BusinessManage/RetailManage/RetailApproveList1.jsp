<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "������׼������";
	//���ҳ�����
	String sType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("type"));
	if(sType==null) sType="";
	System.out.println("----------------------"+sType);
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "RetailApplyModel2";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
  
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
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
			{"true","All","Button","����","����","importRetailInfo()","","","","btn_icon_delete",""},
			{"true","All","Button","����","����","UndoRetailInfo()","","","","btn_icon_delete",""},
			{"true","","Button","����","����","ViewDetail()","","","","btn_icon_detail",""},
		
		};
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function exportRetailInfo(){
		amarExport("myiframe0");
	}
	
	//-- add by ������鹦�� tangyb 20151223 --//
	function ViewDetail(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sRegCode=getItemValue(0,getRow(),"REGCODE");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/BusinessManage/RetailManage/RetailInfoDetail.jsp","SerialNo="+sSerialNo+"&RegCode="+sRegCode+"&PhaseType=<%=sType%>","_blank");
	
	}
	//-- end --//
	
	function importRetailInfo(){
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0) {
			// ����Excel�� alert("��ѡ���ļ���");
			return;
		}
		
		var retal=RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "dataImportSafApproveRetail", "filePath="+sFilePath+",userid="+"<%=CurUser.getUserID()%>"+",orgid="+"<%=CurUser.getOrgID()%>"+",inputdate="+"<%=StringFunction.getTodayNow()%>");
		var sReturn = "";
		var sReturnNo = "";
		if(retal!=null||retal!=""){
			sReturn = retal.split("@")[0];
			sReturnNo = retal.split("@")[1];
		}
		if(sReturn=="error"){
			alert("����ʧ�ܣ�");
			return;
		}
		
		var rt = RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateRetailRno", "selectRnoIsBuild", "AllSerialNo="+sReturnNo);
		
		if(rt == "S"){
			alert("����ɹ���");
		}else{
			alert("����ʧ�ܣ�");
		}
		
		reloadSelf();
	}
	
	//-- add by ��ӳ������� tangyb 20151223 --//
	function UndoRetailInfo(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		var sAgreementApproveStatus = RunMethod("���÷���", "GetColValue", "Retail_info,AgreementApproveStatus,serialno='"+sSerialNo+"'");
	    var sSafDepApproveStatus = RunMethod("���÷���", "GetColValue", "Retail_info,SafDepApproveStatus,serialno='"+sSerialNo+"'");
	    if((sAgreementApproveStatus=="1" || sSafDepApproveStatus=="2")||(sAgreementApproveStatus=="2" || sSafDepApproveStatus=="1")){
	    	alert("��ȫ�������Э�������������ܳ�����");
	    }else if(sAgreementApproveStatus=="4" &&sSafDepApproveStatus=="4"){
	    	RunMethod("PublicMethod","UpdateColValue","String@PrimaryApproveStatus@4@String@PrimaryApproveTime@None,retail_info,String@serialno@"+sSerialNo);
	    	RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateRetailRno", "selectRnoIsBuild", "SerialNo="+sSerialNo);
	    	alert("�����ɹ�");
	    }
	    reloadSelf();
	}
	//-- end --//

	function PrimaryApprove(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sRegCode = getItemValue(0,getRow(),"REGCODE");
	    var sAgreementApproveStatus = getItemValue(0,getRow(),"AgreementApproveStatus");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		if(sAgreementApproveStatus=="1" ){
			alert("���̻�����ˣ���������");
			return;
		}
		AsControl.OpenView("/BusinessManage/RetailManage/RetailInfoDetail1.jsp","SerialNo="+sSerialNo+"&RegCode="+sRegCode,"_blank");
		
		reloadSelf();
	}
	
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
