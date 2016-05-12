<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content: 主页面
		Input Param:
			          
		Output param:
			      
		History Log: 
	 */
	%>
<%/*~END~*/%>
<%
	String sYear = StringFunction.getToday().substring(0,4) ;
	//获得参数
	boolean isOk = false ;
	String sReturnValue="";
	ASResultSet rs = null;
	int i = 0;
	String sCompID = DataConvert.toRealString(iPostChange,(String)request.getParameter("CompID")); 
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType")); 
	String sCommentItemID = DataConvert.toRealString(iPostChange,(String)request.getParameter("CommentItemID"));
	String sSql = "" ;
	sSql = "select Count(*) from REG_COMMENT_RELA where Commentitemid = '"+sCommentItemID+"' and ObjectType='"+sObjectType+"' and ObjectNo = '"+sCompID+"'" ;
	rs = SqlcaRepository.getResultSet(sSql);
	if(rs.next()) {
		i = rs.getInt(1) ;
	}
	if(i > 0) {
		isOk = false ;
	}else {
		sSql = "insert into REG_COMMENT_RELA(CommentitemId,ObjectType,ObjectNo) values ('"+sCommentItemID+"','"+sObjectType+"','"+sCompID+"')" ;
		i = SqlcaRepository.executeSQL(sSql) ;
		if(i == 1) {
			isOk = true;
		}else {
			isOk = false ;
		}
	}
	rs.getStatement().close();
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
                                      
							