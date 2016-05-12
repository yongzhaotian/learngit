<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-3
		Tester:
		Describe:
			��������ϵ�������Ҫ�Ǽ�������ϵ�������ظ����⣬���²��������ϵ��ʱ�򱻵���
			���ڼ��ų�Ա��ϵ����Ҫ��Աֻ����һ���������Ա��ϵ����0401��

		Input Param:
			CustomerID: �ͻ����
			RelationShip: ������ϵ
			CertType: ֤������
			CertID:֤������
		Output Param:
			Message: ���ع����ͻ����RelativeID ���Ϊ�����ʾ��鲻ͨ��,����ʾ��Ϣ
		HistoryLog:
	*/
	%>
<%/*~END~*/%>

<%
	//��ȡҳ�����
	String sCustomerID   = DataConvert.toRealString(iPostChange,CurPage.getParameter("CustomerID"));
	String sRelationShip = DataConvert.toRealString(iPostChange,CurPage.getParameter("RelationShip"));
	String sCertType     = DataConvert.toRealString(iPostChange,CurPage.getParameter("CertType"));
	String sCertID       = DataConvert.toRealString(iPostChange,CurPage.getParameter("CertID"));
	
	//�������
	String sRelativeID = "";
	String sSql = "";
	String sMessage = "";
	ASResultSet rs = null;
	
	//����֤�����ͺ�֤����Ż�ȡ�ͻ����
	sSql = 	" select CustomerID from CUSTOMER_INFO "+
			" where CertType = '"+sCertType+"' "+
			" and CertID = '"+sCertID+"' ";
	rs = Sqlca.getResultSet(sSql);
	if (rs.next()) {
		sRelativeID = rs.getString(1);
		if(sRelativeID.equals(sCustomerID)){
			sMessage="false@�ͻ��������Լ���������Ա��ϵ,��ѡ�������ͻ��󱣴�!";
		}
		else{
			//���ݿͻ���š������ͻ���ź͹�����ϵ��ù����ͻ�����
			sSql = 	" select CustomerName from CUSTOMER_RELATIVE "+
					" where CustomerID = :CustomerID "+
					" and RelativeID = :RelativeID ";//+
					//" and RelationShip = :RelationShip ";	
			SqlObject so=new SqlObject(sSql);
			so.setParameter("CustomerID",sCustomerID);
			so.setParameter("RelativeID",sRelativeID);
			//so.setParameter("RelationShip",sRelationShip);
			ASResultSet rs1 = Sqlca.getResultSet(so);		
			if (rs1.next())
			{
				sMessage="false@�ͻ�["+rs1.getString("CustomerName")+"]�뱾�ͻ��Ĺ�ϵ�Ѿ�����,��ѡ�������ͻ��󱣴�!";
				if (sRelationShip.equals("0401"))
					sMessage="false@�ͻ�["+rs1.getString("CustomerName")+"]�Ѿ��Ǹü��ŵ������Ա,һ����������ֻ����һ�������Ա,���豣��!";
			}
			rs1.getStatement().close();
			
			if (!sMessage.equals("")) sRelativeID = "";
		}
	}
	else 
	{
		sRelativeID = DBKeyHelp.getSerialNo("CUSTOMER_INFO","CustomerID",Sqlca);
	}
	rs.getStatement().close();	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sRelativeID);
	sRelativeID = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	if (sMessage != "") {
		out.println(sMessage);
	}
	else{ 
		out.println("true@" + sRelativeID);
	}
%>
<%/*~END~*/%>

<%@	include file="/IncludeEndAJAX.jsp"%>