<%@page import="com.sun.java.swing.plaf.windows.resources.windows"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		重新加载当前登陆用户属性
	 */
	%>
<%/*~END~*/%> 

<%	
	String	sSno  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("sno"));//门店或者展厅编号
	String	sMoblieposno  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PosNo"));//移动Pos点编号  add by clhuang 2015/05/28

	String sSql = "";
	String sSqlPos = "";
	ASResultSet rsPos = null;
	ASResultSet rs = null;
	SqlObject so = null;
	try{
		//更新当前用户表数据
		sSql = "update user_info set attribute8=:Attribute8,StorePosID=:StorePosID where userid=:UserID";

		Sqlca.executeSQL(new SqlObject(sSql).setParameter("Attribute8", sSno).setParameter("StorePosID", sMoblieposno).setParameter("UserID", CurUser.getUserID()));
		
		
		//更新session中的用户登陆信息
		CurUser.setAttribute8(sSno);
		CurARC.setUser(CurUser);
		session.setAttribute("CurARC",CurARC);
		out.println("success");
	}catch(Exception ex){
		ex.printStackTrace();
		out.println("error");
	}
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>