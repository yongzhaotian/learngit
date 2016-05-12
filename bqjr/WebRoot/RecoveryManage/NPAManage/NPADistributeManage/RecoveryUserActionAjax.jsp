
<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   xxge 2004-11-25
 * Tester:
 *
 * Content:  ����ָ����ͬ�Ĳ����ʲ�������
 * Input Param:
 *		SerialNo����ͬ��ˮ��
 *		ShiftType���ƽ����ͣ�01�������ƽ���02���ͻ��ƽ���
 *		RecoveryUserID: �����ʲ�������
 *		RecoveryOrgID�������ʲ���������������
 *		Flag����־��1�������ˣ�
 * Output param:
 * History Log:  
 *	      
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//��ͬ��ˮ�š��ƽ����͡������ʲ������˻�����˴��롢��������
	String sReturnValue="";
	String sContractNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("SerialNo")); 	
	String sShiftType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ShiftType")); 	
	String sRecoveryUser = DataConvert.toRealString(iPostChange,CurPage.getParameter("RecoveryUserID")); 
	String sRecoveryOrg = DataConvert.toRealString(iPostChange,CurPage.getParameter("RecoveryOrgID")); 
	String sFlag=DataConvert.toRealString(iPostChange,CurPage.getParameter("Flag")); 
	//����ֵת��Ϊ���ַ���
	if (sContractNo == null) sContractNo = "";
	if (sShiftType == null) sShiftType = "";
	if (sRecoveryUser == null) sRecoveryUser = "";
	if (sRecoveryOrg == null) sRecoveryOrg = "";
	if (sFlag == null) sFlag = "";
	
	String sSql="";
	String sSerialNo="";
	String	sColumnName = "SerialNo";
	SqlObject so = null;
	
	try{
		if (sFlag.equals("1"))   //ָ�������˽���
		{
			if (sShiftType.equals("02"))  //����ǿͻ��ƽ��ĺ�ͬ����ôָ�������ˣ����ƽ���
			{
				
			}else  //����������ƽ��ĺ�ͬ����ô���Ӹ����ˣ��ƽ���
			{
						 
					sSql= " UPDATE BUSINESS_CONTRACT "+
						 "  SET RecoveryUserID=:RecoveryUserID, RecoveryOrgID=:RecoveryOrgID" + 
						 "  WHERE  SerialNo=:SerialNo"; 
					so = new SqlObject(sSql).setParameter("RecoveryUserID",sRecoveryUser)
					.setParameter("RecoveryOrgID",sRecoveryOrg).setParameter("SerialNo",sContractNo);
					Sqlca.executeSQL(so);
	
					
			}
		}
		else  // ָ�������˽���
		{
	        
	        sSql= " UPDATE BUSINESS_CONTRACT "+
	             "  SET RecoveryUserID=:RecoveryUserID, RecoveryOrgID=:RecoveryOrgID" + 
	             "  WHERE  SerialNo=:SerialNo";   
			so = new SqlObject(sSql).setParameter("RecoveryUserID",sRecoveryUser)
			.setParameter("RecoveryOrgID",sRecoveryOrg).setParameter("SerialNo",sContractNo);   		
	    	Sqlca.executeSQL(so);
	    	if(sShiftType.equals("01")) //��������ƽ�ָ�������ˣ���Ҫ��������Ϣ���в�������
	    	{
	    		
	    	}
		}
		sReturnValue="true";
	}catch(Exception e){
		e.fillInStackTrace();
		sReturnValue="false";
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
