<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: FSGong 2004-12-30
 * Tester:
 * Content: 
 *从Business_Apply中删除一个申请记录之后，必须删除其相关联的其他信息。
 * Input Param:
 *		  
 *  
 * Output param:
 *		无	
 * History Log:
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	
	//申请流水号、申请大类型
	String 	sSerialNo		= DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String 	sObjectType	= DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));
	
	//流程编号
	String	sFlowNo		= DataConvert.toRealString(iPostChange,(String)request.getParameter("FlowNo"));
	String sReturnValue="";
	SqlObject so = null;
	ASResultSet               rs;

	try{
		//删除FLOW_TASK表中相关数据：删除流程运行历史。
		String	sSql1 = " Delete from FLOW_TASK  where FlowNo=:FlowNo and ObjectNo=:ObjectNo";
		so = new SqlObject(sSql1).setParameter("FlowNo",sFlowNo).setParameter("ObjectNo",sSerialNo);
		Sqlca.executeSQL(so);

		//删除FLOW_OBJECT表中相关数据：删除流程当前运行点。
		String	sSql2 = " Delete from Flow_Object where ObjectType=:ObjectType and ObjectNo=:ObjectNo";
		so = new SqlObject(sSql2).setParameter("ObjectType",sObjectType).setParameter("ObjectNo",sSerialNo);
		Sqlca.executeSQL(so);  				
		
		//删除APPLY_RELATIVE中的关联纪录：SerialNo为申请编号。ObjectNo为合同编号。
		String	sSql3 = " Delete from Apply_Relative where ObjectType='BusinessContract'  and  SerialNo=:SerialNo";
		so = new SqlObject(sSql3).setParameter("SerialNo",sSerialNo);
		Sqlca.executeSQL(so);  

		//删除Business_Apply表中相关数据
		String	sSql4= " Delete from Business_Apply where SerialNo=:SerialNo";
		so = new SqlObject(sSql4).setParameter("SerialNo",sSerialNo);
		Sqlca.executeSQL(so);  			
		sReturnValue="true";
	}
	catch(Exception e)
	{
		sReturnValue="false";
		throw new Exception("事务处理失败！"+e.getMessage());
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