<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zywei 2005-11-29 
		Tester:
		Content: 产品分组信息详情
		Input Param:
			CLTeamID：产品分组编号
		Output param:
		
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "产品分组信息详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量

	//获得页面参数	
	String sCLTeamID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CLTeamID"));
	if(sCLTeamID == null) sCLTeamID = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%
		
	//通过显示模版产生ASDataObject对象doTemp	 
	String sTempletNo="ProductTypeTeamInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);	
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCLTeamID);
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
		{"true","","Button","保存并新增","保存并新增一条记录","saveAndNew()",sResourcesPath}
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
		//获得产品分组内容(主要是保持分行显示标志)
		var sCLTeamContentName = getItemValue(0,getRow(),"CLTeamContentName");		
		sCLTeamContentName.replace(",/r/n",",//r//n");		
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
		OpenPage("/Common/Configurator/CreditLineConfig/ProductTypeTeamList.jsp","_self","");
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
		OpenPage("/Common/Configurator/CreditLineConfig/ProductTypeTeamInfo.jsp","_self","");
	}

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert(){
		initSerialNo();//初始化流水号字段		
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");		
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getTodayNow()%>");
	}
	
	/*~[Describe=选择产品;InputParam=无;OutPutParam=无;]~*/
	function selectProductType(){
		sReturnValue = PopPage("/Common/Configurator/CreditLineConfig/AddProductTypeDialog.jsp?CLTeamID=<%=sCLTeamID%>","","dialogWidth=35;dialogHeight=22;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sReturnValue) != "undefined" && sReturnValue != "@" && sReturnValue != "_none_"){
		 	sReturnValue = sReturnValue.split("@");		 	
		 	setItemValue(0,getRow(),"CLTeamContentID",sReturnValue[0]);
		 	setItemValue(0,getRow(),"CLTeamContentName",sReturnValue[1]);		 	
		 	
		}		
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0){ //如果没有找到对应记录，则新增一条，并设置字段默认值
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"CLTeamType","ProductTypeTeam");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getTodayNow()%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "CL_TEAM";//表名
		var sColumnName = "CLTeamID";//字段名
		var sPrefix = "";//前缀

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
