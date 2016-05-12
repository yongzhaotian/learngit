<%@page import="com.amarsoft.are.ARE"%><%@
page import="com.amarsoft.awe.RuntimeContext"%><%@
page import="com.amarsoft.awe.util.JavaMethod"%><%@
page import="com.amarsoft.awe.util.JavaMethodReturn"%><%@
page import="com.amarsoft.awe.util.JavaMethodArg"%><%
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);
response.setContentType("text/html");
response.setCharacterEncoding("utf-8");
JavaMethodReturn ret = new JavaMethodReturn();
try{
    RuntimeContext CurARC = (RuntimeContext)session.getAttribute("CurARC");
    String sArgs = request.getParameter(JavaMethodArg.getUrlParameterName());
    if(CurARC != null && sArgs!=null) { 
    	ret = JavaMethod.run(JavaMethodArg.getJavaMethodArg(sArgs));
        out.print(ret.getReturn());
    }
}
catch(Exception e)
{
    e.printStackTrace();
    ARE.getLog().error(e.getMessage(),e);
}%>