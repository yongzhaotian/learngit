<%
/* Author: byhu 2004.12.07
 * Tester:
 * Content: ���������ַ��� 
 * Input Param:
 * Output param:
 * History Log:
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<% 
String sTestChinese = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TestChinese"));
if(sTestChinese==null || !sTestChinese.equals("���������ַ���")){
%>
<script type="text/javascript">	
	self.returnValue = "failure";
	//self.close();	
</script>
<%
	throw new Exception("��һ̨�ͻ����޷���ȷ���������ַ�,��ᵼ��ϵͳ��������ϵͳ����Ա��ϵ��");
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
