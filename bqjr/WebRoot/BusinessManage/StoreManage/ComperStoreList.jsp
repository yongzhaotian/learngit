<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
	//���ҳ�����
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	List<String> ls =CurUser.getRoleTable();
	String sTempletNo = "StoreList1";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	for(String i : ls){
		System.out.println("i="+i);
		if(i.indexOf("1004")>=0){
			//�ŵ���г��о���ά���������۾�����ϼ�ȡ�� edit by Dahl 2015-3-20
			//doTemp.WhereClause = " where SI.Status not in ('01','02','04') and citymanager='"+CurUser.getUserID()+"'";
			//doTemp.WhereClause = " where SI.Status not in ('01','02','04') and UI.SuperId='"+CurUser.getUserID()+"'";
			//����Ϊ���о�����Ϊ���۾���Ļ���Ҫ��ȡ���۾�����ϼ�Ϊ���о�����ŵ�Ȼ��ȡ���о���Ϊ���۾�����ŵ�֮��CCS-729 update huzp 20150427
			doTemp.WhereClause = " where SI.Status not in ('01','02','04') and ( UI.SuperId='"+CurUser.getUserID()+"'  OR  SI.SALESMANAGER='"+CurUser.getUserID()+"')";
			break;
		}else if(i.indexOf("1005")>=0){
			doTemp.WhereClause = " where SI.Status not in ('01','02','04') and SALESMANAGER='"+CurUser.getUserID()+"'";
           break;
		}
	}

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
			{"true","","Button","����鿴","����鿴","viewAndEdit()",sResourcesPath},		
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	/* ������ŵ�󶨵����� */
	function unbandSalesman() {
		
		var vWhereClause = "<%=doTemp.WhereClause%>";
		var vSalesNo = document.getElementById("DF7_1_INPUT").value;
		var vSalesName = document.getElementById("DF8_1_INPUT").value;
		var vSerialNo = getItemValue(0,getRow(),"SNO");
		var vSname = getItemValue(0,getRow(),"SNAME");
		
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
		if (sStatus=="07") {
			var tipVal = "ȷ��Ҫȡ���ر�\n�ŵ����ƣ�" + getItemValue(0, getRow(), "SNAME");
			if (confirm(tipVal)) {
				
				// ����̻�״̬Ϊ��ʱ�رգ�������ر�
				var sStoreStatus = RunMethod("���÷���", "GetColValue", "Retail_Info,Status,SerialNo=(select RSerialNo from Store_Info where SerialNo='"+sSerialNo+"')");
				if (sStoreStatus == "07") {
					alert("�̻�״̬Ϊ��ʱ�ر�ʱ����������йرղ�����");
					return;
				}
				
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
		if (sStatus=="07" || sStatus=="05" || sStatus=="03") {
			
			var tipVal = "��ȷ��Ҫ�ر��ŵ꣺" + getItemValue(0, getRow(), "SNAME");
			if (confirm(tipVal)) {
				//alert("serialNo="+getItemValue(0, 0, "SERIALNO")+",retailNo="+getItemValue(0, 0, "RSERIALNO"));
				var sReturn = RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "closeStore", "serialNo="+getItemValue(0, getRow(), "SERIALNO")+",retailNo="+getItemValue(0, getRow(), "RSERIALNO"));
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
		var sRetailStatus = RunMethod("���÷���", "GetColValue", "RETAIL_INFO,STATUS, SERIALNO=(SELECT RSERIALNO FROM STORE_INFO WHERE SERIALNO='"+sSerialNo+"')");
		if (sRetailStatus !== "05") {
			alert("���ȼ����̻���");
			return;
		}
		var sStatus = getItemValue(0, getRow(), "STATUS");
		//alert(sStatus);
		if (sStatus == "03") {
			var tipVal = "ȷ��Ҫ�����ŵ꣺" + getItemValue(0, getRow(), "SNAME");
			if (confirm(tipVal)) {
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
	
	//����ת��
	function updateAll(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sSNO = getItemValue(0,getRow(),"SNO");
		var sCity = getItemValue(0,getRow(),"CITY");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		sCompID = "UpdateAllManager";
		sCompURL = "/BusinessManage/StoreManage/UpdateAllManager.jsp";
	    popComp(sCompID,sCompURL,"City="+sCity+"&SNO="+sSNO,"dialogWidth=400px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();	
	}
    
	//����ת�� 
	function updateOther(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sSNO = getItemValue(0,getRow(),"SNO");
		var sCity = getItemValue(0,getRow(),"CITY");
		var oldSalesManager = getItemValue(0,getRow(),"SALESMANAGER");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
//		sCompID = "UpdateOtherManager";
//		sCompURL = "/BusinessManage/StoreManage/UpdateOtherManager1.jsp";
//	    popComp(sCompID,sCompURL,"City="+sCity+"&SNO="+sSNO+"&oldSalesManager="+oldSalesManager,"dialogWidth=400px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	   
	    sCompID = "UpdateOtherStoreManager";
		sCompURL = "/BusinessManage/StoreManage/UpdateOtherStoreManager.jsp";
	    popComp(sCompID,sCompURL,"City="+sCity+"&SNO="+sSNO+"&oldSalesManager="+oldSalesManager,"dialogWidth=400px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();	
	}
	
	function viewAndEdit(){
		var sSSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sSNo = getItemValue(0, getRow(), "SNO");
		var sStatus= getItemValue(0, getRow(), "STATUS");
		var sFlag = "CountAndCheck";
		if (typeof(sSSerialNo)=="undefined" || sSSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.OpenView("/BusinessManage/StoreManage/StoreInfoTab.jsp","SSerialNo="+sSSerialNo+"&SNo="+sSNo+"&Status="+sStatus+"&sFlag="+sFlag,"_blank","");
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