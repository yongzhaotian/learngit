<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   tbzeng 2014/03/30
		Tester:
		Content: 创建授信额度申请
		Input Param:
			ObjectType：对象类型
			ApplyType：申请类型
			PhaseType：阶段类型
			FlowNo：流程号
			PhaseNo：阶段号		
		Output param:
		History Log: 
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
	if(sObjectType == null) sObjectType = "RetailStoreApply";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "RetailStoreApplyFlow";
	if(sPhaseNo == null) sPhaseNo = "0010";
	
		
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "RetailStoreApplyInfo";
	
	//根据模板编号设置数据对象	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//设置必输背景色
	//doTemp.setHTMLStyle("CustomerType","style={background=\"#EEEEff\"} ");
	//当客户类型发生改变时，系统自动清空已录入的信息
	//doTemp.appendHTMLStyle("CustomerType"," onClick=\"javascript:parent.clearData()\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//设置保存时操作关联数据表的动作
	dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+",#SERIALNO,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.getUserID()+","+CurOrg.orgID+")");
	
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
	
	function getPassedReatil() {
		var sRetVal = setObjectValue("SelectPermitRetailSingle", "", "", 0, 0);
		
		if (typeof(sRetVal)=='undefined'||sRetVal=='_CLEAR_') {
			alert("请选择零售商！");
			return;
		}
		
		setItemValue(0, 0, "RSERIALNO", sRetVal.split("@")[0]);
		setItemValue(0, 0, "RNO", sRetVal.split("@")[1]);
		setItemValue(0, 0, "RNAME", sRetVal.split("@")[2]);
		setItemValue(0, 0, "RNAME1", sRetVal.split("@")[2]);
		setItemValue(0, 0, "RSSerialNo", sRetVal.split("@")[3]);
		
		
	}

	/*~[Describe=设置字段可见性;InputParam=后续事件;OutPutParam=无;]~*/
	function setRetialStoreField() {
		var sPermitType = getItemValue(0, 0, "PERMITTYPE");
		// ObjectNo,RetailName,OrgCode
		if (sPermitType=="01") {
			hideItem(0, 0, "RNO");
			hideItem(0, 0, "RNAME1");
			showItem(0, 0, "RNAME");
			showItem(0, 0, "REGCODE");
			
			setItemValue(0, 0, "RNAME", "");
			setItemValue(0, 0, "REGCODE", "");
			
			setItemRequired(0, 0, "RNO", false);
			setItemRequired(0, 0, "RNAME1", false);
			setItemRequired(0, 0, "RNAME", true);
			setItemRequired(0, 0, "REGCODE", true);
			setItemRequired(0, 0, "RSERIALNO", true);
			// 此处初始化大商户序列号
			setItemValue(0, 0, "RSERIALNO", getSerialNo("Retail_Info", "SerialNo", "R"));
			setItemValue(0,0,"REGCODE","R");
		} else if (sPermitType=="02") {
			
			hideItem(0, 0, "RNO");
			hideItem(0, 0, "RNAME");
			hideItem(0, 0, "REGCODE");
			hideItem(0, 0, "RNAME");
			showItem(0, 0, "RNAME1");
			
			setItemRequired(0, 0, "RSERIALNO", false);
			setItemRequired(0, 0, "RNO", false);
			setItemRequired(0, 0, "RNAME1", true);
			setItemRequired(0, 0, "REGCODE", false);
		} else {
			alert("请选择准入类型！");
			return;
		}
		
	}
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		as_save("myiframe0",sPostEvents);
		RunMethod("公用方法", "RetailInfoInit", getItemValue(0, 0, "SERIALNO"));
	}
	
    /*~[Describe=取消新增授信方案;InputParam=无;OutPutParam=取消标志;]~*/
	function doCancel()
	{		
		top.returnValue = "";
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">

	/*~[Describe=新增一笔授信申请记录;InputParam=无;OutPutParam=无;]~*/
	function doCreation()
	{
		checkRegCode();
		saveRecord("doReturn()");
	}
	
	/*~[Describe=确认新增授信申请;InputParam=无;OutPutParam=申请流水号;]~*/
	function doReturn(){
		var sObjectNo = getItemValue(0,0,"SERIALNO");
		top.returnValue = sObjectNo+"@"+getItemValue(0, 0, "PERMITTYPE")+"@"+getItemValue(0, 0, "RSERIALNO");
		top.close();
	}

	function checkRegCode(){
		var sRegCode=getItemValue(0,0,"REGCODE");
		var returnVal=RunMethod("信用等级评估","查询商户注册号是否存在",sRegCode);
		returnVal=parseFloat(returnVal);
		if( returnVal>0){
			alert("该商户注册号已存在");
			return;
		}
	}
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增一条空记录	
			var serialNo = getSerialNo("RetailStoreApply", "SerialNo");
			setItemValue(0, 0, "SERIALNO", serialNo);
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID %>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"REGCODE","R");
			
			
		}
		
		hideItem(0, 0, "RNO");
		hideItem(0, 0, "RNAME1");
		setItemRequired(0, 0, "RNAME", true);
		setItemRequired(0, 0, "RNAME1", false);
		setItemRequired(0, 0, "REGCODE", true);
		setItemRequired(0, 0, "RSERIALNO", true);
		// 此处初始化大商户序列号
		setItemValue(0, 0, "RSERIALNO", getSerialNo("Retail_Info", "SerialNo", "R"));
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