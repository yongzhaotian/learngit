<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=ע����;]~*/%>
<%
/* 
  author:  zywei 2006-8-9 
  Tester:
  Content:  �ֹ�������Ա��Ϣ
  Input Param:
			CustomerID���ͻ����	
			RelativeID�������ͻ����
			RelativeType����������		
  Output param:
 
  History Log:     

               
 */
 %>
<%/*~END~*/%>

<%     
	
    //�������
    ASResultSet rs = null;
    int iCount1 = 0,iCount2 = 0;
    String sSql = "";
    String sReturnValue = "";
    //����������
    
    //���ҳ��������ͻ���š������ͻ���ź͹������͡�
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sRelativeID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeID"));
   	String sRelativeType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeType"));
   	//����ֵת��Ϊ���ַ���
   	if(sCustomerID == null) sCustomerID = "";
   	if(sRelativeID == null) sRelativeID = "";
   	if(sRelativeType == null) sRelativeType = "";
   	
   	//�������ͻ��Ƿ��Ѵ���ĳ������
	sSql = 	" select Count(CustomerID) "+ 
			" from CUSTOMER_RELATIVE " +
			" where RelativeID=:RelativeID "+
			" and RelationShip like '04%' "+
			" and length(RelationShip)>2 ";
	rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("RelativeID",sRelativeID));
	if(rs.next())
		iCount1 = rs.getInt(1);
	rs.getStatement().close();	
	if(iCount1 <= 0)
	{
		//�������ͻ��Ƿ��Ѵ��ڵ�ǰϵͳ�Զ����������
		sSql =  " select Count(CustomerID) from GROUP_SEARCH "+
				" where RelativeID = :RelativeID ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("RelativeID",sCustomerID));
		if (rs.next()) 
			iCount2 = rs.getInt(1);	
		rs.getStatement().close();
		
		if(iCount2 <= 0)
		{
			sReturnValue = "HaveRecord_Search"; //�ͻ��Ѿ�����ϵͳ�����Ľ��֮��
		}else
		{
			String sNewSql = " Insert into GROUP_SEARCH(CustomerID,RelativeID,SearchFlag, "+
				   " InputOrgid,InputUserid,InputDate,UpdateDate,UpdateOrgid, "+
				   " UpdateUserid,RelativeType) "+
				   " values(:CustomerID,:RelativeID,:SearchFlag,:InputOrgid,:InputUserid,:InputDate,:UpdateDate,:UpdateOrgid,:UpdateUserid,:RelativeType) ";
			SqlObject so = new SqlObject(sNewSql);
			so.setParameter("CustomerID", sCustomerID);
			so.setParameter("RelativeID", sRelativeID);
			so.setParameter("SearchFlag", "2");
			so.setParameter("InputOrgid", CurOrg.getOrgID());
			so.setParameter("InputUserid", CurUser.getUserID());
			so.setParameter("InputDate", StringFunction.getToday());
			so.setParameter("UpdateDate", StringFunction.getToday());
			so.setParameter("UpdateOrgid", CurOrg.getOrgID());
			so.setParameter("UpdateUserid", CurUser.getUserID());
			so.setParameter("RelativeType",sRelativeType);
			Sqlca.executeSQL(so);	
			sReturnValue = "Join"; //�ÿͻ��Ѿ�����Ϊ���ſͻ���
		}		
	}else
	{
		sReturnValue = "HaveRecord_Member";//�ͻ��Ѿ����ڣ������Ѿ���ĳһ�����ŵĳ�Ա	
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