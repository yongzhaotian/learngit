<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   jbye  2004-12-20 9:14
		Tester:
		Content: ȡ�ö�Ӧ�ı�������
		Input Param:
			                
		Output param:
		History Log: 
			DATE	CHANGER		CONTENT
			2005-8-10	fbkang	ҳ�����				
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ȡ�ñ��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����,������Чֵ;]~*/%>
<%
    //�������
	String sSql = "";//--���sql���
	String sObjectNo = "";//--������
	String sObjectType = "";//--��������
	String sTabelName = "";//--����
	String sReturnValue = "false";//--����ֵ
	
	//���ҳ������������� ��ʱΪ�ͻ���
	sObjectNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));

	//���ݿͻ����ҵ���Ӧ�Ŀͻ�����
	sSql = "select CustomerType from CUSTOMER_INFO where CustomerID =:sObjectNo ";
	sObjectType = Sqlca.getString(new SqlObject(sSql).setParameter("sObjectNo",sObjectNo));
		
	//���ݲ�ͬ�Ŀͻ����͵���ͬ�ı���ȡ�ö�Ӧ�ı�������
	if(sObjectType!=null && ("01,02").indexOf(sObjectType.substring(0,2))>=0)// ��˾�ͻ������ſͻ�
		sTabelName = "ENT_INFO ";
	else if(sObjectType!=null && ("03,04,05").indexOf(sObjectType.substring(0,2))>=0)//���˿ͻ������幤�̻���ũ��
		sTabelName = "IND_INFO ";

	//��ȡ���񱨱�����
	sSql = "select FinanceBelong as FSModelClass from "+sTabelName+" where CustomerID =:CustomerID and length(FinanceBelong)>1";
	String sFinanceBelong = Sqlca.getString(new SqlObject(sSql).setParameter("CustomerID",sObjectNo));	
	if(sFinanceBelong == null) sFinanceBelong = "";
	if(!sFinanceBelong.equals("")) sReturnValue = sFinanceBelong;	
	
		
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