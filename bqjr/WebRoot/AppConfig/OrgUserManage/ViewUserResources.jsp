<%@page import="com.amarsoft.app.awe.config.function.model.ResourceTree"%>
<%@page import="com.amarsoft.dict.als.manage.NameManager"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	//���ҳ�����
	String sUserID = CurPage.getParameter("UserID"); //�û����
	if (sUserID == null) sUserID = "";
	String sUserName = NameManager.getUserName(sUserID); //�û�����
	if (sUserName == null) sUserName = "";
%>
<body leftmargin="0" topmargin="0" style="overflow: hidden;">
<table style="width: 100%;height: 100%;border: 0;" cellspacing="0" cellpadding="0" >
	<tr height=1 align=center>
	    <td>
	    	<table>
		    	<tr>
		    		<td><%=new Button("��ѯ","��ѯ","javascript:showTVSearch()").getHtmlText()%></td>
	    		</tr>
	    	</table>
	    </td>
	    <td>�鿴�û�&nbsp;&nbsp;<font color=#0000FF size="5pt"><%=sUserName%>(ID��<%=sUserID%>)</font>&nbsp;&nbsp;��Ȩ��Դ
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
	//setDialogTitle("�鿴�û�<font color=#0000FF><%=sUserName%>(ID��<%=sUserID%>)</font>��Ȩ��Դ");
	function startMenu(){
	<%
		HTMLTreeView tviTemp = new ResourceTree().getUserResourceTree(Sqlca, "�û���Ȩ��Դ", sUserID);	
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		tviTemp.TriggerClickEvent=false;
		out.println(tviTemp.generateHTMLTreeView());%>
	}
	
	startMenu();
	expandNode('root');
</script>
<%@ include file="/IncludeEnd.jsp"%>