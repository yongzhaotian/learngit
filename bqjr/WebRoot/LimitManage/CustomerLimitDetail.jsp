<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:Thong 2005.8.30 10:40
		Tester:
		Content: 单一监管限额设置列表
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "单一监管限额设置列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
	String sTempletFilter = "";
	
	//获得页面参数	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));	
	if(sSerialNo==null) sSerialNo="";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过Sql产生ASDataObject对象doTemp
	String sHeaders[][] = { 
				{"LimitType","限额类型"},
				{"KindCode","客户名称"},
				{"Limit","单一限额(元)"},
				{"ActualLimit","实际占用限额(元)"},
				{"BeginDate","生效日期"},
				{"EndDate","失效日期"},
				{"Useflg","是否使用"},
				{"UserName","输入人员"},
				{"OrgName","机构"},
				{"InputDate","登记日期"}
			       };   				   			       
	sTempletFilter = "1=1";
	sSql = "select SerialNo,LimitType,KindCode,Limit,ActualLimit,BeginDate,EndDate,Useflg"+
			",UserID,getUserName(UserID) as UserName,OrgID,getOrgName(OrgID) as OrgName,InputDate "
			+" from LIMIT_INFO where SerialNo='"+sSerialNo+"'";
			
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "LIMIT_INFO";
	
	doTemp.setKey("SerialNo",true);
	doTemp.setUpdateable("OrgName,UserName",false);			
	doTemp.setVisible("SerialNo,OrgID,UserID",false);
	doTemp.setRequired("TotalSum,Limit,ActualLimit,BeginDate,EndDate,Useflg",true);
		
	doTemp.setAlign("TotalSum,Limit,ActualLimit","3");
	doTemp.setCheckFormat("TotalSum,Limit,ActualLimit","2");
	
	doTemp.setDDDWCode("Useflg","YesOrNo");
	doTemp.setAlign("BeginDate,EndDate,InputDate", "2");
    doTemp.setCheckFormat("BeginDate,EndDate,InputDate","3");
    doTemp.setReadOnly("LimitType,InputDate,UserName,OrgName",true);
  	
    doTemp.setHTMLStyle("BeginDate,EndDate"," style={width:80px} ");
   	doTemp.setHTMLStyle("UserName,InputDate,InputDate"," style={color:#848284;width:80px} ");
   	doTemp.setHTMLStyle("TotalSum"," onBlur=\"javascript:parent.caculateRegularLimit()\" ");
   		
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
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	/*~[Describe=保存所有修改,并返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function saveAndGoBack(){
		initSerialNo();
		saveRecord("goBack()");
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack(){
		OpenPage("/LimitManage/CustomerLimitList.jsp","_self","");
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
		OpenPage("/LimitManage/CustomerLimitDetail.jsp","_self","");
	}

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert(){
		initSerialNo();//初始化流水号字段
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputOrg","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"InputTime","<%=StringFunction.getTodayNow()%>");
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getTodayNow()%>");
	}

	/*~[Describe=单一、集团不同限额进行运算;InputParam=无;OutPutParam=无;]~*/
	function caculateRegularLimit(){
		sTotalSum= getItemValue(0,0,"TotalSum");
		sLimit = sTotalSum * 0.1;
		//alert(sLimit);
		sActualLimit = sTotalSum * 0.15;
		setItemValue(0,0,"Limit",sLimit);
		setItemValue(0,0,"ActualLimit",sActualLimit);
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0){ //如果没有找到对应记录，则新增一条，并设置字段默认值
			as_add("myiframe0");//新增记录
			bIsInsert = true;
		 	setItemValue(0,0,"LimitType","单一限额");
		 	setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"OrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"UserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");			
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() {
		var sTableName = "Limit_Info";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "RL";//前缀

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
