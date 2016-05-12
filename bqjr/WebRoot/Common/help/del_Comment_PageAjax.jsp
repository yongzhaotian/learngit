<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: thong 2005.03.17
 * Tester:
 *
 * Content: 删除reg_comment_item & reg_comment_rela
 * Input Param:
 *			
 *			列名:	ColumnName
 *			
 * Output param:
 *		  
 *
 * History Log:
 *
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%	
	//页面参数之间的传递一定要用DataConvert.toRealString(iPostChange,只要一个参数)它会自动适应window.open或者window_open
	//获取表名、列名和格式
	boolean isOk = false ;
	String sReturnValue="";
	ASResultSet rsTemp ;
	String sCommentItemID = DataConvert.toRealString(iPostChange,(String)request.getParameter("CommentItemid"));
	String sSql = "delete from reg_comment_rela where CommentItemID = :CommentItemID" ;
	String sSql2 = "delete from reg_comment_item where CommentItemID = :CommentItemID";

	int i = 0;
	int i1 = 0;
	try{
		i = Sqlca.executeSQL(new SqlObject(sSql).setParameter("CommentItemID",sCommentItemID)) ;
		i1 = Sqlca.executeSQL(new SqlObject(sSql2).setParameter("CommentItemID",sCommentItemID)) ;
		if(i1 == 1){
			isOk = true ;
		}
	}catch(Exception ex){ex.printStackTrace();}

%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(isOk+"");
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>
