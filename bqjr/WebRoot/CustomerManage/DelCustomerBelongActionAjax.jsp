<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Action00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.2
		Tester:
		Content: ɾ���û�������ϵ
		Input Param:
			CustomerID���ͻ����					
		Output param:
			ReturnValue:����ֵ
				ExistApply:����δ�ս������
				ExistApprove:����δ�ս�������������
				ExistContract:����δ�ս�ĺ�ͬ
		History Log: 
				syang 2009/10/14 ��ɾ���û�������ϵ��
				��Ҫɾ���Ĳ�һ���ǵ�ǰ�û��Ĺ�ϵ��
				��ˣ�֧���ⲿ�����û�ID,���û�д����û�ID,��Ĭ��ʹ�õ�ǰ�û���Ϊ��Ϊԭ���ļ���
		
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Action01;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "",sReturnValue = "";		
	int iCount = 0;
	ASResultSet rs = null;
	
	//��ȡ�������
	
	//��ȡҳ��������ͻ����
	String sCustomerID   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));	
	String sUserID   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));	
	//����ֵת��Ϊ���ַ���
	if(sCustomerID == null) sCustomerID = "";
	if(sUserID == null || sUserID.length() == 0) sUserID = CurUser.getUserID();	//���û�д����û�����Ĭ��ʹ�õ�ǰ�û�
%>
<%/*~END~*/%>	


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Action02;Describe=����ҵ���߼�;]~*/%>
<%    
	//����δ�ս�����ҵ����
	sSql = " select count(SerialNo) from BUSINESS_APPLY "+
		   " where CustomerID = :CustomerID "+
		   " and PigeonholeDate is null "+
		   " and OperateUserID = :OperateUserID " ;
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID).setParameter("OperateUserID",sUserID));
	if(rs.next()) iCount = rs.getInt(1);
	rs.getStatement().close(); 		
	if (iCount == 0)	//����ҵ��ȫ���ս�
	{	
		//����δ�ս������������ҵ����
		sSql = " select count(*) from BUSINESS_APPROVE "+
		       " where CustomerID = :CustomerID "+
	           " and PigeonholeDate is null "+
	           " and OperateUserID = :OperateUserID " ;
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID).setParameter("OperateUserID",sUserID));
		if(rs.next()) iCount = rs.getInt(1);
		rs.getStatement().close();
		if(iCount == 0)	//�����������ҵ��ȫ���ս�
		{	
			//����δ�ս��ͬҵ����
			sSql = " select count(*) from BUSINESS_CONTRACT "+
			       " where CustomerID = :CustomerID "+
		           " and FinishDate is null "+
		           " and ManageUserID = :ManageUserID " ;
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID).setParameter("ManageUserID",sUserID));
			if(rs.next()) iCount = rs.getInt(1);
			rs.getStatement().close();
			if (iCount == 0)	//��ͬҵ��ȫ���ս�
			{	
				//����ɾ��������Ϣ
				String sNewSql = "Delete from  Customer_Belong where CustomerID=:CustomerID and UserID=:UserID";
				SqlObject so = new SqlObject(sNewSql);
				so.setParameter("CustomerID",sCustomerID);
				so.setParameter("UserID",sUserID);
				Sqlca.executeSQL(so);
				//Sqlca.executeSQL("Delete from  Customer_Belong where CustomerID='"+sCustomerID+"'"+" and UserID='"+sUserID+"'");					
				sReturnValue = "DelSuccess";//�ÿͻ�������Ϣ��ɾ����		
			}else
			{
				sReturnValue = "ExistContract";//�ÿͻ�������ͬҵ��δ�սᣬ����ɾ����
			}
		}else
		{
			sReturnValue = "ExistApprove";//�ÿͻ����������������δ�սᣬ����ɾ����
		}
	}else
	{
		sReturnValue = "ExistApply";//�ÿͻ���������ҵ��δ�սᣬ����ɾ����
	}	
	    	
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