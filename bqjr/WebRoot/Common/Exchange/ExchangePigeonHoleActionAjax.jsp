<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
		Content: ���׹鵵
		Input Param:
			      DegbugFlag : ���Ա�־��0 ������ʾ������Ϣ 1����ʾ������Ϣ          
	 */
	//��ȡSerialNo�б�
	String	sSerialNoArray = CurPage.getParameter("SerialNoArray");		
	String sSql = "",sMsg="ERR@";
	String sReturnValue="";
	SqlObject so = null;
	String sNewSql = "";
	if (sSerialNoArray==null) sSerialNoArray="";
	
	try{
		if (sSerialNoArray.equals("")){
			throw new Exception("�������ݴ��󣬳�����ˮ��Ϊ�գ�"); 
		}else{
			sSerialNoArray = StringFunction.replace(sSerialNoArray,",","','");
			sNewSql = "Update BUSINESS_PUTOUT Set ExchangeState='9' where SerialNo in ("+sSerialNoArray+")";
			so = new SqlObject(sNewSql);
			Sqlca.executeSQL(so);
			sMsg = "SUC@�鵵�ɹ���";
		}
	}catch(Exception e){
		sMsg="ERR@"+ e.toString();
	}		   	

	ArgTool args = new ArgTool();
	args.addArg(sMsg);
	sReturnValue = args.getArgString();
	out.println(sReturnValue);
%><%@ include file="/IncludeEndAJAX.jsp"%>