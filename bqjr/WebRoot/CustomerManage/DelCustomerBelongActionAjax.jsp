<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Action00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.2
		Tester:
		Content: 删除用户关联关系
		Input Param:
			CustomerID：客户编号					
		Output param:
			ReturnValue:返回值
				ExistApply:存在未终结的申请
				ExistApprove:存在未终结的最终审批意见
				ExistContract:存在未终结的合同
		History Log: 
				syang 2009/10/14 　删除用户关联关系，
				需要删除的不一定是当前用户的关系，
				因此，支持外部传入用户ID,如果没有传入用户ID,则默认使用当前用户，为了为原来的兼容
		
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Action01;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "",sReturnValue = "";		
	int iCount = 0;
	ASResultSet rs = null;
	
	//获取组件参数
	
	//获取页面参数：客户编号
	String sCustomerID   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));	
	String sUserID   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));	
	//将空值转化为空字符串
	if(sCustomerID == null) sCustomerID = "";
	if(sUserID == null || sUserID.length() == 0) sUserID = CurUser.getUserID();	//如果没有传入用户，则默认使用当前用户
%>
<%/*~END~*/%>	


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Action02;Describe=定义业务逻辑;]~*/%>
<%    
	//计算未终结申请业务数
	sSql = " select count(SerialNo) from BUSINESS_APPLY "+
		   " where CustomerID = :CustomerID "+
		   " and PigeonholeDate is null "+
		   " and OperateUserID = :OperateUserID " ;
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID).setParameter("OperateUserID",sUserID));
	if(rs.next()) iCount = rs.getInt(1);
	rs.getStatement().close(); 		
	if (iCount == 0)	//申请业务全部终结
	{	
		//计算未终结最终审批意见业务数
		sSql = " select count(*) from BUSINESS_APPROVE "+
		       " where CustomerID = :CustomerID "+
	           " and PigeonholeDate is null "+
	           " and OperateUserID = :OperateUserID " ;
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID).setParameter("OperateUserID",sUserID));
		if(rs.next()) iCount = rs.getInt(1);
		rs.getStatement().close();
		if(iCount == 0)	//最终审批意见业务全部终结
		{	
			//计算未终结合同业务数
			sSql = " select count(*) from BUSINESS_CONTRACT "+
			       " where CustomerID = :CustomerID "+
		           " and FinishDate is null "+
		           " and ManageUserID = :ManageUserID " ;
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID).setParameter("ManageUserID",sUserID));
			if(rs.next()) iCount = rs.getInt(1);
			rs.getStatement().close();
			if (iCount == 0)	//合同业务全部终结
			{	
				//可以删除所属信息
				String sNewSql = "Delete from  Customer_Belong where CustomerID=:CustomerID and UserID=:UserID";
				SqlObject so = new SqlObject(sNewSql);
				so.setParameter("CustomerID",sCustomerID);
				so.setParameter("UserID",sUserID);
				Sqlca.executeSQL(so);
				//Sqlca.executeSQL("Delete from  Customer_Belong where CustomerID='"+sCustomerID+"'"+" and UserID='"+sUserID+"'");					
				sReturnValue = "DelSuccess";//该客户所属信息已删除！		
			}else
			{
				sReturnValue = "ExistContract";//该客户所属合同业务未终结，不能删除！
			}
		}else
		{
			sReturnValue = "ExistApprove";//该客户所属最终审批意见未终结，不能删除！
		}
	}else
	{
		sReturnValue = "ExistApply";//该客户所属申请业务未终结，不能删除！
	}	
	    	
%>
<%/*~END~*/%>

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