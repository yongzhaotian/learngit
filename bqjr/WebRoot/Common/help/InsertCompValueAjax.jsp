<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content: ��ҳ��
		Input Param:
			          
		Output param:
			      
		History Log: 
	 */
	%>
<%/*~END~*/%>
<%
	String sYear = StringFunction.getToday().substring(0,4) ;
	//��ò���
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

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(isOk+"");
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>
                                      
							