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
	String sSql ="";
	String sReturnValue="";
	SqlObject so = null;
	String sNewSql = "";
	int sValue=0;
	//获得参数	
	String sCommentText = DataConvert.toRealString(iPostChange,(String)request.getParameter("CommentText")); 
	String sCommentItemName = DataConvert.toRealString(iPostChange,(String)request.getParameter("CommentItemName")); 
	String sTableName = DataConvert.toRealString(iPostChange,(String)request.getParameter("TableName"));
	//String sCommentItemID = DBKeyHelp.getSerialNo("REG_COMMENT_ITEM","CommentItemID",Sqlca);
	String sCommentItemID = "";
	String sMaxSerialNo = Sqlca.getString("select Max(CommentItemID) from REG_COMMENT_ITEM where CommentItemID like 'PIC%'");
	if(sMaxSerialNo==null) sCommentItemID = "PIC000001";
	else{
		int iMax = Integer.parseInt(sMaxSerialNo.substring(3));
		int iNewMax = iMax + 1;
		String sNewMax = String.valueOf(iNewMax);
		int iLength = 6 - sNewMax.length();
		String sPreZero = "";
		for(int i=0;i<iLength;i++) sPreZero += "0";
		sCommentItemID = "PIC"+sPreZero + sNewMax;

	}


	sNewSql = "insert into Reg_Comment_Item(CommentItemID,CommentItemName,SortNo,CommentItemType,CommentText,DogenHelp,InputUser,inputOrg,InputTime,UpdateUser,UpdateTime,Remark) values (:CommentItemID,:CommentItemName,:SortNo,:CommentItemType,:CommentText,:DogenHelp,:InputUser,:inputOrg,:InputTime,:UpdateUser,:UpdateTime,:Remark)" ;
	so = new SqlObject(sNewSql);
	so.setParameter("CommentItemID", sCommentItemID);
	so.setParameter("CommentItemName", sCommentItemName);
	so.setParameter("SortNo", sCommentItemID);
	so.setParameter("CommentItemType", "060");
	so.setParameter("CommentText", "screens/"+sCommentText);
	so.setParameter("DogenHelp", "false");
	so.setParameter("InputUser", CurUser.getUserName());
	so.setParameter("inputOrg", CurOrg.getOrgName());
	so.setParameter("InputTime", StringFunction.getToday());
	so.setParameter("UpdateUser", CurUser.getUserName());
	so.setParameter("UpdateTime", StringFunction.getToday());
	so.setParameter("Remark","width=640 height=480");
	sValue = Sqlca.executeSQL(so) ;

%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sCommentItemID);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>
                                                                                                                    