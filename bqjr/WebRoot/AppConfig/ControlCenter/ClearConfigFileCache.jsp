<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMDAJAX.jsp"%><%
	/* 
	 * 同步缓存
	 * 清空缓存中的数据，重新读入ConfigFile
	 */
	String sReturn = "SUCCESS";
	try{
		CurConfig.reload(application);
	}catch(Exception er){
		out.println("清空缓存失败："+er);
		sReturn = "FAILED";
		throw er;
	}
	out.println(sReturn);
%><%@ include file="/IncludeEndAJAX.jsp"%>