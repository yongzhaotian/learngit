<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: �˿��ѯ
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
	String PG_TITLE = "�˿�������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sBusinessDate=SystemConfig.getBusinessDate();

	//���ҳ�����

	//����������
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sCustomerName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerName"));
	String sDepositsamt = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Depositsamt"));
	
	if(sCustomerID == null) sCustomerID = "";
	if(sCustomerName == null) sCustomerName = "";
	if(sDepositsamt == null) sDepositsamt = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	     	
		String sTempletNo = "DepositsRefundApply"; //ģ����
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
		if(!setCheck()){
			return;
		}
		if(bIsInsert){
			beforeInsert();
		}
		as_save("myiframe0",sPostEvents);
		alert("����ɹ�!");
		self.close();
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe= �˿���У��;InputParam=��;OutPutParam=SerialNo;]~*/
	function setCheck(){
		
		var sDepositsamt= getItemValue(0, 0, "depositsamt");
		var sReturnAmt=getItemValue(0,0,"returnamt");
		if (typeof(sReturnAmt)=='undefined' || sReturnAmt.length==0) {
		setItemValue(0, 0, "returnamt", "0.0");
		}
		if(sReturnAmt<=0 || sReturnAmt>sDepositsamt){
			alert("�˿���ܴ���Ԥ�������ұ������0");
			setItemValue(0, 0, "returnamt", "0.0");
			return false;
		}
		return true;
	} 
	
	/*~[Describe=���������滮ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode() {
		
		var retVal = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
			alert("��ѡ����Ҫѡ��ĳ��У�");
			return;
		}
		
		setItemValue(0, 0, "accountbankcity", retVal.split("@")[0]);
		setItemValue(0, 0, "accountbankcityname", retVal.split("@")[1]);

	}
	
	//�̻��˺ſ���֧��
	function selectBankCode(){
		var sOpenBank = getItemValue(0,0,"refundbankid");
		var sCity     = getItemValue(0,0,"accountbankcity");
		
		if(sCity=="" ||sOpenBank==""){
			alert("��ѡ�񿪻����л�ʡ�У�");
			return;
		}
		
		sCompID = "SelectWithholdList";
		sCompURL = "/CreditManage/CreditApply/SelectWithholdList.jsp";
		sParaString="OpenBank="+sOpenBank+"&City="+sCity;
		
		sReturn = popComp(sCompID,sCompURL,sParaString,"dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		sBankNo=sReturn[0];//
		sBranch=sReturn[1];//

		setItemValue(0,0,"refundbankorgid",sBankNo);
		setItemValue(0,0,"refundbankname",sBranch);
	}

	

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		
		setItemValue(0, 0, "inputorgid", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"inputuserid","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"inputtime","<%=sBusinessDate%>");
		bIsInsert = false;
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			var sSerialNo = getSerialNo("ACCT_FEE","SERIALNO","");
			setItemValue(0, 0, "serialno", sSerialNo);
			setItemValue(0, 0, "customerid", "<%=sCustomerID%>");
			setItemValue(0,0,"customername","<%=sCustomerName%>");
			setItemValue(0,0,"depositsamt","<%=sDepositsamt%>");
			setItemValue(0, 0, "inputorgid", "<%=CurOrg.orgID %>");
			setItemValue(0,0,"inputuserid","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"inputdate","<%=sBusinessDate%>");
	
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
