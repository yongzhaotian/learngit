<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:  hxli 2004.02.19
 * Tester:
 *
 * Content: 转移合同（后台对数据库的操作）
 * Input Param:
 * 			 UserID:接受客户经理
 *           OrgID:接受机构
 *           SerialNo:合同编号
 * Output param:
 *
 * History Log:
 *  		gecg 2005.3.01	 修改页面
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%
    //获取参数：转移合同、转移前机构代码、转移前机构名称、转移前客户经理代码、转移前客户经理名称、转移后客户经理代码、转移后客户经理名称
    String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
    String sFromOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgID"));
	String sFromOrgName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgName"));		
	String sToOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToOrgID"));
	String sToOrgName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToOrgName"));

	//转移日期
	String sInputDate   = StringFunction.getToday();	
	//转移日志信息
	String sChangeReason = "业务入账机构交接操作人员代码:"+CurUser.getUserID()+"   姓名："+CurUser.getUserName()+"   机构代码："+CurOrg.getOrgID()+"   机构名称："+CurOrg.getOrgName();
	String sSql = "",sFlag = "";
	try{
		//在MANAGE_CHANGE表中插入记录，用于记录这次变更操作
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

	    //变更合同的入账机构
		sSql = " update BUSINESS_CONTRACT set StatOrgID=:StatOrgID where "+
		   	   " SerialNo = :SerialNo ";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("StatOrgID",sToOrgID).setParameter("SerialNo",sSerialNo));	
						
		sFlag = "TRUE";
		
	}catch(Exception e)
	{
		sFlag = "FALSE";
		throw new Exception("合同转移处理失败！"+e.getMessage());
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