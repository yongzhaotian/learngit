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
	String PG_TITLE = "��ǰ���������б�ҳ��"; // ��������ڱ��� <title> PG_TITLE </title>
	String BusinessDate=SystemConfig.getBusinessDate();
	String sDoWhere  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("doWhere"));	
	if(sDoWhere==null) sDoWhere="";	
	
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
			{"statusName","����״̬"},
			{"payamt","Ӧ���ܽ��"},
			{"prepayprincipalAmt","��ǰ�������"},
			{"prepayinteAmt","��ǰ������Ϣ���"},
			{"financeAmt","Ӧ����������"},
			{"customerAmt","Ӧ���ͻ������"},
			{"insuranceAmt","Ӧ�����շ�"},
			{"stampDutyAmt","Ӧ��ӡ��˰"},
			{"prepayFactorageAmt","��ǰ����������"},
			{"bugpayamt","���Ļ������"},
			{"applayOrgName","�������"},
			{"applicantByName","������"},
			{"applicantDate","����ʱ��"},
			{"approverByName","������"},
			{"approverDate","����ʱ��"},
			{"approverOrgName","��������"},
			{"prepayFactorageFlag","�Ƿ���ȡ��ǰ����������"}
		};
		String sql =" select pa.serialno as serialNo,pa.contract_serialno as contractSerialno,pa.customer_id as customerId,al.customerName as customerName ,pa.executable_date as executableDate,"
					+" nvl(t.transstatus,pa.status) as status ,"
					+" (case when nvl(t.transstatus,pa.status)='0' then '������' when nvl(t.transstatus,pa.status)='3' then '����ͨ��' when nvl(t.transstatus,pa.status)='1' then '��ִ��' when nvl(t.transstatus,pa.status)='4' then '��ȡ��'  end) as statusName,pa.payamt as payamt, "
					+" pa.prepayprincipal_amt as prepayprincipalAmt,pa.prepayinte_amt as prepayinteAmt,pa.finance_amt as financeAmt,pa.customer_amt as customerAmt,pa.insurance_amt as insuranceAmt,pa.stamp_duty_amt as stampDutyAmt,"
					+" pa.prepay_factorage_amt as prepayFactorageAmt,pa.bugpayamt as bugpayamt, "
					+" getOrgName(pa.applay_orgid) as applayOrgName,getUserName(pa.applicant_by) as applicantByName,pa.applicant_date as applicantDate,getUserName(pa.approver_by) as approverByName,pa.approver_date as approverDate,"
					+" getOrgName(pa.approver_orgid) as approverOrgName, (case when pa.prepay_factorage_flag='0' then '��' when pa.prepay_factorage_flag='1' then '��' end) as prepayFactorageFlag "
					+" from prepayment_applay pa left join acct_loan al on al.serialno=pa.laon_serialno"
					+" left join acct_transaction t on pa.at_serialno =t.serialno  where 1=1 ";
		 ASDataObject doTemp = new ASDataObject(sql);
		 doTemp.setHeader(sHeaders);
		 doTemp.setVisible("customerId,serialNo,status", false);
		 doTemp.setKey("serialNo", true);
		 doTemp.setColumnAttribute("contractSerialno,customerName,status,applicantDate","IsFilter","1");
		 doTemp.setDDDWCodeTable("status", "0,������,1,��ִ��,3,����ͨ��,4,��ȡ��");
	     doTemp.setFilter(Sqlca, "0020", "contractSerialno", "Operators=EqualsString,BeginsWith;");
		 doTemp.setFilter(Sqlca, "0031", "customerName", "Operators=EqualsString,BeginsWith;");
		 doTemp.setFilter(Sqlca, "0010", "status", "Operators=EqualsString;");
		 doTemp.setFilter(Sqlca, "0030", "applicantDate", "Operators=EqualsString,BeginsWith;");
		 
		 doTemp.parseFilterData(request,iPostChange);
		 int count = 0;
		 for(int k=0; k<doTemp.Filters.size(); k++){
			 if(doTemp.Filters.get(k).sFilterInputs[0][1] != null){
				 count ++;
			 }
		 }
		 for(int k=0; k<doTemp.Filters.size(); k++){
			 	if(count==1){
			 		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && "0031".equals(doTemp.Filters.get(k).sFilterID)){
			 			%>
						<script type="text/javascript">
							alert("�ͻ������������������ϲ�ѯ!");
						</script>
						<%
						doTemp.WhereClause+=" and 1=2";
						break;
			 		}
			 	}
				//��������������ܺ���%����
				if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && doTemp.Filters.get(k).sFilterInputs[0][1].contains("%")){
					%>
					<script type="text/javascript">
						alert("������������ܺ���\"%\"����!");
					</script>
					<%
					doTemp.WhereClause+=" and 1=2";
					break;
				}
				
		 }
		if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and pa.status='0' ";
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "1"; //����Ϊ��д
		dwTemp.setPageSize(15);
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
			{"true","","Button","ȷ����ǰ����","ȷ����ǰ����","PrePaymentApprover()",sResourcesPath},
			{"true","","Button","ȡ����ǰ����","ȡ����ǰ����","cancelPrepayMent()",sResourcesPath},
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
	function PrePaymentApprover(){
		var sSerialNo = getItemValue(0,getRow(),"serialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		if(confirm("ȷ������ͨ����ǰ���")){
	    	var params = "orgid=<%=CurUser.getOrgID()%>,userId =<%=CurUser.getUserID()%>,serialNo="+sSerialNo;
	    	var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PaymentApply", "PrepayMentApprover", params);
	    	if(result!=null){
	    		alert(result.split("@")[1]);
	    		if(result.split("@")[0]=="success"){
	    			reloadSelf();
	    		}
	    	}	
		}
		
	}
	
	function cancelPrepayMent(){
		var sSerialNo = getItemValue(0,getRow(),"serialNo");
		var status =  getItemValue(0,getRow(),"status");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		if(status == "0" || status == "3"){
			if(confirm("ȷ��ȡ��ǰ���")){
		    	var params = "orgid=<%=CurUser.getOrgID()%>,userId =<%=CurUser.getUserID()%>,serialNo="+sSerialNo;
		    	var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PaymentApply", "cancelPrepayMent", params);
		    	if(result!=null){
		    		alert(result.split("@")[1]);
		    		if(result.split("@")[0]=="success"){
		    			reloadSelf();
		    		}else{
		    			reloadSelf();
		    		}
		    	}	
			}
		}else{
			alert("ֻ��״̬Ϊ�����еĲ���ȡ����");  
			return;
		}
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
