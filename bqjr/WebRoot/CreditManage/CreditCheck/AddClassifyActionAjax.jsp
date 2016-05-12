<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   zywei 2005/09/09
 * Tester:
 *
 * Content:   新增资产风险分类信息
 * Input Param:
 *		AccountMonth：会计月份
 *		ObjectType：对象类型
 *		ObjectNo：对象编号
 *		ModelNo：模型号
 * Output param:
 * History Log:  
 *	      
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%
	//定义变量：Sql语句
	String sSql = "";
	//定义变量：分类流水号
	String sSerialNo = "";
	//定义变量：余额
	double dBalance = 0.0;
	//定义变量：查询结果集
	ASResultSet rs = null;
	SqlObject so = null;
	String sReturnValue="";
	
	//获取页面参数：会计月份、对象类型、对象编号、类型、模型号
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth")); 
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")); 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	String sModelNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ModelNo")); 
	
	//将空值转化为空字符串
	if(sAccountMonth == null) sAccountMonth = ""; 
	if(sObjectType == null) sObjectType = ""; 
	if(sObjectNo == null) sObjectNo = ""; 
	if(sType == null) sType = ""; 
	if(sModelNo == null) sModelNo = ""; 
	
	//根据对象类型设置其表名
	String sTableName = "";
	if(sObjectType.equals("BusinessContract"))
	{
		sTableName = "BUSINESS_CONTRACT";
	}			
	if(sObjectType.equals("BusinessDueBill"))
	{
		sTableName = "BUSINESS_DUEBILL";
	}
	
	try
	{	
		//如果是批量分类
		if(sType.equals("Batch"))
		{
			String sObjectNo1 = sTableName+".SerialNo";
			sSql = 	" select SerialNo,nvl(Balance,0) as Balance "+
					" from "+sTableName+" "+
					" where not exists (select 1 "+
					" from CLASSIFY_RECORD "+
					" where ObjectType =:ObjectType "+
					" and AccountMonth =:AccountMonth and ObjectNo=:ObjectNo) "+
					" and Balance > 0 ";
			so = new SqlObject(sSql);
			so.setParameter("ObjectType",sObjectType).setParameter("AccountMonth",sAccountMonth).setParameter("ObjectNo",sObjectNo1);
			rs = Sqlca.getASResultSet(so);
			while(rs.next())
			{
				sObjectNo = rs.getString("SerialNo");
				dBalance = rs.getDouble("Balance");
				//获得资产风险分类流水号
				sSerialNo = DBKeyHelp.getSerialNo("CLASSIFY_RECORD","SerialNo",Sqlca);
				//新增资产风险分类信息	
				sSql = 	" insert into CLASSIFY_RECORD(SerialNo,ObjectType,ObjectNo,AccountMonth,ModelNo,"+
					   	" BusinessBalance,Sum1,Sum2,Sum3,Sum4,Sum5,UserID,OrgID,InputDate,ClassifyDate,UpdateDate)"+		
					   	" values(:SerialNo,:ObjectType,:ObjectNo,:AccountMonth,:ModelNo,:BusinessBalance,"+
					   	" :Sum1,:Sum2,:Sum3,:Sum4,:Sum5,:UserID,:OrgID,:InputDate,:ClassifyDate,"+
					   	" :UpdateDate) ";
				so = new SqlObject(sSql);
				so.setParameter("SerialNo",sSerialNo).setParameter("ObjectType",sObjectType)
				.setParameter("ObjectNo",sObjectNo).setParameter("AccountMonth",sAccountMonth)
				.setParameter("ModelNo",sModelNo).setParameter("BusinessBalance",dBalance)
				.setParameter("Sum1",0.00).setParameter("Sum2",0.00).setParameter("Sum3",0.00).setParameter("Sum4",0.00)
				.setParameter("Sum5",0.00).setParameter("UserID",CurUser.getUserID()).setParameter("OrgID",CurOrg.getOrgID()).setParameter("InputDate",StringFunction.getToday())
				.setParameter("ClassifyDate",StringFunction.getToday()).setParameter("UpdateDate",StringFunction.getToday());			
				Sqlca.executeSQL(so);		    	
				    				
				sSql = 	" insert into CLASSIFY_DATA(ObjectType,ObjectNo,SerialNo,ItemNo) " + 
						" select '"+sObjectType+"','"+sObjectNo+"','"+sSerialNo+"'," +   
		        		" ItemNo from EVALUATE_MODEL where ModelNo =:ModelNo ";
				so = new SqlObject(sSql);
				so.setParameter("ModelNo",sModelNo);
				Sqlca.executeSQL(so);
			}
			rs.getStatement().close();			
		}else
		{
			//查询合同/借据的余额
			sSql = 	" select Balance "+
					" from "+sTableName+" "+
					" where SerialNo =:SerialNo ";
			so = new SqlObject(sSql);
			so.setParameter("SerialNo",sObjectNo);
			rs = Sqlca.getASResultSet(so);
			if(rs.next())
				dBalance = rs.getDouble("Balance");
	
			rs.getStatement().close();
			
			//获得资产风险分类流水号
			sSerialNo = DBKeyHelp.getSerialNo("CLASSIFY_RECORD","SerialNo",Sqlca);
			//新增资产风险分类信息	
			sSql = 	" insert into CLASSIFY_RECORD(SerialNo,ObjectType,ObjectNo,AccountMonth,ModelNo,"+
				   	" BusinessBalance,Sum1,Sum2,Sum3,Sum4,Sum5,UserID,OrgID,InputDate,ClassifyDate,UpdateDate)"+		
				   	" values(:SerialNo,:ObjectType,:ObjectNo,:AccountMonth,:ModelNo,:BusinessBalance,"+
				   	" :Sum1,:Sum2,:Sum3,:Sum4,:Sum5,:UserID,:OrgID,:InputDate,:ClassifyDate,"+
				   	" :UpdateDate) ";
			so = new SqlObject(sSql);
			so.setParameter("SerialNo",sSerialNo).setParameter("ObjectType",sObjectType)
				.setParameter("ObjectNo",sObjectNo).setParameter("AccountMonth",sAccountMonth)
				.setParameter("ModelNo",sModelNo).setParameter("BusinessBalance",dBalance)
				.setParameter("Sum1",0.00).setParameter("Sum2",0.00).setParameter("Sum3",0.00).setParameter("Sum4",0.00)
				.setParameter("Sum5",0.00).setParameter("UserID",CurUser.getUserID()).setParameter("OrgID",CurOrg.getOrgID()).setParameter("InputDate",StringFunction.getToday())
				.setParameter("ClassifyDate",StringFunction.getToday()).setParameter("UpdateDate",StringFunction.getToday());			
			Sqlca.executeSQL(so);	    	
			    				
			sSql = 	" insert into CLASSIFY_DATA(ObjectType,ObjectNo,SerialNo,ItemNo) " + 
			" select '"+sObjectType+"','"+sObjectNo+"','"+sSerialNo+"'," +   
    		" ItemNo from EVALUATE_MODEL where ModelNo =:ModelNo ";
			so = new SqlObject(sSql);
			so.setParameter("ModelNo",sModelNo);
			Sqlca.executeSQL(so);
		}
	}catch(Exception e)
	{
		throw new Exception("事务处理失败！"+e.getMessage());
	}    	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sSerialNo);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>
