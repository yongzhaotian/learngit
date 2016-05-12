<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   bwang
		Tester:
		Content: 信用等级评估新增信息
		Input Param:
		
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户评级发起"; // 浏览器窗口标题 <title> PG_TITLE </title>	
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%
    String sTempletNo = "CRApplyCreateDialog";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	doTemp.setReadOnly("CustomerName,OccurType,RefModelName,FSReport",true);
	
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
		{"true","","Button","确定","确定新增客户评级申请","saveRecord()",sResourcesPath},
		{"true","","Button","取消","取消新增客户评级申请","doCancel()",sResourcesPath}		
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(){
		if(bIsInsert){
			initSerialNo();
		}
		as_save("myiframe0","doReturn()");
	}
		
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{
		//选择客户
		var sCustomerID = "";
		var sParaString = "UserID"+","+"<%=CurUser.getUserID()%>";
		var sReturn = setObjectValue("SelectCustomerBelong01",sParaString,"@CustomerID@0@CustomerName@1@CustomerType@2",0,0,"");
		if(typeof(sReturn)=="undefined" || sReturn.length==0||sReturn=="_CANCEL_")return;
		sCustomerID = getItemValue(0,0,"CustomerID");
		//判断该客户是否是暂存形式
		var sTempSaveFlag = RunMethod("CustomerRatingTool","GetTempSaveFlag",sCustomerID);
		if(sTempSaveFlag =="1"){
			setItemValue(0,0,"CustomerID","");
			setItemValue(0,0,"CustomerName","");
			setItemValue(0,0,"CustomerType","");
			alert("该客户信息存储形式为暂存，不能发起评级！");
			return;
		}
		setItemValue(0,0,"CustomerID",sCustomerID);
		//根据选择的客户设置客户评级财报
		addFinanceType();	
		//确定客户评级发生类型。
		var sResult = RunMethod("CustomerRatingTool","JudgeCROccurType",sCustomerID);
		if(typeof(sResult)=="undefined" || sResult.length==0)return;
		setItemValue(0,0,"OccurTypeID",sResult);
		
		if(sResult == "010")
			setItemValue(0,0,"OccurType","即期评级");
		else 
			setItemValue(0,0,"OccurType","评级更新");
	}

	/*~弹出评级模型选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectModel(){
		var sCustomerID = getItemValue(0,0,"CustomerID");
		if(typeof(sCustomerID)== "undefined" || sCustomerID.length==0){
			alert("请先选择用户！");
			return;
		}
		var sReturn = RunMethod("CustomerRatingTool","GetRatingModelCondition",sCustomerID);
		if(typeof(sReturn)=="undefined"|| sReturn==""){
			alert("获得客户评级模板列表出错！");
			return;
		}
		sReturn = sReturn.split("@");
		var alertInform  = "";
		if(sReturn[0] =="NONE") alertInform += "国标分类";
		if(sReturn[1]=="NONE") alertInform += " 企业规模";
		if(sReturn[2]=="NONE") alertInform += " 成立时间";
		
		if(alertInform != ""){
			alert("该客户的"+alertInform+"等信息不完整,请完善后再进行评级");
			return;
		}else{
			var paramString = "Attribute1"+","+sReturn[0]+","+"Attribute2"+","+sReturn[1]+","+"Attribute3"+","+sReturn[2];
			setObjectValue("selectRuleModel", paramString, "@RefModelID@0@RefModelName@1");
		}
	}
	
	/*~[Describe=确定;InputParam=无;OutPutParam=无;]~*/
	function doReturn()
	{
		var sRatingAppID = getItemValue(0,getRow(),"RatingAppID");
		var sModelID = getItemValue(0,getRow(),"RefModelID");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		var sReportDate = getItemValue(0,getRow(),"ReportDate");
		var sReportScope = getItemValue(0,getRow(),"ReportScope");
		var sReportPeriod = getItemValue(0,getRow(),"ReportPeriod");
		var sAuditFlag = getItemValue(0,getRow(),"AuditFlag");
		var sUserID = "<%=CurUser.getUserID()%>";
		var sOrgID = "<%=CurOrg.getOrgID()%>";
		var param = sCustomerID+","+sReportDate+","+sReportScope+","+sReportPeriod+","+sAuditFlag;
		//发起评级锁定报表
		RunMethod("CustomerRatingTool","LockFSRecord",param);
		self.returnValue = sRatingAppID+"@"+sModelID+"@"+sCustomerID;
		self.close();
    }
    
    /*~[Describe=取消;InputParam=无;OutPutParam=无;]~*/
    function doCancel(){		
			top.close();
	}
    
	/*~[Describe=填充财务报表信息;InputParam=无;OutPutParam=无;]~*/
	function addFinanceType(){		
		var sCustomerID = getItemValue(0,0,"CustomerID");
		if(typeof(sCustomerID) == "undefined" || sCustomerID == ""){
			alert("请先选择客户！");
			return;
		}
		var sReturn = RunMethod("CustomerRatingTool","AddFinanceType",sCustomerID);
		if(typeof(sReturn)=="undefined"||sReturn.length==0){
			alert("获得财务报表出错！");
			return;
		}else if(sReturn=="NOSETUPDATE"){
			alert("请保证客户的国标分类，企业规模，成立时间等信息都已录入再进行评级！");
			return;
		}else if(sReturn=="NOREPORT"){
			alert("该客户没有可用的报表，请录入相应的报表再评级！");
			return;
		}
		
		sReturn = sReturn.split("@");
		setItemValue(0,0,"ReportDate",sReturn[0]);
		setItemValue(0,0,"ReportPeriod",sReturn[1]);
		setItemValue(0,0,"ReportScope",sReturn[2]);
		setItemValue(0,0,"AuditFlag",sReturn[3]);

		var period ="";
		if(sReturn[1]=="01")period="月报";
		else if(sReturn[1]=="02")period="季报";
		else if(sReturn[1]=="03") period="半年报";
		else if(sReturn[1]=="04") period="年报";
		var scope="";
		if(sReturn[2]=="01")scope="本部";
		else if(sReturn[2]=="02")scope="合并";
		else if(sReturn[2]=="03")scope="汇总";
		
		sFSReport = "期次:"+sReturn[0]+" 周期:"+period+" 口径:"+scope;
		setItemValue(0,0,"FSReport",sFSReport);
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增一条空记录
			setItemValue(0,0,"RatingPerion","<%=StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", 0)%>"); 
			setItemValue(0,0,"OccurDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"LaunchUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"LaunchOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"RatingType","10");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");	
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");	
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
		
    }

	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "Rating_Apply";//表名
		var sColumnName = "RatingAppID";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,0,"RatingAppID",sSerialNo);
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