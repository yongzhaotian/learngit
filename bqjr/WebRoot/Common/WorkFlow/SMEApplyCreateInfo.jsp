<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: pwang 2009-10-09
		Tester:
		Content: 中小型企业资格认定新增信息
		Input Param:
			ObjectType：对象类型
			ApplyType：申请类型
			PhaseType：阶段类型
			FlowNo：流程号
			PhaseNo：阶段号
		Output param:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "中小型企业资格认定新增信息"; // 浏览器窗口标题 <title> PG_TITLE </title>	
	// 获得页面参数
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	if(sObjectNo==null) sObjectNo="";
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";	
		if(sApplyType == null) sApplyType = "";
		if(sPhaseType == null) sPhaseType = "";	
		if(sFlowNo == null) sFlowNo = "";
		if(sPhaseNo == null) sPhaseNo = "";

	
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "SMEApplyCreateInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.getUserID()+","+CurOrg.getOrgID()+")+!CustomerManage.UpdateSMECustomerApply(#SerialNo)");
	dwTemp.setEvent("AfterUpdate","!CustomerManage.UpdateSMECustomerApply(#SerialNo)");

	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+CurUser.getUserID());//传入参数,逗号分割
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
		{"true","","Button","确定","保存并初始化流程","doCreation()",sResourcesPath},
		{"true","","Button","取消","取消申请","doCancel()",sResourcesPath}		
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">

	//全局变量
	var bIsInsert = false;	

	function Validity(){
		sEmployNumber = getItemValue(0,0,"Attribute1");
		var Letters = "1234567890";
		for (i = 0;i < sEmployNumber.length;i++)
		{
			var CheckChar = sEmployNumber.charAt(i);
			if (Letters.indexOf(CheckChar) == -1)
			{			        
				//alert("请输入整数数值");
				//setItemValue(0,0,"Attribute1","");
			} 
		}
		
	}
	
	/*~[Describe=取消新增处置方式申请方案;InputParam=无;OutPutParam=取消标志;]~*/
	function doCancel(){		
		top.returnValue = "_CANCEL_";
		top.close();
	}

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function doCreation(){
		if(vI_all("myiframe0") && matchModel()){
			saveRecord("doReturn()");
			as_save("myiframe0");
		}
	}
	/*~[Describe=确认新增处置方案申请;InputParam=无;OutPutParam=申请流水号;]~*/
	function doReturn(){
		sCustomerID = getItemValue(0,0,"CustomerID");
		top.returnValue = "_SUCCESSFUL_"+"@"+sCustomerID;
		top.close();
	}	

	/*~[Describe=填入企业相关信息后，进行模型匹配;InputParam=无;OutPutParam=无;]~*/
	function setAsset(){
		var sIndustryType = getItemValue(0,0,"Attribute7");				//中小型企业行业类型**
		//工业,建筑业资产总额设置默认值 
		if(sIndustryType == "0130010" || sIndustryType == "0130020"){
			setItemValue(0,0,"Attribute3","");
		}else{
			setItemValue(0,0,"Attribute3",amarMoney(0,2));
		}
	}
		
	/*~[Describe=填入企业相关信息后，进行模型匹配;InputParam=无;OutPutParam=无;]~*/
	function matchModel(){
		var sIndustryType = getItemValue(0,0,"Attribute7");				//中小型企业行业类型**
		var sEmployeeNum = getItemValue(0,0,"Attribute1");				//职工人数
		var sSaleSum = getItemValue(0,0,"Attribute2");						//销售额
		var sAssetSum = getItemValue(0,0,"Attribute3");						//资产总额
		var sEntScale = getItemValue(0,0,"Attribute6");						//企业规模
		var cScale = {"3":"中型企业","4":"小型企业","0":"大型企业","9":"其它"};
	
		var sReturn = RunMethod("CustomerManage","CheckSMECustomerAction",sIndustryType+","+sEmployeeNum+","+sSaleSum+","+sAssetSum);
		if(sEntScale == sReturn){
			return true;
		}else{
			oEntScale = getASObject(0,0,"Attribute6");
			if(sReturn == "9"){
				if(confirm("你录入的数据不符合任何模型，确定继续吗？")){
					return true;
				}else{
					return false;
				}
			}
			if(confirm("你录入的数据符合"+cScale[sReturn]+"，确定继续吗？")){
				return true;
			}else{
				return false;
			}
		}
	}
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0) {//如果没有找到对应记录，则新增一条，并设置字段默认值
			as_add("myiframe0");//新增一条空记录			
			setItemValue(0,0,"CustomerType","<%=sCustomerType%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;	
		}
	}
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		as_save("myiframe0",sPostEvents);
	}
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert(){
		initSerialNo();//初始化流水号字段
		bIsInsert = false;
	}

	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "SME_APPLY";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
								
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer(){			
		sCustomerType = getItemValue(0,0,"CustomerType");
		if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
		{
			alert("请先选择客户类型!");
			return;
		}
		//具有业务申办权的客户信息
		sParaString = "UserID,"+"<%=CurUser.getUserID()%>"+",CustomerType"+","+sCustomerType;
		//sReturnValue =setObjectValue("SelectApplyCustomer5",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
		//add by syang 2009/11/06 如果客户有在途业务，则不允许进行中小企业资格认定
		sReturnValue =setObjectValue("SelectApplyCustomer5",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");

        if (typeof(sReturnValue) == "undefined" || sReturnValue == "") {
        	sCustomerID = "";
        	sCustomerName = "";
        } else {
        	sCustomerID=sReturnValue.split("@")[0];
            sCustomerName=sReturnValue.split("@")[1];
        }
		//在途业务检查
		sCount = RunMethod("BusinessManage","CustomerUnFinishedBiz",sCustomerID);
		if(sCount != "0"){
			alert("操作失败！该客户有在途申请！");
			setItemValue(0,getRow(),"CustomerID","");
			setItemValue(0,getRow(),"CustomerName","");
			return;
		}
	}

	/*~[Describe=清空信息;InputParam=无;OutPutParam=申请流水号;]~*/
	function clearData(){
		setItemValue(0,0,"CustomerID","");
		setItemValue(0,0,"CustomerName","");
		setItemValue(0,0,"Attribute6","");
		setItemValue(0,0,"Attribute7","");
		setItemValue(0,0,"Attribute1","");
		setItemValue(0,0,"Attribute2","");
		setItemValue(0,0,"Attribute3","");
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();	
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化	
	var bCheckBeforeUnload=false;	//不做页面退出时确认。
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>