<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: lwang 20140220 
		Tester:
		Describe:产品参数页面
		Input Param:
			SerialNo:
		Output Param:

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "产品参数"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
    //定义变量
    String sTempletNo ="";
	//获得页面参数
	String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("typeNo"));	
	String sCurItemID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("curItemID"));	
	if(sCurItemID==null) sCurItemID="";
    if(sTypeNo==null) sTypeNo="";
    ARE.getLog().debug("sTypeNo="+sTypeNo+"&sCurItemID="+sCurItemID);
%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	if(sCurItemID.equals("02")){
		sTempletNo = "CBusinessTypeDetailsInfo1";
	}else{
		sTempletNo = "CBusinessTypeDetailsInfo";
	}
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if(sCurItemID.equals("02")){//融资租赁
		doTemp.setDefaultValue("monthcalculationMethod", "01");
		doTemp.setLimit("contractConditions", 1000);//合同特殊条款，限制为仅能输入500字。

	}else{//汽车金融
		doTemp.setLimit("contractConditions", 2000);//合同特殊条款，限制为仅能输入1000字。
		doTemp.setHTMLStyle("whetherDiscount","onChange=\"javascript:parent.checkDiscount()\"");
		doTemp.setUnit("dealerDiscount,ManufacturersRate", "%");
		//doTemp.setHTMLStyle("securityChargeMode", "onChange=\"javascript:parent.setFeeUnit()\"");	
	}
	doTemp.setHTMLStyle("PenaltyMode", "onChange=\"javascript:parent.selectPenaltyMode()\"");
	doTemp.setHTMLStyle("rateType", "onChange=\"javascript:parent.checkFloatingManner()\"");
	doTemp.setReadOnly("calculationType", true);
	//doTemp.setColumnEvent("whetherDiscount", "onChange", "javascript:parent.checkDiscount()");
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sTypeNo);
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
		if(vI_all("myiframe0")){
			insertTerm();
			bIsInsert = false;
			if(!checkDiscountRate())	return;
			
			as_save("myiframe0");
		   
		}
		
	}
	function checkFloatingManner(){//检查浮动方式
		var sRateType = getItemValue(0,0,"rateType");//利率类型
		var sComponentName="<%=sCurItemID%>";
		//var sFloatingManner = getItemValue(0,0,"floatingManner");//浮动方式
		if(sRateType=="1"){
			setItemRequired(0,0,"floatingManner",true);
		}	
		if(sRateType=="0"){
			setItemDisabled(0,0,"floatingManner",true);
		}
		if(sComponentName=="01"){
			if(sRateType=="2"){
				setItemRequired(0,0,"dealerLiXiTime",true);
			}
		}
		
	}
	function checkDiscount(){
		var sDiscount = getItemValue(0,0,"whetherDiscount");
		
		if("1"==sDiscount){
			setItemValue(0,0,"discountType", "0");
			setItemRequired(0,0,"discountType",true);
			setItemRequired(0,0,"dealerDiscount",true);
			setItemRequired(0,0,"ManufacturersRate",true);
		}else if("0"==sDiscount){
			setItemValue(0,0,"discountType", "");
			setItemValue(0,0,"dealerDiscount", "");
			setItemValue(0,0,"ManufacturersRate", "");
			setItemDisabled(0,0,"discountType",true);
			setItemReadOnly(0,0,"dealerDiscount",true);
			setItemReadOnly(0,0,"ManufacturersRate",true);	
		}
	}
	function checkDiscountRate(){
		var whetherDiscount = getItemValue(0,0,"whetherDiscount");
		if(whetherDiscount=="1"){
			var dealerDiscount = getItemValue(0,0,"dealerDiscount");//经销商贴现比例
			if(typeof(dealerDiscount)=="undefined"||dealerDiscount==""){
				dealerDiscount = 0;
			}
			
			var ManufacturersRate = getItemValue(0,0,"ManufacturersRate");//厂商贴现比例
			if(typeof(ManufacturersRate)=="undefined"||ManufacturersRate==""){
				ManufacturersRate = 0;
			}
			var sPara = "attribute1="+dealerDiscount+",attribute2="+ManufacturersRate;
			var sRateSum = RunJavaMethodSqlca("com.amarsoft.proj.action.JSgetDoubleSum","getDiscountRateSum",sPara);
			if(sRateSum=="false"||sRateSum=="Null"||sRateSum=="null"||sRateSum==""){
				alert("经销商贴现比例与厂商贴现比例之和必须为100，请重新输入");
				return false;
			}else{
				return true;
			}
		}else{
			return true;
		}
		
	}
	function  setFeeUnit(){//设置单位
		var securityChargeMode = getItemValue(0,0,"securityChargeMode");
		if("0"==securityChargeMode){//0 按比例  1 按金额
			//setItemUnit(0,0,"securityServices","%");		
		alert(1);
		setItemUnit("CBusinessTypeDetailsInfo",0300,"securityServices","%");

		}
	
		/* feeWay  fee
		stampMethods   stampTax
		mepaymentChargeMode  repaymentInsurance */
	}
	function setItemUnit(dwname,rowindex,fieldName,unit){
		if(!isNaN(dwname))dwname = "myiframe" + dwname;
		var dwindex = dwname.substring(8);
		var sColIndex = getColIndexFromName(fieldName);
		var oSpanInput = document.getElementById("Unit_" + sColIndex);
		oSpanInput.innerHTML = unit;
	}

	//选择提前还款罚金收取方式
	function selectPenaltyMode(){
		var sPenaltyMode  =getItemValue(0,0,"PenaltyMode");//提前还款罚金收取方式

		if(sPenaltyMode=="0"){//按比例
			setItemRequired(0,0,"penaltyProportion",true);//提前还款罚金比例
			setItemRequired(0,0,"penaltyAmount",false);//提前还款罚金金额
			setItemReadOnly(0,0,"penaltyAmount",true);//提前还款罚金金额
		}else if(sPenaltyMode=="1"){//按金额
			setItemRequired(0,0,"penaltyAmount",true);//提前还款罚金金额
			setItemRequired(0,0,"penaltyProportion",false);//提前还款罚金比例
			setItemReadOnly(0,0,"penaltyProportion",true);//提前还款罚金比例
		}else{
			setItemRequired(0,0,"penaltyProportion",false);//提前还款罚金比例
			setItemRequired(0,0,"penaltyAmount",false);//提前还款罚金金额
		}
	}
	
	//插入组件参数
	function insertTerm(){
		var sObjectNo = "<%=sTypeNo%>"+"-V1.0";
		var sComponentName="<%=sCurItemID%>";
		var RPTTerm = getItemValue(0, 0, "monthcalculationMethod");//月供计算方式
		var ratType = getItemValue(0, 0, "rateType");//利率类型
		var SPTTerm = getItemValue(0, 0, "discountType");//贴息类型
		var FINRate = getItemValue(0, 0, "principalPenaltyBasis");//罚息基础利率
		var FINTerm = getItemValue(0, 0, "penaltyRate");//罚息类型
		var FINFloat = getItemValue(0, 0, "floatingRate");//罚息浮动比例/浮动点
		var sChargeTime = getItemValue(0, 0, "chargeTime");//费用首付时点
		var securityChargeMode = getItemValue(0, 0, "securityChargeMode");//担保服务费收取方式
		var securityServices = getItemValue(0, 0, "securityServices");//担保服务费
		var feeWay = getItemValue(0, 0, "feeWay");//手续费收取方式
		var fee = getItemValue(0, 0, "fee");//手续费
		var mepaymentChargeMode = getItemValue(0, 0, "mepaymentChargeMode");//还款保险费收取方式
		var repaymentInsurance = getItemValue(0, 0, "repaymentInsurance");//还款保险费
		var PenaltyMode = getItemValue(0, 0, "PenaltyMode");//提前还款罚金收取方式
		var penaltyProportion = getItemValue(0, 0, "penaltyProportion");//提前还款罚金比例
		var penaltyAmount = getItemValue(0, 0, "penaltyAmount");//提前还款罚金金额
		
		//贴息类型
		if(typeof(SPTTerm) != "undefined" || SPTTerm != ""){
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,"+SPTTerm);
		}
		
		//利率类型
		var RATTerm = "";
		if(ratType=="0"){//固定利率
			 RATTerm = "RAT002";
		}else if(ratType=="1"){//浮动利率
			 RATTerm = "RAT001";
		}else if(ratType=="2"){//固定灵活
			 RATTerm = "RAT004";
		}
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,"+RATTerm);
		if(RATTerm=="RAT001"){//浮动
			var sFloatType = getItemValue(0, 0, "floatingManner");//浮动方式
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+sFloatType+",PRODUCT_TERM_PARA,String@paraid@RateFloatType@String@termid@RAT001@String@ObjectNo@"+sObjectNo);//浮动方式
		}
		
		//月供计算方式
		if(sComponentName=="02"){//融资租赁
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,RPT18");//先付等额本息
		}else{//汽车金融
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,"+RPTTerm);
		}
		
		//罚息
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,FIN003");
		RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+FINRate+",PRODUCT_TERM_PARA,String@paraid@BaseRate@String@termid@FIN003@String@ObjectNo@"+sObjectNo);//罚息基准利率
		if(FINTerm=="0"){//按比例浮动
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@0,PRODUCT_TERM_PARA,String@paraid@RateFloatType@String@termid@FIN003@String@ObjectNo@"+sObjectNo);//按比例浮动
		}else if(FINTerm=="1"){
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@1,PRODUCT_TERM_PARA,String@paraid@RateFloatType@String@termid@FIN003@String@ObjectNo@"+sObjectNo);//按比例浮动点
		}
		
		/*~~~~~~~~~~~~~~~~~ 费用 ~~~~~~~~~~~~*/
		//提前还款违约金
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,A200");
		if(PenaltyMode=="0"){//按比例
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@03,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@A200@String@ObjectNo@"+sObjectNo);//计算方式(本金余额*费率)
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+penaltyProportion+",PRODUCT_TERM_PARA,String@paraid@FeeRate@String@termid@A200@String@ObjectNo@"+sObjectNo);//罚金比例
		}else if(PenaltyMode=="1"){//按固定金额
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@01,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@A200@String@ObjectNo@"+sObjectNo);//计算方式固定金额
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+penaltyAmount+",PRODUCT_TERM_PARA,String@paraid@FeeAmount@String@termid@A200@String@ObjectNo@"+sObjectNo);//罚金金额
		}
		
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,N300");//担保服务费
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,N400");//手续费
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,C300");//印花税
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,N500");//还款保险费
		//RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,YB100");//延保费
		//RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,QT100");//其他费
		RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+sChargeTime+",PRODUCT_TERM_PARA,String@paraid@FeePayDateFlag@String@termid@N300@String@ObjectNo@"+sObjectNo);//担保服务费收付时点
		RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+sChargeTime+",PRODUCT_TERM_PARA,String@paraid@FeePayDateFlag@String@termid@N400@String@ObjectNo@"+sObjectNo);//手续费收付时点
		RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+sChargeTime+",PRODUCT_TERM_PARA,String@paraid@FeePayDateFlag@String@termid@C500@String@ObjectNo@"+sObjectNo);//印花税收付时点
		RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+sChargeTime+",PRODUCT_TERM_PARA,String@paraid@FeePayDateFlag@String@termid@N500@String@ObjectNo@"+sObjectNo);//还款保险费收付时点

		if(securityChargeMode=="0"){//按比例收
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@03,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@N300@String@ObjectNo@"+sObjectNo);//计算方式
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+securityServices+",PRODUCT_TERM_PARA,String@paraid@FeeRate@String@termid@N300@String@ObjectNo@"+sObjectNo);//费率
		}else if(securityChargeMode=="1"){//按固定金额
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@01,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@N300@String@ObjectNo@"+sObjectNo);//计算方式
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+securityServices+",PRODUCT_TERM_PARA,String@paraid@FeeAmount@String@termid@N300@String@ObjectNo@"+sObjectNo);//费用金额
		}
		
		if(feeWay=="0"){//按比例收
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@03,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@N400@String@ObjectNo@"+sObjectNo);//计算方式
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+fee+",PRODUCT_TERM_PARA,String@paraid@FeeRate@String@termid@N400@String@ObjectNo@"+sObjectNo);//费率
		}else if(feeWay=="1"){//按固定金额
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@01,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@N400@String@ObjectNo@"+sObjectNo);//计算方式
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+fee+",PRODUCT_TERM_PARA,String@paraid@FeeAmount@String@termid@N400@String@ObjectNo@"+sObjectNo);//费用金额
		}
		
		if(mepaymentChargeMode=="0"){//按比例收
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@03,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@N500@String@ObjectNo@"+sObjectNo);//计算方式
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+repaymentInsurance+",PRODUCT_TERM_PARA,String@paraid@FeeRate@String@termid@N400@String@ObjectNo@"+sObjectNo);//计算方式
		}else if(mepaymentChargeMode=="1"){//按固定金额
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@01,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@N400@String@ObjectNo@"+sObjectNo);//计算方式
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+repaymentInsurance+",PRODUCT_TERM_PARA,String@paraid@FeeAmount@String@termid@N500@String@ObjectNo@"+sObjectNo);//计算方式
		}
		
		/* ····融资租赁：转售手续费、残值附加税[VAT]······ */
		if(sComponentName=="02"){
			var salvageAddedMode = getItemValue(0, 0, "salvageAddedMode");//残值附加税收取方式
			var salvageAdded = getItemValue(0, 0, "salvageAdded");//残值附加税【VAT】金额/比例
			var resaleFeePayDate = getItemValue(0, 0, "resaleFeePayDate");//转售手续费收取时间
			var resaleFeesWay = getItemValue(0, 0, "resaleFeesWay");//转售手续费收取方式
			var resaleFees = getItemValue(0, 0, "resaleFees");//转售手续费
			
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,R100");//转售手续费
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,R200");//残值附加税[VAT]
			
			if(salvageAddedMode=="0"){//按比例收
				RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@03,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@N500@String@ObjectNo@"+sObjectNo);//计算方式
				RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+salvageAdded+",PRODUCT_TERM_PARA,String@paraid@FeeRate@String@termid@N400@String@ObjectNo@"+sObjectNo);//计算方式
			}else if(salvageAddedMode=="1"){//按固定金额
				RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@01,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@N400@String@ObjectNo@"+sObjectNo);//计算方式
				RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+salvageAdded+",PRODUCT_TERM_PARA,String@paraid@FeeAmount@String@termid@N500@String@ObjectNo@"+sObjectNo);//计算方式
			}
			
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+resaleFeePayDate+",PRODUCT_TERM_PARA,String@paraid@FeePayDateFlag@String@termid@N500@String@ObjectNo@"+sObjectNo);//还款保险费收付时点

			if(resaleFeesWay=="0"){//按比例收
				RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@03,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@N500@String@ObjectNo@"+sObjectNo);//计算方式
				RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+resaleFees+",PRODUCT_TERM_PARA,String@paraid@FeeRate@String@termid@N400@String@ObjectNo@"+sObjectNo);//计算方式
			}else if(resaleFeesWay=="1"){//按固定金额
				RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@01,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@N400@String@ObjectNo@"+sObjectNo);//计算方式
				RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+resaleFees+",PRODUCT_TERM_PARA,String@paraid@FeeAmount@String@termid@N500@String@ObjectNo@"+sObjectNo);//金额
			}
			
		}
		
		//关联交易
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,TRA001");//发放类交易
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,TRA002");//还款日变更
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,TRA004");//提前还款
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,TRA005");//还款类交易
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,PS001");//其他未归类参数定义
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
		var sComponentName="<%=sCurItemID%>";
		if(sComponentName=="01"){
			setItemValue(0,0,"calculationType", "1");
		}else{
			setItemValue(0,0,"calculationType", "0");
			setItemValue(0,0,"monthcalculationMethod","01");
			setItemValue(0,0,"dealerLiXiTime", "1");
		}
		setItemValue(0,0,"dealerPaymentTime", "1");
		
		setItemValue(0,0,"inputOrg", "<%=CurOrg.getOrgName()%>");
		setItemValue(0,0,"inputUser", "<%=CurUser.getUserName()%>");
		setItemValue(0,0,"inputTime", "<%=StringFunction.getToday()%>");
		setItemValue(0,0,"updateOrg", "<%=CurOrg.getOrgName()%>");
		setItemValue(0,0,"updateUser", "<%=CurUser.getUserName()%>");
		setItemValue(0,0,"updateTime", "<%=StringFunction.getToday()%>");
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
