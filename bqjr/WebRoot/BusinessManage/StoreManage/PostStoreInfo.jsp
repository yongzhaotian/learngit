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
	String sActionType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ActionType"));

	String sStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Status"));
	
	if (sSerialNo == null) sSerialNo = "";
	if (sSSerialNo == null) sSSerialNo = "";
	if (sSNo == null) sSNo = "";
	if (sActionType == null) sActionType = "";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "StorePostStoreInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
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
	
	function selectStore() {
		var sRet = setObjectValue("SelectStoreMulti", "", "");
		if (typeof(sRet)=='undefined' || "_CLEAR_"==sRet || sRet.length==0) {
			alert("��ѡ����Ҫ�������ŵ꣡");
			return;
		}
		sRet = sRet.substring(0, sRet.length-1);
		var sRelativeSNo = "";
		var sRelativeSName = "";
		var retArray = sRet.split("@");
		for (var i in retArray) {
			if (i%2==0) {
				sRelativeSNo += retArray[i] + "@";
			} else if (i%2==1) {
				sRelativeSName += retArray[i] + "@";
			}
		}
	
		setItemValue(0, 0, "RELATIVESNO", sRelativeSNo.substring(0, sRelativeSNo.length-1));
		setItemValue(0, 0, "RELATIVESNAME", sRelativeSName.substring(0, sRelativeSName.length-1));
		
	}
	function selectStoreSingle() {
		
		var sSNo = setObjectValue("SelectStoreSingle", "", "");
		if (typeof(sSNo)=='undefined' || sSNo.length==0) {
			alert("��ѡ����Ҫ�������ŵ꣡");
			return;
		}
	
		setItemValue(0, 0, "RELATIVESNO", sSNo.split("@")[0]);
		
	}
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);

		var retResult = RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "getStoreRelativePostStore", "serialNo="+getItemValue(0, 0, "SERIALNO"));
		if ("FAIL"==retResult) {
			alert("������Ʒʧ�ܣ����飡");
			return;
		}
		
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		
		if ("<%=sActionType%>" ==  "<%=CommonConstans.VIEW_DETAIL %>") {
			self.close();
			return;
		}
		
		AsControl.OpenView("/BusinessManage/StoreManage/PostStoreList.jsp", "SNo=<%=sSNo %>", "_self","");

	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			var serialNo = getSerialNo("Storerelativepoststore", "SerialNo");
			setItemValue(0, 0, "SERIALNO", serialNo);
			setItemValue(0, 0, "SNO", "<%=sSNo %>");
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
