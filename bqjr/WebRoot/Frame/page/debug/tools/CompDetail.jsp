<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
String sToShowClientID = CurPage.getParameter("ToShowClientID");
Component comp = CurCompSession.lookUp(sToShowClientID);
if(comp==null) throw new Exception("������ѱ����ٻ�ͻ��˺Ŵ����޷���CurCompSession���ҵ�������ͻ��˺ţ�"+sToShowClientID);
%>
<script type="text/javascript">
setDialogTitle("�����<%=comp.getCompURL()%>����Ϣ");
</script>
<style>
table{border:0;margin:0;border-collapse:collapse;} table th, table td{padding:0;}
td{border:1px solide #000000}
</style>
<body style="width:100%;height:100%;overflow:hidden;margin-left:0px;margin-right:0px;">
<div style="position:absolute;width:100%;height:100%;overflow:auto;">
<table width="100%" cellspacing="0" border="1px solide #000000" cellpadding="2">
  <tr bgcolor="#B0C4DE"> 
    <td colspan="2" ><strong><font>��ǰ�������</font></strong></td>
  </tr>
<%
for(int i=0;i<comp.getParameterList().size();i++) {
%>
  <tr bgcolor="#FFFFF0"> 
    <td>
    <li><%=comp.getParameterList().get(i).getName()%></li>
    </td>
    <td><textarea style="width:100%;height:100%"><%=comp.getParameterList().get(i).getValue()%></textarea></td>
  </tr>
<%
}
%>
<%
int iCount = 1;
Component pcomp  = comp.getParentComponent();
while (pcomp != null) {
%>
  <tr bgcolor="#B0C4DE"> 
    <td colspan="2" ><strong><font>��[<%=iCount%>]�����������</font></strong></td>
  </tr>
<%
comp = pcomp;
iCount ++;
pcomp  = comp.getParentComponent();
for(int i=0;i<comp.getParameterList().size();i++) {
	%>
	  <tr bgcolor="#FFFFF0"> 
	    <td>
	    <li><%=comp.getParameterList().get(i).getName()%></li>
	    </td>
	    <td><textarea style="width:100%;height:100%"><%=comp.getParameterList().get(i).getValue()%></textarea>
	    </td>
	  </tr>
	<%
	}
%>
<%
}
%>
</table>
</div>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>