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
	String PG_TITLE = "保险公司产品配置"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
		
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "InsuranceCommpayList";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//新增模型：2013-5-9
	
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
		{"true","","Button","详情","详情","myDetail()",sResourcesPath},	
		//{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
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
		var sSerialNo=getSerialNo("Service_Providers", "SerialNo", "");
		var sFlag="Add";
		AsControl.OpenView("/BusinessManage/BusinessType/InsuranceCommpayInfo.jsp","SerialNo="+sSerialNo+"&sFlag="+sFlag,"_blank");
		reloadSelf();
	}
	
	function deleteRecord(){
		var sSerialNo =getItemValue(0,getRow(),"SerialNo");//获取删除记录的单元值
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			RunMethod("DeleteNumber","GetDeleteNumber1","InsuranceCity_Info,InsuranceNo='"+sSerialNo+"'");
			reloadSelf();
		}
	}
	function myDetail(){
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		var sSerialNo =getItemValue(0,getRow(),"SerialNo");//获取删除记录的单元值
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		AsControl.OpenView("/BusinessManage/BusinessType/InsuranceCommpayDetail.jsp","SerialNo="+sSerialNo,"_blank");		
		reloadSelf();
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

