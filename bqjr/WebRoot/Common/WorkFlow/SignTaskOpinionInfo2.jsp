<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
	Author:   CChang 2003.8.25
	Tester:
	Content: 签署意见
	Input Param:
		TaskNo：任务流水号
		ObjectNo：对象编号
		ObjectType：对象类型
	Output param:
	History Log: zywei 2005/07/31 重检页面
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "签署意见";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%	
	//获取组件参数：任务流水号
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sSNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sViewId = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewId"));
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if (sViewId == null) sViewId = "";
	sSNo = sObjectNo;
	
%>
<%/*~END~*/%>

	<%
	// 通过DW模型产生ASDataObject对象doTemp
		String sRolIds = "";
		List roleList = CurUser.getRoleTable();
		for (int i=0; i<roleList.size(); i++) {
			sRolIds += roleList.get(i)+",";
		}
		if (!"".equals(sRolIds)) sRolIds = sRolIds.substring(0, sRolIds.length()-1);
		
		if ("002".equals(sViewId)) CurPage.setAttribute("RightType", "ReadOnly");
		
		String sTempletNo = "RetailStoreOpinion";//模型编号
		ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
		
		//生成HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo+","+sSNo);//传入参数,逗号分割
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
			{"true","","Button","删除","删除意见","deleteRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	var bIsInsert = false; // 标记DW是否处于“新增状态”
	
	// 控制当选择拒绝时控制备注必输 add by tbzeng 2014/05/17
	function setRequireOpinion() {
		
		var sRetSult = getItemValue(0, 0, "SVRESULT");
		if( "01" == sRetSult) {
			setItemRequired(0, 0, "PHASEOPINION", true);
		} else if ("02" == sRetSult) {
			setItemRequired(0, 0, "PHASEOPINION", false);
		}
	}
	
	
	/*~[Describe=保存签署的意见;InputParam=无;OutPutParam=无;]~*/
	function saveRecord()
	{
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
				
		as_save("myiframe0");
		var sSvResult = getItemValue(0, 0, "SVRESULT");
		if (sSvResult == "01") {	// 拒绝
			RunMethod("公用方法", "UpdateColValue", "Store_Info,Status,04,SerialNo='<%=sSerialNo%>'");
		} else if (sSvResult == "02") {	// 通过
			RunMethod("公用方法", "UpdateColValue", "Store_Info,Status,03,SerialNo='<%=sSerialNo%>'");
		}
	}
	
	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		
		setItemValue(0, 0, "INPUTORG", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTTIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATETIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	
	/*~[Describe=删除已删除意见;InputParam=无;OutPutParam=无;]~*/
    function deleteRecord()
    {
    	var sSerialNo = RunMethod("公用方法","GetColValue","Flow_Opinion,SerialNo,SerialNo='"+getItemValue(0, 0, "SERIALNO")+"' and OpinionNo='"+getItemValue(0, 0, "OPINIONNO")+"'");
 	    //未签署意见,点击删除给出提示信息后，不进行页面刷新操作
 	    if (sSerialNo!='Null' && confirm("你确实要删除意见吗？")) {
	   		sReturn= RunMethod("公用方法","DelByWhereClause","Flow_Opinion,SerialNo='"+getItemValue(0, 0, "SERIALNO")+"' and OpinionNo='"+getItemValue(0, 0, "OPINIONNO")+"'");
	   		if (sReturn==1){
	    		alert("意见删除成功!");
	  		}else{
	    		alert("意见删除失败！");
	   		}
			reloadSelf();
		}
	} 
		
	/*~[Describe=插入一条新记录;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		//如果没有找到对应记录，则新增一条，并可以设置字段默认值
		if (getRowCount(0)==0) 
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,getRow(),"SERIALNO","<%=sSerialNo%>");
			setItemValue(0,getRow(),"OBJECTTYPE","<%=sObjectType%>");
			setItemValue(0,getRow(),"OBJECTNO","<%=sObjectNo%>");
			setItemValue(0,getRow(), "OPINIONNO", "<%=sObjectNo%>");
			setItemValue(0,0, "ROLID", "<%=sRolIds %>");
			
			setItemValue(0,getRow(),"INPUTORG","<%=CurOrg.orgID%>");
			setItemValue(0,getRow(),"INPUTORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,getRow(),"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"INPUTTIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
			
			//setItemValue(0,getRow(),"UPDATEORG","<%=CurOrg.orgID%>");
			//setItemValue(0,getRow(),"UPDATEORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,getRow(),"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"UPDATETIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
			
			bIsInsert = true;
		}        
		
		setRequireOpinion();
	}
	</script>
<%/*~END~*/%>


<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%@ include file="/IncludeEnd.jsp"%>