<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "�ŵ���Ϣ";

	// ���ҳ�����
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sSerialNoS =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNoS"));
	
	String BusinessDate=SystemConfig.getBusinessDate();
	
	if (sSerialNo == null) sSerialNo = "";
	if (sSerialNoS == null) sSerialNoS = "";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "FeeCommissionsInfoForMobilePos";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	// �����ֶοɼ�����
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	doTemp.setHTMLStyle("COMSPSTARTDATE","onChange=\"javascript:parent.CheckStartDate()\"");
	doTemp.setHTMLStyle("COMSPENDDATE","onChange=\"javascript:parent.CheckEndDate()\"");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">

	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	function selectProductCategory() {
		
		var sRetVal = setObjectValue("SelectProductCategoryMulti", "", "",0,0,"dialogWidth:360px;dialogHeight:650px;resizable:yes;scrollbars:no;status:no;help:no");
		//alert(sRetVal);
		if (typeof(sRetVal)=='undefined' || sRetVal.length==0) {
			alert("��ѡ����Ʒ���룡");
			return;
		}
		
		sRetVal = sRetVal.substring(0, sRetVal.length-1);
		var retArry = sRetVal.split("@");
		var sPNo = "";
		var sPName = "";
		for (var i in retArry) {
			if (i%2==0) {
				sPNo += retArry[i] + "@";
			} else if (i%2==1) {
				sPName += retArry[i] + "@";
			}
		}
		setItemValue(0, 0, "PNO", sPNo.substring(0, sPNo.length-1));
		setItemValue(0, 0, "PNAME", sPName.substring(0, sPName.length-1));
	}
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		if(!CheckStartDate()){
			return;
		}
		if(!CheckEndDate()){
			return;
		}
		
		var sBASEAMOUNT=getItemValue(0,getRow(),"BASEAMOUNT");
		var sSERVICERATIO=getItemValue(0,getRow(),"SERVICERATIO");
		var sFIXSERVICEAMOUNT=getItemValue(0,getRow(),"FIXSERVICEAMOUNT");
		var sCOMMISSIONRATIO=getItemValue(0,getRow(),"COMMISSIONRATIO");
		var sFIXCOMMISSIONAMOUNT=getItemValue(0,getRow(),"FIXCOMMISSIONAMOUNT");
		var sCOMSPSTARTDATE=getItemValue(0,getRow(),"COMSPSTARTDATE");
		var sCOMSPENDDATE=getItemValue(0,getRow(),"COMSPENDDATE");
		var sSERIALNO="";
		var sSERIALNOS="<%=sSerialNoS %>";
		sSERIALNOS=sSERIALNOS.split(",");
		//alert(sSERIALNOS);
		
		for(var i=0;i<sSERIALNOS.length;i++){
		sSERIALNO=sSERIALNOS[i];
		//RunMethod("ProductManage","UpdateCommission","BASEAMOUNT="+sBASEAMOUNT+",SERVICERATIO="+sSERVICERATIO+",FIXSERVICEAMOUNT="+sFIXSERVICEAMOUNT+",COMMISSIONRATIO="+sCOMMISSIONRATIO+",FIXCOMMISSIONAMOUNT="+sFIXCOMMISSIONAMOUNT+",COMSPSTARTDATE="+sCOMSPSTARTDATE+",COMSPENDDATE="+sCOMSPENDDATE+",SERIALNO="+sSERIALNO);
		RunMethod("ProductManage","UpdateCommissionForMobilePos",sBASEAMOUNT+","+sSERVICERATIO+","+sFIXSERVICEAMOUNT+","+sCOMMISSIONRATIO+","+sFIXCOMMISSIONAMOUNT+","+sCOMSPSTARTDATE+","+sCOMSPENDDATE+","+sSERIALNO);
		
		}
		//alert("����ɹ���");
		//sSERIALNO=sSERIALNOS[sSERIALNOS.length-1];
		//alert(sSERIALNO);
		as_save("myiframe0",sPostEvents);
		
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		
		AsControl.OpenView("/BusinessManage/PosManage/MobilePosApplyFlow/ProductList.jsp", "", "_self","");
		self.close();
		//parent.parent.reloadSelf();
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		bIsInsert = false;
	}
	
	//���Ӷ�����ʼ����
	function CheckStartDate(){
		var sCOMSPSTARTDATE=getItemValue(0,getRow(),"COMSPSTARTDATE");
		
		if("<%=BusinessDate%>">sCOMSPSTARTDATE){
			alert("Ӷ����ʼ���ڲ���С�ڵ�ǰϵͳ���ڣ�");
			setItemValue(0,getRow(),"sCOMSPSTARTDATE","");
			return false;
		}
		return true;
	}
	
	//���Ӷ��Ľ�������
	function CheckEndDate(){
		var sCOMSPSTARTDATE=getItemValue(0,getRow(),"COMSPSTARTDATE");
		var sCOMSPENDDATE=getItemValue(0,getRow(),"COMSPENDDATE");
		if (typeof(sCOMSPSTARTDATE)=="undefined" || sCOMSPSTARTDATE.length==0){
			alert("Ӷ����ʼ���ڲ���Ϊ�գ�");
			setItemValue(0,getRow(),"COMSPENDDATE","");
			return false;
		}
		if(sCOMSPSTARTDATE>sCOMSPENDDATE){
			alert("Ӷ��������ڲ���С��Ӷ����ʼ���ڣ�");
			setItemValue(0,getRow(),"COMSPENDDATE","");
			return false;
		}
		return true;
	}
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			bIsInsert = true;
		}
		
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
