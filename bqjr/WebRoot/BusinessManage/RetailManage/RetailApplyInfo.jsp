<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	System.out.print("------------"+sSerialNo);
	String sType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("type"));
	if(sType==null) sType="";
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "RetailInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//��ĳЩ�м���λû����������ʱ�������Ǳ�ѡ
	String city = Sqlca.getString("select city from RETAIL_INFO where SERIALNO = '"+sSerialNo+"'");
	if(city == null) city="";
	String sortNo = Sqlca.getString("select sortNo from code_library where codeno = 'AreaCode' and itemno='"+city+"'");
	if(sortNo == null) sortNo="";
	String count = Sqlca.getString("select count(1) FROM code_library WHERE codeno = 'AreaCode' "
			+ " AND isinuse = '1' AND sortno LIKE '"+sortNo+"%' AND sortno <> '"+sortNo+"'");
	int iCnt = Integer.parseInt(count);
	if(iCnt == 0){
		doTemp.setRequired("COUNTY", false);
	}
	
	
	if((sType.equals("01")||sType.equals("04"))&&CurUser.hasRole("1005")){
		doTemp.setReadOnly("relative_rno", true);
		doTemp.setRequired("relative_rno", false);
		//�����κβ���
	}else{
		doTemp.setReadOnly("", true);	
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6����ݼ�	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{((sType.equals("01")||sType.equals("04"))&&CurUser.hasRole("1005"))?"true":"false","","Button","����","���������޸�","saveRecord()","","","","btn_icon_save",""},
			//{"true","All","Button","���沢����","���沢�����б�","saveAndGoBack()","","","","",""},
			{"true","","Button","����","�����б�ҳ��","goBack()","","","","",""},
		};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		AsControl.OpenView("/FrameCase/ExampleList.jsp","","_self");
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
	
	//-- add by �̻��˻������̻��˺�ȥ�� tangyb 20151223 --//
	function checkAccount(){
		var sAccount = getItemValue(0,getRow(),"ACCOUNT");
		sAccount = sAccount.replace(/\s+/g,"");
		
		// CCS-1276 �̻��ŵ�׼�빦�ܸĽ�����     �����˺�ֻ����д����
		if (!/^[0-9]*$/.test(sAccount)) {
			alert("�����˺�ֻ������д����!");
			sAccount="";
		}
		
		setItemValue(0,0,"ACCOUNT",sAccount);
	}
	
	function checkAccountName(){
		var sAccountName = getItemValue(0,getRow(),"ACCOUNTNAME");
		sAccountName = sAccountName.replace(/\s+/g,"");
		setItemValue(0,0,"ACCOUNTNAME",sAccountName);
	}
	//-- end --//
	
	//����̻�ע�������ظ���	
	function CheckRegCode(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sRegcode = getItemValue(0,getRow(),"REGCODE");
		var company = getItemValue(0,getRow(),"company");
		//-- add by �̻��˻������̻��˺�ȥ�� tangyb 20151223 --//
		sRegcode = sRegcode.replace(/\s+/g,"");
		setItemValue(0,0,"REGCODE",sRegcode);
		//-- end --//
		
		//����̻�ע����Ƿ���R��ͷ
		if(sRegcode.indexOf("R", 0) != 0){
			alert("�̻�ע��ű�����R��ͷ");
			return false;
		}
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			sSerialNo = " ";
		}
		if (typeof(company)=="undefined" || company.length==0) {
			company = "";
		}
		var sReturnRegcode = RunMethod("CustomerManage","SelectRetailRegcode",sRegcode+","+company+","+sSerialNo);
		if((!(typeof(sRegcode)=="undefined" || sRegcode.length==0))&&sReturnRegcode!="0.0"){
			alert("ע�����ҵ�������ڹ�˾�Ѵ��ڣ���������д��");
			return false;
		}
		return true;
			}
	//����̻����Ƶ��ظ���
	function CheckRetailName(){
		var sRname = getItemValue(0,getRow(),"RNAME");
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var company = getItemValue(0,getRow(),"company");
		//-- add by �̻��˻������̻��˺�ȥ�� tangyb 20151223 --//
		sRname = sRname.replace(/\s+/g,"");
		setItemValue(0,0,"RNAME",sRname);
		//-- end --//
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			sSerialNo = " ";
		}
		if (typeof(company)=="undefined" || company.length==0) {
			company = "";
		}
		var sReturnRegcode = RunMethod("���÷���","GetColValue","RETAIL_INFO,count(1),RNAME='"+sRname+"'and company ='"+company+"' and serialno<>'"+sSerialNo+"'");
		if((!(typeof(sRname)=="undefined" || sRname.length==0))&&sReturnRegcode!="0.0"){
			alert("�̻�������ҵ�������ڹ�˾�Ѵ��ڣ���������д��");
			return false;
		}
		return true;
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
		
		//����̻��˺ſ���֧��
		clearBranchCode();

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
			alert("��ѡ����Ҫѡ�������");
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
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_" || sReturn.indexOf("undefined", 0) >= 0) return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		sBankNo=sReturn[0];//
		sBranch=sReturn[1];//

		setItemValue(0,0,"BranchCode",sBankNo);
		setItemValue(0,0,"BranchCodeName",sBranch);
	}
	
	//����̻��˺ſ���֧��
	function clearBranchCode(){
		setItemValue(0,0,"BranchCode","");
		setItemValue(0,0,"BranchCodeName","");
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
		var sStoreNum = getItemValue(0,0,"STORENUM");
		var sIsrelative = getItemValue(0,0,"ISRELATIVE");//add by clhuang 2015/05/14  CCS-432 ������,�ŵ�׼������������������

		if(typeof(sStoreNum) == undefined || sStoreNum == "undefined" || sStoreNum.length == 0
				|| sStoreNum=="" || sStoreNum == "0" || sStoreNum == "0.0" || sStoreNum == 0 
				|| sStoreNum == NaN || parseInt(sStoreNum)==NaN){
			alert("�ֵ���������Ϊ1");
			return;
		}
		
		//-- add by ע�������ĸ��"R" tangyb 20151223 --//
		var sRegCode = getItemValue(0, 0, "REGCODE");//ע���
		if((!(typeof(sRegCode) == "undefined" || sRegCode.length == 0||sRegCode==null))&&sRegCode.substring(0,1)!="R"){
			setItemValue(0,getRow(),"REGCODE","R"+sRegCode);
		}
		//-- end --//	
		
		/**update CCS-883 ȡ�������ϼ����̻����ϼ����̻��ֶ�ά�� tangyb 20150715
		if (sIsSuper == '1'  && sIsrelative =='1') {
			var sSuperNo = getItemValue(0, 0, "SUPERNO");
			if (typeof(sSuperNo)=='undefined' || sSuperNo.length==0) {
				alert("��ѡ���ϼ����̻���");
				return;
			}
		}*/
		if(!CheckLawPersonCardNo()){
			return;
		}
		if(!CheckRegCode()){
			return;
		}
		if(!CheckRetailName()){
			return;
		}
		
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		
		as_save("myiframe0",sPostEvents);
	}
	
	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		var serialNo = getSerialNo("Retail_Info", "SerialNo");
		setItemValue(0,getRow(),"SERIALNO",serialNo);
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
	
	function CheckLawPersonCardNo(sIdcard){
		var card = getItemValue(0,getRow(),"LAWPERSONCARDNO"); //���֤�����	
		if(card!=""||card.length!=0){
			if(!checkIdcard(card)){
				return false;
				//flag=false;
			}
			return true;
			}else{
				alert("���֤����Ϊ�գ�");
				return false;
			}
		}
	//���֤
	function checkIdcard(idcard){ 
			var Errors=new Array( 
								"��֤ͨ��!", 
								"���֤����λ������!", 
								"���֤����������ڳ�����Χ���зǷ��ַ�!", 
								"���֤����У�����!", 
								"���֤�����Ƿ�!" 
								); 
			var area={11:"����",12:"���",13:"�ӱ�",14:"ɽ��",15:"���ɹ�",21:"����",22:"����",23:"������",31:"�Ϻ�",32:"����",33:"�㽭",34:"����",35:"����",36:"����",37:"ɽ��",41:"����",42:"����",43:"����",44:"�㶫",45:"����",46:"����",50:"����",51:"�Ĵ�",52:"����",53:"����",54:"����",61:"����",62:"����",63:"�ຣ",64:"����",65:"�½�",71:"̨��",81:"���",82:"����",91:"����"} 
								 
			var idcard,Y,JYM; 
			var S,M; 
			var idcard_array = new Array(); 
			idcard_array     = idcard.split(""); 
			//alert(area[parseInt(idcard.substr(0,2))]);
			
			//�������� 
			if(area[parseInt(idcard.substr(0,2))]==null){
				alert(Errors[4]); 
				//setItemValue(0,0,"CertID","");
				//return Errors[4];
				return false;
			}
			 
			//��ݺ���λ������ʽ���� 
			
			switch(idcard.length){
			case 15: 
				if((parseInt(idcard.substr(6,2))+1900) % 4 == 0 || ((parseInt(idcard.substr(6,2))+1900) % 100 == 0 && (parseInt(idcard.substr(6,2))+1900) % 4 == 0 )){ 
					ereg=/^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$/;//���Գ������ڵĺϷ��� 
				}else{ 
					ereg=/^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$/;//���Գ������ڵĺϷ��� 
				} 
			 
				if(ereg.test(idcard)){
					alert(Errors[0]);
					//setItemValue(0,0,"CertID","");
					//return Errors[0]; 
					return true;
			        
				}else{ 
					alert(Errors[2]);
					//setItemValue(0,0,"CertID","");
					//return Errors[2];  
					return false;
				}
				break; 
			case 18: 
				//18λ��ݺ����� 
				//�������ڵĺϷ��Լ��  
				//��������:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9])) 
				//ƽ������:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8])) 
				if ( parseInt(idcard.substr(6,4)) % 4 == 0 || (parseInt(idcard.substr(6,4)) % 100 == 0 && parseInt(idcard.substr(6,4))%4 == 0 )){ 
					ereg=/^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$/;//����������ڵĺϷ���������ʽ 
				}else{
					ereg=/^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$/;//ƽ��������ڵĺϷ���������ʽ 
				} 
				if(ereg.test(idcard)){//���Գ������ڵĺϷ��� 
					//����У��λ 
					S  =  (parseInt(idcard_array[0]) + parseInt(idcard_array[10])) * 7 
						+ (parseInt(idcard_array[1]) + parseInt(idcard_array[11])) * 9 
						+ (parseInt(idcard_array[2]) + parseInt(idcard_array[12])) * 10 
						+ (parseInt(idcard_array[3]) + parseInt(idcard_array[13])) * 5 
						+ (parseInt(idcard_array[4]) + parseInt(idcard_array[14])) * 8 
						+ (parseInt(idcard_array[5]) + parseInt(idcard_array[15])) * 4 
						+ (parseInt(idcard_array[6]) + parseInt(idcard_array[16])) * 2 
						+  parseInt(idcard_array[7]) * 1  
						+  parseInt(idcard_array[8]) * 6 
						+  parseInt(idcard_array[9]) * 3 ; 
					Y    = S % 11; 
					M    = "F"; 
					JYM  = "10X98765432"; 
					M    = JYM.substr(Y,1);//�ж�У��λ 
					if(M == idcard_array[17]){
						return  Errors[0];		//���ID��У��λ 
					}else{
						alert(Errors[3]);
						//setItemValue(0,0,"CertID","");
						//return  Errors[3]; 
						return false;
			        }
				}else{
					alert(Errors[2]);
					//setItemValue(0,0,"CertID","");
					//return Errors[2]; 
					return false;
			    }
				break;
			default:
			    alert(Errors[1]);
			    //setItemValue(0,0,"CertID","");
				//return  Errors[1]; 
				return false;

				break;
			}	 

	}



	function initRow(){
		//setItemValue(0,0,"PrimaryApproveTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
		
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			
			as_add("myiframe0");//������¼
			//
		
			setItemValue(0,getRow(),"SERIALNO","<%=sSerialNo%>");
		
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
			
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
			setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"PrimaryApproveStatus","3");
			setItemValue(0,0,"AgreementApproveStatus","3");
			setItemValue(0,0,"SafDepApproveStatus","3");
			setItemValue(0,0,"company","BQJR");
			setItemValue(0,0,"UPDATEORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
			
			bIsInsert = true;
		}
		setItemDisabled(0,getRow(),"company",true);
		setItemDisabled(0,getRow(),"relative_rno",true);
		setItemReadonly(0,getRow(),"relative_rno",true);
		setItemRequired(0,0,"relative_rno",false);
		//��ĳЩ�м���λû����������ʱ�������Ǳ�ѡ
		setCountryRequired();
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
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
