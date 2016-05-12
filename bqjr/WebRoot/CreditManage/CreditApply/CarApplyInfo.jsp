<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content: 
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
	String PG_TITLE = "新增信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	
	
	System.out.println("----"+sSerialNo+"------");
	
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	if(sSerialNo == null) sSerialNo = "";
		
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "CarApplyInfo";
	
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
	//dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+","+sSerialNo+","+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.getUserID()+","+CurOrg.getOrgID()+")");
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
			{"true","","Button","确认","确认","doCreation()",sResourcesPath},
			{"true","","Button","取消","取消","doCancel()",sResourcesPath}	
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		as_save("myiframe0");
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
	  setInit();//设置初始值
	  var sObjectType = "BusinessContract";//
	  var sApplyType = "CarCreditLineApply";//申请类型
	  //var sPhaseType = "1010";//
	  var sFlowNo = "CarFlowNew";//流程编号
	  var sPhaseNo = "0010";//阶段编号
	  var sSerialNo="<%=sSerialNo%>";
	  var userid="<%=CurUser.getUserID()%>";
	  var orgid="<%=CurOrg.getOrgID()%>";
	
	  sParam=sObjectType+","+sSerialNo+","+sApplyType+","+sFlowNo+","+sPhaseNo+","+userid+","+orgid;
	  //alert("------"+sParam);
	  RunMethod("WorkFlowEngine","InitializeFlow",sParam);//初始化流程
	  saveRecord("doReturn()");
	}
	
	
	/*~[Describe=确认新增授信申请;InputParam=无;OutPutParam=申请流水号;]~*/
	function doReturn(){
		sObjectNo = getItemValue(0,0,"SerialNo");
		sObjectType = "<%=sObjectType%>";		
		top.returnValue = sObjectNo+"@"+sObjectType;
		top.close();
	}

	
	/*~[Describe=弹出汽车金融产品选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectProductID()
	{
		sProductID = getItemValue(0,0,"ProductID");
		if(typeof(sProductID) == "undefined" || sProductID == "")
		{
			alert("请先选择产品类型!");
			return;
		}
		//alert("----------"+sProductID);
		sParaString = "ProductType"+","+sProductID;
		//设置返回参数 
		setObjectValue("SelectCarBusinessInfo",sParaString,"@BusinessType@0@ProductName@1",0,0,"");
	}
	
	//设置值
    function setInit(){
		//车贷合同标识
		setItemValue(0,0,"CreditAttribute","0001");
		//合同状态:060新发生
		setItemValue(0,0,"ContractStatus","060");
		//申请日期
		setItemValue(0,0,"ApplyDate","<%=StringFunction.getToday()%>");
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
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		//更新日期
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		//暂存标志
		setItemValue(0,0,"TempSaveFlag","1");//是否标志（1：是；2：否）
    }
					
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增一条空记录
			
			//车贷合同标识
			setItemValue(0,0,"CreditAttribute","0001");
			//合同状态:060新发生
			setItemValue(0,0,"ContractStatus","060");
			//申请日期
			setItemValue(0,0,"ApplyDate","<%=StringFunction.getToday()%>");
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
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			//更新日期
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			//暂存标志
			setItemValue(0,0,"TempSaveFlag","1");//是否标志（1：是；2：否）
		}
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