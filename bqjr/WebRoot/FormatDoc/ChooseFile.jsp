<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xdhou  2005.02.25
		Tester:
		Content: �鿴���ɵĵ��鱨���ļ�
		Input Param:
			DocID:    formatdoc_catalog�е��ĵ���𣨵��鱨�棬�����鱨�棬...)
			ObjectNo��ҵ����ˮ��
		Output param:
		History Log: cdeng 2009-02-12 �޸Ļ�ȡ�ĵ��洢·����ʽ
	 */
	%>
<%/*~END~*/%>

<%
	//����������	
	String sDocID    = DataConvert.toRealString(iPostChange,(String)request.getParameter("DocID"));    		//���鱨���ĵ����
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo")); 		//ҵ����ˮ��
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType")); 	//��������
%> 

<%
	String sFlag = "";
	//cdeng 2009-02-12 ��ȡ�ĵ��洢·����ʽ
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