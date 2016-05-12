<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 用款记录列表
		
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
	String PG_TITLE = "费用维护"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
		
	//获得页面参数,产品编号
	String sTypeNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("typeNo"));
	if(sTypeNo == null) sTypeNo = "";
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "CostType1";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//新增模型：2013-5-9
	 if(!sTypeNo.equals("")){
		 doTemp.multiSelectionEnabled=true;
	 }
	 doTemp.setColumnAttribute("costNo,feeType","IsFilter","1");
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
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
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
		};
	if(!sTypeNo.equals("")){
		sButtons[0][3]="确定";
		sButtons[0][4]="确定";
		sButtons[0][5]="determine()";
		sButtons[1][3]="取消";
		sButtons[1][4]="取消";
		sButtons[1][5]="doCancel()";
		sButtons[2][0]="false";
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
		sCompID = "CostType";
		sCompURL = "/BusinessManage/Products/CostTypeInfo.jsp";
	    popComp(sCompID,sCompURL," ","dialogWidth=320px;dialogHeight=430px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();
	}
	
	function myDetail(){
		var sSerialNo =getItemValue(0,getRow(),"serialNo");
		var sFeeType =getItemValue(0,getRow(),"feeType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请至少选择一条记录！");
			return;
		}else{
			AsControl.OpenView("/BusinessManage/Products/CostTypeDetailInfo.jsp","serialNo="+sSerialNo+"&feeType="+sFeeType,"_self");
			
		}
	}
	
	function deleteRecord(){
		var sSerialNo =getItemValue(0,getRow(),"serialNo");//获取删除记录的单元值
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			 reloadSelf();
		}
	}
	
	function determine(){
		var sSerialNo = getItemValueArray(0,"serialNo");
		var temp="";//记录费用代码
		var flag=true;
		for(var i=0;i<sSerialNo.length;i++){
			var count= RunMethod("Unique","uniques","businessType_Cost,count(1),costNo='"+sSerialNo[i]+"' and busTypeID=<%=sTypeNo%>");
			if(count>="1.0"){
				 temp=temp+sSerialNo[i]+",";
				 flag=false;
			 }
		}
		if(flag&&sSerialNo!=""){
			for(var i=0;i<sSerialNo.length;i++){
				 RunMethod("BusinessTypeRelative","InsertBusRelative","businessType_Cost,busTypeCostID,busTypeID,costNo,"+getSerialNo("businessType_Cost", "busTypeCostID", " ")+",<%=sTypeNo%>,"+sSerialNo[i]);
			}
			alert("导入成功！！！");
			top.close();
		}else if(sSerialNo!=""){
			alert("你选择中有已存在记录！请重新选择！谢谢！");
		}else{
			alert("你没有选择记录，不能导入！请选择！");
		}		
		
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

