<%
/* Copyright 2001-2006 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:  zywei 2006.10.25
 * Tester:
 *
 * Content: 转移合同（后台对数据库的操作）
 * Input Param:
 * 			 SerialNo：合同编号
 *           FromOrgID：转移前机构代码
 *           FromOrgName：转移前机构名称
 * 			 FromUserID：转移前客户经理代码
 *           FromUserName：转移前客户经理名称
 *           ToUserID：转移后客户经理代码
 * 			 ToUserName：转移后客户经理名称
 *			 ChangeObject：修改对象
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
    //获取参数：转移合同、转移前机构代码、转移前机构名称、转移前客户经理代码、转移前客户经理名称、转移后客户经理代码、转移后客户经理名称、修改对象
    String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
    String sFromOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgID"));
	String sFromOrgName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgName"));
	String sFromUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromUserID"));
	String sFromUserName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromUserName"));	
	String sToUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToUserID"));
	String sToUserName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToUserName"));
	String sChangeObject = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ChangeObject"));
	
	//转移后机构代码和名称
	String sToOrgID = "",sToOrgName = "";
	//客户编号、申请流水号、最终审批意见流水号
	String sCustomerID = "",sApplySerialNo = "",sApproveSerialNo = "";
	//出帐流水号、借据流水号
	String[] sPutOutSerialNo = null;
	//借据流水号
	String[] sDueBillSerialNo = null;
	//登记日期	
	String sInputDate   = StringFunction.getToday();
	int i = 0;//计数器
	int iCountPutPut = 0;//出帐记录数
	int iCountDueBill = 0;//借据记录数
	//转移日志信息
	String sChangeReason = "合同转移操作人员代码:"+CurUser.getUserID()+"   姓名："+CurUser.getUserName()+"   机构代码："+CurOrg.getOrgID()+"   机构名称："+CurOrg.getOrgName();
	//业务办理权、是否成功标志
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
	//关闭结果集
	rs.getStatement().close();

	if(!sBelongAttribute3.equals("1"))
	{
		sFlag = "NOT";
	}else	
    {//进行合同的转移
    	StringTokenizer st = new StringTokenizer(sChangeObject,"|");
	    String [] ChangeObject = new String[st.countTokens()];
		while (st.hasMoreTokens()) 
	    {
	        ChangeObject[i] = st.nextToken();                
	        i++;
	    } 
	    
	    //根据合同流水号获取客户编号、最终审批意见流水号
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
	    
	    //根据最终审批意见流水号获取申请流水号
	    sApplySerialNo = Sqlca.getString(new SqlObject("select RelativeSerialNo from BUSINESS_APPROVE where SerialNo = :SerialNo").setParameter("SerialNo",sApproveSerialNo));
	    
	    //根据合同流水号获取出帐流水号
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
	   
	    //根据合同流水号获取借据流水号
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

    	try{
    		for(int j = 0 ; j < ChangeObject.length ; j ++)
	    	{
	        	if(ChangeObject[j].equals("Customer")) //客户
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
	        		if(ChangeObject[j].equals("Apply")) //申请
	        		{
	        			System.out.println("---------Apply--------"+sApplySerialNo);
        				bzUpdateBusiness.setAttribute("ObjectType","CreditApply");
        				bzUpdateBusiness.setAttribute("ObjectNo",sApplySerialNo);
        				bzUpdateBusiness.setAttribute("ToUserID",sToUserID);
        				bzUpdateBusiness.setAttribute("ToOrgID",sToOrgID);
        				bzUpdateBusiness.run(Sqlca);
	        		}
	        		
	        		if(ChangeObject[j].equals("Approve")) //最终审批意见
	        		{	
	        			System.out.println("---------Approve--------"+sApproveSerialNo);        			
        				bzUpdateBusiness.setAttribute("ObjectType","ApproveApply");
        				bzUpdateBusiness.setAttribute("ObjectNo",sApproveSerialNo);
        				bzUpdateBusiness.setAttribute("ToUserID",sToUserID);
        				bzUpdateBusiness.setAttribute("ToOrgID",sToOrgID);
        				bzUpdateBusiness.run(Sqlca);	        			
	        		}
	        		
	        		if(ChangeObject[j].equals("Contract")) //合同
	        		{	
	        			System.out.println("---------Contract--------"+sSerialNo);   			
        				bzUpdateBusiness.setAttribute("ObjectType","BusinessContract");
        				bzUpdateBusiness.setAttribute("ObjectNo",sSerialNo);
        				bzUpdateBusiness.setAttribute("ToUserID",sToUserID);
        				bzUpdateBusiness.setAttribute("ToOrgID",sToOrgID);
        				bzUpdateBusiness.run(Sqlca);	        			
	        		}
	        		
	        		if(ChangeObject[j].equals("PutOut") && iCountPutPut > 0) //出帐
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
	        		
	        		if(ChangeObject[j].equals("DueBill") && iCountDueBill > 0) //借据
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
    	
    		//在MANAGE_CHANGE表中插入记录，用于记录这次变更操作
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
			throw new Exception("合同转移处理失败！"+e.getMessage());
		}
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