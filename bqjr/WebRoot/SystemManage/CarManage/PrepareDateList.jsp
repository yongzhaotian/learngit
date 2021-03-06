<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 数据准备规则
		
		Input Param:
		SerialNo:流水号
		ObjectType:对象类型
		ObjectNo：对象编号
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "数据准备规则"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sDataType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DataType"));
	String sSceneId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SceneId"));
	if(sDataType==null) sDataType="";
	if(sSceneId==null) sSceneId="";
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "";
	 if(sDataType.equals("01")){
		 sTempletNo = "PrepareDateList";
	 }else{
		 sTempletNo = "AfterDataList";
	 }
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//新增模型：2013-5-9
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 
	 doTemp.WhereClause += " and SceneId = '"+sSceneId+"' ";
	 
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//新增参数传递：2013-5-9
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
		{"true","","Button","新增","新增提款记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","详情记录","myDetail()",sResourcesPath},	
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		AsControl.OpenView("/SystemManage/CarManage/PrepareDateInfo.jsp","DataType="+"<%=sDataType%>"+"&SceneId="+"<%=sSceneId%>","_self");
	}
	
	function deleteRecord(){
		var sItemName =getItemValue(0,getRow(),"ITEMNAME");//获取删除记录的单元值
		if (typeof(sItemName)=="undefined" || sItemName.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			 reloadSelf();
		}
	}
	function myDetail(){
		sItemName=getItemValue(0,getRow(),"ITEMNAME");	
		if(typeof(sItemName)=="undefined" || sItemName.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		AsControl.OpenView("/SystemManage/CarManage/PrepareDateInfo.jsp","ItemName="+sItemName+"&DataType=<%=sDataType%>&SceneId="+"<%=sSceneId%>","_self");		
	}
	
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>

