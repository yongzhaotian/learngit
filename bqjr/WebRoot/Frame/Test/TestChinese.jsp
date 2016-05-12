<%
/* Author: byhu 2004.12.07
 * Tester:
 * Content: 测试中文字符集 
 * Input Param:
 * Output param:
 * History Log:
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<% 
String sTestChinese = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TestChinese"));
if(sTestChinese==null || !sTestChinese.equals("测试中文字符集")){
%>
<script type="text/javascript">	
	self.returnValue = "failure";
	//self.close();	
</script>
<%
	throw new Exception("这一台客户端无法正确传递中文字符,这会导致系统错误。请与系统管理员联系。");
}else{
%>
<script type="text/javascript">	
	self.returnValue = "success";
	self.close();	
</script>
<%
}
%>

<%@ include file="/IncludeEnd.jsp"%>
