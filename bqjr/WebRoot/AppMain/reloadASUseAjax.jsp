<%@page import="com.sun.java.swing.plaf.windows.resources.windows"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		���¼��ص�ǰ��½�û�����
	 */
	%>
<%/*~END~*/%> 

<%	
	String	sSno  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("sno"));//�ŵ����չ�����
	String	sMoblieposno  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PosNo"));//�ƶ�Pos����  add by clhuang 2015/05/28

	String sSql = "";
	String sSqlPos = "";
	ASResultSet rsPos = null;
	ASResultSet rs = null;
	SqlObject so = null;
	try{
		//���µ�ǰ�û�������
		sSql = "update user_info set attribute8=:Attribute8,StorePosID=:StorePosID where userid=:UserID";

		Sqlca.executeSQL(new SqlObject(sSql).setParameter("Attribute8", sSno).setParameter("StorePosID", sMoblieposno).setParameter("UserID", CurUser.getUserID()));
		
		
		//����session�е��û���½��Ϣ
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