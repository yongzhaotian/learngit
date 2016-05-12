<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Content: 警示信息_Info
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "警示信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量

	//获得页面参数	
	String sAlertID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlertID"));
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	if(sAlertID==null) sAlertID="";
	if(sObjectType==null) sObjectType="";
	if(sObjectNo==null) sObjectNo="";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sSql = "select SerialNo,ObjectType,ObjectNo,GetObjectName(ObjectType,ObjectNo) as ObjectName,AlertType,GetItemName('AlertSignal',AlertType) as AlertTypeName,AlertTip,AlertDescribe,OccurDate,OccurTime,UserID,GetUserName(UserID) as UserName,GetOrgName(OrgID) as OrgName,OrgID,OccurReason,Treatment,EndTime,Remark,InputUser,GetUserName(InputUser) as InputUserName,InputOrg,InputTime,UpdateUser,UpdateTime from ALERT_LOG where SerialNo='"+sAlertID+"'";
	String[][] sHeaders = {
		{"ObjectType","警示相关业务对象类型"},
		{"ObjectName","警示相关业务对象"},
		{"AlertTypeName","警示类型"},
		{"AlertTip","警示标题"},
		{"OccurDate","发生日期"},
		{"AlertDescribe","警示信息"},
		{"UserName","处理人"},
		{"OrgName","处理机构"},
		{"InputUserName","输入人"},
		{"InputTime","输入时间"},
		{"Remark","备注"},
		};
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable="ALERT_LOG";
	doTemp.setKey("SerialNo",true);
	doTemp.setUpdateable("ObjectName,AlertTypeName,OrgName,UserName,InputUserName",false);

	doTemp.setDDDWSql("ObjectType","select ObjectType,ObjectName from OBJECTTYPE_CATALOG where ObjectType in('Customer','Individual','BusinessContract')");
	doTemp.setVisible("SerialNo,ObjectNo,AlertType,UserName,UserID,OrgID,OccurTime,OccurReason,Treatment,EndTime,InputUser,InputOrg,UpdateUser,UpdateTime",false);

	//doTemp.setDDDWCode("AlertType","AlertSignal");
	doTemp.setUnit("UserName"," <input type=button value=\"..\" class=inputDate onClick=javascript:parent.setObjectInfo(\"User\",\"@UserID@0@UserName@1@OrgID@2\")> ");
	doTemp.setUnit("OrgName"," <input type=button value=\"..\" class=inputDate onClick=javascript:parent.SelectOrg()> ");
	doTemp.setEditStyle("AlertTypeName,Remark,AlertDescribe","3");
	doTemp.setRequired("AlertTypeName,AlertTip,ObjectName",true);
	doTemp.setCheckFormat("OccurDate","3");
	doTemp.setReadOnly("AlertTypeName,OrgName",true);
	doTemp.appendHTMLStyle("AlertDescribe","style={overflow:auto}");
	doTemp.appendHTMLStyle("Remark","style={overflow:auto}");
	doTemp.setHTMLStyle("AlertTip"," style={width:300px;}");
	doTemp.setHTMLStyle("ObjectName"," style={width:300px;}");
	doTemp.setHTMLStyle("AlertTypeName"," style={width:300px;height:50px;cursor: pointer;} onClick=parent.setObjectInfo(\"Code\",\"CodeNo=AlertSignal^警示类型^ItemNo$like$\\'AL%\\'$and$length(ItemNo)=6@AlertType@0@AlertTypeName@1\") ");
	doTemp.setUnit("ObjectName"," <input type=button value=\"..\" class=inputDate onClick=\"javascript:parent.chooseObject(\\'@ObjectNo@0@ObjectName@1\\')\"> ");
	
	if(!sObjectType.equals("")) doTemp.setDefaultValue("ObjectType",sObjectType);
	else doTemp.setDefaultValue("ObjectType","Customer");

	doTemp.setDefaultValue("ObjectNo",sObjectNo);
	doTemp.setDefaultValue("OccurDate",StringFunction.getToday());

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
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
		{"true","","Button","保存并返回","保存所有修改,并返回列表页面","saveAndGoBack()",sResourcesPath},
		{"true","","Button","保存并新增","保存并新增一条记录","saveAndNew()",sResourcesPath},
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
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
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	/*~[Describe=保存所有修改,并返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack(){
		self.close();
	}

	/*~[Describe=保存并新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function saveAndNew(){
		saveRecord("newRecord()");
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		OpenPage("/CreditManage/CreditAlarm/AlertInfo.jsp?AlertID=new","_self","");
	}

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert(){
		initSerialNo();//初始化流水号字段
		setItemValue(0,0,"InputTime","<%=StringFunction.getTodayNow()%>");
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getTodayNow()%>");
	}

	function chooseObject(sValueString){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		if(sObjectType==null || sObjectType==""){
			alert("请先选择相关对象类型");
			return;
		}
		setObjectInfo(sObjectType,sValueString);
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0){ //如果没有找到对应记录，则新增一条，并设置字段默认值
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrg","<%=CurUser.getOrgID()%>");
		}
    }
	
	function SelectOrg(){
        setObjectInfo("Org","@OrgID@0@OrgName@1");    
	}
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "ALERT_LOG";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "AL";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
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
