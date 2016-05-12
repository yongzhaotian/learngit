<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: 退款查询
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
	String PG_TITLE = "退款查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数

	//获得组件参数
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));

	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = { 
			{"serialno","流水号"},
			{"oldcustomerid","客户号"},
			{"newcontractno","推荐合同号"},
			{"putoutdate","新合同出账日期"},
			{"plannedawardamount","计划奖励金额"},
			{"awardresult","奖励结果"},
			{"actualawardamount","实际奖励金额"},
			{"failurecause","失败原因"},
			{"awarddate","更新奖励结果日期"}
		};
	String sql = "select serialno,oldcustomerid,newcontractno,putoutdate,plannedawardamount,awardresult,actualawardamount,failurecause,awarddate " 
				+ " from customer_recommend_result crr "
				+ " where crr.oldcustomerid='"+sCustomerID+"' ";
	ASDataObject doTemp = new ASDataObject(sql);
	doTemp.setHeader(sHeaders);
	doTemp.setVisible("serialno", false);
	doTemp.setDDDWCodeTable("awardresult", "1,成功,2,失败");
	doTemp.setAlign("plannedawardamount,actualawardamount","3");
	doTemp.setCheckFormat("plannedawardamount,actualawardamount","2");
	doTemp.setAlign("putoutdate,awarddate","2");
	doTemp.setCheckFormat("putoutdate,awarddate","3");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为可写
	dwTemp.setPageSize(500);
	
	//生成datawindow
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
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=交易详情;InputParam=无;OutPutParam=无;]~*/
	
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
