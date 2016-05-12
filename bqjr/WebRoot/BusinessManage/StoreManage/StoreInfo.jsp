<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%

	/*
		Author:  
		Tester:
		Content: 
		Input Param:
		Output param:
		History Log: xswang 2015/06/19 CCS-863 PRM-451 �ŵ����������۾�����ֵ�����޸�
	*/

	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "�ŵ���Ϣ";

	// ���ҳ�����
	String sSSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SSerialNo"));
	String sStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Status"));
	String sFlag =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("sFlag"));
	String sModify=  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Modify"));

	if(sStatus == null) sStatus = "";
	if(sSSerialNo == null) sSSerialNo = "";
	if(sFlag == null) sFlag = ""; 
	if(sModify == null) sModify = ""; 
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "StoreInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setReadOnly("SALESMANAGERNAME", true);
	doTemp.setHTMLStyle("BranchCodeName", "style={width=250px;");
	doTemp.setHTMLStyle("ACCOUNTBANK", "style={width=250px;");
	doTemp.setHTMLStyle("SNAME", "style={width=250px;");
	doTemp.setHTMLStyle("RETAILNAME", "style={width=250px;");
	doTemp.setHTMLStyle("ACCOUNTNAME", "style={width=250px;");
	
	// ���ó��в����޸�
	String sStoreNo = Sqlca.getString(new SqlObject("SELECT SNO FROM STORE_INFO WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", sSSerialNo));
	if (sStoreNo !=null ) doTemp.setUnit("CITYNAME", "");
	
	//�ŵ�״̬Ϊ������͡���ʱ�رա��������޸ġ����۾����͡����о�����
	if("05".equals(sStatus) || "07".equals(sStatus)){
		doTemp.setUnit("SALESMANAGERNAME", "");
	}
	
	// ����Ĭ��ֵ
	// ��ȡ�������ʺ���Ϣ,����������õ��ŵ���
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select Account,AccountName,AccountBank,AccountbankCity,BranchCode,isindaccount from Retail_Info where SerialNo=(Select RSerialNo from Store_Info where SerialNo=:SerialNo) ").setParameter("SerialNo", sSSerialNo));
	String sAccount = "";
	String sAccountName = "";
	String sAccountBank = "";
	String sAccountbankCity = "";
	String sBranchCode = "";
	String sBranchCodeName = "";
	String sIsindaccount = "";
	if (rs.next()) {
		
		sAccount = rs.getString("Account");
		sAccountName = rs.getString("AccountName");
		sAccountBank = rs.getString("AccountBank");
		sAccountbankCity = rs.getString("AccountbankCity");
		sBranchCode = rs.getString("BranchCode");
		sIsindaccount = rs.getString("isindaccount");
		
		// if null set the value ""
		if (sAccount == null) sAccount = "";
		if (sAccountName == null) sAccountName = "";
		if (sAccountBank == null) sAccountBank = "";
		if (sAccountbankCity == null) sAccountbankCity = "";
		if (sBranchCode == null) sBranchCode = "";
		if (sIsindaccount == null) sIsindaccount = "";
		
		sBranchCodeName=Sqlca.getString(new SqlObject("select bankname from bankput_info where bankno =:bankno ").setParameter("bankno", sBranchCode));
		
		doTemp.setDefaultValue("ACCOUNT", sAccount);
		doTemp.setDefaultValue("ACCOUNTNAME", sAccountName);
		doTemp.setDefaultValue("ACCOUNTBANK", sAccountBank);
		doTemp.setDefaultValue("ACCOUNTBANKCITY", sAccountbankCity);
		doTemp.setDefaultValue("BranchCode", sBranchCode);
		doTemp.setDefaultValue("BranchCodeName", sBranchCodeName);
		doTemp.setDefaultValue("isindaccount", sIsindaccount);
	}
	rs.getStatement().close();
	
	//��ĳЩ�м���λû����������ʱ�������Ǳ�ѡ
	String city = Sqlca.getString("select city from STORE_INFO where SERIALNO = '"+sSSerialNo+"'");
	if(city == null) city="";
	String sortNo = Sqlca.getString("select sortNo from code_library where codeno = 'AreaCode' and itemno='"+city+"'");
	if(sortNo == null) sortNo="";
	String count = Sqlca.getString("select count(1) FROM code_library WHERE codeno = 'AreaCode' "
			+ " AND isinuse = '1' AND sortno LIKE '"+sortNo+"%' AND sortno <> '"+sortNo+"'");
	int iCnt = Integer.parseInt(count);
	if(iCnt == 0){
		doTemp.setRequired("COUNTRYNAME", false);
	}
		
	//ҵ��������ĿPRM-657 �̻�/�ŵ��������Ϣ�޸�����
	//�ŵ����ơ��Ƿ�����̻���������Ϣ���ŵ�����˺ſ����С��ŵ�����˺ſ���������ʡ�С��ŵ�����˺Ż������ŵ�����˺š��ŵ�����˺ſ���֧�У�
	if("N".equals(sModify) && !CurUser.hasRole("1705")){
		doTemp.setReadOnly("SNAME,ISNETBANK,ACCOUNTBANK,ACCOUNTBANKCITYNAME,ACCOUNTNAME,ACCOUNT,BranchCodeName", true);
		doTemp.setUnit("ACCOUNTBANKCITYNAME,BranchCodeName", "");
	}
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	
	//�ر�״̬������༭ update CCS-884 �ر�״̬���ر��水ť tangyb 20150720
	if(!"06".equals(sStatus)){
		dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	}else{
		dwTemp.ReadOnly = "1"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	}
	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath},
	};
	if("CountAndCheck".equals(sFlag)){
		dwTemp.ReadOnly = "1"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
		sButtons[0][0] ="false";
		sButtons[1][0] ="false";
		sButtons[2][0] ="false";

	}else{
		dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д

	}
	
	//add CCS-884 �ر�״̬���ر��水ť tangyb 20150720
	if("06".equals(sStatus)){
		sButtons[0][0]="false";
	}
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSSerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">

	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	var gCityManager = "";
	var gSalesManager = "";
	
		// ��ȡ���о���
		function getCityManager() {
			var sSNO = getItemValue(0, 0, "SNO");
			var oldManager = RunMethod("GetElement","GetElementValue","CITYMANAGER,store_info,SNO='"+sSNO+"'");
			if("<%=sStatus%>"!="05"){
				return;
			}
			if(typeof(oldManager)!='undefined' && oldManager.length!=0 && oldManager!=""){
				return;
			}
			
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
			
			var returnValue=RunJavaMethodSqlca("com.amarsoft.app.billions.StoreManagerRelativeCommon", "checkCityManager", "salesManager="+sUserId+",sNo="+sSNO);
			if(returnValue=="true"){
				alert("���ŵ������۴������Ѵ����������о���");
				setItemValue(0, 0, "CITYMANAGER", "");
				setItemValue(0, 0, "CITYMANAGERNAME", "");
			}
		}
		
		// ������̻��������ŵ�������Ϣ�����޸�
		function isNetBank() {
			var sNetBank = getItemValue(0, 0, "ISNETBANK");
			if (sNetBank=="1") {
				setItemReadOnly(0,0,"ACCOUNT", true);
				setItemReadOnly(0,0,"ACCOUNTNAME", true);
				setItemReadOnly(0,0,"ACCOUNTBANK", true);
				setItemReadOnly(0,0,"BranchCodeName", true);
				setItemValue(0, 0, "ACCOUNT", "<%=sAccount%>");
				setItemValue(0, 0, "ACCOUNTNAME", "<%=sAccountName%>");
				setItemValue(0, 0, "ACCOUNTBANK", "<%=sAccountBank%>");
				setItemValue(0, 0, "ACCOUNTBANKCITY", "<%=sAccountbankCity%>");
				setItemValue(0, 0, "BranchCode", "<%=sBranchCode%>");
				var sCityName = RunMethod("���÷���", "GetColValue", "Code_library,ItemName, CodeNo='AreaCode' and Isinuse='1' and ItemNo='<%=sAccountbankCity%>'");
				var sBranchCodeName = RunMethod("���÷���", "GetColValue", "bankput_info,bankname, bankno ='<%=sBranchCode%>'");

				if (sCityName == "Null") sCityName = "";
				if (sBranchCodeName == "Null") sBranchCodeName = "";
				setItemValue(0, 0, "ACCOUNTBANKCITYNAME", sCityName);
				setItemValue(0, 0, "BranchCodeName", sBranchCodeName);
			} else if (sNetBank=="2") {
				setItemReadOnly(0,0,"ACCOUNT", false);
				setItemReadOnly(0,0,"ACCOUNTNAME", false);
				setItemReadOnly(0,0,"ACCOUNTBANK", false);
				setItemReadOnly(0,0,"BranchCodeName", false);
				setItemValue(0,0,"ACCOUNT", "");
				setItemValue(0,0,"ACCOUNTNAME", "");
				setItemValue(0,0,"ACCOUNTBANK", "");
				setItemValue(0, 0, "ACCOUNTBANKCITY", "");
				setItemValue(0, 0, "ACCOUNTBANKCITYNAME", "");
				setItemValue(0, 0, "BranchCodeName", "");
			}
		}
		
		// ���ʹ���̻����������ó�Ĭ��ֵ����������������ó�ֻ��
		function setBankDefValue() {
			var sNetBank = getItemValue(0, 0, "ISNETBANK");
			if (sNetBank=="1") {
				setItemValue(0, 0, "ACCOUNTBANK", "<%=sAccountBank%>");
			}
		}
		
	
		/*~[Describe=������ѡ��ѡ��������Ա;InputParam=��;OutPutParam=��;]~*/
		function selectSalesmanSingle() {
			var sSNO = getItemValue(0, 0, "SNO");
			//var oldManager = RunMethod("GetElement","GetElementValue","salesmanager,store_info,SNO='"+sSNO+"'");
			//alert("sSNO: "+sSNO+"\noldManager : "+oldManager);
			
			/*update ���۾���δ�������ݿ�֮ǰ�����޸�ѡ�� tangyb 20150804 start
			//add by xswang 2015/06/19 CCS-863 PRM-451 �ŵ����������۾�����ֵ�����޸�
			var sSalesManagerName = getItemValue(0, 0, "SALESMANAGERNAME");
			if(sSalesManagerName != "" && sSalesManagerName.length != 0 && typeof(sSalesManagerName) != 'undefined'){
				return;
			}
			//end by xswang 2015/06/19
			*/
			var salesmanager = RunMethod("���÷���", "GetColValue", "store_info, salesmanager, sno='"+ sSNO+"'");
			if(salesmanager != null && salesmanager != "" && typeof(salesmanager) != 'undefined'){
				return;
			}
			/*--update tangyb end--*/
			
			/*
			if(typeof(oldManager)!='undefined' && oldManager.length!=0 && oldManager!=""){
				return;
			}
			*/
			var sCity = getItemValue(0, 0, "CITY");
			if (typeof(sCity)=="undefined" || sCity.length==0) {
				alert("����ѡ���ŵ����ڳ��У�");
				return;
			}
			var sRetVal = setObjectValue("SelectSalesmanSingleByCity1", "City,"+ sCity, "", 0, 0, "");
			
			if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
				return;
			}
			
			setItemValue(0, 0, "SALESMANAGER", sRetVal.split("@")[0]);
			setItemValue(0, 0, "SALESMANAGERNAME", sRetVal.split("@")[1]);
			setItemValue(0, 0, "SALESPHONE", sRetVal.split("@")[2]);
			setItemValue(0, 0, "CITYMANAGER", sRetVal.split("@")[3]);
			setItemValue(0, 0, "CITYMANAGERNAME", sRetVal.split("@")[4]);
			var email = sRetVal.split("@")[5] + "@" + sRetVal.split("@")[6];
			setItemValue(0, 0, "EMAIL", email);
			return;
		}
		
	/*~[Describe=������ѡ��ѡ����Ʒ����;InputParam=��;OutPutParam=��;]~*/
	function selectProductCategoryMulti() {
		var sRetVal = setObjectValue("SelectProductCategoryMulti", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			//alert("��ѡ����Ʒ���룡");
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
			//alert("��ѡ������Ʒ�ƣ�");
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
			//alert("��ѡ����Ҫѡ��ĳ��У�");
			return;
		}
		
		setItemValue(0, 0, "CITY", retVal.split("@")[0]);
		setItemValue(0, 0, "CITYNAME", retVal.split("@")[1]);
		var sSNo = RunJavaMethodSqlca("com.amarsoft.app.billions.GenerateSerialNo", "getStoreNo", "cityCode="+retVal.split("@")[0]);
		setItemValue(0, 0, "SNO", sSNo);

		//����ѡ�������Ҫ�������
		setItemValue(0, 0, "COUNTRY", ""); //��ֵ����
		setItemValue(0, 0, "COUNTRYNAME", ""); //��ֵ����
		//��ĳЩ�м���λû����������ʱ�������Ǳ�ѡ
		setCountryRequired();
	}

	//��ĳЩ�м���λû����������ʱ�������Ǳ�ѡ addby daihuafeng 20151014
	function setCountryRequired() {
		var city = getItemValue(0, 0, "CITY");
		if(typeof(city) == "undefined" || city.length == 0){
			setItemRequired(0,0,"COUNTRYNAME",true);
			return;
		}
		var cnt = RunMethod("BusinessManage", "CountAreaCode", city);
		var iCnt = parseInt(cnt);
		if(iCnt == 0){
			setItemRequired(0,0,"COUNTRYNAME",false);
		}else{
			setItemRequired(0,0,"COUNTRYNAME",true);
		}
	}
	
	
	//ѡ���ŵ�����ַ	
	function getAddressCode() {
		var sCity = getItemValue(0,0,"CITY");
		if(typeof(sCity) =="undefined" || sCity == null || sCity ==""){
			alert("����ѡ���ŵ����ڳ��У�");
			return;
		}
		
		var sSortNo = RunMethod("���÷���", "GetColValue", "code_library,sortno,codeno='AreaCode' and isinuse='1' and itemno='"+sCity+"'");
		
		var retVal = setObjectValue("SelectCityCodeSingle for retail1","SortNo,"+sSortNo,"",0,0,"");
		if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
			alert("��ѡ����Ҫѡ�������");
			return;
		}
		setItemValue(0, 0, "COUNTRY", retVal.split("@")[0]); //��ֵ����
		setItemValue(0, 0, "COUNTRYNAME", retVal.split("@")[1]); //��ֵ����
		
	}
	
	/*~[Describe=���������滮ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode1() {
		
		var retVal = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
			alert("��ѡ����Ҫѡ��ĳ��У�");
			return;
		}
		
		setItemValue(0, 0, "ACCOUNTBANKCITY", retVal.split("@")[0]);
		setItemValue(0, 0, "ACCOUNTBANKCITYNAME", retVal.split("@")[1]);

	}
	
	//�ŵ�����˺ſ���֧��
	function selectBankCode(){
		var sOpenBank = getItemValue(0,0,"ACCOUNTBANK");
		var sCity     = getItemValue(0,0,"ACCOUNTBANKCITY");
		var sNetBank = getItemValue(0, 0, "ISNETBANK");
		if (sNetBank=="1") {
			return;
		}
		
		if(sCity=="" ||sOpenBank==""){
			alert("��ѡ�񿪻����л�ʡ�У�");
			return;
		}
		
		sCompID = "SelectWithholdList";
		sCompURL = "/CreditManage/CreditApply/SelectWithholdList.jsp";
		sParaString="OpenBank="+sOpenBank+"&City="+sCity;
		
		sReturn = popComp(sCompID,sCompURL,sParaString,"dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		sBankNo=sReturn[0];//
		sBranch=sReturn[1];//

		setItemValue(0,0,"BranchCode",sBankNo);
		setItemValue(0,0,"BranchCodeName",sBranch);
	}
	
	function saveRecord(sPostEvents){
		
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
		
		/* 
		var curCityManager = getItemValue(0, 0, "CITYMANAGER");
		var curSalesManager = getItemValue(0, 0, "SALESMANAGER");
		var sSNo = getItemValue(0, 0, "SNO");
		
		
		if (curCityManager.length>0) { // �ı��˳��о���
			RunMethod("���÷���", "UpdateColValue", "User_Info,SuperId,"+curCityManager+",UserId='"+curSalesManager+"'");
		}
		
		if (curSalesManager.length>0) { // �ı������۾���
			RunMethod("���÷���", "UpdateColValue", "User_Info,SuperId,"+curSalesManager+",UserId in (select SalesmanNo from storerelativesalesman where SNo is not null and SNo='"+sSNo+"')");
		}
		*/
		
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		
		//AsControl.OpenView("/BusinessManage/StoreManage/StoreList.jsp", "", "_self","");
		top.close();
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
			bIsInsert = true;
		}
		
		setItemValue(0, 0, "isindaccount", "<%=sIsindaccount%>");
		var sNetBank = getItemValue(0, 0, "ISNETBANK");
		if (sNetBank=="1") {
			setItemReadOnly(0,0,"ACCOUNT", true);
			setItemReadOnly(0,0,"ACCOUNTNAME", true);
			setItemReadOnly(0,0,"ACCOUNTBANK", true);
			setItemValue(0, 0, "ACCOUNT", "<%=sAccount%>");
			setItemValue(0, 0, "ACCOUNTNAME", "<%=sAccountName%>");
			setItemValue(0, 0, "ACCOUNTBANK", "<%=sAccountBank%>");
			setItemValue(0, 0, "ACCOUNTBANKCITY", "<%=sAccountbankCity%>");
			setItemValue(0, 0, "BranchCode", "<%=sBranchCode%>");
			var sCityName =  RunMethod("���÷���", "GetColValue", "Code_library,ItemName, CodeNo='AreaCode' and Isinuse='1' and ItemNo='<%=sAccountbankCity%>'");
			var sBranchCodeName = RunMethod("���÷���", "GetColValue", "bankput_info,bankname, bankno ='<%=sBranchCode%>'");
			if (sCityName == "Null") sCityName = "";
			if (sBranchCodeName=="Null") sBranchCodeName = "";
			setItemValue(0, 0, "BranchCodeName", sBranchCodeName);
			setItemValue(0, 0, "ACCOUNTBANKCITYNAME", sCityName);
		}
		
		// ��ȡ���о������۾���
		gCityManager = getItemValue(0, 0, "CITYMANAGER");
		gSalesManager = getItemValue(0, 0, "SALESMANAGER");
		var sREBATETYPE = getItemValue(0, 0, "REBATETYPE");
		var sREBATEUNIT = getItemValue(0, 0, "REBATEUNIT");
		var sISREBATEMERCHANT = getItemValue(0, 0, "ISREBATEMERCHANT");
		var sREBATEMERCHANT = getItemValue(0, 0, "REBATEMERCHANT");
		var sMONTHREBATEMERCHAN = getItemValue(0, 0, "MONTHREBATEMERCHAN");
		var sQUARTERREBATEMERCHAN = getItemValue(0, 0, "QUARTERREBATEMERCHAN");
		var sYEARREBATEMERCHAN = getItemValue(0, 0, "YEARREBATEMERCHAN");
		if (typeof(sREBATETYPE)=="undefined" || sREBATETYPE.length==0) {
			setItemValue(0, 0, "REBATETYPE", "001");
		}
		if (typeof(sREBATEUNIT)=="undefined" || sREBATEUNIT.length==0) {
			setItemValue(0, 0, "REBATEUNIT", "002");
		}
		if (typeof(sISREBATEMERCHANT)=="undefined" || sISREBATEMERCHANT.length==0) {
			setItemValue(0, 0, "ISREBATEMERCHANT", "2");
		}
		if (typeof(sREBATEMERCHANT)=="undefined" || sREBATEMERCHANT.length==0) {
			setItemValue(0, 0, "REBATEMERCHANT", "002");
		}
		if (typeof(sMONTHREBATEMERCHAN)=="undefined" || sMONTHREBATEMERCHAN.length==0) {
			setItemValue(0, 0, "MONTHREBATEMERCHAN", "001");
		}
		if (typeof(sQUARTERREBATEMERCHAN)=="undefined" || sQUARTERREBATEMERCHAN.length==0) {
			setItemValue(0, 0, "QUARTERREBATEMERCHAN", "001");
		}
		if (typeof(sYEARREBATEMERCHAN)=="undefined" || sYEARREBATEMERCHAN.length==0) {
			setItemValue(0, 0, "YEARREBATEMERCHAN", "001");
		}  
		
		//��ĳЩ�м���λû����������ʱ�������Ǳ�ѡ
		setCountryRequired();
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