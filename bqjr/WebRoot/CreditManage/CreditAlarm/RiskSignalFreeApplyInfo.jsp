<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zywei  2006.03.14
		Tester:
		Content: 预警信息_Info
		Input Param:			 
			SignalType：预警类型（01：发起；02：解除）						 
			SignalStatus：预警状态（10：待处理；15：待分发；20：审批中；30：批准；40：否决） 
			SerialNo：预警解除流水号   
		Output param:
		                
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "预警解除详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
		
	//获得组件参数	
	String sSignalType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SignalType"));	
	String sSignalStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SignalStatus"));	
	//将空值转化为空字符串
	if(sSignalType == null) sSignalType = "";
	if(sSignalStatus == null) sSignalStatus = "";
	//获得页面参数	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));	
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%	

	String[][] sHeaders = {							
							{"CustomerName","客户名称"},
							{"SignalName","预警信号"},
							{"SignalType","预警类型"},
							{"SignalStatusName","预警状态"},	
							{"MessageOriginName","预警信息来源"},	
							{"MessageContent","预警信息详情"},	
							{"ActionFlagName","是否紧急行动"},	
							{"ActionTypeName","紧急行动"},							
							{"FreeReason","建议解除预警原因"},							
							{"Remark","备注"},											
							{"InputOrgName","登记机构"},
							{"InputUserName","登记人"},
							{"InputDate","登记时间"},
							{"UpdateDate","更新时间"}
							};
		
	sSql =  " select ObjectNo,GetCustomerName(ObjectNo) as CustomerName,SignalNo,SignalName,SignalType, "+
			" SignalStatus,getItemName('SignalStatus',SignalStatus) as SignalStatusName,MessageOrigin, "+
			" getItemName('MessageOrigin',MessageOrigin) as MessageOriginName,MessageContent, "+
			" ActionFlag,getItemName('YesNo',ActionFlag) as ActionFlagName,ActionType, "+
			" getItemName('ActionType',ActionType) as ActionTypeName,FreeReason,Remark, "+
			" GetOrgName(InputOrgID) as InputOrgName,InputOrgID,InputUserID, "+
			" GetUserName(InputUserID) as InputUserName,InputDate,UpdateDate, "+
			" SerialNo,ObjectType,SignalChannel "+
			" from RISK_SIGNAL "+
			" where SerialNo = '"+sSerialNo+"' ";
	//通过sql定义doTemp数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="RISK_SIGNAL";
	//设置关键字
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置不可见性
	doTemp.setVisible("SerialNo,ObjectType,SignalNo,SignalStatus,MessageOrigin,ActionFlag",false);
	doTemp.setVisible("ActionType,ObjectNo,SignalChannel,InputUserID,InputOrgID",false);    	
	
	//设置下拉框内容
	doTemp.setDDDWCode("SignalType","SignalType");
			
	//设置格式
	doTemp.setHTMLStyle("CustomerName"," style={width:200px;} ");
	doTemp.setHTMLStyle("SignalName"," style={width:400px;} ");	
	doTemp.setHTMLStyle("InputUserName,InputDate,UpdateDate"," style={width:80px;} ");
	doTemp.setHTMLStyle("MessageContent,FreeReason,Remark"," style={height:100px;width:400px;overflow:auto} ");
 	doTemp.setLimit("MessageContent,FreeReason,Remark",100);
 	doTemp.setEditStyle("MessageContent,FreeReason,Remark","3");
	doTemp.setReadOnly("SignalType,SignalStatus,ObjectNo,CustomerName,SignalName,SignalType,SignalStatusName,MessageOriginName",true);
 	doTemp.setReadOnly("MessageContent,ActionFlagName,ActionTypeName,InputUserName,InputOrgName,InputDate,UpdateDate",true);
 	doTemp.setRequired("FreeReason",true);
	doTemp.setUpdateable("CustomerName,SignalTypeName,SignalStatusName,MessageOriginName",false);
  	doTemp.setUpdateable("ActionFlagName,ActionTypeName,InputUserName,InputOrgName",false);
  	 	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	
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
			{(sSignalStatus.equals("10")?"true":"false"),"","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		};

		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{				
		as_save("myiframe0",sPostEvents);	
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditAlarm/RiskSignalFreeApplyList.jsp","_self","");
	}	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		setItemValue(0,0,"SignalType","<%=sSignalType%>");	
		setItemValue(0,0,"SignalStatus","<%=sSignalStatus%>");							
		setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
    }
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>