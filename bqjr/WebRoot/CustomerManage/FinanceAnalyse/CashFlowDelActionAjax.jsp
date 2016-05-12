<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<% 
	/*
		Author: 
		Tester:
		Describe: 现金流预测
		Input Param:
			CustomerID ： 当前客户编号
			BaseYear   : 基准年份:距离现在最近的一年  
			YearCount  : 预测年数:default=1
			ReportScope: 报表口径	           
		Output Param:
			
		HistoryLog:
		DATE	CHANGER		CONTENT
		2005-7-22 fbkang    新的版本的改写
	 */
%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户现金流测算"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
    //定义变量
    //获得页面参数
 	String sCustomerID = DataConvert.toRealString(CurPage.getParameter("CustomerID"));
	String sBaseYear = DataConvert.toRealString(CurPage.getParameter("BaseYear"));
	String sYearCount = DataConvert.toRealString(CurPage.getParameter("YearCount"));
	String sReportScope = DataConvert.toRealString(CurPage.getParameter("ReportScope"));
	SqlObject so = null;
	String sNewSql = "";			

	String sReturnValue="";
    //获得组件参数

%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=执行SQL语句;]~*/%>

<%
	try{
		sNewSql = "delete from CashFlow_Parameter where CustomerID = :CustomerID and BaseYear = :BaseYear and ReportScope=:ReportScope";
		so = new SqlObject(sNewSql);
		so.setParameter("CustomerID",sCustomerID);
		so.setParameter("BaseYear",sBaseYear);
		so.setParameter("ReportScope",sReportScope);
		Sqlca.executeSQL(so);
		sNewSql = "delete from CashFlow_Data where CustomerID = :CustomerID and BaseYear = :BaseYear and ReportScope=:ReportScope and FCN = :FCN ";
		so = new SqlObject(sNewSql);
		so.setParameter("CustomerID",sCustomerID);
		so.setParameter("BaseYear",sBaseYear);
		so.setParameter("ReportScope",sReportScope);
		so.setParameter("FCN",sYearCount);
		Sqlca.executeSQL(so);
		sNewSql = "delete from CashFlow_Record where CustomerID = :CustomerID and BaseYear = :BaseYear and ReportScope=:ReportScope and FCN = :FCN ";
		so = new SqlObject(sNewSql);
		so.setParameter("CustomerID",sCustomerID);
		so.setParameter("BaseYear",sBaseYear);
		so.setParameter("ReportScope",sReportScope);
		so.setParameter("FCN",sYearCount);
		Sqlca.executeSQL(so);
		sReturnValue = "succeed";	
	}catch(Exception e){
		e.fillInStackTrace();
		sReturnValue="failed";
	}
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>
