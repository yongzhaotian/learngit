<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBeginMDAJAX.jsp"%>
<%@page import="com.amarsoft.app.util.ObjectExim"%><%
	/*
		ҳ��˵��: �������ݶ���
	 */
%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part01;Describe=�߼�����;]~*/%>
<%
	//�������
	String sSql;
	String sReturnValue="";
	
	//���ҳ�����
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sRealPath =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ServerRootPath"));
	if(sObjectType==null) sObjectType="";
	if(sObjectNo==null) sObjectNo="";
	
	try{
		System.out.println("Export DataObject--"+sObjectType+":"+sObjectNo);

		sRealPath = "D:/workdir/";
		ObjectExim oe = new ObjectExim(Sqlca,sObjectType,sRealPath);
	    oe.setSDefaultSchema("INFORMIX");
		oe.exportToXml(Sqlca,sObjectNo);

		System.out.println("export is ok.............");
		//oe.importFromXml(Sqlca,sObjectType+"_"+sObjectNo+".xml");
		sReturnValue="succeeded";
	}catch(Exception ex){
		out.println("����ʧ��!����:"+ex.toString());
		sReturnValue="failed";
	}
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();

	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>