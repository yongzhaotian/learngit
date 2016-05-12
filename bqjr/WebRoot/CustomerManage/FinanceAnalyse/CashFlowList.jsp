<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<% 
	/*
		Author: jbye  2004-12-16 20:15
		Tester:
		Describe: --显示客户相关的现金流预测
		Input Param:
			CustomerID： --当前客户编号
		Output Param:
			CustomerID： --当前客户编号
		HistoryLog:
		DATE	CHANGER		CONTENT
		2005-7-22 fbkang    新的版本的改写
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "现金流预测信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
     String sCustomerID = "";
     String sFinanceBelong = "";
	//获得组件参数
	sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	//获得页面参数
%>
<%/*~END~*/%>


<%
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CashFlowList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
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
			{"true","All","Button","新增预测","新增现金流预测记录","addRecord()",sResourcesPath},
			{"true","All","Button","删除预测","删除现金流预测记录","delRecord()",sResourcesPath},
			{"true","","Button","查看预测","查看现金流预测记录","viewRecord()",sResourcesPath},
		   };
	%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	var sMDStyle = "dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no";
	function addRecord(){
		var vReturn = PopPage("/CustomerManage/FinanceAnalyse/CashFlowAddTerm.jsp?CustomerID=<%=sCustomerID%>","","dialogWidth=20;dialogHeight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(vReturn == "_none_" || typeof(vReturn) == "undefined")
			return;
			   
		OpenPage("/CustomerManage/FinanceAnalyse/CashFlowAddAction.jsp?CustomerID=<%=sCustomerID%>&"+vReturn+"","_self","");
	}

	function delRecord(){
		sUserID=getItemValue(0,getRow(),"UserID");
		var vBaseYear = getItemValue(0,getRow(),"BaseYear");
		var vYearCount = getItemValue(0,getRow(),"FCN");
		var vReportScope = getItemValue(0,getRow(),"ReportScope");

		if(vBaseYear == "" || typeof(vBaseYear) == "undefined"){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else if(sUserID=='<%=CurUser.getUserID()%>'){
    		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
    		{
				var sReturn=PopPageAjax("/CustomerManage/FinanceAnalyse/CashFlowDelActionAjax.jsp?ReportScope="+vReportScope+"&CustomerID=<%=sCustomerID%>&BaseYear="+vBaseYear+"&YearCount="+vYearCount+"&rand="+randomNumber(),"_self","");
				if(typeof(sReturn)!="undefined" && sReturn=="succeed"){
					alert(getBusinessMessage('187'));//现金流预测记录删除完毕！
					reloadSelf();
				}else{
					alert("现金流预测记录删除失败！");
				}
				
            }
    	}else 
    		alert(getHtmlMessage('3'));
	}

	function viewRecord(){
		var vBaseYear = getItemValue(0,getRow(),"BaseYear");
		var vYearCount = getItemValue(0,getRow(),"FCN");
		var vReportScope = getItemValue(0,getRow(),"ReportScope");
		if(vBaseYear == "" || typeof(vBaseYear) == "undefined"){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		OpenPage("/CustomerManage/FinanceAnalyse/CashFlowDetail.jsp?ReportScope="+vReportScope+"&CustomerID=<%=sCustomerID%>&BaseYear="+vBaseYear+"&YearCount="+vYearCount+"&rand="+randomNumber(),"_self");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

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
