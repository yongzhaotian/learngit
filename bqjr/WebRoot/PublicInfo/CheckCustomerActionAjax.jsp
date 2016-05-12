<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zywei 2006-08-11
		Tester:
		Describe:
			检查客户是否已经建立信贷关系

		Input Param:					
			CertType: 证件类型
			CertID:证件号码
		Output Param:
			Message: 返回关联客户编号RelativeID 如果为空则表示检查不通过,并提示消息
		HistoryLog:
	*/
	%>
<%/*~END~*/%>

<%
	//获取页面参数	
	String sCertType = DataConvert.toRealString(iPostChange,CurPage.getParameter("CertType"));
	String sCertID = DataConvert.toRealString(iPostChange,CurPage.getParameter("CertID"));
	
	//定义变量
	String sRelativeID = "";
	String sSql = "";
	SqlObject so = null;
	String sMessage = "";	
	ASResultSet rs = null;
	
	//根据证件类型和证件编号，或客户名称获取客户编号
	sSql = 	" select CustomerID from CUSTOMER_INFO "+
			" where CertType =:CertType "+
			" and CertID =:CertID ";
	so = new SqlObject(sSql).setParameter("CertType",sCertType).setParameter("CertID",sCertID);
	rs = Sqlca.getResultSet(so);
	if (rs.next())
		sRelativeID = rs.getString("CustomerID");
	rs.getStatement().close();
	
	if(sRelativeID == null || sRelativeID.equals(""))
		sRelativeID = DBKeyHelp.getSerialNo("CUSTOMER_INFO","CustomerID",Sqlca);		
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sRelativeID);
	sRelativeID = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sRelativeID);
%>
<%/*~END~*/%>

<%@	include file="/IncludeEndAJAX.jsp"%>