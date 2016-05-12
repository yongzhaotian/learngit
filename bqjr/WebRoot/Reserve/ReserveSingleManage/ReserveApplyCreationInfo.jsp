<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: sjchuan 2009-10-09
		Tester:
		Content: 创建单项减值准备申请
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
	String PG_TITLE = "单项计提减值准备新增信息"; // 浏览器窗口标题 <title> PG_TITLE </title>	
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数	：对象类型、申请类型、阶段类型、流程编号、阶段编号、发生方式、发生日期
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
	
	//定义变量：SQL语句
	String sSql = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "ReserveApplyCreationInfo";
	String sTempletFilter = "1=1";	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);		
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.getUserID()+","+CurOrg.getOrgID()+")+!ReserveManage.InitReserveApply(#SerialNo)");
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
		{"true","","Button","确定","新增逐笔减值准备申请","doCreation()",sResourcesPath},
		{"true","","Button","取消","取消逐笔减值准备方式申请","doCancel()",sResourcesPath}		
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
<script type="text/javascript">
	var bIsInsert = false;
	
	/*~[Describe=取消新增处置方式申请方案;InputParam=无;OutPutParam=取消标志;]~*/
	function doCancel(){		
		top.returnValue = "_CANCEL_";
		top.close();
	}

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function doCreation(){			
		saveRecord("doReturn()");
	}
	
	/*~[Describe=确认新增处置方案申请;InputParam=无;OutPutParam=申请流水号;]~*/
	function doReturn(){
		sSerialNo = getItemValue(0,0,"SerialNo");//申请流水号
		top.returnValue = "_SUCCESSFUL_"+"@"+sSerialNo;
		top.close();
	}	

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
			if (getRowCount(0)==0) {//如果没有找到对应记录，则新增一条，并设置字段默认值
				as_add("myiframe0");//新增一条空记录			
				setItemValue(0,0,"ManagerUserID","<%=CurUser.getUserID()%>");
				setItemValue(0,0,"ManagerOrgID","<%=CurOrg.getOrgID()%>");
				setItemValue(0,0,"ManagerOrgName","<%=CurOrg.getOrgName()%>");
				setItemValue(0,0,"ManagerUserName","<%=CurUser.getUserName()%>");
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
		var sTableName = "RESERVE_APPLY";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
								
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	</script>
	
	<script type="text/javascript">
	
	/*~[Describe=弹出合同选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectReserveContract(){
		setObjectValue("selectReserveContract","UserID,"+"<%=CurUser.getUserID()%>","@AccountMonth@0@DuebillNo@1@CustomerType@2@CustomerID@3@CustomerName@4@Balance@5@FiveClassify@6",0,0,"");
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