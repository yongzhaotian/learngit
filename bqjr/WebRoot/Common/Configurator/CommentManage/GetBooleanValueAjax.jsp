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
	String sTempStr = DataConvert.toRealString(iPostChange,(String)request.getParameter("sTempStr"));
	String sChangeValue = "" ;
	String tmpValue ="";
	String sReturnValue="";
	SqlObject so = null;
	String sNewSql = "";
	sNewSql = "select Count(*) from reg_comment_item where SortNo = :SortNo";
	so=new SqlObject(sNewSql);
	so.setParameter("SortNo",sTempStr);
	String sTempValue = Sqlca.getString(so);
	if(Integer.parseInt(sTempValue) == 0) {
		sChangeValue = "1" ;
	}else {
		tmpValue = sTempStr.substring(0,4) ;
		sNewSql = "select Max(SortNo) from reg_comment_item where Sortno Like :Value";
		so=new SqlObject(sNewSql);
		so.setParameter("Value",tmpValue);
		String sMaxValue = Sqlca.getString(so) ;
		String tmpValue010 = sMaxValue.substring(sMaxValue.length()-4,sMaxValue.length());
		String tmpValue020 = sMaxValue.substring(0,sMaxValue.length()-4);
		int sValue = Integer.parseInt(tmpValue010) ;
		int Value = sValue + 10 ;
		sChangeValue = tmpValue020+Value ;
	}
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sChangeValue);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>
                                                                                                                    