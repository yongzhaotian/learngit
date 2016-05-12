<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   --fbkang  2005.07.27
		Tester:
		Content:  --�õ��ͻ���
		Input Param:
	        CustomerID���ͻ�����
	        UserID���û�����
	        ApplyAttribute������ͻ�����Ȩ��־
	        ApplyAttribute1��������Ϣ�鿴Ȩ��־
	        ApplyAttribute2��������Ϣά����־
	        ApplyAttribute3����������ҵ�����Ȩ��־	
	        ApplyAttribute4��������Ȩ�ޱ�־		                
		Output param:
		History Log: 
			
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

	//�������   
    String sOrgName = "";//--//���ڻ�������
    String sUserName = "";//--�û�����
    String sBelongUserID = "";//--�����û�
    String sSql = "",sReturnValue=""; //--Sql���
    String sHave = "_FALSE_";      //�ÿͻ��Ƿ�������Ȩ
	//����������,�ͻ����롢�û����롢����ͻ�����Ȩ��־��������Ϣ�鿴Ȩ��־��������Ϣά����־����������ҵ�����Ȩ��־������Ȩ�ޱ�־
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserID"));
	String sApplyAttribute  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyAttribute"));
	String sApplyAttribute1 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyAttribute1"));
	String sApplyAttribute2 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyAttribute2"));
	String sApplyAttribute3 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyAttribute3"));
	String sApplyAttribute4 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyAttribute4"));
	//����ֵת��Ϊ���ַ���
	if(sCustomerID == null) sCustomerID = "";           
    if(sUserID == null) sUserID = "";
	if(sApplyAttribute == null) sApplyAttribute = "";           
    if(sApplyAttribute1 == null) sApplyAttribute1 = "";
    if(sApplyAttribute2 == null) sApplyAttribute2 = "";
    if(sApplyAttribute3 == null) sApplyAttribute3 = "";
    if(sApplyAttribute4 == null) sApplyAttribute4 = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=��ȡ����ֵ ;]~*/%>
<%     
    //�ͻ�����Ȩ
	if(sApplyAttribute.equals("1"))
	{
	    //�ж��Ƿ��������ͻ������Ѿ��иÿͻ�������Ȩ
        sSql = " select BelongAttribute,getOrgName(OrgID) as OrgName, "+
			   " getUserName(UserID) as UserName,UserID "+
               " from CUSTOMER_BELONG "+
               " where CustomerID=:CustomerID "+
               " and UserID <> :UserID "+
               " and BelongAttribute = '1'";
	    ASResultSet rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID).setParameter("UserID",sUserID));
	    if(rs.next()) 
	    {
	        sHave = "_TRUE_";  //��������Ȩ
	        sOrgName = rs.getString("OrgName");
	        sUserName = rs.getString("UserName");
	        sBelongUserID = rs.getString("UserID");
	    }
	    rs.getStatement().close();	    
	}
	
	//����ÿͻ�������Ȩ��û���û�ӵ�У���ֱ�Ӹ�������������пͻ�Ȩ�޵ĸ���
	if(sHave.equals("_FALSE_"))
	{  
    	sSql = " Update CUSTOMER_BELONG set BelongAttribute = :BelongAttribute, "+
				" BelongAttribute1 = :BelongAttribute1,BelongAttribute2 = :BelongAttribute2, "+
				" BelongAttribute3 = :BelongAttribute3,BelongAttribute4 = :BelongAttribute4 "+
				" where CustomerID = :CustomerID "+
				" and UserID = :UserID ";
    	SqlObject so = new SqlObject(sSql);
    	so.setParameter("BelongAttribute",sApplyAttribute);
    	so.setParameter("BelongAttribute1",sApplyAttribute1);
    	so.setParameter("BelongAttribute2",sApplyAttribute2);
    	so.setParameter("BelongAttribute3",sApplyAttribute3);
    	so.setParameter("BelongAttribute4",sApplyAttribute4);
    	so.setParameter("CustomerID",sCustomerID);
    	so.setParameter("UserID",sUserID);
    	Sqlca.executeSQL(so);
    } 
	sReturnValue=sHave+"@"+sOrgName+"@"+sUserName+"@"+sBelongUserID;
%>
<%/*~END~*/%>

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
