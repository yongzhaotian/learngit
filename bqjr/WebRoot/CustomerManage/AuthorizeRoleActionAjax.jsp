<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   --fbkang  2005.07.27
		Tester:
		Content:  --得到客户号
		Input Param:
	        CustomerID：客户代码
	        UserID：用户代码
	        ApplyAttribute：申请客户主办权标志
	        ApplyAttribute1：申请信息查看权标志
	        ApplyAttribute2：申请信息维护标志
	        ApplyAttribute3：申请申请业务申办权标志	
	        ApplyAttribute4：待定的权限标志		                
		Output param:
		History Log: 
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户权限申请情况"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量   
    String sOrgName = "";//--//金融机构名称
    String sUserName = "";//--用户名称
    String sBelongUserID = "";//--所属用户
    String sSql = "",sReturnValue=""; //--Sql语句
    String sHave = "_FALSE_";      //该客户是否有主办权
	//获得组件参数,客户代码、用户代码、申请客户主办权标志、申请信息查看权标志、申请信息维护标志、申请申请业务申办权标志、待定权限标志
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserID"));
	String sApplyAttribute  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyAttribute"));
	String sApplyAttribute1 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyAttribute1"));
	String sApplyAttribute2 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyAttribute2"));
	String sApplyAttribute3 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyAttribute3"));
	String sApplyAttribute4 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyAttribute4"));
	//将空值转化为空字符串
	if(sCustomerID == null) sCustomerID = "";           
    if(sUserID == null) sUserID = "";
	if(sApplyAttribute == null) sApplyAttribute = "";           
    if(sApplyAttribute1 == null) sApplyAttribute1 = "";
    if(sApplyAttribute2 == null) sApplyAttribute2 = "";
    if(sApplyAttribute3 == null) sApplyAttribute3 = "";
    if(sApplyAttribute4 == null) sApplyAttribute4 = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=获取数据值 ;]~*/%>
<%     
    //客户主办权
	if(sApplyAttribute.equals("1"))
	{
	    //判断是否有其他客户经理已具有该客户的主办权
        sSql = " select BelongAttribute,getOrgName(OrgID) as OrgName, "+
			   " getUserName(UserID) as UserName,UserID "+
               " from CUSTOMER_BELONG "+
               " where CustomerID=:CustomerID "+
               " and UserID <> :UserID "+
               " and BelongAttribute = '1'";
	    ASResultSet rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID).setParameter("UserID",sUserID));
	    if(rs.next()) 
	    {
	        sHave = "_TRUE_";  //已有主办权
	        sOrgName = rs.getString("OrgName");
	        sUserName = rs.getString("UserName");
	        sBelongUserID = rs.getString("UserID");
	    }
	    rs.getStatement().close();	    
	}
	
	//如果该客户的主办权还没有用户拥有，则直接根据审批结果进行客户权限的更新
	if(sHave.equals("_FALSE_"))
	{  
    	sSql = " Update CUSTOMER_BELONG set BelongAttribute = :BelongAttribute, "+
				" BelongAttribute1 = :BelongAttribute1,BelongAttribute2 = :BelongAttribute2, "+
				" BelongAttribute3 = :BelongAttribute3,BelongAttribute4 = :BelongAttribute4 "+
				" where CustomerID = :CustomerID "+
				" and UserID = :UserID ";
    	SqlObject so = new SqlObject(sSql);
    	so.setParameter("BelongAttribute",sApplyAttribute);
    	so.setParameter("BelongAttribute1",sApplyAttribute1);
    	so.setParameter("BelongAttribute2",sApplyAttribute2);
    	so.setParameter("BelongAttribute3",sApplyAttribute3);
    	so.setParameter("BelongAttribute4",sApplyAttribute4);
    	so.setParameter("CustomerID",sCustomerID);
    	so.setParameter("UserID",sUserID);
    	Sqlca.executeSQL(so);
    } 
	sReturnValue=sHave+"@"+sOrgName+"@"+sUserName+"@"+sBelongUserID;
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
