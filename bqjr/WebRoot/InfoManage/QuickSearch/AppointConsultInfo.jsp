<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "�ͻ�ԤԼ"; // ��������ڱ��� <title> PG_TITLE </title>
	
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sViewId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ViewId"));
	String sWhereClause = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("WhereClause"));
	
	if ("02".equals(sViewId)) {
		CurPage.setAttribute("RightType", "ReadOnly");
	}
	
	if (sSerialNo == null) sSerialNo = "";
	if (sViewId == null) sViewId = "";
	if (sWhereClause == null) sWhereClause = "";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CustomerConsultInfo";//ģ�ͱ��
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);//���׶�������ģ��
	
	// ����Ĭ��ֵ
	
	// �����ֶΰ�ť�¼�
	//doTemp.setHTMLStyle("PHONE", " onblur=\"javascript:parent.checkMobile(this)\"");

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","�����¼","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�Ҳ��","goBack()",sResourcesPath},
	};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	
	/*~[Describe=��������ԤԼ������Ա��Ϣ InputParam=��;OutPutParam=��;]~*/
	function getSalesmanSingle() {
		
		var sRetVal = setObjectValue("SelectSalesmanSingle", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("��ѡ�����ۣ�");
			return;
		}
		setItemValue(0, 0, "RESERVSALES", sRetVal.split("@")[0]);
		setItemValue(0, 0, "RESERVSALESNAME", sRetVal.split("@")[1]);
		return;
		
	}
	
	/*~[Describe=������ѡ�ŵ���Ϣ InputParam=��;OutPutParam=��;]~*/
	function getStoreSingle() {
		
		var sRetVal = setObjectValue("SelectStoreSingle", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("��ѡ���ŵ꣡");
			return;
		}
		setItemValue(0, 0, "RESERVSTORE", sRetVal.split("@")[0]);
		setItemValue(0, 0, "RESERVSTORENAME", sRetVal.split("@")[1]);
		return;
	}
	
	/*~[Describe=����������Ʒ��Ϣ InputParam=��;OutPutParam=��;]~*/
	function getProductCTypeMulti() {
		
		var sRetVal = setObjectValue("SelectProductCTypeMulti", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("��ѡ����Ʒ��");
			return;
		}
		var sTypeArry = sRetVal.substring(0, sRetVal.length-1).split("@");
		var sCTypeIds = "";
		var SCTypeNames = "";
		for (var i=0;i<sTypeArry.length;i=i+2) {
			sCTypeIds += sTypeArry[i] + ",";
			SCTypeNames += sTypeArry[i+1] + ",";
		}
		setItemValue(0, 0, "CHARMPRODUCT", sCTypeIds.substring(0, sCTypeIds.length-1));
		setItemValue(0, 0, "CHARMPRODUCTNAME", SCTypeNames.substring(0, SCTypeNames.length-1));
		return;
	}
	
	/*~[Describe=�������в�Ʒ��Ϣ InputParam=��;OutPutParam=��;]~*/
	function getBusinessTypeMulti() {
		
		var sRetVal = setObjectValue("SelectBusinessTypeMulti", "", "", 0, 0, "");
		
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("��ѡ���Ʒ��");
			return;
		}
		var sTypeArry = sRetVal.substring(0, sRetVal.length-1).split("@");
		var sCTypeNos = "";
		var SCTypeNames = "";
		for (var i=0;i<sTypeArry.length;i=i+2) {
			sCTypeNos += sTypeArry[i] + ",";
			SCTypeNames += sTypeArry[i+1] + ",";
		}
		setItemValue(0, 0, "BUSINESSTYPE", sCTypeNos.substring(0, sCTypeNos.length-1));
		setItemValue(0, 0, "BUSINESSTYPENAME", SCTypeNames.substring(0, SCTypeNames.length-1));
		return;
	}
	
	
	/*~[Describe=���������滮ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode() {

		var sRetVal = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		//var sRetVal = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode=","dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		
		if (typeof(sRetVal)=="undefined" || sRetVal=='_CLEAR_' || sRetVal.length==0) {
			alert("��ѡ��ĳ��У�");
			return;
		}
		
		setItemValue(0, 0, "CITY", sRetVal.split("@")[0]);
		setItemValue(0, 0, "CITYNAME", sRetVal.split("@")[1]);

	}
	
	// ���ʱ���Ƿ���ڵ�ǰʱ��
	function checkDateAfterNow(field) {
		
		var sNowDate = getItemValue(0, 0, "INPUTDATE");
		var sInputDate = getItemValue(0, 0, "VISITDATETIME");
		if (sNowDate.localeCompare(sInputDate) >= 0) {
			alert("ѡ������Ӧ���ڵ�ǰ����");
		}		
	}
	
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		
		setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID %>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID() %>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID %>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID() %>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
	}
	
	// ���ؽ����б�
	function goBack()
	{
		if ("<%=sViewId%>"=="02") {
			AsControl.OpenView("/InfoManage/QuickSearch/AppointManageList.jsp","","_self");
			return;
		}
	}
	
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			var sSerialNo = getSerialNo("Consult_Info","SERIALNO");// ��ȡ��ˮ��
			setItemValue(0,getRow(),"SERIALNO",sSerialNo);
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID %>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.orgName %>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			
			setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID %>");
			setItemValue(0,0,"UPDATEORGNAME","<%=CurOrg.orgName %>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			bIsInsert = true;
		}
    }

	</script>

<script language=javascript>
	bFreeFormMultiCol = true;
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	

<%@ include file="/IncludeEnd.jsp"%>
