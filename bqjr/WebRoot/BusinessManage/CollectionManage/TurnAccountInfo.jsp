<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "�����˹鼯�˻�ҳ��";

	// ���ҳ�����
	String sSerialNoS =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNoS"));
	String sAreaCodes =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AreaCodes"));
	String sProductTypes =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProductTypes"));
	String sSerialNoStr = "";
	String sAreaCodeStr = "";
	String sProductTypeStr = "";
	if(sSerialNoS==null){
		sSerialNoS="";
	}else{
		sSerialNoStr = sSerialNoS.split(",")[0];
	}
	if(sAreaCodes==null){
		sAreaCodes="";
	}else{
		sAreaCodeStr = sAreaCodes.split(",")[0];
	}
	if(sProductTypes==null){
		sProductTypes="";
	}else{
		sProductTypeStr = sProductTypes.split(",")[0];
	}
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "TurnAccountInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNoStr+","+sAreaCodeStr+","+sProductTypeStr);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	function saveRecord(sPostEvents){
		var sSerialNoS = "<%=sSerialNoS%>";
		var sAreaCodes = "<%=sAreaCodes%>";
		var sProductTypes = "<%=sProductTypes%>";
		if(sSerialNoS=="" || sAreaCodes=="" || sProductTypes==""){
			return;
		}
		var sTurnAccountNumber = getItemValue(0,getRow(),"turnAccountNumber");
		var sTurnAccountName = getItemValue(0,getRow(),"turnAccountName");
		var sTurnAccountBlank = getItemValue(0,getRow(),"turnAccountBlank");
		var sBackAccountPrefix = getItemValue(0,getRow(),"backAccountPrefix");
		var sSubBankName = getItemValue(0,getRow(),"SubBankName");
		
		var params = "serialNoS=" + sSerialNoS + ",areaCodes=" + sAreaCodes 
				+ ",productTypes=" + sProductTypes + ",turnAccountNumber=" + sTurnAccountNumber
				+ ",turnAccountName=" + sTurnAccountName + ",turnAccountBlank=" + sTurnAccountBlank
				+ ",backAccountPrefix=" + sBackAccountPrefix + ",subBankName=" + sSubBankName;
		
		var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.TurnAccountSave", 
				"saveBank", params);
		
		if(!vI_all("myiframe0")){
			return;
		}if (result.split("@")[0] != "true") {
			alert(result.split("@")[1]);
			return;
		} else {
			alert("����ɹ���");
			reloadSelf();
			self.close();
			return;
		}
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		self.close();
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		var serialNo = getSerialNo("EXAMPLE_INFO","ExampleId");// ��ȡ��ˮ��
		setItemValue(0,getRow(),"ExampleID",serialNo);
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
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
		//initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
