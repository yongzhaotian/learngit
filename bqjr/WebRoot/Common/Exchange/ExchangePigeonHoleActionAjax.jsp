<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
		Content: 交易归档
		Input Param:
			      DegbugFlag : 调试标志：0 ：不显示调试信息 1：显示调试信息          
	 */
	//获取SerialNo列表
	String	sSerialNoArray = CurPage.getParameter("SerialNoArray");		
	String sSql = "",sMsg="ERR@";
	String sReturnValue="";
	SqlObject so = null;
	String sNewSql = "";
	if (sSerialNoArray==null) sSerialNoArray="";
	
	try{
		if (sSerialNoArray.equals("")){
			throw new Exception("参数传递错误，出账流水号为空！"); 
		}else{
			sSerialNoArray = StringFunction.replace(sSerialNoArray,",","','");
			sNewSql = "Update BUSINESS_PUTOUT Set ExchangeState='9' where SerialNo in ("+sSerialNoArray+")";
			so = new SqlObject(sNewSql);
			Sqlca.executeSQL(so);
			sMsg = "SUC@归档成功！";
		}
	}catch(Exception e){
		sMsg="ERR@"+ e.toString();
	}		   	

	ArgTool args = new ArgTool();
	args.addArg(sMsg);
	sReturnValue = args.getArgString();
	out.println(sReturnValue);
%><%@ include file="/IncludeEndAJAX.jsp"%>