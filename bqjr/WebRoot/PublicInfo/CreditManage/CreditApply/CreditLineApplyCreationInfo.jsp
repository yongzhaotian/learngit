<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   byhu  2004.12.7
		Tester:
		Content: 创建授信额度申请
		Input Param:
			ObjectType：对象类型
			ApplyType：申请类型
			PhaseType：阶段类型
			FlowNo：流程号
			PhaseNo：阶段号		
		Output param:
		History Log: zywei 2005/07/28
					 zywei 2005/07/28 将授信额度新增页面单独处理
					 jgao1 2009/10/21 增加集团授信额度，以及选择客户类型变CreditLineApplyCreationInfo.jsp化时清空Data操作
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授信方案新增信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数	：对象类型、申请类型、阶段类型、流程编号、阶段编号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	
		
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
    //销售门店
    //String sNo = CurARC.getAttribute(request.getSession().getId()+"city");
	String sNo = Sqlca.getString(new SqlObject("select attribute8 from user_info  where userid=:UserID").setParameter("UserID", CurUser.getUserID()));
	
    if(sNo == null) sNo = "";
    System.out.println("-------门店-------"+sNo);
    
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "CreditLineApplyCreationInfo";
	
	//根据模板编号设置数据对象	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//定义变量：查询结果集
	ASResultSet rs = null;
	String sCreditId = "";
	String sCreditPerson = "";
	//设置必输背景色
	//doTemp.setHTMLStyle("CustomerType","style={background=\"#EEEEff\"} ");
	//当客户类型发生改变时，系统自动清空已录入的信息
	//doTemp.appendHTMLStyle("CustomerType"," onClick=\"javascript:parent.clearData()\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//销售门店
    if(sNo == null) sNo = "";
	
	//门店地址
	String sCity = Sqlca.getString(new SqlObject("select city from store_info si where si.identtype='01' and si.sno=:sno").setParameter("sno", sNo));
	//获取贷款人信息
    String sSql="select sp.serialno as SerialNo,sp.serviceprovidersname as ServiceProvidersName "+
				" from Service_Providers sp where sp.customertype1='06' and sp.city like '%"+sCity+"%'";
    rs=Sqlca.getASResultSet(sSql);
    if(rs.next()){
   	 sCreditId = DataConvert.toString(rs.getString("SerialNo"));//贷款人编号
   	 sCreditPerson = DataConvert.toString(rs.getString("ServiceProvidersName"));//贷款人名称
   	
		//将空值转化成空字符串
		if(sCreditId == null) sCreditId = "";
		if(sCreditPerson == null) sCreditPerson = "";
    }
    rs.getStatement().close();
    
	
	//设置保存时操作关联数据表的动作
	dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.getUserID()+","+CurOrg.getOrgID()+") + !WorkFlowEngine.InitializeCLInfo(#SerialNo,#BusinessType,#CustomerID,#CustomerName,#InputUserID,#InputOrgID)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		
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
			{"true","","Button","确认","确认新增授信额度申请","doCreation()",sResourcesPath},
			{"true","","Button","取消","取消新增授信额度申请","doCancel()",sResourcesPath}	
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		InsertCustomer();
		initSerialNo();

		as_save("myiframe0",sPostEvents);
	}
	
	//插入新的客户信息到customer_info、ind_info表中
	function InsertCustomer(){
		var sCustomerName = getItemValue(0,0,"CustomerName");//客户名称
		var sCertID = getItemValue(0,0,"CertID");//身份证号
		//var sCustomerID = getItemValue(0,0,"CustomerID");//客户ID
		var sCustomerType = "0310";//客户类型（个人客户）
		var sCertType = "Ind01";//证件类型（身份证）
		var sStatus = "01";
		var sCustomerOrgType = "0310";
		var sHaveCustomerType = sCustomerType;//
		//判断当前客户是否存在
		var sReturn = RunMethod("BusinessManage","CustomerID",sCustomerName.trim()+","+sCertID.trim());
		if(sReturn == "Null"){//如果客户不存在，则新增
			var sParam = "";
			var ssReturn = RunJavaMethodSqlca("com.amarsoft.app.billions.GenerateSerialNo", "getCustomerId","tableName=IND_INFO,colName=CUSTOMERID");
			setItemValue(0,0,"CustomerID",ssReturn);//客户ID
            sParam = ssReturn+","+sCustomerName+","+sCustomerType+","+sCertType+","+sCertID+
                     ","+sStatus+","+sCustomerOrgType+",<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>,"+sHaveCustomerType;

			var sReturnCID = RunMethod("CustomerManage","AddCustomerAction",sParam);
			if (sReturn.length == 8) setItemValue(0,0,"CustomerID",sReturnCID);//客户ID */
        } else {
        	setItemValue(0,0,"CustomerID",sReturn);//客户ID
        }
		
	}
		   
    /*~[Describe=取消新增授信方案;InputParam=无;OutPutParam=取消标志;]~*/
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">

	/*~[Describe=新增一笔授信申请记录;InputParam=无;OutPutParam=无;]~*/
	function doCreation()
	{
		// 保存是校验身份证号码
	    isCardNo();
		var sProductID = getItemValue(0,0,"ProductID");//产品类型
		if(sProductID=="020"){
			/* var sCustomerID = getItemValue(0,0,"CustomerID");//客户ID
			if(typeof(sCustomerID) == "undefined" || sCustomerID == ""){
				alert("客户未在预约现金贷准入客户名单中！");
				return;
			} */
			checkType();
		}else{
			saveRecord("doReturn()");
		}
	}
	
	/*~[Describe=确认新增授信申请;InputParam=无;OutPutParam=申请流水号;]~*/
	function doReturn(){
		sObjectNo = getItemValue(0,0,"SerialNo");
		sObjectType = "<%=sObjectType%>";		
		top.returnValue = sObjectNo+"@"+sObjectType;
		top.close();
	}

	/*~[Describe=设置首付比例;InputParam=无;OutPutParam=无;]~*/
	function inputDpsMnt(){
		var sTotalSum_ = '0'+getItemValue(0,getRow(),"ProductSum");//商品总价格
		var sPaymentSum_ = '0'+getItemValue(0,getRow(),"PaymentSum");//首付款额
		var sShoufuratio = '0'+getItemValue(0,getRow(),"Shoufuratio");//首付比例

		
		var sTotalSum=parseFloat(sTotalSum_);
		var sPaymentSum=parseFloat(sPaymentSum_);
		

		// 校验商品总价格输入是否正确
		if(chkTotalSumValue()!="true") {
			return;
		}

		if(sPaymentSum<0.0) {
			alert("请输入大于等于0的首付款额！");
			return;
		
		}else if(sPaymentSum>sTotalSum){
			alert("首付额不能大商品总价格！");
			return;
		}
		setItemValue(0, 0, "Shoufuratio", (sPaymentSum/sTotalSum*100).toFixed(2));//首付比例
		setItemValue(0, 0, "PaymentSum", sPaymentSum);//首付金额
	}
	/*~[Describe=设置首付金额;InputParam=无;OutPutParam=无;]~*/
	function inputDownPay(){
		var sTotalSum_ = '0'+getItemValue(0,getRow(),"ProductSum");//商品总价格
		var sPaymentSum_ = '0'+getItemValue(0,getRow(),"PaymentSum");//首付款额
		var sShoufuratio = '0'+getItemValue(0,getRow(),"Shoufuratio");//首付比例
		
		var sTotalSum=parseFloat(sTotalSum_);
		var sPaymentSum=parseFloat(sPaymentSum_);
		
		
		// 校验商品总价格输入是否正确
		if(chkTotalSumValue()!="true") {
			return;
		}
		
		if(parseFloat(sShoufuratio)<0.0) {
			alert("请输入大于等于0的首付比例！");
			return;
		}else if(parseFloat(sShoufuratio)>100.0){
			alert("首付比例不能大于100！");
			return;
		}
		
		setItemValue(0, 0, "PaymentSum", (sTotalSum*parseFloat(sShoufuratio)*0.01).toFixed(0));//首付金额
	}
	
	function chkTotalSumValue() {
		var sTotalSum = ''+getItemValue(0,getRow(),"ProductSum");

		if (sTotalSum.length<=0) {
			alert("请输入商品金额！");
			return "false";
		}
		if (parseFloat(sTotalSum)<0.0) {
			alert("商品金额为正数，请确认！"); 
			 return "false";
		}
		return "true";
	}
	
	/*~[Describe=弹出消费金融产品选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectProductID()
	{
		var	sProductID = getItemValue(0,0,"ProductID");
		var	sProductSum = getItemValue(0,0,"ProductSum");//商品金额
		var sPaymentSum = getItemValue(0,0,"PaymentSum");
		var sShoufuratio1 = getItemValue(0,0,"Shoufuratio");
		var sCertID = getItemValue(0,0,"CertID");
		var sProductCategory = getItemValue(0,0,"ProductCategory");
		var sCustomerName = getItemValue(0,0,"CustomerName");

		var sSum = sProductSum-sPaymentSum;
	//   alert("Sum:"+sSum+"ProductSum:"+sProductSum+"PaymentSum:"+sPaymentSum+"Shuofuratio:"+sShoufuratio1);
	     if (typeof(sProductSum)=="undefined" || sProductSum=="_CLEAR_" || sProductSum.length==0 
	     || typeof(sShoufuratio1)=="undefined" || sShoufuratio1=="_CLEAR_" || sShoufuratio1.length==0
	     || typeof(sCertID)=="undefined" || sCertID=="_CLEAR_" || sCertID.length==0
	     || typeof(sProductCategory)=="undefined" || sProductCategory=="_CLEAR_" || sProductCategory.length==0
	     || typeof(sCustomerName)=="undefined" || sCustomerName=="_CLEAR_" || sCustomerName.length==0
	     || typeof(sPaymentSum)=="undefined" || sPaymentSum=="_CLEAR_" || sPaymentSum.length==0) {
	    	 alert("必输项不能为空！");
			   return;
	     }
		sParaString = "ProductID"+","+sProductID+","+"Sum"+","+sSum+","+"ProductSum"+","+sProductSum+","+"ProductCategory"+","+sProductCategory+","+"Shoufuratio"+","+sShoufuratio1+",SNo,<%=sNo%>";
		//设置返回参数 
		setObjectValue("SelectBusinessInfo",sParaString,"@BusinessType@0@ProductName@1@Periods@2",0,0,""); 
	}
	
	//选择产品类型时，显示对应的文本框
	function checkType(){
		isCardNo();
		
		var sProductId = getItemValue(0,0,"ProductId");
		var sCustomerName = getItemValue(0,0,"CustomerName");
		var sIdentityId   = getItemValue(0,0,"CertID");
		
		
		if(sProductId=="020" && sCustomerName =="" && sIdentityId ==""){
		   alert("请填写客户名称及身份证号！");  	
		}

		if(sProductId=="020" && sCustomerName !="" && sIdentityId !=""){//如果是“预约现金贷” 验证客户信息
		   //查询预约现金贷准入客户名单
		   ssReturn = RunMethod("BusinessManage","CustomerNameInfo",sCustomerName+","+sIdentityId);
		   //alert("------------------"+ssReturn);
		   if(ssReturn == "Null"){
			   alert("客户未在预约现金贷准入客户名单中！");
			   return;
		   }
		}
		//获取客户ID
		var sReturn = RunMethod("BusinessManage","CustomerID",sCustomerName+","+sIdentityId);
		//alert("返回值："+sReturn);
			
	    //设置客户ID
	    if(sReturn == "Null"){
	    	//获取客户号
			//var sSerialNo = RunJavaMethodSqlca("com.amarsoft.app.billions.GenerateSerialNo", "getCustomerId","tableName=IND_INFO,colName=CUSTOMERID");//getSerialNo("Customer_Info","CustomerID","");
			//setItemValue(0,getRow(),"CustomerID",sSerialNo);
	    }else{
	    	//把客户号，身份证号设置只读
	    	setItemReadOnly(0,0,"CustomerName",true);
	    	setItemReadOnly(0,0,"CertID",true);
	    	//把查询的客户ID设置到CustomerID中
	        setItemValue(0,0,"CustomerID",sReturn);
	    }

	}

							
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增一条空记录	
			//证件类型(身份证)
			setItemValue(0,0,"CertType","Ind01");
			//消费贷合同标识
			setItemValue(0,0,"CreditAttribute","0002");
			//合同状态:060新发生
			setItemValue(0,0,"ContractStatus","060");
			//地标状态：
			setItemValue(0,0,"LandmarkStatus","1");
			//门店
			setItemValue(0,getRow(),"Stores","<%=sNo%>");
			
			//经办机构
			setItemValue(0,0,"OperateOrgID","<%=CurUser.getOrgID()%>");
			//经办人
			setItemValue(0,0,"OperateUserID","<%=CurUser.getUserID()%>");
			//经办日期
			setItemValue(0,0,"OperateDate","<%=StringFunction.getToday()%>");
			//登记机构
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			//登记人
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			//登记日期			
			setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
			//更新日期
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			//暂存标志
			setItemValue(0,0,"TempSaveFlag","1");//是否标志（1：是；2：否）
			//客户类型默认为个人客户
			setItemValue(0,0,"CustomerType","0310");
			setItemValue(0,0,"CreditID","<%=sCreditId%>");
			setItemValue(0,0,"CreditPerson","<%=sCreditPerson%>");
		}
		
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo()  
	{
		var sTableName = "BUSINESS_CONTRACT";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
		//初始化版本
		setItemValue(0,getRow(),"ProductVersion","V1.0");						
		//获取流水号
		// 获取客户编号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);	// RunJavaMethodSqlca("com.amarsoft.app.billions.GenerateSerialNo", "getContractId","serialNo="+sCustomerID);//getSerialNo("Customer_Info","CustomerID","");;//
		//将流水号置入对应字段
		
		// 合同号
		var sCustomerID = getItemValue(0,0,"CustomerID");//客户ID
		var sContractId = RunJavaMethodSqlca("com.amarsoft.app.billions.GenerateSerialNo", "getContractId","serialNo="+sCustomerID);
		setItemValue(0,getRow(),sColumnName,sContractId);
		setItemValue(0, 0, "ApplySerialNo", sSerialNo);
	}
	
	
	</script>
	
	<script type="text/javascript">
//身份证正则表达校验
function isCardNo()  
{
	var card = getItemValue(0,getRow(),"CertID");
	//alert("==================="+card);
	checkIdcard(card);
}

//身份证
function checkIdcard(idcard){ 
		var Errors=new Array( 
							"验证通过!", 
							"身份证号码位数不对!", 
							"身份证号码出生日期超出范围或含有非法字符!", 
							"身份证号码校验错误!", 
							"身份证地区非法!" 
							); 
		var area={11:"北京",12:"天津",13:"河北",14:"山西",15:"内蒙古",21:"辽宁",22:"吉林",23:"黑龙江",31:"上海",32:"江苏",33:"浙江",34:"安徽",35:"福建",36:"江西",37:"山东",41:"河南",42:"湖北",43:"湖南",44:"广东",45:"广西",46:"海南",50:"重庆",51:"四川",52:"贵州",53:"云南",54:"西藏",61:"陕西",62:"甘肃",63:"青海",64:"宁夏",65:"新疆",71:"台湾",81:"香港",82:"澳门",91:"国外"} 
							 
		var idcard,Y,JYM; 
		var S,M; 
		var idcard_array = new Array(); 
		idcard_array     = idcard.split(""); 
		//alert(area[parseInt(idcard.substr(0,2))]);
		
		//地区检验 
		if(area[parseInt(idcard.substr(0,2))]==null){
			alert(Errors[4]); 
			setItemValue(0,0,"CertID","");
			return Errors[4];
		}
		 
		//身份号码位数及格式检验 
		
		switch(idcard.length){
		case 15: 
			if((parseInt(idcard.substr(6,2))+1900) % 4 == 0 || ((parseInt(idcard.substr(6,2))+1900) % 100 == 0 && (parseInt(idcard.substr(6,2))+1900) % 4 == 0 )){ 
				ereg=/^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$/;//测试出生日期的合法性 
			}else{ 
				ereg=/^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$/;//测试出生日期的合法性 
			} 
		 
			if(ereg.test(idcard)){
				alert(Errors[0]);
				setItemValue(0,0,"CertID","");
				return Errors[0]; 
		        
			}else{ 
				alert(Errors[2]);
				setItemValue(0,0,"CertID","");
				return Errors[2];  
			}
			break; 
		case 18: 
			//18位身份号码检测 
			//出生日期的合法性检查  
			//闰年月日:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9])) 
			//平年月日:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8])) 
			if ( parseInt(idcard.substr(6,4)) % 4 == 0 || (parseInt(idcard.substr(6,4)) % 100 == 0 && parseInt(idcard.substr(6,4))%4 == 0 )){ 
				ereg=/^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$/;//闰年出生日期的合法性正则表达式 
			}else{
				ereg=/^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$/;//平年出生日期的合法性正则表达式 
			} 
			if(ereg.test(idcard)){//测试出生日期的合法性 
				//计算校验位 
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
				M    = JYM.substr(Y,1);//判断校验位 
				if(M == idcard_array[17]){
					return  Errors[0];		//检测ID的校验位 
				}else{
					alert(Errors[3]);
					setItemValue(0,0,"CertID","");
					return  Errors[3]; 
		        }
			}else{
				alert(Errors[2]);
				setItemValue(0,0,"CertID","");
				return Errors[2]; 
		    }
			break;
		default:
		    alert(Errors[1]);
		    setItemValue(0,0,"CertID","");
			return  Errors[1]; 

			break;
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
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>