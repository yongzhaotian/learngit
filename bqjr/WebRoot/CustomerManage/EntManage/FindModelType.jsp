<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part00;Describe=注释区;]~*/%>
	<%
	/*
		Content: 取得对应的报表类型
		Input Param: sReportNo 报表编号           
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part01;Describe=定义变量，获取参数,逻辑处理;]~*/%>
<%
    //定义变量
	String sReturnValue = "02";//--表示是否为明细附表
	
	//获得页面参数，对象编号 暂时为报表编号
	String sReportNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportNo"));

	//获取财务报表类型
	String sSql = "select MODELNO from REPORT_RECORD  where  ReportNo  =:ReportNo ";
	String sModelno = Sqlca.getString(new SqlObject(sSql).setParameter("ReportNo",sReportNo));	
	if(sModelno == null) sModelno = "";
	
	sSql = "select MODELABBR from REPORT_CATALOG  where  ModelNo  =:ModelNo ";
	String sModelLabbr = Sqlca.getString(new SqlObject(sSql).setParameter("ModelNo",sModelno));	
	if(sModelLabbr == null) sModelLabbr = "";
	
	if(sModelLabbr.equals("报表说明")){
		sReturnValue ="00";
	}else if(sModelLabbr.equals("客户资产与负债明细")){
		sReturnValue ="01";
	}else{
		sReturnValue = sModelno;
	}
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>