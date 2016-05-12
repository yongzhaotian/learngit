<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   hxli  2005.7.28
		Tester:
		Content: 待处理的预警信息_List
		Input Param:
			                AlertType：预警类型
		Output param:
		                
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "待处理的预警列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	String sAlertType;
	String sTreatmentStatus;
	
	//获得组件参数	
	sAlertType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlertType"));
	sTreatmentStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TreatmentStatus"));
	if(sAlertType==null) sAlertType="";
	if(sTreatmentStatus==null) sTreatmentStatus="";
	
	//获得页面参数	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	String[][] sHeaders = {
		{"ObjectName","警示相关对象"},
		{"AlertTypeName","警示类型"},
		{"AlertTip","警示标题"},
		{"OccurDate","发生日期"},
		{"Remark","备注"},
		{"InputUserName","登记人"},
		{"InputTime","登记时间"},
		};
		
	sSql =  " select SerialNo,ObjectType,ObjectNo,GetObjectName(ObjectType,ObjectNo) as ObjectName,"+
			" AlertType,GetItemName('AlertSignal',AlertType) as AlertTypeName,AlertTip,AlertDescribe,"+
			" OccurDate,OccurTime,UserID,OrgID,OccurReason,Treatment,EndTime,Remark,"+
			" GetUserName(InputUser) as InputUserName,InputUser,InputOrg,InputTime,UpdateTime"+
			" from ALERT_LOG where 1=1";
	//通过sql定义doTemp数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.multiSelectionEnabled=true;
	doTemp.UpdateTable="ALERT_LOG";
	//设置关键字
	doTemp.setKey("SerialNo",true);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置不可见项
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo,ObjectType,AlertType,AlertDescribe,UserID,OrgID,OccurReason,OccurTime,Treatment,EndTime,Remark,InputUser,InputOrg,UpdateTime",false);
	//设置格式
	doTemp.setHTMLStyle("ObjectName","style={width:200px}");
	doTemp.setHTMLStyle("AlertTip","style={width:250px}");
	//设置过滤器
	doTemp.setColumnAttribute("AlertTip,InputUserName,ObjectName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));


	if(sTreatmentStatus.equals("Undistributed")){
		doTemp.WhereClause+=" and UserID is null";
		if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause +=" and InputUser='"+CurUser.getUserID()+"'";
	}else if(sTreatmentStatus.equals("Unfinished")){
		doTemp.WhereClause+=" and OrgID='"+CurUser.getOrgID()+"' and EndTime is null";
	}else if(sTreatmentStatus.equals("Finished")){
		doTemp.WhereClause+=" and (UserID='"+CurUser.getUserID()+"' or InputUser='"+CurUser.getUserID()+"')  and EndTime is not null";
		if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause +=" and 1=2";
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sAlertType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
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
		{"false","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"false","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"false","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"false","","Button","原始情况","查看相关的业务对象","openWithObjectViewer()",sResourcesPath},
		{"false","","Button","分发","分发所选中的记录","distribute()",sResourcesPath},
		{"false","","Button","跟踪","跟踪处理情况","follow()",sResourcesPath},
		{"false","","Button","完成处理","完成处理","finish()",sResourcesPath},
		};

		if(sTreatmentStatus.equals("Undistributed")) {
			sButtons[0][0] = "true";
			sButtons[1][0] = "true";
			sButtons[2][0] = "true";
			sButtons[3][0] = "true";
		}else if(sTreatmentStatus.equals("Unfinished")){
			sButtons[1][0] = "true";
			sButtons[3][0] = "true";
			sButtons[4][0] = "true";
			sButtons[5][0] = "true";
			sButtons[6][0] = "true";
		}else{
			sButtons[1][0] = "true";
			sButtons[3][0] = "true";
			sButtons[5][0] = "true";
		}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		popComp("NewAlert","/CreditManage/CreditAlarm/AlertInfo.jsp","");
		reloadSelf();
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")) 
		{
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sAlertID=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sAlertID)=="undefined" || sAlertID.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		popComp("AlertInfo","/CreditManage/CreditAlarm/AlertInfo.jsp","AlertID="+sAlertID,"","");
		reloadSelf();
	}
	
	
	/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/
	function openWithObjectViewer()
	{
		sObjectType=getItemValue(0,getRow(),"ObjectType");
		sObjectNo=getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectType)=="undefined" || sObjectType.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		//alert(sObjectType+"."+sObjectNo);
		openObject(sObjectType,sObjectNo,"001");
	}
	
	function distribute(){
		var sAlertIDs = getItemValueArray(0,"SerialNo");
		var sAlertIDString="";
		for(i=0;i<sAlertIDs.length;i++){
			sAlertIDString += "@" + sAlertIDs[i];
		}
		if (sAlertIDString=="")
		{
			alert("请双击多选区，选择一条以上记录！");
			return;
		}
		sReturn=popComp("AlertDistribute","/CreditManage/CreditAlarm/AlertDistributeVSFrame.jsp","AlertIDString="+sAlertIDString,"");

		reloadSelf();
	}
	function finish(){
		sAlertID=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sAlertID)=="undefined" || sAlertID.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		popComp("AlertFinishInfo","/CreditManage/CreditAlarm/AlertFinishInfo.jsp","AlertID="+sAlertID,"","");
		reloadSelf();
	}
	
	function follow(){
		sAlertID=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sAlertID)=="undefined" || sAlertID.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		popComp("AlertHandleList","/CreditManage/CreditAlarm/AlertHandleList.jsp","AlertID="+sAlertID,"","");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
<%
    if(!doTemp.haveReceivedFilterCriteria()) {
%>
	showFilterArea();
<%
	}	
%>

</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
