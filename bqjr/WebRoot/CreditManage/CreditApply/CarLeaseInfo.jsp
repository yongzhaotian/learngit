<%@ page contentType="text/html; charset=GBK"%>
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


	<%
	String PG_TITLE = "融资租赁"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String sSql="",ssSno="",sSname="",sServiceprovidersname="",sServiceprovidersID="",sGenusgroup="",sCarfactoryid="",sCarfactory="";
	ASResultSet rs = null;
	
	//获得页面参数	：
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	//定义变量：关联业务币种、关联业务到期日、关联流水号、借据号
	String sOldBusinessCurrency = "",sOldMaturity = "",sRelativeSerialNo = "",dOldSerialNo = "",sSno="",ssSname="",sCreditId="",sCreditPerson="",sCity="",sAttr2="";
			
	if(sSerialNo==null) sSerialNo="";
	%>
	<%/*~END~*/%>

	<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
	<% 
		BusinessObject simulationObject = (BusinessObject)session.getAttribute("SimulationObject_Loan");
		if(simulationObject==null) simulationObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessContract");

		//贷款比较所需条件
		String simulationSchemeCount=(String)session.getValue("SimulationSchemeCount");
		if(simulationSchemeCount==null){
			session.putValue("SimulationSchemeCount","1");
			simulationSchemeCount="1";
		}
		
		String productID =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProductID")));
		String CustomerID =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID")));
		//String Vendor =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Vendor")));
		//String paraStr =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("paraStr")));
		String productVersion =  "V1.0";
		if(productID==null)productID="";
		if(CustomerID==null)CustomerID="";
		%>
	<%/*~END~*/%>

<%
//销售门店
// add by xswang 2015/06/01 CCS-713 合同中的门店跳转为其他门店
//String sNo = Sqlca.getString(new SqlObject("select attribute8 from user_info  where userid=:UserID").setParameter("UserID", CurUser.getUserID()));
String sNo = CurUser.getAttribute8();
// end by xswang 2015/06/01

if(sNo == null) sNo = "";
System.out.println("-------销售门店-------"+sNo);
sSql = "";
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
	String sTempletNo = "CarLeaseInfo";//模型编号
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);//交易定义详情模板
	doTemp.setReadOnly("DirectPrice,Cashdeposit,StartRent,SalvageSum,PaymentTotal,Appropriation,CostTotal,MonthCost,MonthRent", true);
	doTemp.setHTMLStyle("DirectPrice,Premiums,AllocationSum,RevenueTax,InsureSum,SalvageSum", "onChange=\"javascript:parent.countAppropriation()\"");
	doTemp.setHTMLStyle("AssureService,ProcedureFee,Stampduty,Premium,Vat,ResellFee","onChange=\"javascript:parent.countCostTotal()\"");
	doTemp.setHTMLStyle("CreditMonth","onChange=\"javascript:parent.countMonthCost()\"");
	doTemp.setHTMLStyle("SalvageRate","onChange=\"javascript:parent.SalvageSum()\"");
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
	function selectOpponentNameOld()
	{
		sBusinessType = getItemValue(0,0,"CreditType");
		if(typeof(sBusinessType) == "undefined" || sBusinessType == "")
		{
			alert("请先选择产品类型!");
			return;
		}
		
		sParaString = "BusinessType"+","+sBusinessType; 
		//设置返回参数 
		setObjectValue("SelectBusinessInfo",sParaString,"@ProductId@0@ProductName@1",0,0,"");
	}
	function selectOpponentName()
	{
		var sSerialNo = "<%=sServiceprovidersID%>";//经销商编号
		var sEntInfoValue2=setObjectValue("SelectDistributorLoadInfo0","SerialNo,"+sSerialNo,"@productName@1",0,0,"");
		if(typeof(sEntInfoValue2)=="undefined" || sEntInfoValue2=="" || sEntInfoValue2=="_CANCEL_" ) return;
		if(sEntInfoValue2=="_CLEAR_"){
			setItemValue(0,0,"ProductID","");
	    	/* setItemValue(0,0,"ProductVersion","V1.0"); */
	    	setItemValue(0,0,"ProductName","");
	    	setItemValue(0,0,"CreditApr","");
		}else{
	    	sEntInfoValue2=sEntInfoValue2.split('@');
	    	sProductID=sEntInfoValue2[0];        //经销商关联的产品代码
	    	sProductName=sEntInfoValue2[1];      //产品名称
	    	sFloatingManner=sEntInfoValue2[2];   //浮动方式
	    	sInterestRate=sEntInfoValue2[3];     //利率类型
	    	sFloatingRange=sEntInfoValue2[4];    //浮动幅度
	    	setItemValue(0,0,"ProductID",sProductID);
	    	/* setItemValue(0,0,"ProductVersion","V1.0"); */
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
			
	function saveRecord()
	{
		initSerialNo();
		as_save("myiframe0");
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
		setItemValue(0,0,"CreditType","02");
		//经销商设置
		setItemValue(0,0,"DealerName","<%=sServiceprovidersname%>");
		//厂商
		setItemValue(0,0,"Vendor","<%=sCarfactory%>");
		
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			//设置贷款类型
			setItemValue(0,0,"CreditType","02");
			//经销商设置
			setItemValue(0,0,"DealerName","<%=sServiceprovidersname%>");
			//厂商
			setItemValue(0,0,"Vendor","<%=sCarfactory%>");
			bIsInsert = true;
		}
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

	//计算总拨款额
	function countAppropriation()
	{
		var DirectPrice = getItemValue(0,0,"DirectPrice");
		var Premiums = getItemValue(0,0,"Premiums");
		var AllocationSum = getItemValue(0,0,"AllocationSum");
		var RevenueTax = getItemValue(0,0,"RevenueTax");
		var InsureSum = getItemValue(0,0,"InsureSum");
		var SalvageSum = getItemValue(0,0,"SalvageSum");
		if(DirectPrice==null||DirectPrice=="") DirectPrice=0;
		if(Premiums==null||Premiums=="") Premiums=0;
		if(AllocationSum==null||AllocationSum=="") AllocationSum=0;
		if(RevenueTax==null||RevenueTax=="") RevenueTax=0;
		if(InsureSum==null||InsureSum=="") InsureSum=0;
		if(SalvageSum==null||SalvageSum=="") SalvageSum=0;
		
		//计算车辆总价
		var sPara = "attribute1="+Premiums+",attribute2="+AllocationSum+",attribute3="+RevenueTax+",attribute4="+InsureSum+",attribute5="+DirectPrice+",attribute6="+SalvageSum;
		
		var Appropriation = RunJavaMethodSqlca("com.amarsoft.proj.action.JSgetDoubleSum","countAppropriation",sPara);
		
		if(Appropriation=="Null"||Appropriation=="null"||Appropriation==""){
			setItemValue(0,0,"Appropriation","");
		}else{
			setItemValue(0,0,"Appropriation",Appropriation);
		}		
	}
	
	//计算费用总计
	function countCostTotal(){
		var AssureService = getItemValue(0,0,"AssureService");//担保服务费	AssureService
    	var ProcedureFee = getItemValue(0,0,"ProcedureFee");//手续费	ProcedureFee
    	var Stampduty = getItemValue(0,0,"Stampduty");//印花税	Stampduty
    	var Premium = getItemValue(0,0,"Premium");//还款保险费	Premium
    	var Vat = getItemValue(0,0,"Vat");//VAT	Vat
    	var ResellFee = getItemValue(0,0,"ResellFee");//转售手续费	ResellFee
    	if(AssureService==null||AssureService=="") AssureService=0;
    	if(ProcedureFee==null||ProcedureFee=="") ProcedureFee=0;
    	if(Stampduty==null||Stampduty=="") Stampduty=0;
    	if(Premium==null||Premium=="") Premium=0;
    	if(Vat==null||Vat=="") Vat=0;
    	if(ResellFee==null||ResellFee=="") ResellFee=0;
    	//计算费用总计
		var sPara = "attribute1="+AssureService+",attribute2="+ProcedureFee+",attribute3="+Stampduty+",attribute4="+Premium+",attribute5="+Vat+",attribute6="+ResellFee;
		var CostTotal = RunJavaMethodSqlca("com.amarsoft.proj.action.JSgetDoubleSum","sumCarTotal",sPara);
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
	

	//计算残值金额
	function SalvageSum(){
		var DirectPrice = getItemValue(0,0,"DirectPrice");
		if(typeof(DirectPrice)=="undefined"||DirectPrice==""){
			return;
		}
		var SalvageRate = getItemValue(0,0,"SalvageRate");
		if(typeof(SalvageRate)=="undefined"||SalvageRate==""){
			return;
		}
		var sPara = "attribute1="+DirectPrice+",attribute2="+SalvageRate;
		var sReturnValues = RunJavaMethodSqlca("com.amarsoft.proj.action.JSgetDoubleSum","FinalPaymentSum",sPara);
		if(typeof(sReturnValues)=="undefined"||sReturnValues==""){
			return;
		}else{
			setItemValue(0,0,"SalvageSum",sReturnValues);
			countCarTotal();
		}
	}
	//金融产品变更时，清空车型
	function cleanCarModel(){
		setItemValue(0,0,"CarModel","");
		setItemValue(0,0,"DirectPrice","");
		countAppropriation();
		SalvageSum();
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
		/* var FinalPayment = getItemValue(0,0,"FinalPayment");
		var FinalPaymentSum = getItemValue(0,0,"FinalPaymentSum"); */
		var BuinsessSum = getItemValue(0,0,"BusinessSum");
		var CreditApr = getItemValue(0,0,"CreditApr");
		if(typeof(FinalPayment) == "undefined" || FinalPayment == "") FinalPayment = 0;
		if(typeof(FinalPaymentSum) == "undefined" || FinalPaymentSum == "") FinalPaymentSum = 0;
		if(typeof(BuinsessSum) == "undefined" || BuinsessSum == "") BuinsessSum = 0;
		if(typeof(CreditApr) == "undefined" || CreditApr == "") CreditApr = 0;
		
		/* var sPara ="typeNo="+sTypeNo+",term="+sTerm+",rate="+CreditApr+",financeAmount="+BuinsessSum+",finalPayment="+FinalPayment+",finalPaymentSum="+FinalPaymentSum; */
		var sPara ="typeNo="+sTypeNo+",term="+sTerm+",rate="+CreditApr+",financeAmount="+BuinsessSum;
		//获取产品参数的“月供计算方式”，并计算每月还款金额
		var sReurnValues = RunJavaMethodSqlca("com.amarsoft.proj.action.GetMonthPayment","getMonthPayment",sPara);
		if(typeof(sReurnValues)=="undefined"||sReurnValues=="") return;
		setItemValue(0,0,"MonthrePayment",sReurnValues);
	}
	//更新对应数值
	function beforeSave(){
 	
    	var DealerName = getItemValue(0,0,"DealerName");//经销商	DealerName
    	var Vendor = getItemValue(0,0,"Vendor");//厂商	Vendor
    	var ProductName = getItemValue(0,0,"ProductName");//金融产品名称 ProductName
    	var CreditMonth = getItemValue(0,0,"CreditMonth");//租赁期限	CreditMonth
    	var CarModel = getItemValue(0,0,"CarModel");//车辆型号	CarModel
    	var CarStatus = getItemValue(0,0,"CarStatus");//车况	CarStatus
    	var DirectPrice = getItemValue(0,0,"DirectPrice");//市场指导价	DirectPrice
    	var Premiums = getItemValue(0,0,"Premiums");//延保费	Premiums
    	var AllocationSum = getItemValue(0,0,"AllocationSum");//车辆附加配置金额	AllocationSum
    	var RevenueTax = getItemValue(0,0,"RevenueTax");//车辆购置税	RevenueTax
    	var InsureSum = getItemValue(0,0,"InsureSum");//车辆保险费	InsureSum
    	var Cashdeposit = getItemValue(0,0,"Cashdeposit");//保证金	Cashdeposit
    	var SalvageRate = getItemValue(0,0,"SalvageRate");//残值比例	SalvageRate
    	var StartRent = getItemValue(0,0,"StartRent");//首月租金	StartRent
    	var SalvageSum = getItemValue(0,0,"SalvageSum");//残值金额	SalvageSum
    	var PaymentTotal = getItemValue(0,0,"PaymentTotal");//首付合计	PaymentTotal
    	var Appropriation = getItemValue(0,0,"Appropriation");//总拨款额	Appropriation
    	var AssureService = getItemValue(0,0,"AssureService");//担保服务费	AssureService
    	var ProcedureFee = getItemValue(0,0,"ProcedureFee");//手续费	ProcedureFee
    	var Stampduty = getItemValue(0,0,"Stampduty");//印花税	Stampduty
    	var Premium = getItemValue(0,0,"Premium");//还款保险费	Premium
    	var Vat = getItemValue(0,0,"Vat");//VAT	Vat
    	var ResellFee = getItemValue(0,0,"ResellFee");//转售手续费	ResellFee
    	var CostTotal = getItemValue(0,0,"CostTotal");//费用总计	CostTotal
    	var MonthCost = getItemValue(0,0,"MonthCost");//每月费用	MonthCost
    	var MonthRent = getItemValue(0,0,"MonthRent");//月租金费用	MonthRent
    	var CreditApr = getItemValue(0,0,"CreditApr");//贷款年利率	CreditApr
    	 var MonthrePayment = getItemValue(0,0,"MonthrePayment");//月还款金额	MonthrePayment

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
	AsOne.AsInit();
	bFreeFormMultiCol=true;
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	

<%@ include file="/IncludeEnd.jsp"%>
