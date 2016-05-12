<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content: 代码项目信息详情
		Input Param:
                    AppID：    代码表编号
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "应用"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql;
	
	//获得组件参数	
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	//通过显示模版产生ASDataObject对象doTemp
	//String sTempletNo = "AppInfo";
	//String sTempletFilter = "1=1";
	//ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	String[][] sHeaders = {
		{"SerialNo","流水号"},
		{"ObjectType","对象类型"},
		{"Describe","预警条件说明"},
		{"Criteria","条件"},
		{"Cycle","周期数量"},
		{"CycleUnit","周期类型"},
		{"LastRun","上一次运行日期"}
	};
	sSql = "select SerialNo,ObjectType,Describe,Criteria,Cycle,CycleUnit,LastRun,InputUser,InputOrg,InputTime,UpdateUser,UpdateTime from RISK_CRITERIA where SerialNo='"+sSerialNo+"'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable="RISK_CRITERIA";
	doTemp.setHeader(sHeaders);
	doTemp.setEditStyle("Criteria","3");
	doTemp.setHTMLStyle("Criteria","style={width:600px;height:100px;overflow:auto} onDBLClick=\"parent.editCriteria(this)\"");
	doTemp.setDDDWSql("ObjectType","select ObjectType,ObjectName from OBJECTTYPE_CATALOG where ObjectType in('Customer','Individual','BusinessContract')");
	doTemp.setCheckFormat("Cycle","2");
	doTemp.setDDDWCode("CycleUnit","PeriodType");
	doTemp.setVisible("SerialNo,InputUser,InputOrg,InputTime,UpdateUser,UpdateTime,LastRun",false);
	//filter过滤条件
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sCriteriaAreaHTML = ""; 
%>

<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
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
		{"true","","Button","保存","保存修改","saveRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	var bIsInsert=false;
    var sCurAppID=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(){
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
        as_save("myiframe0","doReturn('Y');");
	}
    
    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"AppID");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	function initRow(){
		if (getRowCount(0)==0){ //如果没有找到对应记录，则新增一条，并设置字段默认值
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrg","<%=CurUser.getOrgID()%>");
		    bIsInsert = true;
		}
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
	}
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert(){
		initSerialNo();//初始化流水号字段
		setItemValue(0,0,"InputTime","<%=StringFunction.getTodayNow()%>");
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getTodayNow()%>");
	}

	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "RISK_CRITERIA";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "RC";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	function editObjectValueWithScriptEditorForAlertSQL(oObject,sSqlObjectType){
		sInput = oObject.value;
		sInput = real2Amarsoft(sInput);
		sInput = replaceAll(sInput,"~","$[wave]");
		oTempObj = oObject;
        saveParaToComp("ScriptText="+sInput+"&SqlObjectType="+sSqlObjectType,"openScriptEditorForAlertSqlAndSetText()");
		
	}
	function openScriptEditorForAlertSqlAndSetText(){
		var oMyobj = oTempObj;
		sOutPut = popComp("ScriptEditorForAlertSql","/Common/ScriptEditor/ScriptEditorForAlertSql.jsp","","");
		if(typeof(sOutPut)!="undefined" && sOutPut!="_CANCEL_"){
			oMyobj.value = amarsoft2Real(sOutPut);
		}
	}
	function editCriteria(oTemp){
		var sObjectType = getItemValue(0,0,"ObjectType");
		if(sObjectType=="" || typeof(sObjectType)=="undefined"){
			alert("请先选择对象类型!");
			return;
		}
		editObjectValueWithScriptEditorForAlertSQL(oTemp,sObjectType);
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
