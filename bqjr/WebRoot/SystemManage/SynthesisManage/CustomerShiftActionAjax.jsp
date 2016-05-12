<%
/* Copyright 2001-2006 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:  zywei 2006.10.25
 * Tester:
 *
 * Content: 交接客户动作
 * Input Param:
 *			CustomerID：待交接的客户编号
 *			FromOrgID：交接前机构代码
 *			FromOrgName：交接前机构名称
 *          FromUserID：交接前客户经理代码
 *          FromUserName：交接前客户经理名称
 *          ToUserID：交接后客户经理代码
 *          ToUserName：交接后客户经理代码
 *			ChangeObject：修改对象
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
	//获取参数：交接客户、交接前机构代码、交接前机构名称、交接前客户经理代码、交接前客户经理名称、交接后客户经理代码、交接后客户经理名称、修改对象
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
	
    //变量定义   
    String sInputDate   = StringFunction.getToday();
    //交接后的机构代码和名称
    String sToOrgID = "",sToOrgName = "";
	ASResultSet rs = null; //查询结果集
	int iCount = 0; //记录数
	int i = 0;//计数器
    String sSql = ""; //SQL语句
    String sFlag = ""; //交接是否成功标志
    
    //交接日志信息
	String sChangeReason = "客户交接操作人员代码:"+CurUser.getUserID()+"   姓名："+CurUser.getUserName()+"   机构代码："+CurOrg.getOrgID()+"   机构名称："+CurOrg.getOrgName();
    //判断是否有未审批通过的申请
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
	            
        //查询交接后客户经理所在机构代码和名称
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
	        	if(ChangeObject[j].equals("Customer")) //客户
	        	{
	        		Bizlet bzUpdateCustomerRelaInfo = new UpdateCustomerRelaInfo();
					bzUpdateCustomerRelaInfo.setAttribute("CustomerID",sCustomerID); 
					bzUpdateCustomerRelaInfo.setAttribute("FromUserID",sFromUserID);	
					bzUpdateCustomerRelaInfo.setAttribute("ToUserID",sToUserID);		
					bzUpdateCustomerRelaInfo.run(Sqlca);
	        	}else
	        	{
	        		Bizlet bzUpdateBusiness = new UpdateBusiness();
	        		if(ChangeObject[j].equals("Apply")) //申请
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
	        		
	        		if(ChangeObject[j].equals("Approve")) //最终审批意见
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
	        		
	        		if(ChangeObject[j].equals("Contract")) //合同
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
	        		
	        		if(ChangeObject[j].equals("PutOut")) //出帐
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
	        		
	        		if(ChangeObject[j].equals("DueBill")) //借据
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
	        
            //在MANAGE_CHANGE表中插入记录，用于记录这次变更操作
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
		sFlag = "UNFINISHAPPLY";//存在在途申请
	}	
%>
  

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sFlag);
	sFlag = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sFlag);
%>
<%/*~END~*/%>

  
<%@ include file="/IncludeEndAJAX.jsp"%>