<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.util.Date" %>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: slliu 2005-03-04
		Tester:
		Describe: 获得两个日期之间的天数
		Input Param:
			
		Output Param:
		HistoryLog:
	 */
	%>
<%/*~END~*/%>

<%
		//合同到期日、贴现日期
		String sMaturity = DataConvert.toRealString(iPostChange,(String)request.getParameter("Maturity"));
		String sFinishDate = DataConvert.toRealString(iPostChange,(String)request.getParameter("FinishDate"));
		String sReturnValue="";
		
		java.util.Calendar sDate = java.util.Calendar.getInstance();
		java.util.Calendar eDate = java.util.Calendar.getInstance();
		String tmpDay = "";

		int year;
		int month;
		int day;

		tmpDay = sFinishDate;

		year = Integer.parseInt(tmpDay.substring(0, 4));
		month = Integer.parseInt(tmpDay.substring(5, 7));
		day = Integer.parseInt(tmpDay.substring(8, 10));
		month -= 1;
		sDate.set(year, month, day, 0, 0, 0);

		tmpDay = sMaturity;
		year = Integer.parseInt(tmpDay.substring(0, 4));
		month = Integer.parseInt(tmpDay.substring(5, 7));
		day = Integer.parseInt(tmpDay.substring(8, 10));
		

		month -= 1;
		eDate.set(year, month, day, 0, 0, 0);

		day =
			(int) ((eDate.getTime().getTime() - sDate.getTime().getTime())
				/ 1000
				/ 3600
				/ 24);
		
%>
 
 <%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(day+"");
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@	include file="/IncludeEndAJAX.jsp"%>