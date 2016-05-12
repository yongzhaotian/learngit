<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   jbye  2004-12-20 9:14
		Tester:
		Content: 判断对应的报表日期是否存在
		Input Param:
			                
		Output param:
		History Log: 
			利用改造过的类一次性新增或删除一套报表
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "报表更新操作判断"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%
    //定义变量
	String sSql = "",sObjectNo = "",sReportDate = "",sReportScope = "",sReturnValue = "pass";
	ASResultSet rs = null;
	//获得组件参数
	//对象编号 暂时为客户号
	sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	//获得页面参数
	sReportDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportDate"));
	sReportScope = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportScope"));
	//将空值转化为空字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sReportScope == null) sReportScope = "";
	if(sReportDate == null)	sReportDate = "";
	
	//查询当前新增的财务报表是否重复
	
	sSql = 	" select RecordNo from CUSTOMER_FSRECORD "+
			" where CustomerID = :CustomerID "+			
			" and ReportDate = :ReportDate "+
			" and ReportScope = :ReportScope ";

	rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("CustomerID",sObjectNo).setParameter("ReportDate",sReportDate).setParameter("ReportScope",sReportScope));
	if(rs.next())
	{
		sReturnValue = "refuse";
	}
	rs.getStatement().close();
	//out.println(sSql);
%>

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