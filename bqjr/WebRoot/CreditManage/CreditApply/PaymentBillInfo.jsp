<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: smiao 2011.06.01
		Tester:
		Describe: ���֧���嵥��Ϣ
		Input Param:
			ObjectType: ��������
			ObjectNo:   ������
		Output Param:
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���֧���嵥��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//����������
	String sPutoutSerialNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sPurpose = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Purpose"));
	String sBusinessSum = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BusinessSum"));
	String sPaymentMode    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PaymentMode"));
	String sBusinessCurrency    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BusinessCurrency"));
	String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	
	String customerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String customerName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerName"));
	if(sSerialNo == null ) sSerialNo = ""; 
	if(sObjectType == null) sObjectType = "";
    if(sPutoutSerialNo == null) sPutoutSerialNo = ""; 
    if(sPaymentMode == null) sPaymentMode = ""; 
    if(sPurpose == null) sPurpose = ""; 
    
    if(customerID == null) customerID = "";
    if(customerName == null) customerName = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "PaymentBillInfo";

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
  ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
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
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		if (!ValidityCheck()){
			return;
		}else{
			if(bIsInsert){
				beforeInsert();
			}else
				beforeUpdate();		
			as_save("myiframe0");
		}
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditApply/PaymentBillList.jsp","_self","");
	}

	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//��ǰ֧����ˮ��
		var sPICurrency = getItemValue(0,getRow(),"Currency");//��ǰ֧��ҳ��ı���
		var sBPCurrency = "<%=sBusinessCurrency%>";//��ǰ�Ŵ�ҳ��ı���

		var currentPaymentSum = getItemValue(0,getRow(),"PaymentSum");//��ȡ��ǰҳ���֧�����
		var sReturn = RunMethod("BusinessManage","ChangeToRMB",currentPaymentSum+","+sPICurrency);
		currentPaymentSum = parseFloat(sReturn);
		
		paymentSum1 = RunMethod("BusinessManage","GetCurrentPaymentSum",sSerialNo);//��ȡ��ǰ֧����ˮ�Ŷ�Ӧ��֧�����
		if(paymentSum1>0){
			paymentSum1 = paymentSum1;//����ҳ��
		}else{
			paymentSum1 = 0;//����ҳ��
		}
				
		sParaString = "<%=sPutoutSerialNo%>"+","+"<%=sObjectType%>";		
		sReturn = RunMethod("BusinessManage","GetPaymentAmount",sParaString);//��ȡ�Ѿ������֧�����
		var paymentSum = parseFloat(sReturn);//
		
		sReturn = RunMethod("BusinessManage","ChangeToRMB","<%=sBusinessSum%>"+","+sBPCurrency);
		var putoutSum = parseFloat(sReturn);//��ȡ�Ŵ����
		if((paymentSum+currentPaymentSum-paymentSum1)<= putoutSum)
		{
			return true;
		}else 
		{
			alert("֧���ܽ����ڷſ���!");
			return false;
		}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"PutoutSerialNo","<%=sPutoutSerialNo%>");
			setItemValue(0,0,"PaymentMode","<%=sPaymentMode%>");
			setItemValue(0,0,"CapitalUse","<%=sPurpose%>");
			setItemValue(0,0,"CustomerID","<%=customerID%>");
			setItemValue(0,0,"CustomerName","<%=customerName%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
			initSerialNo();
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "Payment_Info";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>