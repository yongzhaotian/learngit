<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
		Content:  
		Input Param:
			      DegbugFlag : ���Ա�־��0 ������ʾ������Ϣ 1����ʾ������Ϣ          
	 */
	//��ȡSerialNo�б�
	String sSerialNoArray = CurPage.getParameter("SerialNoArray");
	String sSql = "",sMsg = "",sReturnValue="";
	SqlObject so = null;
	String sNewSql = "";	
	if (sSerialNoArray==null) sSerialNoArray="000";
	
	try{
		sSerialNoArray = StringFunction.replace(sSerialNoArray,",","','");
		sNewSql = " delete from Trade_Log where SerialNo in ("+sSerialNoArray+")";
		so = new SqlObject(sNewSql);
		Sqlca.executeSQL(so);
		sMsg = "SUC";
	}catch (Exception e){
		sMsg = e.getMessage();
	}

	ArgTool args = new ArgTool();
	args.addArg(SpecialTools.real2Amarsoft(sMsg));
	sReturnValue = args.getArgString();
	out.println(sReturnValue);
%><%@ include file="/IncludeEndAJAX.jsp"%>