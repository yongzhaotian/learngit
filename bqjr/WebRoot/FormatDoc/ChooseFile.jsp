<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xdhou  2005.02.25
		Tester:
		Content: 查看生成的调查报告文件
		Input Param:
			DocID:    formatdoc_catalog中的文档类别（调查报告，贷后检查报告，...)
			ObjectNo：业务流水号
		Output param:
		History Log: cdeng 2009-02-12 修改获取文档存储路径方式
	 */
	%>
<%/*~END~*/%>

<%
	//获得组件参数	
	String sDocID    = DataConvert.toRealString(iPostChange,(String)request.getParameter("DocID"));    		//调查报告文档类别
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo")); 		//业务流水号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType")); 	//对象类型
%> 

<%
	String sFlag = "";
	//cdeng 2009-02-12 获取文档存储路径方式
	ASResultSet rs = null;
	String sSql1="",sFileName="";
	
	sSql1=" select SerialNo,SavePath from Formatdoc_Record where ObjectType='"+sObjectType+"' and  ObjectNo='"+sObjectNo+
		  "' and DocID='"+sDocID+"'";
	rs = Sqlca.getASResultSet(sSql1);
	if(rs.next())
	{
		sFileName = rs.getString("SavePath");
	}
	rs.getStatement().close();
	if(sFileName==null) sFileName="";
	
	java.io.File file = new java.io.File(sFileName);
 
    if(file.exists()) sFlag = "1";
    else sFlag = "2";
%>
<script type="text/javascript">
	self.returnValue="<%=sFlag%>";
    self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>