<%
/* Copyright 2001-2006 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:  zywei 2006.10.25
 * Tester:
 *
 * Content: ���ӿͻ�����
 * Input Param:
 *			CustomerID�������ӵĿͻ����
 *			FromOrgID������ǰ��������
 *			FromOrgName������ǰ��������
 *          FromUserID������ǰ�ͻ��������
 *          FromUserName������ǰ�ͻ���������
 *          ToUserID�����Ӻ�ͻ��������
 *          ToUserName�����Ӻ�ͻ��������
 *			ChangeObject���޸Ķ���
 * Output param:
 *
 *
 * History Log:  
 *				 
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%@ page import="com.amarsoft.app.lending.bizlets.*,com.amarsoft.biz.bizlet.Bizlet" %>


<%
	//��ȡ���������ӿͻ�������ǰ�������롢����ǰ�������ơ�����ǰ�ͻ�������롢����ǰ�ͻ��������ơ����Ӻ�ͻ�������롢���Ӻ�ͻ��������ơ��޸Ķ���
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sFromOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgID"));
	String sFromOrgName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgName"));
	String sFromUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromUserID"));
	String sFromUserName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromUserName"));	
	String sToUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToUserID"));
	String sToUserName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToUserName"));
	String sChangeObject = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ChangeObject"));
	SqlObject so = null;
	String sNewSql = "";	
	
    //��������   
    String sInputDate   = StringFunction.getToday();
    //���Ӻ�Ļ������������
    String sToOrgID = "",sToOrgName = "";
	ASResultSet rs = null; //��ѯ�����
	int iCount = 0; //��¼��
	int i = 0;//������
    String sSql = ""; //SQL���
    String sFlag = ""; //�����Ƿ�ɹ���־
    
    //������־��Ϣ
	String sChangeReason = "�ͻ����Ӳ�����Ա����:"+CurUser.getUserID()+"   ������"+CurUser.getUserName()+"   �������룺"+CurOrg.getOrgID()+"   �������ƣ�"+CurOrg.getOrgName();
    //�ж��Ƿ���δ����ͨ��������
    sSql = 	" select count(BA.SerialNo) "+
    		" from FLOW_OBJECT FB,BUSINESS_APPLY BA "+
    		" where BA.SerialNo = FB.ObjectNo "+
    		" and FB.ObjectType = 'CreditApply' "+
    		" and FB.UserID = :UserID "+
    		" and BA.CustomerID = :CustomerID "+
    		" and FB.PhaseNo <> '1000' "+
    		" and FB.PhaseNo <> '8000' ";
	so = new SqlObject(sSql);
    so.setParameter("UserID",sFromUserID);
    so.setParameter("CustomerID",sCustomerID	);
    rs = Sqlca.getASResultSet(so);
	if(rs.next())
	{
      iCount=rs.getInt(1);
    }
    rs.getStatement().close();
    if(iCount==0)
    {		
		StringTokenizer st = new StringTokenizer(sChangeObject,"|");
	    String [] ChangeObject = new String[st.countTokens()];
		while (st.hasMoreTokens()) 
	    {
	        ChangeObject[i] = st.nextToken();                
	        i++;
	    } 	    
	            
        //��ѯ���Ӻ�ͻ��������ڻ������������
        sSql =  " select BelongOrg,getOrgName(BelongOrg) as BelongOrgName "+
		    	" from USER_INFO " +
		    	" where UserID = :UserID ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("UserID",sToUserID));
		if(rs.next())
		{
		    sToOrgID = DataConvert.toString(rs.getString("BelongOrg"));
		    sToOrgName = DataConvert.toString(rs.getString("BelongOrgName"));
		}
		rs.getStatement().close();
		
        try
        {
           	for(int j = 0 ; j < ChangeObject.length ; j ++)
	    	{
	        	if(ChangeObject[j].equals("Customer")) //�ͻ�
	        	{
	        		Bizlet bzUpdateCustomerRelaInfo = new UpdateCustomerRelaInfo();
					bzUpdateCustomerRelaInfo.setAttribute("CustomerID",sCustomerID); 
					bzUpdateCustomerRelaInfo.setAttribute("FromUserID",sFromUserID);	
					bzUpdateCustomerRelaInfo.setAttribute("ToUserID",sToUserID);		
					bzUpdateCustomerRelaInfo.run(Sqlca);
	        	}else
	        	{
	        		Bizlet bzUpdateBusiness = new UpdateBusiness();
	        		if(ChangeObject[j].equals("Apply")) //����
	        		{
	        			sSql = 	" select distinct SerialNo "+
		    					" from BUSINESS_APPLY "+
		    					" where CustomerID = :CustomerID "+
		    					" and (OperateUserID = :OperateUserID "+
		    					" or InputUserID = :InputUserID) ";
	        			so = new SqlObject(sSql);
	        			so.setParameter("CustomerID",sCustomerID);
	        			so.setParameter("OperateUserID",sFromUserID);
	        			so.setParameter("InputUserID",sFromUserID);
	        			rs = Sqlca.getASResultSet(so);
	        			while(rs.next())
	        			{
	        				bzUpdateBusiness.setAttribute("ObjectType","CreditApply");
	        				bzUpdateBusiness.setAttribute("ObjectNo",rs.getString(1));
	        				bzUpdateBusiness.setAttribute("ToUserID",sToUserID);
	        				bzUpdateBusiness.setAttribute("ToOrgID",sToOrgID);
	        				bzUpdateBusiness.run(Sqlca);
	        			}
	        			rs.getStatement().close();
	        		}
	        		
	        		if(ChangeObject[j].equals("Approve")) //�����������
	        		{
	        			sSql = 	" select distinct SerialNo "+
		    					" from BUSINESS_APPROVE "+
		    					" where CustomerID = :CustomerID "+
		    					" and (OperateUserID = :OperateUserID "+
		    					" or InputUserID = :InputUserID) ";
	        			so = new SqlObject(sSql);
	        			so.setParameter("CustomerID",sCustomerID);
	        			so.setParameter("OperateUserID",sFromUserID);
	        			so.setParameter("InputUserID",sFromUserID);
	        			rs = Sqlca.getASResultSet(so);
	        			while(rs.next())
	        			{
	        				bzUpdateBusiness.setAttribute("ObjectType","ApproveApply");
	        				bzUpdateBusiness.setAttribute("ObjectNo",rs.getString(1));
	        				bzUpdateBusiness.setAttribute("ToUserID",sToUserID);
	        				bzUpdateBusiness.setAttribute("ToOrgID",sToOrgID);
	        				bzUpdateBusiness.run(Sqlca);
	        			}
	        			rs.getStatement().close();
	        		}
	        		
	        		if(ChangeObject[j].equals("Contract")) //��ͬ
	        		{
	        			sSql = 	" select distinct SerialNo "+
		    					" from BUSINESS_CONTRACT "+
		    					" where CustomerID = :CustomerID "+
		    					" and (ManageUserID = :ManageUserID "+
		    					" or OperateUserID = :OperateUserID "+
		    					" or InputUserID = :InputUserID) ";
	        			so = new SqlObject(sSql);
	        			so.setParameter("CustomerID",sCustomerID);
	        			so.setParameter("OperateUserID",sFromUserID);
	        			so.setParameter("ManageUserID",sFromUserID);
	        			so.setParameter("InputUserID",sFromUserID);
	        			rs = Sqlca.getASResultSet(so);
	        			while(rs.next())
	        			{
	        				bzUpdateBusiness.setAttribute("ObjectType","BusinessContract");
	        				bzUpdateBusiness.setAttribute("ObjectNo",rs.getString(1));
	        				bzUpdateBusiness.setAttribute("ToUserID",sToUserID);
	        				bzUpdateBusiness.setAttribute("ToOrgID",sToOrgID);
	        				bzUpdateBusiness.run(Sqlca);
	        			}
	        			rs.getStatement().close();
	        		}
	        		
	        		if(ChangeObject[j].equals("PutOut")) //����
	        		{
	        			sSql = 	" select distinct SerialNo "+
		    					" from BUSINESS_PUTOUT "+
		    					" where CustomerID = :CustomerID "+
		    					" and (OperateUserID = :OperateUserID "+
		    					" or InputUserID = :InputUserID) ";
	        			so = new SqlObject(sSql);
	        			so.setParameter("CustomerID",sCustomerID);
	        			so.setParameter("OperateUserID",sFromUserID);
	        			so.setParameter("InputUserID",sFromUserID);
	        			rs = Sqlca.getASResultSet(so);
	        			while(rs.next())
	        			{
	        				bzUpdateBusiness.setAttribute("ObjectType","PutOutApply");
	        				bzUpdateBusiness.setAttribute("ObjectNo",rs.getString(1));
	        				bzUpdateBusiness.setAttribute("ToUserID",sToUserID);
	        				bzUpdateBusiness.setAttribute("ToOrgID",sToOrgID);
	        				bzUpdateBusiness.run(Sqlca);
	        			}
	        			rs.getStatement().close();
	        		}
	        		
	        		if(ChangeObject[j].equals("DueBill")) //���
	        		{
	        			sSql = 	" select distinct SerialNo "+
		    					" from BUSINESS_DUEBILL "+
		    					" where CustomerID = :CustomerID "+
		    					" and (OperateUserID = :OperateUserID "+
		    					" or InputUserID = :InputUserID) ";
	        			so = new SqlObject(sSql);
	        			so.setParameter("CustomerID",sCustomerID);
	        			so.setParameter("OperateUserID",sFromUserID);
	        			so.setParameter("InputUserID",sFromUserID);
	        			rs = Sqlca.getASResultSet(so);
	        			while(rs.next())
	        			{
	        				bzUpdateBusiness.setAttribute("ObjectType","BusinessDueBill");
	        				bzUpdateBusiness.setAttribute("ObjectNo",rs.getString(1));
	        				bzUpdateBusiness.setAttribute("ToUserID",sToUserID);
	        				bzUpdateBusiness.setAttribute("ToOrgID",sToOrgID);
	        				bzUpdateBusiness.run(Sqlca);
	        			}
	        			rs.getStatement().close();
	        		}
	        	}
	        }
	        
            //��MANAGE_CHANGE���в����¼�����ڼ�¼��α������
            String sSerialNo =  DBKeyHelp.getSerialNo("MANAGE_CHANGE","SerialNo",Sqlca);
            sSql =  " INSERT INTO MANAGE_CHANGE(ObjectType,ObjectNo,SerialNo,OldOrgID,OldOrgName,NewOrgID,NewOrgName,OldUserID, "+
		    		" OldUserName,NewUserID,NewUserName,ChangeReason,ChangeOrgID,ChangeUserID,ChangeTime) "+
		            " VALUES('Customer',:ObjectNo,:SerialNo,:OldOrgID,:OldOrgName,:NewOrgID,:NewOrgName,:OldUserID, "+
		    		" :OldUserName,:NewUserID,:NewUserName,:ChangeReason,:ChangeOrgID,:ChangeUserID,:ChangeTime)";
			so = new SqlObject(sSql);
			so.setParameter("ObjectNo",sCustomerID);
			so.setParameter("SerialNo",sSerialNo);
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
            

			sFlag = "TRUE";
        }
        catch(Exception e)
        {
           	sFlag = "FALSE";
        }	
	}else
	{
		sFlag = "UNFINISHAPPLY";//������;����
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