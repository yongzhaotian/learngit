<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "�ŵ����������";
	//���ҳ�����
	String sType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("type"));
	if(sType==null) sType="";
	System.out.println("----------------------"+sType);
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "StoreApproveList2";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//05��ͨ��
	if("05".equals(sType)){
		PG_TITLE = "�ŵ겻ͨ������";
		doTemp.WhereClause=" WHERE (SI.primaryapprovestatus = '2' or SI.agreementapprovestatus = '2' or SI.safdepapprovestatus = '2') ";  // add by tangyb CCS-992
	} else {
		doTemp.WhereClause=" WHERE (((to_date(to_char(SYSDATE, 'yyyy-MM-dd hh24:mi:ss'), 'yyyy-MM-dd hh24:mi:ss') - to_date(SI.safdepapprovetime, 'yyyy-MM-dd hh24:mi:ss')) <= 3) OR"+
			  	" ((to_date(to_char(SYSDATE, 'yyyy-MM-dd hh24:mi:ss'), 'yyyy-MM-dd hh24:mi:ss') - to_date(SI.agreementapprovetime, 'yyyy-MM-dd hh24:mi:ss')) <= 3))"+
				" AND SI.primaryapprovestatus = '1' AND SI.agreementapprovestatus = '1' AND SI.safdepapprovestatus = '1' ";  // add by tangyb CCS-992
	}
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6����ݼ�	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"false","","Button","Э�����","Э�����","PrimaryApprove()","","","","btn_icon_detail",""},
			{"false","All","Button","����","����","exportRetailInfo()","","","","btn_icon_delete",""},
			{"false","All","Button","����","����","importStoreInfo()","","","","btn_icon_delete",""},
			{"true","","Button","����","����","ViewDetail()","","","","btn_icon_detail",""}, //add by tangyb CCS-992
		};
	
	if("05".equals(sType)){
		sButtons[0][0]="true";
		sButtons[1][0]="true";
		sButtons[2][0]="true";
	}
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.PopView("/BusinessManage/RetailManage/RetailApplyInfo.jsp", "", "");

	}
	
	//-- add by tangyb ������鹦�� 20151224 --//
	function ViewDetail(){
	    	var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
	    	var sRegCode = getItemValue(0,getRow(),"REGCODE");
	    	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
	    		alert("��ѡ��һ����¼��");
	    		return;
	    	}

	    	AsControl.OpenView("/BusinessManage/RetailManage/StoreInfoDetail.jsp","SerialNo="+sSerialNo+"&RegCode="+sRegCode+"&PhaseType=<%=sType%>","_blank");
	    	reloadSelf();
    	
	}
	//-- end --//
	
	//-- add by tangyb ��ӵ������� 20151224 --//
	function exportRetailInfo(){
		amarExport("myiframe0");
		reloadSelf();
	}
	//-- end --//
	
	//-- add by tangyb ��ӵ��빦�� 20151224 --//
	function importStoreInfo(){
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0) {
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

		reloadSelf();
	}
	//-- end --//

	//-- add by tangyb ���Э����˹��� 20151224 --//
	function PrimaryApprove() {
		var sRSerialNo = getItemValue(0, getRow(),"RSERIALNO");
		var sSerialNo = getItemValue(0, getRow(),"SERIALNO");
		var sRegCode = getItemValue(0, getRow(),"REGCODE");
		var sPrimaryapprovestatus = getItemValue(0, getRow(),"PRIMARYAPPROVESTATUS");
		
		//alert("sRSerialNo="+sRSerialNo+",sSerialNo="+sSerialNo+",sRegCode="+sRegCode+",sPrimaryapprovestatus="+sPrimaryapprovestatus);
		
		if (typeof (sSerialNo) == "undefined" || sSerialNo.length == 0) {
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(!sPrimaryapprovestatus == "ͨ��"){
			alert("��ѡ��ļ�¼����δͨ������Э�����");
			return;
		}
		
		AsControl.OpenView("/BusinessManage/RetailManage/StoreInfoDetail1.jsp", "SerialNo=" + sSerialNo + "&RegCode1=" + sRegCode, "_blank");

		reloadSelf();
	}
	//-- end --//
	
	function doSubmit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		RunMethod("���÷���", "UpdateColValue", "Retail_Info,Status,02,SerialNo='"+sSerialNo+"'");
		reloadSelf();
	}
    
	function initRow(){
					
		
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
