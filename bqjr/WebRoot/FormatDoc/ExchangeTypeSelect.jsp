<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xdhou  2005.02.17
		Tester:
		Content: �������ݵ�FORMATDOC_DATA
		Input Param:
			DocID:    formatdoc_catalog�е��ĵ���𣨵��鱨�棬�����鱨�棬...)
			ObjectNo��ҵ����ˮ��
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<% 	
		
	//����������	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo")); 		//ҵ����ˮ��
	String sExchangeType = "";
	String sSql = "select ExchangeType from BUSINESS_PUTOUT where SerialNo = '"+sObjectNo+"'";
	ASResultSet rs = Sqlca.getResultSet(sSql);
	if(rs.next())
	{ 
		sExchangeType = rs.getString(1);
	}
	rs.getStatement().close();
%>

<script type="text/javascript">
	self.returnValue="<%=sExchangeType%>";
    self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>