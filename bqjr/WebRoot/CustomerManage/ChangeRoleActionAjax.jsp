<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   ndeng  2005.04.18
		Tester:
		Content: ת�ƿͻ�����Ȩ
		Input Param:
			  CustomerID���ͻ�����
		Output param:
		History Log: 
			
	 */
	%>
<%/*~END~*/%>
<%

	//�������
	String sReturnValue="";
	SqlObject so = null;
	String sNewSql = "";	
	//����������
	
	//���ҳ�����
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
	String sBelongUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BelongUserID"));
%>

<%		
	try{
      //��ԭ���û��Ե�ǰ�ͻ�������Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩȫ����Ϊ���ޡ�
      sNewSql = "Update CUSTOMER_BELONG set BelongAttribute='2',BelongAttribute1='2',BelongAttribute2='2',BelongAttribute3='2',BelongAttribute4='2',ApplyStatus=null,ApplyRight=null where CustomerID=:CustomerID and UserID=:UserID";
	  so = new SqlObject(sNewSql);
	  so.setParameter("CustomerID",sCustomerID);
	  so.setParameter("UserID",sBelongUserID);
	  Sqlca.executeSQL(so);
      //����ǰ�û��Ե�ǰ�ͻ�������Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩȫ����Ϊ���С�
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
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>
