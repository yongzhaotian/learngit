<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xdhou  2005.02.18
		Tester:
		Content: 选择需要调用的JSP
		Input Param:
			SerialNo:	报告流水号
			ObjectNo：	业务流水号
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>
<%!
	//获得机构所在的分行
	String getBranchOrgID(String sOrgID,Transaction Sqlca) throws Exception {
		String sUpperOrgID = sOrgID;
		int sLevel = Integer.parseInt(Sqlca.getString("select OrgLevel from Org_Info where OrgID='"+sOrgID+"'"));
		while (sLevel > 3) {
			sUpperOrgID = Sqlca.getString("select RelativeOrgID from Org_Info where OrgID='"+sOrgID+"'");
			if (sUpperOrgID == null) break;
			sOrgID = sUpperOrgID;
			sLevel = Integer.parseInt(Sqlca.getString("select OrgLevel from Org_Info where OrgID='"+sOrgID+"'"));
		}
		return sOrgID;
	}
%>

<% 	
	//获得参数	
	String sDocID = CurPage.getParameter("DocID"); 
	String sOrgID = getBranchOrgID(CurOrg.getOrgID(),Sqlca);
	String sSql = "";
	ASResultSet rs = null;

	String sAttribute = "";
	sSql = "select DefaultValue from FORMATDOC_PARA where orgid = '"+sOrgID+"' and docid = '"+sDocID+"'"; 
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()) sAttribute = rs.getString(1);
	rs.getStatement().close();
%>

<script type="text/javascript">
	self.returnValue = "<%=sAttribute%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>