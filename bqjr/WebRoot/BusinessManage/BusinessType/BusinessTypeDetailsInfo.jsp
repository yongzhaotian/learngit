<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: lwang 20140220 
		Tester:
		Describe:产品的基本信息
		Input Param:
			SerialNo:
		Output Param:

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "产品的基本信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	
	//获得页面参数
	String sTypeNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("typeNo"));	
	String sTemp    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("temp"));	
	//产品类型
	String sProductType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProductType"));
	String sSubProductType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SubProductType"));
	if(null == sProductType) sProductType = "";
	String sSerialNo = sTypeNo;
	if(sTemp==null) sTemp="";
	if(null == sSubProductType) sSubProductType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo =null;
	sTempletNo = "BusinessTypeDetailsInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if(sTemp.equals("1")){
        doTemp.setReadOnly("", true);
	}
	
	//add 现金贷需求
	doTemp.setReadOnly("productType",true);
	if("020".equals(sProductType)){ 
		doTemp.setVisible("productCategoryID,shoufuRatioType,shoufuRatio",false);
		doTemp.setVisible("MONTHADDSERVICERATE",true);
		doTemp.setRequired("productCategoryID,shoufuRatioType,shoufuRatio",false);
		doTemp.setVisible("Attribute4",true);//封顶奖金
		doTemp.setRequired("Attribute4",true);
		
	}
	//根据产品类型不同选择不同的产品子类型
	if(sProductType.equals("020")){//现金贷
		doTemp.setDDDWSql("SubProductType", "select itemno , itemname from code_library where codeno='SubProductType' and itemno in ('1','2','3')");
	}else if( sProductType.equals("030") && "".equals(sSubProductType) ){//消费贷
		doTemp.setDDDWSql("SubProductType", "select itemno , itemname from code_library where codeno='SubProductType' and itemno in ('0','4','5')");
	}else if( sProductType.equals("030") && "7".equals(sSubProductType) ){//学生消费贷
		doTemp.setReadOnly("SubProductType", true);
		doTemp.setDDDWSql("SubProductType", "select itemno , itemname from code_library where codeno='SubProductType' and itemno = '7' ");
	}
	doTemp.setHTMLStyle("SalesFormula", "onChange=\"javascript:parent.selectSalesFormula()\";style={background=\"#EEEEff\"}");
	doTemp.setCheckFormat("monthlyInterestRate,EFFECTIVEANNUALRATE,baseRate,CUSTOMERSERVICERATES,MANAGEMENTFEESRATE", "13");
	doTemp.setCheckFormat("lowPrincipal,tallPrincipal,shoufuRatio", "5");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	doTemp.setLimit("EFFECTIVEANNUALRATE",6);
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
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
		{"true","","Button","保存","保存","saveRecord()",sResourcesPath},
	};
	if(sTemp.equals("1")){
		sButtons[0][3]="返回";
		sButtons[0][4]="返回";
		sButtons[0][5]="back()";
	}
	%> 
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		selectRateFormula();
		var sTypeNo  = getItemValue(0,getRow(),"TypeNo");
		var sUnique = RunMethod("Unique","uniques","business_type,count(1),typeNo='"+sTypeNo+"'");
		if(bIsInsert && sUnique=="1.0"){
			alert("该产品编号已经被占用,请输入新的编号");
			return;
		}
		updateTerm();//插入组件参数
		bIsInsert = false;
	    as_save("myiframe0");
	    selectSalesFormula();
	    selectShoufuType();
	}
	
	/*~[Describe=弹出多选框选择商品范畴;InputParam=无;OutPutParam=无;]~*/
	function selectProductCategoryMulti() {
		var sRetVal = setObjectValue("SelectProductCategoryMulti", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("请选择商品范畴！");
			return;
		}
		var sTypeArry = sRetVal.substring(0, sRetVal.length-1).split("@");
		var sCTypeIds = "";
		var SCTypeNames = "";
		for (var i=0;i<sTypeArry.length;i=i+2) {
			sCTypeIds += sTypeArry[i] + ",";
			SCTypeNames += sTypeArry[i+1] + ",";
		}
		setItemValue(0, 0, "productCategory", sCTypeIds.substring(0, sCTypeIds.length-1));  //商品范畴ID
		setItemValue(0, 0, "productCategoryID", SCTypeNames.substring(0, SCTypeNames.length-1));//商品范畴名称
		return;
	}
	
   function checkTypeNo(sTypeNo){
    	var sTypeNo =getItemValue(0,getRow(),"TypeNo");
    	 var strExp=/^[A-Za-z0-9]+$/;
		 if(strExp.test(sTypeNo)){
		    return true;
		}else{
			alert("产品代码必须是数字或字母！");
		    return false;
		}
    }
	
	//插入组件参数
	function updateTerm(){
		var sterm  = getItemValue(0,getRow(),"term");
		var sTypeNo  = getItemValue(0,getRow(),"TypeNo");
		var sObjectNo = sTypeNo+"-V1.0";//关联产品对象编号
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,RPT17");//等额本息
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,RAT002");//固定利率
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,N100");//账户管理费
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,N200");//客户服务费
		
		//利率
		var baseRate = getItemValue(0,getRow(),"baseRate");//产品执行年利率默认%
		var ratereturn = RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+baseRate+",PRODUCT_TERM_PARA,String@paraid@ExecuteRate@String@termid@RAT002@String@ObjectNo@"+sObjectNo);//产品月利率
		
		//设置佣金参数
		var sSalesFormula = getItemValue(0,getRow(),"SalesFormula");//佣金计算方式
		if(sSalesFormula=="01"){//按比例
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,YJ100");//佣金
			var SALESCOMMISSION = getItemValue(0,getRow(),"SALESCOMMISSION");//比例 % 
			if(typeof(SALESCOMMISSION)=="undefined" || SALESCOMMISSION.length==0 || SALESCOMMISSION=="_CANCEL_" ) {
				alert("请输入提成比例！");
				return;
			}
			//计算方式
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@02,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@YJ100@String@ObjectNo@"+sObjectNo);//计算方式(贷款金额*费率)
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+SALESCOMMISSION+",PRODUCT_TERM_PARA,String@paraid@FeeRate@String@termid@YJ100@String@ObjectNo@"+sObjectNo);//佣金费率
		}else if(sSalesFormula=="02"){//按金额 元
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,YJ100");//佣金
			var TCPrice = getItemValue(0,getRow(),"TCPrice");//金额 元
			if(typeof(TCPrice)=="undefined" || TCPrice.length==0 || TCPrice=="_CANCEL_" ) {
				alert("请输入提成金额！");
				return;
			}
			//计算方式
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@01,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@YJ100@String@ObjectNo@"+sObjectNo);//计算方式(固定金额)
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+TCPrice+",PRODUCT_TERM_PARA,String@paraid@FeeAmount@String@termid@YJ100@String@ObjectNo@"+sObjectNo);//佣金金额
		}
	
		//关联交易
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,TRA001");//发放类交易
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,TRA002");//还款日变更
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,TRA004");//提前还款
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,TRA005");//还款类交易
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,PS001");//其他未归类参数定义
		
		//设置费率
		var sManageRate = getItemValue(0,getRow(),"MANAGEMENTFEESRATE");//月账户管理费率
		var termsManageRate = parseFloat(sManageRate)*parseInt(sterm, 10);//全程账户管理费费率
		var sCustomRate = getItemValue(0,getRow(),"CUSTOMERSERVICERATES");//客户服务费率
		var termsCustomRate = parseFloat(sCustomRate)*parseInt(sterm, 10);//全程客户服务费率
		
		if(typeof(sManageRate)=="undefined" || sManageRate=="" || sManageRate=="_CANCEL_" || typeof(sCustomRate)=="undefined" || sCustomRate=="" || sCustomRate=="_CANCEL_") {
			alert("请确保账户管理费率和财务服务费率值得有效！！！");
			
			//费率为零去除产品关联
			if(parseFloat(sManageRate)<=0.0){
				RunMethod("ProductManage","UpdateProductTerm","deleteTermFromProduct,<%=sTypeNo%>,V1.0,N100");
			}
			if(parseFloat(sCustomRate)<=0.0){
				RunMethod("ProductManage","UpdateProductTerm","deleteTermFromProduct,<%=sTypeNo%>,V1.0,N200");
			}
			return;
		}
		RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+termsManageRate+",PRODUCT_TERM_PARA,String@paraid@FeeRate@String@termid@N100@String@ObjectNo@"+sObjectNo);//账户管理费率
		RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+termsCustomRate+",PRODUCT_TERM_PARA,String@paraid@FeeRate@String@termid@N200@String@ObjectNo@"+sObjectNo);//客户服务费率
	}
	
	function back(){
		AsControl.OpenView("/BusinessManage/Products/ProductTypesDetailsInfo1.jsp","","_self");
	}
	
	/*~[Describe=有效年利率EIP;InputParam=无;OutPutParam=无;]~*/
	function selectRateFormula() {
		var rateFormula  = getItemValue(0,getRow(),"rateFormula");//利率计算方式1:有效年利率 2：月供比例
		
			setItemDisabled(0,getRow(),"EFFECTIVEANNUALRATE",false);//有效年利率EIP
			setItemDisabled(0,getRow(),"MONTHLYPROPORTION",true);//月供比例
			
			var baseRate_  = getItemValue(0,getRow(),"baseRate");//产品基准利率
			var baseRate = parseFloat(baseRate_);
			
			if(isNaN(baseRate)){
				baseRate = 0.000;
			}
			var nMonthRate = baseRate/12;			//产品月利率
			var term_  = getItemValue(0,getRow(),"term");//期限
			var nLoanTerm = parseInt(term_, 10);
			
			setItemValue(0, 0, "monthlyInterestRate", nMonthRate);  //产品月利率
			
			if(typeof(term_)=="undefined" || term_.length==0||typeof(baseRate)=="undefined" || baseRate.length==0 || baseRate=="_CANCEL_" ){
				alert("请先填写基准利率和期限！");
				return;
			}
			
			if(nMonthRate<=0.0){
				MonthRatio2 = 1/nLoanTerm;
			}else{
				//产品月利率得出的月供2
				var MonthRatio2 = ((nMonthRate/100)*(Math.pow((1+nMonthRate/100),nLoanTerm)))/(Math.pow((1+nMonthRate/100),nLoanTerm)-1);
			}
			
			//eip利率得出的月供比例1
			var baseRateEIP  = getItemValue(0,getRow(),"EFFECTIVEANNUALRATE");//有效年利率EIP
			var nMonthRateEIP = parseFloat(baseRateEIP)/12;					//EIP月利率
			
			if(typeof(baseRateEIP)=="undefined" || baseRateEIP.length==0){
				alert("先填有效EIR年利率！");
				return;
			}
			if(nMonthRateEIP<nMonthRate ){
				alert("有效EIR年利率不能小于基本利率！");
				setItemValue(0, 0, "EFFECTIVEANNUALRATE", ""); 
				return;
			}
			
			var MonthRatio1 = ((nMonthRateEIP/100)*(Math.pow((1+nMonthRateEIP/100),nLoanTerm)))/(Math.pow((1+nMonthRateEIP/100),nLoanTerm)-1);
			var MANAGEMENTFEES  = getItemValue(0,getRow(),"MANAGEMENTFEES");//月账户管理费占比
			
			var manageMentFeeRate = (parseFloat(MonthRatio1)-parseFloat(MonthRatio2))*parseFloat(MANAGEMENTFEES);//月账户管理费率
			var CUSTOMERSERVICERATES = (parseFloat(MonthRatio1)-parseFloat(MonthRatio2))*(1-parseFloat(MANAGEMENTFEES)*0.01)*100;//月账客户服务费费率
			
			if(parseFloat(MANAGEMENTFEES)=="100.0"){
				manageMentFeeRate = 0.00;
				alert("月账户管理费占比为100时月财务管理费费率为0,请确认是否如此设置！");
			}
			if(nMonthRateEIP==nMonthRate){
				manageMentFeeRate = 0.00;
				CUSTOMERSERVICERATES = 0.00;
				alert("有效EIR年利率等于基本利率时,月财务管理费费率,月账户管理费费率为0,请确认是否如此设置！");
			}
			if(typeof(MANAGEMENTFEES)=="undefined" || MANAGEMENTFEES.length==0){
				alert("先填写月账户管理费占比！");
				return;
			}
			
			setItemValue(0, 0, "MANAGEMENTFEESRATE", manageMentFeeRate.toFixed(3));  //月户管理费率
			setItemValue(0, 0, "CUSTOMERSERVICERATES", CUSTOMERSERVICERATES.toFixed(3));  //月账客户服务费费率
			
			var shoufuType = getItemValue(0, 0, "shoufuRatioType");
			var shoufu = getItemValue(0, 0, "shoufuRatio");
			if(shoufuType == "1" || shoufuType == "2"){
				if(shoufu > 100){
					alert("首付比例(%)不能大于100，请检查！");
					setItemValue(0, 0, "shoufuRatio", ""); 
					return;
				}
			}
		
	}
	
	function selectSalesFormula(){
		var sSalesFormula=getItemValue(0,getRow(),"SalesFormula");
		if(typeof(sSalesFormula)=="undefined" || sSalesFormula.length==0){
			hideItem(0, 0, "TCPrice");
		}
		if(sSalesFormula=="01"){
			hideItem(0, 0, "TCPrice");
			showItem(0, 0, "SALESCOMMISSION");
		}
		if(sSalesFormula=="02"){
			hideItem(0, 0, "SALESCOMMISSION");
			showItem(0, 0, "TCPrice");
		}
	}
    
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录	
			bIsInsert = true;
		}
		selectSalesFormula();
		selectShoufuType();
		setItemValue(0, 0, "inputOrgName", "<%=CurOrg.orgName %>");
		setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID %>");
		setItemValue(0,0,"INPUTUSER", "<%=CurUser.getUserName()%>");
		setItemValue(0,0,"INPUTTIME", "<%=StringFunction.getToday()%>");
		setItemValue(0, 0, "updateOrgName", "<%=CurOrg.orgName %>");
		setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID %>");
		setItemValue(0,0,"UPDATEUSER", "<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UPDATETIME", "<%=StringFunction.getToday()%>");
	}
	
	function selectShoufuType() {
		
		var shoufuType = getItemValue(0, 0, "shoufuRatioType");
		//setItemValue(0, 0, "shoufuRatio", "");
		if (shoufuType == 3 || shoufuType == 4) {
			setItemHeader(0, 0, "shoufuRatio", "首付金额（元）");
		} else {
			setItemHeader(0, 0, "shoufuRatio", "首付比例（%）（按商品价格）");
		}
	}
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
$(document).ready(function(){
	AsOne.AsInit();
	showFilterArea();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();
});
	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
