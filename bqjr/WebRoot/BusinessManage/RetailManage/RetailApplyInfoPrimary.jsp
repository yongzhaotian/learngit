<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	System.out.print("------------"+sSerialNo);
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "RetailApproveInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setHRadioSql("PrimaryApproveStatus", "Select itemno,itemname from code_library  where codeno='PrimaryApproveStatus' and itemno in ('1','2') ");
	
	String sPrimaryApproveStatus = Sqlca.getString(new SqlObject("select PrimaryApproveStatus from RETAIL_INFO where Serialno= :Serialno").setParameter("Serialno", sSerialNo));
	if (sPrimaryApproveStatus == null) sPrimaryApproveStatus = "";
	if(sPrimaryApproveStatus.equals("4")){
	doTemp.setReadOnly("", true);	
	doTemp.setReadOnly("PrimaryApproveStatus,Remark,Refusereason", false);
	}
/* 	if(sPrimaryApproveStatus.equals("1")){
		doTemp.setRequired("RefuseReason",false);
		doTemp.setVisible("RefuseReason",false);
	}else if(sPrimaryApproveStatus.equals("2")){
		doTemp.setVisible("RefuseReason",true);
		doTemp.setRequired("RefuseReason",true);
	} */
		 
	     		 
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6����ݼ�	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","�ύ","�ύ�����޸�","saveRecord()","","","","btn_icon_save",""},
			{"false","All","Button","���沢����","���沢�����б�","saveAndGoBack()","","","","",""},
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
	
	function selectStatus(){
		var sPrimaryApproveStatus = getItemValue(0,getRow(),"PrimaryApproveStatus");
		if(sPrimaryApproveStatus=="1"){
			hideItem(0, 0, "RefuseReason");//����
			setItemValue(0, 0, "RefuseReason","");
			setItemRequired(0,0, "RefuseReason", false);
			}else if (sPrimaryApproveStatus=="2"){
				showItem(0, 0, "RefuseReason");//��ʾ
		        setItemRequired(0,0, "RefuseReason", true);
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
		var sStoreNum=getItemValue(0,0,"STORENUM");
		var sIsrelative = getItemValue(0,0,"ISRELATIVE");//add by clhuang 2015/05/14 CCS-432 ������,�ŵ�׼������������������
		
		if(sStoreNum=="0"){
			alert("�ֵ���������Ϊ0");
			return;
		}
		var sPrimaryApproveStatus = getItemValue(0,0,"PrimaryApproveStatus");
		if(sPrimaryApproveStatus=="4"){
			alert("��ѡ�����״̬��");
			return;
		}
		if (sIsSuper == '1' && sIsrelative =='1') {
			var sSuperNo = getItemValue(0, 0, "SUPERNO");
			if (typeof(sSuperNo)=='undefined' || sSuperNo.length==0) {
				alert("��ѡ���ϼ����̻���");
				return;
			}
		}
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		if(!vI_all("myiframe0")){
			return;
		}
		
		as_save("myiframe0",sPostEvents);
		selectStatus();
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
	
	function initRow(){
		setItemValue(0,0,"PrimaryApproveTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
		setItemValue(0,0,"PRIMARYAPPROVEPERSON","<%=CurUser.getUserID()%>");
		selectStatus();
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
			setItemValue(0,0,"UPDATEORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
			
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
