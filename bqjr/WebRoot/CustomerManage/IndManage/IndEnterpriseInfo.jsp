<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   sjchuan  2009-10-13
		Tester:
		Content: ���徭Ӫ����ҵ��Ϣ����ҳ��
		Input Param:
			  CustomerID:--�ͻ���
		Output param:
		History Log: 
           DATE	     CHANGER		CONTENT
	 */
	%>
<%/*~END~*/%> 


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���徭Ӫ����ҵ�ͻ���Ϣ�ſ�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sCustomerInfoTemplet = "";//--ģ������
    String sSql = "";//--���sql���
    String sCustomerType = "";//--��ſͻ�����   
    String sCustomerScale = "";//--��С�ͻ���ģ   
    String sItemAttribute = "" ;
	String sCertType = "",sCertID = "",sAttribute3 = "";
	ASResultSet rs = null;//-- ��Ž����
	
	//����������,�ͻ�����
    String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ȡ�ÿͻ�����
	sSql = "select CustomerType,CertType,CertID,CustomerScale from CUSTOMER_INFO where CustomerID = :CustomerID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(rs.next()){
		sCustomerType = rs.getString("CustomerType");
		sCertType = rs.getString("CertType");
		sCertID = rs.getString("CertID");
		sCustomerScale = rs.getString("CustomerScale");
	}
	rs.getStatement().close();
	
	if(sCustomerType == null) sCustomerType = "";
	if(sCertType == null) sCertType = "";
	if(sCertID == null) sCertID = "";	
	//ȡ����ͼģ������
	sSql = " select ItemAttribute,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = :ItemNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sCustomerType));
	if(rs.next()){
		sItemAttribute = DataConvert.toString(rs.getString("ItemAttribute"));		//�ͻ�������ͼ����
		sAttribute3 = DataConvert.toString(rs.getString("Attribute3"));		//��С��ҵ�ͻ�������ͼ����
	}
	rs.getStatement().close(); 
	
	if(sCustomerScale!=null&&sCustomerScale.startsWith("02")){
		//��˾�ͻ�������ʾģ��
		sCustomerInfoTemplet = sAttribute3;		//��С��˾�ͻ�������ʾģ��
	}else{
		//��˾�ͻ�������ʾģ��
		sCustomerInfoTemplet = sItemAttribute;		//��˾�ͻ�������ʾģ��
	}
	
	sCustomerInfoTemplet = "IndEnterpriseInfo11";
	if(sCustomerInfoTemplet == null) sCustomerInfoTemplet = "";
		
	if(sCustomerInfoTemplet.equals(""))
		throw new Exception("�ͻ���Ϣ�����ڻ�ͻ�����δ���ã�"); 
	sCustomerType = "01";
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = sCustomerInfoTemplet;	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//���ù��ڵ���ѡ��ʽ
	doTemp.appendHTMLStyle("RegionName"," style=\"cursor: pointer;\" onClick=\"javascript:parent.getRegionCode()\" ");	
	//����ע���ʱ���Χ
	doTemp.appendHTMLStyle("RegisterCapital"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ע���ʱ�������ڵ���0��\" ");
	//����ְ��������Χ
	doTemp.appendHTMLStyle("EmployeeNumber"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ְ������������ڵ���0��\" ");
	//����ʵ���ʱ���Χ
	doTemp.appendHTMLStyle("PaiclUpCapital"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ʵ���ʱ�������ڵ���0��\" ");
	//���þ�Ӫ���������ƽ���ף���Χ
	doTemp.appendHTMLStyle("WorkFieldArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ӫ���������ƽ���ף�������ڵ���0��\" ");
	//���ü�ͥ������(Ԫ)��Χ
	doTemp.appendHTMLStyle("FamilyMonthIncome"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͥ������(Ԫ)������ڵ���0��\" ");
	//���ø���������(Ԫ)��Χ
	doTemp.appendHTMLStyle("YearIncome"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����������(Ԫ)������ڵ���0��\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println(dwTemp.Name);
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","������Ӫ��ҵ","������Ӫ��ҵ","saveRecordTemp()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;
		beforeUpdate();						
		setItemValue(0,getRow(),'TempSaveFlag',"2");//�ݴ��־��1���ǣ�2����
		as_save("myiframe0",sPostEvents);		
	}
		
	function saveRecordTemp(){
		alert("����Ȩ������");	
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateOrgID","<%=CurOrg.getOrgID()%>");
		setItemValue(0,0,"UpdateOrgName","<%=CurOrg.getOrgName()%>");
		setItemValue(0,0,"UpdateUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck(){
		var sCustomerType = "01";
		if(sCustomerType == '01'){ //��˾�ͻ�
			//1��У��Ӫҵִ�յ������Ƿ�С��Ӫҵִ����ʼ��			
			var sLicensedate = getItemValue(0,getRow(),"Licensedate");//Ӫҵִ�յǼ���			
			var sLicenseMaturity = getItemValue(0,getRow(),"LicenseMaturity");//Ӫҵִ�յ�����
			var sToday = "<%=StringFunction.getToday()%>";//��ǰ����
			if(typeof(sLicensedate) != "undefined" && sLicensedate != "" && 
			typeof(sLicenseMaturity) != "undefined" && sLicenseMaturity != ""){
				if(sLicensedate >= sToday){
					alert(getBusinessMessage('132'));//Ӫҵִ�յǼ��ձ������ڵ�ǰ���ڣ�
					return false;		    
				}
				if(sLicenseMaturity <= sLicensedate){
					alert(getBusinessMessage('118'));//Ӫҵִ�յ����ձ�������Ӫҵִ�յǼ��գ�
					return false;		    
				}
			}
			//2��У�鵱���ڹ���(����)��Ϊ�л����񹲺͹�ʱ���ͻ�Ӣ�����Ʋ���Ϊ��			
			var sCountryTypeValue = getItemValue(0,getRow(),"CountryCode");//���ڹ���(����)
			var sEnglishName = getItemValue(0,getRow(),"EnglishName");//�ͻ�Ӣ������
			if(sCountryTypeValue != 'CHN'){
				if (typeof(sEnglishName) == "undefined" || sEnglishName == "" ){
					alert(getBusinessMessage('119')); //���ڹ���(����)��Ϊ�л����񹲺͹�ʱ���ͻ�Ӣ��������Ϊ�գ�
					return false;	
				}
			}
			//3��У����������
			var sOfficeZip = getItemValue(0,getRow(),"OfficeZIP");//��������
			if(typeof(sOfficeZip) != "undefined" && sOfficeZip != "" ){
				if(!CheckPostalcode(sOfficeZip)){
					alert(getBusinessMessage('120'));//������������
					return false;
				}
			}
			//4��У����ϵ�绰
			var sOfficeTel = getItemValue(0,getRow(),"OfficeTel");//��ϵ�绰	
			if(typeof(sOfficeTel) != "undefined" && sOfficeTel != "" ){
				if(!CheckPhoneCode(sOfficeTel)){
					alert(getBusinessMessage('121'));//��ϵ�绰����
					return false;
				}
			}
			//5��У�鴫��绰
			var sOfficeFax = getItemValue(0,getRow(),"OfficeFax");//����绰	
			if(typeof(sOfficeFax) != "undefined" && sOfficeFax != "" ){
				if(!CheckPhoneCode(sOfficeFax)){
					alert(getBusinessMessage('124'));//����绰����
					return false;
				}
			}
			//6��У�������ϵ�绰
			var sFinanceDeptTel = getItemValue(0,getRow(),"FinanceDeptTel");//������ϵ�绰	
			if(typeof(sFinanceDeptTel) != "undefined" && sFinanceDeptTel != "" ){
				if(!CheckPhoneCode(sFinanceDeptTel)){
					alert(getBusinessMessage('125'));//������ϵ�绰����
					return false;
				}
			}
			//7��У������ʼ���ַ
			var sEmailAdd = getItemValue(0,getRow(),"EmailAdd");//�����ʼ���ַ	
			if(typeof(sEmailAdd) != "undefined" && sEmailAdd != "" ){
				if(!CheckEMail(sEmailAdd)){
					alert(getBusinessMessage('130'));//��˾E��Mail����
					return false;
				}
			}
			
			//8��У�������
			var sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//������	
			if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" ){
				if(!CheckLoanCardID(sLoanCardNo)){
					alert(getBusinessMessage('101'));//����������							
					return false;
				}
				
				//���������Ψһ��
				var sCustomerName = getItemValue(0,getRow(),"EnterpriseName");//�ͻ�����	
				sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sCustomerName+","+sLoanCardNo);
				if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many"){
					alert(getBusinessMessage('227'));//�ô������ѱ������ͻ�ռ�ã�							
					return false;
				}						
			}
			
			//9:У�鵱�Ƿ����ű�׼���ſͻ�Ϊ��ʱ�����������ϼ���˾���ơ��ϼ���˾��֯����������ϼ���˾������
			var sECGroupFlag = getItemValue(0,getRow(),"ECGroupFlag");//�Ƿ����ű�׼���ſͻ�
			if(sECGroupFlag == '1'){ //�Ƿ����ű�׼���ſͻ���1���ǣ�2����
				var sSuperCorpName = getItemValue(0,getRow(),"SuperCorpName");//�ϼ���˾����
				var sSuperLoanCardNo = getItemValue(0,getRow(),"SuperLoanCardNo");//�ϼ���˾������
				var sSuperCertID = getItemValue(0,getRow(),"SuperCertID");//�ϼ���˾��֯��������
				if(typeof(sSuperCorpName) == "undefined" || sSuperCorpName == "" ){
					alert(getBusinessMessage('126'));
					return false;
				}
				if((typeof(sSuperLoanCardNo) == "undefined" || sSuperLoanCardNo == "") && 
					(typeof(sSuperCertID) == "undefined" || sSuperCertID == "") ){
					alert(getBusinessMessage('127'));
					return false;
				}
				//���¼�����ϼ���˾��֯�������룬����ҪУ���ϼ���˾��֯��������ĺϷ��ԣ�ͬʱ���ϼ���˾֤����������Ϊ��֯��������֤
				if(typeof(sSuperCertID) != "undefined" && sSuperCertID != "" ){
					if(!CheckORG(sSuperCertID)){
						alert(getBusinessMessage('128'));//�ϼ���˾��֯������������							
						return false;
					}
					setItemValue(0,getRow(),'SuperCertType',"Ent01");
				}
				//���¼�����ϼ���˾�����ţ�����ҪУ���ϼ���˾�����ŵĺϷ���
				if(typeof(sSuperLoanCardNo) != "undefined" && sSuperLoanCardNo != "" ){
					if(!CheckLoanCardID(sSuperLoanCardNo)){
						alert(getBusinessMessage('129'));//�ϼ���˾����������							
						return false;
					}
					
					//�����ϼ���˾������Ψһ��
					var sSuperCorpName = getItemValue(0,getRow(),"SuperCorpName");//�ϼ���˾�ͻ�����	
					sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sSuperCorpName+","+sSuperLoanCardNo);
					if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many"){
						alert(getBusinessMessage('228'));//���ϼ���˾�������ѱ������ͻ�ռ�ã�							
						return false;
					}						
				}
			}
		}
		
		if(sCustomerType == '02'){ //���ſͻ�
			//1��У�����ܿͻ�������ϵ�绰
			var sRelativeType = getItemValue(0,getRow(),"RelativeType");//���ܿͻ�������ϵ�绰
			if(typeof(sRelativeType) != "undefined" && sRelativeType != "" ){
				if(!CheckPhoneCode(sRelativeType)){
					alert(getBusinessMessage('223'));//���ܿͻ�������ϵ�绰����
					return false;
				}
			}
		}
		if(sCustomerType == '03'){ //���˿ͻ�
			//1:У��֤������Ϊ���֤����ʱ���֤ʱ�����������Ƿ�֤ͬ������е�����һ��
			var sCertType = getItemValue(0,getRow(),"CertType");//֤������
			var sCertID = getItemValue(0,getRow(),"CertID");//֤�����
			var sBirthday = getItemValue(0,getRow(),"Birthday");//��������
			if(typeof(sBirthday) != "undefined" && sBirthday != "" ){
				if(sCertType == 'Ind01' || sCertType == 'Ind08'){
					//�����֤�е������Զ�������������,�����֤�е��Ա𸳸��Ա�
					if(sCertID.length == 15){
						sSex = sCertID.substring(14);
						sSex = parseInt(sSex);
						sCertID = sCertID.substring(6,12);
						sCertID = "19"+sCertID.substring(0,2)+"/"+sCertID.substring(2,4)+"/"+sCertID.substring(4,6);
						if(sSex%2==0)//����żŮ
							setItemValue(0,getRow(),"Sex","2");
						else
							setItemValue(0,getRow(),"Sex","1");
					}
					if(sCertID.length == 18){
						sSex = sCertID.substring(16,17);
						sSex = parseInt(sSex);
						sCertID = sCertID.substring(6,14);
						sCertID = sCertID.substring(0,4)+"/"+sCertID.substring(4,6)+"/"+sCertID.substring(6,8);
						if(sSex%2==0)//����żŮ
							setItemValue(0,getRow(),"Sex","2");
						else
							setItemValue(0,getRow(),"Sex","1");
					}
					if(sBirthday != sCertID){
						alert(getBusinessMessage('200'));//�������ں����֤�еĳ������ڲ�һ�£�	
						return false;
					}
				}
				
				if(sBirthday < '1900/01/01'){
					alert(getBusinessMessage('201'));//�������ڱ�������1900/01/01��	
					return false;
				}
			}
			
			//2��У���ס��ַ�ʱ�
			var sFamilyZIP = getItemValue(0,getRow(),"FamilyZIP");//��ס��ַ�ʱ�
			if(typeof(sFamilyZIP) != "undefined" && sFamilyZIP != "" ){
				if(!CheckPostalcode(sFamilyZIP)){
					alert(getBusinessMessage('202'));//��ס��ַ�ʱ�����
					return false;
				}
			}
			
			//3��У��סլ�绰
			var sFamilyTel = getItemValue(0,getRow(),"FamilyTel");//סլ�绰	
			if(typeof(sFamilyTel) != "undefined" && sFamilyTel != "" ){
				if(!CheckPhoneCode(sFamilyTel)){
					alert(getBusinessMessage('203'));//סլ�绰����
					return false;
				}
			}
			
			//4��У���ֻ�����
			var sMobileTelephone = getItemValue(0,getRow(),"MobileTelephone");//�ֻ�����
			if(typeof(sMobileTelephone) != "undefined" && sMobileTelephone != "" ){
				if(!CheckPhoneCode(sMobileTelephone)){
					alert(getBusinessMessage('204'));//�ֻ���������
					return false;
				}
			}
			
			//5��У���������
			var sEmailAdd = getItemValue(0,getRow(),"EmailAdd");//��������	
			if(typeof(sEmailAdd) != "undefined" && sEmailAdd != "" ){
				if(!CheckEMail(sEmailAdd)){
					alert(getBusinessMessage('205'));//������������
					return false;
				}
			}
			
			//6��У��ͨѶ��ַ�ʱ�
			var sCommZip = getItemValue(0,getRow(),"CommZip");//ͨѶ��ַ�ʱ�
			if(typeof(sCommZip) != "undefined" && sCommZip != "" ){
				if(!CheckPostalcode(sCommZip)){
					alert(getBusinessMessage('206'));//ͨѶ��ַ�ʱ�����
					return false;
				}
			}
			
			//7��У�鵥λ��ַ�ʱ�
			var sWorkZip = getItemValue(0,getRow(),"WorkZip");//��λ��ַ�ʱ�
			if(typeof(sWorkZip) != "undefined" && sWorkZip != "" ){
				if(!CheckPostalcode(sWorkZip)){
					alert(getBusinessMessage('207'));//��λ��ַ�ʱ�����
					return false;
				}
			}
			
			//8��У�鵥λ�绰
			var sWorkTel = getItemValue(0,getRow(),"WorkTel");//��λ�绰	
			if(typeof(sWorkTel) != "undefined" && sWorkTel != "" ){
				if(!CheckPhoneCode(sWorkTel)){
					alert(getBusinessMessage('208'));//��λ�绰����
					return false;
				}
			}
			
			//8��У�鱾��λ������ʼ��
			var sWorkBeginDate = getItemValue(0,getRow(),"WorkBeginDate");//����λ������ʼ��
			var sToday = "<%=StringFunction.getToday()%>";//��ǰ����
			if(typeof(sWorkBeginDate) != "undefined" && sWorkBeginDate != "" ){
				if(sWorkBeginDate >= sToday){
					alert(getBusinessMessage('209'));//����λ������ʼ�ձ������ڵ�ǰ���ڣ�
					return false;
				}
				
				if(sWorkBeginDate <= sBirthday){
					alert(getBusinessMessage('210'));//����λ������ʼ�ձ������ڳ������ڣ�
					return false;
				}
			}						
		}
		return true;		
	}

    /*~[Describe=������ҵ����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectOrgType(){
		sParaString = "CodeNo"+",OrgType";		
		setObjectValue("SelectCode",sParaString,"@OrgType@0@OrgTypeName@1",0,0,"");
	}
	
	/*~[Describe=��������/����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCountryCode(){
		sParaString = "CodeNo"+",CountryCode";			
		sCountryCodeInfo = setObjectValue("SelectCode",sParaString,"@CountryCode@0@CountryCodeName@1",0,0,"");
		if (typeof(sCountryCodeInfo) != "undefined" && sCountryCodeInfo != ""  && sCountryCodeInfo != "_NONE_" 
		&& sCountryCodeInfo != "_CLEAR_" && sCountryCodeInfo != "_CANCEL_"){
			sCountryCodeInfo = sCountryCodeInfo.split('@');
			sCountryCodeValue = sCountryCodeInfo[0];//-- ���ڹ���(����)����
			if(sCountryCodeValue != 'CHN') //�����ڹ���(����)��Ϊ�л����񹲺͹�ʱ�������ʡ�ݡ�ֱϽ�С�������������
			{
				setItemValue(0,getRow(),"RegionCode","");
				setItemValue(0,getRow(),"RegionCodeName","");
			}
		}
	}
	
	/*~[Describe=�������õȼ�����ģ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCreditTempletType(){
		sParaString = "CodeNo"+",CreditTempletType";			
		setObjectValue("SelectCode",sParaString,"@CreditBelong@0@CreditBelongName@1",0,0,"");
	}
	
	/*~[Describe=������Ӧ���ֿ�ģ��ģ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectAnalyseType(sModelType){
		sParaString = "ModelType"+","+sModelType;			
		setObjectValue("selectAnalyseType",sParaString,"@CreditBelong@0@CreditBelongName@1",0,0,"");
	}
	/*~[Describe=����ʡ�ݡ�ֱϽ�С�������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode(flag){
		//�жϹ�����û��ѡ�й�
		var sCountryTypeValue = getItemValue(0,getRow(),"CountryCode");
		var sRegionInfo;
		if (flag == "ent"){
			if("01" == "01"){ //��˾�ͻ�Ҫ����ѡ���ڹ��һ��������ѡ�����ʡ��
				//�жϹ����Ƿ��Ѿ�ѡ��
				if (typeof(sCountryTypeValue) != "undefined" && sCountryTypeValue != "" ){
					if(sCountryTypeValue == "CHN"){
						sParaString = "CodeNo"+",AreaCode";			
						setObjectValue("SelectCode",sParaString,"@RegionCode@0@RegionCodeName@1",0,0,"");
					}else{
						alert(getBusinessMessage('122'));//��ѡ���Ҳ����й�������ѡ�����
						return;
					}
				}else{
					alert(getBusinessMessage('123'));//��δѡ����ң��޷�ѡ�����
					return;
				}
			}else{
				sParaString = "CodeNo"+",AreaCode";			
				setObjectValue("SelectCode",sParaString,"@RegionCode@0@RegionCodeName@1",0,0,"");
			}
		}else{ 	//������ҵ�ͻ�����������͸��˵ļ���
			sParaString = "CodeNo"+",AreaCode";			
			setObjectValue("SelectCode",sParaString,"@NativePlace@0@NativePlaceName@1",0,0,"");
		}
	}	
	
	/*~[Describe=����������ҵ����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getIndustryType(){
		//������ҵ��������м������������ʾ��ҵ����
		sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		if(sIndustryTypeInfo == "NO"){
			setItemValue(0,getRow(),"IndustryType","");
			setItemValue(0,getRow(),"IndustryTypeName","");
		}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != ""){
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];//-- ��ҵ���ʹ���
			sIndustryTypeName = sIndustryTypeInfo[1];//--��ҵ��������

			sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?IndustryTypeValue="+sIndustryTypeValue+"&rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
			if(sIndustryTypeInfo == "NO"){
				setItemValue(0,getRow(),"IndustryType","");
				setItemValue(0,getRow(),"IndustryTypeName","");
			}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != ""){
				sIndustryTypeInfo = sIndustryTypeInfo.split('@');
				sIndustryTypeValue = sIndustryTypeInfo[0];//-- ��ҵ���ʹ���
				sIndustryTypeName = sIndustryTypeInfo[1];//--��ҵ��������
				setItemValue(0,getRow(),"IndustryType",sIndustryTypeValue);
				setItemValue(0,getRow(),"IndustryTypeName",sIndustryTypeName);				
			}
		}
	}
	
	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getOrg(){
		setObjectValue("SelectAllOrg","","@OrgID@0@OrgName@1",0,0,"");
	}
	
	/*~[Describe=�����û�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getUser(){
		var sOrg = getItemValue(0,getRow(),"OrgID");
		sParaString = "BelongOrg,"+sOrg;	
		if (sOrg.length != 0 ){
			setObjectValue("SelectUserBelongOrg",sParaString,"@UserID@0@UserName@1",0,0,"");
		}else{
			alert(getBusinessMessage('132'));//����ѡ��ܻ�������
		}
	}
						
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		var sCountryCode = getItemValue(0,getRow(),"CountryCode");
		var sInputUserID = getItemValue(0,getRow(),"InputUserID");
		var sCreditBelong = getItemValue(0,getRow(),"CreditBelong");
		if (sCountryCode=="") //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			setItemValue(0,getRow(),"CountryCode","CHN");
			setItemValue(0,getRow(),"CountryCodeName","�л����񹲺͹�");
		}
		if (sInputUserID==""){
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
		}
		if("<%=sCustomerInfoTemplet%>" == "EnterpriseInfo03" && sCreditBelong == ""){
		    setItemValue(0,getRow(),"CreditBelong","011");			
			setItemValue(0,getRow(),"CreditBelongName","��ҵ���������ҵ��λ���õȼ�������");
		}
		
		sCustomerType = "<%=sCustomerType.substring(0,2)%>";
		var sCertType = getItemValue(0,0,"CertType");//--֤������
		var sCertID = getItemValue(0,0,"CertID");//--֤������
		if(sCustomerType == '03'){ //���˿ͻ�
			//�ж����֤�Ϸ���,�������֤����Ӧ����15��18λ��
			if(sCertType =='Ind01' || sCertType =='Ind08'){
				//�����֤�е������Զ�������������
				if(sCertID.length == 15){
					sCertID = sCertID.substring(6,12);
					sCertID = "19"+sCertID.substring(0,2)+"/"+sCertID.substring(2,4)+"/"+sCertID.substring(4,6);
					setItemValue(0,getRow(),"Birthday",sCertID);
				}
				if(sCertID.length == 18){
					sCertID = sCertID.substring(6,14);
					sCertID = sCertID.substring(0,4)+"/"+sCertID.substring(4,6)+"/"+sCertID.substring(6,8);
					setItemValue(0,getRow(),"Birthday",sCertID);
				}
			}
		}
    }
	
    //����String.replace���������ַ����������ߵĿո��滻�ɿ��ַ���
    function Trim (sTmp){
     	return sTmp.replace(/^(\s+)/,"").replace(/(\s+)$/,"");
    }
	
	//���� ��ҵ���͡�Ա�����������۶�ʲ��ܶ�ȷ����С��ҵ��ģ
	function EntScope(){
		/*
		����˵����
		�μ��ĵ���ͳ���ϴ���С����ҵ���ְ취�����У�������ͳ�ƾ����˾
		����������ָ���������ҵ���͡�Ա�����������۶�ʲ��ܶ�
		*/
		var sIndustryType = getItemValue(0,getRow(),"IndustryType");//��С��ҵ��ҵ
		var sLastYearSale = getItemValue(0,getRow(),"SellSum");//�����۶�
		var sCapitalAmount = getItemValue(0,getRow(),"TOTALASSETS");//�ʲ��ܶ�
		var sEmployeeNumber = getItemValue(0,getRow(),"EmployeeNumber");//Ա������
		if(typeof(sIndustryType)=="undefined" || sIndustryType.length==0)
			return;
		if(typeof(sLastYearSale)=="undefined" || sLastYearSale.length==0)
			return;
		if(typeof(sCapitalAmount)=="undefined" || sCapitalAmount.length==0)
			return;
		if(typeof(sEmployeeNumber)=="undefined" || sEmployeeNumber.length==0)
			return;
		if(sIndustryType.substring(0,1)=="B" || sIndustryType.substring(0,1)=="C"||sIndustryType.substring(0,1)=="D"){ //��ҵ����ҵ
			if(sEmployeeNumber>=2000&&sLastYearSale>=30000&&sCapitalAmount>=40000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<300||sLastYearSale<3000||sCapitalAmount<4000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="E"){ //����ҵ��ҵ
			if(sEmployeeNumber>=3000&&sLastYearSale>=30000&&sCapitalAmount>=40000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<600||sLastYearSale<3000||sCapitalAmount<4000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="H63"){ //����ҵ��ҵ
			if(sEmployeeNumber>=200&&sLastYearSale>=30000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<3000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="H65"){ //����ҵ��ҵ
			if(sEmployeeNumber>=500&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<1000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="F" && sIndustryType.substring(0,3)!="F59"&& sIndustryType.substring(0,3)!="F58"){ //��ͨ����ҵ��ҵ
			if(sEmployeeNumber>=3000&&sLastYearSale>=30000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<500||sLastYearSale<3000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="F59"){ //����ҵ��ҵ
			if(sEmployeeNumber>=1000&&sLastYearSale>=30000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<400||sLastYearSale<3000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="I"){ //ס�޺Ͳ���ҵ
			if(sEmployeeNumber>=800&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<400||sLastYearSale<3000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="A"){ //ũ��������ҵ
			if(sEmployeeNumber>=3000&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<500||sLastYearSale<1000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="F58"){ //�ִ���ҵ
			if(sEmployeeNumber>=500&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<1000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="K"){ //���ز���ҵ
			if(sEmployeeNumber>=200&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<1000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="J"){ //������ҵ
			if(sEmployeeNumber>=500&&sLastYearSale>=50000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<5000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="M78" ||sIndustryType.substring(0,1)=="N"){ //���ʿ����ˮ������������ҵ
			if(sEmployeeNumber>=2000&&sLastYearSale>=20000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<600||sLastYearSale<2000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="R"){ //���塢������ҵ
			if(sEmployeeNumber>=600&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<200||sLastYearSale<3000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="M"&&sIndustryType.substring(0,3)!="M78"){ //��Ϣ������ҵ
			if(sEmployeeNumber>=400&&sLastYearSale>=30000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<3000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="G"){ //��������������ҵ
			if(sEmployeeNumber>=300&&sLastYearSale>=30000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<3000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="L73"){ //������ҵ
			if(sEmployeeNumber>=300&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<1000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="L74"){ //���񼰿Ƽ�������ҵ
			if(sEmployeeNumber>=400&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<1000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="O"){ //���������ҵ
			if(sEmployeeNumber>=800&&sLastYearSale>=15000) { //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<200||sLastYearSale<1000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}else{ //������ҵ
			if(sEmployeeNumber>=500&&sLastYearSale>=15000){ //����
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<1000){ //С��
				setItemValue(0,getRow(),"Scope","03");
			}else{ //����
				setItemValue(0,getRow(),"Scope","02");
			}
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
	var bCheckBeforeUnload=false;	
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
