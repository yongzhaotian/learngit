<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.accounting.web.*"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
	<%
	String t=(String)session.getAttribute("SimulationSchemeCount");
	int schemeCount=Integer.parseInt(t);
	
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径  
	String sButtons[][] = {
			{"true","","Button","打印","打印","printReport()",sResourcesPath},
			{"true","","Button","关闭","关闭","self.close()",sResourcesPath},
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
		alert("没有另存方案，无法生成报告！");
		self.close();
	}
</script>
<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面]~*/%>
<html>
<head>
<title>贷款方案报告</title>
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
			<p align="center" class="style2"><b>贷款方案报告</></p>
 			<table align="center"  border="1" cellpadding="" cellspacing="0" bordercolor="#000033">
				<tr bgcolor="#3399FF">
					<td  height="27">&nbsp;</td>
<% 
				
			for(int i=1;i<=schemeCount;i++){
%>
				    <td width="274"> <div align="center" class="style1">方案<%=i%></div></td>
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
