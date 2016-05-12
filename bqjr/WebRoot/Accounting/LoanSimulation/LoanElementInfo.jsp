<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  	ttyu 2013.8.26
		Tester:
		Content: 贷款概要信息
		Input Param:
			productID： 产品编号
			productVersion：产品版本
		Output param:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "贷款咨询"; 
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String displayTemplet = "LoanElementInfo";
	ASDataObject doTemp = new ASDataObject(displayTemplet,Sqlca);
	//生成DataWindow对象
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="2";
	
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
		{"true","All","Button","生成还款计划","生成还款计划","makePlan()","","","",""},
		{"true","All","Button","保存还款计划","保存还款计划","as_save(0)","","","",""},
		{"true","All","Button","导出Execl","导出Execl","as_save(0)","","","",""}
	};
	%> 
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
<script language=javascript>
	function makePlan(){
		var sBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		var sRateYear = getItemValue(0,getRow(),"RateYear");
		var sRepayFrequency = getItemValue(0,getRow(),"RepayFrequency");
		var sPutOutDate = getItemValue(0,getRow(),"PutOutDate");
		var sTermMonth = getItemValue(0,getRow(),"TermMonth");
		var sFirstRepaymentDate = getItemValue(0,getRow(),"FirstRepaymentDate");
		
		var sParam = "BusinessSum="+sBusinessSum+"&RateYear="+sRateYear+"&RepayFrequency="+sRepayFrequency+"&PutOutDate="+sPutOutDate+"&TermMonth="+sTermMonth+"&FirstRepaymentDate="+sFirstRepaymentDate;
		AsControl.OpenView("/Accounting/LoanSimulation/LoanPlanInfo.jsp",sParam,"rightdown","");
	}
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0){ //如果没有找到对应记录，则新增一条，并设置字段默认值
			as_add("myiframe0");//新增记录
		}
    }
</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	bCheckBeforeUnload=false;
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>