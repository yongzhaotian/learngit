<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBegin.jsp"%>
<%
	String PG_TITLE = "������ϸ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//��ȡ����
	String feeSerialNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FeeSerialNo")));//������ˮ��
	AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
	BusinessObject fee = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.fee,feeSerialNo);
	String feeFrequency = fee.getString("FeeFrequency");
	String objectType = fee.getString("ObjectType");
	String objectNo = fee.getString("ObjectNo");

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "AcctFeeInfo";
	String sTempletFilter = "(ColAttribute like '%"+objectType+"%' or ColAttribute is null)"; 
	ASDataObject doTemp = new ASDataObject(sTempletNo, sTempletFilter, Sqlca);
	//�ո�Ƶ��һ�εģ�����ʾ�������ʼ���ںͽ�������
	if("3".equals(feeFrequency)){
		doTemp.setVisible("SEGBEGINSTAGE,SEGENDSTAGE", false);
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);
	//��λ
	dwTemp.setHarborTemplate(DWExtendedFunctions.getDWDockHTMLTemplate(sTempletNo,"1=1", Sqlca));
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(feeSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	

	//����Ϊ��
	//0.�Ƿ���ʾ
	//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
	//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
	//3.��ť����
	//4.˵������
	//5.�¼�
	//6.��ԴͼƬ·��
	String sButtons[][] = {
	{"true", "", "Button", "����","�����¼","saveRecord()",sResourcesPath},
	};
%>

<%@ include file="/Resources/CodeParts/List05.jsp"%>
<script language=javascript>
	function saveRecord(){
		bSavePrompt=true;
		var amount = getItemValue(0,0,"Amount");
		var waiveAmount = getItemValue(0,0,"WaiveAmount");
		var waivePercent = getItemValue(0,0,"WaivePercent");
		if(amount == "")
		{
			amount = 0;
		}
		if(waiveAmount == "")
		{
			waiveAmount = 0;
		}
		if(waivePercent == "")
		{
			waivePercent = 0;
		}
		if(waivePercent>0 && waiveAmount >0){
			alert("��������ͼ������ͬʱ��ֵ��");
			return;
		}
		calFeeAmount_T();
		as_save("myiframe0","afterLoad()"); 
	}
	
	function calFeeAmount_T(){
		var feeAmount = RunMethod("LoanAccount","CalFeeAmount","<%=feeSerialNo%>");
		if(typeof(feeAmount) == "undefined" || feeAmount == ""){
			feeAmount = "0.0";
		}
		setItemValue(0,0,"Amount",feeAmount);
		
		feeAmount = getItemValue(0,0,"Amount");
		var waivePercent = getItemValue(0,0,"WaivePercent");
		var waiveAmount = getItemValue(0,0,"WaiveAmount");
		if(typeof(waivePercent) == "undefined" || waivePercent == ""){
			waivePercent = "0.0";
		}
		if(typeof(waiveAmount) == "undefined" || waiveAmount == ""){
			waiveAmount = "0.0";
		}
		
		if(waiveAmount>0){
			setItemValue(0,0,"FeeActualAmount",amarMoney(parseFloat(feeAmount)-parseFloat(waiveAmount),2));
			//setItemValue(0,0,"WaivePercent",parseFloat(waiveAmount/feeAmount));
		}
		else {
			setItemValue(0,0,"FeeActualAmount",amarMoney(parseFloat(feeAmount)-parseFloat(waivePercent*feeAmount/100),2));
			//setItemValue(0,0,"WaiveAmount",parseFloat(waivePercent*feeAmount/100));
		} 
	}
	
	function calFeeAmount(){
		bSavePrompt=false;
		var waivePercent = getItemValue(0,0,"WaivePercent");
		var waiveAmount = getItemValue(0,0,"WaiveAmount");
		if(typeof(waivePercent) == "undefined" || waivePercent == ""){
			waivePercent = "0.0";
		}
		if(typeof(waiveAmount) == "undefined" || waiveAmount == ""){
			waiveAmount = "0.0";
		}
		if(waivePercent>0 && waiveAmount >0){
			alert("��������ͼ������ͬʱ��ֵ��");
			return;
		}
		as_save("myiframe0","calFeeAmount_T()");
	}
	
	/*~[Describe=֧����Ϣ;InputParam=��;OutPutParam=��;]~*/
	function viewAccountInfo(){
		var obj = frames['myiframe0'].document.getElementById('ContentFrame_FeeAccountsPart');
		if(typeof(obj) == "undefined" || obj == null) return;
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		AsControl.OpenView("/Accounting/LoanDetail/LoanTerm/DepositAccountsList.jsp","Status=0@1&ObjectNo="+sObjectNo+"&ObjectType=<%=fee.getObjectType()%>","FeeAccountsPart","");
	}
	
	/*~[Describe=���ü�����Ϣ;InputParam=��;OutPutParam=��;]~*/
	function viewFEEWaiveInfo(){
		var obj = frames['myiframe0'].document.getElementById('ContentFrame_FeeWaivePart');
		if(typeof(obj) == "undefined" || obj == null) return;
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		AsControl.OpenView("/Accounting/LoanDetail/LoanTerm/AcctFeeWaiveList.jsp","Status=0@1&ObjectNo="+sObjectNo+"&ObjectType=<%=fee.getObjectType()%>","FeeWaivePart","");
	}
	
	/*~[Describe=�����¼�;InputParam=��;OutPutParam=��;]~*/
	function afterLoad(){
		viewAccountInfo();
		viewFEEWaiveInfo();
	}
	//��ʼ��
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
	setItemValue(0,getRow(),"CashonlineFlag","1");
	afterLoad();
</script>
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>