<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.2
		Tester:
		Content: 客户信息检查
		Input Param:
			                
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	String sReturnValue="";
	String sActionType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ActionType"));
	String sSerialNo   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	
	//out.println("sSerialNo:"+sSerialNo);
	if(sActionType.equals("Delete"))
	{		
		Sqlca.executeSQL(new SqlObject("delete from RISK_SIGNAL where SerialNo=:SerialNo").setParameter("SerialNo",sSerialNo));
		sReturnValue="ok";
	}
	else if(sActionType.equals("Add"))
	{
		String sRemark = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Remark"));
		String sSignalStatus = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SignalStatus"));

		String Today=StringFunction.getToday();

		String sSql="update RISK_SIGNAL set InputOrgID=:InputOrgID,InputUserID=:InputUserID,InputDate=:InputDate,UpdateDate=:UpdateDate,Remark=:Remark,SignalStatus=:SignalStatus"+
		" where SerialNo=:SerialNo";
		SqlObject so=new SqlObject(sSql);
		so.setParameter("InputOrgID",CurUser.getOrgID());
		so.setParameter("InputUserID",CurUser.getUserID());
		so.setParameter("InputDate",Today);
		so.setParameter("UpdateDate",Today);
		so.setParameter("Remark",sRemark);
		so.setParameter("SignalStatus",sSignalStatus);
		so.setParameter("SerialNo",sSerialNo);
		Sqlca.executeSQL(so);
		sReturnValue="ok";
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