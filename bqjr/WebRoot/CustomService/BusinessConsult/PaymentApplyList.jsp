<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Describe: ��ǰ���������б�ҳ��
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ǰ�����б�ҳ��"; // ��������ڱ��� <title> PG_TITLE </title>
	String sCertID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CertID"));//���֤��
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//��ͬ��
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));//�ͻ����
	String BusinessDate=SystemConfig.getBusinessDate();
	
	
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = { 
			{"serialNo","�������к�"},
			{"contractSerialno","��ͬ��"},
			{"customerId","�ͻ�id"},
			{"customerName","�ͻ�����"},
			{"executableDate","��ǰ�����ִ������"},
			{"status","����״̬"},
			{"payamt","Ӧ���ܽ��"},
			{"prepayprincipalAmt","��ǰ�������"},
			{"prepayinteAmt","��ǰ������Ϣ���"},
			{"financeAmt","Ӧ����������"},
			{"customerAmt","Ӧ���ͻ������"},
			{"insuranceAmt","Ӧ�����շ�"},
			{"stampDutyAmt","Ӧ��ӡ��˰"},
			{"prepayFactorageAmt","��ǰ����������"},
			{"bugpayamt","���Ļ������"},
			{"isbomtr","�Ƿ�ʹ���Ż���ǰ����"},
			{"applayOrgName","�������"},
			{"applicantByName","������"},
			{"applicantDate","����ʱ��"},
			{"approverByName","������"},
			{"approverDate","����ʱ��"},
			{"approverOrgName","��������"},
			{"prepayFactorageFlag","�Ƿ���ȡ��ǰ����������"}
		};
		String sql =" select pa.serialno as serialNo,pa.contract_serialno as contractSerialno,pa.customer_id as customerId,al.customerName as customerName ,pa.executable_date as executableDate, pa.is_bomtr as isbomtr, "
					+" (case when nvl(t.transstatus,pa.status)='0' then '������' when nvl(t.transstatus,pa.status)='3' then '����ͨ��' when nvl(t.transstatus,pa.status)='1' then '��ִ��' when nvl(t.transstatus,pa.status)='4' then '��ȡ��'  end) as status,pa.payamt as payamt, "
					+" pa.prepayprincipal_amt as prepayprincipalAmt,pa.prepayinte_amt as prepayinteAmt,pa.finance_amt as financeAmt,pa.customer_amt as customerAmt,pa.insurance_amt as insuranceAmt,pa.stamp_duty_amt as stampDutyAmt,"
					+" pa.prepay_factorage_amt as prepayFactorageAmt, pa.bugpayamt as bugpayamt, "
					+" getOrgName(pa.applay_orgid) as applayOrgName,getUserName(pa.applicant_by) as applicantByName,pa.applicant_date as applicantDate,getUserName(pa.approver_by) as approverByName,pa.approver_date as approverDate,"
					+" getOrgName(pa.approver_orgid) as approverOrgName, (case when pa.prepay_factorage_flag='0' then '��' when pa.prepay_factorage_flag='1' then '��' end) as prepayFactorageFlag "
				 	+" from prepayment_applay pa left join acct_loan al on al.serialno=pa.laon_serialno"
				 	+" left join acct_transaction t on pa.at_serialno =t.serialno  where 1=1 ";
		//����DataObject
// 		 String sTempletNo="BeginRepayList";
// 		 ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
		 ASDataObject doTemp = new ASDataObject(sql);
		 doTemp.setHeader(sHeaders);
		 doTemp.setVisible("customerId,serialNo", false);
		 doTemp.WhereClause += " and pa.contract_serialno = '"+sSerialNo+"'";		
		 
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "1"; //����Ϊ��д
		
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
			{"true","","Button","��ǰ��������","��ǰ��������","PrePaymentApply()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>
	
<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------------
	
	<%/*~[Describe=��ǰ��������;] ~*/%>
	function PrePaymentApply() {
		//��ȡ��ͬ�ţ����֤��
		sSerialNo =	"<%=sSerialNo%>";
		sCertID ="<%=sCertID%>";
		sCustomerID ="<%=sCustomerID%>";
		
		//CCS-953 ��ǰ����˻������ü����໥�ж��Ƿ��н��׽�����
		var returnValue = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PayMentRevisionSchedule","validate","contractSerialNo="+sSerialNo+"");
		if(returnValue!="0"){
			alert(returnValue);
			return;
		}//CCS-953 end
		//AsControl.OpenView("/CustomService/BusinessConsult/PaymentApplyDlog.jsp","SerialNo="+sSerialNo+"&CertID="+sCertID,"_blank","dialogWidth=200px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		AsControl.OpenView("/CustomService/BusinessConsult/PrepaymentApply.jsp","SerialNo="+sSerialNo+"&CertID="+sCertID,"_blank","dialogWidth=200px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
