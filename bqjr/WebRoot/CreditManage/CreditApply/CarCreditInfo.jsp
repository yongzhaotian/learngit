<%@page import="com.amarsoft.app.accounting.util.FeeFunctions"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.accounting.config.loader.ProductConfig"%>
<%@ page import="com.amarsoft.app.accounting.web.*"%>
<%@ page import="com.amarsoft.app.accounting.product.*"%>
<%@ page import="com.amarsoft.app.accounting.businessobject.*"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
<%
	/*
		Author:   
		Tester:
		Content: 
		Input Param:
				 ObjectType：
				 ObjectNo：
		Output param:
		History Log: xswang 2015/06/01 CCS-713 合同中的门店跳转为其他门店
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "汽车贷款"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得页面参数	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";

	//定义变量：贷款类型、客户号、经销商、产品类型、厂商、金融产品名称
	String CreditType = "",CustomerID = "",DealerName = "",ProductID = "",Vendor = "",ProductName = "";
	//定义变量：贷款期限（月）、车辆型号、车况、市场指导价、延保费
	String CreditMonth = "",CarModel = "",CarStatus = "",DirectPrice = "",Premiums = "";
	//定义变量：车辆附加配置金额、关联业务到期日、车辆购置税、起息日
	String AllocationSum = "",Maturity = "",RevenueTax = "",PutoutDate = "",ssSno="",sSname="",sServiceprovidersID = "",sServiceprovidersname="",sGenusgroup="",sCarfactoryid="",sCarfactory="";
	//定义变量：保险费、车辆售价、车辆总价/担保服务费/还款保险费/手续费/费用总计/每月费用/首付金额/贷款金额/尾款金额/月还款金额
	double InsureSum = 0.0,VehiclePrice = 0.0,CarTotal = 0.0,AssureService=0.0,Premium=0.0,ProcedureFee=0.0,CostTotal = 0.0,MonthCost = 0.0,PaymentSum = 0.0,PaymentTotal=0.0,BusinessSum=0.0,FinalPaymentSum=0.0,MonthrePayment=0.0;
	//定义变量：贷款比例、尾款比例、还旧借新次数、债务重组次数
	int PaymentRate = 0,FinalPayment = 0;
	double PaycostTotal = 0.0;//应还费用合计
	//定义变量：查询结果集
	ASResultSet rs = null;
	
	//定义变量：关联业务币种、关联业务到期日、关联流水号、借据号
	String sOldBusinessCurrency = "",sOldMaturity = "",sRelativeSerialNo = "",dOldSerialNo = "",sSno="",ssSname="",sCreditId="",sCreditPerson="",sCity="",sAttr2="";
		

	BusinessObject simulationObject = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	if(simulationObject==null) simulationObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessContract");

	//贷款比较所需条件
	String simulationSchemeCount=(String)session.getValue("SimulationSchemeCount");
	if(simulationSchemeCount==null){
		session.putValue("SimulationSchemeCount","1");
		simulationSchemeCount="1";
	}
	
	String productID =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProductID")));
	CustomerID =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID")));
	//String Vendor =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Vendor")));
	//String paraStr =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("paraStr")));
	String productVersion =  "V1.0";
	if(productID==null)productID="";
	if(CustomerID==null)CustomerID="";


	 
    //销售门店
    //String sNo = CurARC.getAttribute(request.getSession().getId()+"city");
    // add by xswang 2015/06/01 CCS-713 合同中的门店跳转为其他门店
    //String sNo = Sqlca.getString(new SqlObject("select attribute8 from user_info  where userid=:UserID").setParameter("UserID", CurUser.getUserID()));
    String sNo = CurUser.getAttribute8();
	// end by xswang 2015/06/01

    if(sNo == null) sNo = "";
    System.out.println("-------销售门店-------"+sNo);
    String sSql = "";
    sSql="select sno,sname from store_info where sno = :sno and  identtype = '01'";
    rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sno",sNo));
    if(rs.next()){
   	 sSno = DataConvert.toString(rs.getString("sno"));//门店
   	 sSname = DataConvert.toString(rs.getString("sname"));
		//将空值转化成空字符串
		if(sSno == null) sSno = "";
		if(sSname == null) sSname = "";
		
    }
    rs.getStatement().close();
    
    
    String sCityName = "" ;//区域中文名
    //汽车贷款处理
    sSql="select si.city as city,getitemname('AreaCode',si.city) as cityName,si.sno as sno,si.sname as sname,sp.serialNo as serviceprovidersID, sp.serviceprovidersname as serviceprovidersname,sp.genusgroup as genusgroup,sp.carfactoryid as carfactoryid,sp.carfactory as carfactory from store_info si,service_providers sp where si.rserialno=sp.serialno and si.identtype='02' and sp.customertype1='07' and si.sno=:sno";
    rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sno",sNo));
    if(rs.next()){
   	 ssSno = DataConvert.toString(rs.getString("sno"));//展厅编号
   	 ssSname = DataConvert.toString(rs.getString("sname"));//展厅名称
   	 sServiceprovidersID = DataConvert.toString(rs.getString("serviceprovidersID"));//服务商编号
   	 sServiceprovidersname = DataConvert.toString(rs.getString("serviceprovidersname"));//服务商名称
   	 sGenusgroup = DataConvert.toString(rs.getString("genusgroup"));//所属集团
   	 sCarfactoryid = DataConvert.toString(rs.getString("carfactoryid"));//所属车厂ID
   	 sCarfactory = DataConvert.toString(rs.getString("carfactory"));//所属车厂名称
   	 sCity = DataConvert.toString(rs.getString("city"));//区域
   	 sCityName = DataConvert.toString(rs.getString("cityName"));//区域
    }
    rs.getStatement().close();
    
    ARE.getLog().debug("======"+sCity+","+ssSno+","+ssSname+","+sServiceprovidersname+","+sGenusgroup+","+sCarfactoryid+","+sCarfactory);
       

	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CarCreditInfo";//模型编号
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);//交易定义详情模板
	doTemp.setReadOnly("DirectPrice,CarTotal,CostTotal,MonthCost,PaymentSum,PaymentTotal,BusinessSum,BusinessRate,FinalPaymentSum,MonthrePayment", true);
	doTemp.setHTMLStyle("Premiums,AllocationSum,RevenueTax,InsureSum,VehiclePrice", "onChange=\"javascript:parent.countCarTotal()\"");//延保费+车辆附加配置金额+车辆购置税+保险费+车辆售价=车辆总价
	doTemp.setHTMLStyle("AssureService,Premium,ProcedureFee","onChange=\"javascript:parent.countCostTotal()\"");
	doTemp.setHTMLStyle("CreditMonth","onChange=\"javascript:parent.countMonthCost()\"");
	doTemp.setHTMLStyle("PaymentRate","onChange=\"javascript:parent.countPayment()\"");
	doTemp.setHTMLStyle("FinalPayment","onChange=\"javascript:parent.FinalPaymentSum()\"");
	doTemp.setHTMLStyle("ProductName","onChange=\"javascript:parent.cleanCarModel()\"");
	doTemp.setHTMLStyle("CreditApr,ProductID","onChange=\"javascript:parent.checkRate()\"");
	doTemp.setHTMLStyle("MonthrePayment","onClick=\"javascript:parent.countMonthrePayment()\"");
	    

	

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		//{"true","","Button","保存","保存","saveRecord()",sResourcesPath},
		{"true","","Button","保存","保存记录","saveBusinessObjectToSession(\'"+simulationObject.getObjectType()+"\')",sResourcesPath},
		{"false","","Button","返回","返回","goBack()",sResourcesPath},
		{"true","","Button","查看还款计划","查看还款计划","",sResourcesPath},
		{"false","","Button","重置查询数据","清除原有查询数据","reset()",sResourcesPath},
		{"false","","Button","生成还款计划","还款计划查看","",sResourcesPath}
	};
	sButtons[2][5]="runTransaction2('0020','"+simulationObject.getObjectType()+"','"+simulationObject.getObjectNo()+"','"+simulationObject.getString("PutoutDate")+"')";
	if((BusinessObject)session.getAttribute("SimulationObject_Loan") != null){
		sButtons[3][0] = "true";
	}
	
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	var bIsInsert = false;
	//---------------------定义按钮事件------------------------------------
	function selectOpponentName()
	{
		var sSerialNo = "<%=sServiceprovidersID%>";//经销商编号
		var sEntInfoValue2=setObjectValue("SelectDistributorLoadInfo0","SerialNo,"+sSerialNo,"@productName@1",0,0,"");
		if(typeof(sEntInfoValue2)=="undefined" || sEntInfoValue2=="" || sEntInfoValue2=="_CANCEL_" ) return;
		if(sEntInfoValue2=="_CLEAR_"){
			setItemValue(0,0,"ProductID","");
	    	setItemValue(0,0,"ProductVersion",""); 
	    	setItemValue(0,0,"ProductName","");
	    	setItemValue(0,0,"CreditApr","");
	    	setItemValue(0,0,"MonthrePayment","");
		}else{
	    	sEntInfoValue2=sEntInfoValue2.split('@');
	    	sProductID=sEntInfoValue2[0];        //经销商关联的产品代码
	    	sProductName=sEntInfoValue2[1];      //产品名称
	    	sFloatingManner=sEntInfoValue2[2];   //浮动方式
	    	sInterestRate=sEntInfoValue2[3];     //利率类型
	    	sFloatingRange=sEntInfoValue2[4];    //浮动幅度
	    	setItemValue(0,0,"ProductID",sProductID);
	    	setItemValue(0,0,"ProductVersion","V1.0"); 
	    	setItemValue(0,0,"ProductName",sProductName);
	    	checkRate();
	    	countMonthrePayment();
		}
	}
	
	function runTransaction2(transcode,documenttype,documentno,transDate){
		var returnValue = PopPage("/Accounting/LoanSimulation/RunTransaction2.jsp?TransCode="+transcode+"&DocumentType="+documenttype+"&DocumentNo="+documentno+"&TransDate="+transDate+"&ToInheritObj=y","","resizable=yes;dialogWidth=30;dialogHeight=30;dialogLeft=400;dialogTop=200;center:yes;status:no;statusbar:no");
		if(returnValue==0) alert("交易执行成功！");

		OpenComp("ACCT_LoanSimulationCashFlowTab","/Accounting/LoanSimulation/CashFlowTab.jsp","","");
		//reloadSelf();

		//PopPage("/Accounting/LoanSimulation/PaymentScheduleList.jsp?","","");
		reloadSelf();

	}
	
	// 返回交易列表
	function goBack()
	{
		//OpenPage("/BusinessManage/CollectionManage/TransferDealManagerList.jsp","_self","");
	}
	

	//汽车型号代码
	function selectCarCode(){
		var sTypeNo = getItemValue(0,0,"ProductID");
		if(typeof(sTypeNo) == "undefined" || sTypeNo == "")
		{
			alert("请先选择金融产品名称!");
			return;
		}
		//设置返回参数 
		var sReturnValues = setObjectValue("SelectCarCodeInfo","TypeNo,"+sTypeNo,"",0,0,"");

		if(typeof(sReturnValues)=="undefined" || sReturnValues=="" || sReturnValues=="_CANCEL_" ) return;
		if(sReturnValues=="_CLEAR_"){
			setItemValue(0,0,"CarModel","");
			setItemValue(0,0,"DirectPrice","");	
		}else{
			sReturnValue = sReturnValues.split("@");
			var CarModel = sReturnValue[0];
			var DirectPrice =  sReturnValue[1];
			setItemValue(0,0,"CarModel",CarModel);
			setItemValue(0,0,"DirectPrice",DirectPrice);	
		}
	}
	
	function initRow()
	{

		//设置贷款类型
		setItemValue(0,0,"CreditType","01");
		//经销商设置
		setItemValue(0,0,"DealerName","<%=sServiceprovidersname%>");
		//厂商
		setItemValue(0,0,"Vendor","<%=sCarfactory%>");

		
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			//设置贷款类型
			bIsInsert = true;
		}
		setItemValue(0,0,"CreditType","01");
    }
	 
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "Car_Credit_Info";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
       
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	} 
	
	//计算车辆总价
	function countCarTotal(){
		var DirectPrice = getItemValue(0,0,"DirectPrice");
		var Premiums = getItemValue(0,0,"Premiums");
		var AllocationSum = getItemValue(0,0,"AllocationSum");
		var RevenueTax = getItemValue(0,0,"RevenueTax");
		var InsureSum = getItemValue(0,0,"InsureSum");
		var VehiclePrice = getItemValue(0,0,"VehiclePrice");
		if(DirectPrice==null||DirectPrice=="") DirectPrice=0;
		if(Premiums==null||Premiums=="") Premiums=0;
		if(AllocationSum==null||AllocationSum=="") AllocationSum=0;
		if(RevenueTax==null||RevenueTax=="") RevenueTax=0;
		if(InsureSum==null||InsureSum=="") InsureSum=0;
		if(VehiclePrice==null||VehiclePrice=="") VehiclePrice=0;
		if(DirectPrice<VehiclePrice){
			alert("车辆售价不得超过市场指导价！");
			return;
		}
		//计算车辆总价
		var sPara = "attribute1="+Premiums+",attribute2="+AllocationSum+",attribute3="+RevenueTax+",attribute4="+InsureSum+",attribute5="+VehiclePrice;
		var CarTotal = RunJavaMethodSqlca("com.amarsoft.proj.action.JSgetDoubleSum","countCarTotal",sPara);
		if(CarTotal=="Null"||CarTotal=="null"||CarTotal==""){
			setItemValue(0,0,"CarTotal","");
		}else{
			setItemValue(0,0,"CarTotal",CarTotal);
		}
		
	}
	
	//计算费用总计
	function countCostTotal(){
		var AssureService = getItemValue(0,0,"AssureService");
    	var Premium = getItemValue(0,0,"Premium");
    	var ProcedureFee = getItemValue(0,0,"ProcedureFee");
    	if(AssureService==null||AssureService=="") AssureService=0;
    	if(Premium==null||Premium=="") Premium=0;
    	if(ProcedureFee==null||ProcedureFee=="") ProcedureFee=0;
    	//计算费用总计
		var sPara = "attribute1="+AssureService+",attribute2="+Premium+",attribute3="+ProcedureFee+",attribute4=0,attribute5=0";
		var CostTotal = RunJavaMethodSqlca("com.amarsoft.proj.action.JSgetDoubleSum","countCarTotal",sPara);
		if(CostTotal=="Null"||CostTotal=="null"||CostTotal==""){
			setItemValue(0,0,"CostTotal","0");
			countMonthCost();
		}else{
			setItemValue(0,0,"CostTotal",CostTotal);	
			countMonthCost();
		}	
	}
	
	//计算每月费用
	function  countMonthCost(){
		var CostTotal = getItemValue(0,0,"CostTotal");
		var CreditMonth = getItemValue(0,0,"CreditMonth");
		
		if(CostTotal==null||CostTotal=="") CostTotal=0;	
		//if(CreditMonth==null||CreditMonth=="") return;
		
		//注意期限要进行码值与实际值的转换: 0	12   1	18   2	24   3	36   4	48   5	60 
		var sTerm = RunMethod("LoanAccount","TermConvert",CreditMonth);
		if(typeof(sTerm)=="undefined"||sTerm==""){
			return;
		}
		var sPara = "attribute1="+CostTotal+",attribute2="+sTerm;
		var MonthCost = RunJavaMethodSqlca("com.amarsoft.proj.action.JSgetDoubleSum","countMonthCost",sPara);
		if(MonthCost=="Null"||MonthCost=="null"||MonthCost==""){
			setItemValue(0,0,"MonthCost","0");
		}else{			
			setItemValue(0,0,"MonthCost",MonthCost);
			}
	}
	
	//计算首付金额、首付合计、贷款比例、贷款金额
	function countPayment(){
		var PaymentRate = getItemValue(0,0,"PaymentRate");
		if(typeof(PaymentRate)=="undefined"||PaymentRate==""){
			return;
		}
		var CarTotal = getItemValue(0,0,"CarTotal");
		if(typeof(CarTotal)=="undefined"||CarTotal==""){
			return;
		}
		var sPara = "attribute1="+PaymentRate+",attribute2="+CarTotal;
		var sReturnValues = RunJavaMethodSqlca("com.amarsoft.proj.action.JSgetDoubleSum","countPayment",sPara);
		if(typeof(PaymentRate)=="undefined"||PaymentRate==""){
			return;
		} else{
			var PaymentSum = sReturnValues.split("@")[0];
			var BusinessRate = sReturnValues.split("@")[1];
	    	var BusinessSum = sReturnValues.split("@")[2]; 
	    	setItemValue(0,0,"PaymentSum",PaymentSum);
	    	setItemValue(0,0,"PaymentTotal",PaymentSum);
	    	setItemValue(0,0,"BusinessRate",BusinessRate);
	    	setItemValue(0,0,"BusinessSum",BusinessSum);
	    	FinalPaymentSum();
		}  	
	}
	
	//计算尾款金额
	function FinalPaymentSum(){
		var BusinessSum = getItemValue(0,0,"BusinessSum");
		if(typeof(BusinessSum)=="undefined"||BusinessSum==""){
			return;
		}
		var FinalPayment = getItemValue(0,0,"FinalPayment");
		if(typeof(FinalPayment)=="undefined"||FinalPayment==""){
			return;
		}
		var sPara = "attribute1="+BusinessSum+",attribute2="+FinalPayment;
		var sReturnValues = RunJavaMethodSqlca("com.amarsoft.proj.action.JSgetDoubleSum","FinalPaymentSum",sPara);
		if(typeof(sReturnValues)=="undefined"||sReturnValues==""){
			return;
		}else{
			setItemValue(0,0,"FinalPaymentSum",sReturnValues);
		}
	}
	
	//金融产品变更时，清空车型
	function cleanCarModel(){
		setItemValue(0,0,"CarModel","");
		setItemValue(0,0,"DirectPrice","");
		countCarTotal();		
	}
	
	//贷款年利率校验
	function checkRate(){	
		
		var sTypeNo = getItemValue(0,0,"ProductID");
		if(typeof(sTypeNo) == "undefined" || sTypeNo == "")
		{
			setItemValue(0,0,"CreditApr","");
			return;
		}
		var CreditMonth = getItemValue(0,0,"CreditMonth");
		
		//获取产品参数的“是否贴现”、“利率类型”、“浮动类型”  
		var sReurnValues = RunJavaMethodSqlca("com.amarsoft.proj.action.GetRelativeRateInfo","getRateInfo","typeNo="+sTypeNo);
		if(typeof(sReurnValues)=="undefined"||sReurnValues=="") return;
		
	    //是否贴现：whetherDiscount			TrueFalse                          利率类型：rateType		RateType1                    浮动类型:floatingManner			RateFloatType
		var whetherDiscount = sReurnValue.split("@")[0];//0	否     		1	是
		var rateType = sReurnValue.split("@")[1];//0	固定利率				1	浮动利率			2	固定灵活利率
		var floatingManner = sReurnValue.split("@")[2];//0	按浮动比列					1	按浮动点
		//取期限参数中的“固定利率值”、“最高固定利率”、“浮动幅度”、  ”贴息客户固定利率“
		sReurnValues = RunJavaMethodSqlca("com.amarsoft.proj.action.GetRelativeRateInfo","getRateInfoFromTerm","typeNo="+sTypeNo+",term="+CreditMonth);
		//固定利率值:loanFixedRate			最高固定利率:highestFixedRate      			浮动幅度:floatingRate
		if(typeof(sReurnValues)=="undefined"||sReurnValues=="") return;
		var loanFixedRate = sReurnValue.split("@")[0];
		var highestFixedRate = sReurnValue.split("@")[1];
		var floatingRate = sReurnValue.split("@")[2];
		var discountFixedRate = sReurnValue.split("@")[3];
		
		if(whetherDiscount=="0"){//不贴息产品
			if(rateType=="2"){//利率类型选择固定灵活利率需要销售经理手工输入贷款利率，并控制贷款利率不能小于产品期限相关参数配置表中的固定利率值，同时不得高于最高固定利率。
				var CreditApr = getItemValue(0,0,"CreditApr");
				if(CreditApr<loanFixedRate){
					alert("贷款利率不能小于产品期限相关参数配置表中的固定利率值");
					return;
				}
				if(CreditApr>highestFixedRate){
					alert("贷款利率不能高于产品期限相关参数配置表中的最高固定利率");
					return;
				}			
			}else{
				setItemReadOnly(0,0,"CreditApr",true);
				if(rateType=="0"){//若利率类型为固定利率，显示产品期限相关参数配置表中的固定利率值。
					setItemValue(0,0,"CreditApr",loanFixedRate);
				}else if(rateType=="1"){//当利率类型为浮动利率时，根据期限找到对应的基准利率，
					//取人行基准利率  
					//期限转换：
					/* Term：		1	6月-12月 (含12月)			2	12-36月 (含36月)				3	37-60月 (含60月)
						Term1：	0	12									1	18									2	24								3	36						4	48						5	60					*/
					var Term = "";
					if(CreditMonth=="0") Term = "1";
					if(CreditMonth=="1"||CreditMonth=="2"||CreditMonth=="3") Term = "2";
					if(CreditMonth=="4"||CreditMonth=="5") Term = "3";
					sReurnValues = RunJavaMethodSqlca("com.amarsoft.proj.action.GetRelativeRateInfo","getRateInfoFromTerm","term="+Term);
					//基准利率:yearsInterestRate（年利率）   monthInterestRate（月利率）
					if(typeof(sReurnValues)=="undefined"||sReurnValues=="") return;
					var yearsInterestRate = sReurnValue.split("@")[0];
					var monthInterestRate = sReurnValue.split("@")[1];
					//若为按比例浮动，则贷款利率=基准利率*（1+浮动幅度），若为按浮动点，则贷款利率=基准利率+浮动幅度
						var sPara = "attribute1="+monthInterestRate+",attribute2="+floatingRate+"attribute3="+floatingManner;
						sReurnValues = RunJavaMethodSqlca("com.amarsoft.proj.action.JSgetDoubleSum","CountCreditApr",sPara);
						if(typeof(sReurnValues)=="undefined"||sReurnValues=="") return;
						setItemValue(0,0,"CreditApr",sReurnValues);
				}
			}
		}else if(whetherDiscount=="1"){//贴息产品：贴息客户固定利率    discountFixedRate
			setItemValue(0,0,"CreditApr",discountFixedRate);
		}else{
			alert("请完善产品参数配置");
			setItemValue(0,0,"CreditApr","");
		}	
	}
	
	//计算月供
	function countMonthrePayment(){
		var sTypeNo = getItemValue(0,0,"ProductID");
		if(typeof(sTypeNo) == "undefined" || sTypeNo == "")
		{
			setItemValue(0,0,"MonthrePayment","");
			return;
		}
		var CreditMonth = getItemValue(0,0,"CreditMonth");
		//注意期限要进行码值与实际值的转换: 0	12   1	18   2	24   3	36   4	48   5	60 
		var sTerm = RunMethod("LoanAccount","TermConvert",CreditMonth);
		if(typeof(sTerm)=="undefined"||sTerm==""){
			return;
		}
		var FinalPayment = getItemValue(0,0,"FinalPayment");
		var FinalPaymentSum = getItemValue(0,0,"FinalPaymentSum");
		var BuinsessSum = getItemValue(0,0,"BusinessSum");
		var CreditApr = getItemValue(0,0,"CreditApr");
		if(typeof(FinalPayment) == "undefined" || FinalPayment == "") FinalPayment = 0;
		if(typeof(FinalPaymentSum) == "undefined" || FinalPaymentSum == "") FinalPaymentSum = 0;
		if(typeof(BuinsessSum) == "undefined" || BuinsessSum == "") BuinsessSum = 0;
		if(typeof(CreditApr) == "undefined" || CreditApr == "") CreditApr = 0;
		
		var sPara ="typeNo="+sTypeNo+",term="+sTerm+",rate="+CreditApr+",financeAmount="+BuinsessSum+",finalPayment="+FinalPayment+",finalPaymentSum="+FinalPaymentSum;
		//获取产品参数的“月供计算方式”，并计算每月还款金额
		var sReurnValues = RunJavaMethodSqlca("com.amarsoft.proj.action.GetMonthPayment","getMonthPayment",sPara);
		if(typeof(sReurnValues)=="undefined"||sReurnValues=="") return;
		setItemValue(0,0,"MonthrePayment",sReurnValues);
	}
	
	function PMT (ir, np, pv, fv ) {
		 /*
		 ir - interest rate per month
		 np - number of periods (months)
		 pv - present value
		 fv - future value (residual value)
		 type - 0 or 1 need to implement that
		 */
		 pmt = ( ir * ( pv * Math.pow ( (ir+1), np ) + fv ) ) / ( ( ir + 1 ) * ( Math.pow ( (ir+1), np) -1 ) );
		 return pmt;
		}
	
	/* 月供计算函数
	 [in]princ : 总价
	 [in]dp:  首付百分比 (例 : 20% -> dp=20 )
	 [in]term: 还款期数 (例 : 5年 -> term=5*12)
	 [out]pmt: 月供金额 */
	 
	 function PMT(princ,dp,term)
	 {
	     princ = price*(1-dp/100);
	     intRate = ir/100/ 12;
	     months = term * 12;
	     pmt = Math.floor((princ*intRate)/(1-Math.pow(1+intRate,(-1*months)))*100)/100;
	     return pmt;
	 }
	
	//更新对应数值
	function beforeSave(){
		var ProductID = getItemValue(0,0,"ProductID");
    	var CustomerID = getItemValue(0,0,"CustomerID");
    	var DealerName = getItemValue(0,0,"DealerName");
    	var Vendor = getItemValue(0,0,"Vendor");
		var ProductName = getItemValue(0,0,"ProductName");
    	var CreditMonth = getItemValue(0,0,"CreditMonth");
    	var CarModel = getItemValue(0,0,"CarModel");
    	var CarStatus = getItemValue(0,0,"CarStatus");
		var DirectPrice = getItemValue(0,0,"DirectPrice");
    	var Premiums = getItemValue(0,0,"Premiums");
    	var Maturity = getItemValue(0,0,"Maturity");
    	var AllocationSum = getItemValue(0,0,"AllocationSum");
		var RevenueTax = getItemValue(0,0,"RevenueTax");
    	var PutoutDate = getItemValue(0,0,"PutoutDate");
    	var InsureSum = getItemValue(0,0,"InsureSum");
    	var VehiclePrice = getItemValue(0,0,"VehiclePrice");
		var CarTotal = getItemValue(0,0,"CarTotal");
    	var AssureService = getItemValue(0,0,"AssureService");
    	var Premium = getItemValue(0,0,"Premium");
    	var ProcedureFee = getItemValue(0,0,"ProcedureFee");
		var CostTotal = getItemValue(0,0,"CostTotal");
    	var MonthCost = getItemValue(0,0,"MonthCost");
    	var PaymentSum = getItemValue(0,0,"PaymentSum");
    	var PaymentRate = getItemValue(0,0,"PaymentRate");
		var PaymentTotal = getItemValue(0,0,"PaymentTotal");
    	var BusinessSum = getItemValue(0,0,"BusinessSum");
    	var BusinessRate = getItemValue(0,0,"BusinessRate");
    	var CreditType = getItemValue(0,0,"CreditType");
    	var FinalPaymentSum = getItemValue(0,0,"FinalPaymentSum");
		var FinalPayment = getItemValue(0,0,"FinalPayment");
    	var MonthrePayment = getItemValue(0,0,"MonthrePayment");
    	var PrinciPal = getItemValue(0,0,"PrinciPal");
    	var Interest = getItemValue(0,0,"Interest");
		var FinalInterest = getItemValue(0,0,"FinalInterest");
    	var PaycostTotal = getItemValue(0,0,"PaycostTotal");
    	var RepaymentDate = getItemValue(0,0,"RepaymentDate");
    	
    	/* +"&RevenueTax="+RevenueTax+"&PutoutDate="+PutoutDate+"&InsureSum="+InsureSum+"&"
		+"VehiclePrice="+VehiclePrice+"&CarTotal="+CarTotal+"&AssureService="+AssureService+"&Premium="+Premium+"&ProcedureFee="+ProcedureFee+"&CostTotal="+CostTotal+"&MonthCost="+MonthCost+"&PaymentSum="+PaymentSum+"&"
		+"PaymentRate="+PaymentRate+"&PaymentTotal="+PaymentTotal+"&BusinessSum="+BusinessSum+"&FinalPaymentSum="+FinalPaymentSum+"&FinalPayment="+FinalPayment+"&MonthrePayment="+MonthrePayment+"&PrinciPal="+PrinciPal+"&Interest="+Interest+"&"
		+"FinalInterest="+FinalInterest+"&PaycostTotal="+PaycostTotal+"&RepaymentDate="+RepaymentDate;
		 
    	*/
    	var sParaString = "";
    	sParaString = "&Maturity="+Maturity+"&Premium="+Premium+"&FinalPaymentSum="+FinalPaymentSum+"&Premiums="+Premiums+"&RevenueTax="+RevenueTax+"&InsureSum="+InsureSum+
    	"&AssureService="+AssureService+"&ProcedureFee="+ProcedureFee+"&BusinessSum="+BusinessSum+"&BusinessRate="+BusinessRate+"&CreditType="+CreditType+"&ProductID="+ProductID+"&CustomerID="+CustomerID;
		
    	return sParaString;
		
	}
	

	//保存
	function saveBusinessObjectToSession(businessObjectType,parentObjectType,parentObjectNo){
		var sParaStr2=beforeSave();
		//return;

		if(businessObjectType=="jbo.app.BUSINESS_CONTRACT"){
			var r = checkSave();
			if(r==1){
				return;
			}
		}	

		var colCount = DZ[0][1].length;//列数
		var paraStr = "RowCount="+getRowCount(0);
		var colnames="";
		for(var i=0;i<DZ[0][1].length;i++){
			var updateable=DZ[0][1][i][5];
			//alert(updateable+"--"+getColName(0,i));
			if(updateable==0) continue;
			colnames+=getColName(0,i)+",";
		}
		colnames = colnames.substring(0,colnames.length-1);
		for(var j=1;j<=getRowCount(0);j++){
			for(var i=0;i<colCount;i++){
				var updateable=DZ[0][1][i][5];
				if(updateable==0) continue;
				var value=getItemValueByIndex(0,j-1,i);
				if(typeof(value)=="undefined"||value==null || value.length==0||value=="null"||value=="Null") continue;
				paraStr += "&"+getColName(0,i)+j+"="+value;
			}
		}
		if(typeof(parentObjectType)=="undefined"||parentObjectType==null ||parentObjectType=="null"||parentObjectType=="Null") 
			parentObjectType="";
		if(typeof(parentObjectNo)=="undefined"||parentObjectNo==null ||parentObjectNo=="null"||parentObjectNo=="Null") 
			parentObjectNo="";
		paraStr+="&ParentObjectType="+parentObjectType;
		paraStr+="&ParentObjectNo="+parentObjectNo;
		paraStr+=sParaStr2;
		paraStr+="&BusinessObjectType="+businessObjectType+"&ColNames="+colnames;
		
		//空行不保存，再次刷新后无空行出现
		var returnValue = PopPage("/Accounting/LoanSimulation/BusinessObjectAction.jsp?"+paraStr,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
	
		if(returnValue=="true"){
			alert("保存成功！");
			if(businessObjectType=="jbo.app.BUSINESS_CONTRACT"){
				parent.tt();
			}		
			reloadSelf();
		}
		else alert("保存失败！");
	}
	
	//数据重置
	function reset(){
		session.removeAttribute("SimulationObject_Loan");
		session.removeAttribute("SimulationObject_BusinessContract");
		reloadSelf();
	}
	
	</script>

<script language=javascript>
<%=DWExtendedFunctions.setDataWindowValues(simulationObject,simulationObject, dwTemp,Sqlca) %>
	AsOne.AsInit();
	bFreeFormMultiCol=true;
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	

<%@ include file="/IncludeEnd.jsp"%>
