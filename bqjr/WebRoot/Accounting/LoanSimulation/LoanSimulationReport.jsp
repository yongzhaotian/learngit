<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.accounting.web.*"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	String t=(String)session.getAttribute("SimulationSchemeCount");
	int schemeCount=Integer.parseInt(t);
	
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��  
	String sButtons[][] = {
			{"true","","Button","��ӡ","��ӡ","printReport()",sResourcesPath},
			{"true","","Button","�ر�","�ر�","self.close()",sResourcesPath},
	};
	%> 
<%/*~END~*/%>

 <style type="text/css">
<!--
.style1 {font-size: 14px}
-->
</style>

<script language=javascript>
	if(<%=schemeCount%><1){
		alert("û����淽�����޷����ɱ��棡");
		self.close();
	}
</script>
<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��]~*/%>
<html>
<head>
<title>���������</title>
</head> 
<body leftmargin="0" topmargin="0" class="pagebackground">
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" id=InfoTable>
	<tr id="ButtonTR" height="1">
		<td id="InfoButtonArea" class="InfoButtonArea">
			<%@ include file="/Resources/CodeParts/ButtonSet.jsp"%>
	    </td>
	</tr>
	<tr>
		<td>
			<p align="center" class="style2"><b>���������</></p>
 			<table align="center"  border="1" cellpadding="" cellspacing="0" bordercolor="#000033">
				<tr bgcolor="#3399FF">
					<td  height="27">&nbsp;</td>
<% 
				
			for(int i=1;i<=schemeCount;i++){
%>
				    <td width="274"> <div align="center" class="style1">����<%=i%></div></td>
<%
			}
%>
				</tr> 
<%
			String s="&nbsp;";
			Object[] termTypeSet=ProductConfig.getTermTypeSet().getKeys();
			for(Object key: termTypeSet){
				String termType=(String)key;
				String termTypeName=ProductConfig.getTermTypeAttribute(termType, "TermTypeName");
%>
				<tr>
					<td height="56" bgcolor="#FFCC66"><%=termTypeName%></td>
<% 
				for(int i=1;i<Integer.valueOf(t);i++){
					BusinessObject loan = (BusinessObject)session.getAttribute("SimulationObject_Loan"+i);
					out.println("<td>"+ProductReport.genHTML(loan, termType)+"</td>");
				}
%>			
				</tr>
<%
  			}
 %>
 			</table>
		</td>
	</tr>
</table>
	<script type="text/javascript">
		sButtonAreaHTML = document.getElementById("InfoButtonArea").innerHTML;
		if(sButtonAreaHTML.indexOf("hc_drawButtonWithTip")<0){
			document.getElementById("ButtonTR").style.display="none";
		}
	</script>
</body>
</html>
<%/*~END~*/%>


<script language=javascript>
	function printReport(){
		window.print("","");
	}
</script>
</body>

</html>
<%@	include file="/IncludeEnd.jsp"%>
