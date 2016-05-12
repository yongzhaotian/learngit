<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMDAJAX.jsp"%><%
	String sReturn = "";
	ArgTool arg = new ArgTool();
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select ExampleID,ExampleName from Example_Info order by ExampleID desc"));
	if(rs.next()){
		arg.addArg(rs.getString(1));
		arg.addArg(rs.getString(2));
	}
	
	rs.getStatement().close();
	
	sReturn = arg.getArgString();
	out.print(sReturn);
%><%@ include file="/IncludeEndAJAX.jsp"%>
