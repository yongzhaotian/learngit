<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:  hxli 2004.02.19
 * Tester:
 *
 * Content: ������ҵ��ת��Ȩ����̨�����ݿ�Ĳ�����
 * Input Param:
 * 			 SerialNo����ͬ���
 *           FromOrgID��ת��ǰ��������
 *           FromOrgName��ת��ǰ��������
 * 			 FromUserID��ת��ǰ�ͻ��������
 *           FromUserName��ת��ǰ�ͻ���������
 *           ToUserID��ת�ƺ�ͻ��������
 * 			 ToUserName��ת�ƺ�ͻ���������
 * Output param:
 *
 * History Log:
 *  		zywei 2005.8.16	 �޸�ҳ��
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%
    //��ȡ������ת�ƺ�ͬ��ת��ǰ�������롢ת��ǰ�������ơ�ת��ǰ�ͻ�������롢ת��ǰ�ͻ��������ơ�ת�ƺ�ͻ�������롢ת�ƺ�ͻ���������
    String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
    String sFromOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgID"));
	String sFromOrgName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgName"));
	String sFromUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromUserID"));
	String sFromUserName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromUserName"));	
	String sToUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToUserID"));
	String sToUserName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToUserName"));

	//ת�ƺ�������������
	String sToOrgID = "",sToOrgName = "";	
	String sInputDate   = StringFunction.getToday();
	//ת����־��Ϣ
	String sChangeReason = "������ҵ��ת��Ȩ������Ա����:"+CurUser.getUserID()+"   ������"+CurUser.getUserName()+"   �������룺"+CurOrg.getOrgID()+"   �������ƣ�"+CurOrg.getOrgName();
	//SQL��䡢�Ƿ�ɹ���־
	String sSql = "",sFlag = "";
	//��ѯ�����
	ASResultSet rs = null;
	SqlObject so = null;
	//��ѯ���Ӻ�ͻ��������ڻ������������
    sSql =  " select BelongOrg,getOrgName(BelongOrg) as BelongOrgName "+
        	" from USER_INFO " +
        	" where UserID = :UserID ";
	so = new SqlObject(sSql).setParameter("UserID",sToUserID);
	rs = Sqlca.getASResultSet(so);
	if(rs.next())
	{
	    sToOrgID = DataConvert.toString(rs.getString("BelongOrg"));
	    sToOrgName = DataConvert.toString(rs.getString("BelongOrgName"));
	}
	rs.getStatement().close();

	try{
		//��MANAGE_CHANGE���в����¼�����ڼ�¼��α������
        String sSerialNo1 =  DBKeyHelp.getSerialNo("MANAGE_CHANGE","SerialNo",Sqlca);
        sSql =  " INSERT INTO MANAGE_CHANGE(ObjectType,ObjectNo,SerialNo,OldOrgID,OldOrgName,NewOrgID,NewOrgName,OldUserID, "+
				" OldUserName,NewUserID,NewUserName,ChangeReason,ChangeOrgID,ChangeUserID,ChangeTime) "+
		        " VALUES('FlowTask',:ObjectNo,:SerialNo,:OldOrgID,:OldOrgName,:NewOrgID,:NewOrgName,:OldUserID, "+
		        " :OldUserName,:NewUserID,:NewUserName,:ChangeReason,:ChangeOrgID,:ChangeUserID,:ChangeTime)";
        so = new SqlObject(sSql);
        so.setParameter("ObjectNo",sSerialNo);
        so.setParameter("SerialNo",sSerialNo1);
        so.setParameter("OldOrgID",sFromOrgID);
        so.setParameter("OldOrgName",sFromOrgName);
        so.setParameter("NewOrgID",sToOrgID);
        so.setParameter("NewOrgName",sToOrgName);
        so.setParameter("OldUserID",sFromUserID);
        so.setParameter("OldUserName",sFromUserName);
        so.setParameter("NewUserID",sToUserID);
        so.setParameter("NewUserName",sToUserName);
        so.setParameter("ChangeReason",sChangeReason);
        so.setParameter("ChangeOrgID",CurOrg.getOrgID());
        so.setParameter("ChangeUserID",CurUser.getUserID());
        so.setParameter("ChangeTime",sInputDate);
        Sqlca.executeSQL(so);

        //�����ͬ�Ĺܻ��˺ͻ���
		//sSql = " update FLOW_TASK set OrgID='"+sToOrgID+"',OrgName='"+sToOrgName+"',UserID='"+sToUserID+"',UserName='"+sToUserName+"' where "+
		//	   " SerialNo = '"+sSerialNo+"' ";
		sSql = " update FLOW_TASK set OrgID=:OrgID,OrgName=:OrgName,UserID=:UserID,UserName=:UserName where "+
		   	" SerialNo = :SerialNo ";
        so=new SqlObject(sSql);
        so.setParameter("OrgID",sToOrgID);
        so.setParameter("OrgName",sToOrgName);
        so.setParameter("UserID",sToUserID);
        so.setParameter("UserName",sToUserName);
        so.setParameter("SerialNo",sSerialNo);
		Sqlca.executeSQL(so);			
		sFlag = "TRUE";
			
	}catch(Exception e)
	{
		sFlag = "FALSE";
		throw new Exception("������ҵ��ת��Ȩ����ʧ�ܣ�"+e.getMessage());
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