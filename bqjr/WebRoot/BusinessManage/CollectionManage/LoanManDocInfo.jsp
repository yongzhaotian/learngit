<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "���ø�ʽ�������ĵ�ҳ��";

	// ���ҳ�����
	String sSerialNoS =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNoS"));
	String sAreaCodes =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AreaCodes"));
	String sProductTypes =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProductTypes"));
	String sTypeNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TypeNo"));

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
	
	String sSerialNo = sSerialNoStr+sAreaCodeStr+sProductTypeStr;
	ARE.getLog().info("��ˮ�ţ�===============sSerialNo�� "+sSerialNo);
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "LoanManEDocInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo+","+sTypeNo);//�������,���ŷָ�
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
		var sSerialNoArr = sSerialNoS.split(",");
		var sAreaCodeArr = sAreaCodes.split(",");
		var sProductTypeArr = sProductTypes.split(",");
		var sSpSerialNo = "";
		var sBusinessType = getItemValue(0,getRow(),"BusinessType");
		var sDocID = getItemValue(0,getRow(),"DocID");
		var sBeginTime = getItemValue(0,getRow(),"BeginTime");
		var sEndTime = getItemValue(0,getRow(),"EndTime");
		var sinputUser = getItemValue(0,getRow(),"inputUser");
		var sinputDate = getItemValue(0,getRow(),"inputDate");
		
		if(!dateCompare()){
			return;
		}
		if(!vI_all("myiframe0")){
			return;
		}

		for(var i=0;i<sAreaCodeArr.length;i++){
			sSpSerialNo = sSerialNoArr[i]+sAreaCodeArr[i]+sProductTypeArr[i];
			RunMethod( "LoanAccount", "deleteFormatdoc", "SpSerialNo='"+sSpSerialNo+"' and BusinessType='"+sBusinessType+"'");
			RunMethod( "LoanAccount", "insertFormatDocVersion", sSpSerialNo+","+sBusinessType+","+sDocID+","+sBeginTime+","+sEndTime+","+sinputUser+","+sinputDate);
			RunMethod( "���÷���", "UpdateColValue", "ProvidersCity,SpSerialNo,"+sSpSerialNo+",SerialNo='"+sSerialNoArr[i]+"' and AreaCode='"+sAreaCodeArr[i]+"' and ProductType='"+sProductTypeArr[i]+"'");//���´����˳����м���ģ��������
		}
		
		alert("����ɹ���");
		window.close();
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	//��ȡģ����
	 function getDocID(){
		var sTypeNo = getItemValue(0,getRow(),"BusinessType");
		var sRetVal = setObjectValue("selectFormatdocCatalog", "TypeNo,"+sTypeNo, "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal.length==0){
			alert("��ѡ�����ģ�棡");
			return;
		}
		setItemValue(0,0,"DocID",sRetVal.split("@")[0]);
		setItemValue(0,0,"DocName",sRetVal.split("@")[1]);
	} 
	
	 function dateCompare() {
			
			var sStartTime = getItemValue(0, 0, "BeginTime");
			var sEndTime = getItemValue(0, 0, "EndTime");
			if(typeof(sStartTime)=="undefined" || sStartTime.length==0){
				alert("����ѡ����Чʱ�䣡");
				return false;
			}
			if ((sEndTime.localeCompare(sStartTime)<=0)&&!(typeof(sEndTime)=="undefined" || sEndTime.length==0)) {
				alert("ʧЧʱ����������Чʱ�䣡");
				return false;
			}
			return true;
		}
	 
	function goBack(){}


	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		
		setItemValue(0,0,"SpSerialNo","<%=sSerialNo%>");
		setItemValue(0,0,"BusinessType","<%=sTypeNo%>");
		var sBusinessType = getItemValue(0, 0, "BusinessType");
		var sDOCName = RunMethod("���÷���", "GetColValue", "Formatdoc_Type,typetitle,TypeNo='"+sBusinessType+"'");
		setItemValue(0,0,"BusinessTypeName",sDOCName);
		setItemValue(0,0,"inputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"inputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"inputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
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
			beforeInsert();
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
