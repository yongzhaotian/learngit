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
	String sActionType = DataConvert.toRealString(iPostChange, (String)CurPage.getParameter("ActionType"));
	
	String sStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Status"));
	
	if (sSSerialNo == null) sSSerialNo = "";
	if (sSerialNo == null) sSerialNo = "";
	if (sSNo == null) sSNo = "";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "StoreProductInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	// �����ֶοɼ�����
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	
	//�ر�״̬������༭ update CCS-884 �ر�״̬���ر��水ť tangyb 20150720
	if(!"06".equals(sStatus)){
		dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	}else{
		dwTemp.ReadOnly = "1"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	}
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath},
	};
	
	//add CCS-884 �ر�״̬���ر��水ť tangyb 20150720
	if("06".equals(sStatus)){
		sButtons[0][0]="false";
	}
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">

	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	function selectProductCategory() {
		
		var sRetVal = setObjectValue("SelectProductSetMulti", "", "",0,0,"dialogWidth:660px;dialogHeight:450px;resizable:yes;scrollbars:no;status:no;help:no");
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
		setItemValue(0, 0, "PNO", sPNo.substring(0, sPNo.length-1));
		setItemValue(0, 0, "PNAME", sPName.substring(0, sPName.length-1));
	}
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		//CCS-1069  add by zty 20160203
		var pNo = getItemValue(0, 0, "PNO");
		if(pNo.indexOf("@") == -1){
			pNo = pNo + "@" + pNo;
			setItemValue(0, 0, "PNO", pNo);
		}
		//end add;
		as_save("myiframe0",sPostEvents);
		
		var sRetResult = RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "getStoreRelativeProductCategory", "serialNo="+getItemValue(0, 0, "SERIALNO"));
		if ("Fail" == sRetResult) {
			alert("������Ʒʧ�ܣ����飡");
			return;
		}
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		if ("<%=sActionType%>" == "<%=CommonConstans.VIEW_DETAIL%>") {
			self.close();
			return;
		}
		AsControl.OpenView("/BusinessManage/StoreManage/ProductList.jsp", "SNo=<%=sSNo %>", "_self","");

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
			var sSerialNo = getSerialNo("StoreRelativeProduct","SerialNo");// ��ȡ��ˮ��
			setItemValue(0,0,"SERIALNO",sSerialNo);
			setItemValue(0, 0, "SNO", "<%=sSNo %>");
			var sIssUper = RunMethod("CheckIsSuper", "Check", "<%=sSNo %>");
			/****CCS-1043 PRM-581 �ŵ������롰�Ƿ���̻����ֶ� update huzp begin****/
			var sSuperName = RunMethod("FindSuperName", "FindSuper", "<%=sSNo %>");
			/****end ****/
			if(sIssUper == "Null"){
				sIssUper ="";
			}
			setItemValue(0, 0, "ISSUPER", sIssUper);
			setItemValue(0, 0, "SSERIALNO", "<%=sSSerialNo %>");
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"UPDATEORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			/****CCS-1043 PRM-581 �ŵ������롰�Ƿ���̻����ֶ� update huzp begin****/
			setItemValue(0, 0, "RNAMESHORT", sSuperName);
			/****end ****/
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
