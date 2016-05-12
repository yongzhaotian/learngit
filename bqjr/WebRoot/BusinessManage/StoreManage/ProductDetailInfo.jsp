<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "�ŵ���Ϣ";

	// ���ҳ�����
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sSNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNo"));
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sObjectNo == null) sObjectNo="";		// || "StoreApplyInfo".equals(sObjectType)
	if(sObjectType == null) sObjectType="";
	if(sSNo == null) sSNo="";
	if(sSerialNo == null) sSerialNo = "";
	
	String sPrevUrl =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PrevUrl"));
	String flag = CurPage.getParameter("flag");
	if(sPrevUrl==null) sPrevUrl="";
	if(flag==null) flag = "";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "StoreProductInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	// �����ֶοɼ�����
	doTemp.setReadOnly("SNO,PNO", true);
	doTemp.setUnit("PNO", "");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
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
	var sPrevUrl = "<%=sPrevUrl%>";
	
	function selectProductType() {
		
		var sRetVal = setObjectValue("SelectProductType", "", "");
		if (typeof(sRetVal)=='undefined' || sRetVal.length==0) {
			alert("��ѡ���Ʒ���ͣ�");
			return;
		}
		
		setItemValue(0, 0, "PNO", sRetVal);
		
	}
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
		
		//AsControl.OpenView("/BusinessManage/StoreManage/ProductList.jsp", "SNo=<%=sSNo %>", "_self","");
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		
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
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
			setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"UPDATEORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
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
