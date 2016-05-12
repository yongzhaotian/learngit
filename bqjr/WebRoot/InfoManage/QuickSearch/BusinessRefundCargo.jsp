<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: 退货申请
		Input Param:
			ObjectType:
			ObjectNo:
			SerialNo：业务流水号
		Output Param:
			SerialNo：业务流水号
		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "退货申请信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sBusinessDate=SystemConfig.getBusinessDate();

	//获得页面参数

	//获得组件参数
	String sSerialNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo")));
	String sCustomerName = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerName")));
	String sBusinessSum = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessSum")));
	System.out.println(sSerialNo+"-------"+sCustomerName+"--------"+sBusinessSum);
	if(sSerialNo == null) sSerialNo = "";
	if(sCustomerName == null) sCustomerName = "";
	if(sBusinessSum == null) sBusinessSum = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	     	
		String sTempletNo = "BusinessRefundCargo"; //模版编号
	    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

		//生成查询框
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		
		
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
		dwTemp.setPageSize(16);  //服务器分页

		//生成HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //查询区的页面代码
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
		{"true","","Button","保存","保存","saveRecord()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; 
	
	/*~[Describe= 保存;InputParam=无;OutPutParam=SerialNo;]~*/
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		as_save("myiframe0",sPostEvents);
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	
	

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		
		setItemValue(0, 0, "inputorgid", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"inputuserid","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"inputdate","<%=sBusinessDate%>");
		bIsInsert = false;
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			setItemValue(0, 0, "serialno", <%=sSerialNo%>);
			setItemValue(0,0,"customername","<%=sCustomerName%>");
			setItemValue(0,0,"businesssum","<%=sBusinessSum%>");
			setItemValue(0, 0, "inputorgid", "<%=CurOrg.orgID %>");
			setItemValue(0,0,"inputuserid","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"inputdate","<%=sBusinessDate%>");
	
			bIsInsert = true;
		}
	} 
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});

</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
