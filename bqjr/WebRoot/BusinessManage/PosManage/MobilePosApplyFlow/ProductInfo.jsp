<%@page import="com.amarsoft.app.billions.CommonConstans"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "�ŵ���Ϣ";

	// ���ҳ�����
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sSSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SSerialNo"));
	String sSNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNo"));
	String sMobilePosNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MobilePosNo"));
	String sActionType = DataConvert.toRealString(iPostChange, (String)CurPage.getParameter("ActionType"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	
	if (sSSerialNo == null) sSSerialNo = "";
	if (sSerialNo == null) sSerialNo = "";
	if (sMobilePosNo == null) sMobilePosNo = "";
	if (sSNo == null) sSNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "MobilePosProductInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	// �����ֶοɼ�����
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{CurUser.hasRole("1005")&&"0010".equals(sPhaseNo)?"true":"false","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">

	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	function selectProductCategory() {
		var ssSNo="<%=sSNo%>";
		var sRetVal = setObjectValue("SelectProductForMobilePos", "SNo,"+ssSNo+",POSNO,<%=sMobilePosNo%>", "",0,0,"dialogWidth:660px;dialogHeight:450px;resizable:yes;scrollbars:no;status:no;help:no");
		//alert(sRetVal);
		if (typeof(sRetVal)=='undefined' || sRetVal.length==0) {
			//alert("��ѡ����Ʒ���룡");
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
//		alert(sPNo.substring(0, sPNo.length-1));
//		alert(sPName.substring(0, sPName.length-1));
		setItemValue(0, 0, "PNO", sPNo.substring(0, sPNo.length-1));
		setItemValue(0, 0, "PNAME", sPName.substring(0, sPName.length-1));
	}
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		//as_save("myiframe0",sPostEvents); 
		var sParam = "";
		var sSerialNo = getItemValue(0,0,"SERIALNO");//��ˮ��
		var sPosNo = getItemValue(0,0,"POSNO");//pos���
		var sPNos = getItemValue(0,0,"PNO");
		var sPNAMEs = getItemValue(0,0,"PNAME");
		var sINPUTORG = getItemValue(0,0,"INPUTORG");
		var sINPUTUSER = getItemValue(0,0,"INPUTUSER");
		var sINPUTDATE = getItemValue(0,0,"INPUTDATE");
		var sUPDATEORG = getItemValue(0,0,"UPDATEORG");
		var sUPDATEUSER = getItemValue(0,0,"UPDATEUSER");
		var sUPDATEDATE = getItemValue(0,0,"UPDATEDATE");
		sParam = "SerialNo="+sSerialNo+",POSNO="+sPosNo+",PNO="+sPNos+",PNAME="+sPNAMEs+",INPUTORG="+sINPUTORG
		+",INPUTUSER="+sINPUTUSER+",INPUTUSER="+sINPUTUSER+",UPDATEDATE="+sUPDATEDATE+",INPUTDATE="+sINPUTDATE
		+",UPDATEORG="+sUPDATEORG+",UPDATEUSER="+sUPDATEUSER;
		
		var sRetResult= RunJavaMethodSqlca("com.amarsoft.app.billions.PosRelativeProduct", "sRelativeProduct", sParam);
		if ("FALSE" == sRetResult) {
			alert("������Ʒʧ�ܣ����飡");
			return;
		}else if("NoProduct"==sRetResult){
			alert("��Ʒѡ��ʧ�ܣ����飡");
			return;
		}else{
			alert("������Ʒ�ɹ���");
		}
		var sPNO = RunMethod("���÷���","GetColValue", "MobilePosRelativeProduct,PNO,SerialNo='"+sSerialNo+"'");
		setItemValue(0, 0, "PNO",sPNO );
		var sPName = RunMethod("���÷���","GetColValue", "MobilePosRelativeProduct,PNAME,SerialNo='"+sSerialNo+"'");
		setItemValue(0, 0, "PNAME",sPName );
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		if ("<%=sActionType%>" == "<%=CommonConstans.VIEW_DETAIL%>") {
			self.close();
			return;
		}
		var sSNo = "<%=sSNo%>"
		AsControl.OpenView("/BusinessManage/PosManage/MobilePosApplyFlow/ProductList.jsp", "SNo="+sSNo+"&MOBLIEPOSNO=<%=sMobilePosNo %>", "_self","");

	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			var sSerialNo = getSerialNo("MobilePosRelativeProduct","SerialNo");// ��ȡ��ˮ��
			setItemValue(0,0,"SERIALNO",sSerialNo);
			setItemValue(0, 0, "POSNO", "<%=sMobilePosNo %>");
			setItemValue(0, 0, "SSERIALNO", "<%=sSSerialNo %>");
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"UPDATEORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			bIsInsert = true;
		}
		
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
