<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "�ŵ���Ϣ";

	// ���ҳ�����
	String sRSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RSerialNo"));
	String sSSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SSerialNo"));
	if(sRSerialNo == null) sRSerialNo = "";
	if(sSSerialNo == null) sSSerialNo = "";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "StoreInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setHTMLStyle("BranchCodeName", "style={width=250px;");
	
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select Account,AccountName,AccountBank,BusinessScope,isindaccount from Retail_Info where SerialNo=:SerialNo").setParameter("SerialNo", sRSerialNo));
	String sAccount = null;
	String sAccountName = null;
	String sAccountBank = null;
	String sPCategory = null;
	String sIsindaccount = "";
	if (rs.next()) {
		sAccount = rs.getString("Account");
		sAccountName = rs.getString("AccountName");
		sAccountBank = rs.getString("AccountBank");
		sPCategory = rs.getString("BusinessScope");
		sIsindaccount = rs.getString("isindaccount");
	}
	if (sAccount == null) sAccount = "";
	if (sAccountName == null) sAccountName = "";
	if (sAccountBank == null) sAccountBank = "";
	if (sPCategory == null) sPCategory = "";
	if (sIsindaccount == null) sIsindaccount = "";
	
	rs.getStatement().close();
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSSerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">

		//��ȡ���о���
		function getCityManager() {
			
			var sCity = getItemValue(0, 0, "CITY");
			if (typeof(sCity)=="undefined" || sCity.length==0) {
				alert("����ѡ���ŵ����ڳ��У�");
				return;
			}
			
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


	/*~[Describe=���������滮ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode()
	{
		var sRetVal = PopPage("/Common/ToolsC/AllCityCodeNoSingle.jsp","","dialogWidth=550px;dialogHeight=600px;center:yes;resizable:yes;scrollbars:no;status:no;help:no");
	
		if (typeof(sRetVal)=='undefined' || sRetVal.length==0) {
			alert("��ѡ����Ҫѡ��ĳ��У�");
			return;
		}
		
		var sAreaCodeInfo = sRetVal.split('@');
		var sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
		var sAreaCodeName = sAreaCodeInfo[1];//--������������
		setItemValue(0,0,"REGIONCODE",sAreaCodeValue);
		setItemValue(0,0,"REGIONCODENAME",sAreaCodeName);
		
	}
	
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
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
		
		AsControl.OpenView("/BusinessManage/RetailManage/RetailStoreList.jsp", "RSerialNo=<%=sRSerialNo %>", "_self","");
		
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		
		setItemValue(0,0,"InputOrg","<%=CurOrg.orgID%>");
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateOrg","<%=CurOrg.orgID%>");
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			var serialNo = getSerialNo("Store_Info","SerialNo");// ��ȡ��ˮ��
			setItemValue(0,getRow(),"SerialNo",serialNo);
			setItemValue(0,0,"InputOrg","<%=CurOrg.orgID%>");
			setItemValue(0, 0, "InputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
			
			setItemValue(0,0,"UpdateOrg","<%=CurOrg.orgID%>");
			setItemValue(0, 0, "UpdateOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
			bIsInsert = true;
		}
		setItemValue(0, 0, "Account", "<%=sAccount %>");
		setItemValue(0, 0, "AccountName", "<%=sAccountName %>");
		setItemValue(0, 0, "AccountBank", "<%=sAccountBank %>");
		setItemValue(0, 0, "PCategory", "<%=sPCategory %>");
		setItemValue(0, 0, "isindaccount", "<%=sIsindaccount%>");
		
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
