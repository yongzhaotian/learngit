<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
<%
	/*
		Author:   
		Tester://CCS-960  审核要点及审核公告的内容无法更改字体、大小、颜色、加粗等功能，请添加更改字体、大小、颜色、加粗  update huzp 20150804
		Content: 
		Input Param:
		Output param:
		History Log: 
	*/
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
<%
	String PG_TITLE = "查看审核要点"; // 浏览器窗口标题 <title> PG_TITLE </title>
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数：流程编号、阶段编号
		String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
		String sPhaseNo= DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
		String Time= DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Time"));

		//将空值转化成空字符串
		if (sFlowNo == null) sFlowNo = "";
		if (sPhaseNo == null) sPhaseNo = "";

		//根据流程模型编号和阶段编号查询阶段名称
		String sPhaseName = Sqlca.getString("select PhaseName from Flow_Model where FlowNo = '" + sFlowNo + "' and PhaseNo = '"+ sPhaseNo + "'");
		if (null == sPhaseName) sPhaseName = "";//CCS-960  审核要点及审核公告的内容无法更改字体、大小、颜色、加粗等功能，请添加更改字体、大小、颜色、加粗  update huzp 20150804
		//CCS-960  审核要点及审核公告的内容无法更改字体、大小、颜色、加粗等功能，请添加更改字体、大小、颜色、加粗  update huzp 20150804
		String clob = null;
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String AUDITPOINTS="";
		String sql = "SELECT T.AUDITPOINTS FROM auditpoints T WHERE T.FLOWNO='"
				+ sFlowNo
				+ "' AND T.PHASENO='"
				+ sPhaseNo
				+ "' AND T.Time='" + Time + "'";
		conn = Sqlca.getConnection();
		ps = conn.prepareStatement(sql);
		rs = ps.executeQuery();
		if (rs.next()) {
			clob = rs.getString("AUDITPOINTS");
			/*
			Reader is = clob.getCharacterStream();// 得到流
			BufferedReader br = new BufferedReader(is);
			String s = br.readLine();
			StringBuffer sb = new StringBuffer();
			while (s != null) {// 执行循环将字符串全部取出付值给StringBuffer由StringBuffer转成STRING
				sb.append(s);
				s = br.readLine();
			}*/
			AUDITPOINTS = clob.toString();
			/*
			AUDITPOINTS = AUDITPOINTS.replaceAll("hzp", "=");
			AUDITPOINTS = AUDITPOINTS.replaceAll("tlg", "\"");
			AUDITPOINTS = AUDITPOINTS.replaceAll("rlt", "#");
			AUDITPOINTS = AUDITPOINTS.replaceAll("nbsp", "&nbsp;");
			AUDITPOINTS = AUDITPOINTS.replaceAll("lt", "&lt;");
			AUDITPOINTS = AUDITPOINTS.replaceAll("gt", "&gt;");
			AUDITPOINTS = AUDITPOINTS.replaceAll("amp", "&amp;");
			*/
		}
		if (null == AUDITPOINTS) AUDITPOINTS = "";
		if (rs != null) {
			rs.getStatement().close();
		}
%>
<%/*~END~*/%>

<html>
<head>
<title>查看审核要点信息</title>

<script type="text/javascript">
	function goBack() {
		AsControl.OpenView("/SystemManage/CarManage/AuditPointsModelInfoAdd.jsp","","rightup");
	}
</script>
</head>
<body bgcolor="#D3D3D3">
	<table align="left" style="margin-top: 20px;">
		<tr>
			<td align="left"><input type="button" style="width: 50px" name="ok" value="返回" onclick="javascript:goBack()">
			</td>
		</tr>
		<tr>
			<td align="left"><font size="2">【<%=sPhaseName%>】审核要点【汉字最大限制1000内】:</font>
			</td>
			<td rows="10" cols="60">
			</td>
			
		</tr>
		<tr>
			<td align="left"><%=AUDITPOINTS %></td>		
		</tr>
		<tr>
			<input type="hidden" name="FlowNo" value="<%=sFlowNo%>">
			<input type="hidden" name="PhaseNo" value="<%=sPhaseNo%>">
		</tr>
	</table>
	</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>