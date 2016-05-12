<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 汽车产品管理
		
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
	String PG_TITLE = "汽车产品管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//获得页面参数
	String sComponentName    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("componentName"));	
	String sCurItemID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("curItemID"));	
	if(sComponentName==null) sComponentName=""; 
    if(sCurItemID==null)  sCurItemID="";
    System.out.println(sComponentName+"----------------");
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
		
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "CBusinessTypeList";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//新增模型：2013-5-9
	
	 doTemp.setColumnAttribute("TypeNo,typeName","IsFilter","1");
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
	
	dwTemp.setEvent("BeforeDelete","!ProductManage.DeleteVersionInfo(#TypeNo,V1.0)");//删除版本
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCurItemID);//新增参数传递：2013-5-9
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
		{"true","","Button","新增产品","新增产品记录","newRecord()",sResourcesPath},
		{"true","","Button","产品详情","产品详情","productConfigure()",sResourcesPath}, 
		{"true","","Button","删除产品","删除所选中的记录","deleteRecord()",sResourcesPath}, 
		{"true","","Button","启用","启用产品","enable()",sResourcesPath},
		{"true","","Button","停用","停用产品","disable()",sResourcesPath}, 		
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
		popComp("CBusinessTypeInfo","/BusinessManage/BusinessType/CarLoan/CBusinessTypeInfo.jsp","curItemID=<%=sCurItemID%>","dialogWidth=300px;dialogHeight=360px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
        reloadSelf();
	}
	
	function productConfigure(){
		var sTypeNo =getItemValue(0,getRow(),"TypeNo");
		if (typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert("请至少选择一条记录！");
			return;
		}
    	popComp("CBusinessTypeInfo1","/BusinessManage/BusinessType/CarLoan/CBusinessTypeInfo1.jsp","typeNo="+sTypeNo+"&curItemID=<%=sCurItemID%>","");
    	reloadSelf();
	}
	
	function deleteRecord(){
		var sTypeNo =getItemValue(0,getRow(),"TypeNo");//获取删除记录的单元值
		if (typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			 reloadSelf();
		}
	}
	
	function enable(){
		var sIsInUse =getItemValue(0,getRow(),"IsInUse");
		var sTypeNo =getItemValue(0,getRow(),"TypeNo");
		if(sIsInUse=="启用"){
			alert("该产品已被启用中。。。。");
		}else {
			if(confirm("您真的想启用该产品吗？")){
				RunMethod("Enable","enableAndDisable","1,"+sTypeNo);
				as_save("myiframe0");  //如果单个删除，则要调用此语句
				 reloadSelf();
			}		
		}
	}
	
	function disable(){
		var sIsInUse =getItemValue(0,getRow(),"IsInUse");
		var sTypeNo =getItemValue(0,getRow(),"TypeNo");
		if(sIsInUse=="停用"){
			alert("该产品已被停用。。。。");
		}else {
			if(confirm("您真的想停用该产品吗？")){
				RunMethod("Enable","enableAndDisable","2,"+sTypeNo);
				as_save("myiframe0");  //如果单个删除，则要调用此语句
				 reloadSelf();
			}		
		}
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

