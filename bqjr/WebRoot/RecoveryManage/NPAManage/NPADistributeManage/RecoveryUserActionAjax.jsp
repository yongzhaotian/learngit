
<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   xxge 2004-11-25
 * Tester:
 *
 * Content:  更新指定合同的不良资产管理人
 * Input Param:
 *		SerialNo：合同流水号
 *		ShiftType：移交类型（01：审批移交；02：客户移交）
 *		RecoveryUserID: 不良资产管理人
 *		RecoveryOrgID：不良资产管理人所属机构
 *		Flag：标志（1：跟踪人）
 * Output param:
 * History Log:  
 *	      
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//合同流水号、移交类型、不良资产管理人或跟踪人代码、所属机构
	String sReturnValue="";
	String sContractNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("SerialNo")); 	
	String sShiftType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ShiftType")); 	
	String sRecoveryUser = DataConvert.toRealString(iPostChange,CurPage.getParameter("RecoveryUserID")); 
	String sRecoveryOrg = DataConvert.toRealString(iPostChange,CurPage.getParameter("RecoveryOrgID")); 
	String sFlag=DataConvert.toRealString(iPostChange,CurPage.getParameter("Flag")); 
	//将空值转化为空字符串
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
		if (sFlag.equals("1"))   //指定跟踪人进入
		{
			if (sShiftType.equals("02"))  //如果是客户移交的合同，那么指定跟踪人，不移交。
			{
				
			}else  //如果是审批移交的合同，那么增加跟踪人，移交。
			{
						 
					sSql= " UPDATE BUSINESS_CONTRACT "+
						 "  SET RecoveryUserID=:RecoveryUserID, RecoveryOrgID=:RecoveryOrgID" + 
						 "  WHERE  SerialNo=:SerialNo"; 
					so = new SqlObject(sSql).setParameter("RecoveryUserID",sRecoveryUser)
					.setParameter("RecoveryOrgID",sRecoveryOrg).setParameter("SerialNo",sContractNo);
					Sqlca.executeSQL(so);
	
					
			}
		}
		else  // 指定管理人进入
		{
	        
	        sSql= " UPDATE BUSINESS_CONTRACT "+
	             "  SET RecoveryUserID=:RecoveryUserID, RecoveryOrgID=:RecoveryOrgID" + 
	             "  WHERE  SerialNo=:SerialNo";   
			so = new SqlObject(sSql).setParameter("RecoveryUserID",sRecoveryUser)
			.setParameter("RecoveryOrgID",sRecoveryOrg).setParameter("SerialNo",sContractNo);   		
	    	Sqlca.executeSQL(so);
	    	if(sShiftType.equals("01")) //如果审批移交指定跟踪人，需要往跟踪信息表中插入数据
	    	{
	    		
	    	}
		}
		sReturnValue="true";
	}catch(Exception e){
		e.fillInStackTrace();
		sReturnValue="false";
	}
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>
