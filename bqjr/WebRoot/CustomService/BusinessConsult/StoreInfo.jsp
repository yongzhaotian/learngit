<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "�ŵ���Ϣ";

	// ���ҳ�����
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sWhereClause = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("WhereClause"));
	String sViewId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ViewId"));
	
	if (sSerialNo == null) sSerialNo = "";
	if (sWhereClause == null) sWhereClause = "";
	if (sViewId == null) sViewId = "01";
	
	if ("02".equals(sViewId)) CurPage.setAttribute("RightType", "ReadOnly");
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "StoreInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
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
	
	// ��ȡ���о���
	function getCityManager() {
		
		var sRetVal = setObjectValue("SelectCityResponsiblePerson", "CityNo,"+getItemValue(0, 0, "CITY"),"",0,0,"");
		if (typeof(sRetVal)=='undefined' || sRetVal=="_CLEAR_") {
			return;
		}
		var sUserId = sRetVal.split("@")[0];
		var sUserName = sRetVal.split("@")[1];
		setItemValue(0, 0, "CITYMANAGER", sUserId);
		setItemValue(0, 0, "CITYMANAGERNAME", sUserName);
	}
	
	// ������̻��������ŵ�������Ϣ�����޸�
	function isNetBank() {
		
	}
	
	// ���ʹ���̻����������ó�Ĭ��ֵ����������������ó�ֻ��
	function setBankDefValue() {
	}
	
	
	/*~[Describe=������ѡ��ѡ��������Ա;InputParam=��;OutPutParam=��;]~*/
	function selectSalesmanSingle() {
		
		var sRetVal = setObjectValue("SelectSalesmanSingle", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("��ѡ�����ۣ�");
			return;
		}
		setItemValue(0, 0, "SALESMANAGER", sRetVal.split("@")[0]);
		setItemValue(0, 0, "SALESMANAGERNAME", sRetVal.split("@")[1]);
		return;
	}
	
	/*~[Describe=������ѡ��ѡ����Ʒ����;InputParam=��;OutPutParam=��;]~*/
	function selectProductCategoryMulti() {
		var sRetVal = setObjectValue("SelectProductCategoryMulti", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("��ѡ����Ʒ���룡");
			return;
		}
		var sTypeArry = sRetVal.substring(0, sRetVal.length-1).split("@");
		var sCTypeIds = "";
		var SCTypeNames = "";
		for (var i=0;i<sTypeArry.length;i=i+2) {
			sCTypeIds += sTypeArry[i] + ",";
			SCTypeNames += sTypeArry[i+1] + ",";
		}
		setItemValue(0, 0, "PRODUCTCATEGORY", sCTypeIds.substring(0, sCTypeIds.length-1));
		setItemValue(0, 0, "PRODUCTCATEGORYNAME", SCTypeNames.substring(0, SCTypeNames.length-1));
		return;
	}
	
	function selectAccount() {
		alert("ѡ���˺ţ��Զ���仧���Ϳ�����");
	}
	
	function selectMainProductCategory() {
		var sRetVal = setObjectValue("SelectProductCategoryMulti", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("��ѡ������Ʒ�ƣ�");
			return;
		}
		var sTypeArry = sRetVal.substring(0, sRetVal.length-1).split("@");
		var sCTypeIds = "";
		var SCTypeNames = "";
		for (var i=0;i<sTypeArry.length;i=i+2) {
			sCTypeIds += sTypeArry[i] + ",";
			SCTypeNames += sTypeArry[i+1] + ",";
		}
		setItemValue(0, 0, "MAINBUSINESSTYPE", sCTypeIds.substring(0, sCTypeIds.length-1));
		setItemValue(0, 0, "MAINBUSINESSTYPENAME", SCTypeNames.substring(0, SCTypeNames.length-1));
		return;
	}
	
	/*~[Describe=���������滮ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode() {
		
		var retVal = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
			alert("��ѡ����Ҫѡ��ĳ��У�");
			return;
		}
		
		setItemValue(0, 0, "CITY", retVal.split("@")[0]);
		setItemValue(0, 0, "CITYNAME", retVal.split("@")[1]);
		var sSNo = RunJavaMethodSqlca("com.amarsoft.app.billions.GenerateSerialNo", "getStoreNo", "cityCode="+retVal.split("@")[0]);
		setItemValue(0, 0, "SNO", sSNo);
	}
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		
		AsControl.OpenView("/CustomService/BusinessConsult/StoreConsultList.jsp", "WhereClause=<%=sWhereClause %>", "_self");
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		var serialNo = getSerialNo("Store_Info","SNo");// ��ȡ��ˮ��
		setItemValue(0,getRow(),"SNo",serialNo);
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"UPDATEORGNAME","<%=CurOrg.orgName%>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			bIsInsert = true;
		}
		
		isNetBank();
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
