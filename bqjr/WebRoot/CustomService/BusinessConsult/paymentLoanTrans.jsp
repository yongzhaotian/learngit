<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ��ǰ������ϸ-- */
	String PG_TITLE = "��ǰ������ϸ";

	// ���ҳ�����
	String objectNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")));//������ˮ��
	String objectType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")));//TransApply
	String sScheduleDate = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ScheduleDate")));//�ƻ���ǰ������
	String sPayDate = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PayDate")));//��ǰ�����������
	String sFlag = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag")));
	String sYesNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("YesNo")));//�Ƿ���ȡ��ǰ����������
	String PrePrepayFeeAmt = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PrePrepayFeeAmt")));//��ǰ����������
	String ContractSerialNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ContractSerialNo")));//��ͬ��ˮ
	
	String sCustomername = Sqlca.getString("select customername from business_contract where serialno='"+ContractSerialNo+"'");
	String loanSerialNo = Sqlca.getString("select serialno from acct_loan where putoutno='"+ContractSerialNo+"'");
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "Transaction_0055";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(objectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"false","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
    //�˷������ڱ����ҳ�����ݸ��µ�������ȴ������ʾ���˷�����Ҫ������ɾ��  add  by phe
	function checkModified(){
	 return true;
	}
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			bIsInsert = true;
		}
		// ���ú�ͬ�źͿͻ�����
		
		setItemValue(0,getRow(),"LoanSerialNo","<%=loanSerialNo%>");
		var sScheduleDate="<%=sScheduleDate%>";
		var sTransDate = "<%=sPayDate%>";
		var sLoanSerialNo = "<%=loanSerialNo%>";
		var sContractSerialNo = "<%=ContractSerialNo%>";
		setItemValue(0, 0, "putoutno", sContractSerialNo);
		setItemValue(0, 0, "CustomerName", "<%=sCustomername%>");
		var sParaString=sTransDate+","+sLoanSerialNo+","+sScheduleDate;
		var sReturn = "";
		sReturn=RunMethod("BusinessManage","SelectPrepaymentAmount",sParaString);
		var str=sReturn.split(",");
		
		setItemValue(0,getRow(),"PayPrincipalAmt",str[0]);
		setItemValue(0,getRow(),"PayInteAmt",str[1]);
		setItemValue(0,getRow(),"PrePayPrincipalAmt",str[0]);
		setItemValue(0,getRow(),"PrePayInteAmt",str[1]);
		setItemValue(0,getRow(),"PayInsuranceFee",str[2]);
		/* setItemValue(0,getRow(),"PrepaymentFee",str[3]); */
		var sFee = str[3];//����ƻ�����ǰ����������
		setItemValue(0,getRow(),"CustomerServeFee",str[4]);
		setItemValue(0,getRow(),"AccountManageFee",str[5]);
		setItemValue(0,getRow(),"StampTax",str[6]);
		setItemValue(0,getRow(),"PayAmt",str[7]);
		
		var sFlag=str[8];
		setItemValue(0,getRow(),"TransDate","<%=sPayDate%>");
		var PayAmt = getItemValue(0,getRow(),"PayAmt");
		var PrePrepayFeeAmt="<%=PrePrepayFeeAmt%>";

		setItemValue(0,getRow(),"PrepaymentFee",parseFloat(PrePrepayFeeAmt));
		if(parseFloat(sFee)==0.0){
			setItemValue(0,getRow(),"PayAmt",parseFloat(PrePrepayFeeAmt)+parseFloat(PayAmt));
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
<%@ include file="/IncludeEnd.jsp"%>
