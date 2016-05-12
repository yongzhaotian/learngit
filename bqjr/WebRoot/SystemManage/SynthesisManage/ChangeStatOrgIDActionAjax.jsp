<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:  hxli 2004.02.19
 * Tester:
 *
 * Content: ת�ƺ�ͬ����̨�����ݿ�Ĳ�����
 * Input Param:
 * 			 UserID:���ܿͻ�����
 *           OrgID:���ܻ���
 *           SerialNo:��ͬ���
 * Output param:
 *
 * History Log:
 *  		gecg 2005.3.01	 �޸�ҳ��
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%
    //��ȡ������ת�ƺ�ͬ��ת��ǰ�������롢ת��ǰ�������ơ�ת��ǰ�ͻ�������롢ת��ǰ�ͻ��������ơ�ת�ƺ�ͻ�������롢ת�ƺ�ͻ���������
    String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
    String sFromOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgID"));
	String sFromOrgName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgName"));		
	String sToOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToOrgID"));
	String sToOrgName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToOrgName"));

	//ת������
	String sInputDate   = StringFunction.getToday();	
	//ת����־��Ϣ
	String sChangeReason = "ҵ�����˻������Ӳ�����Ա����:"+CurUser.getUserID()+"   ������"+CurUser.getUserName()+"   �������룺"+CurOrg.getOrgID()+"   �������ƣ�"+CurOrg.getOrgName();
	String sSql = "",sFlag = "";
	try{
		//��MANAGE_CHANGE���в����¼�����ڼ�¼��α������
	    String sSerialNo1 =  DBKeyHelp.getSerialNo("MANAGE_CHANGE","SerialNo",Sqlca);
	    /*sSql =  " INSERT INTO MANAGE_CHANGE(ObjectType,ObjectNo,SerialNo,OldOrgID,OldOrgName,NewOrgID,NewOrgName,OldUserID, "+
	    		" OldUserName,NewUserID,NewUserName,ChangeReason,ChangeOrgID,ChangeUserID,ChangeTime) "+
	            " VALUES('BusinessContract','"+sSerialNo+"','"+sSerialNo1+"','"+sFromOrgID+"','"+sFromOrgName+"','"+sToOrgID+"', "+
	            " '"+sToOrgName+"','','','','','"+sChangeReason+"','"+CurOrg.getOrgID()+"','"+CurUser.getUserID()+"','"+sInputDate+"')";*/
	    sSql =  " INSERT INTO MANAGE_CHANGE(ObjectType,ObjectNo,SerialNo,OldOrgID,OldOrgName,NewOrgID,NewOrgName,OldUserID, "+
				" OldUserName,NewUserID,NewUserName,ChangeReason,ChangeOrgID,ChangeUserID,ChangeTime) "+
		        " VALUES('BusinessContract',:ObjectNo,:SerialNo,:OldOrgID,:OldOrgName,:NewOrgID, "+
		        " :NewOrgName,'','','','',:ChangeReason,:ChangeOrgID,:ChangeUserID,:ChangeTime)";
	    SqlObject so = new SqlObject(sSql);
	    so.setParameter("ObjectNo",sSerialNo);
	    so.setParameter("SerialNo",sSerialNo1);
	    so.setParameter("OldOrgID",sFromOrgID);
	    so.setParameter("OldOrgName",sFromOrgName);
	    so.setParameter("NewOrgID",sToOrgID);
	    so.setParameter("NewOrgName",sToOrgName);
	    so.setParameter("ChangeReason",sChangeReason);
	    so.setParameter("ChangeOrgID",CurOrg.getOrgID());
	    so.setParameter("ChangeUserID",CurUser.getUserID());
	    so.setParameter("ChangeTime",sInputDate);
	    Sqlca.executeSQL(so);

	    //�����ͬ�����˻���
		sSql = " update BUSINESS_CONTRACT set StatOrgID=:StatOrgID where "+
		   	   " SerialNo = :SerialNo ";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("StatOrgID",sToOrgID).setParameter("SerialNo",sSerialNo));	
						
		sFlag = "TRUE";
		
	}catch(Exception e)
	{
		sFlag = "FALSE";
		throw new Exception("��ͬת�ƴ���ʧ�ܣ�"+e.getMessage());
	}
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sFlag);
	sFlag = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sFlag);
%>
<%/*~END~*/%>


<%@ include file="/IncludeEndAJAX.jsp"%>