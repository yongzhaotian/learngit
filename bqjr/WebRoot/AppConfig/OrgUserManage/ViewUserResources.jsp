<%@page import="com.amarsoft.app.awe.config.function.model.ResourceTree"%>
<%@page import="com.amarsoft.dict.als.manage.NameManager"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	//获得页面参数
	String sUserID = CurPage.getParameter("UserID"); //用户编号
	if (sUserID == null) sUserID = "";
	String sUserName = NameManager.getUserName(sUserID); //用户名称
	if (sUserName == null) sUserName = "";
%>
<body leftmargin="0" topmargin="0" style="overflow: hidden;">
<table style="width: 100%;height: 100%;border: 0;" cellspacing="0" cellpadding="0" >
	<tr height=1 align=center>
	    <td>
	    	<table>
		    	<tr>
		    		<td><%=new Button("查询","查询","javascript:showTVSearch()").getHtmlText()%></td>
	    		</tr>
	    	</table>
	    </td>
	    <td>查看用户&nbsp;&nbsp;<font color=#0000FF size="5pt"><%=sUserName%>(ID：<%=sUserID%>)</font>&nbsp;&nbsp;授权资源
	    </td>
	</tr>
	<tr>
		<td id="myleft" colspan='3' align=center width=100%>
			<div style="positition:absolute;align:left;height:100%;overflow-y: hide;">
				<iframe name="left" src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0 scrolling=no ></iframe>
			</div>
		</td>
	</tr>
</table>
</body>
<script type="text/javascript">
	//setDialogTitle("查看用户<font color=#0000FF><%=sUserName%>(ID：<%=sUserID%>)</font>授权资源");
	function startMenu(){
	<%
		HTMLTreeView tviTemp = new ResourceTree().getUserResourceTree(Sqlca, "用户授权资源", sUserID);	
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		tviTemp.TriggerClickEvent=false;
		out.println(tviTemp.generateHTMLTreeView());%>
	}
	
	startMenu();
	expandNode('root');
</script>
<%@ include file="/IncludeEnd.jsp"%>