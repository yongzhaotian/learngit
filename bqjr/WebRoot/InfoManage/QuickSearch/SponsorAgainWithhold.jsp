<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: �����ٴδ���
		Input Param:
			ObjectType:
			ObjectNo:
			SerialNo��ҵ����ˮ��
		Output Param:
			SerialNo��ҵ����ˮ��
		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ٴδ�������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sBusinessDate=SystemConfig.getBusinessDate();

	//���ҳ�����

	//����������
	String sPayAmount = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PayAmount")));
	String sLoanSerialNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanSerialNo")));
	String sCustomerID = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID")));
	String sCustomerName = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerName")));
	String sPutOutNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PutOutNo")));
	String sOutsourcingCollection=DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OutsourcingCollection")));
	
	if(sPayAmount == null) sPayAmount = "";
	if(sLoanSerialNo == null) sLoanSerialNo = "";
	if(sCustomerID == null) sCustomerID = "";
	if(sCustomerName == null) sCustomerName = "";
	if(sPutOutNo == null) sPutOutNo = "";
	if(sOutsourcingCollection == null) sOutsourcingCollection = "";

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	     	
		String sTempletNo = "SponsorAgainWithhold"; //ģ����
	    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

		//���ɲ�ѯ��
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		
		
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		dwTemp.setPageSize(16);  //��������ҳ

		//����HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
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
		{"true","","Button","����","����","saveRecord()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; 
	
	/*~[Describe= ����;InputParam=��;OutPutParam=SerialNo;]~*/
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		
		if(!vI_all("myiframe0")) return;
		
		var payTotalAmount = getItemValue(0,getRow(),"payaccountname2");
		var payAmount = getItemValue(0,getRow(),"payamount");
		
		if(parseFloat(payAmount)<=0){
			alert("���۽��������0");
			return;
		}
		
		if(parseFloat(payTotalAmount)<parseFloat(payAmount)){
			alert("���۽��ܴ��ڵ���Ӧ���ܽ��");
			setItemValue(0, 0, "payamount", "");
			return;
		}
		if(!confirm("����ɹ����޷�ȡ�����Ƿ�ȷ�����룿")){
			return;
		}
		
		as_save("myiframe0",sPostEvents);
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	
	

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		setItemValue(0, 0, "batchtranstype", "2");//PRM-728 ȡ���˱���������ʱ���������Ĺ��� '1','������','2','����ͨ��','3','��ȡ��','4','�ͻ�����'
		setItemValue(0, 0, "accountingorgid", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"digest","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"payaccountorgid1","<%=SystemConfig.getBusinessTime()%>");
		bIsInsert = false;
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			var sTableName = "LS_BATCH_LAS_CORE";//����
			var sColumnName = "SerialNo";//�ֶ���
			var sPrefix = "";//ǰ׺
		
			//��ȡ��ˮ��
			var sSerialNo = "<%=DBKeyUtils.getSerialNo("LS")%>"
			setItemValue(0, 0, "serialno", sSerialNo);
			setItemValue(0, 0, "inputdate", "<%=sBusinessDate%>");
			setItemValue(0, 0, "objectno", "<%=sLoanSerialNo%>");
			setItemValue(0, 0, "objecttype", "jbo.app.ACCT_LOAN");
			setItemValue(0, 0, "payaccountname3", "<%=sCustomerName%>");
			setItemValue(0, 0, "payaccountno3", "<%=sCustomerID%>");
			setItemValue(0, 0, "batchtranstype", "2");//PRM-728 ȡ���˱���������ʱ���������Ĺ��� '1','������','2','����ͨ��','3','��ȡ��','4','�ͻ�����'
			setItemValue(0, 0, "payaccountname2", "<%=sPayAmount%>");
			setItemValue(0, 0, "accountingorgid", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "digest", "<%=CurUser.getUserID()%>");
			setItemValue(0, 0, "payaccountorgid1", "<%=SystemConfig.getBusinessTime()%>");
			setItemValue(0, 0, "recieveaccountno", "<%=sPutOutNo %>");
			setItemValue(0, 0, "outsourcingcollection", "<%=sOutsourcingCollection %>");

			bIsInsert = true;
		}
	} 
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});

</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
