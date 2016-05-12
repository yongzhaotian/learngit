<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  --JBai 2005.12.17
		Tester:
		Content: --客户信息检查
		Input Param:
			  UserID：客户编码
			  OrgID：机构代码			                				
			  CustomerID：客户号
			  sCustomerType ：客户类型
		Output param:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户信息校验"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>

<%  
    //定义变量：sql语句
	String sSql = "",sReturnValue="";
	
	//获得组件参数
	
    //获得页面参数：客户编号、机构代码、客户编号、客户类型
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgID"));
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));	
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
   
   	if(sCustomerType == null) sCustomerType = "";
   	
	if(sCustomerType.equals("02"))
	{
	   try 
	   {		
			String sNewSql = " update CUSTOMER_BELONG set OrgID = :OrgID , UserID = :UserID"+
							 " where CustomerID = :CustomerID and Belongattribute = '1'";
			SqlObject so = new SqlObject(sNewSql);
			so.setParameter("OrgID",sOrgID);
			so.setParameter("UserID",sUserID);
			so.setParameter("CustomerID",sCustomerID);
			Sqlca.executeSQL(so);
			sReturnValue="succeed";
		} catch(Exception e)
		{	
			throw new Exception("事务处理失败！"+e.getMessage());
		}			
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