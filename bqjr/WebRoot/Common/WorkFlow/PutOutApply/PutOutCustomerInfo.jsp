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
	 */
	%>
<%/*~END~*/%> 


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户概况"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
    
	if(sCustomerID == null) sCustomerID = "";
	if(sTypes == null) sTypes = "";
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
	rs.getStatement().close();
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
	rs.getStatement().close();
	
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
	
	if(rs.next()){ 
		sItemAttribute = DataConvert.toString(rs.getString("ItemAttribute"));		//大型企业客户详情树图类型		
	    sAttribute3 = DataConvert.toString(rs.getString("Attribute3"));		        //中小企业客户详情树图类型
	}
	rs.getStatement().close(); 
	
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
	
	if(sCustomerType.substring(0,2).equals("03")){ //个人客户
		sSql = "select TempSaveFlag from IND_INFO where CustomerID = :CustomerID ";
	}else{ //公司客户或集团客户
		sSql = "select TempSaveFlag from ENT_INFO where CustomerID = :CustomerID ";
	}
	sTempSaveFlag = Sqlca.getString(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(sTempSaveFlag == null) sTempSaveFlag = "";	
	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = sCustomerInfoTemplet;	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if(sCertType.equals("Ind01") || sCertType.equals("Ind08")){
		//doTemp.setReadOnly("Sex,Birthday",true);
	}	
	//add by jgao1 如果证件类型是营业执照，则隐藏证件号码字段 2009-11-2
	if(sCertType.equals("Ent02")){
		doTemp.setVisible("CorpID",false);
		doTemp.setReadOnly("LicenseNo",true);
	}
	
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//设置插入和更新事件，反方向插入和更新(更新客户的贷款卡编号) 
	if(sCustomerType.substring(0,2).equals("01")){ //公司客户
    	if(sCertType.equals("Ent01")){
    		dwTemp.setEvent("AfterInsert","!CustomerManage.AddCustomerInfo(#CustomerID,#EnterpriseName,"+sCertType+",#CorpID,#LoanCardNo,"+CurUser.getUserID()+")");
			dwTemp.setEvent("AfterUpdate","!CustomerManage.AddCustomerInfo(#CustomerID,#EnterpriseName,"+sCertType+",#CorpID,#LoanCardNo,"+CurUser.getUserID()+")");
  		}else{
  			dwTemp.setEvent("AfterInsert","!CustomerManage.AddCustomerInfo(#CustomerID,#EnterpriseName,"+sCertType+","+SpecialTools.real2Amarsoft(sCertID)+",#LoanCardNo,"+CurUser.getUserID()+")");
			dwTemp.setEvent("AfterUpdate","!CustomerManage.AddCustomerInfo(#CustomerID,#EnterpriseName,"+sCertType+","+SpecialTools.real2Amarsoft(sCertID)+",#LoanCardNo,"+CurUser.getUserID()+")");
  		}
  	}
	
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
		{"false","All","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{sTempSaveFlag.equals("2")?"false":"false","All","Button","暂存","暂时保存所有修改内容","saveRecordTemp()",sResourcesPath}
	};
	//只要客户经理没有主办权,就不能修改本页面。
	String sRight = Sqlca.getString(new SqlObject(" select BelongAttribute2 from CUSTOMER_BELONG where CustomerID = :CustomerID and UserID = :UserID ").setParameter("CustomerID",sCustomerID).setParameter("UserID",CurUser.getUserID()));
	if(sRight != null && !sRight.equals("1")){
	 	sButtons[0][0] = "false";
	 	sButtons[1][0] = "false";
	}
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
		var sCustomerType = "<%=sCustomerType.substring(0,2)%>";
		//录入数据有效性检查
		//if (!ValidityCheck()) return;
		beforeUpdate();
		setItemValue(0,0,"TempSaveFlag","2");//暂存标志（1：是；2：否）
		as_save("myiframe0",sPostEvents);
		
	}
		
	function saveRecordTemp(){
		var sCustomerType = "<%=sCustomerType%>";
		//0：表示第一个dw
		setNoCheckRequired(0);  //先设置所有必输项都不检查
		setItemValue(0,0,"TempSaveFlag","1");//暂存标志（1：是；2：否）
		as_save("myiframe0");   //再暂存
		setNeedCheckRequired(0);//最后再将必输项设置回来	
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
		var sCustomerType = "<%=sCustomerType.substring(0,2)%>";
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
		
		if(sCustomerType == '03'){ //个人客户
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
			sMobileTelephone = getItemValue(0,getRow(),"MobileTelephone");//手机号码
			if(typeof(sMobileTelephone) == "undefined" || sMobileTelephone == "" ){
				
				setItemValue(0,0,"MobileTelephone","00000000000");//当手机号码为空时，点击保存，系统自动的输入"00000000000"
			}
		}
		return true;		
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
		
		sWorkTel=sZipCode+"-"+sPhoneCode+"-"+sExtensionNo;
		setItemValue(0,0,"WorkTel",sWorkTel);//工作电话

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
		var sFlag2 = getItemValue(0,getRow(),"Flag2");
		
		//获取户籍地址
		var sNativePlace = getItemValue(0,0,"NativePlace");
		var sNativePlaceName = getItemValue(0,0,"NativePlaceName");
		var sVillagetown = getItemValue(0,0,"Villagetown");
		var sStreet = getItemValue(0,0,"Street");
		var sCommunity = getItemValue(0,0,"Community");
		var sRoom = getItemValue(0,0,"CellNo");
		//alert("----------------------"+sRoom);
		//alert("----------------------"+sFlag2);
		
		
		if(sFlag2=="1"){//如果是
			setItemValue(0,0,"FamilyAdd",sNativePlace);//现居住地址
			setItemValue(0,0,"FamilyAddName",sNativePlaceName);
			setItemValue(0,0,"Countryside",sVillagetown);//乡/镇(现居)
			setItemValue(0,0,"Villagecenter",sStreet);//街道/村（现居）
			setItemValue(0,0,"Plot",sCommunity);//小区/楼盘（现居）
			setItemValue(0,0,"Room",sRoom);//栋/单元/房间号（现居）
		}else{
			setItemValue(0,0,"FamilyAdd","");//现居住地址
			setItemValue(0,0,"FamilyAddName","");
			setItemValue(0,0,"Countryside","");//乡/镇(现居)
			setItemValue(0,0,"Villagecenter","");//街道/村（现居）
			setItemValue(0,0,"Plot","");//小区/楼盘（现居）
			setItemValue(0,0,"Room","");//栋/单元/房间号（现居）
		}

	}
	
	function selectYesNo2(){
		var sFlag8 = getItemValue(0,getRow(),"Flag8");
		
		//alert("--------------"+sFlag8)
		
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
        
		if(sFlag8=="010"){//同现居住地址

			setItemValue(0,0,"CommAdd",sFamilyAdd);
			setItemValue(0,0,"CommAddName",sFamilyAddName);
			setItemValue(0,0,"EmailCountryside",sCountryside);
			setItemValue(0,0,"EmailStreet",sVillagecenter);
			setItemValue(0,0,"EmailPlot",sPlot);
			setItemValue(0,0,"EmailRoom",sRoom);
		}else if(sFlag8=="020"){//同单位/学校地址

			setItemValue(0,0,"CommAdd",sWorkAdd);
			setItemValue(0,0,"CommAddName",sWorkAddName);
			setItemValue(0,0,"EmailCountryside",sUnitCountryside);
			setItemValue(0,0,"EmailStreet",sUnitStreet);
			setItemValue(0,0,"EmailPlot",sUnitRoom);
			setItemValue(0,0,"EmailRoom",sUnitNo);
		}else if(sFlag8=="030"){//同户籍地址

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
	

						
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
	  if (getRowCount(0)==0){ //如果没有找到对应记录，则新增一条，并设置字段默认值
			as_add("myiframe0");//新增记录
			bIsInsert = true;

		setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
		
		setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
		setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");  
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		
		var sCountryCode = getItemValue(0,getRow(),"CountryCode");
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
			setItemValue(0,getRow(),"CountryCode","CHN");
			setItemValue(0,getRow(),"CountryCodeName","中华人民共和国");
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
		if(sCustomerType == '03') //个人客户
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
    }
	
	/*~[Describe=初始化客户号字段;InputParam=无;OutPutParam=无;]~*/
	function initCustomerID(){
		var sTableName = "IND_INFO";//表名
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
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
