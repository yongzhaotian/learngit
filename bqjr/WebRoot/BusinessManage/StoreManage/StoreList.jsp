<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
	//���ҳ�����
	String sModify= DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Modify"));
	if(sModify==null) sModify="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "StoreList1";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.WhereClause = " where SI.Status not in ('01','02','04')";

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
		{"true","","Button","����","����","activeStore()",sResourcesPath},
		{"false","","Button","������Ʒ","������Ʒ","relativeProduct()",sResourcesPath},
		{"false","","Button","�ƽ�","�ƽ�����һ�ͻ�����","handOver()",sResourcesPath},
		{"true","","Button","����ŵ�","������ŵ�󶨵�����","unbandSalesman()",sResourcesPath},
		{"true","","Button","����¼ ","����¼","history()",sResourcesPath},
		{"false","","Button","�������о���","�������о���","updateCityManager()",sResourcesPath},
		{"true","","Button","�ŵ겿��ת�� ","�ŵ겿��ת��","updateOther()",sResourcesPath},
		{"true","","Button","�ŵ�����ת�� ","�ŵ�����ת��","updateAll()",sResourcesPath},
		{"true","","Button","�ر�","�ر�","closeStore()",sResourcesPath},
		
		// ����ԭ������ʱ�رչ��� update by huzp 20150428
		{"true","","Button","��ʱ�ر�","��ʱ�ر�","amomentCloseStore()",sResourcesPath},
		//{"true","","Button","��عر�","��عر�","amomentCloseStore2()",sResourcesPath},
		
		{"true","","Button","ȡ����ʱ�ر�","ȡ����ʱ�ر�","cancelCloseStore()",sResourcesPath},
		//by chengwenhao 
		//CCS-1290
		//�ŵ�����б�����м�����ť�ò�����Ҫ����
		{"false","","Button","excel���� ","excel����","ExcelImport()",sResourcesPath}, 
		{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","����EXCEL","����EXCEL","exportExcel()",sResourcesPath},
		
	};
	
	//���ڿ��Ƶ��а�ť��ʾ��������  add by Dahl 20150318
	String iButtonsLineMax = "12";
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);
			
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	//Excel����������	
	function exportExcel(){
		amarExport("myiframe0");
	}

	/* ������ŵ�󶨵����� */
	function unbandSalesman() {
		
		var vWhereClause = "<%=doTemp.WhereClause%>";
		var vSalesNo = document.getElementById("DF7_1_INPUT").value;
		var vSalesName = document.getElementById("DF8_1_INPUT").value;
		var vSerialNo = getItemValue(0,getRow(),"SNO");
		var vSname = getItemValue(0,getRow(),"SNAME");
		
		var sStatus = getItemValue(0, getRow(), "STATUS"); //�ŵ�״̬
		if(sStatus == "06"){ //�ر�״̬
			alert("�ŵ괦�ڹر�״̬�����������ŵ� ");
			return;
		}
		
		AsControl.OpenView("/BusinessManage/StoreManage/StoreUserUnbandList.jsp","","_self","");
		
		return;

		var vQuery = vSalesNo;
		if (vSalesName!="" && vSalesNo=="") {
			vQuery = vSalesName;
			var icnt = RunMethod("���÷���", "GetColValue", "user_info,count(userid),username='"+vQuery+"'");
			if (icnt > 1) {
				alert("�����ŵ����飬�ŵ���������н��");
				return;
			}

		}
		
		if (vQuery ==  "") {
			alert("���������۱�Ż����Ʋ�ѯ���ŵ꣡");
			return;
		}
		
		if (vWhereClause.indexOf(vQuery)<0) {
			alert("���Ȳ�ѯ��");
			return;
		}
		
		if (typeof(vSerialNo)=="undefined" || vSerialNo.length==0){
			alert("��ѡ��һ���ŵ���н��");
			return;
		}
		
		if (vSalesName!="" && vSalesNo=="") {
			vQuery = RunMethod("���÷���", "GetColValue", "user_info,userid,username='"+vQuery+"'"); 
		}
		
		if (confirm("ȷ��Ҫ����󶨣��ŵ꣺"+vSname+"�����۱�ţ�"+RunMethod("���÷���", "GetColValue", "user_info,username,userid='"+vQuery+"'"))){
			RunMethod("���÷���", "DelByWhereClause", "storerelativesalesman,sno='"+vSerialNo+"' and salesmanno='"+vQuery+"'");
			RunMethod("���÷���", "UpdateColValue", "user_info,superid,,userid='"+vQuery+"'");
		}

		reloadSelf();
	}

	function handOver() {
		AsControl.PopView("/BusinessManage/StoreManage/test.jsp", "", "");
	}

	<%/*~[Describe=������Ʒ;InputParam=��;OutPutParam=��;] added by tbzeng 2014/02/26~*/%>
	function relativeProduct() {
		var sStatus = getItemValue(0, getRow(), "STATUS"); //�ŵ�״̬
		if(sStatus == "06"){ //�ر�״̬
			alert("�ŵ괦�ڹر�״̬�������������Ʒ ");
			return;
		}
		
		var sRetVal = AsControl.PopView("/BusinessManage/StoreManage/StoreProductDoubleSelect.jsp", "", "dialogWidth:1080px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no");
		var sProductCategorys = sRetVal.split("~")[0];
		var sStores = sRetVal.split("~")[1];
		
		if (typeof(sRetVal)=='undefined' || (sProductCategorys.length==0 || sStores.length==0)) {
			alert("��ѡ���ŵ�Ͳ�Ʒ���룡");
			return;
		}
		sProductCategorys = sProductCategorys.substring(0, sProductCategorys.length-1);
		sStores = sStores.substring(0, sStores.length-1);
		/* alert(sStores);
		alert(sProductCategorys);
		return; */
		// ִ��java�������в���
		RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "getStoreRelativeProductMulti", "serialNo="+sProductCategorys+",objectNo="+sStores+",retailNo=<%=CurUser.getUserID()%>");
		reloadSelf();
	}

	<%/*~[Describe=ȡ���ر�������;InputParam=��;OutPutParam=��;] added by tbzeng 2014/02/26~*/%>
	function cancelCloseStore() {
		openColseDate="<%=DateX.format(new java.util.Date(), "yyyy/MM/dd HH:mm:ss")%>";
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		var sStatus = getItemValue(0, getRow(), "STATUS");
		//�����sStatus=��08����״̬�жϣ�add huzp 20150423(�����ѳ���20150428)
		//if (sStatus=="07"||sStatus=="08") {
		if (sStatus=="07") {
			var tipVal = "ȷ��Ҫȡ���ر�\n�ŵ����ƣ�" + getItemValue(0, getRow(), "SNAME");
			if (confirm(tipVal)) {
				
				// ����̻�״̬Ϊ��ʱ�رգ�������ر�
				var sStoreStatus = RunMethod("���÷���", "GetColValue", "Retail_Info,Status,SerialNo=(select RSerialNo from Store_Info where SerialNo='"+sSerialNo+"')");
				if (sStoreStatus == "07") {
					alert("�̻�״̬Ϊ��ʱ�ر�ʱ����������йرղ�����");
					return;
				}
				//����˷�ذ�ť�¼� add huzp 20150423(�����ѳ���20150428)
				/*
				if (sStoreStatus == "08") {
					alert("�̻�״̬Ϊ��عر�ʱ����������йرղ�����");
					return;
				}
				*/
				
				sReturn = RunMethod("���÷���","UpdateColValue","Store_Info,Status,05,SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
					alert("ȡ���ر��ŵ�ʧ�ܣ�");
					return;			
				}else{
					RunMethod("���÷���","UpdateColValue","Store_Info,openColseName,<%=CurUser.getUserID()%>, SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
					RunMethod("ModifyNumber","GetModifyNumber","Store_Info,openColseDate='"+openColseDate+"',SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				}
				reloadSelf();
			}
		} else {
			alert("��ʱ�ر�״̬�ŵ������ȡ���رգ�");
			return;
		}
	}

	<%/*~[Describe=��ʱ�ر�������;InputParam=��;OutPutParam=��;] added by tbzeng 2014/02/26~*/%>
	function amomentCloseStore() {
		openColseDate="<%=DateX.format(new java.util.Date(), "yyyy/MM/dd HH:mm:ss")%>";
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		var sStatus = getItemValue(0, getRow(), "STATUS");
		if (sStatus == "05") {
			
			var tipVal = "ȷ��Ҫ��ʱ�ر�\n�ŵ����ƣ�" + getItemValue(0, getRow(), "SNAME");
			if (confirm(tipVal)) {
				sReturn = RunMethod("���÷���","UpdateColValue","Store_Info,Status,07,SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
					alert("�ŵ���ʱ�ر�ʧ�ܣ�");
					return;			
				}else{
					RunMethod("���÷���","UpdateColValue","Store_Info,openColseName,<%=CurUser.getUserID()%>, SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
					RunMethod("ModifyNumber","GetModifyNumber","Store_Info,openColseDate='"+openColseDate+"',SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				}
				reloadSelf();
			}
		} else {
			alert("����״̬�ŵ��������ʱ�رգ�");
			return;
		}
	}
	
	//��дԭ����ʱ�رպ�����Ϊ��عر� add huzp 20150424 ���˹����ѳ��� 20150428��
	function amomentCloseStore2() {
		openColseDate="<%=DateX.format(new java.util.Date(), "yyyy/MM/dd HH:mm:ss")%>";
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		var sStatus = getItemValue(0, getRow(), "STATUS");
		if (sStatus == "05") {
			var tipVal = "ȷ��Ҫ��عر�\n�ŵ����ƣ�" + getItemValue(0, getRow(), "SNAME");
			if (confirm(tipVal)) {
				sReturn = RunMethod("���÷���","UpdateColValue","Store_Info,Status,08,SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
					alert("�ŵ��عر�ʧ�ܣ�");
					return;			
				}else{
					RunMethod("���÷���","UpdateColValue","Store_Info,openColseName,<%=CurUser.getUserID()%>, SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
					RunMethod("ModifyNumber","GetModifyNumber","Store_Info,openColseDate='"+openColseDate+"',SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				}
				reloadSelf();
			}
		} else {
			alert("����״̬�ŵ�������عرգ�");
			return;
		}
	}

	<%/*~[Describe=�ر�������;InputParam=��;OutPutParam=��;] added by tbzeng 2014/02/26~*/%>
	function closeStore() {
		openColseDate="<%=DateX.format(new java.util.Date(), "yyyy/MM/dd HH:mm:ss")%>";
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		//����״̬Ϊ�������ʱ�رյ������̣��ɽ���رա�����״̬������;
		var sStatus = getItemValue(0, getRow(), "STATUS");
		
		// ���sStatus=="08" ״̬  add huzp 20150423���˹����ѳ���20150428��
		//if (sStatus=="07" ||sStatus=="08" || sStatus=="05" || sStatus=="03") {
		   if (sStatus=="07" || sStatus=="05" || sStatus=="03") {
			
			var tipVal = "��ȷ��Ҫ�ر��ŵ꣺" + getItemValue(0, getRow(), "SNAME");
			if (confirm(tipVal)) {
				var userId='<%=CurUser.getUserID()%>'; //�޸���
				var orgid = "<%=CurOrg.orgID%>"; //�������
				//alert("serialNo="+getItemValue(0, 0, "SERIALNO")+",retailNo="+getItemValue(0, 0, "RSERIALNO"));
				var sReturn = RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "closeStore", "serialNo="+getItemValue(0, getRow(), "SERIALNO")+",retailNo="+getItemValue(0, getRow(), "RSERIALNO")+ ",userId=" + userId + ",orgid=" + orgid);
				if(sReturn == "Fail") {				
					alert("�ŵ�ر�ʧ�ܣ�");
					return;			
				}else{
					RunMethod("���÷���","UpdateColValue","Store_Info,openColseName,<%=CurUser.getUserID()%>, SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
					RunMethod("ModifyNumber","GetModifyNumber","Store_Info,openColseDate='"+openColseDate+"',SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				}
				reloadSelf();
			}
		} else {
			alert("ֻ���ŵ�Ϊ׼�롢�������ʱ�ر�״̬��������йرղ�����");
			return;
		}
	}

	<%/*~[Describe=����������;InputParam=��;OutPutParam=��;] added by tbzeng 2014/02/26~*/%>
	function activeStore() {
		openColseDate="<%=DateX.format(new java.util.Date(), "yyyy/MM/dd HH:mm:ss")%>";
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		/*add CCS-884 �ŵ�״ֻ̬��ת��״̬�������� tangyb 20150720 start
		var sRetailStatus = RunMethod("���÷���", "GetColValue", "RETAIL_INFO,STATUS, SERIALNO=(SELECT RSERIALNO FROM STORE_INFO WHERE SERIALNO='"+sSerialNo+"')");
		if (sRetailStatus !== "05") {
			alert("���ȼ����̻���");
			return;
		}*/
		var sno = getItemValue(0, getRow(), "SNO"); //�ŵ����
		var sStatus = getItemValue(0, getRow(), "STATUS"); //�ŵ�״̬
		if (sStatus == "03") { //׼��״̬
			var tipVal = "ȷ��Ҫ�����ŵ꣺" + getItemValue(0, getRow(), "SNAME");
			if (confirm(tipVal)) {
				//-- update CCS-884 �ŵ�����Ż� tangyanbo 20150720 start --//
				//У������ֶ��Ƿ�Ϊ��
				var errorMes = RunJavaMethodSqlca("com.amarsoft.app.billions.StoreInfo", "queryStoreKeyInfoIsNull", "serialno="+sSerialNo);
				if(errorMes != ""){
					alert(errorMes);
					return;
				}
				
				var sRetailStatus = RunMethod("���÷���", "GetColValue", "RETAIL_INFO,STATUS, SERIALNO=(SELECT RSERIALNO FROM STORE_INFO WHERE SERIALNO='"+sSerialNo+"')");
				if (sRetailStatus !== "05") {
					alert("���ȼ����̻���");
					return;
				}
				
				//У���Ƿ������Ʒ
				var ccount = RunMethod("���÷���", "GetColValue", "storerelativeproduct,count(1),sno='"+sno+"'"); 
				if (typeof(ccount) == "undefined" || parseInt(ccount) == 0) {
					alert("���ȹ�����Ʒ��");
					return;
				}
				
				//У���Ƿ����������Ա
				var xcount = RunMethod("���÷���", "GetColValue", "storerelativesalesman,count(1),sno='"+sno+"' and stype is null"); 
				if (typeof(xcount) == "undefined" || parseInt(xcount) == 0) {
					alert("���ȹ���������Ա��");
					return;
				}
				//-- end --//
				
				sReturn = RunMethod("���÷���","UpdateColValue","Store_Info,Status,05,SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
					alert("�����ŵ�ʧ�ܣ�");
					return;			
				}else{
					RunMethod("���÷���","UpdateColValue","Store_Info,openColseName,<%=CurUser.getUserID()%>, SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
					RunMethod("ModifyNumber","GetModifyNumber","Store_Info,openColseDate='"+openColseDate+"',SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				}
			}
			reloadSelf();
		} else if (sStatus == "05") {
			alert("�ŵ��Ѿ������");
			return;
		}else {
			alert("׼��״̬�ŵ�������");
			return;
		}
	}

	<%/*~[Describe=�ŵ���Ϣ�鿴;InputParam=��;OutPutParam=��;] added by tbzeng 2014/02/20~*/%>
	function viewReservCustomerInfo(){
		
		AsControl.OpenView("/CustomService/BusinessConsult/ReservConsultInfo.jsp","CustomerType=Customer","_blank","");
	}
	
	<%/*~[Describe=�ͻ�ԤԼ;InputParam=��;OutPutParam=��;] added by tbzeng 2014/02/20~*/%>
	function viewReservCommercialInfo(){
		
		AsControl.OpenView("/CustomService/BusinessConsult/ReservConsultInfo.jsp","CustomerType=Commercial","_blank","");
	}
	
	<%/*~[Describe=�̻�ԤԼ;InputParam=��;OutPutParam=��;] added by tbzeng 2014/02/20~*/%>
	function viewStoreInfo(){
		var sSerialNo = getItemValue(0,getRow(),"SERILNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		//alert(1);
		AsControl.OpenView("/BusinessManage/StoreManage/StoreInfo.jsp","SNo="+sSNo,"_self","");
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
	
	//�鿴��ʷ��¼ 
	function history(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sSNO = getItemValue(0,getRow(),"SNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.OpenView("/BusinessManage/StoreManage/StoreUserHistoryList.jsp","SNO="+sSNO,"_self","");
	}
	
	//���ĳ��о���
	function updateCityManager(){
		var sStatus = getItemValue(0, getRow(), "STATUS"); //�ŵ�״̬
		if(sStatus == "06"){ //�ر�״̬
			alert("�ŵ괦�ڹر�״̬����������ĳ��о���");
			return;
		}

		sCompID = "UpdateSalesManagerSuper";
		sCompURL = "/BusinessManage/StoreManage/UpdateSalesManagerSuper.jsp";
	    popComp(sCompID,sCompURL,"","dialogWidth=400px;dialogHeight=300px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();	
	}
    
	//�ŵ�����ת��
	function updateAll(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sSNO = getItemValue(0,getRow(),"SNO");
		var sCity = getItemValue(0,getRow(),"CITY"); 
		
		var sStatus = getItemValue(0, getRow(), "STATUS"); //�ŵ�״̬
		if(sStatus == "06"){ //�ر�״̬
			alert("�ŵ괦�ڹر�״̬������������ת��");
			return;
		}
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		sCompID = "UpdateAllManager";
		sCompURL = "/BusinessManage/StoreManage/UpdateAllManager.jsp";
	    popComp(sCompID,sCompURL,"City="+sCity+"&SNO="+sSNO,"dialogWidth=400px;dialogHeight=300px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();	
	}
	
	//�ŵ겿��ת�� 
	function updateOther(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sSNO = getItemValue(0,getRow(),"SNO");
		var sCity = getItemValue(0,getRow(),"CITY");
		var oldSalesManager = getItemValue(0,getRow(),"SALESMANAGER");
		
		var sStatus = getItemValue(0, getRow(), "STATUS"); //�ŵ�״̬
		if(sStatus == "06"){ //�ر�״̬
			alert("�ŵ괦�ڹر�״̬����������ת�� ");
			return;
		}
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
//		sCompID = "UpdateOtherManager";
//		sCompURL = "/BusinessManage/StoreManage/UpdateOtherManager1.jsp";
//	    popComp(sCompID,sCompURL,"City="+sCity+"&SNO="+sSNO+"&oldSalesManager="+oldSalesManager,"dialogWidth=400px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	   
	    sCompID = "UpdateOtherStoreManager";
		sCompURL = "/BusinessManage/StoreManage/UpdateOtherStoreManager.jsp";
	    popComp(sCompID,sCompURL,"City="+sCity+"&SNO="+sSNO+"&oldSalesManager="+oldSalesManager,"dialogWidth=400px;dialogHeight=300px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();	
	}
	
	function viewAndEdit(){
		var sSSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sSNo = getItemValue(0, getRow(), "SNO");
		var sStatus= getItemValue(0, getRow(), "STATUS");
		if (typeof(sSSerialNo)=="undefined" || sSSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.OpenView("/BusinessManage/StoreManage/StoreInfoTab.jsp","SSerialNo="+sSSerialNo+"&SNo="+sSNo+"&Status="+sStatus+"&Modify=<%=sModify%>","_blank","");
		reloadSelf();
	}
	
	
	//excel����
	function ExcelImport(){
		var sStatus = getItemValue(0, getRow(), "STATUS"); //�ŵ�״̬
		if(sStatus == "06"){ //�ر�״̬
			alert("�ŵ괦�ڹر�״̬��������Excel����");
			return;
		}
		
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0) {
			// ����Excel�� alert("��ѡ���ļ���");
			return;
		}
		
		RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "dataImportStoreInfo", "filePath="+sFilePath+",userid="+"<%=CurUser.getUserID()%>"+",orgid="+"<%=CurUser.getOrgID()%>"+",inputdate="+"<%=StringFunction.getTodayNow()%>");
		
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