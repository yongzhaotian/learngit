<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: jytian 2004-12-06 
		Tester:
		Describe: 添加重点信息链接中
		Input Param:
			ObjectType：信息类型
			ObjectNo：信息代码
		Output Param:
		HistoryLog:   zywei 2005/09/10 重检代码
			
	 */
	%>
<%/*~END~*/%> 

<%	
	//定义变量 
	SqlObject so = null;
	String sNewSql = "";	
	//获取页面参数：信息类型和信息代码
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	
   sNewSql = " select ObjectType,UserID,ObjectNo "+
  			 " from USER_DEFINEINFO "+
   			 " where UserID =:UserID "+
  			 " and ObjectType=:ObjectType "+
  			 " and ObjectNo=:ObjectNo";
   so = new SqlObject(sNewSql);
   so.setParameter("UserID",CurUser.getUserID());
   so.setParameter("ObjectType",sObjectType);
   so.setParameter("ObjectNo",sObjectNo);
   ASResultSet rs = Sqlca.getResultSet(so);
   String sReturnValue="";
   if(rs.next())
   {	
	   sReturnValue="242";
   }
   else
   {
	    sNewSql = " insert into USER_DEFINEINFO(UserID,ObjectType,ObjectNo) values(:UserID,:ObjectType,:ObjectNo) ";
	    so = new SqlObject(sNewSql);
	    so.setParameter("UserID",CurUser.getUserID());
	    so.setParameter("ObjectType",sObjectType);
	    so.setParameter("ObjectNo",sObjectNo);
	    Sqlca.executeSQL(so);
	    sReturnValue="243";	
    }
    rs.getStatement().close();
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
<%@ include file="/IncludeEndAJAX.jsp"%>