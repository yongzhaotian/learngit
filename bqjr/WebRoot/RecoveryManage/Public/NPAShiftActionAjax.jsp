<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   xxge 2004-11-25
 * Tester:
 *
 * Content:  �������ʲ��ƽ���ȫ���������º�ͬ��
 * Input Param:
 *		SerialNo����ͬ��ˮ��
 *		TraceOrgID����ȫ����
 *		ShiftType: �ƽ����ͣ�01�������ƽ���02���˻��ƽ���
 *		Type���ƽ�����1�������ƽ���2�������ƽ���
 * Output param:
 * History Log:  
 *	      
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//�������
	String sSql = "";    
	ASResultSet rs = null;
	double sBalance = 0;
	String sReturnValue="";
	
	//��ͬ��ˮ�š���ȫ�������ƽ����͡��ƽ�����
	String sSerialNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("SerialNo")); 	
	String sTraceOrgID = DataConvert.toRealString(iPostChange,CurPage.getParameter("TraceOrgID"));
	String sShiftType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ShiftType"));
	String sType = DataConvert.toRealString(iPostChange,CurPage.getParameter("Type"));
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sTraceOrgID == null) sTraceOrgID = "";
	if(sShiftType == null) sShiftType = "";
	if(sType == null) sType = "";
   	
	if(sType.equals("1"))//���Ŵ����ƽ���ȫ��
   	{	        
        //sSql = " select Balance from BUSINESS_CONTRACT where SerialNo='"+sSerialNo+"' ";
        sSql = " select Balance from BUSINESS_CONTRACT where SerialNo=:SerialNo ";
  		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));    
   		if(rs.next())
   		 	sBalance = rs.getDouble("Balance");        
		 rs.getStatement().close();
		       
        //���º�ͬ��
        //sSql = " update BUSINESS_CONTRACT set ShiftBalance = "+sBalance+",ShiftType = '"+sShiftType+"',RecoveryOrgID = '"+sTraceOrgID+"' where SerialNo = '"+sSerialNo+"' ";
        sSql = " update BUSINESS_CONTRACT set ShiftBalance = :ShiftBalance,ShiftType = :ShiftType,RecoveryOrgID = :RecoveryOrgID where SerialNo = :SerialNo ";
        SqlObject so = new SqlObject(sSql);
        so.setParameter("ShiftBalance",sBalance);
        so.setParameter("ShiftType",sShiftType);
        so.setParameter("RecoveryOrgID",sTraceOrgID);
        so.setParameter("SerialNo",sSerialNo);
       	Sqlca.executeSQL(so);	 
       	sReturnValue="true";
	%>
	
	<%
	}else //�ӱ�ȫ���˻ص��Ŵ���
	{	
		//���º�ͬ��
        //sSql= " update BUSINESS_CONTRACT set ShiftBalance = 0.0,ShiftType = null,RecoveryOrgID = null where SerialNo = '"+sSerialNo+"' ";
		sSql= " update BUSINESS_CONTRACT set ShiftBalance = 0.0,ShiftType = null,RecoveryOrgID = null where SerialNo = :SerialNo";
       	Sqlca.executeSQL(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));	
       	sReturnValue="true";
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
