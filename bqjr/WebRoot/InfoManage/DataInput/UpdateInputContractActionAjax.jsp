<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.8
		Tester:
		Content: 合同补登数据处理
		Input Param:
			                BusinessType:业务品种
			                SerialNo:合同流水号
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>合同补登数据处理</title>
<%
	String sSql;
	SqlObject so = null;
	String sSerialNo="",sBusinessType="",sReturnValue="";	
	ASResultSet rs = null;
	sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));	
	sBusinessType = DataConvert.toRealString(iPostChange,(String)request.getParameter("BusinessType"));	
	String sToday = StringFunction.getToday();
	try{
		sSql = 	" Update BUSINESS_CONTRACT set BusinessType =:BusinessType,"+
				" InputDate =:InputDate, "+		
				" InputOrgID =:InputOrgID, "+
				" InputUserID =:InputUserID, "+
				" UpdateDate =:UpdateDate, "+
				" PigeonholeDate =:PigeonholeDate "+
				" where SerialNo =:SerialNo";
		so = new SqlObject(sSql).setParameter("BusinessType",sBusinessType)
		.setParameter("InputDate",StringFunction.getToday()).setParameter("InputOrgID",CurOrg.getOrgID())
		.setParameter("InputUserID",CurUser.getUserID()).setParameter("UpdateDate",sToday)
		.setParameter("PigeonholeDate",sToday).setParameter("SerialNo",sSerialNo);
		Sqlca.executeSQL(so);
		sReturnValue="succeed";
	}catch(Exception e){
		e.fillInStackTrace();
	}
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