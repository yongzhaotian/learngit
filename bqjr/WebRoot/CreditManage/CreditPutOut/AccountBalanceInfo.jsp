<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cchang 2004-12-07
		Tester:
		Describe: 业务余额信息;
		Input Param:
			SerialNo:流水号
		Output Param:
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "业务余额信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";

	//获得组件参数
	
	//获得页面参数
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sSerialNo==null) sSerialNo="";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sHeaders[][] = { {"SerialNo","合同流水号"},
	                        {"ArtificialNo","合同编号"},
							{"CustomerName","客户名称"},
							{"CustomerID","客户代码"},
							{"Currency","币种"}, 
							{"BusinessSum","合同金额(元)"},
							{"ActualPutOutSum","实际发放金额(元)"},                           
							{"Balance","余额(元)"}, 
							{"NormalBalance","正常余额(元)"},			
							{"OverDueBalance","逾期余额(元)"}, 
							{"DullBalance","呆滞余额(元)"},  
							{"BadBalance","呆帐余额(元)"},                          
			                {"InterestBalance1","表内欠息(元)"},
			                {"InterestBalance2","表外欠息(元)"}
			       };

	sSql = 	" select SerialNo,ArtificialNo,CustomerName,CustomerID,"+
			" getItemName('Currency',BusinessCurrency) as Currency,BusinessSum,"+
			" ActualPutOutSum,Balance,NormalBalance,OverDueBalance,"+
	   		" DullBalance,BadBalance,InterestBalance1,InterestBalance2 "+
	    	" from BUSINESS_CONTRACT where SerialNo='"+sSerialNo+"'  ";


	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "BUSINESS_CONTRACT";
	doTemp.setHeader(sHeaders);
	doTemp.setKey("SerialNo",true);

	doTemp.setAlign("BusinessSum,ActualPutOutSum,Balance,NormalBalance,OverDueBalance,DullBalance,BadBalance,InterestBalance1,InterestBalance2","3");
	doTemp.setCheckFormat("BusinessSum,ActualPutOutSum,Balance,NormalBalance,OverDueBalance,DullBalance,BadBalance,InterestBalance1,InterestBalance2","2");
	doTemp.setHTMLStyle("ArtificialNo"," style={width:180px} ");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
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
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	function initRow()
	{
    }
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

