<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   sjchuan  2009-10-13
		Tester:
		Content: 个体经营户企业信息详情页面
		Input Param:
			  CustomerID:--客户号
		Output param:
		History Log: 
           DATE	     CHANGER		CONTENT
	 */
	%>
<%/*~END~*/%> 


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "个体经营户企业客户信息概况"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sCustomerInfoTemplet = "";//--模板类型
    String sSql = "";//--存放sql语句
    String sCustomerType = "";//--存放客户类型   
    String sCustomerScale = "";//--中小客户规模   
    String sItemAttribute = "" ;
	String sCertType = "",sCertID = "",sAttribute3 = "";
	ASResultSet rs = null;//-- 存放结果集
	
	//获得组件参数,客户代码
    String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//取得客户类型
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
	//取得视图模板类型
	sSql = " select ItemAttribute,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = :ItemNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sCustomerType));
	if(rs.next()){
		sItemAttribute = DataConvert.toString(rs.getString("ItemAttribute"));		//客户详情树图类型
		sAttribute3 = DataConvert.toString(rs.getString("Attribute3"));		//中小企业客户详情树图类型
	}
	rs.getStatement().close(); 
	
	if(sCustomerScale!=null&&sCustomerScale.startsWith("02")){
		//公司客户管理显示模板
		sCustomerInfoTemplet = sAttribute3;		//中小公司客户详情显示模板
	}else{
		//公司客户管理显示模板
		sCustomerInfoTemplet = sItemAttribute;		//公司客户详情显示模板
	}
	
	sCustomerInfoTemplet = "IndEnterpriseInfo11";
	if(sCustomerInfoTemplet == null) sCustomerInfoTemplet = "";
		
	if(sCustomerInfoTemplet.equals(""))
		throw new Exception("客户信息不存在或客户类型未设置！"); 
	sCustomerType = "01";
	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = sCustomerInfoTemplet;	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//设置国内地区选择方式
	doTemp.appendHTMLStyle("RegionName"," style=\"cursor: pointer;\" onClick=\"javascript:parent.getRegionCode()\" ");	
	//设置注册资本范围
	doTemp.appendHTMLStyle("RegisterCapital"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"注册资本必须大于等于0！\" ");
	//设置职工人数范围
	doTemp.appendHTMLStyle("EmployeeNumber"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"职工人数必须大于等于0！\" ");
	//设置实收资本范围
	doTemp.appendHTMLStyle("PaiclUpCapital"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"实收资本必须大于等于0！\" ");
	//设置经营场地面积（平方米）范围
	doTemp.appendHTMLStyle("WorkFieldArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"经营场地面积（平方米）必须大于等于0！\" ");
	//设置家庭月收入(元)范围
	doTemp.appendHTMLStyle("FamilyMonthIncome"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"家庭月收入(元)必须大于等于0！\" ");
	//设置个人年收入(元)范围
	doTemp.appendHTMLStyle("YearIncome"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"个人年收入(元)必须大于等于0！\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
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
			{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"true","","Button","新增经营企业","新增经营企业","saveRecordTemp()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
		//录入数据有效性检查
		if (!ValidityCheck()) return;
		beforeUpdate();						
		setItemValue(0,getRow(),'TempSaveFlag',"2");//暂存标志（1：是；2：否）
		as_save("myiframe0",sPostEvents);		
	}
		
	function saveRecordTemp(){
		alert("您无权新增！");	
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

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
		var sCustomerType = "01";
		if(sCustomerType == '01'){ //公司客户
			//1：校验营业执照到期日是否小于营业执照起始日			
			var sLicensedate = getItemValue(0,getRow(),"Licensedate");//营业执照登记日			
			var sLicenseMaturity = getItemValue(0,getRow(),"LicenseMaturity");//营业执照到期日
			var sToday = "<%=StringFunction.getToday()%>";//当前日期
			if(typeof(sLicensedate) != "undefined" && sLicensedate != "" && 
			typeof(sLicenseMaturity) != "undefined" && sLicenseMaturity != ""){
				if(sLicensedate >= sToday){
					alert(getBusinessMessage('132'));//营业执照登记日必须早于当前日期！
					return false;		    
				}
				if(sLicenseMaturity <= sLicensedate){
					alert(getBusinessMessage('118'));//营业执照到期日必须晚于营业执照登记日！
					return false;		    
				}
			}
			//2：校验当所在国家(地区)不为中华人民共和国时，客户英文名称不能为空			
			var sCountryTypeValue = getItemValue(0,getRow(),"CountryCode");//所在国家(地区)
			var sEnglishName = getItemValue(0,getRow(),"EnglishName");//客户英文名称
			if(sCountryTypeValue != 'CHN'){
				if (typeof(sEnglishName) == "undefined" || sEnglishName == "" ){
					alert(getBusinessMessage('119')); //所在国家(地区)不为中华人民共和国时，客户英文名不能为空！
					return false;	
				}
			}
			//3：校验邮政编码
			var sOfficeZip = getItemValue(0,getRow(),"OfficeZIP");//邮政编码
			if(typeof(sOfficeZip) != "undefined" && sOfficeZip != "" ){
				if(!CheckPostalcode(sOfficeZip)){
					alert(getBusinessMessage('120'));//邮政编码有误！
					return false;
				}
			}
			//4：校验联系电话
			var sOfficeTel = getItemValue(0,getRow(),"OfficeTel");//联系电话	
			if(typeof(sOfficeTel) != "undefined" && sOfficeTel != "" ){
				if(!CheckPhoneCode(sOfficeTel)){
					alert(getBusinessMessage('121'));//联系电话有误！
					return false;
				}
			}
			//5：校验传真电话
			var sOfficeFax = getItemValue(0,getRow(),"OfficeFax");//传真电话	
			if(typeof(sOfficeFax) != "undefined" && sOfficeFax != "" ){
				if(!CheckPhoneCode(sOfficeFax)){
					alert(getBusinessMessage('124'));//传真电话有误！
					return false;
				}
			}
			//6：校验财务部联系电话
			var sFinanceDeptTel = getItemValue(0,getRow(),"FinanceDeptTel");//财务部联系电话	
			if(typeof(sFinanceDeptTel) != "undefined" && sFinanceDeptTel != "" ){
				if(!CheckPhoneCode(sFinanceDeptTel)){
					alert(getBusinessMessage('125'));//财务部联系电话有误！
					return false;
				}
			}
			//7：校验电子邮件地址
			var sEmailAdd = getItemValue(0,getRow(),"EmailAdd");//电子邮件地址	
			if(typeof(sEmailAdd) != "undefined" && sEmailAdd != "" ){
				if(!CheckEMail(sEmailAdd)){
					alert(getBusinessMessage('130'));//公司E－Mail有误！
					return false;
				}
			}
			
			//8：校验贷款卡编号
			var sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//贷款卡编号	
			if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" ){
				if(!CheckLoanCardID(sLoanCardNo)){
					alert(getBusinessMessage('101'));//贷款卡编号有误！							
					return false;
				}
				
				//检验贷款卡编号唯一性
				var sCustomerName = getItemValue(0,getRow(),"EnterpriseName");//客户名称	
				sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sCustomerName+","+sLoanCardNo);
				if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many"){
					alert(getBusinessMessage('227'));//该贷款卡编号已被其他客户占用！							
					return false;
				}						
			}
			
			//9:校验当是否征信标准集团客户为是时，则需输入上级公司名称、上级公司组织机构代码或上级公司贷款卡编号
			var sECGroupFlag = getItemValue(0,getRow(),"ECGroupFlag");//是否征信标准集团客户
			if(sECGroupFlag == '1'){ //是否征信标准集团客户（1：是；2：否）
				var sSuperCorpName = getItemValue(0,getRow(),"SuperCorpName");//上级公司名称
				var sSuperLoanCardNo = getItemValue(0,getRow(),"SuperLoanCardNo");//上级公司贷款卡编号
				var sSuperCertID = getItemValue(0,getRow(),"SuperCertID");//上级公司组织机构代码
				if(typeof(sSuperCorpName) == "undefined" || sSuperCorpName == "" ){
					alert(getBusinessMessage('126'));
					return false;
				}
				if((typeof(sSuperLoanCardNo) == "undefined" || sSuperLoanCardNo == "") && 
					(typeof(sSuperCertID) == "undefined" || sSuperCertID == "") ){
					alert(getBusinessMessage('127'));
					return false;
				}
				//如果录入了上级公司组织机构代码，则需要校验上级公司组织机构代码的合法性，同时将上级公司证件类型设置为组织机构代码证
				if(typeof(sSuperCertID) != "undefined" && sSuperCertID != "" ){
					if(!CheckORG(sSuperCertID)){
						alert(getBusinessMessage('128'));//上级公司组织机构代码有误！							
						return false;
					}
					setItemValue(0,getRow(),'SuperCertType',"Ent01");
				}
				//如果录入了上级公司贷款卡编号，则需要校验上级公司贷款卡编号的合法性
				if(typeof(sSuperLoanCardNo) != "undefined" && sSuperLoanCardNo != "" ){
					if(!CheckLoanCardID(sSuperLoanCardNo)){
						alert(getBusinessMessage('129'));//上级公司贷款卡编号有误！							
						return false;
					}
					
					//检验上级公司贷款卡编号唯一性
					var sSuperCorpName = getItemValue(0,getRow(),"SuperCorpName");//上级公司客户名称	
					sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sSuperCorpName+","+sSuperLoanCardNo);
					if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many"){
						alert(getBusinessMessage('228'));//该上级公司贷款卡编号已被其他客户占用！							
						return false;
					}						
				}
			}
		}
		
		if(sCustomerType == '02'){ //集团客户
			//1：校验主管客户经理联系电话
			var sRelativeType = getItemValue(0,getRow(),"RelativeType");//主管客户经理联系电话
			if(typeof(sRelativeType) != "undefined" && sRelativeType != "" ){
				if(!CheckPhoneCode(sRelativeType)){
					alert(getBusinessMessage('223'));//主管客户经理联系电话有误！
					return false;
				}
			}
		}
		if(sCustomerType == '03'){ //个人客户
			//1:校验证件类型为身份证或临时身份证时，出生日期是否同证件编号中的日期一致
			var sCertType = getItemValue(0,getRow(),"CertType");//证件类型
			var sCertID = getItemValue(0,getRow(),"CertID");//证件编号
			var sBirthday = getItemValue(0,getRow(),"Birthday");//出生日期
			if(typeof(sBirthday) != "undefined" && sBirthday != "" ){
				if(sCertType == 'Ind01' || sCertType == 'Ind08'){
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
			
			//2：校验居住地址邮编
			var sFamilyZIP = getItemValue(0,getRow(),"FamilyZIP");//居住地址邮编
			if(typeof(sFamilyZIP) != "undefined" && sFamilyZIP != "" ){
				if(!CheckPostalcode(sFamilyZIP)){
					alert(getBusinessMessage('202'));//居住地址邮编有误！
					return false;
				}
			}
			
			//3：校验住宅电话
			var sFamilyTel = getItemValue(0,getRow(),"FamilyTel");//住宅电话	
			if(typeof(sFamilyTel) != "undefined" && sFamilyTel != "" ){
				if(!CheckPhoneCode(sFamilyTel)){
					alert(getBusinessMessage('203'));//住宅电话有误！
					return false;
				}
			}
			
			//4：校验手机号码
			var sMobileTelephone = getItemValue(0,getRow(),"MobileTelephone");//手机号码
			if(typeof(sMobileTelephone) != "undefined" && sMobileTelephone != "" ){
				if(!CheckPhoneCode(sMobileTelephone)){
					alert(getBusinessMessage('204'));//手机号码有误！
					return false;
				}
			}
			
			//5：校验电子邮箱
			var sEmailAdd = getItemValue(0,getRow(),"EmailAdd");//电子邮箱	
			if(typeof(sEmailAdd) != "undefined" && sEmailAdd != "" ){
				if(!CheckEMail(sEmailAdd)){
					alert(getBusinessMessage('205'));//电子邮箱有误！
					return false;
				}
			}
			
			//6：校验通讯地址邮编
			var sCommZip = getItemValue(0,getRow(),"CommZip");//通讯地址邮编
			if(typeof(sCommZip) != "undefined" && sCommZip != "" ){
				if(!CheckPostalcode(sCommZip)){
					alert(getBusinessMessage('206'));//通讯地址邮编有误！
					return false;
				}
			}
			
			//7：校验单位地址邮编
			var sWorkZip = getItemValue(0,getRow(),"WorkZip");//单位地址邮编
			if(typeof(sWorkZip) != "undefined" && sWorkZip != "" ){
				if(!CheckPostalcode(sWorkZip)){
					alert(getBusinessMessage('207'));//单位地址邮编有误！
					return false;
				}
			}
			
			//8：校验单位电话
			var sWorkTel = getItemValue(0,getRow(),"WorkTel");//单位电话	
			if(typeof(sWorkTel) != "undefined" && sWorkTel != "" ){
				if(!CheckPhoneCode(sWorkTel)){
					alert(getBusinessMessage('208'));//单位电话有误！
					return false;
				}
			}
			
			//8：校验本单位工作起始日
			var sWorkBeginDate = getItemValue(0,getRow(),"WorkBeginDate");//本单位工作起始日
			var sToday = "<%=StringFunction.getToday()%>";//当前日期
			if(typeof(sWorkBeginDate) != "undefined" && sWorkBeginDate != "" ){
				if(sWorkBeginDate >= sToday){
					alert(getBusinessMessage('209'));//本单位工作起始日必须早于当前日期！
					return false;
				}
				
				if(sWorkBeginDate <= sBirthday){
					alert(getBusinessMessage('210'));//本单位工作起始日必须晚于出生日期！
					return false;
				}
			}						
		}
		return true;		
	}

    /*~[Describe=弹出企业类型选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectOrgType(){
		sParaString = "CodeNo"+",OrgType";		
		setObjectValue("SelectCode",sParaString,"@OrgType@0@OrgTypeName@1",0,0,"");
	}
	
	/*~[Describe=弹出国家/地区选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCountryCode(){
		sParaString = "CodeNo"+",CountryCode";			
		sCountryCodeInfo = setObjectValue("SelectCode",sParaString,"@CountryCode@0@CountryCodeName@1",0,0,"");
		if (typeof(sCountryCodeInfo) != "undefined" && sCountryCodeInfo != ""  && sCountryCodeInfo != "_NONE_" 
		&& sCountryCodeInfo != "_CLEAR_" && sCountryCodeInfo != "_CANCEL_"){
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
	function selectCreditTempletType(){
		sParaString = "CodeNo"+",CreditTempletType";			
		setObjectValue("SelectCode",sParaString,"@CreditBelong@0@CreditBelongName@1",0,0,"");
	}
	
	/*~[Describe=弹出对应评分卡模型模板选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectAnalyseType(sModelType){
		sParaString = "ModelType"+","+sModelType;			
		setObjectValue("selectAnalyseType",sParaString,"@CreditBelong@0@CreditBelongName@1",0,0,"");
	}
	/*~[Describe=弹出省份、直辖市、自治区选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getRegionCode(flag){
		//判断国家有没有选中国
		var sCountryTypeValue = getItemValue(0,getRow(),"CountryCode");
		var sRegionInfo;
		if (flag == "ent"){
			if("01" == "01"){ //公司客户要求先选所在国家或地区，再选择具体省市
				//判断国家是否已经选了
				if (typeof(sCountryTypeValue) != "undefined" && sCountryTypeValue != "" ){
					if(sCountryTypeValue == "CHN"){
						sParaString = "CodeNo"+",AreaCode";			
						setObjectValue("SelectCode",sParaString,"@RegionCode@0@RegionCodeName@1",0,0,"");
					}else{
						alert(getBusinessMessage('122'));//所选国家不是中国，无需选择地区
						return;
					}
				}else{
					alert(getBusinessMessage('123'));//尚未选择国家，无法选择地区
					return;
				}
			}else{
				sParaString = "CodeNo"+",AreaCode";			
				setObjectValue("SelectCode",sParaString,"@RegionCode@0@RegionCodeName@1",0,0,"");
			}
		}else{ 	//区分企业客户的行政区域和个人的籍贯
			sParaString = "CodeNo"+",AreaCode";			
			setObjectValue("SelectCode",sParaString,"@NativePlace@0@NativePlaceName@1",0,0,"");
		}
	}	
	
	/*~[Describe=弹出国标行业类型选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getIndustryType(){
		//由于行业分类代码有几百项，分两步显示行业代码
		sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		if(sIndustryTypeInfo == "NO"){
			setItemValue(0,getRow(),"IndustryType","");
			setItemValue(0,getRow(),"IndustryTypeName","");
		}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != ""){
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];//-- 行业类型代码
			sIndustryTypeName = sIndustryTypeInfo[1];//--行业类型名称

			sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?IndustryTypeValue="+sIndustryTypeValue+"&rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
			if(sIndustryTypeInfo == "NO"){
				setItemValue(0,getRow(),"IndustryType","");
				setItemValue(0,getRow(),"IndustryTypeName","");
			}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != ""){
				sIndustryTypeInfo = sIndustryTypeInfo.split('@');
				sIndustryTypeValue = sIndustryTypeInfo[0];//-- 行业类型代码
				sIndustryTypeName = sIndustryTypeInfo[1];//--行业类型名称
				setItemValue(0,getRow(),"IndustryType",sIndustryTypeValue);
				setItemValue(0,getRow(),"IndustryTypeName",sIndustryTypeName);				
			}
		}
	}
	
	/*~[Describe=弹出机构选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getOrg(){
		setObjectValue("SelectAllOrg","","@OrgID@0@OrgName@1",0,0,"");
	}
	
	/*~[Describe=弹出用户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getUser(){
		var sOrg = getItemValue(0,getRow(),"OrgID");
		sParaString = "BelongOrg,"+sOrg;	
		if (sOrg.length != 0 ){
			setObjectValue("SelectUserBelongOrg",sParaString,"@UserID@0@UserName@1",0,0,"");
		}else{
			alert(getBusinessMessage('132'));//请先选择管户机构！
		}
	}
						
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		var sCountryCode = getItemValue(0,getRow(),"CountryCode");
		var sInputUserID = getItemValue(0,getRow(),"InputUserID");
		var sCreditBelong = getItemValue(0,getRow(),"CreditBelong");
		if (sCountryCode=="") //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			setItemValue(0,getRow(),"CountryCode","CHN");
			setItemValue(0,getRow(),"CountryCodeName","中华人民共和国");
		}
		if (sInputUserID==""){
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
		}
		if("<%=sCustomerInfoTemplet%>" == "EnterpriseInfo03" && sCreditBelong == ""){
		    setItemValue(0,getRow(),"CreditBelong","011");			
			setItemValue(0,getRow(),"CreditBelongName","企业化管理的事业单位信用等级评估表");
		}
		
		sCustomerType = "<%=sCustomerType.substring(0,2)%>";
		var sCertType = getItemValue(0,0,"CertType");//--证件类型
		var sCertID = getItemValue(0,0,"CertID");//--证件号码
		if(sCustomerType == '03'){ //个人客户
			//判断身份证合法性,个人身份证号码应该是15或18位！
			if(sCertType =='Ind01' || sCertType =='Ind08'){
				//将身份证中的日期自动赋给出生日期
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
	
    //利用String.replace函数，将字符串左右两边的空格替换成空字符串
    function Trim (sTmp){
     	return sTmp.replace(/^(\s+)/,"").replace(/(\s+)$/,"");
    }
	
	//根据 行业类型、员工人数、销售额、资产总额确定中小企业规模
	function EntScope(){
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
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
	var bCheckBeforeUnload=false;	
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
