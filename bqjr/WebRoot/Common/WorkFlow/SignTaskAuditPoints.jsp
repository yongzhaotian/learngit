<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*
		Author:   xswang 20150505
		Tester:
		Content: CCS-637 PRM-293 ��˹��������Ҫ�㹦��ά��
		Input Param:
		Output param:
		History Log: CCS-960  ���Ҫ�㼰��˹���������޷��������塢��С����ɫ���Ӵֵȹ��ܣ�����Ӹ������塢��С����ɫ���Ӵ�  update huzp 20150804
	*/
%>

<%
		//����������
		String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	    String sObjectNo= DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
		String sCurFlowNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("FlowNo"));
		String sCurPhaseNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("PhaseNo"));
		
		//��ȡ���µ��ֶ�����
		String sSql1 = "select Max(SerialNo) as SerialNo from FLow_Task where ObjectNo =:ObjectNo and FlowNo =:FlowNo";
		String sSerialNo = Sqlca.getString(new SqlObject(sSql1)
				.setParameter("ObjectNo", sObjectNo).setParameter("FlowNo", sCurFlowNo));
		sSql1 = "select PhaseNo from Flow_Task where ObjectNo =:ObjectNo and FlowNo =:FlowNo and SerialNo =:SerialNo";
		sCurPhaseNo = Sqlca.getString(new SqlObject(sSql1)
				.setParameter("ObjectNo", sObjectNo).setParameter("FlowNo", sCurFlowNo).setParameter("SerialNo", sSerialNo));

		String sSql =	" select * from "+
					  " (select ap.auditpoints as AuditPoints from auditpoints ap " +
					  " where ap.flowno=:FlowNo and ap.phaseno=:PhaseNo "+
					  " order by Time desc) "+
					  " where rownum = 1 ";

		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("FlowNo", sCurFlowNo).setParameter("PhaseNO", sCurPhaseNo));
		String sAuditPoints ="";//CCS-960  ���Ҫ�㼰��˹���������޷��������塢��С����ɫ���Ӵֵȹ��ܣ�����Ӹ������塢��С����ɫ���Ӵ�  update huzp 20150804
%>
<div>
	<table>
		<tr>
			<td></td>
		</tr>
		<tr>
			<td>���Ҫ�㣺</td>
		</tr>
		<tr>
			<%while(rs.next()){ 
				sAuditPoints=rs.getString(1);//CCS-960  ���Ҫ�㼰��˹���������޷��������塢��С����ɫ���Ӵֵȹ��ܣ�����Ӹ������塢��С����ɫ���Ӵ�  update huzp 20150804
				/*
				sAuditPoints = sAuditPoints.replaceAll("hzp", "=");//��"="�ᱻת�塣�ʱ���ʱ�Ƚ�����ת�崦�����ﷴת�����
				sAuditPoints = sAuditPoints.replaceAll("tlg", "\"");
				sAuditPoints = sAuditPoints.replaceAll("rlt", "#");
				sAuditPoints = sAuditPoints.replaceAll("nbsp", "&nbsp;");
				sAuditPoints = sAuditPoints.replaceAll("lt", "&lt;");
				sAuditPoints = sAuditPoints.replaceAll("gt", "&gt;");
				sAuditPoints = sAuditPoints.replaceAll("amp", "&amp;");*/
			%>

			<td><div
					style="width: 300px; height: 200px; overflow: auto; border: 1px solid #000000;">
					<%=sAuditPoints%>
				</div></td>
			<%
			}
			rs.getStatement().close();
			%>
		</tr>
	</table>
</div>
<div>
	<jsp:include page="/AppConfig/Document/AuditPointsAttachmentList1.jsp"></jsp:include>
</div>
<script type="text/javascript">

//���html���ݽ��и�ʽ�������� 
	  function replaceAll(obj,str1,str2){//CCS-960  ���Ҫ�㼰��˹���������޷��������塢��С����ɫ���Ӵֵȹ��ܣ�����Ӹ������塢��С����ɫ���Ӵ�  update huzp 20150804         
			var result  = obj.replace(eval("/"+str1+"/gi"),str2);        
			return result;  
	  }
</script>
<%@ include file="/IncludeEnd.jsp"%>