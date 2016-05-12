<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: FSGong 2004-12-30
 * Tester:
 * Content: 
 *��Business_Apply��ɾ��һ�������¼֮�󣬱���ɾ�����������������Ϣ��
 * Input Param:
 *		  
 *  
 * Output param:
 *		��	
 * History Log:
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	
	//������ˮ�š����������
	String 	sSerialNo		= DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String 	sObjectType	= DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));
	
	//���̱��
	String	sFlowNo		= DataConvert.toRealString(iPostChange,(String)request.getParameter("FlowNo"));
	String sReturnValue="";
	SqlObject so = null;
	ASResultSet               rs;

	try{
		//ɾ��FLOW_TASK����������ݣ�ɾ������������ʷ��
		String	sSql1 = " Delete from FLOW_TASK  where FlowNo=:FlowNo and ObjectNo=:ObjectNo";
		so = new SqlObject(sSql1).setParameter("FlowNo",sFlowNo).setParameter("ObjectNo",sSerialNo);
		Sqlca.executeSQL(so);

		//ɾ��FLOW_OBJECT����������ݣ�ɾ�����̵�ǰ���е㡣
		String	sSql2 = " Delete from Flow_Object where ObjectType=:ObjectType and ObjectNo=:ObjectNo";
		so = new SqlObject(sSql2).setParameter("ObjectType",sObjectType).setParameter("ObjectNo",sSerialNo);
		Sqlca.executeSQL(so);  				
		
		//ɾ��APPLY_RELATIVE�еĹ�����¼��SerialNoΪ�����š�ObjectNoΪ��ͬ��š�
		String	sSql3 = " Delete from Apply_Relative where ObjectType='BusinessContract'  and  SerialNo=:SerialNo";
		so = new SqlObject(sSql3).setParameter("SerialNo",sSerialNo);
		Sqlca.executeSQL(so);  

		//ɾ��Business_Apply�����������
		String	sSql4= " Delete from Business_Apply where SerialNo=:SerialNo";
		so = new SqlObject(sSql4).setParameter("SerialNo",sSerialNo);
		Sqlca.executeSQL(so);  			
		sReturnValue="true";
	}
	catch(Exception e)
	{
		sReturnValue="false";
		throw new Exception("������ʧ�ܣ�"+e.getMessage());
	}		
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>