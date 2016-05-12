<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 经销商信息管理
		
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
	String PG_TITLE = "经销商信息管理 "; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得页面参数
	String sTemp = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("temp"));	   
	String sTypeNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("typeNo"));
	if(sTypeNo==null) sTypeNo="";	
	if(sTemp==null) sTemp="";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
			
	 ASDataObject doTemp = null;
	 String sTempletNo = "DistributorList";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//新增模型：2013-5-9
	 if(sTemp.equals("3")){
		 doTemp.multiSelectionEnabled=true;
	 }
	 doTemp.setColumnAttribute("distributorName,distributorType","IsFilter","1");
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
	//生成HTMLDataWindow
	Vector vTemp=null;
	if(sTemp.equals("3")){
		vTemp = dwTemp.genHTMLDataWindow(sTypeNo);//新增参数传递：2013-5-9
	}else{
		 vTemp = dwTemp.genHTMLDataWindow("");//新增参数传递：2013-5-9
	}
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
		{"true","","Button","新增经销商","新增经销商","newRecord()",sResourcesPath},
		{"true","","Button","查看/修改经销商详情","查看/修改经销商详情","modifyDetail()",sResourcesPath},	
		{"true","","Button","文件上传和扫描","文件上传和扫描","d()",sResourcesPath},
		{"true","","Button","经销商启用","经销商启用","enable()",sResourcesPath},
		};
	 if(sTemp.equals("2")){
		sButtons[0][3]="确定";
		sButtons[0][4]="确定";
		sButtons[0][5]="determine1()";
		sButtons[1][3]="取消";
		sButtons[1][3]="取消";
		sButtons[1][5]="doCancel()";
		sButtons[2][0]="false";
		sButtons[3][0]="false";
	}else if (sTemp.equals("3")){
		sButtons[0][3]="确定";
		sButtons[0][4]="确定";
		sButtons[0][5]="determine2()";
		sButtons[1][3]="取消";
		sButtons[1][3]="取消";
		sButtons[1][5]="doCancel()";
		sButtons[2][0]="false";
		sButtons[3][0]="false";
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	function newRecord(){
		OpenPage("/DistributorInfo/DistributorInfo.jsp","_self","");
	}
 
	function determine1(){
		var sCustomerID =getItemValue(0,getRow(),"serialNo");
		var sEntErpriseName =getItemValue(0,getRow(),"entErpriseName");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("请选择一个经销商！");
			return;
		}	
	   	window.close();
	}
	
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	
	function determine2(){
		var sCustomerID = getItemValueArray(0,"serialNo");	
		var temp="";//记录费用代码
		var flag=true;
		for(var i=0;i<sCustomerID.length;i++){
			var count= RunMethod("Unique","uniques","businessType_Car,count(1),customerID='"+sCustomerID[i]+"' and busTypeID=<%=sTypeNo%>");
			if(count>="1.0"){
				 temp=temp+sCustomerID[i]+",";
				 flag=false;
			 }
		}
		if(flag&&sCustomerID!=""){
			for(var i=0;i<sCustomerID.length;i++){
				 RunMethod("BusinessTypeRelative","InsertBusRelative","businessType_Car,busTypeCarID,busTypeID,customerID,"+getSerialNo("businessType_Car", "busTypeCarID", " ")+",<%=sTypeNo%>,"+sCustomerID[i]);
			}
			alert("导入成功！！！");
			top.close();
		}else if(sCustomerID!=""){
			alert("你选择的中有已存在记录！请重新选择！谢谢！");
		}else{
			alert("你没有选择记录，不能导入！请选择！");
		}		
	}
	
	function modifyDetail(){
		var sSerialNo =getItemValue(0,getRow(),"serialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/DistributorInfo/DistributorDetail.jsp","serialNo="+sSerialNo,"_blank");
		reloadSelf();
	}
	
	function enable(){
		var sSerialNo =getItemValue(0,getRow(),"serialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		if(confirm("您真的启用该经销商吗？")){
			RunMethod("ModifyNumber","GetModifyNumber","Service_Providers,distributorStaus='02',serialNo='"+sSerialNo+"'");
		}
		reloadSelf();
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

