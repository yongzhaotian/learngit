<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: jytian 2004-12-06 
		Tester:
		Describe: ����ص���Ϣ������
		Input Param:
			ObjectType����Ϣ����
			ObjectNo����Ϣ����
		Output Param:
		HistoryLog:   zywei 2005/09/10 �ؼ����
			
	 */
	%>
<%/*~END~*/%> 

<%	
	//������� 
	SqlObject so = null;
	String sNewSql = "";	
	//��ȡҳ���������Ϣ���ͺ���Ϣ����
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	//����ֵת��Ϊ���ַ���
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
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%@ include file="/IncludeEndAJAX.jsp"%>