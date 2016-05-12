<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	//���ҳ�����
	String sType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("type"));
	if(sType==null) sType="";
	System.out.println("----------------------"+sType);
	
	String PG_TITLE = "���������������";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "RetailApplyModel";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//05��ͨ��
	if("05".equals(sType)){
		PG_TITLE = "�����̲�ͨ������";
		doTemp.WhereClause=" WHERE (primaryapprovestatus = '2' OR agreementapprovestatus = '2' OR safdepapprovestatus = '2') ";
	}else{
		doTemp.WhereClause=" WHERE (((to_date(to_char(SYSDATE, 'yyyy-MM-dd hh24:mi:ss'), 'yyyy-MM-dd hh24:mi:ss') - to_date(safdepapprovetime, 'yyyy-MM-dd hh24:mi:ss')) <= 3) OR"+
				  " ((to_date(to_char(SYSDATE, 'yyyy-MM-dd hh24:mi:ss'), 'yyyy-MM-dd hh24:mi:ss') - to_date(agreementapprovetime, 'yyyy-MM-dd hh24:mi:ss')) <= 3))"+
					  " AND primaryapprovestatus = '1' AND agreementapprovestatus = '1' AND safdepapprovestatus = '1' ";
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
			{"false","All","Button","����","����","importRetailInfo()","","","","btn_icon_delete",""},
			{"true","","Button","����","����","ViewDetail()","","","","btn_icon_detail",""},
		};
	
	if("05".equals(sType)){
		sButtons[0][0]="true";
		sButtons[1][0]="true";
		sButtons[2][0]="true";
	}
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	//-- add by ��ӵ������� tangyb 20151223 --//
	function exportRetailInfo(){
		amarExport("myiframe0");
	}
	//-- end --//
	
	function newRecord(){
		AsControl.PopView("/BusinessManage/RetailManage/RetailApplyInfo.jsp", "", "");
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
	}
	
	//-- add by tangyb Э�����  20151230 --//
	function PrimaryApprove(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sRegCode = getItemValue(0,getRow(),"REGCODE");
		var primaryapprovestatus = getItemValue(0,getRow(),"PrimaryApproveStatus");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(!primaryapprovestatus == "ͨ��"){
			alert("��ѡ��ļ�¼����δͨ������Э�����");
			return;
		}
		
		AsControl.OpenView("/BusinessManage/RetailManage/RetailInfoDetail1.jsp","SerialNo="+sSerialNo+"&RegCode="+sRegCode,"_blank");
		
		reloadSelf();
	}
	//-- end --//
	
	//-- add by tangyb ��ȫ��˵���  20151230 --//
	function importRetailInfo(){
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0) {
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
