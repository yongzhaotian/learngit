<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   ndeng  2005.04.18
		Tester:
		Content: 转移客户主办权
		Input Param:
			  CustomerID：客户代码
		Output param:
		History Log: 
			
	 */
	%>
<%/*~END~*/%>
<%

	//定义变量
	String sReturnValue="";
	SqlObject so = null;
	String sNewSql = "";	
	//获得组件参数
	
	//获得页面参数
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
	String sBelongUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BelongUserID"));
%>

<%		
	try{
      //将原来用户对当前客户的主办权、信息查看权、信息维护权、业务办理权全部置为“无”
      sNewSql = "Update CUSTOMER_BELONG set BelongAttribute='2',BelongAttribute1='2',BelongAttribute2='2',BelongAttribute3='2',BelongAttribute4='2',ApplyStatus=null,ApplyRight=null where CustomerID=:CustomerID and UserID=:UserID";
	  so = new SqlObject(sNewSql);
	  so.setParameter("CustomerID",sCustomerID);
	  so.setParameter("UserID",sBelongUserID);
	  Sqlca.executeSQL(so);
      //将当前用户对当前客户的主办权、信息查看权、信息维护权、业务办理权全部置为“有”
      sNewSql = "Update CUSTOMER_BELONG set BelongAttribute='1',BelongAttribute1='1',BelongAttribute2='1',BelongAttribute3='1',BelongAttribute4='1' where CustomerID=:CustomerID and UserID=:UserID";
      so = new SqlObject(sNewSql);
	  so.setParameter("CustomerID",sCustomerID);
	  so.setParameter("UserID",sUserID);
	  Sqlca.executeSQL(so);
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
