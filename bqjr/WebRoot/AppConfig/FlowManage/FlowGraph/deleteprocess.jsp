<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<html xmlns:v="urn:schemas-microsoft-com:vml">
	<head>
		<title>删除流程图</title>

		<script src="<%=sWebRootPath%>/AppConfig/FlowManage/FlowGraph/resources/js/WorkFlowWorkSpace.js" language="javascript"></script>
		<script src="<%=sWebRootPath%>/AppConfig/FlowManage/FlowGraph/resources/src/com/amarsoft/util/Array.js" language="javascript"></script>
		<script src="<%=sWebRootPath%>/AppConfig/FlowManage/FlowGraph/resources/src/com/amarsoft/util/String.js" language="javascript"></script>
		<script src="<%=sWebRootPath%>/AppConfig/FlowManage/FlowGraph/resources/src/com/amarsoft/html/Toolkit.js" language="javascript"></script>
		<script src="<%=sWebRootPath%>/AppConfig/FlowManage/FlowGraph/resources/src/com/amarsoft/ajax/Ajax.js" language="javascript"></script>
		<script src="<%=sWebRootPath%>/AppConfig/FlowManage/FlowGraph/deleteprocess.js" language="javascript"></script>
		
		<style type="text/css">
			body {
				text-align:center;
			}
		</style>
	</head>

	<body>
		<table cellPadding="3" cellSpacing="3">
			<tr>
				<td height="50px" colSpan="2" align="center" vAlign="middle">流程图删除后,下次打开时会重新生成,您确定要删除该流程的流程图吗？</td>
			</tr>
			<tr>
				<td width="50%" align="right"><%=new Button("&nbsp;确&nbsp;定&nbsp;","确定","javascript:deleteInit();","","","high2").getHtmlText()%></td>
				<td width="50%" align="left"><%=new Button("&nbsp;取&nbsp;消&nbsp;","取消","javascript:self.close();","","","high").getHtmlText()%></td>
			</tr>
		</table>
	</body>
</html>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
