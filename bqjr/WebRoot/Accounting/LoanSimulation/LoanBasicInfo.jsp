<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.accounting.config.loader.ProductConfig"%>
<%@ page import="com.amarsoft.app.accounting.web.*"%>
<%@ page import="com.amarsoft.app.accounting.product.*"%>
<%@ page import="com.amarsoft.app.accounting.businessobject.*"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  	--ygwang	2010.03
		Tester:
		Content: 贷款概要信息
		Input Param:
			productID： 产品编号
			productVersion：产品版本
		Output param:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "贷款咨询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	BusinessObject simulationObject = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	if(simulationObject==null) simulationObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessPutOut");

	//贷款比较所需条件
	String simulationSchemeCount=(String)session.getValue("SimulationSchemeCount");
	if(simulationSchemeCount==null){
		session.putValue("SimulationSchemeCount","1");
		simulationSchemeCount="1";
	}
	
	String productID =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProductID")));
	String productVersion =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProductVersion")));
	if(productID==null)productID="";
	if(productVersion==null)productVersion="";
	%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得页面参数
	ProductManage productManage = new ProductManage(Sqlca);
	if(productID!=null&&productID.length()>0&&(productVersion==null||productVersion.length()==0)){
		productVersion=ProductConfig.getProductNewestVersionID(productID);
	}
	
	if((!productID.equals(simulationObject.getString("BusinessType"))||!productVersion.equals(simulationObject.getString("ProductVersion")))
			&&productID!=null&&productID.length()>0){
		simulationObject.setAttributeValue("BusinessType",productID);
		simulationObject.setAttributeValue("ProductID",productID);
		simulationObject.setAttributeValue("ProductVersion",productVersion);
		simulationObject.setAttributeValue("ProductName",ProductConfig.getProductName(productID));
		simulationObject.setAttributeValue("BusinessTypeName",ProductConfig.getProductName(productID));
		productManage.createTermObject(simulationObject);
	}
	if(productID==null||productID.length()==0){
		productID=simulationObject.getString("BusinessType");
		productVersion = simulationObject.getString("ProductVersion");
	}
	if(productID!=null&&productID.length()>0){
		productManage.initBusinessObject(simulationObject);
	}
	String rightType="";
	if(simulationObject!=null&&BUSINESSOBJECT_CONSTATNTS.loan.equals(simulationObject.getObjectType()))
		rightType="ReadOnly";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String displayTempletFilter="BusinessPutout";
	if(simulationObject!=null){
		if(BUSINESSOBJECT_CONSTATNTS.loan.equals(simulationObject.getObjectType()))
			displayTempletFilter="Loan";
	}
	String displayTemplet = "LoanSimulationBasicInfo";
	ASDataObject doTemp = new ASDataObject(displayTemplet,"(colAttribute is null or colAttribute like '%"+displayTempletFilter+"%')",Sqlca);
	//生成DataWindow对象
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="2";
	//设置是否只读 1:只读 0:可写
	if(rightType!=null&&rightType.equals("ReadOnly")){
		dwTemp.ReadOnly = "1";
	}
	else dwTemp.ReadOnly = "0";
	
	//扩张datawindow功能
	ASValuePool valuePool=new ASValuePool();
	valuePool.setAttribute("ProductID", productID);
	valuePool.setAttribute("ProductVersion", productVersion);
	DWExtendedFunctions.exinitASDataObject(dwTemp, CurPage, valuePool, Sqlca,CurUser);
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
			{"true","","Button","保存","保存记录","saveBusinessObjectToSession(\'"+simulationObject.getObjectType()+"\')",sResourcesPath},
	};
	if(rightType!=null&&rightType.equals("ReadOnly")){
		sButtons[0][0]="false";
	}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	// 选择业务品种
	function selectBusinessType(){
		var sReturn = setObjectValue("SelectLoanType","","@BusinessType@0@BusinessTypeName@1",0,0,"");
		if(typeof(sReturn) == "undefined" || sReturn == "_CANCEL_" || sReturn == "_NONE_" || sReturn == "_CLEAR_" ) return;
		var productID = sReturn.split("@")[0];

		OpenComp("LoanTitleInfo","/Accounting/LoanSimulation/LoanBasicInfo.jsp","ProductID="+productID+"&ProductVersion=","_self");
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0){ //如果没有找到对应记录，则新增一条，并设置字段默认值
			as_add("myiframe0");//新增记录
		}
    }
	
	function afterLoad()
	{
		calcLoanRateTermID("LoanSimulation");
		calcRPTTermID("LoanSimulation");
		viewTermList("LoanSimulation","FIN","FINPart");
		viewTermList("LoanSimulation","SPT","SPTPart");
		viewTermList("LoanSimulation","FEE","FEEPart");
	}
	function checkSave(){
		var businessType= getItemValue(0,getRow(),"BusinessType");
		var currency= getItemValue(0,getRow(),"BusinessCurrency");
		var putOutDate= getItemValue(0,getRow(),"PutOutDate");
		var maturityDate= getItemValue(0,getRow(),"Maturity");
		var businessSum= getItemValue(0,getRow(),"BusinessSum");
		var repriceType= getItemValue(0,getRow(),"RepriceType");
		var loanRateTermID= getItemValue(0,getRow(),"LoanRateTermID");
		var rptTermID= getItemValue(0,getRow(),"RPTTermID");
		var termMonth= getItemValue(0,getRow(),"TermMonth");
		//赋值出账日期
		parent.putOutDate=putOutDate;
		if(typeof(businessType) == "undefined"||businessType==null||businessType.length==0){
			alert("业务品种必输!");
			return 1;
		}
		if(typeof(currency) == "undefined"||currency==null||currency.length==0){
			alert("币种必输!");
			return 1;
		}		
		if(typeof(putOutDate) == "undefined"||putOutDate==null||putOutDate.length==0){
			alert("放款日必输!");
			return 1;
		}
		if(typeof(businessSum) == "undefined"||businessSum==null||businessSum<=0){
			alert("放款金额必输!");
			return 1;
		}
		if(typeof(maturityDate) == "undefined"||maturityDate==null||maturityDate.length==0){
			alert("到期日必输!");
			return 1;
		}		
		if(typeof(loanRateTermID) == "undefined"||loanRateTermID==null||loanRateTermID.length==0){
			alert("利率类型必输!");
			return 1;
		}
		if(typeof(rptTermID) == "undefined"||rptTermID==null||rptTermID.length==0){
			alert("还款方式方式必输!");
			return 1;
		}
		if(typeof(termMonth) == "undefined"||rptTermID==null||rptTermID.length==0){
			alert("还款方式方式必输!");
			return 1;
		}
	}
	
</script>
<%/*~END~*/%>

<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/LoanSimulation/js/basicinfo.js"> </script>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/common.js"> </script>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/LoanSimulation/js/businessobject.js"> </script>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>
	<%=DWExtendedFunctions.setDataWindowValues(simulationObject,simulationObject, dwTemp,Sqlca) %>
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	bCheckBeforeUnload=false;
	my_load(2,0,'myiframe0');
	afterLoad();
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>