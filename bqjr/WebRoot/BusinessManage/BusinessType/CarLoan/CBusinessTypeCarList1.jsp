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
	String PG_TITLE = "新增该产品下的车型"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//获得页面参数
    String sTypeNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("typeNo"));
    if(sTypeNo==null) sTypeNo="";
    System.out.println(sTypeNo+"----------------");
%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sHeaders[][] = { 							
			{"StatisticDate","统计日期"},
			{"modelsID","车型编号"},
			{"modelsBrand","品牌"},
			{"modelsSeries","系列"},
			{"carModel","汽车型号"},
			{"carModelCode","汽车型号代码"},
			{"bodyType","车身类型"},
			{"manufacturers","生产厂商"},
			{"salesStartTime","生产/销售起始时间"},
			{"engineSize","发动机排量"},										
			{"color","颜色"},
			{"price","车辆出厂价"},
			{"inputOrg","登记机构"},
			{"inputTime","登记时间"},
			{"inputUser","登记人"},
			{"updateOrg","更新机构"},
			{"updateTime","更新时间"},
			{"updateUser","更新人"}
		   }; 

	String sSql ="select modelsID,modelsBrand,modelsSeries,carModel,carModelCode,bodyType,manufacturers,salesStartTime,"
			     +"engineSize,color,price,inputOrg,inputTime,inputUser,updateOrg,updateTime,updateUser from car_model_info ";
		
	 ASDataObject doTemp = null;
	 doTemp = new ASDataObject(sSql);//新增模型：2013-5-9
	 doTemp.setHeader(sHeaders);	
	 doTemp.multiSelectionEnabled=true;
	 doTemp.setKey("modelsID", true);
	 doTemp.setHTMLStyle("modelsID", "style={width:50px}");
	 doTemp.setHTMLStyle("modelsBrand,modelsSeries,carModel,carModelCode", "style={width:100px}");
	 doTemp.setHTMLStyle("bodyType,manufacturers,salesStartTime,engineSize,color", "style={width:100px}");
	 doTemp.setColumnAttribute("modelsID,modelsBrand","IsFilter","1");
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
			{"true","","Button","确认","确认","doCreation()",sResourcesPath},
			{"true","","Button","取消","取消","doCancel()",sResourcesPath}	
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
	function doCreation() {
		
		saveRecord("doReturn()");
		
	}
	function saveRecord(sPostEvents)
	{		
		var sModelsID = getItemValueArray(0,"modelsID");	
		var temp="";//记录费用代码
		var flag=true;
		for(var i=0;i<sModelsID.length;i++){
			var count= RunMethod("Unique","uniques","businessType_Car,count(1),carID='"+sModelsID[i]+"' and busTypeID=<%=sTypeNo%>");
			if(count>="1.0"){
				 temp=temp+sModelsID[i]+",";
				 flag=false;
			 }
		}
		if(flag&&sModelsID!=""){
			for(var i=0;i<sModelsID.length;i++){
				 RunMethod("BusinessTypeRelative","InsertBusRelative","businessType_Car,busTypeCarID,busTypeID,carID,"+getSerialNo("businessType_Car", "busTypeCarID", " ")+",<%=sTypeNo%>,"+sModelsID[i]);
			}
			alert("导入成功！！！");
			self.close();
			top.close();
		}else if(sModelsID!=""){
			alert("你选择的中有已存在记录！请重新选择！谢谢！");
		}else{
			alert("你没有选择记录，不能导入！请选择！");
		}	
	}
	
	function doReturn(){
		top.close();
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

