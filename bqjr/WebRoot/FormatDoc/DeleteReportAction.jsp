<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xdhou  2005.02.17
		Tester:
		Content: 插入数据到FORMATDOC_DATA
		Input Param:
			DocID:    formatdoc_catalog中的文档类别（调查报告，贷后检查报告，...)
			ObjectNo：业务流水号
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<% 	
		
	//获得组件参数	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 		//业务流水号,参数获取方式modified by yzheng 2013-6-25
	String sSql = "delete from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"'";
	Sqlca.executeSQL(sSql);
%>

<script type="text/javascript">
    self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>