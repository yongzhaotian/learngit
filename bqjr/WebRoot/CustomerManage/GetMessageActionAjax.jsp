<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  cchang  2004.12.2
		Tester:
		Content: --Ȩ�����뵯��ҳ��
		Input Param:
			  CustomerID  ��--�ͻ���
		Output param:
			               
		History Log: 
		   DATE	    CHANGER		CONTENT
		   2005.7.27 fbkang     �޸��µİ汾
		   2009.5.25 fwang      �޸��µİ汾
		
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ�Ȩ���������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//ҳ�����֮��Ĵ���һ��Ҫ��DataConvert.toRealString(iPostChange,ֻҪһ������)�����Զ���Ӧwindow.open����window.open
	//��ȡ�����������͸�ʽ
	//�������	
	String  sSql = "";//--���sql���	
	String  sSuperiorOrgID = "";//--����ϼ����ڻ�������
	String  sSuperiorOrgName = "";//--����ϼ����ڻ�������
	String  sMessage = "";//--�����Ϣ
	String  sFlag = "";//--���һ����ǩ
	ASResultSet rs = null;//--��Ž����
	//��ȡҳ�����
	String	sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	//��ȡ�������	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=��ȡ����ֵ;]~*/%>
<%
	//��ȡ��ǰ�������ϼ�����
	sSql = 	" select OI.RelativeOrgID as SuperiorOrgID,getOrgName(OI.RelativeOrgID) as SuperiorOrgName "+
		    " from ORG_INFO OI"+
			" where OI.OrgID = :OrgID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("OrgID",CurOrg.getOrgID()));
	if(rs.next())
	{
		sSuperiorOrgID = rs.getString("SuperiorOrgID");
		sSuperiorOrgName = rs.getString("SuperiorOrgName");	
	}
	rs.getStatement().close();
	
	/*sSql = " select ApplyType " +
		   " from CUSTOMER_BELONG " +
		   " where CustomerID = '"+sCustomerID+"'";*/
	sSql = " select ApplyType " +
	   	   " from CUSTOMER_BELONG " +
	   	   " where CustomerID = :CustomerID";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(rs.next())
	{
		sFlag = rs.getString("ApplyType");
	}
	rs.getStatement().close();
	
	SqlObject so = null;
	String sNewSql = "";	
		
	if(sFlag.equals("1")){
		sNewSql = "update CUSTOMER_BELONG set ApplyRight=:ApplyRight where CustomerID=:CustomerID and UserID=:UserID";
		so = new SqlObject(sNewSql);
		so.setParameter("ApplyRight",CurOrg.getOrgID());
		so.setParameter("CustomerID",sCustomerID);
		so.setParameter("UserID",CurUser.getUserID());
		Sqlca.executeSQL(so);
		//Sqlca.executeSQL("update CUSTOMER_BELONG set ApplyRight='"+CurOrg.getOrgID()+"' where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.getUserID()+"'");
		sMessage = "�ÿͻ�Ȩ��������Ϣ�Ѿ����͵���"+CurOrg.getOrgName()+"�����������ϻ����Ŀͻ�Ȩ�޹�����Ա�������硣 ";
		}	
	if(sFlag.equals("2")){
		sNewSql = "update CUSTOMER_BELONG set ApplyRight=:ApplyRight where CustomerID=:CustomerID and UserID=:UserID";
		so = new SqlObject(sNewSql);
		so.setParameter("ApplyRight",sSuperiorOrgID);
		so.setParameter("CustomerID",sCustomerID);
		so.setParameter("UserID",CurUser.getUserID());
		Sqlca.executeSQL(so);
		//Sqlca.executeSQL("update CUSTOMER_BELONG set ApplyRight='"+sSuperiorOrgID+"' where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.getUserID()+"'");
		sMessage = "�ÿͻ�Ȩ��������Ϣ�Ѿ����͵���"+sSuperiorOrgName+"�����������ϻ����Ŀͻ�Ȩ�޹�����Ա�������硣 ";
		}	
	if(sFlag.equals("3")){
		sNewSql = "update CUSTOMER_BELONG set ApplyRight=:ApplyRight where CustomerID=:CustomerID and UserID=:UserID";  //modified by yzheng 2013-06-01
		so = new SqlObject(sNewSql);
		so.setParameter("ApplyRight",sSuperiorOrgID);
		so.setParameter("CustomerID",sCustomerID);
		so.setParameter("UserID",CurUser.getUserID());
		Sqlca.executeSQL(so);
		//Sqlca.executeSQL("update CUSTOMER_BELONG set ApplyRight='9900' where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.getUserID()+"'");
		sMessage = "�ÿͻ�Ȩ��������Ϣ�Ѿ����͵���"+sSuperiorOrgName+"�����������ϻ����Ŀͻ�Ȩ�޹�����Ա�������硣 ";
	}	
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sMessage);
	sMessage = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sMessage);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>
