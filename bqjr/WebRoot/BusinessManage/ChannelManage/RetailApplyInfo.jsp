<%@page import="com.amarsoft.app.billions.CommonConstans"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "������׼������"; // ��������ڱ��� <title> PG_TITLE </title>
	
	// ���ҳ�����
	String sRSSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RSSerialNo"));
	String sRSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RSerialNo"));
	String sApplyType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	String sViewId = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ViewId"));
	String sPermitType=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PermitType"));
	String sModify =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Modify"));
	if (sRSSerialNo == null) sRSSerialNo = "";
	if (sRSerialNo == null) sRSerialNo = "";
	if (sApplyType == null) sApplyType = "";
	if (sViewId == null) sViewId = "";
	if (sPermitType == null) sPermitType = "";
	if(sModify == null) sModify = "";
	
	if (CommonConstans.ReTAILSTORE_APPROVE_TYPE.equals(sApplyType) || "02".equals(sViewId)) CurPage.setAttribute("RightType", "ReadOnly");
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "RetailInfo";//ģ�ͱ��
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);//���׶�������ģ��
	doTemp.setHTMLStyle("BranchCodeName", "style={width=250px;");
	doTemp.setHTMLStyle("ACCOUNTBANK", "style={width=250px;");
	doTemp.setHTMLStyle("RNAME", "style={width=250px;");
	doTemp.setHTMLStyle("ACCOUNTNAME", "style={width=250px;");
	
	// ����̻��Ѿ����ͨ�����������޸ĳ���
	String sRetialNo = Sqlca.getString(new SqlObject("SELECT RNO FROM RETAIL_INFO WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", sRSerialNo));
	if (sRetialNo != null) doTemp.setUnit("CITYNAME", "");
	
	//��ĳЩ�м���λû����������ʱ�������Ǳ�ѡ
		String city = Sqlca.getString("select city from RETAIL_INFO where SERIALNO = '"+sRSerialNo+"'");
		if(city == null) city="";
		String sortNo = Sqlca.getString("select sortNo from code_library where codeno = 'AreaCode' and itemno='"+city+"'");
		if(sortNo == null) sortNo="";
		String count = Sqlca.getString("select count(1) FROM code_library WHERE codeno = 'AreaCode' "
				+ " AND isinuse = '1' AND sortno LIKE '"+sortNo+"%' AND sortno <> '"+sortNo+"'");
		int iCnt = Integer.parseInt(count);
		if(iCnt == 0){
			doTemp.setRequired("COUNTY", false);
		}
	
	// ����Ĭ��ֵ
	
	//ҵ��������ĿPRM-657 �̻�/�ŵ��������Ϣ�޸�����
	if("N".equals(sModify) && !CurUser.hasRole("1705")){
		doTemp.setReadOnly("RNAME,REGCODE,LAWPERSON,LAWPERSONCARDNO", true);
	}

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	if(sPermitType.equals("02")){ 
		dwTemp.ReadOnly = "1";
	}else{
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	 }
	//����HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sRSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	
	 
	String	sButtons[][] = {
				{"true","","Button","����","�����¼","saveRecord()",sResourcesPath},
				
				{sPermitType.equals("02")?"false":"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath},
				{"false","","Button","����xxxx","�����б�Ҳ��","selectAreaInfo()",sResourcesPath},
			};
		
	
	
	
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=�������ʼ��Ϸ���;InputParam=��;OutPutParam=��;]~*/
	function checkEmail(obj) {
		var bEmail = CheckEMail(obj.value);
		
		var Letters = "@";
		//����ַ�����"@"�ַ���λ��
		
		var index=obj.value.indexOf(Letters) ;
			
		if (!bEmail) {
			alert("��������ȷ�ĵ������䣡");
			return;
		}
		
		if((((obj.value.charAt(index+1))=="q"&&(obj.value.charAt(index+2))=="q"))||(((obj.value.charAt(index+1))=="Q"&&(obj.value.charAt(index+2))=="Q"))||(((obj.value.charAt(index+1))=="q"&&(obj.value.charAt(index+2))=="Q"))||(((obj.value.charAt(index+1))=="Q"&&(obj.value.charAt(index+2))=="q"))){
			
			
			alert("����ʹ��QQ����");
			return false;
			
		}
	}
	/*~[Describe=ѡ����ϻ���Ӫ��Χ��ѡ;InputParam=��;OutPutParam=��;]~*/
	function getBizScope() {
		
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
		setItemValue(0, 0, "BUSINESSSCOPE", sCTypeIds.substring(0, sCTypeIds.length-1));
		setItemValue(0, 0, "BUSINESSSCOPENAME", SCTypeNames.substring(0, SCTypeNames.length-1));
		return;
	}
	
	/*~[Describe=ѡ���ϼ����̻�������ѡ;InputParam=��;OutPutParam=��;]~*/
	function selectSuperRetailSingle() {
		
		var sIsRelative = getItemValue(0, 0, "ISRELATIVE");
		if ("1" != sIsRelative) {
			alert("����ȷ���Ƿ��д��̻���ѡ���ǣ�");
			return ;
		}
		
		var sRetVal = setObjectValue("SelectPermitRetailSingle", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("��ѡ��Ҫѡ��Ĵ��̻���");
			return;
		}
		
		setItemValue(0, 0, "SUPERNO", sRetVal.split("@")[1]);
	}
	
	/*~[Describe=ѡ���ϼ����̻�������ѡ;InputParam=��;OutPutParam=��;]~*/
	function selectBankAccount() {
		alert("ѡ���˺ţ��Զ������˻����������˺�");
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
		
		//����ѡ�������Ҫ�������
		setItemValue(0, 0, "COUNTY", ""); //��ֵ����
		
		var street = getItemValue(0, 0, "STREET"); //�ֵ�
		if(street == null || street == 'undefined'){
			street = "";
		}
		setItemValue(0, 0, "ADDRESS", street); //�̻������ַ 

		//��ĳЩ�м���λû����������ʱ�������Ǳ�ѡ
		setCountryRequired();
	}
	
	//��ĳЩ�м���λû����������ʱ�������Ǳ�ѡ addby daihuafeng 20151014
	function setCountryRequired() {
		var city = getItemValue(0, 0, "CITY");
		if(typeof(city) == "undefined" || city.length == 0){
			setItemRequired(0,0,"COUNTY",true);
			return;
		}
		var cnt = RunMethod("BusinessManage", "CountAreaCode", city);
		var iCnt = parseInt(cnt);
		if(iCnt == 0){
			setItemRequired(0,0,"COUNTY",false);
		}else{
			setItemRequired(0,0,"COUNTY",true);
		}
	}
	
	/*��������Ϣ���̻������ַ����ӵ���һ����ѡ���*/
	//add by jshu
	function getRegionCodeforretail() {
		var retVal = setObjectValue("SelectCityCodeSingle for retail","","",0,0,"");
		if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
			alert("��ѡ����Ҫѡ��ĳ��У�");
			return;
		}
		
		setItemValue(0, 0, "ADDRESS", retVal.split("@")[0]);
		setItemValue(0, 0, "ADDRESSNAME", retVal.split("@")[1]);
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
	
	//�̻��˺ſ���֧��
	function selectBankCode(){
		var sOpenBank = getItemValue(0,0,"ACCOUNTBANK");
		var sCity     = getItemValue(0,0,"ACCOUNTBANKCITY");
		
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

	
	function CheckPhone(obj) {
		var ret = CheckPhoneCode(obj.value);
		if(!ret) {
			alert("����ĵ绰�����������������룡");
			obj.value = "";
			return;
		} 
	}
	
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	function saveRecord(sPostEvents){
		var sIsSuper = getItemValue(0, 0, "ISSUPER");
		var sAccountBankCity = getItemValue(0, 0, "ACCOUNTBANKCITY");
		var sAccount = getItemValue(0, 0, "ACCOUNT");
		var sAccountName = getItemValue(0, 0, "ACCOUNTNAME");
		var sAccountBank = getItemValue(0, 0, "ACCOUNTBANK");
		var sBranchCode = getItemValue(0, 0, "BranchCode");
		sRSerialNo="<%=sRSerialNo%>";
		var sStoreNum=getItemValue(0,0,"STORENUM");
		
		if(sStoreNum=="0"){
			alert("�ֵ���������Ϊ0");
			return;
		}
		/**update CCS-883 ȡ�������ϼ����̻����ϼ����̻��ֶ�ά�� tangyb 20150715
		if (sIsSuper == '1') {
			var sSuperNo = getItemValue(0, 0, "SUPERNO");
			if (typeof(sSuperNo)=='undefined' || sSuperNo.length==0) {
				alert("��ѡ���ϼ����̻���");
				return;
			}
		}*/
		
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		
		as_save("myiframe0",sPostEvents);
		
		//add   wlq    ͬʱ�޸��ŵ�֧����Ϣ   20140721  
		RunMethod("UpdateStore","GetUpdateStore",sAccountBankCity+","+sAccount+","+sAccountName+","+sAccountBank+","+sBranchCode+","+sRSerialNo);
		RunMethod("ModifyNumber","GetModifyNumber","store_info,UPDATEDATE='<%=StringFunction.getToday()%>', RSERIALNO='"+sRSerialNo+"' and ISNETBANK='1'");
	}
	
	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		
		setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
	}
	
	// ���ؽ����б�
	function goBack()
	{
		//AsControl.OpenView("/BusinessManage/ChannelManage/RetailStoreApplyList.jsp","","_self");
		self.close();
	}
	//�Ƿ���̻������ֹ�ѡ�񡰷񡱣������Ƿ����ϼ����̻����͡��ϼ����̻���ֱ��������ɻ�ɫ�����޷��ֶ����ĺ�ѡ��
	function isBigCheck(){
		var sIssuper=getItemValue(0,0,"ISSUPER");
		if(sIssuper=="2"){
			setItemDisabled(0,getRow(),"ISRELATIVE",true);
			setItemDisabled(0,getRow(),"SUPERNO",true);
		}else{
			setItemDisabled(0,getRow(),"ISRELATIVE",false);
			setItemDisabled(0,getRow(),"SUPERNO",false);
		
		}
		
	}
	
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,getRow(),"SERIALNO","<%=sRSSerialNo %>");
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
			setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
			
			
			setItemValue(0,0,"UPDATEORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
			
			bIsInsert = true;
		}

		//��ĳЩ�м���λû����������ʱ�������Ǳ�ѡ
		setCountryRequired();
    }
	
	/*add CCS-883 ����ѡ�� tangyb 20150716*/
	function getAddressCode() {
		var city = getItemValue(0, 0, "CITY");
		if(typeof(city)=="undefined" || city == null || city == ""){
			alert("����ѡ���̻����ڳ���");
			return;
		}
		
		var sortno = RunMethod("���÷���", "GetColValue", "code_library,sortno,codeno='AreaCode' and isinuse='1' and itemno='"+city+"'");

		var retVal = setObjectValue("SelectCityCodeSingle for retail1","SortNo,"+sortno,"",0,0,"");
		if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
			alert("��ѡ����Ҫѡ���������");
			return;
		}
		
		//setItemValue(0, 0, "ADDRESSCITY", retVal.split("@")[0]);
		setItemValue(0, 0, "COUNTY", retVal.split("@")[1]); //��ֵ����
		
		var street = getItemValue(0, 0, "STREET"); //�ֵ�
		if(street == null || street == 'undefined'){
			street = "";
		}
		setItemValue(0, 0, "ADDRESS", retVal.split("@")[1]+""+street); //�̻������ַ 

	}
	
	/**
	 * ���������ͽֵ���ֵ�̻������ַ 
	 */
	function setAddress(){
		var county = getItemValue(0, 0, "COUNTY"); //����
		if(county == null || county == 'undefined'){
			county = "";
		}

		var street = getItemValue(0, 0, "STREET"); //�ֵ�
		if(street == null || street == 'undefined'){
			street = "";
		}

		var address = county + street; //�̻������ַ 
		if(address != null && address != ""){
			setItemValue(0, 0, "ADDRESS", address); //��ֵ����
		}
	}
	/*add CCS-883 ѡ���̻������ַ tangyb 20150716 end*/

	</script>

<script language=javascript>
	bFreeFormMultiCol = true;
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	

<%@ include file="/IncludeEnd.jsp"%>
