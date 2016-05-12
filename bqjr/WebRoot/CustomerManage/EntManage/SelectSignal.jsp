<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xuzhang 2005-1-21
		Tester:
		Describe:选择新增预警信号风险提示;
		Input Param:
			CustomerID：客户编号
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "选择风险提示信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%
	String sCustomerID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	//out.println(sCustomerID);
	//设置表头
	String sHeaders[][] = {{"signalName","风险信号名称"}};
	//取得用户未选择的风险提示类型列表
	String sSql="select itemname as signalName ,itemno as SignalType from code_library where codeno='AlertSignal'"+
				" and itemno not in ("+
				" select Signaltype from risk_signal where objectNo='"+sCustomerID+"')";
	//通过sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.setHTMLStyle("signalName"," style={width:400px} ");
	doTemp.setVisible("SignalType",false);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));



	String sCriteriaAreaHTML = ""; //查询区的页面代码


%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件下一步
		//6.资源图片路径

	String sButtons[][] = {
		{"true","","Button","选择","选择一条预警信息","Next_Step()",sResourcesPath},
		//{"true","","Button","取消","取消","Cancel()",sResourcesPath},
		};
	%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<script type="text/javascript">
	function Next_Step()
	{
		sRecordNo = getItemValue(0,getRow(),"SignalType");
		if (typeof(sRecordNo) != "undefined" && sRecordNo != "" )
		{
			returnValue=sRecordNo;
			self.close();
		}
		else
		{
			alert("请选择一条预警信息");
		}
	}
	/*
	function Cancel()
	{
		if(confirm("你确认要取消添加操作吗？"))
		{
			OpenComp("SignalList","/CustomerManage/EntManage/CustomerSignalList.jsp","CustomerID=<%=sCustomerID%>","_self");
		}
	}*/
</script>

<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>

<%@ include file="/IncludeEnd.jsp"%>

