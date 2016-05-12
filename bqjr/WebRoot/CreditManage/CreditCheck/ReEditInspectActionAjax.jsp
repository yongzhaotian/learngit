<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   ndeng  2005.1.24
		Tester:
		Content: 撤回完成的检查报告操作
		Input Param:
			 SerialNo: 流水号
			 ObjectType：对象类型
			 ObjectNo：对象编号
		Output param:
		
		History Log: zywei 2006/09/11 重检代码
			
	 */
	%>
<%/*~END~*/%>

<%
	//定义变量
	String sSql = "";
	SqlObject so = null;
	//获取页面参数
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));
	String sReturnValue="succeed";
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";

	try{
		//如果是贷款用途报告
		if(sObjectType.equals("BusinessContract"))
		{
			sSql = 	" update INSPECT_INFO set FinishDate = null,InspectType = '010010'"+
					" where SerialNo =:SerialNo "+
					" and ObjectNo =:ObjectNo "+
					" and ObjectType =:ObjectType";
			so = new SqlObject(sSql).setParameter("SerialNo",sSerialNo)
			.setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);
			Sqlca.executeSQL(so);
		}
		//客户检查报告，
		else if(sObjectType.equals("Customer"))
		{		
			sSql = 	" update INSPECT_INFO set FinishDate = null,InspectType = '020010'"+
		   			" where SerialNo =:SerialNo "+
		   			" and ObjectNo =:ObjectNo "+
		   			" and ObjectType =:ObjectType ";
		   	so = new SqlObject(sSql).setParameter("SerialNo",sSerialNo)
			.setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);	
			Sqlca.executeSQL(so);
		}
	}catch(Exception e){
		e.printStackTrace();
		sReturnValue="failed";
	}
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>