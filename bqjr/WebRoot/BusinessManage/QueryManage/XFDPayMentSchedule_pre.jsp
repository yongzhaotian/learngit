<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Describe: Ԥ����ƻ���ѯҳ��
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ԥ����ƻ���ѯҳ��"; // ��������ڱ��� <title> PG_TITLE </title>
	//����������
    String loanSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("loanSerialNo"));
    String preBalance = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("preBalance"));
    if(preBalance == null ) preBalance = "";
    if(loanSerialNo == null ) loanSerialNo = "";
	Double preBalances = Double.valueOf(preBalance); 
	String BusinessDate=SystemConfig.getBusinessDate();
	
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
		String sHeaders[][] = { 
								{"SeqID","�ڴ�"},
								{"PayDate","Ӧ������"},
								{"TotalAmt","Ӧ���ڿ��ܽ��(Ԫ)"},
								{"ActualTotalAmt","ʵ���ڿ��ܽ��(Ԫ)"},
								{"PayprincipalAmt","������(Ԫ)"},
								{"ActualPayPrincipalAmt","������(Ԫ)"},
								{"InteAmt","��Ϣ���(Ԫ)"},
								{"ActualPayInteAmt","��Ϣ���(Ԫ)"},
								{"CustomerServeFee","�ͻ������(Ԫ)"},
								{"ActualCustomerServeFee","�ͻ������(Ԫ)"},
								{"AccountManageFee","��������(Ԫ)"},
								{"ActualAccountManageFee","��������(Ԫ)"},
								{"StampTax","ӡ��˰(Ԫ)"},
								{"ActualStampTax","ӡ��˰(Ԫ)"},
								{"PayInsuranceFee","���շ�(Ԫ)"},
								{"ActualPayInsuranceFee","���շ�(Ԫ)"},
								{"OverDueAmt","���ɽ�(Ԫ)"},
								{"ActualOverDueAmt","���ɽ�(Ԫ)"},
								{"AdvanceFee","��ǰ����������(Ԫ)"},
								{"ActualAdvanceFee","��ǰ����������(Ԫ)"}
							}; 

		 String sSql ="SELECT aps.seqid as SeqID,aps.paydate as PayDate, "+
				   "sum(nvl(aps.payprincipalamt,0)+nvl(aps.payinteamt,0)) as TotalAmt, "+//--Ӧ���ܽ��
	               "sum(nvl(aps.actualpayprincipalamt,0)+nvl(aps.actualpayinteamt,0)) as ActualTotalAmt, "+//--ʵ���ܽ��
			       "sum(case when aps.paytype='1' or aps.paytype='5' then nvl(aps.payprincipalamt,0) else 0 end) as PayprincipalAmt, "+//--Ӧ������
			       "sum(case when aps.paytype='1' or aps.paytype='5' then nvl(aps.actualpayprincipalamt,0) else 0 end) as ActualPayPrincipalAmt, "+//--ʵ������
			       "sum(case when aps.paytype='1' or aps.paytype='5' then nvl(aps.payinteamt,0) else 0 end) as InteAmt, "+//--Ӧ����Ϣ
			       "sum(case when aps.paytype='1' or aps.paytype='5' then nvl(aps.actualpayinteamt,0) else 0 end) as ActualPayInteAmt, "+//--ʵ����Ϣ
			       "sum(case when aps.paytype='A2' then nvl(aps.payprincipalamt,0) else 0 end) as CustomerServeFee, "+//--Ӧ���ͻ������
			       "sum(case when aps.paytype='A2' then nvl(aps.actualpayprincipalamt,0) else 0 end) as ActualCustomerServeFee, "+//--ʵ���ͻ������
			       "sum(case when aps.paytype='A7' then nvl(aps.payprincipalamt,0) else 0 end) as AccountManageFee, "+//--Ӧ����������
			       "sum(case when aps.paytype='A7' then nvl(aps.actualpayprincipalamt,0) else 0 end) as ActualAccountManageFee, "+//--ʵ����������
			       "sum(case when aps.paytype='A11' then nvl(aps.payprincipalamt,0) else 0 end) as StampTax, "+//--ӡ��˰
			       "sum(case when aps.paytype='A11' then nvl(aps.actualpayprincipalamt,0) else 0 end) as ActualStampTax, "+//--ʵ��ӡ��˰
			       "sum(case when aps.paytype='A12' then nvl(aps.payprincipalamt,0) else 0 end) as PayInsuranceFee, "+//--���շ�
			       "sum(case when aps.paytype='A12' then nvl(aps.actualpayprincipalamt,0) else 0 end) as ActualPayInsuranceFee, "+//--ʵ�����շ�
			       "sum(case when aps.paytype='A10' then nvl(aps.payprincipalamt,0) else 0 end) as OverDueAmt, "+//--���ɽ�
			       "sum(case when aps.paytype='A10' then nvl(aps.actualpayprincipalamt,0) else 0 end) as ActualOverDueAmt, "+//--ʵ�����ɽ�
			       "sum(case when aps.paytype='A9' then nvl(aps.payprincipalamt,0) else 0 end) as AdvanceFee, "+//--Ӧ����ǰ����������
			       "sum(case when aps.paytype='A9' then nvl(aps.actualpayprincipalamt,0) else 0 end) as ActualAdvanceFee "+//--ʵ����ǰ����������			     
				   "FROM acct_payment_schedule aps where (aps.objectno='"+loanSerialNo+"' and aps.objecttype='jbo.app.ACCT_LOAN') or (aps.relativeobjectno='"+loanSerialNo+"' and aps.relativeobjecttype='jbo.app.ACCT_LOAN') "+// �����Ľ��
				   "group by SeqID,PayDate order by SeqID,PayDate ";

	 //����DataObject				
	 ASDataObject doTemp = new ASDataObject(sSql);
	 doTemp.setCheckFormat("PayDate","3");
	 doTemp.setVisible("ActualPayPrincipalAmt,ActualPayInteAmt,ActualCustomerServeFee,ActualAccountManageFee,ActualStampTax,ActualPayInsuranceFee,ActualOverDueAmt,ActualAdvanceFee", false);
	
	 doTemp.setHeader(sHeaders);
	 doTemp.setAlign("TotalAmt,ActualTotalAmt,PayprincipalAmt,ActualPayPrincipalAmt,InteAmt,ActualPayInteAmt,AccountManageFee,CustomerServeFee,ActualAccountManageFee","3");
	 doTemp.setAlign("ActualCustomerServeFee,StampTax,ActualStampTax,PayInsuranceFee,ActualPayInsuranceFee,OverDueAmt,ActualOverDueAmt,AdvanceFee,ActualAdvanceFee","3");
	 doTemp.setAlign("SeqID,PayDate","2");
	 doTemp.setCheckFormat("TotalAmt,ActualTotalAmt,PayprincipalAmt,ActualPayPrincipalAmt,InteAmt,ActualPayInteAmt,CustomerServeFee,ActualCustomerServeFee,AccountManageFee,ActualAccountManageFee","2");
	 doTemp.setCheckFormat("StampTax,ActualStampTax,PayInsuranceFee,ActualPayInsuranceFee,OverDueAmt,ActualOverDueAmt,AdvanceFee,ActualAdvanceFee","2");
	
	 doTemp.setColumnType("TotalAmt,ActualTotalAmt,PayprincipalAmt,ActualPayPrincipalAmt,InteAmt,ActualPayInteAmt,AccountManageFee,CustomerServeFee,ActualCustomerServeFee,StampTax,ActualStampTax,PayInsuranceFee,ActualPayInsuranceFee,OverDueAmt,ActualOverDueAmt,AdvanceFee","2");
	 doTemp.setHTMLStyle("PayDate","style={width:80px}");
	 doTemp.setHTMLStyle("SeqID","style={width:30px}");
	 
	 ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	 //dwTemp.setPageSize(24);//���÷�ҳ
	 dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	 dwTemp.ReadOnly = "1"; //����Ϊ��д
	 dwTemp.ShowSummary = "1";//���û���
	//����datawindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
		String sButtons[][] = {
		//{!loanSerialNo.equals("")?"true":"false","","Button","��ͬ���ü�����Ϣ","���ü����¼","FeeWaiveView()",sResourcesPath},
		//{loanSerialNo.equals("")?"true":"false","","Button","��ͬ����ƻ�����","����ƻ�����","RepaymentList()",sResourcesPath},
		{"true","","Button","����Excel","����Excel","exportAll()",sResourcesPath},
		{"true","","Button","test","test","test()",sResourcesPath}
		//{"true","","Button","Ԥ�����"+preBalance+"","Ԥ�����","",sResourcesPath}
		//{(!preBalance.equals("")?"true":"false"),"","Button","Ԥ�������","�������","plan",sResourcesPath},
		//{(!preBalance.equals("")?"true":"false"),"","PlainText","Ԥ�����"+preBalance+"Ԫ","Ԥ�����","",sResourcesPath}
	
	};
	
	
	%> 
<%/*~END~*/%>
	
<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	 /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}
	function test()
	{
		
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">

	</script>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init_show();
	my_load_show(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
