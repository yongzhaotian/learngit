<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=注释区;]~*/%>
<%
/* 
  author:  zywei 2006-8-9 
  Tester:
  Content:  手工新增成员信息
  Input Param:
			CustomerID：客户编号	
			RelativeID：关联客户编号
			RelativeType：关联类型		
  Output param:
 
  History Log:     

               
 */
 %>
<%/*~END~*/%>

<%     
	
    //定义变量
    ASResultSet rs = null;
    int iCount1 = 0,iCount2 = 0;
    String sSql = "";
    String sReturnValue = "";
    //获得组件参数
    
    //获得页面参数：客户编号、关联客户编号和关联类型。
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sRelativeID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeID"));
   	String sRelativeType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeType"));
   	//将空值转化为空字符串
   	if(sCustomerID == null) sCustomerID = "";
   	if(sRelativeID == null) sRelativeID = "";
   	if(sRelativeType == null) sRelativeType = "";
   	
   	//检查关联客户是否已存在某集团中
	sSql = 	" select Count(CustomerID) "+ 
			" from CUSTOMER_RELATIVE " +
			" where RelativeID=:RelativeID "+
			" and RelationShip like '04%' "+
			" and length(RelationShip)>2 ";
	rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("RelativeID",sRelativeID));
	if(rs.next())
		iCount1 = rs.getInt(1);
	rs.getStatement().close();	
	if(iCount1 <= 0)
	{
		//检查关联客户是否已存在当前系统自动搜索结果中
		sSql =  " select Count(CustomerID) from GROUP_SEARCH "+
				" where RelativeID = :RelativeID ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("RelativeID",sCustomerID));
		if (rs.next()) 
			iCount2 = rs.getInt(1);	
		rs.getStatement().close();
		
		if(iCount2 <= 0)
		{
			sReturnValue = "HaveRecord_Search"; //客户已经存在系统搜索的结果之内
		}else
		{
			String sNewSql = " Insert into GROUP_SEARCH(CustomerID,RelativeID,SearchFlag, "+
				   " InputOrgid,InputUserid,InputDate,UpdateDate,UpdateOrgid, "+
				   " UpdateUserid,RelativeType) "+
				   " values(:CustomerID,:RelativeID,:SearchFlag,:InputOrgid,:InputUserid,:InputDate,:UpdateDate,:UpdateOrgid,:UpdateUserid,:RelativeType) ";
			SqlObject so = new SqlObject(sNewSql);
			so.setParameter("CustomerID", sCustomerID);
			so.setParameter("RelativeID", sRelativeID);
			so.setParameter("SearchFlag", "2");
			so.setParameter("InputOrgid", CurOrg.getOrgID());
			so.setParameter("InputUserid", CurUser.getUserID());
			so.setParameter("InputDate", StringFunction.getToday());
			so.setParameter("UpdateDate", StringFunction.getToday());
			so.setParameter("UpdateOrgid", CurOrg.getOrgID());
			so.setParameter("UpdateUserid", CurUser.getUserID());
			so.setParameter("RelativeType",sRelativeType);
			Sqlca.executeSQL(so);	
			sReturnValue = "Join"; //该客户已经新增为集团客户。
		}		
	}else
	{
		sReturnValue = "HaveRecord_Member";//客户已经存在，并且已经是某一个集团的成员	
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