<%@page import="com.amarsoft.app.util.RoleAuthController"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   --cchang  2004.12.2
		Tester:
		Content: --�ͻ��ſ�
		Input Param:
			  CustomerID:--�ͻ���
		Output param:
		History Log: 
           DATE	     CHANGER		CONTENT
           2005.7.25 fbkang         �°汾�ĸ�д
		   2005.9.10 zywei         �ؼ���� 
		   2005.12.15 jbai
		   2006.10.16 fhuang       �ؼ����
		   2009.10.12 pwang        �� �ı�ҳ����漰�ͻ������жϵ����ݡ�
		   2009.10.27 sjchuan	        ҳ����Ĭ����ʾ��ҵ��ģ
		   2015/07/13 jiangyuanlin CCS-890
	 */
	%>
<%/*~END~*/%> 


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ��ſ�"; // ��������ڱ��� <title> PG_TITLE </title>
	//CurComp.setAttribute("RightType", "All");
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sCustomerInfoTemplet = "";//--ģ������
    String sSql = "";//--���sql���
    String sCustomerType = "";//--��ſͻ�����   
    String sCustomerOrgType = "";//--��Ż�������
    String sScope = "";//add by sjchuan 2009-10-27 �����ҵ��ģ
    String sItemAttribute = "" ;
    String sTempSaveFlag = "" ;//�ݴ��־
	String sCertType = "",sCertID = "",sAttribute3 = "";
	ASResultSet rs = null;//-- ��Ž����
	
	//����������,�ͻ�����
    String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
    String sTypes =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Types"));//����Ŵ�ҵ�񲹵�ʱ�Ŀͻ������types
    String sRightType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));//
    
    //��ͬ���
    String sObjectNo = CurARC.getAttribute("BQContractNo");
    if(null == sObjectNo) sObjectNo = "";
    //��������
    String sProductID = Sqlca.getString("select ProductID from Business_Contract where SerialNo = '"+sObjectNo+"' and CustomerID = '"+sCustomerID+"' ");
    if(null == sProductID) sProductID = "";
    
    //add CCS-150 ��¼ÿ����ͬ�Ŀͻ�������Ϣ
    String sContractStatus = Sqlca.getString("select ContractStatus from Business_Contract where SerialNo = '"+sObjectNo+"' and CustomerID = '"+sCustomerID+"' ");
    if(null == sContractStatus) sContractStatus = "";
    //end
    
   /*  // ��ȡ��ǰ��ͬ���
    String sBQContractNo = CurARC.getAttribute("BQContractNo");
    if (sBQContractNo == null) sBQContractNo = "";
    // ��ȡ��ͬ״̬
    String sContractStatus = Sqlca.getString(new SqlObject("SELECT CONTRACTSTATUS from BUSINESS_CONTRACT where SERIALNO=:ObjectNo").setParameter("ObjectNo", sBQContractNo));
    if (!"060".equals(sContractStatus)) CurComp.setAttribute("RightType", "ReadOnly"); */
    //System.out.println("----------------------------"+sCustomerID);
    
	if(sCustomerID == null) sCustomerID = "";
	if(sTypes == null) sTypes = "";
	if (sRightType==null) sRightType = "";
	//���ҳ�����	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ȡ�ÿͻ�����
	sSql = "select CustomerType,CertType,CertID from CUSTOMER_INFO where CustomerID = :CustomerID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(rs.next()){
		sCustomerType = rs.getString("CustomerType");
		sCertType = rs.getString("CertType");
		sCertID = rs.getString("CertID");
	}
//	rs.getStatement().close();
	if(sCustomerType == null) sCustomerType = ""; 
	if(sCertType == null) sCertType = "";
	if(sCertID == null) sCertID = "";
	
	//ȡ�ÿͻ�����
	sSql = "select OrgNature,Scope from ENT_INFO where CustomerID = :CustomerID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(rs.next()){
		sCustomerOrgType = rs.getString("OrgNature");
		sScope = rs.getString("Scope");	//add sjchuan 2009-10-27 ȡ����ҵ��ģ
	}
//	rs.getStatement().close();
	
	// ��ȡ�ͻ�¼���ͬ�ŵ����ڳ���
//	String sNo = CurARC.getAttribute(request.getSession().getId()+"city");
	String sNo= CurUser.getAttribute8();
	System.out.println(sNo+"------------------------");
	if (sNo == null) {
		sNo = "";
	}
	
	String sStoreCity = Sqlca.getString(new SqlObject("select City from Store_Info where SNo=:SNo").setParameter("SNo", sNo));
	if (sStoreCity == null) sStoreCity = "";
	String isInNearCity = Sqlca.getString(new SqlObject("select StoreCity from NearCity_Info where StoreCity=:StoreCity").setParameter("StoreCity", sStoreCity));
	if (isInNearCity == null) isInNearCity = "";
	// ��ȡ��ǰ�ͻ�¼���ͬ�ŵ����ڳ�������
	String sStoreCityName = Sqlca.getString(new SqlObject("select ITEMNAME from CODE_LIBRARY where CODENO = 'AreaCode' and ITEMNO = :ITEMNO").setParameter("ITEMNO", sStoreCity));
	if (sStoreCityName == null) sStoreCityName = "";
	
	//add by clhuang 2015/04/22 CCS-703 PRM-333 ���Ѵ�ũ��ĵ�λ�绰��Ϊѡ��
	String sHeadShip="";
	sSql = "select HeadShip from ind_info where CustomerID = :CustomerID";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(rs.next()){
		sHeadShip = rs.getString("HeadShip");
		}
	if(sHeadShip == null) sHeadShip = "";
	//end by clhuang 2015/04/22
	//ȡ����ͼģ������
	if(sCustomerType.equals("03")){ //�������ڿͻ���Ϣģ��
		//sSql = " select ItemAttribute,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerOrgType' and ItemNo = :ItemNo ";
		sSql = " select ItemAttribute,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = :ItemNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sCustomerType));
	}
	if(sCustomerType.equals("04")){//�Թ�
		sSql = " select ItemAttribute,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = :ItemNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sCustomerType));
	}
	if (sCustomerType.equals("05")){//��˾
		sSql = " select ItemAttribute,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = :ItemNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sCustomerType));
	}
    if (sCustomerType.equals("0310")){ //���ѽ��ڿͻ���Ϣģ��
		sSql = " select ItemAttribute,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = :ItemNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sCustomerType));
	}
    if (sCustomerType.equals("0330")){ //С��ҵ���ͻ���Ϣģ��
		sSql = " select ItemAttribute,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = :ItemNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sCustomerType));
	}
	if(rs.next()){ 
		sItemAttribute = DataConvert.toString(rs.getString("ItemAttribute"));		//������ҵ�ͻ�������ͼ����		
	    sAttribute3 = DataConvert.toString(rs.getString("Attribute3"));		        //��С��ҵ�ͻ�������ͼ����
	}
	rs.getStatement().close(); 
	
	String sSubProductType = "";//��Ʒ������ // �����������ж�ģ�� quliangmao
	String education="select SubProductType from Business_Contract  where SerialNo=:SerialNo";
	ASResultSet educationrs = Sqlca.getASResultSet(new SqlObject(education).setParameter("SerialNo",sObjectNo));
  	if(educationrs.next()){ 
  		sSubProductType=DataConvert.toString(educationrs.getString("SubProductType"));
  		if(null==sSubProductType) sSubProductType = "";//add CCS-820 �����ֽ�������л��ѡ��ͻ��鿴�ͻ����鱨�� by rqiao 20150514
 	}
  	educationrs.getStatement().close();  
 	if("5".equals(sSubProductType)){//��ѧ����
 		sItemAttribute="IndividualEducationInfo1";
	} 
 	if("4".equals(sSubProductType)){//�ǳ��˴�
 		sItemAttribute="IndividualEducationInfo2";
	} 
 	if( "7".equals(sSubProductType) ){	//ѧ�����Ѵ�
 		sItemAttribute="StuPosCustomerInfo";
 	}
	String smallBusinessApplyType = "";//���ݺ�ͬid��ѯApplyType(С��ҵ��)
	String smallBusinessApply="select ApplyType from FLOW_OBJECT  where ObjectNo=:SerialNo";
	ASResultSet smalleducationrs = Sqlca.getASResultSet(new SqlObject(smallBusinessApply).setParameter("SerialNo",sObjectNo));
  	if(smalleducationrs.next()){ 
  		smallBusinessApplyType=DataConvert.toString(smalleducationrs.getString("ApplyType"));
  		if(null==smallBusinessApplyType) smallBusinessApplyType = "";//add CCS-820 �����ֽ�������л��ѡ��ͻ��鿴�ͻ����鱨�� by rqiao 20150514
 	}
  	smalleducationrs.getStatement().close();  
  	if("SmallBusinessApply".equals(smallBusinessApplyType)){
  		sItemAttribute="SmallCustomerInfo";//С��ҵ��
  	}
  	
	if(sItemAttribute == null) sItemAttribute = "";	
	if(sAttribute3 == null) sAttribute3 = "";	
	if(sCustomerType.equals("0120")){
		if(sTypes.equals("Reinforce")){ //��Ϊ���ǿͻ�ʱ����С��˾�ͻ���������ʾģ��EnterpriseInfoInput11
			sCustomerInfoTemplet="EnterpriseInfoInput11";
		}else{
			sCustomerInfoTemplet = sAttribute3;	
		}
	}else
		sCustomerInfoTemplet = sItemAttribute;	//�����ͻ�������ʾģ��
		
	if(sCustomerInfoTemplet == null) sCustomerInfoTemplet = "";
	if(sCustomerInfoTemplet.equals(""))
		throw new Exception("�ͻ���Ϣ�����ڻ�ͻ�����δ���ã�"); 
	
	if(sCustomerType.substring(0,2).equals("03") || sCustomerType.equals("03")){ //���˿ͻ�
		sSql = "select TempSaveFlag from IND_INFO where CustomerID = :CustomerID ";
	}else{ //��˾�ͻ����Թ�
		sSql = "select TempSaveFlag from ENT_INFO where CustomerID = :CustomerID ";
	}
	sTempSaveFlag = Sqlca.getString(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(sTempSaveFlag == null) sTempSaveFlag = "";
	
	//add by clhuang 2015/05/04 CCS-718 PRM-342 ���Ѵ�ѧ����Ʒ�����̶�ѡ������
	//��ȡ��ͬ�Ĳ�Ʒ����
	String sBusinessType = Sqlca.getString(new SqlObject("select businesstype from business_contract where serialno= :serialno").setParameter("serialno",sObjectNo));
	//update CCS-820 �����ֽ�������л��ѡ��ͻ��鿴�ͻ����鱨�� by rqiao 20150514
	if(null==sBusinessType) sBusinessType = "";
	if(!"".equals(sBusinessType))
	{
		sBusinessType = sBusinessType.substring(0, 2);//��ȡ�ַ���ǰ��λ
	}
	//end
	//end by clhung 2015/05/04
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = sCustomerInfoTemplet;	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setHTMLStyle("Marriage", "onClick=\"javascript:parent.selectMarriage()\";style={background=\"#EEEEff\"}");
	
	if(sCertType.equals("Ind01") || sCertType.equals("Ind08")){
		//doTemp.setReadOnly("Sex,Birthday",true);
	}	
	//add by jgao1 ���֤��������Ӫҵִ�գ�������֤�������ֶ� 2009-11-2
	if(sCertType.equals("Ent02")){
		doTemp.setVisible("CorpID",false);
		doTemp.setReadOnly("LicenseNo",true);
	}
	//add by phe 2015/05/15 CCS-639 �ֻ�������֤����У�������ϸ˵��
	String sPhoneNum = "";//��ȡԭ�����ֻ�����
	String sCELLPHONEVERIFY = "";//��ȡԭ����У����
	sSql = "select PHONEVALIDATE,CELLPHONEVERIFY from ind_info where CustomerID = :CustomerID";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(rs.next()){
		sPhoneNum = rs.getString("PHONEVALIDATE");
		sCELLPHONEVERIFY = rs.getString("CELLPHONEVERIFY");
		}
	if(sPhoneNum == null) sPhoneNum = "";
	if(sCELLPHONEVERIFY == null) sCELLPHONEVERIFY = "";
	//rs.getStatement().close();
	//end by phe 2015/05/15
	
	
	//add by clhuang 2015/05/04 CCS-718 PRM-342 ���Ѵ�ѧ����Ʒ�����̶�ѡ������
	//�жϲ�Ʒ�����Ƿ����ԡ�XS����ͷ
	String sql = "";
	if(sBusinessType.equals("XS")){

		sql = "select itemno,itemname from code_library where itemno in('5','6','7') and codeno='EducationExperience'";
	}else{	

		sql = "select itemno,itemname from code_library where codeno='EducationExperience' and isinuse='1'";
	}

	doTemp.setDDDWSql("EduExperience", sql);//����ģ�����ʾ��Դ
	//end by clhuang 2015/05/04 
	
	//add by clhuang 2015/04/22 CCS-703 PRM-333 ���Ѵ�ũ��ĵ�λ�绰��Ϊѡ��
	//aad by clhuang 2015/07/29 CCS-1006 �Ե����ũ��ͻ���λ�绰����Ϊ�Ǳ���
	//update by dahl 2015/08/18 CCS-1008 �ض����У����Ѵ�ũ��ĵ�λ�绰��Ϊѡ���ض����У����Ѵ�ũ��ĵ�λ�绰��Ϊѡ��
	String sPilotC = Sqlca.getString("SELECT 1 FROM pilot_city pc where pc.subproducttype='0' and pc.verifytype='C' and pc.city='"+sStoreCity+"' ");
	if(sHeadShip.equals("10")&&"1".equals(sPilotC)){
		doTemp.setRequired("WorkTel", false);
		}
	//end by clhuang 2015/04/22
	
	//add by dahl 20150804 ccs-993 ���ض������£����Ѵ������е�λ�绰��Ϊ�Ǳ�����
	String sPilotB = Sqlca.getString("SELECT 1 FROM pilot_city pc where pc.subproducttype='0' and pc.verifytype='B' and pc.city='"+sStoreCity+"' ");
    if("1".equals(sPilotB)){
    	doTemp.setRequired("WorkTel", false);
    }
	// end by dahl
	
	//���ؿͻ�������Ϣ
	
	//��admin,������Ӫ��������۽�ɫ�����ܲ鿴����ƻ�
 	//if(CurUser.hasRole("1008") || CurUser.getUserID().equals("admin")){
 		
 	//}else{
	//	doTemp.setVisible("CertID",false);
 	//}
	RoleAuthController rac = new RoleAuthController(doTemp, CurUser.getRoleTable(), "QueryCustomerInfo", Sqlca, "01");
	rac.roleAuthCtrl("DONO", null);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	
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
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	var sReturnMessageCode="";
	var wait=60;
	//---------------------���尴ť�¼�------------------------------------

		
	//����ѧ����ѧУ��Ϣ��student_school_info�� add by dahl ccs-733
	function addStudentCchoolInfo(){
		var customerId = "<%=sCustomerID%>";
		var schoolName = getItemValue(0,getRow(),"school_name");
		var schoolCollege = getItemValue(0,getRow(),"school_college");
		var schoolDepartment = getItemValue(0,getRow(),"school_department");
		var schoolProfessionalName = getItemValue(0,getRow(),"school_professional_name");
		var schoolClass = getItemValue(0,getRow(),"school_class");
		var schoolStudentNo = getItemValue(0,getRow(),"school_student_no");
		var schoolLearning = getItemValue(0,getRow(),"school_learning");
		var schoolStatusStudent = getItemValue(0,getRow(),"school_status_student");
		var schoolDegreeCategory = getItemValue(0,getRow(),"school_Degree_category");
		var schoolLength = getItemValue(0,getRow(),"school_length");
		var schoolLevel = getItemValue(0,getRow(),"school_level");
		var schoolDormitoryTelephone = getItemValue(0,getRow(),"school_dormitory_telephone");
		var schoolCounselorTelephone = getItemValue(0,getRow(),"school_counselor_telephone");
		var schoolEnrollmentDate = getItemValue(0,getRow(),"school_enrollment_date");
		var schoolExpectedDate = getItemValue(0,getRow(),"school_expected_date");
		var schoolAddress = getItemValue(0,getRow(),"school_address");
		var schoolTownship = getItemValue(0,getRow(),"school_township");
		var schoolStreet = getItemValue(0,getRow(),"school_street");
		var schoolCommunity = getItemValue(0,getRow(),"school_community");
		var schoolRoomNo = getItemValue(0,getRow(),"school_room_no");
		
		var params = "customerId="+customerId+",schoolName="+schoolName+",schoolCollege="+schoolCollege+",schoolDepartment="+schoolDepartment+",schoolProfessionalName="+schoolProfessionalName+",schoolClass="+schoolClass+",schoolStudentNo="+schoolStudentNo+",schoolLearning="+schoolLearning+",schoolStatusStudent="+schoolStatusStudent+",schoolDegreeCategory="+schoolDegreeCategory+",schoolLength="+schoolLength+",schoolLevel="+schoolLevel+",schoolDormitoryTelephone="+schoolDormitoryTelephone+",schoolCounselorTelephone="+schoolCounselorTelephone+",schoolEnrollmentDate="+schoolEnrollmentDate+",schoolExpectedDate="+schoolExpectedDate+",schoolAddress="+schoolAddress+",schoolTownship="+schoolTownship+",schoolStreet="+schoolStreet+",schoolCommunity="+schoolCommunity+",schoolRoomNo="+schoolRoomNo;
		
		RunJavaMethodSqlca("com.amarsoft.proj.action.CheckCustomerInfo", "updateStudentCchoolInfo", params);
	}
	
	function getSchoolAddress(){
        var sAreaCodeInfo = "";
			sAreaCodeInfo = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		//������չ��ܵ��ж�
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"school_address","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
					sAreaCodeName = sAreaCodeInfo[1];//--������������
					setItemValue(0,getRow(),"school_address",sAreaCodeValue);
					setItemValue(0,getRow(),"school_addressName",sAreaCodeName);
			}
		}
	 }
	
  	/***************��������**********quliangmao********/
	function setAgeEdu(){
		var sIdentityId   = getItemValue(0,0,"CertID");
		var myDate=new Date(); 
		   var thisYear = myDate.getFullYear(); 
		   var thisMonth = myDate.getMonth()+1; 
		   var thisDay = myDate.getDate(); 
		   var age = myDate.getFullYear() - sIdentityId.substring(6, 10) - 1;
		   if (sIdentityId.substring(10, 12) < thisMonth || sIdentityId.substring(10, 12) == thisMonth && sIdentityId.substring(12, 14) <= thisDay) { 
			   age++; 
			 }
			 setItemValue(0,0,"age",age);
	}  
	/* function afterUpdate(){
		var sCustomerID=getItemValue(0,0,"CustomerID");
		var sWorkTelAreaCode=getItemValue(0,0,"WorkTelAreaCode");
		var sWorkTelMain=getItemValue(0,0,"WorkTelMain");
		var sWorkTel=sWorkTelAreaCode+sWorkTelMain;
		RunMethod("CustomerManage","UpdateWorkTel",sWorkTel+","+sCustomerID);
	} */
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=��ʾ��λ��ʾ;InputParam=��;OutPutParam=��;]~*/
	function showTitle(obj){
		obj.title="����д�ͻ��Ĺ�����λȫ�ƣ�                                     "+
			"* ��������д���徭Ӫ��λ���ƣ�"+
			"* ѧ������д�Ͷ�ѧУ���������ƣ�"+
			"* ũ��Ħ�г�����������дFM+��ʶ�����˵��м�ͥ�̶��绰�Ĳ���ͬһ������˵���������λ������ȷ����д����Ϊ��FM+����������FM�������ô��绰����˳��Ϊ�������˱��� - ���������� - �������ھӻ����ѣ���������";
	}
	/*~[Describe=�칫�绰��ʾ;InputParam=��;OutPutParam=��;]~*/
	function showTitle2(obj){
		obj.title="����Ϊ�������ֹ�����λ�ĵ�λ�绰������ȡ�÷ֻ�����"+
			"* �������ڡ���λ�绰����д�������ڵص绰��"+
			"* ѧ�����ڡ���λ�绰����д��ѧУ�绰��Ժϵ�绰��"+
			"* ũ��Ħ�г����������ڡ���λ�绰����д������������д���˵ļ�ͥ�̶��绰����������";
	}
	/*~[Describe=��ַ������֤;InputParam=��;OutPutParam=��;]~*/
	function checkAddress(obj){
		var sValue=obj.value;
		if(typeof(sValue) == "undefined" || sValue.length==0){
			return false;
		}
		if(!(/^[a-zA-Z0-9\u2E80-\uFE4F-#()����\/]+$/.test(sValue))){                        
			if(sValue!='*'){      //����Ϣ��ͳһ����*
			alert("��ַ����Ƿ�");
			obj.focus();
			return false;
			}
		}else if((sValue.indexOf("��")!=-1)||(sValue.indexOf("��")!=-1)){
			alert("��ַ����Ƿ�");
			obj.focus();
			return false;
		}
	}
	/*~[Describe=�籣������֤;InputParam=��;OutPutParam=��;]~*/
	function checkSino(obj){
		var sSino=getItemValue(0,getRow(),"Sino");
		if(typeof(sSino) == "undefined" || sSino.length==0){
			return false;
		}
		if(!(/^[A-Za-z0-9]+$/.test(sSino))){
			alert("�籣��/ѧ��֤���ֻ�������ֺ���ĸ");
			obj.focus();
			return false;
		}
	}
	/*~[Describe=��λ������֤;InputParam=��;OutPutParam=��;]~*/
	function checkWorkCorp(obj){
		var sWorkCorp=getItemValue(0, getRow(), "WorkCorp");
		if(typeof(sWorkCorp) == "undefined" || sWorkCorp.length==0){
			return false;
		}
		if(!(/^[a-zA-Z0-9\u4e00-\u9fa5]+$/.test(sWorkCorp))){
			alert("��λ��������Ƿ�");
			obj.focus();
			return false;
		}
	}
	
	//У����������벻��С�ڵ���0
	function checkSelfMonthIncome(obj){
		var sSelfMonthIncome=getItemValue(0,getRow(),"SelfMonthIncome");
		if(typeof(sSelfMonthIncome) == "undefined" || sSelfMonthIncome.length==0){
			return false;
		}
		if(parseFloat(sSelfMonthIncome)<=0){
			alert("����������������0��");
			obj.focus();
			return false;
		}
		
	}
	
	/*~[Describe=����������֤;InputParam=��;OutPutParam=��;]~*/
	function checkDepartment(obj){
		var sDepartment=getItemValue(0,getRow(),"EmployRecord");
		if(typeof(sDepartment) == "undefined" || sDepartment.length==0){
			return false;
		}
		if(!(/^([a-zA-Z0-9\u4e00-\u9fa5])+$/.test(sDepartment))){
			alert("��ְ��������Ƿ�");
			obj.focus();
			return false;
		}
	}
	/*~[Describe=����������֤;InputParam=��;OutPutParam=��;]~*/
	function checkName(obj){
		var sName=obj.value;
		if(typeof(sName) == "undefined" || sName.length==0 ){
			return false;
		}else{
			
		if(/\s+/.test(sName)){
			alert("�������пո�����������");
			obj.focus();
			return false;
		}
		//�������������Ļ�����ĸ
		if(!(/^[\u4e00-\u9fa5]{2,7}$|^[a-zA-Z]{1,30}$/.test(sName))){
			    if(!(/^([\u4e00-\u9fa5]+|[a-zA-Z]+)��([\u4e00-\u9fa5]+|[a-zA-Z]+)$/.test(sName))){
				alert("��������Ƿ�");
				obj.focus();
				return false;
			    }
			}
		 }
	}
	/*~[Describe=��Ů��Ŀ��֤;InputParam=��;OutPutParam=��;]~*/
	function checkChildNum(obj){
		var sChildrentotal=obj.value;
		if(typeof(sChildrentotal) == "undefined" || sChildrentotal.length==0){
			return false;
		}
		
		if(!(/^[0-9]+$/.test(sChildrentotal))){
			alert("�������Ů��Ŀֻ��������0-10");
			obj.focus();
			return false;
		}
		var num=parseInt(sChildrentotal);
		if(num>10||num<0){
			alert("�������Ů��Ŀֻ��������0-10");
			obj.focus();
			return false;
		} 
	}
	/*~[Describe=����/�ڶ�/����Ӫҵʱ����֤;InputParam=��;OutPutParam=��;]~*/
	function checkWorkDate(obj){
		var sWorkDate=getItemValue(0,getRow(),"JobTime");
		if(typeof(sWorkDate) == "undefined" || sWorkDate.length==0){
			return false;
		}
		var num=parseInt(sWorkDate);
		if(sWorkDate<1){
			alert("ʱ�䲻��һ����");
			obj.focus();
			return false;
		}
	
	}
	/*~[Describe=�����֤;InputParam=��;OutPutParam=��;]~*/
	function checkMoney(obj){
		var sValue=obj.value;
		var num=parseInt(sValue);
		if(num<0){
			alert("���������С����");
			obj.focus();
		}
	}
	/*~[Describe=ǩ֤������֤;InputParam=��;OutPutParam=��;]~*/
	function checkInstitution(obj){
		var sInstitution=getItemValue(0,getRow(),"Issueinstitution");
		if(typeof(sInstitution) == "undefined" || sInstitution.length==0){
			return false;
		}
		if(!(/^([a-zA-Z0-9\u4e00-\u9fa5])+$/.test(sInstitution))){
			alert("ǩ����������Ƿ�");
			obj.focus();
			return false;
		}
	}
	/*~[Describe=��������֤;InputParam=��;OutPutParam=��;]~*/
	function checkMaturityDate(){
		var sInputDate="<%=StringFunction.getToday()%>";
	    var days1=sInputDate.split("/");
        var now1=days1[0]+days1[1]+days1[2];
        var current1=parseInt(now1);
        var sMaturityDate=getItemValue(0,getRow(),"MaturityDate");
        var days2=sMaturityDate.split("/");
        var now2=days2[0]+days2[1]+days2[2];
        var current2=parseInt(now2);
        if(current1>=current2){
        	alert("��֤���ѵ���");
        	return false;
        }
       return true;
	}
	/*~[Describe=�ֻ�������֤;InputParam=��;OutPutParam=��;]~*/
	function checkMobile(obj){
	    var sMobile = obj.value;
	    if(typeof(sMobile) == "undefined" || sMobile.length==0){
	    	alert("�ֻ����벻�ܿ�");
	    	return false;
	    }
	    if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sMobile))){ 
	        alert("�ֻ�����������������������"); 
	        //obj.focus();
		    //setItemValue(0,0,"MobileTelephone","");
	        return false; 
	    } 
	}
    
	/*~[Describe=סլ�绰��֤;InputParam=��;OutPutParam=��;]~*/
	function checkPhone(obj){
		var sFamilyTel = getItemValue(0,getRow(),"FamilyTel");
		var sFamilyTel1=sFamilyTel.split("-");
		//alert(sFamilyTel1);
		var sFamilyTel2=sFamilyTel.substring(0,1);
		//alert(sFamilyTel2);
		//alert(sFamilyTel1.length);
		 if(typeof(sFamilyTel) == "undefined" || sFamilyTel.length==0){    //Ϊ��ʱ����У��
		    	return false;
		    }
		if(sFamilyTel1.length=="1"){
				if(sFamilyTel2=="1"){
				if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sFamilyTel1))){    //���ֻ���
			        alert("�ֻ������ʽ��д����"); 
			        obj.focus();
			        
			        return false; 
			    
			}	
				}else if(sFamilyTel2=="0"){
					
					alert("�̶��绰��ʽ��д����");
					obj.focus();
			        
			        return false; 
				
				}else{
					alert("�����ʽ��д���Ϸ�");
					obj.focus();
					return false;
				}
		}else if(sFamilyTel1.length=="2"){
			if(/^0\d{2,3}$/.test(sFamilyTel1[0])){
				if((/^0\d{2,3}-?\d{7,8}$/.test(sFamilyTel))){
					
				}else{
					alert("�̶��绰��ʽ��д����");
					obj.focus();
					return false;
				}
				
			}else{
				alert("������д����");
				obj.focus();
				return false;
			}
			
		}else if(sFamilyTel1.length>"3"){
			alert("�̶��绰��д���淶����������д");
			obj.focus();
			return false;
		}else{			
			if(/^0\d{2,3}$/.test(sFamilyTel1[0])){
				if((/^\d{7,8}$/.test(sFamilyTel1[1]))){
					 if((/^\d{1,8}$/.test(sFamilyTel1[2]))){
						 
					 }else{
						 alert("�ֻ�������д����");
						 obj.focus();
						 return false;
					 }
					
				}else{
					alert("�̶��绰��ʽ��д����");
					obj.focus();
					return false;
				}
				
			}else{
				alert("������д����");
				obj.focus();
				return false;
			}
			
		}
	   
	    
	} 
	
	/*~[Describe=�칫/ѧУ/����绰������;InputParam=��;OutPutParam=��;]~*/
	function checkWorkTel(obj){
	    var sWorkTel = getItemValue(0,getRow(),"WorkTel");
	    //�ո��Զ�����
	    /* var sWork=sWorkTelMain.replace(" ","");
	    setItemValue(0,0, "WorkTelMain", sWork); */
	    if(typeof(sWorkTel) == "undefined" || sWorkTel.length==0){     
	    	return false;
	    }
	    
	    //if(!(/^0\d{2,3}-?\d{7,8}$/.test(sWorkTel))){ 
	    	 if(!(/^[+]{0,4}(\d){1,3}[ ]?([-]?((\d)|[ ]){1,14})+$/.test(sWorkTel))){
	        alert("�칫/ѧУ/����绰����"); 
	        obj.focus();
		    //setItemValue(0,0,"WorkTel","");
	        return false; 
	    }   
	  //  if(!(/^[-\d]{7,8}$/.test(sWork))){
	 //   	alert("�칫/ѧУ/����绰������ֻ����7λ��8λ����");
	//    	obj.focus();
	 //   	return false;
	//    }
	} 
	/*~[Describe=�칫/ѧУ/����绰����;InputParam=��;OutPutParam=��;]~*/
    function checkWorkTelAreaCode(obj){
    	var sWorkTelAreaCode=getItemValue(0,0,"WorkTelAreaCode");
    	if(typeof(sWorkTelAreaCode) == "undefined" || sWorkTelAreaCode.length==0){     
	    	return false;
	    }
    	if(!(/^0\d{2,3}$/.test(sWorkTelAreaCode))){
    		if(sWorkTelAreaCode!="400"){
    		alert("���ű�����3��4λ��������0��ʼ��������400");
    		obj.focus();
    		return false;
    		}
    	}
    }
	
	
	
    //add by clhuang 2015/04/22  CCS-703 PRM-333 ���Ѵ�ũ��ĵ�λ�绰��Ϊѡ��
	function checkWorkTelHeadShip(){
	   var sHeadShip=getItemValue(0,0,"HeadShip");
	   var sStoreCity="<%=sStoreCity%>";
	   var sSubProductType="<%=sSubProductType%>";
	   var sPilotC="<%=sPilotC%>";
	   var sPilotB="<%=sPilotB%>";
	   
	   //update by dahl 2015/08/18 ccs-1008 ccs-993
	   if(sHeadShip=="10"&&"1" == sPilotC ){
		   setItemRequired(0, 0, "WorkTel", false);
	   }else if("1" == sPilotB ){
		   setItemRequired(0, 0, "WorkTel", false);
	   }else{
		   setItemRequired(0, 0, "WorkTel", true);
	   }
		   }
	   //end clhuang 2015/04/22
	   
	/*~[Describe=��ż�绰��֤;InputParam=��;OutPutParam=��;]~*/
	function checkSpouseTel(obj){
		//alert("0000");
		var sSpouseTel=getItemValue(0,getRow(),"SpouseTel");
		//�ո��Զ�����
		var sSpouse=sSpouseTel.replace(" ","");
		setItemValue(0,0,"SpouseTel",sSpouse);
		 if(typeof(sSpouse) == "undefined" || sSpouse.length==0){     
			 return false;
		 }
		 
		 
			var sSpouse1=sSpouse.split("-");
			var sSpouse2=sSpouse.substring(0,1);
			//alert(sFamilyTel2);
			//alert(sFamilyTel1.length);
			
			//alert(sSpouse1);
			//alert(sSpouse1.length);
			if(sSpouse1.length=="1"){
					if(sSpouse2=="1"){
					if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sSpouse))){    //���ֻ���
				       
						alert("�ֻ������ʽ��д����"); 
						obj.focus();
				        return false; 
				    
						}	
					}else if(sSpouse2=="0"){
						alert("�̶��绰��ʽ��д����"); 
						obj.focus();
				        return false; 
						
					
					}else{
						alert("�����ʽ��д���Ϸ�");
						obj.focus();
						return false;
					}
			}else if(sSpouse1.length=="2"){
				if(/^0\d{2,3}$/.test(sSpouse1[0])){
					if((/^0\d{2,3}-?\d{7,8}$/.test(sSpouse))){
						
					}else{
						alert("�̶��绰��ʽ��д����");
						obj.focus();
						return false;
					}
					
				}else{
					alert("������д����");
					obj.focus();
					return false;
				}
				
			}else if(sSpouse1.length>"3"){
				alert("�̶��绰��д���淶����������д");
				obj.focus();
				return false;
			}else{			
				if(/^0\d{2,3}$/.test(sSpouse1[0])){
					if((/^\d{7,8}$/.test(sSpouse1[1]))){
						 if((/^\d{1,8}$/.test(sSpouse1[2]))){
							 
						 }else{
							 alert("�ֻ�������д����");
							 obj.focus();
							 return false;
						 }
						
					}else{
						alert("�̶��绰��ʽ��д����");
						obj.focus();
						return false;
					}
					
				}else{
					alert("������д����");
					obj.focus();
					return false;
				}
				
			}
		   
		    
		
	}
	/*~[Describe=�����绰��֤;InputParam=��;OutPutParam=��;]~*/
	function checkKinshipTel(obj){
		var sKinshipTel=getItemValue(0,getRow(),"KinshipTel");
		//�ո��Զ�����
		var sKinship=sKinshipTel.replace(" ","");
		setItemValue(0,0,"KinshipTel",sKinship);
		 if(typeof(sKinship) == "undefined" || sKinship.length==0){     
			 return false;
		 }
		
			var sKinship1=sKinship.split("-");
			var sKinship2=sKinship.substring(0,1);
			//alert(sFamilyTel2);
			//alert(sFamilyTel1.length);
			
			if(sKinship1.length=="1"){
					if(sKinship2=="1"){
					if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sKinship))){    //���ֻ���
				        alert("�ֻ������ʽ��д����"); 
				        obj.focus();
				        
				        return false; 
				    
				}	
					} else if (sKinship2=="0"){
					
						alert("�̶��绰��ʽ��д����"); 
						obj.focus();
			        
			       		 return false; 
					
					}else{
						alert("�����ʽ��д���Ϸ�");
						obj.focus();
						return false;
					}
			}else if(sKinship1.length=="2"){
				if(/^0\d{2,3}$/.test(sKinship1[0])){
					if((/^0\d{2,3}-?\d{7,8}$/.test(sKinship))){
						
					}else{
						alert("�̶��绰��ʽ��д����");
						obj.focus();
						return false;
					}
					
				}else{
					alert("������д����");
					obj.focus();
					return false;
				}
				
			}else if(sKinship1.length>"3"){
				alert("�̶��绰��д���淶����������д");
				obj.focus();
				return false;
			}else{			
				if(/^0\d{2,3}$/.test(sKinship1[0])){
					if((/^\d{7,8}$/.test(sKinship1[1]))){
						 if((/^\d{1,8}$/.test(sKinship1[2]))){
							 
						 }else{
							 alert("�ֻ�������д����");
							 obj.focus();
							 return false;
						 }
						
					}else{
						alert("�̶��绰��ʽ��д����");
						obj.focus();
						return false;
					}
					
				}else{
					alert("������д����");
					obj.focus();
					return false;
				}
				
			}
		   
	}
	
	
	
/*********************��֤�ֻ�����**************************************************/
	
	function isCheckMobilePhone(obj){
		var sSchCouTel=obj.value;
		//�ո��Զ�����
		var sSCTel=sSchCouTel.replace(" ","");
		 if(typeof(sSCTel) == "undefined" || sSCTel.length==0){     
			 return false;
		 }
			var sSCTel1=sSCTel.split("-");
			var sSCTel2=sSCTel.substring(0,1);
			if(sSCTel1.length=="1"){
					if(sSCTel2=="1"){
					if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sSCTel))){    //���ֻ���
						alert("�ֻ������ʽ��д����"); 
						obj.focus();
				        return false; 
						}	
					}else if(sSCTel2=="0"){
						alert("�̶��绰��ʽ��д����"); 
						obj.focus();
				        return false; 
					}else{
						alert("�����ʽ��д���Ϸ�");
						obj.focus();
						return false;
					}
			}else if(sSCTel1.length=="2"){
				if(/^0\d{2,3}$/.test(sSCTel1[0])){
					if((/^0\d{2,3}-?\d{7,9}$/.test(sSCTel))){
					}else{
						alert("�̶��绰��ʽ��д����");
						obj.focus();
						return false;
					}
				}else{
					alert("������д����");
					obj.focus();
					return false;
				}
			}else if(sSCTel1.length>"3"){
				alert("�̶��绰��д���淶����������д");
				obj.focus();
				return false;
			}else{			
				if(/^0\d{2,3}$/.test(sSCTel1[0])){
					if((/^\d{7,9}$/.test(sSCTel1[1]))){
						 if((/^\d{1,9}$/.test(sSCTel1[2]))){
						 }else{
							 alert("�ֻ�������д����");
							 obj.focus();
							 return false;
						 }
					}else{
						alert("�̶��绰��ʽ��д����");
						obj.focus();
						return false;
					}
				}else{
					alert("������д����");
					obj.focus();
					return false;
				}
			}
	}		
	//  ֻ������һλ���� qulingmao 
	function checkNumOne(obj){ 
		if(!isNaN(obj.value)){     
		}else{      
			alert("������һλ��������!");  
			 obj.focus();
			return;
		}
	}
	function checkRateEmal(obj){
	    var re = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/;   
	    if(obj.value){
		    if (!re.test(obj.value)) {
		        alert("��������ȷ��ʽ���ʼ���ַ");
		   	  	obj.focus();
		        return false;
		     }
	    }
	}



	//  ֻ������һλ���� qulingmao 
	function checkNumOneWo(obj){ 
		if(!isNaN(obj.value)){     
			if(obj.value >100 || obj.value <0){
				 alert("��ȥ����˾��������δ��ֻ����0-100 ֮��");
				  obj.focus();
				return;
			}
		}else{      
			alert("������һλ��������!");  
			 obj.focus();
			return;
		}
	}
	
		//  ֻ������0-9999999�� qulingmao 
	function checkNumSix(obj){ 
		if(!isNaN(obj.value)){    
			if(obj.value >999999 || obj.value <0){
				alert("�����������֣�ֻ����0-999999 ֮��");
				  obj.focus();
				return;
			}
			
		}else{      
			alert("������������!");  
		}
	}
	function checkNumSix2(obj){ 
		if(!isNaN(obj.value)){    
			if(obj.value >999999 || obj.value <0){
				alert("�����������֣�ֻ����0-999999 ֮��");
			    obj.focus();
				return;
			}
			
		}else{      
			alert("������������!");  
			
			return;
		}
	}
	//add by jshu  
	function checkMobile1(obj){
	    var sMobile = obj.value;
	    if(typeof(sMobile) == "undefined" || sMobile.length==0){
	    	alert("�ֻ����벻�ܿ�");
	    	return false;
	    }
	    if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sMobile))){ 
	        alert("�ֻ�����������������������"); 
	      //add by jshu
	        //obj.focus();
		    //setItemValue(0,0,"MobileTelephone","");
	        return false; 
	    } 
	  
		   //add ������д�ֻ����룬�Զ�����У���ֻ��ĺ��� jshu
	    setItemValue(0,0,"PHONEVALIDATE",sMobile);
	   
	    initSendMessage();
	    sReturnMessageCode="";
	}
	
	//У���ֻ� add by dyh 20150618
	function checkMobile2(obj){
	    var sMobile = obj.value;
	    if(typeof(sMobile) == "undefined" || sMobile.length==0){
	    	alert("�ֻ����벻�ܿ�");
	    	obj.focus();
	    	return false;
	    }
	    if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sMobile))){ 
	        alert("�ֻ�����������������������"); 
	        obj.focus();
	        return false; 
	    } 
	    setItemValue(0,0,"PHONEVALIDATE",sMobile);
	   
	    initSendMessage();
	    sReturnMessageCode="";
	}
	
	/*~[Describe=������ϵ�˵绰��֤;InputParam=��;OutPutParam=��;]~*/
	function checkContactTel(obj){
		var sContactTel=getItemValue(0,getRow(),"ContactTel");
		//�ո��Զ�����
		var sContact=sContactTel.replace(" ","");
		setItemValue(0,0,"ContactTel",sContact);
		 if(typeof(sContact) == "undefined" || sContact.length==0){     
			 return false;
		 }
		
			var sContact1=sContact.split("-");
			var sContact2=sContact.substring(0,1);
			//alert(sFamilyTel2);
			//alert(sFamilyTel1.length);
			
			if(sContact1.length=="1"){
					if(sContact2=="1"){
					if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sContact))){    //���ֻ���
				        alert("�ֻ������ʽ��д����"); 
				        obj.focus();
				        return false; 
				    
				}	
					}else if(sContact2=="0"){
					
					alert("�̶��绰��ʽ��д����"); 
					obj.focus();
		       		 return false; 
					
					}else{
						alert("�����ʽ��д���Ϸ�");
						obj.focus();
						return false;
					}
			}else if(sContact1.length=="2"){
				if(/^0\d{2,3}$/.test(sContact1[0])){
					if((/^0\d{2,3}-?\d{7,8}$/.test(sContact))){
						
					}else{
						alert("�̶��绰��ʽ��д����");
						obj.focus();
						return false;
					}
					
				}else{
					alert("������д����");
					obj.focus();
					return false;
				}
				
			}else if(sContact1.length>"3"){
				alert("�̶��绰��д���淶����������д");
				obj.focus();
				return false;
			}else{			
				if(/^0\d{2,3}$/.test(sContact1[0])){
					if((/^\d{7,8}$/.test(sContact1[1]))){
						 if((/^\d{1,8}$/.test(sContact1[2]))){
							 
						 }else{
							 alert("�ֻ�������д����");
							 obj.focus();
							 return false;
						 }
						
					}else{
						alert("�̶��绰��ʽ��д����");
						obj.focus();
						return false;
					}
					
				}else{
					alert("������д����");
					obj.focus();
					return false;
				}
				
			}
		   
	}
	
	
	/***********beging CCS-1181 ����������ϵ��ʽ huzp 20151201***************************************************/
	/*~[Describe=������ϵ��ʽ��֤;InputParam=��;OutPutParam=��;]~*/
	function checkOtherTelePhone(obj){
		var sOtherTelePhone=getItemValue(0,getRow(),"OTHERTELEPHONE");
		//�ո��Զ�����
		var sContact=sOtherTelePhone.replace(" ","");
		setItemValue(0,0,"OTHERTELEPHONE",sContact);
		 if(typeof(sContact) == "undefined" || sContact.length==0){     
			 return false;
		 }
			var sContact1=sContact.split("-");
			var sContact2=sContact.substring(0,1);
			
			if(sContact1.length=="1"){
					if(sContact2=="1"){
						if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sContact))){    //���ֻ���
					        alert("�ֻ������ʽ��д����"); 
					        obj.focus();
					        return false; 
						}	
					}else if(sContact2=="0"){
						alert("�̶��绰��ʽ��д���󣨸�ʽΪ������-�����ţ�");
						obj.focus();
			       		 return false; 
					}else{
						alert("�����ʽ��д���Ϸ�");
						obj.focus();
						return false;
					}
			}else if(sContact1.length=="2"){
				if(/^0\d{2,3}$/.test(sContact1[0])){
					if((/^0\d{2,3}-?\d{7,8}$/.test(sContact))){
					}else{
						alert("�̶��绰��ʽ��д���󣨸�ʽΪ������-�����ţ�");
						obj.focus();
						return false;
					}
				}else{
					alert("������д����");
					obj.focus();
					return false;
				}
			}else if(sContact1.length>"3"){
				alert("�̶��绰��д���淶����������д");
				obj.focus();
				return false;
			}else{			
				if(/^0\d{2,3}$/.test(sContact1[0])){
					if((/^\d{7,8}$/.test(sContact1[1]))){
						 if((/^\d{1,8}$/.test(sContact1[2]))){
						 }else{
							 alert("�ֻ�������д����");
							 obj.focus();
							 return false;
						 }
					}else{
						alert("�̶��绰��ʽ��д���󣨸�ʽΪ������-�����ţ�");
						obj.focus();
						return false;
					}
				}else{
					alert("������д����");
					obj.focus();
					return false;
				}
			}
	}
	/*********end*****************************************************/
	
	
	//������ϵ��ַ�Ƿ�ͬ������ַ
	function selectFlag10(){
		var sFlag10 = getItemValue(0,0,"Flag10");
		
		//������ϵ��ַ
		//var sNativePlace = getItemValue(0,0,"NativePlace");
		var sNativePlaceName = getItemValue(0,0,"NativePlaceName");
		
		
		if(sFlag10=="1"){//�����
			setItemValue(0,0,"KinshipAdd",sNativePlaceName);//������ϵ��ַ
		}else{
			setItemValue(0,0,"KinshipAdd","");//������ϵ��ַ
		}

	}
	
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
		var sCustomerType = "<%=sCustomerType.substring(0,2)%>";
		var sCustomerType2 = "<%=sCustomerType%>";
		
		
		if(sCustomerType == '01'){ //��˾�ͻ�
			
			//8��У�������
			sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//������	
			if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" ){
				//���������Ψһ��
				sCustomerID = getItemValue(0,getRow(),"CustomerID");//�ͻ�����	
				sReturn=RunMethod("CustomerManage","CheckLoanCardNoChangeCustomer",sCustomerID+","+sLoanCardNo);
				if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") {
					alert(getBusinessMessage('227'));//�ô������ѱ������ͻ�ռ�ã�							
					return false;
				}					
			}
			
			//9:У�鵱�Ƿ����ű�׼���ſͻ�Ϊ��ʱ�����������ϼ���˾���ơ��ϼ���˾��֯����������ϼ���˾������
			sSuperCertID = getItemValue(0,getRow(),"SuperCertID");//�ϼ���˾��֯��������
	    	sECGroupFlag = getItemValue(0,getRow(),"ECGroupFlag");//�Ƿ����ű�׼���ſͻ�
	    	
			if(sECGroupFlag == '1'){ //�Ƿ����ű�׼���ſͻ���1���ǣ�2����
				
				//���¼�����ϼ���˾��֯�������룬����ҪУ���ϼ���˾��֯��������ĺϷ��ԣ�ͬʱ���ϼ���˾֤����������Ϊ��֯��������֤
				if(typeof(sSuperCertID) != "undefined" && sSuperCertID != "" ){
					setItemValue(0,getRow(),'SuperCertType',"Ent01");
				}	
			}			
		}
		
		if(sCustomerType == '03' || sCustomerType2 == '03'){ //���˿ͻ�
			//1:У��֤������Ϊ���֤����ʱ���֤ʱ�����������Ƿ�֤ͬ������е�����һ��
			sCertType = getItemValue(0,getRow(),"CertType");//֤������
			sCertID = getItemValue(0,getRow(),"CertID");//֤�����
			sBirthday = getItemValue(0,getRow(),"Birthday");//��������
			if(typeof(sBirthday) != "undefined" && sBirthday != "" ){
				if(sCertType == 'Ind01' || sCertType == 'Ind08'){
					//У���֤����ʱ���֤�ĳ���
					if(sCertID.length != 15 && sCertID.length !=18){
						alert(getBusinessMessage('250')); //֤�����볤������							
						return false;
					}
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
				
			//4��У���ֻ�����
		    var sMobile = getItemValue(0,getRow(),"MobileTelephone");
		    if(typeof(sMobile) == "undefined" || sMobile.length==0){
		    	alert("�ֻ����벻��Ϊ�գ�");
		    	return false;
		    }
		    if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sMobile))){
		        alert("�ֻ�����������������������");
		        return false; 
		    }
		    /* //�칫/ѧУ/����绰
		    var sWorkTel = getItemValue(0,getRow(),"WorkTel");
		    if(typeof(sWorkTel) == "undefined" || sWorkTel.length==0){
		    	alert("�칫/ѧУ/����绰���ܿգ�"); 
		    	return false;
		    }
		    
		   // if(!(/^0\d{2,3}-?\d{7,8}$/.test(sWorkTel))){ 
		   if(!(/^[+]{0,4}(\d){1,3}[ ]?([-]?((\d)|[ ]){1,14})+$/.test(sWorkTel))){
		        alert("�칫/ѧУ/����绰����"); 
		        //obj.focus();
			    //setItemValue(0,0,"WorkTel","");
		        return false; 
		    }  */
			
			//5.QQ����
			sQqNo = getItemValue(0,getRow(),"QqNo");//QQ
			if(isNaN(sQqNo)==true){
				alert("QQ������������֣�");
				return false;
			}
			
			//��������ϵ�绰��������ϵ�绰У��
			/*sKinshipTel = getItemValue(0,getRow(),"KinshipTel");//QQ
			if(isNaN(sKinshipTel)==true){
				alert("������ϵ�绰���������֣�");
				return false;
			}
			sContactTel = getItemValue(0,getRow(),"ContactTel");//QQ
			if(isNaN(sContactTel)==true){
				alert("��������ϵ�绰���������֣�");
				return false;
			}
			*/
			//���֤������У��
			 var sMaturityDate=getItemValue(0,getRow(),"MaturityDate");
			if(!checkMaturityDate()){
				return false;
			}
			//У�������֤��  add by phe
 			 var sSubProductTypeqlm="<%=sSubProductType%>";
			 var sMessageCode=getItemValue(0,0,"CELLPHONEVERIFY");
			 var sPHONEVALIDATE = getItemValue(0,0,"PHONEVALIDATE");//��ȡ��ǰҳ��绰����
			 var sCustomerID = getItemValue(0,0,"CustomerID");
			 var sPhoneNum = RunMethod("���÷���", "GetColValue", "ind_info,PHONEVALIDATE,CustomerID='"+sCustomerID+"'");
			 var sOldMessageCode = RunMethod("���÷���", "GetColValue", "ind_info,CELLPHONEVERIFY,CustomerID='"+sCustomerID+"'");
			 //С��ҵ������֤��
				if("6"!=sSubProductTypeqlm){
					 if(sMessageCode!=""&&(sPHONEVALIDATE!=sPhoneNum)){
						 
						 if(sReturnMessageCode!=sMessageCode){
							alert("���������֤������!");
							return false;	 
					 }
		 
				}
					 //��������֤���϶��ֻ����벻���У��
					 if(sMessageCode!=""&&(sPHONEVALIDATE==sPhoneNum)&&(sReturnMessageCode!=sMessageCode)&&(sOldMessageCode!=sMessageCode)){
						 alert("���������֤������!");
							return false;
					 }
				//CCS-890 jiangyuanlin
				if(sMessageCode==""){
					setItemRequired(0,0,"CELLPHONEVERIFY_REMARK",true);
				}else{
					setItemRequired(0,0,"CELLPHONEVERIFY_REMARK",false);
				}
				//CCS-890 end
			}
		}
		return true;		
	}

	function checkTelPhone(){
		//�ж������ֻ����벻���ظ�
		
		//�ֻ�����
		var sMobileTelephone = getItemValue(0,0,"MobileTelephone");
		//סլ�绰
		var sFamilyTel = getItemValue(0,0,"FamilyTel");
		//�칫/ѧУ/����绰
		var sWorkTel = getItemValue(0,0,"WorkTel");
		////�칫/ѧУ/����绰�ֺ�
		var WorkTelPlus = getItemValue(0,0,"WorkTelPlus");
		//��ż�绰����
		var sSpouseTel = getItemValue(0,0,"SpouseTel");
		//������ϵ�绰
		var sKinshipTel = getItemValue(0,0,"KinshipTel");
		//��ϵ�˵绰
		var sContactTel = getItemValue(0,0,"ContactTel");
		
		//add by dyh 20150610
		//��ͥ��Ա��λ�绰
		var family_parents_companytel = getItemValue(0,0,"family_parents_companytel");
		//����������ϵ�绰
		var family_parents_telephone = getItemValue(0,0,"family_parents_telephone");
		//����Ա�绰
		var school_counselor_telephone = getItemValue(0,0,"school_counselor_telephone");
		//ѧԺ/����绰
		var school_dormitory_telephone = getItemValue(0,0,"school_dormitory_telephone");
		//end dyh
		
		var myArray =new Array(); 
		//�ѵ绰����Ϊ�յ�ȥ��
		var k=0;
		if(typeof(sMobileTelephone) != "undefined" && sMobileTelephone.length>0){
			myArray[k++] = sMobileTelephone; 
		}
		if(typeof(sWorkTel) != "undefined" && sWorkTel.length>0){
			myArray[k++] = sWorkTel;
		}
		if(typeof(sKinshipTel) != "undefined" && sKinshipTel.length>0){
			myArray[k++] = sKinshipTel;
		}
		if(typeof(sContactTel) != "undefined" && sContactTel.length>0){
			myArray[k++] = sContactTel;
		}
		if(typeof(sSpouseTel) != "undefined" && sSpouseTel.length>0){
			myArray[k++] = sSpouseTel;
		}
		if(typeof(sFamilyTel) != "undefined" && sFamilyTel.length>0){
			myArray[k++] = sFamilyTel;
		}
		if(typeof(WorkTelPlus) != "undefined" && WorkTelPlus.length>0){
			myArray[k++] = WorkTelPlus;
		}
		
		//add by dyh 20150610
		if(typeof(family_parents_companytel) != "undefined" && family_parents_companytel.length>0){
			myArray[k++] = family_parents_companytel;
		}
		if(typeof(family_parents_telephone) != "undefined" && family_parents_telephone.length>0){
			myArray[k++] = family_parents_telephone;
		}
		if(typeof(school_counselor_telephone) != "undefined" && school_counselor_telephone.length>0){
			myArray[k++] = school_counselor_telephone;
		}
		if(typeof(school_dormitory_telephone) != "undefined" && school_dormitory_telephone.length>0){
			myArray[k++] = school_dormitory_telephone;
		}
		//end dyh
		
		var flag = "1";
		for(var i=0;i<myArray.length;i++){
			for(var j=i+1;j<myArray.length;j++){
				if(myArray[i] == myArray[j]){
					flag="0";
					break;
				}
			}
		}
		if(flag == "1"){
			return true;
		}else{
			alert("���й�ϵ�ĵ绰�����ظ�����,�����ظ����벢�޸�!");
			return false;
		}
	}
	
    /*~[Describe=������ҵ����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/   
    function selectOrgType(){
        sParaString = "CodeNo"+",OrgType";      
        //'0110'������ҵ�ͻ��������С����徭Ӫ��ѡ��     Add by zhuang 2010-03-17
        var sCustomerType = "<%=sCustomerType%>";
        if(sCustomerType =='0110'){
            setObjectValue("SelectBigOrgType",sParaString,"@OrgType@0@OrgTypeName@1",0,0,"");
        }else{
            setObjectValue("SelectCode",sParaString,"@OrgType@0@OrgTypeName@1",0,0,"");
        }
    }
    
	/*~[������ַʡ��ѡ�񴰿�]~*/
	function getNativePlace()
	{
		//var sAreaCode = getItemValue(0,getRow(),"City");
		//sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		
		//add by dahl 2015/08/18 ccs-1008

		var sPilotC = "<%=sPilotC%>";
        var sHeadShip=getItemValue(0,0,"HeadShip");
        var sCity = "<%=sStoreCity%>";
        var sAreaCodeInfo = "";
        
        if("10" == sHeadShip && "1" == sPilotC ){
			var sParaString = "CodeNo,AreaCode,ItemNo," + sCity;        	
        	sAreaCodeInfo = setObjectValue("SelectCodeItemNo",sParaString,"",0,0,"");
        }else{
        	sAreaCodeInfo = setObjectValue("SelectCityCodeSingle","","",0,0,"");
        }
        
		//������չ��ܵ��ж�
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"NativePlace","");
			setItemValue(0,getRow(),"NativePlaceName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
					sAreaCodeName = sAreaCodeInfo[1];//--������������
					setItemValue(0,getRow(),"NativePlace",sAreaCodeValue);
					setItemValue(0,getRow(),"NativePlaceName",sAreaCodeName);			
			}
		}
	 }
	
	/*~[�־ӵ�ַʡ��ѡ�񴰿�]~*/
	function getFamilyAdd()
	{
		//var sAreaCode = getItemValue(0,getRow(),"City");
		//sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
        //�����ڽӳ��е��ж�  edit by pli2   20141117
		//var sAreaCodeInfo = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		
        //add by dahl 2015/08/18 ccs-1008
        var sPilotC = "<%=sPilotC%>";
        var sHeadShip=getItemValue(0,0,"HeadShip");
        var sCity = "<%=sStoreCity%>";
        var sAreaCodeInfo = "";
		
        if("10" == sHeadShip && "1" == sPilotC ){
			var sParaString = "CodeNo,AreaCode,ItemNo," + sCity;
        	sAreaCodeInfo = setObjectValue("SelectCodeItemNo",sParaString,"",0,0,"");
        }else if ("<%=isInNearCity%>" == "") {
			sAreaCodeInfo = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		} else {
			sAreaCodeInfo= setObjectValue("SelectNearCityCodeSingle","StoreCity,<%=sStoreCity%>","",0,0,"");
		}
        
		//������չ��ܵ��ж�
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"FamilyAdd","");
			setItemValue(0,getRow(),"FamilyAddName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
					sAreaCodeName = sAreaCodeInfo[1];//--������������
					setItemValue(0,getRow(),"FamilyAdd",sAreaCodeValue);
					setItemValue(0,getRow(),"FamilyAddName",sAreaCodeName);			
			}
		}
	 }
	
	/*~[��λ��ַʡ��ѡ�񴰿�]~*/
	function getWorkAdd()
	{
		//var sAreaCode = getItemValue(0,getRow(),"City");
		//sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		var sAreaCodeInfo = "";
		var sPilotC = "<%=sPilotC%>";
        var sHeadShip=getItemValue(0,0,"HeadShip");
        var sCity = "<%=sStoreCity%>";
        

        if("10" == sHeadShip && "1" == sPilotC ){
			var sParaString = "CodeNo,AreaCode,ItemNo," + sCity;
        	sAreaCodeInfo = setObjectValue("SelectCodeItemNo",sParaString,"",0,0,"");
        }else if ("<%=isInNearCity%>" == "") {
			sAreaCodeInfo = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		} else {
			sAreaCodeInfo= setObjectValue("SelectNearCityCodeSingle","StoreCity,<%=sStoreCity%>","",0,0,"");
		}
		
		//������չ��ܵ��ж�
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"WorkAdd","");
			setItemValue(0,getRow(),"WorkAddName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
					sAreaCodeName = sAreaCodeInfo[1];//--������������
					setItemValue(0,getRow(),"WorkAdd",sAreaCodeValue);
					setItemValue(0,getRow(),"WorkAddName",sAreaCodeName);			
			}
		}
	 }

	
	/*~[�־�ס�أ�û���ٽ�����]~quliangmao*/
	function getWorkAddEduById(obj){
		var itemid="";
		var itemname="";
		if(obj){
			if("F"==obj){
				itemid="FamilyAdd";
				itemname="FamilyAddName";
			}
		}else{
			return;
		}
		 var	sAreaCodeInfo = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		//������չ��ܵ��ж�
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),itemid,"");
			setItemValue(0,getRow(),itemname,"");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
					sAreaCodeName = sAreaCodeInfo[1];//--������������
					setItemValue(0,getRow(),itemid,sAreaCodeValue);
					setItemValue(0,getRow(),itemname,sAreaCodeName);			
			}
		}
	 }
	
	/*~[��λ��ַʡ��ѡ�񴰿�]~*/
	function getWorkAddEdu(){
		//var sAreaCode = getItemValue(0,getRow(),"City");
		//sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		var sAreaCodeInfo = "";
			sAreaCodeInfo = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		//������չ��ܵ��ж�
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"WorkAdd","");
			setItemValue(0,getRow(),"WorkAddName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
					sAreaCodeName = sAreaCodeInfo[1];//--������������
					setItemValue(0,getRow(),"WorkAdd",sAreaCodeValue);
					setItemValue(0,getRow(),"WorkAddName",sAreaCodeName);			
			}
		}
	 }
	
	/*~[�ʼĵ�ַʡ��ѡ�񴰿�]~*/
	function getCommAdd()
	{
		//var sAreaCode = getItemValue(0,getRow(),"City");
		//sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
        var sAreaCodeInfo = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		
		//������չ��ܵ��ж�
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"CommAdd","");
			setItemValue(0,getRow(),"CommAddName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
					sAreaCodeName = sAreaCodeInfo[1];//--������������
					setItemValue(0,getRow(),"CommAdd",sAreaCodeValue);
					setItemValue(0,getRow(),"CommAddName",sAreaCodeName);			
			}
		}
	 }
	 //�־�ס��ַ�Ƿ�ͬ������ַ quliangmao
	function selectYesNoEdu(){
		var sFlag2 = getItemValue(0,0,"Flag2");
		//��ȡ������ַ
		var sNativePlace = getItemValue(0,0,"NativePlace");
		var sNativePlaceName = getItemValue(0,0,"NativePlaceName");
		var sVillagetown = getItemValue(0,0,"Villagetown");
		var sStreet = getItemValue(0,0,"Street");
		var sCommunity = getItemValue(0,0,"Community");
		var sRoom = getItemValue(0,0,"CellNo");
		var sCommZip = getItemValue(0,0,"CommZip");
		//alert("----------------------"+sRoom);
		//alert("----------------------"+sFlag2);
		
		
		if(sFlag2=="1"){//�����
			//��ѯ���ٽ����У�ƥ���ٽ����к��ŵ����        edit by awang 20141204
			//��ǰ�ŵ�����Ƿ�������ٽ����е�ά�������δ��ά�����򲻱�У��
			var sReturnValue=RunMethod("NearCity","getSerialNo","<%=sStoreCity%>");
		    if(sReturnValue=="Null"){
		    	setItemValue(0,0,"FamilyAdd",sNativePlace);//�־�ס��ַ
				setItemValue(0,0,"FamilyAddName",sNativePlaceName);
				setItemValue(0,0,"Countryside",sVillagetown);//��/��(�־�)
				setItemValue(0,0,"Villagecenter",sStreet);//�ֵ�/�壨�־ӣ�
				setItemValue(0,0,"Plot",sCommunity);//С��/¥�̣��־ӣ�
				setItemValue(0,0,"Room",sRoom);//��/��Ԫ/����ţ��־ӣ�
				setItemValue(0,0,"FamilyZIP",sCommZip);//��ס��ַ�ʱ�
		    	return;
		    }
				    //�������ά������Ҫ����ٽ�����
					var sReturn=RunMethod("NearCity","getNearCity","<%=sStoreCity%>");
				    if(sReturn=="Null"){
				    	sReturn="";
				    }
				    setItemValue(0,0,"FamilyAdd",sNativePlace);//�־�ס��ַ
					setItemValue(0,0,"FamilyAddName",sNativePlaceName);
					setItemValue(0,0,"Countryside",sVillagetown);//��/��(�־�)
					setItemValue(0,0,"Villagecenter",sStreet);//�ֵ�/�壨�־ӣ�
					setItemValue(0,0,"Plot",sCommunity);//С��/¥�̣��־ӣ�
					setItemValue(0,0,"Room",sRoom);//��/��Ԫ/����ţ��־ӣ�
					setItemValue(0,0,"FamilyZIP",sCommZip);//��ס��ַ�ʱ�
			
		}else{
			setItemValue(0,0,"FamilyAdd","");//�־�ס��ַ
			setItemValue(0,0,"FamilyAddName","");
			setItemValue(0,0,"Countryside","");//��/��(�־�)
			setItemValue(0,0,"Villagecenter","");//�ֵ�/�壨�־ӣ�
			setItemValue(0,0,"Plot","");//С��/¥�̣��־ӣ�
			setItemValue(0,0,"Room","");//��/��Ԫ/����ţ��־ӣ�
			setItemValue(0,0,"FamilyZIP","");//��ס��ַ�ʱ�
		}

	}
	
	/*~[�����ַ����ַ��]~*/
	function addNativePlace(obj){
		//������ַ
		var sNativePlace = getItemValue(0,0,"NativePlace");
		var sNativePlaceName = getItemValue(0,0,"NativePlaceName");
		var sVillagetown = getItemValue(0,0,"Villagetown");
		var sStreet = getItemValue(0,0,"Street");
		var sCommunity = getItemValue(0,0,"Community");
		var sCellNo = getItemValue(0,0,"CellNo");
		
		//�־�ס��ַ
		var sFamilyAdd = getItemValue(0,0,"FamilyAdd");
		var sFamilyAddName = getItemValue(0,0,"FamilyAddName");
		var sCountryside = getItemValue(0,0,"Countryside");
		var sVillagecenter = getItemValue(0,0,"Villagecenter");
		var sPlot = getItemValue(0,0,"Plot");
		var sRoom = getItemValue(0,0,"Room");
		
		//��λ��ַ
		var sWorkAdd = getItemValue(0,0,"WorkAdd");
		var sWorkAddName = getItemValue(0,0,"WorkAddName");
		var sUnitCountryside = getItemValue(0,0,"UnitCountryside");
		var sUnitStreet = getItemValue(0,0,"UnitStreet");
		var sUnitRoom = getItemValue(0,0,"UnitRoom");
		var sUnitNo = getItemValue(0,0,"UnitNo");
		
		//�ʼĵ�ַ
		var sCommAdd = getItemValue(0,0,"CommAdd");
		var sCommAddName = getItemValue(0,0,"CommAddName");
		var sEmailCountryside = getItemValue(0,0,"EmailCountryside");
		var sEmailStreet = getItemValue(0,0,"EmailStreet");
		var sEmailPlot = getItemValue(0,0,"EmailPlot");
		var sEmailRoom = getItemValue(0,0,"EmailRoom");
		
		//�ͻ����
		var sCustomerID = getItemValue(0,0,"CustomerID");
		//��ַ���ͣ�AddType
        var addType=obj;
		
        /** --update Object_Maxsnȡ���Ż� tangyb 20150817 start-- 
        //��ȡ��ˮ��
		var sSerialNo = getSerialNo("Customer_Add_Info","SerialNo","");*/
		
		//��ȡ��ˮ��
		var sSerialNo = '<%=DBKeyUtils.getSerialNo("CA")%>';
        /** --end --*/

		

		if(addType=="03"){//������ַ
			str=sNativePlace+","+sNativePlaceName+","+sVillagetown+","+sStreet+","+sCommunity+","+sCellNo+","+sCustomerID+","+addType+","+sSerialNo;
		    //alert("---������ַ---"+str);
		}
		if(addType=="01"){//��λ��ַ
			str=sWorkAdd+","+sWorkAddName+","+sUnitCountryside+","+sUnitStreet+","+sUnitRoom+","+sUnitNo+","+sCustomerID+","+addType+","+sSerialNo;
			//alert("---��λ��ַ---"+str);
		}
		if(addType=="02"){//�־�ס��ַ
			str=sFamilyAdd+","+sFamilyAddName+","+sCountryside+","+sVillagecenter+","+sPlot+","+sRoom+","+sCustomerID+","+addType+","+sSerialNo;
			//alert("---�־�ס��ַ---"+str);
		}
		if(addType=="04"){//�ʼĵ�ַ
			str=sCommAdd+","+sCommAddName+","+sEmailCountryside+","+sEmailStreet+","+sEmailPlot+","+sEmailRoom+","+sCustomerID+","+addType+","+sSerialNo;
			//alert("---�ʼĵ�ַ--"+str);
		}
		//�����ַ����ַ�ֿ�
		RunMethod("BusinessManage","UpdateAddressInfo",str);
        
	}
	
	/*~[����绰���绰��]~*/
	function addPhoneInfo(obj){
		//�ֻ�����
		var sMobileTelephone = getItemValue(0,0,"MobileTelephone");
		//סլ�绰
		var sFamilyTel = getItemValue(0,0,"FamilyTel");
		//�칫/ѧУ/����绰
		var sWorkTel = getItemValue(0,0,"WorkTel");
		//��ż�绰����
		var sSpouseTel = getItemValue(0,0,"SpouseTel");
		//������ϵ�绰
		var sKinshipTel = getItemValue(0,0,"KinshipTel");
		//��ϵ�˵绰
		var sContactTel = getItemValue(0,0,"ContactTel");
		//�ͻ����
		var sCustomerID = getItemValue(0,0,"CustomerID");
		//��ȡ��ˮ��
		/** --update Object_Maxsnȡ���Ż� tangyb 20150817 start-- 
		var sSerialNo = getSerialNo("Phone_Info","SerialNo","");*/
		var sSerialNo = '<%=DBKeyUtils.getSerialNo("PI")%>';
		/** --end --*/

		if(obj=="01"){//�ֻ�����
			str=sSerialNo+","+sCustomerID+","+sMobileTelephone+",010";
		}
		if(obj=="02"){//סլ�绰
			str=sSerialNo+","+sCustomerID+","+sFamilyTel+",010";
		}
		if(obj=="03"){//�칫/ѧУ/����绰
			str=sSerialNo+","+sCustomerID+","+sWorkTel+",999";
		}
		if(obj=="04"){//��ż�绰����
			str=sSerialNo+","+sCustomerID+","+sSpouseTel+",020";
		}
		if(obj=="05"){//������ϵ�绰
			str=sSerialNo+","+sCustomerID+","+sKinshipTel+",060";
		}
		if(obj=="06"){//��ϵ�˵绰
			str=sSerialNo+","+sCustomerID+","+sContactTel+",999";
		}
		
		//����绰���绰�ֿ�
		RunMethod("BusinessManage","UpdatePhoneInfo",str);
		
	}
	
	/*~[Describe=��������/����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCountryCode(){
		sParaString = "CodeNo"+",CountryCode";			
		sCountryCodeInfo = setObjectValue("SelectCode",sParaString,"@CountryCode@0@CountryCodeName@1",0,0,"");
		if (typeof(sCountryCodeInfo) != "undefined" && sCountryCodeInfo != ""  && sCountryCodeInfo != "_NONE_" 
		&& sCountryCodeInfo != "_CLEAR_" && sCountryCodeInfo != "_CANCEL_")
		{
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
	function selectCreditTempletType()
	{		
		sParaString = "CodeNo"+",CreditTempletType";			
		setObjectValue("SelectCode",sParaString,"@CreditBelong@0@CreditBelongName@1",0,0,"");
	}
	
	/*~[Describe=������Ӧ���ֿ�ģ��ģ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectAnalyseType(sModelType)
	{		
		sParaString = "ModelType"+","+sModelType;			
		setObjectValue("selectAnalyseType",sParaString,"@CreditBelong@0@CreditBelongName@1",0,0,"");
	}
	/*~[Describe=����ʡ�ݡ�ֱϽ�С�������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode(flag)
	{		
		if (flag != "ent") { //������ҵ�ͻ�����������͸��˵ļ���
			sParaString = "CodeNo"+",AreaCode";			
			setObjectValue("SelectCode",sParaString,"@NativePlace@0@NativePlaceName@1",0,0,"");
		}
	}
	
	
	//������������
	function selectMonthTotal(){
		var sOneselfincome =getItemValue(0,0,"Oneselfincome");//����������
		var sOtherRevenue =getItemValue(0,0,"OtherRevenue");//����������
		var sSpouseIncome =getItemValue(0,0,"SpouseIncome");//��ż������

		if(!isNaN(sOneselfincome) && !isNaN(sOtherRevenue) && !isNaN(sSpouseIncome)){
			var stotal=parseFloat(sOneselfincome)+parseFloat(sOtherRevenue)+parseFloat(sSpouseIncome);
			//alert("--------------"+stotal);
	        dTotal = roundOff(stotal,2);//�������뱣��2λС��

	        if(!isNaN(dTotal)){
			    setItemValue(0,0,"MonthTotal",dTotal);//��������
	        }
		 }
	 }
	
	//�����¾�����
	function selectNetmargin(){
		var sMonthTotal =getItemValue(0,0,"MonthTotal");//��������
		var sMonthexpend =getItemValue(0,0,"Monthexpend");//��ͥ��֧��
		var sRentexpend =getItemValue(0,0,"Rentexpend");//�·���֧��
		var sCreditMonth =getItemValue(0,0,"CreditMonth");//�����¹�

		if(!isNaN(sMonthTotal) && !isNaN(sMonthexpend) && !isNaN(sRentexpend) && !isNaN(sCreditMonth)){
			var stotal=parseFloat(sMonthTotal)-parseFloat(sMonthexpend)-parseFloat(sRentexpend)-parseFloat(sCreditMonth);
			//alert("--------------"+stotal);
	        dTotal = roundOff(stotal,2);//�������뱣��2λС��

	        if(!isNaN(dTotal)){
			    setItemValue(0,0,"Netmargin",dTotal);//�¾�����
	        }
		 }
	 }
	
	
	/*~[Describe=�������ڵ�;InputParam=��;OutPutParam=��;]~*/
	function getRegionCodes()
	{
		var sAreaCode = getItemValue(0,getRow(),"NativePlace");
		sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");

		//������չ��ܵ��ж�
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"NativePlace","");
			setItemValue(0,getRow(),"NativePlaceName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
					sAreaCodeName = sAreaCodeInfo[1];//--������������
					setItemValue(0,getRow(),"NativePlace",sAreaCodeValue);
					setItemValue(0,getRow(),"NativePlaceName",sAreaCodeName);			
			}
		}
	}
	
	//������ѻ飬��ż���ƺͺ���Ϊ����
	function selectMarriage(){
		var sMarriage=getItemValue(0,0,"Marriage");
		if(sMarriage=="2"){
			setItemRequired(0, 0, "SpouseName", true);
			setItemRequired(0, 0, "SpouseTel", true);
		}else{
			setItemRequired(0, 0, "SpouseName", false);
			setItemRequired(0, 0, "SpouseTel", false);
		}
	}
	
	/*~[Describe=ס�����ڵ�;InputParam=��;OutPutParam=��;]~*/
	function getLiveRoom()
	{
		var sAreaCode = getItemValue(0,getRow(),"LiveRoom");
		sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");

		//������չ��ܵ��ж�
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"LiveRoom","");
			setItemValue(0,getRow(),"LiveRoomName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
					sAreaCodeName = sAreaCodeInfo[1];//--������������
					setItemValue(0,getRow(),"LiveRoom",sAreaCodeValue);
					setItemValue(0,getRow(),"LiveRoomName",sAreaCodeName);			
			}
		}
	}

	/*~[Describe=������ַѡ��;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddManageList";
		sCompURL = "/CustomerManage/AddManageList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sAddress=sReturn[0];//
		sAddressName=sReturn[1];//
		sTownShip=sReturn[2];//
		sStreet=sReturn[3];//
		sCell=sReturn[4];//
		sRoom=sReturn[5];//
		
		setItemValue(0,0,"NativePlace",sAddress);//��ַID
		setItemValue(0,0,"NativePlaceName",sAddressName);//��ַNAME
		setItemValue(0,0,"Villagetown",sTownShip);//��/��
		setItemValue(0,0,"Street",sStreet);//�ֵ�/��
		setItemValue(0,0,"Community",sCell);//С��/¥��
		setItemValue(0,0,"CellNo",sRoom);//��/��Ԫ/�����
		
	}
	
	/*~[Describe=�־ӵ�ַѡ��;InputParam=��;OutPutParam=��;]~*/
	function getAddCode(){
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddManageList";
		sCompURL = "/CustomerManage/AddManageList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sAddress=sReturn[0];//
		sAddressName=sReturn[1];//
		sTownShip=sReturn[2];//
		sStreet=sReturn[3];//
		sCell=sReturn[4];//
		sRoom=sReturn[5];//
		
		setItemValue(0,0,"FamilyAdd",sAddress);//�־�ס��ַ
		setItemValue(0,0,"FamilyAddName",sAddressName);
		setItemValue(0,0,"Countryside",sTownShip);//��/��(�־�)
		setItemValue(0,0,"Villagecenter",sStreet);//�ֵ�/�壨�־ӣ�
		setItemValue(0,0,"Plot",sCell);//С��/¥�̣��־ӣ�
		setItemValue(0,0,"Room",sRoom);//��/��Ԫ/����ţ��־ӣ�
		
	}
	
	/*~[Describe=��λ��ַѡ��;InputParam=��;OutPutParam=��;]~*/
	function getCellRegionCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddManageList";
		sCompURL = "/CustomerManage/AddManageList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sAddress=sReturn[0];//
		sAddressName=sReturn[1];//
		sTownShip=sReturn[2];//
		sStreet=sReturn[3];//
		sCell=sReturn[4];//
		sRoom=sReturn[5];//
		
		setItemValue(0,0,"WorkAdd",sAddress);//��ַID
		setItemValue(0,0,"WorkAddName",sAddressName);//��ַNAME
		setItemValue(0,0,"UnitCountryside",sTownShip);//��/��
		setItemValue(0,0,"UnitStreet",sStreet);//�ֵ�/��
		setItemValue(0,0,"UnitRoom",sCell);//С��/¥��
		setItemValue(0,0,"UnitNo",sRoom);//��/��Ԫ/�����
	}	
	
	/*~[Describe=�ʼĵ�ַѡ��;InputParam=��;OutPutParam=��;]~*/
	function getEmailRegionCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddManageList";
		sCompURL = "/CustomerManage/AddManageList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sAddress=sReturn[0];//
		sAddressName=sReturn[1];//
		sTownShip=sReturn[2];//
		sStreet=sReturn[3];//
		sCell=sReturn[4];//
		sRoom=sReturn[5];//
		
		setItemValue(0,0,"CommAdd",sAddress);//��ַID
		setItemValue(0,0,"CommAddName",sAddressName);//��ַNAME
		setItemValue(0,0,"EmailCountryside",sTownShip);//��/��
		setItemValue(0,0,"EmailStreet",sStreet);//�ֵ�/��
		setItemValue(0,0,"EmailPlot",sCell);//С��/¥��
		setItemValue(0,0,"EmailRoom",sRoom);//��/��Ԫ/�����
	}
	
	/*~[Describe=סլ�绰ѡ��;InputParam=��;OutPutParam=��;]~*/
	function getPhoneCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sZipCode=sReturn[0];//����
		sPhoneCode=sReturn[1];//�绰����
		sExtensionNo=sReturn[2];//�ֻ�����
		sPhoneType=sReturn[3];//�绰����
		
		sFamilyTel=sZipCode+"-"+sPhoneCode;
		setItemValue(0,0,"FamilyTel",sFamilyTel);//סլ�绰
		
	}
	
	/*~[Describe=�ֻ�����ѡ��;InputParam=��;OutPutParam=��;]~*/
	function getTelPhoneCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sZipCode=sReturn[0];//����
		sPhoneCode=sReturn[1];//�绰����
		sExtensionNo=sReturn[2];//�ֻ�����
		sPhoneType=sReturn[3];//�绰����
		
		setItemValue(0,0,"MobileTelephone",sPhoneCode);//�ֻ�����
		
	}
	
	/*~[Describe=�����绰ѡ��;InputParam=��;OutPutParam=��;]~*/
	function getWorkPhoneCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sZipCode=sReturn[0];//����
		sPhoneCode=sReturn[1];//�绰����
		sExtensionNo=sReturn[2];//�ֻ�����
		sPhoneType=sReturn[3];//�绰����
		
		if(sExtensionNo==""){
			sWorkTel=sZipCode+"-"+sPhoneCode;
		}else{
			sWorkTel=sZipCode+"-"+sPhoneCode+"-"+sExtensionNo;
		}
		
		setItemValue(0,0,"WorkTel",sWorkTel);//�����绰

	}
	
	/*~[Describe=�������;InputParam=��;OutPutParam=��;]~*/
	function getFaxNumber()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sZipCode=sReturn[0];//����
		sPhoneCode=sReturn[1];//�绰����
		sExtensionNo=sReturn[2];//�ֻ�����
		sPhoneType=sReturn[3];//�绰����
		
		sWorkTel=sZipCode+"-"+sPhoneCode;
		setItemValue(0,0,"FaxNumber",sWorkTel);//�������

	}
	
	/*~[Describe=��ż�绰����ѡ��;InputParam=��;OutPutParam=��;]~*/
	function getSpouseTel()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sZipCode=sReturn[0];//����
		sPhoneCode=sReturn[1];//�绰����
		sExtensionNo=sReturn[2];//�ֻ�����
		sPhoneType=sReturn[3];//�绰����
		
		//sWorkTel=sZipCode+"-"+sPhoneCode+"-"+sExtensionNo;
		setItemValue(0,0,"SpouseTel",sPhoneCode);//��ż�绰
		
	}
	
	
	/*~[Describe=��ϵ�˵绰ѡ��;InputParam=��;OutPutParam=��;]~*/
	function getLinkManCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sZipCode=sReturn[0];//����
		sPhoneCode=sReturn[1];//�绰����
		sExtensionNo=sReturn[2];//�ֻ�����
		sPhoneType=sReturn[3];//�绰����
		
		//sWorkTel=sZipCode+"-"+sPhoneCode+"-"+sExtensionNo;
		setItemValue(0,0,"ContactTel",sPhoneCode);//��ϵ�˵绰
		
	}
	
	
	/*~[Describe=����������ҵ����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getIndustryType()
	{
		var sIndustryType = getItemValue(0,getRow(),"IndustryType");
		//������ҵ��������м������������ʾ��ҵ����
		sIndustryTypeInfo = PopComp("IndustryVFrame","/Common/ToolsA/IndustryVFrame.jsp","IndustryType="+sIndustryType,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		//������չ��ܵ��ж�
		if(sIndustryTypeInfo == "NO" ||sIndustryTypeInfo == '_CLEAR_' )
		{	
			setItemValue(0,getRow(),"IndustryType","");
			setItemValue(0,getRow(),"IndustryTypeName","");
		}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
		{
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];//-- ��ҵ���ʹ���
			sIndustryTypeName = sIndustryTypeInfo[1];//--��ҵ��������
			setItemValue(0,getRow(),"IndustryType",sIndustryTypeValue);
			setItemValue(0,getRow(),"IndustryTypeName",sIndustryTypeName);				
		}
	}
	
	//�־�ס��ַ�Ƿ�ͬ������ַ
	function selectYesNo(){
		var sFlag2 = getItemValue(0,0,"Flag2");
		//��ȡ������ַ
		var sNativePlace = getItemValue(0,0,"NativePlace");
		var sNativePlaceName = getItemValue(0,0,"NativePlaceName");
		var sVillagetown = getItemValue(0,0,"Villagetown");
		var sStreet = getItemValue(0,0,"Street");
		var sCommunity = getItemValue(0,0,"Community");
		var sRoom = getItemValue(0,0,"CellNo");
		var sCommZip = getItemValue(0,0,"CommZip");
		//alert("----------------------"+sRoom);
		//alert("----------------------"+sFlag2);
		
		
		if(sFlag2=="1"){//�����
			//��ѯ���ٽ����У�ƥ���ٽ����к��ŵ����        edit by awang 20141204
			//��ǰ�ŵ�����Ƿ�������ٽ����е�ά�������δ��ά�����򲻱�У��
			var sReturnValue=RunMethod("NearCity","getSerialNo","<%=sStoreCity%>");
		    if(sReturnValue=="Null"){
		    	setItemValue(0,0,"FamilyAdd",sNativePlace);//�־�ס��ַ
				setItemValue(0,0,"FamilyAddName",sNativePlaceName);
				setItemValue(0,0,"Countryside",sVillagetown);//��/��(�־�)
				setItemValue(0,0,"Villagecenter",sStreet);//�ֵ�/�壨�־ӣ�
				setItemValue(0,0,"Plot",sCommunity);//С��/¥�̣��־ӣ�
				setItemValue(0,0,"Room",sRoom);//��/��Ԫ/����ţ��־ӣ�
				setItemValue(0,0,"FamilyZIP",sCommZip);//��ס��ַ�ʱ�
		    	return;
		    }
		    //�������ά������Ҫ����ٽ�����
			var sReturn=RunMethod("NearCity","getNearCity","<%=sStoreCity%>");
		    if(sReturn=="Null"){
		    	sReturn="";
		    }
			var sVal=sReturn.substring(1,sReturn.length-1);
			var sflag=0;
			var storeCity="<%=sStoreCity%>";
			var sValue=sVal.split(",");
			 for(var i=0;i<sValue.length;i++){
				 if(sValue[i]==sNativePlace||storeCity==sNativePlace){
					 sflag=1;
				 }
	         }
			 if(sflag==0){
			 alert("��ַ�����ŵ���м��ٽ����У�");
		     setItemValue(0,0,"Flag2","2");
			 }else{
				    setItemValue(0,0,"FamilyAdd",sNativePlace);//�־�ס��ַ
					setItemValue(0,0,"FamilyAddName",sNativePlaceName);
					setItemValue(0,0,"Countryside",sVillagetown);//��/��(�־�)
					setItemValue(0,0,"Villagecenter",sStreet);//�ֵ�/�壨�־ӣ�
					setItemValue(0,0,"Plot",sCommunity);//С��/¥�̣��־ӣ�
					setItemValue(0,0,"Room",sRoom);//��/��Ԫ/����ţ��־ӣ�
					setItemValue(0,0,"FamilyZIP",sCommZip);//��ס��ַ�ʱ�
			 }
			
		}else{
			setItemValue(0,0,"FamilyAdd","");//�־�ס��ַ
			setItemValue(0,0,"FamilyAddName","");
			setItemValue(0,0,"Countryside","");//��/��(�־�)
			setItemValue(0,0,"Villagecenter","");//�ֵ�/�壨�־ӣ�
			setItemValue(0,0,"Plot","");//С��/¥�̣��־ӣ�
			setItemValue(0,0,"Room","");//��/��Ԫ/����ţ��־ӣ�
			setItemValue(0,0,"FamilyZIP","");//��ס��ַ�ʱ�
		}

	}
	
	function selectYesNo2(){
		var sFlag8 = getItemValue(0,0,"Flag8");
		
		//alert("--------------"+sFlag8);
		//��ȡ������ַ
		var sNativePlace = getItemValue(0,0,"NativePlace");
		var sNativePlaceName = getItemValue(0,0,"NativePlaceName");
		var sVillagetown = getItemValue(0,0,"Villagetown");
		var sStreet = getItemValue(0,0,"Street");
		var sCommunity = getItemValue(0,0,"Community");
		var sCellNo = getItemValue(0,0,"CellNo");
		//��ȡ��λ��ַ
		var sWorkAdd = getItemValue(0,0,"WorkAdd");
		var sWorkAddName = getItemValue(0,0,"WorkAddName");
		var sUnitCountryside = getItemValue(0,0,"UnitCountryside");
		var sUnitStreet = getItemValue(0,0,"UnitStreet");
		var sUnitRoom = getItemValue(0,0,"UnitRoom");
		var sUnitNo = getItemValue(0,0,"UnitNo");

		//��ȡ�־�ס��ַ
        var sFamilyAdd = getItemValue(0,0,"FamilyAdd");
        var sFamilyAddName = getItemValue(0,0,"FamilyAddName");
        var sCountryside = getItemValue(0,0,"Countryside");
        var sVillagecenter = getItemValue(0,0,"Villagecenter");
        var sPlot = getItemValue(0,0,"Plot");
        var sRoom = getItemValue(0,0,"Room");
  
		if(sFlag8=="1"){//ͬ�־�ס��ַ
			setItemValue(0,0,"CommAdd",sFamilyAdd);
			setItemValue(0,0,"CommAddName",sFamilyAddName);
			setItemValue(0,0,"EmailCountryside",sCountryside);
			setItemValue(0,0,"EmailStreet",sVillagecenter);
			setItemValue(0,0,"EmailPlot",sPlot);
			setItemValue(0,0,"EmailRoom",sRoom);
		}else if(sFlag8=="2"){//ͬ��λ/ѧУ��ַ
			setItemValue(0,0,"CommAdd",sWorkAdd);
			setItemValue(0,0,"CommAddName",sWorkAddName);
			setItemValue(0,0,"EmailCountryside",sUnitCountryside);
			setItemValue(0,0,"EmailStreet",sUnitStreet);
			setItemValue(0,0,"EmailPlot",sUnitRoom);
			setItemValue(0,0,"EmailRoom",sUnitNo);
		}else if(sFlag8=="3"){//ͬ������ַ
			setItemValue(0,0,"CommAdd",sNativePlace);
			setItemValue(0,0,"CommAddName",sNativePlaceName);
			setItemValue(0,0,"EmailCountryside",sVillagetown);
			setItemValue(0,0,"EmailStreet",sStreet);
			setItemValue(0,0,"EmailPlot",sCommunity);
			setItemValue(0,0,"EmailRoom",sCellNo);
		}else{//
			setItemValue(0,0,"CommAdd","");
			setItemValue(0,0,"CommAddName","");
			setItemValue(0,0,"EmailCountryside","");
			setItemValue(0,0,"EmailStreet","");
			setItemValue(0,0,"EmailPlot","");
			setItemValue(0,0,"EmailRoom","");
		}

	}
	
	//add by dyh 20150601 CCS-733 ѧ����
	function selectYesNo3(){
		var sFlag8 = getItemValue(0,0,"Flag8");
		
		//alert("--------------"+sFlag8);
		//��ȡ������ַ
		var sNativePlace = getItemValue(0,0,"NativePlace");
		var sNativePlaceName = getItemValue(0,0,"NativePlaceName");
		var sVillagetown = getItemValue(0,0,"Villagetown");
		var sStreet = getItemValue(0,0,"Street");
		var sCommunity = getItemValue(0,0,"Community");
		var sCellNo = getItemValue(0,0,"CellNo");
		//��ȡѧУ��ַ
		var sSchoolAdd = getItemValue(0,0,"school_address");
		var sSchoolAddName = getItemValue(0,0,"school_addressName");
		var sSchoolCountryside = getItemValue(0,0,"school_township");
		var sSchoolStreet = getItemValue(0,0,"school_street");
		var sSchoolCommunity = getItemValue(0,0,"school_community");
		var sSchoolNo = getItemValue(0,0,"school_room_no");

		//��ȡ�־�ס��ַ
        var sFamilyAdd = getItemValue(0,0,"FamilyAdd");
        var sFamilyAddName = getItemValue(0,0,"FamilyAddName");
        var sCountryside = getItemValue(0,0,"Countryside");
        var sVillagecenter = getItemValue(0,0,"Villagecenter");
        var sPlot = getItemValue(0,0,"Plot");
        var sRoom = getItemValue(0,0,"Room");
  
		if(sFlag8=="1"){//ͬ�־�ס��ַ
			setItemValue(0,0,"CommAdd",sFamilyAdd);
			setItemValue(0,0,"CommAddName",sFamilyAddName);
			setItemValue(0,0,"EmailCountryside",sCountryside);
			setItemValue(0,0,"EmailStreet",sVillagecenter);
			setItemValue(0,0,"EmailPlot",sPlot);
			setItemValue(0,0,"EmailRoom",sRoom);
		}else if(sFlag8=="2"){//ͬ��λ/ѧУ��ַ
			setItemValue(0,0,"CommAdd",sSchoolAdd);
			setItemValue(0,0,"CommAddName",sSchoolAddName);
			setItemValue(0,0,"EmailCountryside",sSchoolCountryside);
			setItemValue(0,0,"EmailStreet",sSchoolStreet);
			setItemValue(0,0,"EmailPlot",sSchoolCommunity);
			setItemValue(0,0,"EmailRoom",sSchoolNo);
		}else if(sFlag8=="3"){//ͬ������ַ
			setItemValue(0,0,"CommAdd",sNativePlace);
			setItemValue(0,0,"CommAddName",sNativePlaceName);
			setItemValue(0,0,"EmailCountryside",sVillagetown);
			setItemValue(0,0,"EmailStreet",sStreet);
			setItemValue(0,0,"EmailPlot",sCommunity);
			setItemValue(0,0,"EmailRoom",sCellNo);
		}else{//
			setItemValue(0,0,"CommAdd","");
			setItemValue(0,0,"CommAddName","");
			setItemValue(0,0,"EmailCountryside","");
			setItemValue(0,0,"EmailStreet","");
			setItemValue(0,0,"EmailPlot","");
			setItemValue(0,0,"EmailRoom","");
		}

	}
	
	
	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getOrg()
	{		
		setObjectValue("SelectAllOrg","","@OrgID@0@OrgName@1",0,0,"");
	}
	
	/*~[Describe=�����û�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getUser()
	{		
		var sOrg = getItemValue(0,getRow(),"OrgID");
		sParaString = "BelongOrg,"+sOrg;	
		if (sOrg.length != 0 )
		{		
			setObjectValue("SelectUserBelongOrg",sParaString,"@UserID@0@UserName@1",0,0,"");
		}else
		{
			alert(getBusinessMessage('132'));//����ѡ��ܻ�������
		}
	}
	
	function setspouse_address(datatype){
		//var sAreaCode = getItemValue(0,getRow(),"City");
		//sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		var sAreaCodeInfo = "";
			sAreaCodeInfo = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		//������չ��ܵ��ж�
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"spouse_address","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
					sAreaCodeName = sAreaCodeInfo[1];//--������������
					if("s"==datatype){
						setItemValue(0,getRow(),"spouse_address",sAreaCodeName);
					}else{
						setItemValue(0,getRow(),"spouse_address",sAreaCodeName);
					}
			}
		}
	 }
	 
	 function setKINSHIPADD(datatype){
		//var sAreaCode = getItemValue(0,getRow(),"City");
		//sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		var sAreaCodeInfo = "";
			sAreaCodeInfo = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		//������չ��ܵ��ж�
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"KINSHIPADD","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
					sAreaCodeName = sAreaCodeInfo[1];//--������������
					if("s"==datatype){
						setItemValue(0,getRow(),"KINSHIPADD",sAreaCodeName);
					}else{
						setItemValue(0,getRow(),"KINSHIPADD",sAreaCodeName);
					}
			}
		}
	 }
						
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if("020" == "<%=sProductID%>")
		{
			var sObjectNo = "<%=sObjectNo%>";
			//�ֽ��-�Ƿ��һ��¼��ͻ���Ϣ��־���ջ�1��ʾ��һ��¼�룬0Ϊ��¼�����
			var sIsCashLoanTemp = RunMethod("���÷���", "GetColValue", "Business_Contract,IsCashLoanTemp,SerialNo='"+sObjectNo+"'");
			if(null == sIsCashLoanTemp) sIsCashLoanTemp = "";
			//����¼����⣬�����������Ҫ�ÿտͻ����ֻ�����������ͥ��ϵ����Ϣ
			if("0"!=sIsCashLoanTemp)
			{
				initCashLoanInfo();
			}
		}
		
		 var sMessageCode=getItemValue(0,0,"CELLPHONEVERIFY");
		 var sTempSaveFlag = getItemValue(0,0,"TempSaveFlag");
		 var o = document.all("myiframe0").contentWindow.document.getElementById("sendMessage");
			if(sMessageCode!=""&&sTempSaveFlag!="1"){
		 	o.setAttribute("disabled", true);
			 setItemReadOnly(0,0,"CELLPHONEVERIFY",true);
			 o.value="�����ȡ";
			}
		
	  if (getRowCount(0)==0){ //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");//������¼
			bIsInsert = true;
		var sCountryCode = getItemValue(0,getRow(),"Country");
		var sInputUserID = getItemValue(0,getRow(),"InputUserID");
		var sCreditBelong = getItemValue(0,getRow(),"CreditBelong");
		
		var sHasIERight = getItemValue(0,getRow(),"HasIERight");
		var SECGroupFlag = getItemValue(0,getRow(),"ECGroupFlag");
		var sLoanFlag = getItemValue(0,getRow(),"LoanFlag");
		var sListingCorpType = getItemValue(0,getRow(),"ListingCorpOrNot");// add by zhuang 2010-03-17
		
        //�������й�˾����Ĭ��ֵΪ�������С�  add by zhuang 2010-03-17        
        if(sListingCorpType=="")
        {   
            //"2"���ֶ�"ListingCorpOrNot"��ģ���ж�Ӧ���ô���ListingCorpType��ItemNoֵ����ʾ������
            setItemValue(0,getRow(),"ListingCorpOrNot","2");
        }
	    
		//�����ֶ�Ĭ��ֵ
		if (sCountryCode=="")
		{
			setItemValue(0,getRow(),"Country","CHN");
		}

		//���ô�����ҵ����ҵ��ģĬ��ֵ add by cbsu 2009-11-02
        if("<%=sCustomerType%>" == '0110')
        {
            setItemValue(0,getRow(),"Scope","2");
        }
        
		if (sInputUserID=="") 
		{
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
		}
		if("<%=sCustomerInfoTemplet%>" == "EnterpriseInfo03" && sCreditBelong == "")
		{
		    setItemValue(0,getRow(),"CreditBelong","010");			
			setItemValue(0,getRow(),"CreditBelongName","��ҵ���������ҵ��λ���õȼ�������");
		}
		if("<%=sCustomerInfoTemplet%>" == "IndEntInfo")
		{
		    setItemValue(0,getRow(),"FinanceBelong","050");			
		}
		
		sCustomerType = "<%=sCustomerType.substring(0,2)%>";
		sCertType = getItemValue(0,0,"CertType");//--֤������	
		sCertID = getItemValue(0,0,"CertID");//--֤������
		ssCustomerType = "<%=sCustomerOrgType%>";
		sScope = "<%=sScope%>";	
		if(ssCustomerType == '0101' || ssCustomerType == '0102' || ssCustomerType == '0107')
		{
			sRCCurrency = getItemValue(0,0,"RCCurrency");
			sPCCurrency = getItemValue(0,0,"PCCurrency");
			if(sRCCurrency == '')
				setItemValue(0,getRow(),"RCCurrency","01");		
			if(sPCCurrency == '')
				setItemValue(0,getRow(),"PCCurrency","01");
		}
		if(sCustomerType == '01')//��˾�ͻ�
		{
			if(sLoanFlag == "")
			setItemValue(0,getRow(),"LoanFlag","1");
			if(sHasIERight == "")
			setItemValue(0,getRow(),"HasIERight","2");
			if(SECGroupFlag == "")
			setItemValue(0,getRow(),"ECGroupFlag","2");
		}
		if(sCustomerType == '03' ||sCustomerType == '0310') //���˿ͻ�
		{	
			//�ж����֤�Ϸ���,�������֤����Ӧ����15��18λ��
			if(sCertType =='Ind01' || sCertType =='Ind08')
			{
				//�����֤�е������Զ�������������
				if(sCertID.length == 15)
				{
					sSex = sCertID.substring(14);
					sSex = parseInt(sSex);
					sCertID = sCertID.substring(6,12);
					sCertID = "19"+sCertID.substring(0,2)+"/"+sCertID.substring(2,4)+"/"+sCertID.substring(4,6);
					setItemValue(0,getRow(),"Birthday",sCertID);
					if(sSex%2==0)//����żŮ
						setItemValue(0,getRow(),"Sex","2");
					else
						setItemValue(0,getRow(),"Sex","1");
				}
				if(sCertID.length == 18)
				{
					sSex = sCertID.substring(16,17);
					sSex = parseInt(sSex);
					sCertID = sCertID.substring(6,14);
					sCertID = sCertID.substring(0,4)+"/"+sCertID.substring(4,6)+"/"+sCertID.substring(6,8);
					setItemValue(0,getRow(),"Birthday",sCertID);
					if(sSex%2==0)//����żŮ
						setItemValue(0,getRow(),"Sex","2");
					else
						setItemValue(0,getRow(),"Sex","1");
				}
			}
			
		}
	  }
	  
	  // ������֤�ŵ����ڶ�λΪ�������Ա�Ĭ��Ϊ����
	  var sCertId = getItemValue(0, 0, "CertID");
	  var iLastTwo = parseInt(sCertId.charAt(sCertId.length-2));
	  if (iLastTwo%2 == 0) {
		setItemValue(0, 0, "Sex", "2");  
	  } else if (iLastTwo%2 == 1) {
		setItemValue(0, 0, "Sex", "1");  
	  }
    }
	
	//�������
	function selectAge(){
		var sBirthday = getItemValue(0,getRow(),"Birthday");//�ͻ������еĳ�������
		    
		if(sBirthday !=""){
			 var age=-1;
			 var today=new Date();
			 var todayYear=today.getFullYear();
			 var todayMonth=today.getMonth()+1;
			 var todayDay=today.getDate();
			 
			 var birthdayYear=sBirthday.substring(0,4);
			 var birthdayMonth=sBirthday.substring(5,7);
			 var birthdayDay=sBirthday.substring(8,10);
			 
			 if(todayYear-birthdayYear<0){
			    alert("��������ѡ�����!");
			 }else{
			       if(todayMonth*1-birthdayMonth*1<0){
			          age = (todayYear*1-birthdayYear*1)-1;
			        }else{
			              if(todayDay-birthdayDay>=0){
			                  age = (todayYear*1-birthdayYear*1);
			               }else{
			                  age = (todayYear*1-birthdayYear*1)-1;
			               }
			        }
			  }
			 setItemValue(0,0,"Age",age);
		}
		
	}
	
	//�����ж�
	function selectCoCode(){
		var sCountry = getItemValue(0,getRow(),"Country");

		if(sCountry =="CHN"){//�й�
			setItemRequired(0,0,"LiveDate",false);//���й���ʼ��סʱ�� ����
			setItemRequired(0,0,"NativePlaceName",true);//�������ڵ�
		}else if(sCountry =="HKG"){//���
			setItemRequired(0,0,"LiveDate",false);
			setItemRequired(0,0,"NativePlaceName",false);
		}else if(sCountry =="MAC"){//����
			setItemRequired(0,0,"LiveDate",false);
			setItemRequired(0,0,"NativePlaceName",false);
		}else if(sCountry ==""){//Ϊ��ʱ
			setItemRequired(0,0,"LiveDate",false);
			setItemRequired(0,0,"NativePlaceName",false);
		}else{
			setItemRequired(0,0,"LiveDate",true);
			setItemRequired(0,0,"NativePlaceName",false);
		}
	}
	
	
	
	/*~[Describe=��ʼ���ͻ����ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initCustomerID(){
		var sTableName = "CUSTOMER_INFO";//����
		var sColumnName = "CustomerID";//�ֶ���
		var sPrefix = "";//ǰ׺
       
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
    //����String.replace���������ַ����������ߵĿո��滻�ɿ��ַ���
    function Trim (sTmp)
    {
     	return sTmp.replace(/^(\s+)/,"").replace(/(\s+)$/,"");
    }
	
	//���� ��ҵ���͡�Ա�����������۶�ʲ��ܶ�ȷ����С��ҵ��ģ
	function EntScope() {
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

	//add �ֽ��-�����ģ��
	//��ż��λ���Ƹ�ʽ���
	function CheckSpouseWorkCorp(obj)
	{
		var sSpouseWorkCorp = obj.value;
		if(typeof(sSpouseWorkCorp) == "undefined" || sSpouseWorkCorp.length==0){
			return false;
		}
		if(!(/^[a-zA-Z0-9\u4e00-\u9fa5]+$/.test(sSpouseWorkCorp))){
			alert("��ż��λ��������Ƿ�");
			obj.focus();
			return false;
		}
	}

	//��ż��λ�绰��ʽ���
	function CheckSpouseWorkTel(obj)
	{
		var sSpouseWorkTel = obj.value;
		if(typeof(sSpouseWorkTel) == "undefined" || sSpouseWorkTel.length==0){
			return false;
		}
		if(!(/^[+]{0,4}(\d){1,3}[ ]?([-]?((\d)|[ ]){1,14})+$/.test(sSpouseWorkTel))){
	        alert("��ż��λ�绰����"); 
	        obj.focus();
	        return false; 
	    } 
	}
	//�ֽ��-�ͻ�������Ϣ�ÿգ��ͻ����ֻ�����������ͥ��ϵ����Ϣ��������¼��
	function initCashLoanInfo()
	{
		var array = [];
		array = ["MobileTelephone","EmailAdd","WorkCorp","WorkTel","WorkAdd","WorkAddName","UnitCountryside","UnitStreet","UnitRoom","UnitNo","SpouseName","SpouseTel","SPOUSEWORKCORP","SPOUSEWORKTEL","KinshipName","KinshipTel","Flag10","KinshipAdd","RelativeType","OtherContact","Contactrelation","ContactTel"];
		for(var i = 0;i<array.length;i++)
		{
			setItemValue(0,0,array[i],"");
		}
	}
	//end
/* 	//add by jshu ������֤�ֻ��ķ��͹���
	var flag=true;
	var time2=0;
	function sendMessage(){
		
		var TelePhone=getItemValue(0,0,"PHONEVALIDATE");	
		var myDate2 ;
		var myDate1 ;
		var time;
		var time1;
		
		myDate1= new Date();
		time1=myDate1.getTime();
		
		time=60-Math.round((time1-time2)/1000);
		
		if(flag){
		sReturnMessageCode=RunMethod("CustomerManage", "SendMessages", TelePhone);
		flag=false;
		
		myDate2 = new Date();
		time2=myDate2.getTime();
		
		setTimeout("flag=true",60000);
		
		}else{
			
		
			alert("��ȴ�"+time+"�������");
			return ;
		}
		//ShowMessage("ϵͳ���ڷ���......,60���������",true,true);
		//setTimeout("hideMessage()",6000);	
		//var v=$(window.frames["ObjectList"].frames["tab_T001_iframe_1"].frames["DeskTopInfo"].frames["right"].frames["myiframe0"].document).find("#sendMessage")
		//.click=function(){time(this);}
		
	} */
	//add by phe 2015/05/15 ������֤
	function sendMessage(){
		var TelePhone=getItemValue(0,0,"PHONEVALIDATE");
		if(typeof(TelePhone) == "undefined" || TelePhone.length==0){
			alert("�������ֻ�����!");
			return;
		}
		
		sReturnMessageCode=RunMethod("CustomerManage", "SendMessages", TelePhone);
		wait = 60;	
		time();
	}
	
	function time() {		
		var o = document.all("myiframe0").contentWindow.document.getElementById("sendMessage");
		if (wait == 0) {			
			o.removeAttribute("disabled");						
			o.value="�����ȡ";	
		    initSendMessage();
			wait = 60;		
			} else {			
				o.setAttribute("disabled", true);			
				o.value="���·���(" + wait + ")";			
				wait--;			
				setTimeout(function() {				
					time(o);		
					},			
					1000);		
					}	
		}
	//���ö��Ŷ�����֤��ͬ����ʽ
	function initSendMessage(){

		 var sPHONEVALIDATE = getItemValue(0,0,"PHONEVALIDATE");//��ȡ��ǰҳ��绰����
		 var sCustomerID = getItemValue(0,0,"CustomerID");
		 var sPhoneNum = RunMethod("���÷���", "GetColValue", "ind_info,PHONEVALIDATE,CustomerID='"+sCustomerID+"'");
		 var sMessageCode=getItemValue(0,0,"CELLPHONEVERIFY");
		 var sTempSaveFlag = getItemValue(0,0,"TempSaveFlag");
		 var sOldMessageCode = RunMethod("���÷���", "GetColValue", "ind_info,CELLPHONEVERIFY,CustomerID='"+sCustomerID+"'");

		 var o = document.all("myiframe0").contentWindow.document.getElementById("sendMessage");
		 if(sPHONEVALIDATE==sPhoneNum&&sMessageCode!=""&&sTempSaveFlag!="1"&&sMessageCode==sOldMessageCode){
			 o.setAttribute("disabled", true);
			 setItemReadOnly(0,0,"CELLPHONEVERIFY",true);
			 o.value="�����ȡ";
		 }else{
			 o.setAttribute("disabled", false);
			 setItemReadOnly(0,0,"CELLPHONEVERIFY",false);
			 o.value="�����ȡ";
			
		 }
		 wait = 0;
		 
	}
	//end by phe
	//�Ƿ��б��ط���
	function selectWay(){
		var isHouse=getItemValue(0,0,"isHouse");
		if(isHouse == '1'){
			//���ñ�ѡ����ѡ���з�������ʾ��������ַ�������������͡��������������������Ȩ�����ˡ�Ϊ����
			setItemRequired(0,0,"FHouseAdd",true);
			setItemRequired(0,0,"FHouseType",true);
			setItemRequired(0,0,"HouseArea",true);
			setItemRequired(0,0,"FHouseBelong",true);
		}else{
			setItemRequired(0,0,"FHouseAdd",false);
			setItemRequired(0,0,"FHouseType",false);
			setItemRequired(0,0,"HouseArea",false);
			setItemRequired(0,0,"FHouseBelong",false);
		}
		var isLoan = getItemValue(0,0,"isLoan");
		if(isLoan == '1'){
			//���ñ�ѡ����ѡ���д����ʾ���������С��������ʼʱ�䡰�����������ʱ�䡰���������Ϊ����
			setItemRequired(0,0,"LoanBank",true);
			setItemRequired(0,0,"LoanBegin",true);
			setItemRequired(0,0,"LoanEnd",true);
			setItemRequired(0,0,"HouseLoadNum",true);
		}else{
			setItemRequired(0,0,"LoanBank",false);
			setItemRequired(0,0,"LoanBegin",false);
			setItemRequired(0,0,"LoanEnd",false);
			setItemRequired(0,0,"HouseLoadNum",false);
		}
	}
	
	//add by dyh 20150610
	//����ı���ȷ��
	function checkForms(obj){
		var nameStr=obj.value;
	
        var iu, iuu, regArray=new Array("","��","��","��","��","��","��","��","!","@","#","$","%","^","&","*","_","+","=","|","","[","]","��","~","`"+
        "!","<",">","��","��","��","��","��","��","��","��","��","��","��","��","��","?","��","/"+
        "��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","&","��","��","��","��","��","��","{","}","~","��","��","��"+
        "��","��","��","��","��","��","��","��","��","��","��","/","��","��","��","��","��","��","��","��","��","��"+
        "��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��"+
        "��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��"+
        "��","��","��","��","��","��","��","��","��","��","��","��","��","��","��","��",".","��","��"); 
        iuu=regArray.length;
        for(iu=1;iu<=iuu;iu++){
               if (nameStr.indexOf(regArray[iu])!=-1){
            	   if(regArray[iu]){
                      alert("���Ʋ��ܰ�������" + regArray[iu]+"���ַ�");
                      obj.focus();
                      return ;
            	   }
               }
        }
 	  return true;              
 	}
	
	//CCS-890 PRM-472 ������֤��Ϊ����Ҫ��עԭ�� 
	function cellphoneverifyRemarkChange(){
		var remark=getItemValue(0,0,"CELLPHONEVERIFY_REMARK");
		if(remark=="099"){
			showOtherItem(0,0,"CELLPHONEVERIFY_OTHER","");
			setItemRequired(0,0,"CELLPHONEVERIFY_OTHER",true);
		}else{
			showOtherItem(0,0,"CELLPHONEVERIFY_OTHER","none");
			setItemRequired(0,0,"CELLPHONEVERIFY_OTHER",false);
		}
	}
	
	function showOtherItem(iDW,iRow,sCol,display){
		if(display==undefined || display=="block") display = ""; //��ʱ��ô����
		var iCol = getColIndex(iDW,sCol);
		var oInput = window.frames["myiframe"+iDW].document.getElementById("R"+iRow+"F"+iCol);
		oInput.parentNode.style.display = display;
		window.frames["myiframe"+iDW].document.getElementById("TDR"+iRow+"F"+iCol).style.display =display;
	}
	//CCS-890 END
	
	function checkPilotC(){
		 //add by dahl 2015/08/18 ccs-1008
        var sPilotC = "<%=sPilotC%>";
        var sCity = "<%=sStoreCity%>";
        var sHeadShip = getItemValue(0,0,"HeadShip");
        var sNativePlace = getItemValue(0,0,"NativePlace");
        var sFamilyAdd = getItemValue(0,0,"FamilyAdd");
        var sWorkAdd = getItemValue(0,0,"WorkAdd","");
        
        //�Ե���У���ְ��Ϊũ��
        if("10" == sHeadShip && "1" == sPilotC ){
        	
        	//�ŵ����ڳ��С�������ַ���ס��ַ������һ�£��ſ����ύ�ɹ���
        	if( sCity != sNativePlace || sCity != sFamilyAdd || sCity != sWorkAdd ){
        		alert("���ض������£�ְλѡ��ũ��ʱ���־�ס��ַѡ���ٽ�������Ч�����ŵ����ڳ��С�������ַ����ס��ַ����λ��ַ��һ��.");
        		return false;
        	}
        }
        
        return true;
		
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
	cellphoneverifyRemarkChange();//CCS-890
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
