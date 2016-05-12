<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.2
		Tester:
		Content: �ͻ���Ϣ���
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

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>