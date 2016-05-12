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
					 xswang 2015/06/01 CCS-713 合同中的门店跳转为其他门店
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
	String subProductType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SubProductType"));//学生或者成人贷类型
	String initSERIALNO = "";
	String initCertID =  "";
	String initCustomerID = "";
	String initCustomerName = "";
	String initMobileTelephone = "";
	String initWorkCorp = "";
	String initSelfMonthIncome = "";
	String initRelativeType = "";
	String initKinshipName = "";
	String initKinshipTel = "";
	String initContactrelation = "";
	String initOtherContact = "";
	String initContactTel = "";
	String initInteriorCode = "";
	/*****************update huzp 二段式提单需求修改 begin*******************/
	String switch_status = Sqlca.getString(new SqlObject("select t.switch_status from SYSTEM_SWITCH t where t.switch_type ='PRETRIAL_ENABLE'"));
	if("1".equals(switch_status)){
		 initSERIALNO = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SERIALNO"));
		 initCertID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CertID"));
		 initCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
		 initCustomerName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerName"));
		 initMobileTelephone = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MobileTelephone"));
		 initWorkCorp = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("WorkCorp"));
		 initSelfMonthIncome = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SelfMonthIncome"));
		 initRelativeType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeType"));
		 initKinshipName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("KinshipName"));
		 initKinshipTel = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("KinshipTel"));
		 initContactrelation = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Contactrelation"));
		 initOtherContact = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OtherContact"));
		 initContactTel = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ContactTel"));
		 initInteriorCode = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InteriorCode"));
	}
	/*****************end*********************************************/
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	if(subProductType == null) subProductType = "";
	
	/*****************update huzp 二段式提单需求修改 begin*******************/
	if("1".equals(switch_status)){
		if(initSERIALNO == null) initSERIALNO = "";	
		if(initCertID == null) initCertID = "";
		if(initCustomerID == null) initCustomerID = "";	
		if(initCustomerName == null) initCustomerName = "";
		if(initMobileTelephone == null) initMobileTelephone = "";
		if(initWorkCorp == null) initWorkCorp = "";	
		if(initSelfMonthIncome == null) initSelfMonthIncome = "";
		if(initRelativeType == null) initRelativeType = "";	
		if(initKinshipName == null) initKinshipName = "";
		if(initKinshipTel == null) initKinshipTel = "";
		if(initContactrelation == null) initContactrelation = "";	
		if(initOtherContact == null) initOtherContact = "";
		if(initContactTel == null) initContactTel = "";	
		if(initInteriorCode == null) initInteriorCode = "";	
	}
	/*****************end*********************************************/

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
    //销售门店
    //String sNo = CurARC.getAttribute(request.getSession().getId()+"city");
	// add by xswang 2015/06/01 CCS-713 合同中的门店跳转为其他门店
	//String sNo = Sqlca.getString(new SqlObject("select attribute8 from user_info  where userid=:UserID").setParameter("UserID", CurUser.getUserID()));
	String sNo = CurUser.getAttribute8();
	// end by xswang 2015/06/01
	
    if(sNo == null) sNo = "";
    System.out.println("-------门店-------"+sNo);
    String sStorePosid = Sqlca.getString(new SqlObject("select storeposid from user_info  where userid=:UserID").setParameter("UserID", CurUser.getUserID()));
    if(sStorePosid == null) sStorePosid = "";
    System.out.println("-------移动Pos点-------"+sStorePosid);
    
    	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "NoOrderdCashNewApplyInfo";
	
	//根据模板编号设置数据对象	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//定义变量：查询结果集
	ASResultSet rs = null;
	String sCreditId = "";
	String sCreditPerson = "";
	//设置必输背景色
	//doTemp.setHTMLStyle("CustomerType","style={background=\"#EEEEff\"} ");
	//当客户类型发生改变时，系统自动清空已录入的信息
	doTemp.setReadOnly("ProductName",true);
	//doTemp.appendHTMLStyle("CertID"," onChange=\"javascript:parent.getCustomerName()\" ");//update CCS-445 现金贷申请界面改为姓名身份证号均必填
	
	/*****************update huzp 二段式提单需求修改 begin*******************/
	if("0".equals(switch_status)){
		doTemp.setReadOnly("CustomerName",false);
		doTemp.setReadOnly("CertID",false);
	}
	/*****************************************************************/
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//销售门店
    if(sNo == null) sNo = "";
	
	//门店地址
	String sCity = Sqlca.getString(new SqlObject("select city from store_info si where si.identtype='01' and si.sno=:sno").setParameter("sno", sNo));
	//获取保险公司
    String InsuranceNo=Sqlca.getString(new SqlObject("select sp.ins_serialno from bq_insurance_info sp,insurancecity_info ii "+
    			"where sp.ins_serialno = ii.insuranceno and sp.ins_status = '1' and ii.cityno='"+sCity+"' and ii.subproducttype='2'"));
	if(InsuranceNo==null) InsuranceNo="";
	//获取贷款人信息  
    String sSql="select sp.serialno as SerialNo, sp.serviceprovidersname as ServiceProvidersName "+
 				"from Service_Providers sp,ProvidersCity pc where sp.customertype1 = '06' and pc.ProductType = '2' "+
 				"and pc.serialno=sp.serialno and sp.loaner = '010' and pc.areacode='"+sCity+"'";
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
			{"true","","Button","重置","重置新增授信额度申请","doReset()",sResourcesPath},
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

		var sCustomerName = getItemValue(0,0,"CustomerName");//客户名称
		var sCertID = getItemValue(0,0,"CertID");//身份证号
		var sReturn = RunMethod("BusinessManage","CustomerID",sCustomerName.trim()+","+sCertID.trim());
		if(sReturn == "Null"){//如果客户不存在，则新增
				alert("网络原因，合同保存失败，请重新录入！");
				reloadSelf();
				return;
		}
			//update CCS-445 现金贷申请界面改为姓名身份证号均必填
		var sProductName = getItemValue(0,0,"ProductName");//产品名称
		if("undefined" == typeof(sProductName) || sProductName.length==0 || null == sProductName)
		{
			alert("请选择产品！");
			return;
		}
		as_save("myiframe0",sPostEvents);
		/***************begin update huzp CCS-1334,二段式提单*******************************/
		if("1"=="<%=switch_status%>"){
			RunMethod("公用方法", "UpdateColValue", "Pretrial_Info,STATE,004,SERIALNO='"+"<%=initSERIALNO%>"+"'");
		}
		/***************end*******************************/


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
				/*****************update huzp 二段式提单需求修改 begin*******************/
					if("1"=="<%=switch_status%>"){
						var ssReturn="<%=initCustomerID%>";//从预审界面传来的客户编号，因为同是新增避免再次取号
						/*****************end*******************/
						setItemValue(0,0,"CustomerID",ssReturn);//客户ID
						sParam = ssReturn+","+sCustomerName+","+sCustomerType+","+sCertType+","+sCertID+
				                 ","+sStatus+","+sCustomerOrgType+",<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>,"+sHaveCustomerType+",<%=initMobileTelephone%>,<%=initWorkCorp%>,<%=initSelfMonthIncome%>,<%=initRelativeType%>,<%=initKinshipName%>,<%=initKinshipTel%>,<%=initContactrelation%>,<%=initOtherContact%>,<%=initContactTel%>";
				     
				        var sReturnCID = RunMethod("CustomerManage","AddCustomerAction",sParam);
						if (sReturn.length == 8) setItemValue(0,0,"CustomerID",sReturnCID);//客户ID */
			    	} else {
			    		var ssReturn = RunJavaMethodSqlca("com.amarsoft.app.billions.GenerateSerialNo", "getCustomerId",null);
						setItemValue(0,0,"CustomerID",ssReturn);//客户ID
						 sParam = ssReturn+","+sCustomerName+","+sCustomerType+","+sCertType+","+sCertID+
				                 ","+sStatus+","+sCustomerOrgType+",<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>,"+sHaveCustomerType;
				        var sReturnCID = RunMethod("CustomerManage","AddCustomerAction",sParam);
						if (sReturn.length == 8) setItemValue(0,0,"CustomerID",sReturnCID);//客户ID */
			    	}	
			}else{
				if("1"=="<%=switch_status%>"){
					/*****************update huzp 二段式提单需求修改 begin*******************/
					var sParam = "CustomerID=" +sReturn+",WorkCorp="+'<%=initWorkCorp%>'+",MobileTelephone="+'<%=initMobileTelephone%>'+",SelfMonthIncome="+'<%=initSelfMonthIncome%>'+",KinshipName="+'<%=initKinshipName%>'+",KinshipTel="+'<%=initKinshipTel%>'+",RelativeType="+'<%=initRelativeType%>'+",Contactrelation="+'<%=initContactrelation%>'+",OtherContact="+'<%=initOtherContact%>'+",ContactTel="+'<%=initContactTel%>' ;
					RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateIndInfoAction", "updateIndInfo", sParam);
		        	/*****************end*******************/
					setItemValue(0,0,"CustomerID",sReturn);//客户ID
				}else{
					setItemValue(0,0,"CustomerID",sReturn);//客户ID
					RunMethod("公用方法", "UpdateColValue", "IND_INFO,TEMPSAVEFLAG,1,CUSTOMERID='"+sReturn+"'");     
				}	
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
		var sStore = RunMethod("公用方法", "GetColValue", "Store_info,SNO||' '||sName,sno='<%=sNo%>'");
		if(!confirm("当前登录所在门店为：\n\r"+sStore+"\n\r是否确认在该门店发起申请？")){
			return;
		}
		// 保存是校验身份证号码
	    isCardNo();
	     //校验身份证是否是在18-55之间
	    var sIdentifiedID = getItemValue(0,getRow(),"CertID");
		if(typeof(sIdentifiedID)=="undefined" || sIdentifiedID.length==0){
			setItemValue(0,0,"CertID","");
			return;
		}else{
			 checkIDAge();
		}
		var sProductID = getItemValue(0,0,"ProductID");//产品类型
		//add by phe 2015/03/31 CCS-572 PRM-254 安硕系统中限制销售代表为自己申请员工贷
	     if(!checkUserNotCustomer()){
	    	 return;
	     }
		
	    var BusinessType = getItemValue(0,0,"BusinessType");//产品ID
		// 判断投保是否必须选择
	    var creditCycle = getItemValue(0, 0, "CreditCycle");
	    if (creditCycle != "1") {		// 没选择投保的时候，才判断投保项是否必须选择
	    	var res = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.CheckCreditCycle", "checkNecessity", "businessType=" + BusinessType);
	    	if (res == "1") {
	    		alert("该产品必须选择投保！");
	    		return;
	    	}
	    } 
		
		saveRecord("doReturn()");
		
		//往同盾反诈骗平台插入一条数据 add by lgq 20151029
		var sCertID = getItemValue(0,0,"CertID");//身份证号
		var sSerialNo = getItemValue(0,0,"SerialNo"); //合同编号
		//RunMethod("PublicMethod","CallScoreTaskPort",sCertID+","+sSerialNo);
		//RunJavaMethod("com.amarsoft.app.billions.CallScoreTaskPort","ThreadCallPort",
				//"CertID="+sCertID+","+"SerialNo="+sSerialNo);
		
		$.ajax({
			type:"post",
			url: sWebRootPath+"/servlet/scoreTask",
			data: {"SerialNo" : sSerialNo,"CertID" : sCertID},
			timeout: 4000,
			async: true,
			success: function(msg){
			     //alert( "Data Saved: " + msg );
			},
			error:function(msg){
				//alert("超时！");
			}

		})
	}
	
	// 校验身份证是否是在18-55之间
	function checkIDAge(){
		var sIdentifiedID = getItemValue(0,getRow(),"CertID");
		if(typeof(sIdentifiedID)=="undefined" || sIdentifiedID.length==0){
			alert("身份证号码不能为空！");
			return false;
		}else{
			var myDate = new Date();
			var thisYear = myDate.getFullYear();
			var thisMonth = myDate.getMonth()+1;
			var thisDay = myDate.getDate();
			var age = myDate.getFullYear() - sIdentifiedID.substring(6,10)-1;
			if(sIdentifiedID.substring(10,12)<thisMonth || sIdentifiedID.substring(10,12) == thisMonth && sIdentifiedID.substring(12,14)<= thisDay){
				age++;
			}
			if((age>55) || (age<18)){
				alert("客户年龄必须在18到55之间");
				return false;
			}
		}
		return true;
	}
	//end
	
	/*~[Describe=;InputParam=无;OutPutParam=无;]~*/
	function ProductSum(){
		setItemValue(0, 0, "ProductName", "");
		setItemValue(0, 0, "Periods", "");
		setItemValue(0, 0, "MonthRepayment", "");
		setItemValue(0, 0, "EventName", "");
		setItemValue(0, 0, "BusinessType", "");
		setItemValue(0, 0, "EventID", "");
	}
	/*~[Describe=确认新增授信申请;InputParam=无;OutPutParam=申请流水号;]~*/
	function doReturn(){
		sObjectNo = getItemValue(0,0,"SerialNo");
		sObjectType = "<%=sObjectType%>";		
		top.returnValue = sObjectNo+"@"+sObjectType;
		top.close();
	}

	
	function chkTotalSumValue() {
		var sTotalSum = ''+getItemValue(0,getRow(),"BusinessSum");

		if (sTotalSum.length<=0) {
			alert("请输入贷款金额！");
			return "false";
		}
		if (parseFloat(sTotalSum)<0.0) {
			alert("贷款金额为正数，请确认！"); 
			 return "false";
		}
		return "true";
	}
	
	/*~[Describe=弹出消费金融产品选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	
	
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
			//门店名称 add by clhuang 2015/06/25 CCS-658 PRM-309 销售代表办单时提醒门店功能以及可选择门店搜索功能
			var sName = RunMethod("公用方法", "GetColValue", "Store_info,sname,sno='<%=sNo%>'");  
			setItemValue(0,getRow(),"StoresName",sName);
			// 业务来源
			setItemValue(0,getRow(),"SureType","PC");
			// 保险公司编号
			setItemValue(0,getRow(),"InsuranceNo","<%=InsuranceNo%>");
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
			setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
			//更新日期
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			//暂存标志
			setItemValue(0,0,"TempSaveFlag","1");//是否标志（1：是；2：否）
			//客户类型默认为个人客户
			setItemValue(0,0,"CustomerType","0310");
			setItemValue(0,0,"CreditID","<%=sCreditId%>");
			setItemValue(0,0,"CreditPerson","<%=sCreditPerson%>");
			setItemValue(0,0,"ProductID","020");
			//产品子类型
			setItemValue(0,0,"SubProductType","2");
	    	/*****************update huzp 二段式提单需求修改 begin*******************/
			if("1"=="<%=switch_status%>"){

            		setItemValue(0,getRow(),"CertID","<%=initCertID%>");//身份证号
			setItemValue(0,getRow(),"CustomerName","<%=initCustomerName%>");//客户姓名
			}
			/*****************end*********************************************/

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
        	/*****************update huzp 二段式提单需求修改 begin*******************/
		if("1"=="<%=switch_status%>"){
        	setItemValue(0, 0, "PretrialSerialNo", "<%=initSERIALNO%>");
		setItemValue(0, 0, "InteriorCode", "<%=initInteriorCode%>");
		}
		/*****************end*********************************************/

	}
	
	
	</script>
	
	<script type="text/javascript">
//身份证正则表达校验
function isCardNo()  
{
	var card = getItemValue(0,getRow(),"CertID");
	//alert("==================="+card);
	if(typeof(card)=="undefined" || card.length==0){
		alert("身份证号码不能为空！");
		setItemValue(0,0,"CertID","");
		return;
	}
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
				ereg=/^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$/;//闰年出生日期的合法性正则表达式 
			}else{
				ereg=/^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$/;//平年出生日期的合法性正则表达式 
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

	//根据身份证号码获取客户名称及客户编号
	function getCustomerName()
	{
		var sCertID = getItemValue(0,getRow(),"CertID");
		var sCustomerName = RunMethod("公用方法", "GetColValue", "CUSTOMER_INFO,CUSTOMERNAME,CERTID='"+sCertID+"'");
		var sCustomerID = RunMethod("公用方法", "GetColValue", "CUSTOMER_INFO,CUSTOMERID,CERTID='"+sCertID+"'");
		if("Null" == sCustomerName || null == sCustomerName || "" == sCustomerName || "undefined" == sCustomerName || "Null" == sCustomerID || null == sCustomerID || "" == sCustomerID || "undefined" == sCustomerID)
		{
			alert("客户信息不存在，请检查!");
			setItemValue(0,0,"CustomerName","");
			setItemValue(0,0,"CustomerID","");
		}else
		{
			setItemValue(0,0,"CustomerName",sCustomerName);
			setItemValue(0,0,"CustomerID",sCustomerID);
		}
	}
	
	/*~[Describe=安硕系统中限制销售代表为自己申请员工贷;InputParam=无;OutPutParam=无;]~*/
	function checkUserNotCustomer(){
		  //add by phe 2015/03/31 CCS-572 PRM-254 安硕系统中限制销售代表为自己申请员工贷
		 var sCustomerName = getItemValue(0,0,"CustomerName");
		 var sCertID = getItemValue(0,0,"CertID");
		  
	     var sCount = RunMethod("BusinessManage", "selectUserCerttype", '<%=CurUser.getUserID() %>');
			if(sCount=="0.0"){
				alert("请通知OA在用户表更新身份证号，然后才能做单!");
				return false;
			}
			var sUserNameAndCertID = RunMethod("BusinessManage", "selectUserNameAndCertID", '<%=CurUser.getUserID() %>');
			var sUserNameAndCertIDs=sUserNameAndCertID.split("@");
			if(sUserNameAndCertIDs[0]==sCustomerName&&sUserNameAndCertIDs[1]==sCertID){
				alert("无法为自己提交申请！");
				return false;
			}
			return true;
			//end by phe 2015/03/31
	}
	
	
	/*~[Describe=弹出消费金融产品选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectProductID()
	{
		var	sProductID = getItemValue(0,0,"ProductID");
		var	sSum = getItemValue(0,0,"BusinessSum");
		//var sCustomerID = getItemValue(0,0,"CustomerID");
		var sBusinessSum = getItemValue(0,0,"BusinessSum");
		//add CCS-445 现金贷申请界面改为姓名身份证号均必填
		var sCertID = getItemValue(0,getRow(),"CertID");
		var sCustomerName = getItemValue(0,getRow(),"CustomerName");
		//var sCustomerID = RunMethod("公用方法", "GetColValue", "CUSTOMER_INFO,CUSTOMERID,CERTID='"+sCertID+"' and CUSTOMERNAME = '"+sCustomerName+"'");
		//setItemValue(0,0,"CustomerID",sCustomerID);
		//end

	//   alert("Sum:"+sSum+"ProductSum:"+sProductSum+"PaymentSum:"+sPaymentSum+"Shuofuratio:"+sShoufuratio1);
		/*  if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0 || "Null" == sCustomerID || null == sCustomerID || "" == sCustomerID)
	     {
		     alert("客户信息不存在，请检查！");
		     return;
		 } */
	     if (typeof(sSum)=="undefined" || sSum=="_CLEAR_" || sSum.length==0) {
	    	 alert("请输入贷款金额！");
			   return;
	     }
	     //add by phe 2015/03/31 CCS-572 PRM-254 安硕系统中限制销售代表为自己申请员工贷
	     if(!checkUserNotCustomer()){
	    	 return;
	     }

	     sParaString = "Sum"+","+sSum+","+"pID"+","+sProductID+","+"SNo,<%=sNo%>";
		//设置返回参数 
		//serialno@eventname@productid@productname@TypeNo@TypeName@Term
		setObjectValue("NoOrderCashLoanInfo",sParaString,"@ProductName@1@Periods@0@BusinessType@2",0,0,"");
		var sCreditCycle = getItemValue(0,0,"CreditCycle");//是否投保
		var sBugPayPkgind = getItemValue(0,0,"BugPayPkgind");//是否购买随心还服务包
		//调用一次每月还款额计算
		if(!(typeof(sCreditCycle)=="undefined" || sCreditCycle.length==0 || typeof(sBugPayPkgind)=="undefined" || sBugPayPkgind.length==0)){
			getMonthPayment();
		}
	}
	
	//是否投保，联动计算每月还款额  add by phe
	function getMonthPayment(){
		var sBusinessType = getItemValue(0,0,"BusinessType");//获取产品代码
		var sBusinessSum = getItemValue(0,0,"BusinessSum");//贷款金额
		var sPeriods = getItemValue(0,0,"Periods");//分期期数
		var sCreditCycle = getItemValue(0,0,"CreditCycle");//是否投保
		var sBugPayPkgind = getItemValue(0,0,"BugPayPkgind");//是否购买随心还服务包
		var sInsuranceNo = "<%=InsuranceNo%>";//保险公司
		
		//var sCount = RunMethod("公用方法", "GetColValue", "product_term_library,count(1),subtermtype = 'A12' and status='1' and  ObjectNo ='"+sBusinessType+"-V1.0'");
		
		if(typeof(sBusinessSum)=="undefined" || sBusinessSum.length==0){
			alert("商品金额不能为空！");
			return;
		}
		if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0){
			alert("请先选择产品！");
			return;
		}
		
		//判断该产品是否配置随心还服务包费用
		if(sBugPayPkgind=="1"){
			var sRe = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.CheckBugPayPkgind", "checkSuiXinHuan", "businessType="+sBusinessType);
			if(sRe == 0){
				alert("该产品未配置收取随心还服务包费用！");
				setItemValue(0,0,"BugPayPkgind","0");
			}
		}
		
		//检查是否可以投保
		var sReturn = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.CheckCreditCycle", "CreditCycle", "businessType="+sBusinessType+",insuranceNo="+sInsuranceNo);
		if(sCreditCycle=="1"&&sReturn!="true"){//不允许投保
				
			if(sReturn=="false@BusinessType"){
				alert("产品代码为空!");
			}else if(sReturn=="false@product"){
				alert("产品未关联保险费，不能投保!");
			}else if(sReturn=="false@InsuranceNo"){
				alert("该城市没有保险公司，不能投保!");
			}else if(sReturn=="false@InsuranceFee"){
				alert("保险公司未关联保险费，不能投保!");
			}else if(sReturn=="false@InsuranceFeeAll"){
				alert("保险公司只能关联一个有效保险费!");
			}
			/*同一个产品全国都是同一费率,所以保险公司不需要配置保险费
			else if(sReturn=="false@ProductInsurance"){
				alert("产品未关联与当前保险公司相应的保险费，不能投保!");
			}*/
			else{
				alert("产品或者保险公司关联保险费异常，不能投保，请检查!");
			}
			setItemValue(0,0,"CreditCycle","2");
		}
		
		sCreditCycle = getItemValue(0,0,"CreditCycle");//再次获取是否投保
		if(parseFloat(sBusinessSum) < 0){
			 alert("贷款金额必须大于0！");
			 return;
			}else{
				if(parseFloat(parseInt(sBusinessSum,10))<parseFloat(sBusinessSum)){
					alert("贷款金额的差必须为整数，请检查");
					return;
				}
				var sMonthPayment=RunMethod("PublicMethod","GetMonthPayment",sBusinessSum+","+sBusinessType+","+sPeriods+","+sCreditCycle+","+sBugPayPkgind);
				
				var MonthPaymentBefore = parseFloat(sMonthPayment);
				var MonthPaymentAfter = fix(MonthPaymentBefore);
				setItemValue(0,getRow(),"MonthRepayment",MonthPaymentAfter+"");
				//end
			}
		
	}
	/*~[Describe=重置;InputParam=无;OutPutParam=无;]~*/
	function doReset(){
		reloadSelf();
	}
	/*~[Describe=小数进位;InputParam=无;OutPutParam=无;]~*/
	function fix(d) {
		var temp = d * 10;
		var value1 = Math.ceil(parseFloat(temp));//进位取整
		var finalyvalue = parseFloat(value1)/10;
		if(d==parseInt(d,10)){
			finalyvalue = d;
		}
		return finalyvalue;
	}
	//end by phe
	
	
	//add CCS-1118 PRM-659 无预约现金贷增加【客户来源】字段    by fangxq 20151130 
	function customerSourceChange(){
		var remark=getItemValue(0,0,"CustomerSource");
		if(remark=="008"){
			showOtherItem(0,0,"CustomerSource_other","");
			setItemRequired(0,0,"CustomerSource_other",true);
		}else{
			showOtherItem(0,0,"CustomerSource_other","none");
			setItemRequired(0,0,"CustomerSource_other",false);
		}
	}
	
	function showOtherItem(iDW,iRow,sCol,display){
		if(display==undefined || display=="block") display = ""; //暂时这么处理
		var iCol = getColIndex(iDW,sCol);
		var oInput = window.frames["myiframe"+iDW].document.getElementById("R"+iRow+"F"+iCol);
		oInput.parentNode.style.display = display;
		window.frames["myiframe"+iDW].document.getElementById("TDR"+iRow+"F"+iCol).style.display =display;
	}
	//PRM-659 END
	
	
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
	customerSourceChange(); //PRM-659
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>