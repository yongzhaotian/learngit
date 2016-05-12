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
			SerialNo：预警流水号    
		Output param:
		                
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "预警发起"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
							{"SignalStatus","预警状态"},	
							{"MessageOrigin","预警信息来源"},	
							{"MessageContent","预警信息详情"},	
							{"ActionFlag","是否紧急行动"},	
							{"ActionType","紧急行动"},
							{"FreeFlag","是否解除"},	
							{"Remark","备注"},						
							{"InputOrgName","登记机构"},
							{"InputUserName","登记人"},
							{"InputDate","登记时间"},
							{"UpdateDate","更新时间"}
							};
		
	sSql =  " select ObjectNo,GetCustomerName(ObjectNo) as CustomerName,SignalNo, "+
			" SignalName,SignalType,SignalStatus,MessageOrigin,MessageContent, "+
			" ActionFlag,ActionType,'' as FreeFlag,Remark, "+
			" GetOrgName(InputOrgID) as InputOrgName,InputOrgID, "+
			" GetUserName(InputUserID) as InputUserName,InputUserID, "+
			" InputDate,UpdateDate,SerialNo,ObjectType,SignalChannel "+
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
	doTemp.setVisible("SerialNo,ObjectType,SignalNo",false);
	if(!sSignalStatus.equals("30"))
		doTemp.setVisible("FreeFlag",false);
	//设置下拉框内容
	doTemp.setDDDWCode("SignalType","SignalType");
	doTemp.setDDDWCode("SignalStatus","SignalStatus");
	doTemp.setDDDWCode("MessageOrigin","MessageOrigin");
	doTemp.setDDDWCode("ActionFlag","YesNo");
	doTemp.setDDDWCode("ActionType","ActionType");
	
	//设置格式
	doTemp.setHTMLStyle("CustomerName"," style={width:200px;} ");
	doTemp.setHTMLStyle("SignalName"," style={width:400px;} ");
	doTemp.setEditStyle("MessageContent,Remark","3");
 	doTemp.setLimit("MessageContent,Remark",200);
	doTemp.setReadOnly("SignalType,SignalStatus,ObjectNo,CustomerName,SignalName,InputUserName,InputOrgName,InputDate,UpdateDate",true);
 	doTemp.setRequired("CustomerName,SignalName,MessageOrigin,ActionFlag",true);
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo,SignalChannel,InputUserID,InputOrgID",false);    	
	doTemp.setUpdateable("InputUserName,InputOrgName,CustomerName,FreeFlag",false);
  	if(sSignalStatus.equals("10"))
  	{	  			
	  	doTemp.setUnit("CustomerName","<input type=button value=\"...\" onClick=parent.selectCustomer()>");		
		doTemp.setUnit("SignalName","<input type=button value=\"...\" onClick=parent.selectAlertSignal()>");		
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	if(!sSignalStatus.equals("10"))
		dwTemp.ReadOnly="1";
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//获取该批准的预警信息是否已被解除
	String sFreeFlag = "否";
	ASResultSet rs = null;
	if(sSignalStatus.equals("30")){ //批准
		sSql = 	" select Count(SerialNo) from RISK_SIGNAL "+
				" where RelativeSerialNo = :RelativeSerialNo "+				
				" and SignalStatus = '30' ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("RelativeSerialNo",sSerialNo));
		if(rs.next()){
			int iCount = rs.getInt(1);
			if(iCount > 0) sFreeFlag = "是";
			else sFreeFlag = "否";		
		} 
		rs.getStatement().close();
	}
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
	var bIsInsert = false; //标记DW是否处于“新增状态”
	
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{	
		sActionFlag = getItemValue(0,getRow(),"ActionFlag");
		if(sActionFlag == "1") //需要采取紧急行动
		{
			sActionType = getItemValue(0,getRow(),"ActionType");
			if (typeof(sActionType)=="undefined" || sActionType.length==0)
			{
				alert("请选择紧急行动！"); 
				return;
			}
		}else
		{
			setItemValue(0,0,"ActionType",""); //将所填写的紧急行动详情置为空字符串
		}	
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditAlarm/RiskSignalApplyList.jsp","_self","");
	}	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}


	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"ObjectType","Customer");	
			setItemValue(0,0,"SignalType","<%=sSignalType%>");	
			setItemValue(0,0,"SignalStatus","<%=sSignalStatus%>");
			setItemValue(0,0,"SignalChannel","01");		//01:手工录入；02：系统自动				
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;			
		}
		setItemValue(0,0,"FreeFlag","<%=sFreeFlag%>");	
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "RISK_SIGNAL";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=弹出预警信号选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectAlertSignal()
	{			
		sParaString = "CodeNo"+","+"AlertSignal";
		setObjectValue("SelectCode",sParaString,"@SignalNo@0@SignalName@1",0,0,"");
	}
	
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{	
		var sParaStr = "CertType, ";
		setObjectValue("SelectOwner",sParaStr,"@ObjectNo@0@CustomerName@1",0,0,"");
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