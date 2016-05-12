<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  cchang  2004.12.2
		Tester:
		Content: --权限申请弹出页面
		Input Param:
			  CustomerID  ：--客户号
		Output param:
			               
		History Log: 
		   DATE	    CHANGER		CONTENT
		   2005.7.27 fbkang     修改新的版本
		   2009.5.25 fwang      修改新的版本
		
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
	//页面参数之间的传递一定要用DataConvert.toRealString(iPostChange,只要一个参数)它会自动适应window.open或者window.open
	//获取表名、列名和格式
	//定义变量	
	String  sSql = "";//--存放sql语句	
	String  sSuperiorOrgID = "";//--存放上级金融机构代码
	String  sSuperiorOrgName = "";//--存放上级金融机构名称
	String  sMessage = "";//--存放信息
	String  sFlag = "";//--存放一个标签
	ASResultSet rs = null;//--存放结果集
	//获取页面参数
	String	sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	//获取组件参数	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=获取变量值;]~*/%>
<%
	//获取当前机构的上级机构
	sSql = 	" select OI.RelativeOrgID as SuperiorOrgID,getOrgName(OI.RelativeOrgID) as SuperiorOrgName "+
		    " from ORG_INFO OI"+
			" where OI.OrgID = :OrgID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("OrgID",CurOrg.getOrgID()));
	if(rs.next())
	{
		sSuperiorOrgID = rs.getString("SuperiorOrgID");
		sSuperiorOrgName = rs.getString("SuperiorOrgName");	
	}
	rs.getStatement().close();
	
	/*sSql = " select ApplyType " +
		   " from CUSTOMER_BELONG " +
		   " where CustomerID = '"+sCustomerID+"'";*/
	sSql = " select ApplyType " +
	   	   " from CUSTOMER_BELONG " +
	   	   " where CustomerID = :CustomerID";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(rs.next())
	{
		sFlag = rs.getString("ApplyType");
	}
	rs.getStatement().close();
	
	SqlObject so = null;
	String sNewSql = "";	
		
	if(sFlag.equals("1")){
		sNewSql = "update CUSTOMER_BELONG set ApplyRight=:ApplyRight where CustomerID=:CustomerID and UserID=:UserID";
		so = new SqlObject(sNewSql);
		so.setParameter("ApplyRight",CurOrg.getOrgID());
		so.setParameter("CustomerID",sCustomerID);
		so.setParameter("UserID",CurUser.getUserID());
		Sqlca.executeSQL(so);
		//Sqlca.executeSQL("update CUSTOMER_BELONG set ApplyRight='"+CurOrg.getOrgID()+"' where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.getUserID()+"'");
		sMessage = "该客户权限申请消息已经发送到【"+CurOrg.getOrgName()+"】，请与以上机构的客户权限管理人员进行联络。 ";
		}	
	if(sFlag.equals("2")){
		sNewSql = "update CUSTOMER_BELONG set ApplyRight=:ApplyRight where CustomerID=:CustomerID and UserID=:UserID";
		so = new SqlObject(sNewSql);
		so.setParameter("ApplyRight",sSuperiorOrgID);
		so.setParameter("CustomerID",sCustomerID);
		so.setParameter("UserID",CurUser.getUserID());
		Sqlca.executeSQL(so);
		//Sqlca.executeSQL("update CUSTOMER_BELONG set ApplyRight='"+sSuperiorOrgID+"' where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.getUserID()+"'");
		sMessage = "该客户权限申请消息已经发送到【"+sSuperiorOrgName+"】，请与以上机构的客户权限管理人员进行联络。 ";
		}	
	if(sFlag.equals("3")){
		sNewSql = "update CUSTOMER_BELONG set ApplyRight=:ApplyRight where CustomerID=:CustomerID and UserID=:UserID";  //modified by yzheng 2013-06-01
		so = new SqlObject(sNewSql);
		so.setParameter("ApplyRight",sSuperiorOrgID);
		so.setParameter("CustomerID",sCustomerID);
		so.setParameter("UserID",CurUser.getUserID());
		Sqlca.executeSQL(so);
		//Sqlca.executeSQL("update CUSTOMER_BELONG set ApplyRight='9900' where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.getUserID()+"'");
		sMessage = "该客户权限申请消息已经发送到【"+sSuperiorOrgName+"】，请与以上机构的客户权限管理人员进行联络。 ";
	}	
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sMessage);
	sMessage = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sMessage);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>
