<%@page import="com.amarsoft.app.util.RoleAuthController"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   --cchang  2004.12.2
		Tester:
		Content: --客户概况
		Input Param:
			  CustomerID:--客户号
		Output param:
		History Log: 
           DATE	     CHANGER		CONTENT
           2005.7.25 fbkang         新版本的改写
		   2005.9.10 zywei         重检代码 
		   2005.12.15 jbai
		   2006.10.16 fhuang       重检代码
		   2009.10.12 pwang        修 改本页面的涉及客户类型判断的内容。
		   2009.10.27 sjchuan	        页面中默认显示企业规模
		   2015/07/13 jiangyuanlin CCS-890
	 */
	%>
<%/*~END~*/%> 


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户概况"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//CurComp.setAttribute("RightType", "All");
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sCustomerInfoTemplet = "";//--模板类型
    String sSql = "";//--存放sql语句
    String sCustomerType = "";//--存放客户类型   
    String sCustomerOrgType = "";//--存放机构类型
    String sScope = "";//add by sjchuan 2009-10-27 存放企业规模
    String sItemAttribute = "" ;
    String sTempSaveFlag = "" ;//暂存标志
	String sCertType = "",sCertID = "",sAttribute3 = "";
	ASResultSet rs = null;//-- 存放结果集
	
	//获得组件参数,客户代码
    String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
    String sTypes =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Types"));//获得信贷业务补登时的客户详情的types
    String sRightType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));//
    
    //合同编号
    String sObjectNo = CurARC.getAttribute("BQContractNo");
    if(null == sObjectNo) sObjectNo = "";
    //贷款类型
    String sProductID = Sqlca.getString("select ProductID from Business_Contract where SerialNo = '"+sObjectNo+"' and CustomerID = '"+sCustomerID+"' ");
    if(null == sProductID) sProductID = "";
    
    //add CCS-150 记录每个合同的客户详情信息
    String sContractStatus = Sqlca.getString("select ContractStatus from Business_Contract where SerialNo = '"+sObjectNo+"' and CustomerID = '"+sCustomerID+"' ");
    if(null == sContractStatus) sContractStatus = "";
    //end
    
   /*  // 获取当前合同编号
    String sBQContractNo = CurARC.getAttribute("BQContractNo");
    if (sBQContractNo == null) sBQContractNo = "";
    // 获取合同状态
    String sContractStatus = Sqlca.getString(new SqlObject("SELECT CONTRACTSTATUS from BUSINESS_CONTRACT where SERIALNO=:ObjectNo").setParameter("ObjectNo", sBQContractNo));
    if (!"060".equals(sContractStatus)) CurComp.setAttribute("RightType", "ReadOnly"); */
    //System.out.println("----------------------------"+sCustomerID);
    
	if(sCustomerID == null) sCustomerID = "";
	if(sTypes == null) sTypes = "";
	if (sRightType==null) sRightType = "";
	//获得页面参数	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//取得客户类型
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
	
	//取得客户类型
	sSql = "select OrgNature,Scope from ENT_INFO where CustomerID = :CustomerID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(rs.next()){
		sCustomerOrgType = rs.getString("OrgNature");
		sScope = rs.getString("Scope");	//add sjchuan 2009-10-27 取得企业规模
	}
//	rs.getStatement().close();
	
	// 获取客户录入合同门店所在城市
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
	// 获取当前客户录入合同门店所在城市名称
	String sStoreCityName = Sqlca.getString(new SqlObject("select ITEMNAME from CODE_LIBRARY where CODENO = 'AreaCode' and ITEMNO = :ITEMNO").setParameter("ITEMNO", sStoreCity));
	if (sStoreCityName == null) sStoreCityName = "";
	
	//add by clhuang 2015/04/22 CCS-703 PRM-333 消费贷农民的单位电话改为选填
	String sHeadShip="";
	sSql = "select HeadShip from ind_info where CustomerID = :CustomerID";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(rs.next()){
		sHeadShip = rs.getString("HeadShip");
		}
	if(sHeadShip == null) sHeadShip = "";
	//end by clhuang 2015/04/22
	//取得视图模板类型
	if(sCustomerType.equals("03")){ //汽车金融客户信息模板
		//sSql = " select ItemAttribute,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerOrgType' and ItemNo = :ItemNo ";
		sSql = " select ItemAttribute,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = :ItemNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sCustomerType));
	}
	if(sCustomerType.equals("04")){//自雇
		sSql = " select ItemAttribute,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = :ItemNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sCustomerType));
	}
	if (sCustomerType.equals("05")){//公司
		sSql = " select ItemAttribute,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = :ItemNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sCustomerType));
	}
    if (sCustomerType.equals("0310")){ //消费金融客户信息模板
		sSql = " select ItemAttribute,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = :ItemNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sCustomerType));
	}
    if (sCustomerType.equals("0330")){ //小企业贷客户信息模板
		sSql = " select ItemAttribute,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = :ItemNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sCustomerType));
	}
	if(rs.next()){ 
		sItemAttribute = DataConvert.toString(rs.getString("ItemAttribute"));		//大型企业客户详情树图类型		
	    sAttribute3 = DataConvert.toString(rs.getString("Attribute3"));		        //中小企业客户详情树图类型
	}
	rs.getStatement().close(); 
	
	String sSubProductType = "";//产品子类型 // 根据子类型判断模板 quliangmao
	String education="select SubProductType from Business_Contract  where SerialNo=:SerialNo";
	ASResultSet educationrs = Sqlca.getASResultSet(new SqlObject(education).setParameter("SerialNo",sObjectNo));
  	if(educationrs.next()){ 
  		sSubProductType=DataConvert.toString(educationrs.getString("SubProductType"));
  		if(null==sSubProductType) sSubProductType = "";//add CCS-820 交叉现金贷进行中活动，选择客户查看客户详情报错 by rqiao 20150514
 	}
  	educationrs.getStatement().close();  
 	if("5".equals(sSubProductType)){//非学生贷
 		sItemAttribute="IndividualEducationInfo1";
	} 
 	if("4".equals(sSubProductType)){//非成人贷
 		sItemAttribute="IndividualEducationInfo2";
	} 
 	if( "7".equals(sSubProductType) ){	//学生消费贷
 		sItemAttribute="StuPosCustomerInfo";
 	}
	String smallBusinessApplyType = "";//根据合同id查询ApplyType(小企业贷)
	String smallBusinessApply="select ApplyType from FLOW_OBJECT  where ObjectNo=:SerialNo";
	ASResultSet smalleducationrs = Sqlca.getASResultSet(new SqlObject(smallBusinessApply).setParameter("SerialNo",sObjectNo));
  	if(smalleducationrs.next()){ 
  		smallBusinessApplyType=DataConvert.toString(smalleducationrs.getString("ApplyType"));
  		if(null==smallBusinessApplyType) smallBusinessApplyType = "";//add CCS-820 交叉现金贷进行中活动，选择客户查看客户详情报错 by rqiao 20150514
 	}
  	smalleducationrs.getStatement().close();  
  	if("SmallBusinessApply".equals(smallBusinessApplyType)){
  		sItemAttribute="SmallCustomerInfo";//小企业贷
  	}
  	
	if(sItemAttribute == null) sItemAttribute = "";	
	if(sAttribute3 == null) sAttribute3 = "";	
	if(sCustomerType.equals("0120")){
		if(sTypes.equals("Reinforce")){ //当为补登客户时，中小公司客户详情用显示模板EnterpriseInfoInput11
			sCustomerInfoTemplet="EnterpriseInfoInput11";
		}else{
			sCustomerInfoTemplet = sAttribute3;	
		}
	}else
		sCustomerInfoTemplet = sItemAttribute;	//其他客户详情显示模板
		
	if(sCustomerInfoTemplet == null) sCustomerInfoTemplet = "";
	if(sCustomerInfoTemplet.equals(""))
		throw new Exception("客户信息不存在或客户类型未设置！"); 
	
	if(sCustomerType.substring(0,2).equals("03") || sCustomerType.equals("03")){ //个人客户
		sSql = "select TempSaveFlag from IND_INFO where CustomerID = :CustomerID ";
	}else{ //公司客户、自雇
		sSql = "select TempSaveFlag from ENT_INFO where CustomerID = :CustomerID ";
	}
	sTempSaveFlag = Sqlca.getString(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(sTempSaveFlag == null) sTempSaveFlag = "";
	
	//add by clhuang 2015/05/04 CCS-718 PRM-342 消费贷学生产品教育程度选择限制
	//获取合同的产品代码
	String sBusinessType = Sqlca.getString(new SqlObject("select businesstype from business_contract where serialno= :serialno").setParameter("serialno",sObjectNo));
	//update CCS-820 交叉现金贷进行中活动，选择客户查看客户详情报错 by rqiao 20150514
	if(null==sBusinessType) sBusinessType = "";
	if(!"".equals(sBusinessType))
	{
		sBusinessType = sBusinessType.substring(0, 2);//截取字符串前两位
	}
	//end
	//end by clhung 2015/05/04
	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = sCustomerInfoTemplet;	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setHTMLStyle("Marriage", "onClick=\"javascript:parent.selectMarriage()\";style={background=\"#EEEEff\"}");
	
	if(sCertType.equals("Ind01") || sCertType.equals("Ind08")){
		//doTemp.setReadOnly("Sex,Birthday",true);
	}	
	//add by jgao1 如果证件类型是营业执照，则隐藏证件号码字段 2009-11-2
	if(sCertType.equals("Ent02")){
		doTemp.setVisible("CorpID",false);
		doTemp.setReadOnly("LicenseNo",true);
	}
	//add by phe 2015/05/15 CCS-639 手机短信验证功能校验规则详细说明
	String sPhoneNum = "";//获取原来的手机号码
	String sCELLPHONEVERIFY = "";//获取原来的校验码
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
	
	
	//add by clhuang 2015/05/04 CCS-718 PRM-342 消费贷学生产品教育程度选择限制
	//判断产品代码是否是以‘XS’开头
	String sql = "";
	if(sBusinessType.equals("XS")){

		sql = "select itemno,itemname from code_library where itemno in('5','6','7') and codeno='EducationExperience'";
	}else{	

		sql = "select itemno,itemname from code_library where codeno='EducationExperience' and isinuse='1'";
	}

	doTemp.setDDDWSql("EduExperience", sql);//设置模板的显示来源
	//end by clhuang 2015/05/04 
	
	//add by clhuang 2015/04/22 CCS-703 PRM-333 消费贷农民的单位电话改为选填
	//aad by clhuang 2015/07/29 CCS-1006 试点城市农民客户单位电话设置为非必输
	//update by dahl 2015/08/18 CCS-1008 特定城市，消费贷农民的单位电话改为选填特定城市，消费贷农民的单位电话改为选填
	String sPilotC = Sqlca.getString("SELECT 1 FROM pilot_city pc where pc.subproducttype='0' and pc.verifytype='C' and pc.city='"+sStoreCity+"' ");
	if(sHeadShip.equals("10")&&"1".equals(sPilotC)){
		doTemp.setRequired("WorkTel", false);
		}
	//end by clhuang 2015/04/22
	
	//add by dahl 20150804 ccs-993 在特定城市下，消费贷申请中单位电话变为非必填项
	String sPilotB = Sqlca.getString("SELECT 1 FROM pilot_city pc where pc.subproducttype='0' and pc.verifytype='B' and pc.city='"+sStoreCity+"' ");
    if("1".equals(sPilotB)){
    	doTemp.setRequired("WorkTel", false);
    }
	// end by dahl
	
	//隐藏客户敏感信息
	
	//除admin,销售运营以外的销售角色，不能查看还款计划
 	//if(CurUser.hasRole("1008") || CurUser.getUserID().equals("admin")){
 		
 	//}else{
	//	doTemp.setVisible("CertID",false);
 	//}
	RoleAuthController rac = new RoleAuthController(doTemp, CurUser.getRoleTable(), "QueryCustomerInfo", Sqlca, "01");
	rac.roleAuthCtrl("DONO", null);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println(dwTemp.Name);
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	var sReturnMessageCode="";
	var wait=60;
	//---------------------定义按钮事件------------------------------------

		
	//保存学生的学校信息到student_school_info表 add by dahl ccs-733
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
		//增加清空功能的判断
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"school_address","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
					sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
					setItemValue(0,getRow(),"school_address",sAreaCodeValue);
					setItemValue(0,getRow(),"school_addressName",sAreaCodeName);
			}
		}
	 }
	
  	/***************计算年龄**********quliangmao********/
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


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=显示单位提示;InputParam=无;OutPutParam=无;]~*/
	function showTitle(obj){
		obj.title="请填写客户的工作单位全称；                                     "+
			"* 个体请填写个体经营单位名称；"+
			"* 学生请填写就读学校的完整名称；"+
			"* 农民摩托车申请人请填写FM+认识申请人的有家庭固定电话的并在同一个镇的人的姓名。单位名字正确的填写方法为：FM+人名，例如FM张三（该处电话优先顺序为：申请人本人 - 申请人亲属 - 申请人邻居或朋友）（待定）";
	}
	/*~[Describe=办公电话提示;InputParam=无;OutPutParam=无;]~*/
	function showTitle2(obj){
		obj.title="必须为申请人现工作单位的单位电话，尽量取得分机号码"+
			"* 个体请在“单位电话”填写个体所在地电话；"+
			"* 学生请在“单位电话”填写该学校电话或院系电话。"+
			"* 农民摩托车申请人请在“单位电话”填写雇主名称中填写的人的家庭固定电话。（待定）";
	}
	/*~[Describe=地址输入验证;InputParam=无;OutPutParam=无;]~*/
	function checkAddress(obj){
		var sValue=obj.value;
		if(typeof(sValue) == "undefined" || sValue.length==0){
			return false;
		}
		if(!(/^[a-zA-Z0-9\u2E80-\uFE4F-#()（）\/]+$/.test(sValue))){                        
			if(sValue!='*'){      //无信息，统一输入*
			alert("地址输入非法");
			obj.focus();
			return false;
			}
		}else if((sValue.indexOf("【")!=-1)||(sValue.indexOf("】")!=-1)){
			alert("地址输入非法");
			obj.focus();
			return false;
		}
	}
	/*~[Describe=社保输入验证;InputParam=无;OutPutParam=无;]~*/
	function checkSino(obj){
		var sSino=getItemValue(0,getRow(),"Sino");
		if(typeof(sSino) == "undefined" || sSino.length==0){
			return false;
		}
		if(!(/^[A-Za-z0-9]+$/.test(sSino))){
			alert("社保号/学生证编号只能是数字和字母");
			obj.focus();
			return false;
		}
	}
	/*~[Describe=单位输入验证;InputParam=无;OutPutParam=无;]~*/
	function checkWorkCorp(obj){
		var sWorkCorp=getItemValue(0, getRow(), "WorkCorp");
		if(typeof(sWorkCorp) == "undefined" || sWorkCorp.length==0){
			return false;
		}
		if(!(/^[a-zA-Z0-9\u4e00-\u9fa5]+$/.test(sWorkCorp))){
			alert("单位名称输入非法");
			obj.focus();
			return false;
		}
	}
	
	//校验个人月收入不能小于等于0
	function checkSelfMonthIncome(obj){
		var sSelfMonthIncome=getItemValue(0,getRow(),"SelfMonthIncome");
		if(typeof(sSelfMonthIncome) == "undefined" || sSelfMonthIncome.length==0){
			return false;
		}
		if(parseFloat(sSelfMonthIncome)<=0){
			alert("个人月收入必须大于0！");
			obj.focus();
			return false;
		}
		
	}
	
	/*~[Describe=部门输入验证;InputParam=无;OutPutParam=无;]~*/
	function checkDepartment(obj){
		var sDepartment=getItemValue(0,getRow(),"EmployRecord");
		if(typeof(sDepartment) == "undefined" || sDepartment.length==0){
			return false;
		}
		if(!(/^([a-zA-Z0-9\u4e00-\u9fa5])+$/.test(sDepartment))){
			alert("任职部门输入非法");
			obj.focus();
			return false;
		}
	}
	/*~[Describe=姓名输入验证;InputParam=无;OutPutParam=无;]~*/
	function checkName(obj){
		var sName=obj.value;
		if(typeof(sName) == "undefined" || sName.length==0 ){
			return false;
		}else{
			
		if(/\s+/.test(sName)){
			alert("姓名含有空格，请重新输入");
			obj.focus();
			return false;
		}
		//姓名必须是中文或者字母
		if(!(/^[\u4e00-\u9fa5]{2,7}$|^[a-zA-Z]{1,30}$/.test(sName))){
			    if(!(/^([\u4e00-\u9fa5]+|[a-zA-Z]+)·([\u4e00-\u9fa5]+|[a-zA-Z]+)$/.test(sName))){
				alert("姓名输入非法");
				obj.focus();
				return false;
			    }
			}
		 }
	}
	/*~[Describe=子女数目验证;InputParam=无;OutPutParam=无;]~*/
	function checkChildNum(obj){
		var sChildrentotal=obj.value;
		if(typeof(sChildrentotal) == "undefined" || sChildrentotal.length==0){
			return false;
		}
		
		if(!(/^[0-9]+$/.test(sChildrentotal))){
			alert("输入的子女数目只能是数字0-10");
			obj.focus();
			return false;
		}
		var num=parseInt(sChildrentotal);
		if(num>10||num<0){
			alert("输入的子女数目只能是数字0-10");
			obj.focus();
			return false;
		} 
	}
	/*~[Describe=工作/在读/个体营业时间验证;InputParam=无;OutPutParam=无;]~*/
	function checkWorkDate(obj){
		var sWorkDate=getItemValue(0,getRow(),"JobTime");
		if(typeof(sWorkDate) == "undefined" || sWorkDate.length==0){
			return false;
		}
		var num=parseInt(sWorkDate);
		if(sWorkDate<1){
			alert("时间不满一个月");
			obj.focus();
			return false;
		}
	
	}
	/*~[Describe=金额验证;InputParam=无;OutPutParam=无;]~*/
	function checkMoney(obj){
		var sValue=obj.value;
		var num=parseInt(sValue);
		if(num<0){
			alert("所输入金额不能小于零");
			obj.focus();
		}
	}
	/*~[Describe=签证机关验证;InputParam=无;OutPutParam=无;]~*/
	function checkInstitution(obj){
		var sInstitution=getItemValue(0,getRow(),"Issueinstitution");
		if(typeof(sInstitution) == "undefined" || sInstitution.length==0){
			return false;
		}
		if(!(/^([a-zA-Z0-9\u4e00-\u9fa5])+$/.test(sInstitution))){
			alert("签发机关输入非法");
			obj.focus();
			return false;
		}
	}
	/*~[Describe=到期日验证;InputParam=无;OutPutParam=无;]~*/
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
        	alert("该证件已到期");
        	return false;
        }
       return true;
	}
	/*~[Describe=手机号码验证;InputParam=无;OutPutParam=无;]~*/
	function checkMobile(obj){
	    var sMobile = obj.value;
	    if(typeof(sMobile) == "undefined" || sMobile.length==0){
	    	alert("手机号码不能空");
	    	return false;
	    }
	    if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sMobile))){ 
	        alert("手机号码输入有误，请重新输入"); 
	        //obj.focus();
		    //setItemValue(0,0,"MobileTelephone","");
	        return false; 
	    } 
	}
    
	/*~[Describe=住宅电话验证;InputParam=无;OutPutParam=无;]~*/
	function checkPhone(obj){
		var sFamilyTel = getItemValue(0,getRow(),"FamilyTel");
		var sFamilyTel1=sFamilyTel.split("-");
		//alert(sFamilyTel1);
		var sFamilyTel2=sFamilyTel.substring(0,1);
		//alert(sFamilyTel2);
		//alert(sFamilyTel1.length);
		 if(typeof(sFamilyTel) == "undefined" || sFamilyTel.length==0){    //为空时不必校验
		    	return false;
		    }
		if(sFamilyTel1.length=="1"){
				if(sFamilyTel2=="1"){
				if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sFamilyTel1))){    //非手机号
			        alert("手机号码格式填写错误"); 
			        obj.focus();
			        
			        return false; 
			    
			}	
				}else if(sFamilyTel2=="0"){
					
					alert("固定电话格式填写错误");
					obj.focus();
			        
			        return false; 
				
				}else{
					alert("号码格式填写不合法");
					obj.focus();
					return false;
				}
		}else if(sFamilyTel1.length=="2"){
			if(/^0\d{2,3}$/.test(sFamilyTel1[0])){
				if((/^0\d{2,3}-?\d{7,8}$/.test(sFamilyTel))){
					
				}else{
					alert("固定电话格式填写错误");
					obj.focus();
					return false;
				}
				
			}else{
				alert("区号填写错误");
				obj.focus();
				return false;
			}
			
		}else if(sFamilyTel1.length>"3"){
			alert("固定电话填写不规范，请重新填写");
			obj.focus();
			return false;
		}else{			
			if(/^0\d{2,3}$/.test(sFamilyTel1[0])){
				if((/^\d{7,8}$/.test(sFamilyTel1[1]))){
					 if((/^\d{1,8}$/.test(sFamilyTel1[2]))){
						 
					 }else{
						 alert("分机号码填写错误");
						 obj.focus();
						 return false;
					 }
					
				}else{
					alert("固定电话格式填写错误");
					obj.focus();
					return false;
				}
				
			}else{
				alert("区号填写错误");
				obj.focus();
				return false;
			}
			
		}
	   
	    
	} 
	
	/*~[Describe=办公/学校/个体电话主机号;InputParam=无;OutPutParam=无;]~*/
	function checkWorkTel(obj){
	    var sWorkTel = getItemValue(0,getRow(),"WorkTel");
	    //空格自动忽略
	    /* var sWork=sWorkTelMain.replace(" ","");
	    setItemValue(0,0, "WorkTelMain", sWork); */
	    if(typeof(sWorkTel) == "undefined" || sWorkTel.length==0){     
	    	return false;
	    }
	    
	    //if(!(/^0\d{2,3}-?\d{7,8}$/.test(sWorkTel))){ 
	    	 if(!(/^[+]{0,4}(\d){1,3}[ ]?([-]?((\d)|[ ]){1,14})+$/.test(sWorkTel))){
	        alert("办公/学校/个体电话有误！"); 
	        obj.focus();
		    //setItemValue(0,0,"WorkTel","");
	        return false; 
	    }   
	  //  if(!(/^[-\d]{7,8}$/.test(sWork))){
	 //   	alert("办公/学校/个体电话主机号只能是7位或8位数字");
	//    	obj.focus();
	 //   	return false;
	//    }
	} 
	/*~[Describe=办公/学校/个体电话区号;InputParam=无;OutPutParam=无;]~*/
    function checkWorkTelAreaCode(obj){
    	var sWorkTelAreaCode=getItemValue(0,0,"WorkTelAreaCode");
    	if(typeof(sWorkTelAreaCode) == "undefined" || sWorkTelAreaCode.length==0){     
	    	return false;
	    }
    	if(!(/^0\d{2,3}$/.test(sWorkTelAreaCode))){
    		if(sWorkTelAreaCode!="400"){
    		alert("区号必须是3到4位，或者以0开始，或者是400");
    		obj.focus();
    		return false;
    		}
    	}
    }
	
	
	
    //add by clhuang 2015/04/22  CCS-703 PRM-333 消费贷农民的单位电话改为选填
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
	   
	/*~[Describe=配偶电话验证;InputParam=无;OutPutParam=无;]~*/
	function checkSpouseTel(obj){
		//alert("0000");
		var sSpouseTel=getItemValue(0,getRow(),"SpouseTel");
		//空格自动忽略
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
					if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sSpouse))){    //非手机号
				       
						alert("手机号码格式填写错误"); 
						obj.focus();
				        return false; 
				    
						}	
					}else if(sSpouse2=="0"){
						alert("固定电话格式填写错误"); 
						obj.focus();
				        return false; 
						
					
					}else{
						alert("号码格式填写不合法");
						obj.focus();
						return false;
					}
			}else if(sSpouse1.length=="2"){
				if(/^0\d{2,3}$/.test(sSpouse1[0])){
					if((/^0\d{2,3}-?\d{7,8}$/.test(sSpouse))){
						
					}else{
						alert("固定电话格式填写错误");
						obj.focus();
						return false;
					}
					
				}else{
					alert("区号填写错误");
					obj.focus();
					return false;
				}
				
			}else if(sSpouse1.length>"3"){
				alert("固定电话填写不规范，请重新填写");
				obj.focus();
				return false;
			}else{			
				if(/^0\d{2,3}$/.test(sSpouse1[0])){
					if((/^\d{7,8}$/.test(sSpouse1[1]))){
						 if((/^\d{1,8}$/.test(sSpouse1[2]))){
							 
						 }else{
							 alert("分机号码填写错误");
							 obj.focus();
							 return false;
						 }
						
					}else{
						alert("固定电话格式填写错误");
						obj.focus();
						return false;
					}
					
				}else{
					alert("区号填写错误");
					obj.focus();
					return false;
				}
				
			}
		   
		    
		
	}
	/*~[Describe=亲属电话验证;InputParam=无;OutPutParam=无;]~*/
	function checkKinshipTel(obj){
		var sKinshipTel=getItemValue(0,getRow(),"KinshipTel");
		//空格自动忽略
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
					if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sKinship))){    //非手机号
				        alert("手机号码格式填写错误"); 
				        obj.focus();
				        
				        return false; 
				    
				}	
					} else if (sKinship2=="0"){
					
						alert("固定电话格式填写错误"); 
						obj.focus();
			        
			       		 return false; 
					
					}else{
						alert("号码格式填写不合法");
						obj.focus();
						return false;
					}
			}else if(sKinship1.length=="2"){
				if(/^0\d{2,3}$/.test(sKinship1[0])){
					if((/^0\d{2,3}-?\d{7,8}$/.test(sKinship))){
						
					}else{
						alert("固定电话格式填写错误");
						obj.focus();
						return false;
					}
					
				}else{
					alert("区号填写错误");
					obj.focus();
					return false;
				}
				
			}else if(sKinship1.length>"3"){
				alert("固定电话填写不规范，请重新填写");
				obj.focus();
				return false;
			}else{			
				if(/^0\d{2,3}$/.test(sKinship1[0])){
					if((/^\d{7,8}$/.test(sKinship1[1]))){
						 if((/^\d{1,8}$/.test(sKinship1[2]))){
							 
						 }else{
							 alert("分机号码填写错误");
							 obj.focus();
							 return false;
						 }
						
					}else{
						alert("固定电话格式填写错误");
						obj.focus();
						return false;
					}
					
				}else{
					alert("区号填写错误");
					obj.focus();
					return false;
				}
				
			}
		   
	}
	
	
	
/*********************验证手机号码**************************************************/
	
	function isCheckMobilePhone(obj){
		var sSchCouTel=obj.value;
		//空格自动忽略
		var sSCTel=sSchCouTel.replace(" ","");
		 if(typeof(sSCTel) == "undefined" || sSCTel.length==0){     
			 return false;
		 }
			var sSCTel1=sSCTel.split("-");
			var sSCTel2=sSCTel.substring(0,1);
			if(sSCTel1.length=="1"){
					if(sSCTel2=="1"){
					if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sSCTel))){    //非手机号
						alert("手机号码格式填写错误"); 
						obj.focus();
				        return false; 
						}	
					}else if(sSCTel2=="0"){
						alert("固定电话格式填写错误"); 
						obj.focus();
				        return false; 
					}else{
						alert("号码格式填写不合法");
						obj.focus();
						return false;
					}
			}else if(sSCTel1.length=="2"){
				if(/^0\d{2,3}$/.test(sSCTel1[0])){
					if((/^0\d{2,3}-?\d{7,9}$/.test(sSCTel))){
					}else{
						alert("固定电话格式填写错误");
						obj.focus();
						return false;
					}
				}else{
					alert("区号填写错误");
					obj.focus();
					return false;
				}
			}else if(sSCTel1.length>"3"){
				alert("固定电话填写不规范，请重新填写");
				obj.focus();
				return false;
			}else{			
				if(/^0\d{2,3}$/.test(sSCTel1[0])){
					if((/^\d{7,9}$/.test(sSCTel1[1]))){
						 if((/^\d{1,9}$/.test(sSCTel1[2]))){
						 }else{
							 alert("分机号码填写错误");
							 obj.focus();
							 return false;
						 }
					}else{
						alert("固定电话格式填写错误");
						obj.focus();
						return false;
					}
				}else{
					alert("区号填写错误");
					obj.focus();
					return false;
				}
			}
	}		
	//  只能输入一位整数 qulingmao 
	function checkNumOne(obj){ 
		if(!isNaN(obj.value)){     
		}else{      
			alert("请输入一位数字类型!");  
			 obj.focus();
			return;
		}
	}
	function checkRateEmal(obj){
	    var re = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/;   
	    if(obj.value){
		    if (!re.test(obj.value)) {
		        alert("请输入正确格式的邮件地址");
		   	  	obj.focus();
		        return false;
		     }
	    }
	}



	//  只能输入一位整数 qulingmao 
	function checkNumOneWo(obj){ 
		if(!isNaN(obj.value)){     
			if(obj.value >100 || obj.value <0){
				 alert("过去本公司申请过几次贷款，只能是0-100 之间");
				  obj.focus();
				return;
			}
		}else{      
			alert("请输入一位数字类型!");  
			 obj.focus();
			return;
		}
	}
	
		//  只能输入0-9999999数 qulingmao 
	function checkNumSix(obj){ 
		if(!isNaN(obj.value)){    
			if(obj.value >999999 || obj.value <0){
				alert("个人收入数字，只能是0-999999 之间");
				  obj.focus();
				return;
			}
			
		}else{      
			alert("不是数字类型!");  
		}
	}
	function checkNumSix2(obj){ 
		if(!isNaN(obj.value)){    
			if(obj.value >999999 || obj.value <0){
				alert("其他收入数字，只能是0-999999 之间");
			    obj.focus();
				return;
			}
			
		}else{      
			alert("不是数字类型!");  
			
			return;
		}
	}
	//add by jshu  
	function checkMobile1(obj){
	    var sMobile = obj.value;
	    if(typeof(sMobile) == "undefined" || sMobile.length==0){
	    	alert("手机号码不能空");
	    	return false;
	    }
	    if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sMobile))){ 
	        alert("手机号码输入有误，请重新输入"); 
	      //add by jshu
	        //obj.focus();
		    //setItemValue(0,0,"MobileTelephone","");
	        return false; 
	    } 
	  
		   //add 增加填写手机号码，自动设置校验手机的号码 jshu
	    setItemValue(0,0,"PHONEVALIDATE",sMobile);
	   
	    initSendMessage();
	    sReturnMessageCode="";
	}
	
	//校验手机 add by dyh 20150618
	function checkMobile2(obj){
	    var sMobile = obj.value;
	    if(typeof(sMobile) == "undefined" || sMobile.length==0){
	    	alert("手机号码不能空");
	    	obj.focus();
	    	return false;
	    }
	    if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sMobile))){ 
	        alert("手机号码输入有误，请重新输入"); 
	        obj.focus();
	        return false; 
	    } 
	    setItemValue(0,0,"PHONEVALIDATE",sMobile);
	   
	    initSendMessage();
	    sReturnMessageCode="";
	}
	
	/*~[Describe=其他联系人电话验证;InputParam=无;OutPutParam=无;]~*/
	function checkContactTel(obj){
		var sContactTel=getItemValue(0,getRow(),"ContactTel");
		//空格自动忽略
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
					if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sContact))){    //非手机号
				        alert("手机号码格式填写错误"); 
				        obj.focus();
				        return false; 
				    
				}	
					}else if(sContact2=="0"){
					
					alert("固定电话格式填写错误"); 
					obj.focus();
		       		 return false; 
					
					}else{
						alert("号码格式填写不合法");
						obj.focus();
						return false;
					}
			}else if(sContact1.length=="2"){
				if(/^0\d{2,3}$/.test(sContact1[0])){
					if((/^0\d{2,3}-?\d{7,8}$/.test(sContact))){
						
					}else{
						alert("固定电话格式填写错误");
						obj.focus();
						return false;
					}
					
				}else{
					alert("区号填写错误");
					obj.focus();
					return false;
				}
				
			}else if(sContact1.length>"3"){
				alert("固定电话填写不规范，请重新填写");
				obj.focus();
				return false;
			}else{			
				if(/^0\d{2,3}$/.test(sContact1[0])){
					if((/^\d{7,8}$/.test(sContact1[1]))){
						 if((/^\d{1,8}$/.test(sContact1[2]))){
							 
						 }else{
							 alert("分机号码填写错误");
							 obj.focus();
							 return false;
						 }
						
					}else{
						alert("固定电话格式填写错误");
						obj.focus();
						return false;
					}
					
				}else{
					alert("区号填写错误");
					obj.focus();
					return false;
				}
				
			}
		   
	}
	
	
	/***********beging CCS-1181 新增其他联系方式 huzp 20151201***************************************************/
	/*~[Describe=其他联系方式验证;InputParam=无;OutPutParam=无;]~*/
	function checkOtherTelePhone(obj){
		var sOtherTelePhone=getItemValue(0,getRow(),"OTHERTELEPHONE");
		//空格自动忽略
		var sContact=sOtherTelePhone.replace(" ","");
		setItemValue(0,0,"OTHERTELEPHONE",sContact);
		 if(typeof(sContact) == "undefined" || sContact.length==0){     
			 return false;
		 }
			var sContact1=sContact.split("-");
			var sContact2=sContact.substring(0,1);
			
			if(sContact1.length=="1"){
					if(sContact2=="1"){
						if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sContact))){    //非手机号
					        alert("手机号码格式填写错误"); 
					        obj.focus();
					        return false; 
						}	
					}else if(sContact2=="0"){
						alert("固定电话格式填写错误（格式为：区号-主机号）");
						obj.focus();
			       		 return false; 
					}else{
						alert("号码格式填写不合法");
						obj.focus();
						return false;
					}
			}else if(sContact1.length=="2"){
				if(/^0\d{2,3}$/.test(sContact1[0])){
					if((/^0\d{2,3}-?\d{7,8}$/.test(sContact))){
					}else{
						alert("固定电话格式填写错误（格式为：区号-主机号）");
						obj.focus();
						return false;
					}
				}else{
					alert("区号填写错误");
					obj.focus();
					return false;
				}
			}else if(sContact1.length>"3"){
				alert("固定电话填写不规范，请重新填写");
				obj.focus();
				return false;
			}else{			
				if(/^0\d{2,3}$/.test(sContact1[0])){
					if((/^\d{7,8}$/.test(sContact1[1]))){
						 if((/^\d{1,8}$/.test(sContact1[2]))){
						 }else{
							 alert("分机号码填写错误");
							 obj.focus();
							 return false;
						 }
					}else{
						alert("固定电话格式填写错误（格式为：区号-主机号）");
						obj.focus();
						return false;
					}
				}else{
					alert("区号填写错误");
					obj.focus();
					return false;
				}
			}
	}
	/*********end*****************************************************/
	
	
	//亲属联系地址是否同户籍地址
	function selectFlag10(){
		var sFlag10 = getItemValue(0,0,"Flag10");
		
		//亲属联系地址
		//var sNativePlace = getItemValue(0,0,"NativePlace");
		var sNativePlaceName = getItemValue(0,0,"NativePlaceName");
		
		
		if(sFlag10=="1"){//如果是
			setItemValue(0,0,"KinshipAdd",sNativePlaceName);//亲属联系地址
		}else{
			setItemValue(0,0,"KinshipAdd","");//亲属联系地址
		}

	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateOrgID","<%=CurOrg.getOrgID()%>");
		setItemValue(0,0,"UpdateOrgName","<%=CurOrg.getOrgName()%>");
		setItemValue(0,0,"UpdateUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck(){
		var sCustomerType = "<%=sCustomerType.substring(0,2)%>";
		var sCustomerType2 = "<%=sCustomerType%>";
		
		
		if(sCustomerType == '01'){ //公司客户
			
			//8：校验贷款卡编号
			sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//贷款卡编号	
			if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" ){
				//检验贷款卡编号唯一性
				sCustomerID = getItemValue(0,getRow(),"CustomerID");//客户名称	
				sReturn=RunMethod("CustomerManage","CheckLoanCardNoChangeCustomer",sCustomerID+","+sLoanCardNo);
				if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") {
					alert(getBusinessMessage('227'));//该贷款卡编号已被其他客户占用！							
					return false;
				}					
			}
			
			//9:校验当是否征信标准集团客户为是时，则需输入上级公司名称、上级公司组织机构代码或上级公司贷款卡编号
			sSuperCertID = getItemValue(0,getRow(),"SuperCertID");//上级公司组织机构代码
	    	sECGroupFlag = getItemValue(0,getRow(),"ECGroupFlag");//是否征信标准集团客户
	    	
			if(sECGroupFlag == '1'){ //是否征信标准集团客户（1：是；2：否）
				
				//如果录入了上级公司组织机构代码，则需要校验上级公司组织机构代码的合法性，同时将上级公司证件类型设置为组织机构代码证
				if(typeof(sSuperCertID) != "undefined" && sSuperCertID != "" ){
					setItemValue(0,getRow(),'SuperCertType',"Ent01");
				}	
			}			
		}
		
		if(sCustomerType == '03' || sCustomerType2 == '03'){ //个人客户
			//1:校验证件类型为身份证或临时身份证时，出生日期是否同证件编号中的日期一致
			sCertType = getItemValue(0,getRow(),"CertType");//证件类型
			sCertID = getItemValue(0,getRow(),"CertID");//证件编号
			sBirthday = getItemValue(0,getRow(),"Birthday");//出生日期
			if(typeof(sBirthday) != "undefined" && sBirthday != "" ){
				if(sCertType == 'Ind01' || sCertType == 'Ind08'){
					//校身份证或临时身份证的长度
					if(sCertID.length != 15 && sCertID.length !=18){
						alert(getBusinessMessage('250')); //证件号码长度有误！							
						return false;
					}
					//将身份证中的日期自动赋给出生日期,把身份证中的性别赋给性别
					if(sCertID.length == 15){
						sSex = sCertID.substring(14);
						sSex = parseInt(sSex);
						sCertID = sCertID.substring(6,12);
						sCertID = "19"+sCertID.substring(0,2)+"/"+sCertID.substring(2,4)+"/"+sCertID.substring(4,6);
						if(sSex%2==0)//奇男偶女
							setItemValue(0,getRow(),"Sex","2");
						else
							setItemValue(0,getRow(),"Sex","1");
					}
					if(sCertID.length == 18){
						sSex = sCertID.substring(16,17);
						sSex = parseInt(sSex);
						sCertID = sCertID.substring(6,14);
						sCertID = sCertID.substring(0,4)+"/"+sCertID.substring(4,6)+"/"+sCertID.substring(6,8);
						if(sSex%2==0)//奇男偶女
							setItemValue(0,getRow(),"Sex","2");
						else
							setItemValue(0,getRow(),"Sex","1");
					}
					if(sBirthday != sCertID){
						alert(getBusinessMessage('200'));//出生日期和身份证中的出生日期不一致！	
						return false;
					}
				}
				
				if(sBirthday < '1900/01/01'){
					alert(getBusinessMessage('201'));//出生日期必须晚于1900/01/01！	
					return false;
				}
			}
				
			//4：校验手机号码
		    var sMobile = getItemValue(0,getRow(),"MobileTelephone");
		    if(typeof(sMobile) == "undefined" || sMobile.length==0){
		    	alert("手机号码不能为空！");
		    	return false;
		    }
		    if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sMobile))){
		        alert("手机号码输入有误，请重新输入");
		        return false; 
		    }
		    /* //办公/学校/个体电话
		    var sWorkTel = getItemValue(0,getRow(),"WorkTel");
		    if(typeof(sWorkTel) == "undefined" || sWorkTel.length==0){
		    	alert("办公/学校/个体电话不能空！"); 
		    	return false;
		    }
		    
		   // if(!(/^0\d{2,3}-?\d{7,8}$/.test(sWorkTel))){ 
		   if(!(/^[+]{0,4}(\d){1,3}[ ]?([-]?((\d)|[ ]){1,14})+$/.test(sWorkTel))){
		        alert("办公/学校/个体电话有误！"); 
		        //obj.focus();
			    //setItemValue(0,0,"WorkTel","");
		        return false; 
		    }  */
			
			//5.QQ号码
			sQqNo = getItemValue(0,getRow(),"QqNo");//QQ
			if(isNaN(sQqNo)==true){
				alert("QQ号码必须是数字！");
				return false;
			}
			
			//其他人联系电话、亲属联系电话校验
			/*sKinshipTel = getItemValue(0,getRow(),"KinshipTel");//QQ
			if(isNaN(sKinshipTel)==true){
				alert("亲属联系电话必须是数字！");
				return false;
			}
			sContactTel = getItemValue(0,getRow(),"ContactTel");//QQ
			if(isNaN(sContactTel)==true){
				alert("其他人联系电话必须是数字！");
				return false;
			}
			*/
			//身份证到期日校验
			 var sMaturityDate=getItemValue(0,getRow(),"MaturityDate");
			if(!checkMaturityDate()){
				return false;
			}
			//校验短信验证码  add by phe
 			 var sSubProductTypeqlm="<%=sSubProductType%>";
			 var sMessageCode=getItemValue(0,0,"CELLPHONEVERIFY");
			 var sPHONEVALIDATE = getItemValue(0,0,"PHONEVALIDATE");//获取当前页面电话号码
			 var sCustomerID = getItemValue(0,0,"CustomerID");
			 var sPhoneNum = RunMethod("公用方法", "GetColValue", "ind_info,PHONEVALIDATE,CustomerID='"+sCustomerID+"'");
			 var sOldMessageCode = RunMethod("公用方法", "GetColValue", "ind_info,CELLPHONEVERIFY,CustomerID='"+sCustomerID+"'");
			 //小企业贷无验证码
				if("6"!=sSubProductTypeqlm){
					 if(sMessageCode!=""&&(sPHONEVALIDATE!=sPhoneNum)){
						 
						 if(sReturnMessageCode!=sMessageCode){
							alert("你输入的验证码有误!");
							return false;	 
					 }
		 
				}
					 //给短信验证加上对手机号码不变的校验
					 if(sMessageCode!=""&&(sPHONEVALIDATE==sPhoneNum)&&(sReturnMessageCode!=sMessageCode)&&(sOldMessageCode!=sMessageCode)){
						 alert("你输入的验证码有误!");
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
		//判断所有手机号码不能重复
		
		//手机号码
		var sMobileTelephone = getItemValue(0,0,"MobileTelephone");
		//住宅电话
		var sFamilyTel = getItemValue(0,0,"FamilyTel");
		//办公/学校/个体电话
		var sWorkTel = getItemValue(0,0,"WorkTel");
		////办公/学校/个体电话分号
		var WorkTelPlus = getItemValue(0,0,"WorkTelPlus");
		//配偶电话号码
		var sSpouseTel = getItemValue(0,0,"SpouseTel");
		//亲属联系电话
		var sKinshipTel = getItemValue(0,0,"KinshipTel");
		//联系人电话
		var sContactTel = getItemValue(0,0,"ContactTel");
		
		//add by dyh 20150610
		//家庭成员单位电话
		var family_parents_companytel = getItemValue(0,0,"family_parents_companytel");
		//其他亲属联系电话
		var family_parents_telephone = getItemValue(0,0,"family_parents_telephone");
		//辅导员电话
		var school_counselor_telephone = getItemValue(0,0,"school_counselor_telephone");
		//学院/宿舍电话
		var school_dormitory_telephone = getItemValue(0,0,"school_dormitory_telephone");
		//end dyh
		
		var myArray =new Array(); 
		//把电话号码为空的去掉
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
			alert("所有关系的电话存在重复号码,请检测重复号码并修改!");
			return false;
		}
	}
	
    /*~[Describe=弹出企业类型选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/   
    function selectOrgType(){
        sParaString = "CodeNo"+",OrgType";      
        //'0110'大型企业客户，不能有“个体经营”选项     Add by zhuang 2010-03-17
        var sCustomerType = "<%=sCustomerType%>";
        if(sCustomerType =='0110'){
            setObjectValue("SelectBigOrgType",sParaString,"@OrgType@0@OrgTypeName@1",0,0,"");
        }else{
            setObjectValue("SelectCode",sParaString,"@OrgType@0@OrgTypeName@1",0,0,"");
        }
    }
    
	/*~[户籍地址省市选择窗口]~*/
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
        
		//增加清空功能的判断
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"NativePlace","");
			setItemValue(0,getRow(),"NativePlaceName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
					sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
					setItemValue(0,getRow(),"NativePlace",sAreaCodeValue);
					setItemValue(0,getRow(),"NativePlaceName",sAreaCodeName);			
			}
		}
	 }
	
	/*~[现居地址省市选择窗口]~*/
	function getFamilyAdd()
	{
		//var sAreaCode = getItemValue(0,getRow(),"City");
		//sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
        //加入邻接城市的判断  edit by pli2   20141117
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
        
		//增加清空功能的判断
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"FamilyAdd","");
			setItemValue(0,getRow(),"FamilyAddName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
					sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
					setItemValue(0,getRow(),"FamilyAdd",sAreaCodeValue);
					setItemValue(0,getRow(),"FamilyAddName",sAreaCodeName);			
			}
		}
	 }
	
	/*~[单位地址省市选择窗口]~*/
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
		
		//增加清空功能的判断
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"WorkAdd","");
			setItemValue(0,getRow(),"WorkAddName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
					sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
					setItemValue(0,getRow(),"WorkAdd",sAreaCodeValue);
					setItemValue(0,getRow(),"WorkAddName",sAreaCodeName);			
			}
		}
	 }

	
	/*~[现居住地，没有临近城市]~quliangmao*/
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
		//增加清空功能的判断
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),itemid,"");
			setItemValue(0,getRow(),itemname,"");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
					sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
					setItemValue(0,getRow(),itemid,sAreaCodeValue);
					setItemValue(0,getRow(),itemname,sAreaCodeName);			
			}
		}
	 }
	
	/*~[单位地址省市选择窗口]~*/
	function getWorkAddEdu(){
		//var sAreaCode = getItemValue(0,getRow(),"City");
		//sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		var sAreaCodeInfo = "";
			sAreaCodeInfo = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		//增加清空功能的判断
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"WorkAdd","");
			setItemValue(0,getRow(),"WorkAddName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
					sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
					setItemValue(0,getRow(),"WorkAdd",sAreaCodeValue);
					setItemValue(0,getRow(),"WorkAddName",sAreaCodeName);			
			}
		}
	 }
	
	/*~[邮寄地址省市选择窗口]~*/
	function getCommAdd()
	{
		//var sAreaCode = getItemValue(0,getRow(),"City");
		//sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
        var sAreaCodeInfo = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		
		//增加清空功能的判断
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"CommAdd","");
			setItemValue(0,getRow(),"CommAddName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
					sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
					setItemValue(0,getRow(),"CommAdd",sAreaCodeValue);
					setItemValue(0,getRow(),"CommAddName",sAreaCodeName);			
			}
		}
	 }
	 //现居住地址是否同户籍地址 quliangmao
	function selectYesNoEdu(){
		var sFlag2 = getItemValue(0,0,"Flag2");
		//获取户籍地址
		var sNativePlace = getItemValue(0,0,"NativePlace");
		var sNativePlaceName = getItemValue(0,0,"NativePlaceName");
		var sVillagetown = getItemValue(0,0,"Villagetown");
		var sStreet = getItemValue(0,0,"Street");
		var sCommunity = getItemValue(0,0,"Community");
		var sRoom = getItemValue(0,0,"CellNo");
		var sCommZip = getItemValue(0,0,"CommZip");
		//alert("----------------------"+sRoom);
		//alert("----------------------"+sFlag2);
		
		
		if(sFlag2=="1"){//如果是
			//查询出临近城市，匹配临近城市和门店城市        edit by awang 20141204
			//当前门店城市是否进行了临近城市的维护，如果未做维护，则不必校验
			var sReturnValue=RunMethod("NearCity","getSerialNo","<%=sStoreCity%>");
		    if(sReturnValue=="Null"){
		    	setItemValue(0,0,"FamilyAdd",sNativePlace);//现居住地址
				setItemValue(0,0,"FamilyAddName",sNativePlaceName);
				setItemValue(0,0,"Countryside",sVillagetown);//乡/镇(现居)
				setItemValue(0,0,"Villagecenter",sStreet);//街道/村（现居）
				setItemValue(0,0,"Plot",sCommunity);//小区/楼盘（现居）
				setItemValue(0,0,"Room",sRoom);//栋/单元/房间号（现居）
				setItemValue(0,0,"FamilyZIP",sCommZip);//居住地址邮编
		    	return;
		    }
				    //如果已做维护，需要查出临近城市
					var sReturn=RunMethod("NearCity","getNearCity","<%=sStoreCity%>");
				    if(sReturn=="Null"){
				    	sReturn="";
				    }
				    setItemValue(0,0,"FamilyAdd",sNativePlace);//现居住地址
					setItemValue(0,0,"FamilyAddName",sNativePlaceName);
					setItemValue(0,0,"Countryside",sVillagetown);//乡/镇(现居)
					setItemValue(0,0,"Villagecenter",sStreet);//街道/村（现居）
					setItemValue(0,0,"Plot",sCommunity);//小区/楼盘（现居）
					setItemValue(0,0,"Room",sRoom);//栋/单元/房间号（现居）
					setItemValue(0,0,"FamilyZIP",sCommZip);//居住地址邮编
			
		}else{
			setItemValue(0,0,"FamilyAdd","");//现居住地址
			setItemValue(0,0,"FamilyAddName","");
			setItemValue(0,0,"Countryside","");//乡/镇(现居)
			setItemValue(0,0,"Villagecenter","");//街道/村（现居）
			setItemValue(0,0,"Plot","");//小区/楼盘（现居）
			setItemValue(0,0,"Room","");//栋/单元/房间号（现居）
			setItemValue(0,0,"FamilyZIP","");//居住地址邮编
		}

	}
	
	/*~[插入地址到地址库]~*/
	function addNativePlace(obj){
		//户籍地址
		var sNativePlace = getItemValue(0,0,"NativePlace");
		var sNativePlaceName = getItemValue(0,0,"NativePlaceName");
		var sVillagetown = getItemValue(0,0,"Villagetown");
		var sStreet = getItemValue(0,0,"Street");
		var sCommunity = getItemValue(0,0,"Community");
		var sCellNo = getItemValue(0,0,"CellNo");
		
		//现居住地址
		var sFamilyAdd = getItemValue(0,0,"FamilyAdd");
		var sFamilyAddName = getItemValue(0,0,"FamilyAddName");
		var sCountryside = getItemValue(0,0,"Countryside");
		var sVillagecenter = getItemValue(0,0,"Villagecenter");
		var sPlot = getItemValue(0,0,"Plot");
		var sRoom = getItemValue(0,0,"Room");
		
		//单位地址
		var sWorkAdd = getItemValue(0,0,"WorkAdd");
		var sWorkAddName = getItemValue(0,0,"WorkAddName");
		var sUnitCountryside = getItemValue(0,0,"UnitCountryside");
		var sUnitStreet = getItemValue(0,0,"UnitStreet");
		var sUnitRoom = getItemValue(0,0,"UnitRoom");
		var sUnitNo = getItemValue(0,0,"UnitNo");
		
		//邮寄地址
		var sCommAdd = getItemValue(0,0,"CommAdd");
		var sCommAddName = getItemValue(0,0,"CommAddName");
		var sEmailCountryside = getItemValue(0,0,"EmailCountryside");
		var sEmailStreet = getItemValue(0,0,"EmailStreet");
		var sEmailPlot = getItemValue(0,0,"EmailPlot");
		var sEmailRoom = getItemValue(0,0,"EmailRoom");
		
		//客户编号
		var sCustomerID = getItemValue(0,0,"CustomerID");
		//地址类型：AddType
        var addType=obj;
		
        /** --update Object_Maxsn取号优化 tangyb 20150817 start-- 
        //获取流水号
		var sSerialNo = getSerialNo("Customer_Add_Info","SerialNo","");*/
		
		//获取流水号
		var sSerialNo = '<%=DBKeyUtils.getSerialNo("CA")%>';
        /** --end --*/

		

		if(addType=="03"){//户籍地址
			str=sNativePlace+","+sNativePlaceName+","+sVillagetown+","+sStreet+","+sCommunity+","+sCellNo+","+sCustomerID+","+addType+","+sSerialNo;
		    //alert("---户籍地址---"+str);
		}
		if(addType=="01"){//单位地址
			str=sWorkAdd+","+sWorkAddName+","+sUnitCountryside+","+sUnitStreet+","+sUnitRoom+","+sUnitNo+","+sCustomerID+","+addType+","+sSerialNo;
			//alert("---单位地址---"+str);
		}
		if(addType=="02"){//现居住地址
			str=sFamilyAdd+","+sFamilyAddName+","+sCountryside+","+sVillagecenter+","+sPlot+","+sRoom+","+sCustomerID+","+addType+","+sSerialNo;
			//alert("---现居住地址---"+str);
		}
		if(addType=="04"){//邮寄地址
			str=sCommAdd+","+sCommAddName+","+sEmailCountryside+","+sEmailStreet+","+sEmailPlot+","+sEmailRoom+","+sCustomerID+","+addType+","+sSerialNo;
			//alert("---邮寄地址--"+str);
		}
		//插入地址到地址仓库
		RunMethod("BusinessManage","UpdateAddressInfo",str);
        
	}
	
	/*~[插入电话到电话库]~*/
	function addPhoneInfo(obj){
		//手机号码
		var sMobileTelephone = getItemValue(0,0,"MobileTelephone");
		//住宅电话
		var sFamilyTel = getItemValue(0,0,"FamilyTel");
		//办公/学校/个体电话
		var sWorkTel = getItemValue(0,0,"WorkTel");
		//配偶电话号码
		var sSpouseTel = getItemValue(0,0,"SpouseTel");
		//亲属联系电话
		var sKinshipTel = getItemValue(0,0,"KinshipTel");
		//联系人电话
		var sContactTel = getItemValue(0,0,"ContactTel");
		//客户编号
		var sCustomerID = getItemValue(0,0,"CustomerID");
		//获取流水号
		/** --update Object_Maxsn取号优化 tangyb 20150817 start-- 
		var sSerialNo = getSerialNo("Phone_Info","SerialNo","");*/
		var sSerialNo = '<%=DBKeyUtils.getSerialNo("PI")%>';
		/** --end --*/

		if(obj=="01"){//手机号码
			str=sSerialNo+","+sCustomerID+","+sMobileTelephone+",010";
		}
		if(obj=="02"){//住宅电话
			str=sSerialNo+","+sCustomerID+","+sFamilyTel+",010";
		}
		if(obj=="03"){//办公/学校/个体电话
			str=sSerialNo+","+sCustomerID+","+sWorkTel+",999";
		}
		if(obj=="04"){//配偶电话号码
			str=sSerialNo+","+sCustomerID+","+sSpouseTel+",020";
		}
		if(obj=="05"){//亲属联系电话
			str=sSerialNo+","+sCustomerID+","+sKinshipTel+",060";
		}
		if(obj=="06"){//联系人电话
			str=sSerialNo+","+sCustomerID+","+sContactTel+",999";
		}
		
		//插入电话到电话仓库
		RunMethod("BusinessManage","UpdatePhoneInfo",str);
		
	}
	
	/*~[Describe=弹出国家/地区选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCountryCode(){
		sParaString = "CodeNo"+",CountryCode";			
		sCountryCodeInfo = setObjectValue("SelectCode",sParaString,"@CountryCode@0@CountryCodeName@1",0,0,"");
		if (typeof(sCountryCodeInfo) != "undefined" && sCountryCodeInfo != ""  && sCountryCodeInfo != "_NONE_" 
		&& sCountryCodeInfo != "_CLEAR_" && sCountryCodeInfo != "_CANCEL_")
		{
			sCountryCodeInfo = sCountryCodeInfo.split('@');
			sCountryCodeValue = sCountryCodeInfo[0];//-- 所在国家(地区)代码
			if(sCountryCodeValue != 'CHN') //当所在国家(地区)不为中华人民共和国时，需清除省份、直辖市、自治区的数据
			{
				setItemValue(0,getRow(),"RegionCode","");
				setItemValue(0,getRow(),"RegionCodeName","");
			}
		}
	}
	
	/*~[Describe=弹出信用等级评估模板选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCreditTempletType()
	{		
		sParaString = "CodeNo"+",CreditTempletType";			
		setObjectValue("SelectCode",sParaString,"@CreditBelong@0@CreditBelongName@1",0,0,"");
	}
	
	/*~[Describe=弹出对应评分卡模型模板选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectAnalyseType(sModelType)
	{		
		sParaString = "ModelType"+","+sModelType;			
		setObjectValue("selectAnalyseType",sParaString,"@CreditBelong@0@CreditBelongName@1",0,0,"");
	}
	/*~[Describe=弹出省份、直辖市、自治区选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getRegionCode(flag)
	{		
		if (flag != "ent") { //区分企业客户的行政区域和个人的籍贯
			sParaString = "CodeNo"+",AreaCode";			
			setObjectValue("SelectCode",sParaString,"@NativePlace@0@NativePlaceName@1",0,0,"");
		}
	}
	
	
	//计算月总收入
	function selectMonthTotal(){
		var sOneselfincome =getItemValue(0,0,"Oneselfincome");//本人月收入
		var sOtherRevenue =getItemValue(0,0,"OtherRevenue");//其他月收入
		var sSpouseIncome =getItemValue(0,0,"SpouseIncome");//配偶月收入

		if(!isNaN(sOneselfincome) && !isNaN(sOtherRevenue) && !isNaN(sSpouseIncome)){
			var stotal=parseFloat(sOneselfincome)+parseFloat(sOtherRevenue)+parseFloat(sSpouseIncome);
			//alert("--------------"+stotal);
	        dTotal = roundOff(stotal,2);//四舍五入保留2位小数

	        if(!isNaN(dTotal)){
			    setItemValue(0,0,"MonthTotal",dTotal);//月总收入
	        }
		 }
	 }
	
	//计算月净收入
	function selectNetmargin(){
		var sMonthTotal =getItemValue(0,0,"MonthTotal");//月总收入
		var sMonthexpend =getItemValue(0,0,"Monthexpend");//家庭月支出
		var sRentexpend =getItemValue(0,0,"Rentexpend");//月房租支出
		var sCreditMonth =getItemValue(0,0,"CreditMonth");//贷款月供

		if(!isNaN(sMonthTotal) && !isNaN(sMonthexpend) && !isNaN(sRentexpend) && !isNaN(sCreditMonth)){
			var stotal=parseFloat(sMonthTotal)-parseFloat(sMonthexpend)-parseFloat(sRentexpend)-parseFloat(sCreditMonth);
			//alert("--------------"+stotal);
	        dTotal = roundOff(stotal,2);//四舍五入保留2位小数

	        if(!isNaN(dTotal)){
			    setItemValue(0,0,"Netmargin",dTotal);//月净收入
	        }
		 }
	 }
	
	
	/*~[Describe=户籍所在地;InputParam=无;OutPutParam=无;]~*/
	function getRegionCodes()
	{
		var sAreaCode = getItemValue(0,getRow(),"NativePlace");
		sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");

		//增加清空功能的判断
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"NativePlace","");
			setItemValue(0,getRow(),"NativePlaceName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
					sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
					setItemValue(0,getRow(),"NativePlace",sAreaCodeValue);
					setItemValue(0,getRow(),"NativePlaceName",sAreaCodeName);			
			}
		}
	}
	
	//如果是已婚，配偶名称和号码为必输
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
	
	/*~[Describe=住所所在地;InputParam=无;OutPutParam=无;]~*/
	function getLiveRoom()
	{
		var sAreaCode = getItemValue(0,getRow(),"LiveRoom");
		sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");

		//增加清空功能的判断
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"LiveRoom","");
			setItemValue(0,getRow(),"LiveRoomName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
					sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
					setItemValue(0,getRow(),"LiveRoom",sAreaCodeValue);
					setItemValue(0,getRow(),"LiveRoomName",sAreaCodeName);			
			}
		}
	}

	/*~[Describe=户籍地址选择;InputParam=无;OutPutParam=无;]~*/
	function getRegionCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddManageList";
		sCompURL = "/CustomerManage/AddManageList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sAddress=sReturn[0];//
		sAddressName=sReturn[1];//
		sTownShip=sReturn[2];//
		sStreet=sReturn[3];//
		sCell=sReturn[4];//
		sRoom=sReturn[5];//
		
		setItemValue(0,0,"NativePlace",sAddress);//地址ID
		setItemValue(0,0,"NativePlaceName",sAddressName);//地址NAME
		setItemValue(0,0,"Villagetown",sTownShip);//乡/镇
		setItemValue(0,0,"Street",sStreet);//街道/村
		setItemValue(0,0,"Community",sCell);//小区/楼盘
		setItemValue(0,0,"CellNo",sRoom);//栋/单元/房间号
		
	}
	
	/*~[Describe=现居地址选择;InputParam=无;OutPutParam=无;]~*/
	function getAddCode(){
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddManageList";
		sCompURL = "/CustomerManage/AddManageList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sAddress=sReturn[0];//
		sAddressName=sReturn[1];//
		sTownShip=sReturn[2];//
		sStreet=sReturn[3];//
		sCell=sReturn[4];//
		sRoom=sReturn[5];//
		
		setItemValue(0,0,"FamilyAdd",sAddress);//现居住地址
		setItemValue(0,0,"FamilyAddName",sAddressName);
		setItemValue(0,0,"Countryside",sTownShip);//乡/镇(现居)
		setItemValue(0,0,"Villagecenter",sStreet);//街道/村（现居）
		setItemValue(0,0,"Plot",sCell);//小区/楼盘（现居）
		setItemValue(0,0,"Room",sRoom);//栋/单元/房间号（现居）
		
	}
	
	/*~[Describe=单位地址选择;InputParam=无;OutPutParam=无;]~*/
	function getCellRegionCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddManageList";
		sCompURL = "/CustomerManage/AddManageList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sAddress=sReturn[0];//
		sAddressName=sReturn[1];//
		sTownShip=sReturn[2];//
		sStreet=sReturn[3];//
		sCell=sReturn[4];//
		sRoom=sReturn[5];//
		
		setItemValue(0,0,"WorkAdd",sAddress);//地址ID
		setItemValue(0,0,"WorkAddName",sAddressName);//地址NAME
		setItemValue(0,0,"UnitCountryside",sTownShip);//乡/镇
		setItemValue(0,0,"UnitStreet",sStreet);//街道/村
		setItemValue(0,0,"UnitRoom",sCell);//小区/楼盘
		setItemValue(0,0,"UnitNo",sRoom);//栋/单元/房间号
	}	
	
	/*~[Describe=邮寄地址选择;InputParam=无;OutPutParam=无;]~*/
	function getEmailRegionCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddManageList";
		sCompURL = "/CustomerManage/AddManageList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sAddress=sReturn[0];//
		sAddressName=sReturn[1];//
		sTownShip=sReturn[2];//
		sStreet=sReturn[3];//
		sCell=sReturn[4];//
		sRoom=sReturn[5];//
		
		setItemValue(0,0,"CommAdd",sAddress);//地址ID
		setItemValue(0,0,"CommAddName",sAddressName);//地址NAME
		setItemValue(0,0,"EmailCountryside",sTownShip);//乡/镇
		setItemValue(0,0,"EmailStreet",sStreet);//街道/村
		setItemValue(0,0,"EmailPlot",sCell);//小区/楼盘
		setItemValue(0,0,"EmailRoom",sRoom);//栋/单元/房间号
	}
	
	/*~[Describe=住宅电话选择;InputParam=无;OutPutParam=无;]~*/
	function getPhoneCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sZipCode=sReturn[0];//区号
		sPhoneCode=sReturn[1];//电话号码
		sExtensionNo=sReturn[2];//分机号码
		sPhoneType=sReturn[3];//电话类型
		
		sFamilyTel=sZipCode+"-"+sPhoneCode;
		setItemValue(0,0,"FamilyTel",sFamilyTel);//住宅电话
		
	}
	
	/*~[Describe=手机号码选择;InputParam=无;OutPutParam=无;]~*/
	function getTelPhoneCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sZipCode=sReturn[0];//区号
		sPhoneCode=sReturn[1];//电话号码
		sExtensionNo=sReturn[2];//分机号码
		sPhoneType=sReturn[3];//电话类型
		
		setItemValue(0,0,"MobileTelephone",sPhoneCode);//手机号码
		
	}
	
	/*~[Describe=工作电话选择;InputParam=无;OutPutParam=无;]~*/
	function getWorkPhoneCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sZipCode=sReturn[0];//区号
		sPhoneCode=sReturn[1];//电话号码
		sExtensionNo=sReturn[2];//分机号码
		sPhoneType=sReturn[3];//电话类型
		
		if(sExtensionNo==""){
			sWorkTel=sZipCode+"-"+sPhoneCode;
		}else{
			sWorkTel=sZipCode+"-"+sPhoneCode+"-"+sExtensionNo;
		}
		
		setItemValue(0,0,"WorkTel",sWorkTel);//工作电话

	}
	
	/*~[Describe=传真号码;InputParam=无;OutPutParam=无;]~*/
	function getFaxNumber()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sZipCode=sReturn[0];//区号
		sPhoneCode=sReturn[1];//电话号码
		sExtensionNo=sReturn[2];//分机号码
		sPhoneType=sReturn[3];//电话类型
		
		sWorkTel=sZipCode+"-"+sPhoneCode;
		setItemValue(0,0,"FaxNumber",sWorkTel);//传真号码

	}
	
	/*~[Describe=配偶电话号码选择;InputParam=无;OutPutParam=无;]~*/
	function getSpouseTel()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sZipCode=sReturn[0];//区号
		sPhoneCode=sReturn[1];//电话号码
		sExtensionNo=sReturn[2];//分机号码
		sPhoneType=sReturn[3];//电话类型
		
		//sWorkTel=sZipCode+"-"+sPhoneCode+"-"+sExtensionNo;
		setItemValue(0,0,"SpouseTel",sPhoneCode);//配偶电话
		
	}
	
	
	/*~[Describe=联系人电话选择;InputParam=无;OutPutParam=无;]~*/
	function getLinkManCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		//alert("======================="+sReturn);
		
		sZipCode=sReturn[0];//区号
		sPhoneCode=sReturn[1];//电话号码
		sExtensionNo=sReturn[2];//分机号码
		sPhoneType=sReturn[3];//电话类型
		
		//sWorkTel=sZipCode+"-"+sPhoneCode+"-"+sExtensionNo;
		setItemValue(0,0,"ContactTel",sPhoneCode);//联系人电话
		
	}
	
	
	/*~[Describe=弹出国标行业类型选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getIndustryType()
	{
		var sIndustryType = getItemValue(0,getRow(),"IndustryType");
		//由于行业分类代码有几百项，分两步显示行业代码
		sIndustryTypeInfo = PopComp("IndustryVFrame","/Common/ToolsA/IndustryVFrame.jsp","IndustryType="+sIndustryType,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		//增加清空功能的判断
		if(sIndustryTypeInfo == "NO" ||sIndustryTypeInfo == '_CLEAR_' )
		{	
			setItemValue(0,getRow(),"IndustryType","");
			setItemValue(0,getRow(),"IndustryTypeName","");
		}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
		{
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];//-- 行业类型代码
			sIndustryTypeName = sIndustryTypeInfo[1];//--行业类型名称
			setItemValue(0,getRow(),"IndustryType",sIndustryTypeValue);
			setItemValue(0,getRow(),"IndustryTypeName",sIndustryTypeName);				
		}
	}
	
	//现居住地址是否同户籍地址
	function selectYesNo(){
		var sFlag2 = getItemValue(0,0,"Flag2");
		//获取户籍地址
		var sNativePlace = getItemValue(0,0,"NativePlace");
		var sNativePlaceName = getItemValue(0,0,"NativePlaceName");
		var sVillagetown = getItemValue(0,0,"Villagetown");
		var sStreet = getItemValue(0,0,"Street");
		var sCommunity = getItemValue(0,0,"Community");
		var sRoom = getItemValue(0,0,"CellNo");
		var sCommZip = getItemValue(0,0,"CommZip");
		//alert("----------------------"+sRoom);
		//alert("----------------------"+sFlag2);
		
		
		if(sFlag2=="1"){//如果是
			//查询出临近城市，匹配临近城市和门店城市        edit by awang 20141204
			//当前门店城市是否进行了临近城市的维护，如果未做维护，则不必校验
			var sReturnValue=RunMethod("NearCity","getSerialNo","<%=sStoreCity%>");
		    if(sReturnValue=="Null"){
		    	setItemValue(0,0,"FamilyAdd",sNativePlace);//现居住地址
				setItemValue(0,0,"FamilyAddName",sNativePlaceName);
				setItemValue(0,0,"Countryside",sVillagetown);//乡/镇(现居)
				setItemValue(0,0,"Villagecenter",sStreet);//街道/村（现居）
				setItemValue(0,0,"Plot",sCommunity);//小区/楼盘（现居）
				setItemValue(0,0,"Room",sRoom);//栋/单元/房间号（现居）
				setItemValue(0,0,"FamilyZIP",sCommZip);//居住地址邮编
		    	return;
		    }
		    //如果已做维护，需要查出临近城市
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
			 alert("地址不在门店城市及临近城市！");
		     setItemValue(0,0,"Flag2","2");
			 }else{
				    setItemValue(0,0,"FamilyAdd",sNativePlace);//现居住地址
					setItemValue(0,0,"FamilyAddName",sNativePlaceName);
					setItemValue(0,0,"Countryside",sVillagetown);//乡/镇(现居)
					setItemValue(0,0,"Villagecenter",sStreet);//街道/村（现居）
					setItemValue(0,0,"Plot",sCommunity);//小区/楼盘（现居）
					setItemValue(0,0,"Room",sRoom);//栋/单元/房间号（现居）
					setItemValue(0,0,"FamilyZIP",sCommZip);//居住地址邮编
			 }
			
		}else{
			setItemValue(0,0,"FamilyAdd","");//现居住地址
			setItemValue(0,0,"FamilyAddName","");
			setItemValue(0,0,"Countryside","");//乡/镇(现居)
			setItemValue(0,0,"Villagecenter","");//街道/村（现居）
			setItemValue(0,0,"Plot","");//小区/楼盘（现居）
			setItemValue(0,0,"Room","");//栋/单元/房间号（现居）
			setItemValue(0,0,"FamilyZIP","");//居住地址邮编
		}

	}
	
	function selectYesNo2(){
		var sFlag8 = getItemValue(0,0,"Flag8");
		
		//alert("--------------"+sFlag8);
		//获取户籍地址
		var sNativePlace = getItemValue(0,0,"NativePlace");
		var sNativePlaceName = getItemValue(0,0,"NativePlaceName");
		var sVillagetown = getItemValue(0,0,"Villagetown");
		var sStreet = getItemValue(0,0,"Street");
		var sCommunity = getItemValue(0,0,"Community");
		var sCellNo = getItemValue(0,0,"CellNo");
		//获取单位地址
		var sWorkAdd = getItemValue(0,0,"WorkAdd");
		var sWorkAddName = getItemValue(0,0,"WorkAddName");
		var sUnitCountryside = getItemValue(0,0,"UnitCountryside");
		var sUnitStreet = getItemValue(0,0,"UnitStreet");
		var sUnitRoom = getItemValue(0,0,"UnitRoom");
		var sUnitNo = getItemValue(0,0,"UnitNo");

		//获取现居住地址
        var sFamilyAdd = getItemValue(0,0,"FamilyAdd");
        var sFamilyAddName = getItemValue(0,0,"FamilyAddName");
        var sCountryside = getItemValue(0,0,"Countryside");
        var sVillagecenter = getItemValue(0,0,"Villagecenter");
        var sPlot = getItemValue(0,0,"Plot");
        var sRoom = getItemValue(0,0,"Room");
  
		if(sFlag8=="1"){//同现居住地址
			setItemValue(0,0,"CommAdd",sFamilyAdd);
			setItemValue(0,0,"CommAddName",sFamilyAddName);
			setItemValue(0,0,"EmailCountryside",sCountryside);
			setItemValue(0,0,"EmailStreet",sVillagecenter);
			setItemValue(0,0,"EmailPlot",sPlot);
			setItemValue(0,0,"EmailRoom",sRoom);
		}else if(sFlag8=="2"){//同单位/学校地址
			setItemValue(0,0,"CommAdd",sWorkAdd);
			setItemValue(0,0,"CommAddName",sWorkAddName);
			setItemValue(0,0,"EmailCountryside",sUnitCountryside);
			setItemValue(0,0,"EmailStreet",sUnitStreet);
			setItemValue(0,0,"EmailPlot",sUnitRoom);
			setItemValue(0,0,"EmailRoom",sUnitNo);
		}else if(sFlag8=="3"){//同户籍地址
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
	
	//add by dyh 20150601 CCS-733 学生贷
	function selectYesNo3(){
		var sFlag8 = getItemValue(0,0,"Flag8");
		
		//alert("--------------"+sFlag8);
		//获取户籍地址
		var sNativePlace = getItemValue(0,0,"NativePlace");
		var sNativePlaceName = getItemValue(0,0,"NativePlaceName");
		var sVillagetown = getItemValue(0,0,"Villagetown");
		var sStreet = getItemValue(0,0,"Street");
		var sCommunity = getItemValue(0,0,"Community");
		var sCellNo = getItemValue(0,0,"CellNo");
		//获取学校地址
		var sSchoolAdd = getItemValue(0,0,"school_address");
		var sSchoolAddName = getItemValue(0,0,"school_addressName");
		var sSchoolCountryside = getItemValue(0,0,"school_township");
		var sSchoolStreet = getItemValue(0,0,"school_street");
		var sSchoolCommunity = getItemValue(0,0,"school_community");
		var sSchoolNo = getItemValue(0,0,"school_room_no");

		//获取现居住地址
        var sFamilyAdd = getItemValue(0,0,"FamilyAdd");
        var sFamilyAddName = getItemValue(0,0,"FamilyAddName");
        var sCountryside = getItemValue(0,0,"Countryside");
        var sVillagecenter = getItemValue(0,0,"Villagecenter");
        var sPlot = getItemValue(0,0,"Plot");
        var sRoom = getItemValue(0,0,"Room");
  
		if(sFlag8=="1"){//同现居住地址
			setItemValue(0,0,"CommAdd",sFamilyAdd);
			setItemValue(0,0,"CommAddName",sFamilyAddName);
			setItemValue(0,0,"EmailCountryside",sCountryside);
			setItemValue(0,0,"EmailStreet",sVillagecenter);
			setItemValue(0,0,"EmailPlot",sPlot);
			setItemValue(0,0,"EmailRoom",sRoom);
		}else if(sFlag8=="2"){//同单位/学校地址
			setItemValue(0,0,"CommAdd",sSchoolAdd);
			setItemValue(0,0,"CommAddName",sSchoolAddName);
			setItemValue(0,0,"EmailCountryside",sSchoolCountryside);
			setItemValue(0,0,"EmailStreet",sSchoolStreet);
			setItemValue(0,0,"EmailPlot",sSchoolCommunity);
			setItemValue(0,0,"EmailRoom",sSchoolNo);
		}else if(sFlag8=="3"){//同户籍地址
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
	
	
	/*~[Describe=弹出机构选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getOrg()
	{		
		setObjectValue("SelectAllOrg","","@OrgID@0@OrgName@1",0,0,"");
	}
	
	/*~[Describe=弹出用户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getUser()
	{		
		var sOrg = getItemValue(0,getRow(),"OrgID");
		sParaString = "BelongOrg,"+sOrg;	
		if (sOrg.length != 0 )
		{		
			setObjectValue("SelectUserBelongOrg",sParaString,"@UserID@0@UserName@1",0,0,"");
		}else
		{
			alert(getBusinessMessage('132'));//请先选择管户机构！
		}
	}
	
	function setspouse_address(datatype){
		//var sAreaCode = getItemValue(0,getRow(),"City");
		//sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		var sAreaCodeInfo = "";
			sAreaCodeInfo = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		//增加清空功能的判断
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"spouse_address","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
					sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
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
		//增加清空功能的判断
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"KINSHIPADD","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
					sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
					if("s"==datatype){
						setItemValue(0,getRow(),"KINSHIPADD",sAreaCodeName);
					}else{
						setItemValue(0,getRow(),"KINSHIPADD",sAreaCodeName);
					}
			}
		}
	 }
						
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if("020" == "<%=sProductID%>")
		{
			var sObjectNo = "<%=sObjectNo%>";
			//现金贷-是否第一次录入客户信息标志（空或1表示第一次录入，0为已录入过）
			var sIsCashLoanTemp = RunMethod("公用方法", "GetColValue", "Business_Contract,IsCashLoanTemp,SerialNo='"+sObjectNo+"'");
			if(null == sIsCashLoanTemp) sIsCashLoanTemp = "";
			//除已录入过外，其他情况均需要置空客户的手机、工作、家庭联系人信息
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
			 o.value="点击获取";
			}
		
	  if (getRowCount(0)==0){ //如果没有找到对应记录，则新增一条，并设置字段默认值
			as_add("myiframe0");//新增记录
			bIsInsert = true;
		var sCountryCode = getItemValue(0,getRow(),"Country");
		var sInputUserID = getItemValue(0,getRow(),"InputUserID");
		var sCreditBelong = getItemValue(0,getRow(),"CreditBelong");
		
		var sHasIERight = getItemValue(0,getRow(),"HasIERight");
		var SECGroupFlag = getItemValue(0,getRow(),"ECGroupFlag");
		var sLoanFlag = getItemValue(0,getRow(),"LoanFlag");
		var sListingCorpType = getItemValue(0,getRow(),"ListingCorpOrNot");// add by zhuang 2010-03-17
		
        //设置上市公司类型默认值为“非上市”  add by zhuang 2010-03-17        
        if(sListingCorpType=="")
        {   
            //"2"是字段"ListingCorpOrNot"在模板中对应所用代码ListingCorpType的ItemNo值，表示非上市
            setItemValue(0,getRow(),"ListingCorpOrNot","2");
        }
	    
		//设置字段默认值
		if (sCountryCode=="")
		{
			setItemValue(0,getRow(),"Country","CHN");
		}

		//设置大型企业的企业规模默认值 add by cbsu 2009-11-02
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
			setItemValue(0,getRow(),"CreditBelongName","企业化管理的事业单位信用等级评估表");
		}
		if("<%=sCustomerInfoTemplet%>" == "IndEntInfo")
		{
		    setItemValue(0,getRow(),"FinanceBelong","050");			
		}
		
		sCustomerType = "<%=sCustomerType.substring(0,2)%>";
		sCertType = getItemValue(0,0,"CertType");//--证件类型	
		sCertID = getItemValue(0,0,"CertID");//--证件号码
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
		if(sCustomerType == '01')//公司客户
		{
			if(sLoanFlag == "")
			setItemValue(0,getRow(),"LoanFlag","1");
			if(sHasIERight == "")
			setItemValue(0,getRow(),"HasIERight","2");
			if(SECGroupFlag == "")
			setItemValue(0,getRow(),"ECGroupFlag","2");
		}
		if(sCustomerType == '03' ||sCustomerType == '0310') //个人客户
		{	
			//判断身份证合法性,个人身份证号码应该是15或18位！
			if(sCertType =='Ind01' || sCertType =='Ind08')
			{
				//将身份证中的日期自动赋给出生日期
				if(sCertID.length == 15)
				{
					sSex = sCertID.substring(14);
					sSex = parseInt(sSex);
					sCertID = sCertID.substring(6,12);
					sCertID = "19"+sCertID.substring(0,2)+"/"+sCertID.substring(2,4)+"/"+sCertID.substring(4,6);
					setItemValue(0,getRow(),"Birthday",sCertID);
					if(sSex%2==0)//奇男偶女
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
					if(sSex%2==0)//奇男偶女
						setItemValue(0,getRow(),"Sex","2");
					else
						setItemValue(0,getRow(),"Sex","1");
				}
			}
			
		}
	  }
	  
	  // 如果身份证号倒数第二位为基数，性别默认为男性
	  var sCertId = getItemValue(0, 0, "CertID");
	  var iLastTwo = parseInt(sCertId.charAt(sCertId.length-2));
	  if (iLastTwo%2 == 0) {
		setItemValue(0, 0, "Sex", "2");  
	  } else if (iLastTwo%2 == 1) {
		setItemValue(0, 0, "Sex", "1");  
	  }
    }
	
	//年龄计算
	function selectAge(){
		var sBirthday = getItemValue(0,getRow(),"Birthday");//客户详情中的出生日期
		    
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
			    alert("出生日期选择错误!");
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
	
	//国籍判断
	function selectCoCode(){
		var sCountry = getItemValue(0,getRow(),"Country");

		if(sCountry =="CHN"){//中国
			setItemRequired(0,0,"LiveDate",false);//在中国开始居住时间 必输
			setItemRequired(0,0,"NativePlaceName",true);//户籍所在地
		}else if(sCountry =="HKG"){//香港
			setItemRequired(0,0,"LiveDate",false);
			setItemRequired(0,0,"NativePlaceName",false);
		}else if(sCountry =="MAC"){//澳门
			setItemRequired(0,0,"LiveDate",false);
			setItemRequired(0,0,"NativePlaceName",false);
		}else if(sCountry ==""){//为空时
			setItemRequired(0,0,"LiveDate",false);
			setItemRequired(0,0,"NativePlaceName",false);
		}else{
			setItemRequired(0,0,"LiveDate",true);
			setItemRequired(0,0,"NativePlaceName",false);
		}
	}
	
	
	
	/*~[Describe=初始化客户号字段;InputParam=无;OutPutParam=无;]~*/
	function initCustomerID(){
		var sTableName = "CUSTOMER_INFO";//表名
		var sColumnName = "CustomerID";//字段名
		var sPrefix = "";//前缀
       
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
    //利用String.replace函数，将字符串左右两边的空格替换成空字符串
    function Trim (sTmp)
    {
     	return sTmp.replace(/^(\s+)/,"").replace(/(\s+)$/,"");
    }
	
	//根据 行业类型、员工人数、销售额、资产总额确定中小企业规模
	function EntScope() {
		/*
		方法说明：
		参见文档《统计上大中小型企业划分办法（暂行）》国家统计局设管司
		计算依赖的指标包括：行业类型、员工人数、销售额、资产总额
		*/
		var sIndustryType = getItemValue(0,getRow(),"IndustryType");//中小企业行业
		var sLastYearSale = getItemValue(0,getRow(),"SellSum");//年销售额
		var sCapitalAmount = getItemValue(0,getRow(),"TOTALASSETS");//资产总额
		var sEmployeeNumber = getItemValue(0,getRow(),"EmployeeNumber");//员工人数
		if(typeof(sIndustryType)=="undefined" || sIndustryType.length==0)
			return;
		if(typeof(sLastYearSale)=="undefined" || sLastYearSale.length==0)
			return;
		if(typeof(sCapitalAmount)=="undefined" || sCapitalAmount.length==0)
			return;
		if(typeof(sEmployeeNumber)=="undefined" || sEmployeeNumber.length==0)
			return;
		if(sIndustryType.substring(0,1)=="B" || sIndustryType.substring(0,1)=="C"||sIndustryType.substring(0,1)=="D"){ //工业类企业
			if(sEmployeeNumber>=2000&&sLastYearSale>=30000&&sCapitalAmount>=40000){ //大型
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<300||sLastYearSale<3000||sCapitalAmount<4000){ //小型
				setItemValue(0,getRow(),"Scope","03");
			}else{ //中型
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="E"){ //建筑业企业
			if(sEmployeeNumber>=3000&&sLastYearSale>=30000&&sCapitalAmount>=40000){ //大型
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<600||sLastYearSale<3000||sCapitalAmount<4000){ //小型
				setItemValue(0,getRow(),"Scope","03");
			}else{ //中型
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="H63"){ //批发业企业
			if(sEmployeeNumber>=200&&sLastYearSale>=30000){ //大型
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<3000){ //小型
				setItemValue(0,getRow(),"Scope","03");
			}else{ //中型
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="H65"){ //零售业企业
			if(sEmployeeNumber>=500&&sLastYearSale>=15000){ //大型
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<1000){ //小型
				setItemValue(0,getRow(),"Scope","03");
			}else{ //中型
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="F" && sIndustryType.substring(0,3)!="F59"&& sIndustryType.substring(0,3)!="F58"){ //交通运输业企业
			if(sEmployeeNumber>=3000&&sLastYearSale>=30000){ //大型
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<500||sLastYearSale<3000){ //小型
				setItemValue(0,getRow(),"Scope","03");
			}else{ //中型
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="F59"){ //邮政业企业
			if(sEmployeeNumber>=1000&&sLastYearSale>=30000){ //大型
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<400||sLastYearSale<3000){ //小型
				setItemValue(0,getRow(),"Scope","03");
			}else{ //中型
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="I"){ //住宿和餐饮业
			if(sEmployeeNumber>=800&&sLastYearSale>=15000){ //大型
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<400||sLastYearSale<3000){ //小型
				setItemValue(0,getRow(),"Scope","03");
			}else{ //中型
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="A"){ //农林牧渔企业
			if(sEmployeeNumber>=3000&&sLastYearSale>=15000){ //大型
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<500||sLastYearSale<1000){ //小型
				setItemValue(0,getRow(),"Scope","03");
			}else{ //中型
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="F58"){ //仓储企业
			if(sEmployeeNumber>=500&&sLastYearSale>=15000){ //大型
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<1000){ //小型
				setItemValue(0,getRow(),"Scope","03");
			}else{ //中型
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="K"){ //房地产企业
			if(sEmployeeNumber>=200&&sLastYearSale>=15000){ //大型
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<1000){ //小型
				setItemValue(0,getRow(),"Scope","03");
			}else{ //中型
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="J"){ //金融企业
			if(sEmployeeNumber>=500&&sLastYearSale>=50000){ //大型
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<5000){ //小型
				setItemValue(0,getRow(),"Scope","03");
			}else{ //中型
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="M78" ||sIndustryType.substring(0,1)=="N"){ //地质勘查和水利环境管理企业
			if(sEmployeeNumber>=2000&&sLastYearSale>=20000){ //大型
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<600||sLastYearSale<2000){ //小型
				setItemValue(0,getRow(),"Scope","03");
			}else{ //中型
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="R"){ //文体、娱乐企业
			if(sEmployeeNumber>=600&&sLastYearSale>=15000){ //大型
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<200||sLastYearSale<3000){ //小型
				setItemValue(0,getRow(),"Scope","03");
			}else{ //中型
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="M"&&sIndustryType.substring(0,3)!="M78"){ //信息传输企业
			if(sEmployeeNumber>=400&&sLastYearSale>=30000){ //大型
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<3000){ //小型
				setItemValue(0,getRow(),"Scope","03");
			}else{ //中型
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="G"){ //计算机服务软件企业
			if(sEmployeeNumber>=300&&sLastYearSale>=30000){ //大型
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<3000){ //小型
				setItemValue(0,getRow(),"Scope","03");
			}else{ //中型
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="L73"){ //租赁企业
			if(sEmployeeNumber>=300&&sLastYearSale>=15000){ //大型
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<1000){ //小型
				setItemValue(0,getRow(),"Scope","03");
			}else{ //中型
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,3)=="L74"){ //商务及科技服务企业
			if(sEmployeeNumber>=400&&sLastYearSale>=15000){ //大型
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<1000){ //小型
				setItemValue(0,getRow(),"Scope","03");
			}else{ //中型
				setItemValue(0,getRow(),"Scope","02");
			}
		}else if(sIndustryType.substring(0,1)=="O"){ //居民服务企业
			if(sEmployeeNumber>=800&&sLastYearSale>=15000) { //大型
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<200||sLastYearSale<1000){ //小型
				setItemValue(0,getRow(),"Scope","03");
			}else{ //中型
				setItemValue(0,getRow(),"Scope","02");
			}
		}else{ //其他企业
			if(sEmployeeNumber>=500&&sLastYearSale>=15000){ //大型
				setItemValue(0,getRow(),"Scope","01");
			}else if(sEmployeeNumber<100||sLastYearSale<1000){ //小型
				setItemValue(0,getRow(),"Scope","03");
			}else{ //中型
				setItemValue(0,getRow(),"Scope","02");
			}
		}
	}

	//add 现金贷-申请表模版
	//配偶单位名称格式检查
	function CheckSpouseWorkCorp(obj)
	{
		var sSpouseWorkCorp = obj.value;
		if(typeof(sSpouseWorkCorp) == "undefined" || sSpouseWorkCorp.length==0){
			return false;
		}
		if(!(/^[a-zA-Z0-9\u4e00-\u9fa5]+$/.test(sSpouseWorkCorp))){
			alert("配偶单位名称输入非法");
			obj.focus();
			return false;
		}
	}

	//配偶单位电话格式检查
	function CheckSpouseWorkTel(obj)
	{
		var sSpouseWorkTel = obj.value;
		if(typeof(sSpouseWorkTel) == "undefined" || sSpouseWorkTel.length==0){
			return false;
		}
		if(!(/^[+]{0,4}(\d){1,3}[ ]?([-]?((\d)|[ ]){1,14})+$/.test(sSpouseWorkTel))){
	        alert("配偶单位电话有误！"); 
	        obj.focus();
	        return false; 
	    } 
	}
	//现金贷-客户部分信息置空（客户的手机、工作、家庭联系人信息），重新录入
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
/* 	//add by jshu 短信验证手机的发送功能
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
			
		
			alert("请等待"+time+"秒后重试");
			return ;
		}
		//ShowMessage("系统正在发送......,60秒后请重试",true,true);
		//setTimeout("hideMessage()",6000);	
		//var v=$(window.frames["ObjectList"].frames["tab_T001_iframe_1"].frames["DeskTopInfo"].frames["right"].frames["myiframe0"].document).find("#sendMessage")
		//.click=function(){time(this);}
		
	} */
	//add by phe 2015/05/15 短信验证
	function sendMessage(){
		var TelePhone=getItemValue(0,0,"PHONEVALIDATE");
		if(typeof(TelePhone) == "undefined" || TelePhone.length==0){
			alert("请输入手机号码!");
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
			o.value="点击获取";	
		    initSendMessage();
			wait = 60;		
			} else {			
				o.setAttribute("disabled", true);			
				o.value="重新发送(" + wait + ")";			
				wait--;			
				setTimeout(function() {				
					time(o);		
					},			
					1000);		
					}	
		}
	//设置短信短信验证不同的样式
	function initSendMessage(){

		 var sPHONEVALIDATE = getItemValue(0,0,"PHONEVALIDATE");//获取当前页面电话号码
		 var sCustomerID = getItemValue(0,0,"CustomerID");
		 var sPhoneNum = RunMethod("公用方法", "GetColValue", "ind_info,PHONEVALIDATE,CustomerID='"+sCustomerID+"'");
		 var sMessageCode=getItemValue(0,0,"CELLPHONEVERIFY");
		 var sTempSaveFlag = getItemValue(0,0,"TempSaveFlag");
		 var sOldMessageCode = RunMethod("公用方法", "GetColValue", "ind_info,CELLPHONEVERIFY,CustomerID='"+sCustomerID+"'");

		 var o = document.all("myiframe0").contentWindow.document.getElementById("sendMessage");
		 if(sPHONEVALIDATE==sPhoneNum&&sMessageCode!=""&&sTempSaveFlag!="1"&&sMessageCode==sOldMessageCode){
			 o.setAttribute("disabled", true);
			 setItemReadOnly(0,0,"CELLPHONEVERIFY",true);
			 o.value="点击获取";
		 }else{
			 o.setAttribute("disabled", false);
			 setItemReadOnly(0,0,"CELLPHONEVERIFY",false);
			 o.value="点击获取";
			
		 }
		 wait = 0;
		 
	}
	//end by phe
	//是否有本地房产
	function selectWay(){
		var isHouse=getItemValue(0,0,"isHouse");
		if(isHouse == '1'){
			//设置必选项，如果选择有房产，显示”房产地址“、”房产类型“、”房产面积“、“产权属于人”为必输
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
			//设置必选项，如果选择有贷款，显示”贷款银行“、”贷款开始时间“、”贷款结束时间“、“贷款金额”为必输
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
	//检查文本正确性
	function checkForms(obj){
		var nameStr=obj.value;
	
        var iu, iuu, regArray=new Array("","◎","■","●","№","↑","→","↓","!","@","#","$","%","^","&","*","_","+","=","|","","[","]","？","~","`"+
        "!","<",">","‰","→","←","↑","↓","¤","§","＃","＆","＆","＼","≡","≠","?","、","/"+
        "≈","∈","∪","∏","∑","∧","∨","⊥","∥","∥","∠","⊙","≌","≌","√","∝","∞","∮","，","。","&","？","：","《","》","【","】","{","}","~","！","￥","…"+
        "∫","≯","≮","＞","≥","≤","≠","±","＋","÷","×","/","Ⅱ","Ⅰ","Ⅲ","Ⅳ","Ⅴ","Ⅵ","Ⅶ","Ⅷ","Ⅹ","Ⅻ"+
        "╄","╅","╇","┻","┻","┇","┭","┷","┦","┣","┝","┤","┷","┷","┹","╉","╇","【","】"+
        "①","②","③","④","⑤","⑥","⑦","⑧","⑨","⑩","┌","├","┬","┼","┍","┕","┗","┏","┅","—"+
        "〖","〗","←","〓","☆","§","□","‰","◇","＾","＠","△","▲","＃","℃","※",".","≈","￠"); 
        iuu=regArray.length;
        for(iu=1;iu<=iuu;iu++){
               if (nameStr.indexOf(regArray[iu])!=-1){
            	   if(regArray[iu]){
                      alert("名称不能包含：【" + regArray[iu]+"】字符");
                      obj.focus();
                      return ;
            	   }
               }
        }
 	  return true;              
 	}
	
	//CCS-890 PRM-472 短信验证码为空需要备注原因 
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
		if(display==undefined || display=="block") display = ""; //暂时这么处理
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
        
        //试点城市，且职务为农民
        if("10" == sHeadShip && "1" == sPilotC ){
        	
        	//门店所在城市、户籍地址与居住地址三者需一致，才可以提交成功。
        	if( sCity != sNativePlace || sCity != sFamilyAdd || sCity != sWorkAdd ){
        		alert("在特定城市下，职位选择农民时，现居住地址选择临近城市无效，即门店所在城市、户籍地址、居住地址、单位地址需一致.");
        		return false;
        	}
        }
        
        return true;
		
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
	cellphoneverifyRemarkChange();//CCS-890
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
