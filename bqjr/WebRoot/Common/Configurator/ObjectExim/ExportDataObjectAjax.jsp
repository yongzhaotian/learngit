<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBeginMDAJAX.jsp"%>
<%@page import="com.amarsoft.app.util.ObjectExim"%><%
	/*
		页面说明: 导出数据对象
	 */
%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part01;Describe=逻辑处理;]~*/%>
<%
	//定义变量
	String sSql;
	String sReturnValue="";
	
	//获得页面参数
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
		out.println("生成失败!错误:"+ex.toString());
		sReturnValue="failed";
	}
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();

	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>