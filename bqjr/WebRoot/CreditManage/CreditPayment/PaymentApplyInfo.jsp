<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%> 

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: qfang 2011-6-7
		Tester:
		Content:  ֧���嵥����ҳ��
		Input Param:
		Output param:
		History Log:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "֧���嵥����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%	
	//����������	���������͡��������͡��׶����͡����̱�š��׶α��
	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	//����ֵת���ɿ��ַ���
	if(sSerialNo == null) sSerialNo = "";	
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";		
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "PaymentApplyInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);

	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//���ñ���ʱ�����������ݱ�Ķ���
	dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.getUserID()+","+CurOrg.getOrgID()+") + !WorkFlowEngine.InitializeCLInfo(#SerialNo,#BusinessType,#CustomerID,#CustomerName,#InputUserID,#InputOrgID)");
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
		{"false","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(){
		if (!ValidityCheck()){
			return;
		}else{
			if(bIsInsert){
				//����ǰ���й�����ϵ���
				beforeInsert();
				//��������,���Ϊ��������,�����ҳ��ˢ��һ��,��ֹ�������޸�
				beforeUpdate();
				initSerialNo();
				as_save("myiframe0");
				autoCloseSelf();
				return;
			}else{
				beforeUpdate();
				as_save("myiframe0");
			}
		}
	}
	function autoCloseSelf(){
		self.returnValue=getItemValue(0,getRow(),"SerialNo");
		self.close();
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack(){
		top.close();
	}

	function selectPutOutSerialNo(){
		var sInputUserID = getItemValue(0,getRow(),"InputUserID");
		var sParaString = "PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>"+","+"InputUserID"+","+sInputUserID;
		var sReturn = setObjectValue("SelectPutOutSerialNo",sParaString,"",0,0,"");
		if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || sReturn == "_CANCEL_") return;
		sReturn = sReturn.split("@");
		var sSerialNo = sReturn[0];	//�ſ���
		var sPaymentMode = sReturn[1]; //֧����ʽ
		var sCustomerName = sReturn[2];//�ͻ�����
		var sBusinessSum = sReturn[3];//�Ŵ����
		var sCustomerID = sReturn[4];//�ͻ����
		var sBusinessCurrency = sReturn[5];//�Ŵ����
		setItemValue(0,getRow(),"PutoutSerialNo",sSerialNo);
		setItemValue(0,getRow(),"PaymentMode",sPaymentMode);
		setItemValue(0,getRow(),"CustomerName",sCustomerName);
		setItemValue(0,getRow(),"BusinessSum",sBusinessSum);
		setItemValue(0,getRow(),"CustomerID",sCustomerID);	
		setItemValue(0,getRow(),"BusinessCurrency",sBusinessCurrency);
	}

	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//֧����ˮ��
		var sPICurrency = getItemValue(0,getRow(),"Currency");//��ǰ֧��ҳ��ı���
		var sBPCurrency = getItemValue(0,getRow(),"BusinessCurrency");//��ǰ�Ŵ�ҳ��ı���
		var putoutSum = getItemValue(0,getRow(),"BusinessSum");//��ȡ��طŴ�ҵ��ķŴ����
		var sPutoutSerialNo = getItemValue(0,getRow(),"PutoutSerialNo");//��طŴ�����ˮ��
		var currentPaymentSum = getItemValue(0,getRow(),"PaymentSum");//��ȡ��ǰҳ���֧�����
		var sReturn = RunMethod("BusinessManage","ChangeToRMB",currentPaymentSum+","+sPICurrency);
		currentPaymentSum = parseFloat(sReturn);
		
		var paymentSum1 = RunMethod("BusinessManage","GetCurrentPaymentSum",sSerialNo);//��ȡ��ǰ֧����ˮ�Ŷ�Ӧ��֧�����
		if(paymentSum1>0){
			paymentSum1 = paymentSum1;//����ҳ��
		}else{
			paymentSum1 = 0;//����ҳ��
		}
							
		var sParaString = sPutoutSerialNo+","+"<%=sObjectType%>";
		sReturn = RunMethod("BusinessManage","GetPaymentAmount",sParaString);//��ȡ�Ѿ������֧�����
		var paymentSum = parseFloat(sReturn);

		sReturn = RunMethod("BusinessManage","ChangeToRMB",putoutSum+","+sBPCurrency);
		putoutSum = parseFloat(sReturn);//��ȡ�Ŵ����

		if((paymentSum+currentPaymentSum-paymentSum1)<= putoutSum){
			return true;
		}else{
			alert("֧���ܽ����ڷſ���!");
			return false;
		}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false;
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"DocID","6000");
			setItemValue(0,0,"PaymentStatus","000");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
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