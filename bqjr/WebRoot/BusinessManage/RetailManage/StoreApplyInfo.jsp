<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
	String sSerialNo = CurPage.getParameter("SerialNo");
	if(sSerialNo==null) sSerialNo="";
	String sRSerailNo="";
	String sType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("type"));
	if(sType==null) sType="";
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "StoreApplyInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if((sType.equals("01")||sType.equals("04"))&&CurUser.hasRole("1005")){
	//doTemp.setReadOnly("", false);	
	}else{
	doTemp.setReadOnly("", true);	
	}
	
	//��ĳЩ�м���λû����������ʱ�������Ǳ�ѡ
	String city = Sqlca.getString("select city from STORE_INFO where SERIALNO = '"+sSerialNo+"'");
	if(city == null) city="";
	String sortNo = Sqlca.getString("select sortNo from code_library where codeno = 'AreaCode' and itemno='"+city+"'");
	if(sortNo == null) sortNo="";
	String count = Sqlca.getString("select count(1) FROM code_library WHERE codeno = 'AreaCode' "
			+ " AND isinuse = '1' AND sortno LIKE '"+sortNo+"%' AND sortno <> '"+sortNo+"'");
	int iCnt = Integer.parseInt(count);
	if(iCnt == 0){
		doTemp.setRequired("COUNTRYNAME", false);
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	doTemp.setHTMLStyle("BranchCodeName", "style={width=250px;");
	doTemp.setHTMLStyle("ACCOUNTBANK", "onchange=\"javascript:parent.clearBranchCode()\"");
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	// ����Ĭ��ֵ
	// ��ȡ�������ʺ���Ϣ,����������õ��ŵ���
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6����ݼ�	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{((sType.equals("01")||sType.equals("04"))&&CurUser.hasRole("1005"))?"true":"false","All","Button","����","���������޸�","saveRecord()","","","","btn_icon_save",""},
			{"true","","Button","����","�����б�ҳ��","goBack()","","","","",""},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	function saveRecord(sPostEvents){
		//-- add by �������ŵ�׼�����������Ż� tangyb 20151223 --//
		var sRegCode = getItemValue(0, 0, "REGCODE");//ע���
		if((!(typeof(sRegCode) == "undefined" || sRegCode.length == 0||sRegCode==null))&&sRegCode.substring(0,1)!="P"){
			setItemValue(0,getRow(),"REGCODE","P"+sRegCode);
		}
		//-- end --//
		
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();	
		if(!CheckRegCode()){
			return;
		}
		if(!CheckStoreName()){
			return;
		}

		//�����Ƿ�ί���տ�
		setIsEntrustedCollection();
			
		as_save("myiframe0",sPostEvents);
		
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function doSubmit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		
	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
	}
	
	//�����Ƿ�ί���տ�
	function setIsEntrustedCollection(){
		var RetailName = getItemValue(0, 0, "RetailName");
		var ACCOUNTNAME = getItemValue(0, 0, "ACCOUNTNAME");
		if(RetailName == ACCOUNTNAME){
			setItemValue(0, 0, "ISENTRUSTEDCOLLECTION", "2");
		}else{
			setItemValue(0, 0, "ISENTRUSTEDCOLLECTION", "1");
		}
	}
	
	function getPassedReatil() {
		var sParaString = "InputUser,<%=CurUser.getUserID()%>";
		// ��SelectPermitRetailSingle��ΪSelectPermitRetailSingle2  CCS-1276�̻��ŵ�׼�빦�ܸĽ�����
		var sRetVal = setObjectValue("SelectPermitRetailSingle2", sParaString, "", 0, 0,"");
		var sNetBank = getItemValue(0, 0, "ISNETBANK");
		if (typeof(sRetVal)=='undefined'||sRetVal=='_CLEAR_') {
			alert("��ѡ�������̣�");
			return;
		}
		
		var sRserialno = sRetVal.split("@")[0];
		setItemValue(0, 0, "RSERIALNO", sRserialno);
		setItemValue(0, 0, "RetailName", sRetVal.split("@")[1]);
		var sAccount=sRetVal.split("@")[2];
		var sAccountName=sRetVal.split("@")[3];
		var sAccountBank=sRetVal.split("@")[4];
		var sAccountbankCity=sRetVal.split("@")[5];
		var sBranchCode=sRetVal.split("@")[6];
		var sServiceFee=sRetVal.split("@")[7];//-- add by huzp CCS-1040 ���������̷���� 20160127 --//
		var sIsindaccount=sRetVal.split("@")[8]; //-- add by huzp CCS-1040 ���������̷���� 20160127 ��ԭ��7��Ϊ8��--//
		setItemValue(0, 0, "isindaccount", sIsindaccount);
		setItemValue(0, 0, "SERVICEFEE", sServiceFee);//-- add by huzp CCS-1040 ���������̷���� 20160127 --//
		//-- add by tangyb CCS-1040 ���������̷���� 20160125 --//
		//var sServiceFee = RunMethod("���÷���", "GetColValue", "retail_info, servicefee, serialno="+sRserialno);
		//setItemValue(0, 0, "SERVICEFEE", sServiceFee);
		//-- end --//
		
		if (sNetBank=="1") {
			setItemReadOnly(0,0,"BranchCodeName", true);
			setItemDisabled(0,getRow(),"ACCOUNTBANKCITYNAME",true);
			setItemDisabled(0,getRow(),"ACCOUNT",true);
			setItemDisabled(0,getRow(),"ACCOUNTNAME",true);
			setItemDisabled(0,getRow(),"ACCOUNTBANK",true);
			
			setItemValue(0, 0, "ACCOUNT", sAccount);
			setItemValue(0, 0, "ACCOUNTNAME", sAccountName);
			setItemValue(0, 0, "ACCOUNTBANK", sAccountBank);
			setItemValue(0, 0, "ACCOUNTBANKCITY", sAccountbankCity);
			setItemValue(0, 0, "BranchCode", sBranchCode);
			setItemValue(0, 0, "ACCOUNTBANKCITYNAME", RunMethod("���÷���", "GetColValue", "Code_library,ItemName, CodeNo='AreaCode' and Isinuse='1' and ItemNo="+sAccountbankCity));
			var sBranchCodeName = RunMethod("���÷���", "GetColValue", "bankput_info,bankname, bankno ="+sBranchCode);
			setItemValue(0, 0, "BranchCodeName", sBranchCodeName);
		} else if (sNetBank=="2") {
			setItemDisabled(0,getRow(),"ACCOUNTBANKCITYNAME",false);
			setItemDisabled(0,getRow(),"ACCOUNT",false);
			setItemDisabled(0,getRow(),"ACCOUNTNAME",false);
			setItemDisabled(0,getRow(),"ACCOUNTBANK",false);
			
			setItemReadOnly(0,0,"BranchCodeName", false);
			setItemValue(0,0,"ACCOUNT", "");
			setItemValue(0,0,"ACCOUNTNAME", "");
			setItemValue(0,0,"ACCOUNTBANK", "");
			setItemValue(0, 0, "ACCOUNTBANKCITY", "");
			setItemValue(0, 0, "ACCOUNTBANKCITYNAME", "");
			setItemValue(0, 0, "BranchCodeName", "");
		}
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

	//���ע�������ظ���
	
	function CheckRegCode(){
		var sRegcode = getItemValue(0,getRow(),"REGCODE");
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var company=getItemValue(0, getRow(), "company");
		//-- add by �������ŵ�׼�����������Ż� tangyb 20151223 --//
		sRegcode = sRegcode.replace(/\s+/g,"");
		setItemValue(0,0,"REGCODE",sRegcode);
		//-- end --//
		
		//�ŵ�ע��ű�����P��ͷ
		if(sRegcode.indexOf("P", 0) != 0){
			alert("�ŵ�ע��ű�����P��ͷ");
			return false;
		}
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			sSerialNo = " ";
		}
		if(typeof(company)=="undefined"|| company.length==0)
			{
			company="";
			}
		var sReturnRegcode = RunMethod("CustomerManage","SelectStoreRegcode",sRegcode+","+company+","+sSerialNo);
		if((!(typeof(sRegcode)=="undefined" || sRegcode.length==0))&&sReturnRegcode!=0.0){ // update tangyb
			alert("ע�����ҵ�������ڹ�˾�Ѵ��ڣ���������д��");
			return false;
		}
		return true;
			}
	
	//����ŵ����Ƶ��ظ���
	function CheckStoreName(){
		var sSname = getItemValue(0,getRow(),"SNAME");
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var company=getItemValue(0,getRow(),"company");
		//-- add by �������ŵ�׼�����������Ż� tangyb 20151223 --//
		sSname = sSname.replace(/\s+/g,"");
		setItemValue(0,0,"SNAME",sSname);
		//-- end --//
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			sSerialNo = " ";
		}
		if (typeof(company)=="undefined" || company.length==0) {
			company = " ";
		}
		var sReturnRegcode = RunMethod("���÷���","GetColValue","STORE_INFO,count(1),SNAME='"+sSname+"'and company='"+company+"' and serialno<>'"+sSerialNo+"'");
		if((!(typeof(sSname)=="undefined" || sSname.length==0))&&sReturnRegcode!="0.0"){
			alert("�ŵ�������ҵ�������ڹ�˾�Ѵ��ڣ���������д��");
			return false;
		}
		return true;
			}
	
	// ������̻��������ŵ�������Ϣ�����޸�
	function isNetBank() {
	
		var sNetBank = getItemValue(0, 0, "ISNETBANK");
		var sRSERIALNO=getItemValue(0, 0, "RSERIALNO");
		if(sRSERIALNO==""){
			alert("����ѡ��������");
			return;
		}
		var accoutInfo= RunMethod("���÷���", "selectRetailAccount", sRSERIALNO);
		var sAccount=accoutInfo.split("@")[1];
		var sAccountName=accoutInfo.split("@")[2];
		var sAccountBank=accoutInfo.split("@")[3];
		var sAccountbankCity=accoutInfo.split("@")[4];
		var sBranchCode=accoutInfo.split("@")[5];
		
		if (sNetBank=="1") {
			
			setItemReadOnly(0,0,"BranchCodeName", true);
			
			setItemDisabled(0,getRow(),"ACCOUNTBANKCITYNAME",true);
			setItemDisabled(0,getRow(),"ACCOUNT",true);
			setItemDisabled(0,getRow(),"ACCOUNTNAME",true);
			setItemDisabled(0,getRow(),"ACCOUNTBANK",true);
			
			
			setItemValue(0, 0, "ACCOUNT", sAccount);
			setItemValue(0, 0, "ACCOUNTNAME", sAccountName);
			setItemValue(0, 0, "ACCOUNTBANK", sAccountBank);
			setItemValue(0, 0, "ACCOUNTBANKCITY", sAccountbankCity);
			setItemValue(0, 0, "BranchCode", sBranchCode);
			setItemValue(0, 0, "ACCOUNTBANKCITYNAME", RunMethod("���÷���", "GetColValue", "Code_library,ItemName, CodeNo='AreaCode' and Isinuse='1' and ItemNo='sAccountbankCity'"));
			var sBranchCodeName = RunMethod("���÷���", "GetColValue", "bankput_info,bankname, bankno ='sBranchCode'");
			setItemValue(0, 0, "BranchCodeName", sBranchCodeName);
		} else if (sNetBank=="2") {
			setItemDisabled(0,getRow(),"ACCOUNTBANKCITYNAME",false);
			setItemDisabled(0,getRow(),"ACCOUNT",false);
			setItemDisabled(0,getRow(),"ACCOUNTNAME",false);
			setItemDisabled(0,getRow(),"ACCOUNTBANK",false);
			
			
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
	/*~[Describe=������ѡ��ѡ��������Ա;InputParam=��;OutPutParam=��;]~*/
	function selectSalesmanSingle() {
		
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
		setItemValue(0, 0, "SALESMANPHONE", sRetVal.split("@")[2]);
		setItemValue(0, 0, "SALESMANEMAIL", sRetVal.split("@")[5]+"@"+sRetVal.split("@")[6]);

		setItemValue(0, 0, "CITYMANAGERNAME", sRetVal.split("@")[4]);
		setItemValue(0, 0, "CITYMANAGER", sRetVal.split("@")[3]);
		
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
		//����ѡ�������Ҫ�������
		setItemValue(0, 0, "COUNTRY", ""); //��ֵ����
		setItemValue(0, 0, "COUNTRYNAME", ""); //��ֵ����
		
		var sStreet = getItemValue(0, 0, "STREET"); //�ֵ�
		if(sStreet == null || sStreet == 'undefined'){
			sStreet = "";
		}
		setItemValue(0, 0, "ADDRESS", sStreet); //�ŵ�����ַ 
		//var sSNo = RunJavaMethodSqlca("com.amarsoft.app.billions.GenerateSerialNo", "getStoreNo", "cityCode="+retVal.split("@")[0]);
		//setItemValue(0, 0, "SNO", sSNo);
		
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
		
		var sStreet = getItemValue(0, 0, "STREET"); //�ֵ�
		if(sStreet == null || sStreet == 'undefined'){
			sStreet = "";
		}
		setItemValue(0, 0, "ADDRESS", retVal.split("@")[1]+""+sStreet); //�̻������ַ 

	}
	
	/**
	 * ���������ͽֵ���ֵ�ŵ�����ַ 
	 */
	function setAddress(){
		var sCountry = getItemValue(0, 0, "COUNTRYNAME"); //����
		if(sCountry == null || sCountry == 'undefined'){
			sCountry = "";
		}

		var sStreet = getItemValue(0, 0, "STREET"); //�ֵ�
		if(sStreet == null || sStreet == 'undefined'){
			sStreet = "";
		}

		var sAddress = sCountry + sStreet; //�ŵ�����ַ 
		if(sAddress != null && sAddress != ""){
			setItemValue(0, 0, "ADDRESS", sAddress); //��ֵ����
		}
	}
	
	/*~[Describe=���������滮ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode1() {

		var sNetBank = getItemValue(0, 0, "ISNETBANK");
		if (sNetBank=="1") {
			return;
		}
		
		var retVal = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
			alert("��ѡ����Ҫѡ��ĳ��У�");
			return;
		}
		
		setItemValue(0, 0, "ACCOUNTBANKCITY", retVal.split("@")[0]);
		setItemValue(0, 0, "ACCOUNTBANKCITYNAME", retVal.split("@")[1]);

		//����ŵ�����˺ſ���֧��
		clearBranchCode();

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
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_" || sReturn.indexOf("undefined", 0) >= 0) return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		sBankNo=sReturn[0];//
		sBranch=sReturn[1];//

		setItemValue(0,0,"BranchCode",sBankNo);
		setItemValue(0,0,"BranchCodeName",sBranch);
	}
	
	//����ŵ�����˺ſ���֧��
	function clearBranchCode(){
		setItemValue(0,0,"BranchCode","");
		setItemValue(0,0,"BranchCodeName","");
	}
	
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			var serialNo = getSerialNo("Store_Info","SerialNo");// ��ȡ��ˮ��
			setItemValue(0,getRow(),"SERIALNO",serialNo);
			
			setItemValue(0,0,"STOREMAINCONTRACTPOSITION","�곤");
			setItemValue(0,0,"Status","01");
			setItemValue(0,0,"PrimaryApproveStatus","3");
			setItemValue(0,0,"AgreementApproveStatus","3");
			setItemValue(0,0,"SafDepApproveStatus","3");
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
			setItemValue(0, 0, "INPUTORGNAME", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
            setItemValue(0,0,"company","BQJR");
			
			setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
			setItemValue(0, 0, "UPDATEORGNAME", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			bIsInsert = true;
		}

		setItemDisabled(0,getRow(),"company",true);
		setItemDisabled(0,getRow(),"relative_sno",true);
		setItemRequired(0,0,"relative_sno",false);
		gCityManager = getItemValue(0, 0, "CITYMANAGER");
		gSalesManager = getItemValue(0, 0, "SALESMANAGER");

		//��ĳЩ�м���λû����������ʱ�������Ǳ�ѡ
		setCountryRequired();
	}

	$(document).ready(function() {
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2, 0, 'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
