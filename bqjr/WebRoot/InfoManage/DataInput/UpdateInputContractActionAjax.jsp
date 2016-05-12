<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.8
		Tester:
		Content: ��ͬ�������ݴ���
		Input Param:
			                BusinessType:ҵ��Ʒ��
			                SerialNo:��ͬ��ˮ��
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>��ͬ�������ݴ���</title>
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