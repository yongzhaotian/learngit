<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content: 代码项目信息详情
		Input Param:
                    FunctionID：    代码表编号
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
	String sSortNo; //排序编号
	
	//获得组件参数	
	String sFunctionID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FunctionID"));
	if(sFunctionID==null) sFunctionID="";

%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
   	String sHeaders[][] = {
				{"FunctionID","代码ID"},
				{"CompID","组件ID"},
				{"PageID","页面ID"},
				{"FunctionName","代码名称"},
				{"RightID","权限ID"},
				{"TargetComp","源组件"},
				{"InfoRightType","InfoRightType"},
				{"DefaultForm","DefaultForm"},
				{"TargetPage","TargetPage"},
				{"Remark","备注"},
				{"InputUserName","输入人"},
				{"InputUser","输入人"},
				{"InputOrgName","输入机构"},
				{"InputOrg","输入机构"},
				{"InputTime","输入时间"},
				{"UpdateUserName","更新人"},
				{"UpdateUser","更新人"},
				{"UpdateTime","更新时间"}
			       };  

	sSql = " Select  "+
				"FunctionID,"+
				"CompID,"+
				"PageID,"+
				"FunctionName,"+
				"RightID,"+
				"TargetComp,"+
				"InfoRightType,"+
				"DefaultForm,"+
				"TargetPage,"+
				"Remark,"+
				"getUserName(InputUser) as InputUserName,"+
				"InputUser,"+
				"getOrgName(InputOrg) as InputOrgName,"+
				"InputOrg,"+
				"InputTime,"+
				"getUserName(UpdateUser) as UpdateUserName,"+
				"UpdateUser,"+
				"UpdateTime "+
				"From REG_FUNCTION_DEF Where FunctionID = '"+sFunctionID+"'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="REG_FUNCTION_DEF";
	doTemp.setKey("FunctionID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("FunctionID"," style={width:160px} ");
	doTemp.setHTMLStyle("CompID"," style={width:160px} ");
	doTemp.setHTMLStyle("PageID"," style={width:160px} ");
	doTemp.setHTMLStyle("FunctionName"," style={width:160px} ");
	doTemp.setHTMLStyle("RightID"," style={width:160px} ");
	doTemp.setHTMLStyle("TargetComp"," style={width:160px} ");
	doTemp.setHTMLStyle("InfoRightType"," style={width:160px} ");
	doTemp.setHTMLStyle("DefaultForm"," style={width:160px} ");
	doTemp.setHTMLStyle("TargetPage"," style={width:160px} ");

	doTemp.setHTMLStyle("InputUser,UpdateUser"," style={width:160px} ");
	doTemp.setHTMLStyle("InputOrg"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	doTemp.setReadOnly("InputUserName,InputOrgName,UpdateUserName,InputTime,UpdateTime",true);
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);
  	doTemp.setVisible("InputUser,UpdateUser,InputOrg",false);    	

 	doTemp.setEditStyle("PageID,TargetPage,Remark","3");
	doTemp.setHTMLStyle("PageID,TargetPage,Remark"," style={height:100px;width:600px;overflow:auto} ");
			
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
		// Del by wuxiong 2005-02-22 因返回在TreeView中会有错误 {"true","","Button","返回","返回代码列表","doReturn('N')",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
    var sCurFunctionID=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
	        as_save("myiframe0","doReturn('Y');");
	}
    
	/*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
	function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"FunctionID");
	        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
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
