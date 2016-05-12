<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   FSGong 2004-12-16
 * Tester:
 *
 * Content:  
 * Input Param:
 *		ObjectNo：对象编号 
 *		ObjectType: 对象类型
 * Output param	：统计结果。
 *
 * History Log:  
 *	      
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%
	String sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo")); //资产流水号
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	//将空值转化为空字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	
	//定义变量
	String sSql = "";
	String sReturnValue="";
	double  dSum1 = 0;//统计累计出租回收金额
	double  dSum2 = 0;//统计累计出售回收金额
	double  dSum3 = 0;//统计累计费用支付总额
	double  dSum4 = 0;//统计处理净收入
	ASResultSet rs = null;
	SqlObject so = null;

 	//统计累计出租回收金额:人民币
	sSql = 	" select sum(RMBSum) as my_Sum  from RECLAIM_INFO "+
			" where  ObjectNo = :ObjectNo "+
			" and ObjectType = :ObjectType "+
			" and CashBackType = '01' ";
	so = new SqlObject(sSql).setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);
	rs = Sqlca.getASResultSet(so);
	if (rs.next())
		dSum1=rs.getDouble(1);	
	rs.getStatement().close(); 
 	
 	//统计累计出售回收金额:人民币
	sSql = 	" select sum(RMBSum) as my_Sum  from RECLAIM_INFO "+
			" where ObjectNo = :ObjectNo "+
			" and ObjectType = :ObjectType "+
			" and CashBackType in ('02','03','04','05') ";
	so = new SqlObject(sSql).setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);	
	rs = Sqlca.getASResultSet(so);
	if (rs.next())
		dSum2=rs.getDouble(1);
	rs.getStatement().close(); 
 	
 	//统计累计费用支付总额:人民币
	sSql = 	" select sum(CostSum) as my_Sum from COST_INFO "+
			" where  ObjectNo = :ObjectNo "+
			" and ObjectType = :ObjectType "+
			" and AccountDesc <> '02' ";//不考虑列为营业外支出的费用.
	so = new SqlObject(sSql).setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);	
	rs = Sqlca.getASResultSet(so);
	if (rs.next())
	  	dSum3=rs.getDouble(1);
	rs.getStatement().close(); 

   	//统计处理净收入
	dSum4=dSum1+dSum2-dSum3;	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(dSum1+"");
	args.addArg(dSum2+"");
	args.addArg(dSum3+"");
	args.addArg(dSum4+"");
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>