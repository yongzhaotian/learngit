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
	String sTempletNo = "MobilePosList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.WhereClause = " where MP.Status not in ('01','02','04')";

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
		{"true","","Button","����鿴","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","����","����","activeStore()",sResourcesPath},
		{"true","","Button","�ر�","�ر�","closeStore()",sResourcesPath},
		{"true","","Button","��ʱ�ر�","��ʱ�ر�","amomentCloseStore()",sResourcesPath},
		{"true","","Button","ȡ���ر�","ȡ���ر�","cancelCloseStore()",sResourcesPath},
		
	};
	
	//���ڿ��Ƶ��а�ť��ʾ��������  add by Dahl 20150318
	String iButtonsLineMax = "12";
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);
			
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
		var sRETATIVESTORENO = getItemValue(0, getRow(), "RETATIVESTORENO");//�ŵ����
		var sMOBLIEPOSNO = getItemValue(0,getRow(),"MOBLIEPOSNO");//pos����
		if (typeof(sMOBLIEPOSNO)=="undefined" || sMOBLIEPOSNO.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		var sStatus = getItemValue(0, getRow(), "STATUS");
		if(sStatus=="07"){
			var sReturn = RunMethod("���÷���","UpdateColValue","MOBILEPOS_INFO,Status,05,MOBLIEPOSNO='"+getItemValue(0, getRow(), "MOBLIEPOSNO")+"'");
			if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
				alert("ȡ���ر��ƶ�POS��ʧ�ܣ�");
				return;	
			}
			alert("ȡ���ر��ƶ�POS��ɹ���");
			reloadSelf();
		} else {
			alert("��ʱ�ر�״̬�ŵ������ȡ���رգ�");
			return;
		}
	}

	<%/*~[Describe=��ʱ�ر�������;InputParam=��;OutPutParam=��;] added by tbzeng 2014/02/26~*/%>
	function amomentCloseStore() {
		var sRETATIVESTORENO = getItemValue(0, getRow(), "RETATIVESTORENO");//�ŵ����
		var sMOBLIEPOSNO = getItemValue(0,getRow(),"MOBLIEPOSNO");//pos����
		if (typeof(sMOBLIEPOSNO)=="undefined" || sMOBLIEPOSNO.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}

		var sStatus = getItemValue(0, getRow(), "STATUS");
		if (sStatus == "05") {
			var tipVal = "ȷ��Ҫ��ʱ�ر�\n�ƶ�POS�㣺" + getItemValue(0, getRow(), "MOBLIEPOSNO");
			if (confirm(tipVal)) {
				var sReturn = RunMethod("���÷���","UpdateColValue","MOBILEPOS_INFO,Status,07,MOBLIEPOSNO='"+getItemValue(0, getRow(), "MOBLIEPOSNO")+"'");
				if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
					alert("�ƶ�POS����ʱ�ر�ʧ�ܣ�");
					return;			
				}else if(sStatus == "07"){
                  alert("�ƶ�POS����ʱ�رճɹ���");
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
		var sMobliePosNo = getItemValue(0,getRow(),"MOBLIEPOSNO");  //�ƶ�POS�����
		var sRetativeStoreNO = getItemValue(0,getRow(),"RETATIVESTORENO");  //�ŵ����
		
		if (typeof(sMobliePosNo)=="undefined" || sMobliePosNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		//����״̬Ϊ�������ʱ�رյ������̣��ɽ���رա�����״̬������;
		var sStatus = getItemValue(0, getRow(), "STATUS");
		if (sStatus=="07" || sStatus=="05" || sStatus=="03") {
			
			var tipVal = "��ȷ��Ҫ�ر��ƶ�POS�㣺" + getItemValue(0, getRow(), "RETATIVESTORENO");
			if (confirm(tipVal)) {
	        	var sReturn = RunMethod("���÷���","UpdateColValue","MOBILEPOS_INFO,STATUS,06,MOBLIEPOSNO='"+getItemValue(0, getRow(), "MOBLIEPOSNO")+"'");
				if(sReturn == "Fail") {				
					alert("�ƶ�POS��ر�ʧ�ܣ�");
					return;			
				}else if(sStatus=="06" ){
					alert("�ƶ�POS��رճɹ���");
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
		var sMobliePosNo = getItemValue(0,getRow(),"MOBLIEPOSNO");  //�ƶ�POS�����
		var sRetativeStoreNO = getItemValue(0,getRow(),"RETATIVESTORENO");  //�ŵ����
		
		if (typeof(sMobliePosNo)=="undefined" || sMobliePosNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		var sStatus = getItemValue(0, getRow(), "STATUS");
		var sPosStatus = RunMethod("���÷���","GetColValue","MOBILEPOS_INFO,STATUS,MOBLIEPOSNO='"+getItemValue(0, getRow(), "MOBLIEPOSNO")+"'");
          if(sStatus == "03"){
		        var sStoreStatus = RunMethod("���÷���","GetColValue","STORE_INFO,STATUS,SNO='"+getItemValue(0, getRow(), "RETATIVESTORENO")+"'");
		        if(sStoreStatus !="05"){
		        	alert("���� �����ŵ꣡");
		        }else{
		        	var sReturn = RunMethod("���÷���","UpdateColValue","MOBILEPOS_INFO,STATUS,05,MOBLIEPOSNO='"+getItemValue(0, getRow(), "MOBLIEPOSNO")+"'");		        	
		        }
		        alert("����ɹ���");
		       reloadSelf(); 
		   }else if(sStatus == "05"){
			   alert("�ƶ�POS���Ѽ���");
			   return;
		   }else{
			   alert("׼��״̬���ƶ�POS��������");
			   return;
		   }

		
		
<%-- 		openColseDate="<%=DateX.format(new java.util.Date(), "yyyy/MM/dd HH:mm:ss")%>";
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
		} --%>
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
	
	function viewAndEdit(){
		var sApplySerialNo= getItemValue(0,getRow(),"APPLYSERIALNO");
		var sSNo = getItemValue(0, getRow(), "RETATIVESTORENO");
		var sStatus= getItemValue(0, getRow(), "STATUS");
		var sMobilePosNo=getItemValue(0,getRow(),"MOBLIEPOSNO")
		if (typeof(sApplySerialNo)=="undefined" || sApplySerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.OpenView("/BusinessManage/PosManage/MobilePosApplyFlow/MobilePosInfoTab.jsp","ApplySerialNo="+sApplySerialNo+"&SNo="+sSNo+"&Status="+sStatus+"&MOBLIEPOSNO="+sMobilePosNo,"_blank","");
		reloadSelf();
	}
	
	

	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>