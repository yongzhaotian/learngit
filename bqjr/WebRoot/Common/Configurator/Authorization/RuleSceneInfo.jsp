<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zllin@amarsoft.com
		Tester:
		Describe: 授权维度信息详情;
		Input Param:
			SynonymnID：BOM对象名称
			
		Output Param:

		HistoryLog:

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授权维度信息详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";//Sql语句
	
	//获得页面参数：对象类型、对象编号、担保信息编号、抵押物编号、质物类型
	String sSceneID = DataConvert.toString((String)CurComp.getParameter("SceneID"));
	String sGroupID = DataConvert.toString((String)CurComp.getParameter("GroupID"));
	//ARE.getLog().debug("sSceneID=["+sSceneID+"],sGroupID=["+sGroupID+"]");
		
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%	
	
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject("AuthorSceneInfo",Sqlca);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	
	//设置setEvent
	dwTemp.setEvent("AfterInsert", "!PublicMethod.AuthorObjectManage('update','scene',#SCENEID)+!PublicMethod.AuthorRelative(#SCENEID,"+sGroupID+")");
	dwTemp.setEvent("AfterUpdate", "!PublicMethod.AuthorObjectManage('update','scene',#SCENEID)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSceneID);
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
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","PlainText","所包含的参数变更后需要逐个调整\"授权方案规则配置\"","","",sResourcesPath}
	};
	
	%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		//录入数据有效性检查
		if(bIsInsert){		
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0","self.close();");	
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	
	function resetObjects(){
		setItemValue(0,0,"OBJECTS","");
		setItemValue(0,0,"OBJECTSNAME","");
	}
	
	function selectUser(colId,colName){
		popDynamicSelector("DYNAMICUSER",colId,colName);
	}
	function selectRole(colId,colName){
		popDynamicSelector("DYNAMICROLE",colId,colName);
	}
	function selectDimension(colId,colName){
		popSelector("DIMENSION",colId,colName);
	}
	function selectFlow(colId,colName){
		popSelector("FLOW",colId,colName);
	}
	function selectOrg(colId,colName){
		popSelector("ORG",colId,colName);
	}
	
	function popSelector(type,colId,colName){
		var selectedId = getItemValue(0,getRow(),colId);	
		var sReturn = PopPage("/Common/Configurator/Authorization/ElementSelect.jsp?iniString="+selectedId+"&type="+type,"","dialogWidth=550px;dialogHeight=400px;center:yes;resizable:yes;scrollbars:no;status:no;help:no");
		if(typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=="_CANCEL_"){
			return ;		//do nothing
		}
		if(sReturn=="_CLEAR_"){
			setItemValue(0,0,colId,"");
			setItemValue(0,0,colName,"");
			return;
		}
		var selectedValue = sReturn.split("@");
		if(typeof(selectedValue[0])!="undefined" && selectedValue[0].length > 0){		//没有做出选择
			setItemValue(0,0,colId,selectedValue[0]);
			setItemValue(0,0,colName,selectedValue[1]);
		}
	}
	
	function popDynamicSelector(type,colId,colName){
		var selectedId = getItemValue(0,getRow(),colId);	
		var sReturn = PopPage("/Common/Configurator/Authorization/ElementSelectDynamic.jsp?iniString="+selectedId+"&type="+type,"","dialogWidth=640px;dialogHeight=400px;center:yes;resizable:yes;scrollbars:no;status:no;help:no");
		if(typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=="_CANCEL_"){
			return ;		//do nothing
		}
		/**/
		if(sReturn=="_CLEAR_"){
			setItemValue(0,0,colId,"");
			setItemValue(0,0,colName,"");
			return;
		}
		var selectedValue = sReturn.split("@");
		if(typeof(selectedValue[0])!="undefined" && selectedValue[0].length > 0){		//没有做出选择
			setItemValue(0,0,colId,selectedValue[0]);
			setItemValue(0,0,colName,selectedValue[1]);
		}
		
	}

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		//
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0) == 0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			bIsInsert = true;			
		}
		
    }

	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "SADRE_RULESCENE";//表名
		var sColumnName = "SCENEID";//字段名
		var sPrefix = "S";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		//var sSceneID = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","");
		var sSceneID = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),"SCENEID",sSceneID);				
	}
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化

</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
