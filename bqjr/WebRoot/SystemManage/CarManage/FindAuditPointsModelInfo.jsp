<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
<%
	/*
		Author:   
		Tester://CCS-960  ���Ҫ�㼰��˹���������޷��������塢��С����ɫ���Ӵֵȹ��ܣ�����Ӹ������塢��С����ɫ���Ӵ�  update huzp 20150804
		Content: 
		Input Param:
		Output param:
		History Log: 
	*/
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
<%
	String PG_TITLE = "�鿴���Ҫ��"; // ��������ڱ��� <title> PG_TITLE </title>
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//���������������̱�š��׶α��
		String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
		String sPhaseNo= DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
		String Time= DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Time"));

		//����ֵת���ɿ��ַ���
		if (sFlowNo == null) sFlowNo = "";
		if (sPhaseNo == null) sPhaseNo = "";

		//��������ģ�ͱ�źͽ׶α�Ų�ѯ�׶�����
		String sPhaseName = Sqlca.getString("select PhaseName from Flow_Model where FlowNo = '" + sFlowNo + "' and PhaseNo = '"+ sPhaseNo + "'");
		if (null == sPhaseName) sPhaseName = "";//CCS-960  ���Ҫ�㼰��˹���������޷��������塢��С����ɫ���Ӵֵȹ��ܣ�����Ӹ������塢��С����ɫ���Ӵ�  update huzp 20150804
		//CCS-960  ���Ҫ�㼰��˹���������޷��������塢��С����ɫ���Ӵֵȹ��ܣ�����Ӹ������塢��С����ɫ���Ӵ�  update huzp 20150804
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
			Reader is = clob.getCharacterStream();// �õ���
			BufferedReader br = new BufferedReader(is);
			String s = br.readLine();
			StringBuffer sb = new StringBuffer();
			while (s != null) {// ִ��ѭ�����ַ���ȫ��ȡ����ֵ��StringBuffer��StringBufferת��STRING
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
<title>�鿴���Ҫ����Ϣ</title>

<script type="text/javascript">
	function goBack() {
		AsControl.OpenView("/SystemManage/CarManage/AuditPointsModelInfoAdd.jsp","","rightup");
	}
</script>
</head>
<body bgcolor="#D3D3D3">
	<table align="left" style="margin-top: 20px;">
		<tr>
			<td align="left"><input type="button" style="width: 50px" name="ok" value="����" onclick="javascript:goBack()">
			</td>
		</tr>
		<tr>
			<td align="left"><font size="2">��<%=sPhaseName%>�����Ҫ�㡾�����������1000�ڡ�:</font>
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