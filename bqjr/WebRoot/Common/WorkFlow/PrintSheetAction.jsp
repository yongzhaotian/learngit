<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xuzhang  2005.1.25
		Tester:
		Content: ��ӡ����ͳһ֪ͨ��Ԥ����
		Input Param:
			ObjectNo����������������
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>
<%
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectNo == null) sObjectNo = "";
	
	String sApproveType = "";	
	String sSql="select ApproveType from BUSINESS_APPROVE where SerialNo=:SerialNo";
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(rs.next())
	{
		sApproveType=DataConvert.toString(rs.getString("ApproveType"));
		if(sApproveType == null) sApproveType = "";
	}
	rs.getStatement().close();
	
%>
<script type="text/javascript">
<%if(sApproveType.equals("01")){%> //ͬ��
		OpenPage("/Common/WorkFlow/PrintAggreeSheet.jsp?ObjectNo=<%=sObjectNo%>","_self","");
	<%}else if(sApproveType.equals("02")){%> //���
		OpenPage("/Common/WorkFlow/PrintDisaggreeSheet.jsp?ObjectNo=<%=sObjectNo%>","_self","");
	<%}%>
</script>

<%@ include file="/IncludeEnd.jsp"%>