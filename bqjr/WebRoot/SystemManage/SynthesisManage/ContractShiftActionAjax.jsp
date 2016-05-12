<%
/* Copyright 2001-2006 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:  zywei 2006.10.25
 * Tester:
 *
 * Content: ת�ƺ�ͬ����̨�����ݿ�Ĳ�����
 * Input Param:
 * 			 SerialNo����ͬ���
 *           FromOrgID��ת��ǰ��������
 *           FromOrgName��ת��ǰ��������
 * 			 FromUserID��ת��ǰ�ͻ��������
 *           FromUserName��ת��ǰ�ͻ���������
 *           ToUserID��ת�ƺ�ͻ��������
 * 			 ToUserName��ת�ƺ�ͻ���������
 *			 ChangeObject���޸Ķ���
 * Output param:
 *
 * History Log:
 *  		
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%@ page import="com.amarsoft.app.lending.bizlets.*,com.amarsoft.biz.bizlet.Bizlet" %>


<%
    //��ȡ������ת�ƺ�ͬ��ת��ǰ�������롢ת��ǰ�������ơ�ת��ǰ�ͻ�������롢ת��ǰ�ͻ��������ơ�ת�ƺ�ͻ�������롢ת�ƺ�ͻ��������ơ��޸Ķ���
    String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
    String sFromOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgID"));
	String sFromOrgName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgName"));
	String sFromUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromUserID"));
	String sFromUserName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromUserName"));	
	String sToUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToUserID"));
	String sToUserName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToUserName"));
	String sChangeObject = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ChangeObject"));
	
	//ת�ƺ�������������
	String sToOrgID = "",sToOrgName = "";
	//�ͻ���š�������ˮ�š��������������ˮ��
	String sCustomerID = "",sApplySerialNo = "",sApproveSerialNo = "";
	//������ˮ�š������ˮ��
	String[] sPutOutSerialNo = null;
	//�����ˮ��
	String[] sDueBillSerialNo = null;
	//�Ǽ�����	
	String sInputDate   = StringFunction.getToday();
	int i = 0;//������
	int iCountPutPut = 0;//���ʼ�¼��
	int iCountDueBill = 0;//��ݼ�¼��
	//ת����־��Ϣ
	String sChangeReason = "��ͬת�Ʋ�����Ա����:"+CurUser.getUserID()+"   ������"+CurUser.getUserName()+"   �������룺"+CurOrg.getOrgID()+"   �������ƣ�"+CurOrg.getOrgName();
	//ҵ�����Ȩ���Ƿ�ɹ���־
	String sBelongAttribute3 = "",sFlag = "";
    String sSql = " select CB.BelongAttribute3 from BUSINESS_CONTRACT BC,CUSTOMER_BELONG CB where "+
				  " BC.SerialNo = :SerialNo and BC.CustomerID = CB.CustomerID and CB.UserID "+
				  " = :UserID ";
    SqlObject so = new SqlObject(sSql);
    so.setParameter("SerialNo",sSerialNo);
    so.setParameter("UserID",sToUserID);
	ASResultSet rs = Sqlca.getASResultSet(so);
	if(rs.next())
	{
	    sBelongAttribute3 = DataConvert.toString(rs.getString(1));
        if(sBelongAttribute3 == null)
            sBelongAttribute3 = "";
	}
	//�رս����
	rs.getStatement().close();

	if(!sBelongAttribute3.equals("1"))
	{
		sFlag = "NOT";
	}else	
    {//���к�ͬ��ת��
    	StringTokenizer st = new StringTokenizer(sChangeObject,"|");
	    String [] ChangeObject = new String[st.countTokens()];
		while (st.hasMoreTokens()) 
	    {
	        ChangeObject[i] = st.nextToken();                
	        i++;
	    } 
	    
	    //���ݺ�ͬ��ˮ�Ż�ȡ�ͻ���š��������������ˮ��
	    sSql = 	" select CustomerID,RelativeSerialNo "+
				" from BUSINESS_CONTRACT "+
				" where SerialNo = :SerialNo ";
	    rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
	    if(rs.next())
	    {
	    	sCustomerID = rs.getString("CustomerID");
	    	sApproveSerialNo = rs.getString("RelativeSerialNo");
	    }
	    rs.getStatement().close();
	    
	    //�����������������ˮ�Ż�ȡ������ˮ��
	    sApplySerialNo = Sqlca.getString(new SqlObject("select RelativeSerialNo from BUSINESS_APPROVE where SerialNo = :SerialNo").setParameter("SerialNo",sApproveSerialNo));
	    
	    //���ݺ�ͬ��ˮ�Ż�ȡ������ˮ��
	    sSql = 	" select count(SerialNo) "+
				" from BUSINESS_PUTOUT "+
				" where ContractSerialNo = :ContractSerialNo ";
	    rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ContractSerialNo",sSerialNo));
		if(rs.next())
		{
			iCountPutPut = rs.getInt(1);
		}   
		rs.getStatement().close();
		sPutOutSerialNo = new String[iCountPutPut];
		
	    sSql = 	" select SerialNo "+
				" from BUSINESS_PUTOUT "+
				" where ContractSerialNo = :ContractSerialNo ";
	    sPutOutSerialNo = Sqlca.getStringArray(new SqlObject(sSql).setParameter("ContractSerialNo",sSerialNo));	
	   
	    //���ݺ�ͬ��ˮ�Ż�ȡ�����ˮ��
	    sSql = 	" select count(SerialNo) "+
				" from BUSINESS_DUEBILL "+
				" where RelativeSerialNo2 =:RelativeSerialNo2 ";
    	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("RelativeSerialNo2",sSerialNo));
		if(rs.next())
		{
			iCountDueBill = rs.getInt(1);
		}   
		rs.getStatement().close();
		sDueBillSerialNo = new String[iCountDueBill];
		
	    sSql = 	" select SerialNo "+
				" from BUSINESS_DUEBILL "+
				" where RelativeSerialNo2 = :RelativeSerialNo2 ";
	    sDueBillSerialNo = Sqlca.getStringArray(new SqlObject(sSql).setParameter("RelativeSerialNo2",sSerialNo));
	   	    
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

    	try{
    		for(int j = 0 ; j < ChangeObject.length ; j ++)
	    	{
	        	if(ChangeObject[j].equals("Customer")) //�ͻ�
	        	{
	        		System.out.println("----------Customer--------"+sCustomerID);
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
	        			System.out.println("---------Apply--------"+sApplySerialNo);
        				bzUpdateBusiness.setAttribute("ObjectType","CreditApply");
        				bzUpdateBusiness.setAttribute("ObjectNo",sApplySerialNo);
        				bzUpdateBusiness.setAttribute("ToUserID",sToUserID);
        				bzUpdateBusiness.setAttribute("ToOrgID",sToOrgID);
        				bzUpdateBusiness.run(Sqlca);
	        		}
	        		
	        		if(ChangeObject[j].equals("Approve")) //�����������
	        		{	
	        			System.out.println("---------Approve--------"+sApproveSerialNo);        			
        				bzUpdateBusiness.setAttribute("ObjectType","ApproveApply");
        				bzUpdateBusiness.setAttribute("ObjectNo",sApproveSerialNo);
        				bzUpdateBusiness.setAttribute("ToUserID",sToUserID);
        				bzUpdateBusiness.setAttribute("ToOrgID",sToOrgID);
        				bzUpdateBusiness.run(Sqlca);	        			
	        		}
	        		
	        		if(ChangeObject[j].equals("Contract")) //��ͬ
	        		{	
	        			System.out.println("---------Contract--------"+sSerialNo);   			
        				bzUpdateBusiness.setAttribute("ObjectType","BusinessContract");
        				bzUpdateBusiness.setAttribute("ObjectNo",sSerialNo);
        				bzUpdateBusiness.setAttribute("ToUserID",sToUserID);
        				bzUpdateBusiness.setAttribute("ToOrgID",sToOrgID);
        				bzUpdateBusiness.run(Sqlca);	        			
	        		}
	        		
	        		if(ChangeObject[j].equals("PutOut") && iCountPutPut > 0) //����
	        		{	        	
        				for(int k = 0;k < sPutOutSerialNo.length;k++)
        				{
	        				System.out.println("---------PutOut--------"+sPutOutSerialNo[k]);  		
	        				bzUpdateBusiness.setAttribute("ObjectType","PutOutApply");
	        				bzUpdateBusiness.setAttribute("ObjectNo",sPutOutSerialNo[k]);
	        				bzUpdateBusiness.setAttribute("ToUserID",sToUserID);
	        				bzUpdateBusiness.setAttribute("ToOrgID",sToOrgID);
	        				bzUpdateBusiness.run(Sqlca);	
	        			}        			
	        		}
	        		
	        		if(ChangeObject[j].equals("DueBill") && iCountDueBill > 0) //���
	        		{	          					
        				for(int l = 0;l < sPutOutSerialNo.length;l++)
        				{
	        				System.out.println("---------DueBill--------"+sDueBillSerialNo[l]);
	        				bzUpdateBusiness.setAttribute("ObjectType","BusinessDueBill");
	        				bzUpdateBusiness.setAttribute("ObjectNo",sDueBillSerialNo[l]);
	        				bzUpdateBusiness.setAttribute("ToUserID",sToUserID);
	        				bzUpdateBusiness.setAttribute("ToOrgID",sToOrgID);
	        				bzUpdateBusiness.run(Sqlca);
	        			}	        			
	        		}
	        	}
	        }
    	
    		//��MANAGE_CHANGE���в����¼�����ڼ�¼��α������
            String sSerialNo1 =  DBKeyHelp.getSerialNo("MANAGE_CHANGE","SerialNo",Sqlca);
            sSql =  " INSERT INTO MANAGE_CHANGE(ObjectType,ObjectNo,SerialNo,OldOrgID,OldOrgName,NewOrgID,NewOrgName,OldUserID, "+
		    		" OldUserName,NewUserID,NewUserName,ChangeReason,ChangeOrgID,ChangeUserID,ChangeTime) "+
		            " VALUES('BusinessContract',:ObjectNo,:SerialNo,:OldOrgID,:OldOrgName,:NewOrgID,:NewOrgName,:OldUserID, "+
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
            		
			sFlag = "TRUE";
		}catch(Exception e)
		{
			sFlag = "FALSE";
			throw new Exception("��ͬת�ƴ���ʧ�ܣ�"+e.getMessage());
		}
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