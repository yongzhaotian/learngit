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
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 		//ҵ����ˮ��,������ȡ��ʽmodified by yzheng 2013-6-25
	String sSql = "delete from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"'";
	Sqlca.executeSQL(sSql);
%>

<script type="text/javascript">
    self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>