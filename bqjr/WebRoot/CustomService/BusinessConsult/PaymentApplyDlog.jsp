<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Describe: ��ǰ�����ѯҳ��
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ǰ�����ѯҳ��"; // ��������ڱ��� <title> PG_TITLE </title>
	String sCertID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CertID"));//���֤��
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//��ͬ��

	
	String BusinessDate=SystemConfig.getBusinessDate();
	if (sCertID==null) sCertID="";
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
		String sHeaders[][] = { 
								{"CertID","�ͻ����֤��"},
								{"ContractSerialno","��ͬ��"},
								{"YesNo","�Ƿ���ȡ��ǰ����������"},
								{"ScheduleDate","�ƻ���ǰ��������"},
								{"payDate","��ǰ�����������"},
								{"payAmt","�ܽ��"}
								
							}; 

		  String sSql ="select '' as CertID,'' as ContractSerialno,'' as YesNo,'' as ScheduleDate,'' as payDate,'' as payAmt from SYSTEM_SETUP where 1=2";
		//����DataObject				
		 ASDataObject doTemp = new ASDataObject(sSql);
		 doTemp.setHeader(sHeaders);
		
		doTemp.setReadOnly("CertID,ContractSerialno,payDate,payAmt", true);
		doTemp.setRequired("ContractSerialno,payDate,YesNo,ScheduleDate,payAmt", true);
		doTemp.setCheckFormat("ScheduleDate","3");
		doTemp.setAlign("ScheduleDate","1");
		doTemp.setHTMLStyle("ScheduleDate"," style={width:130px} onChange=\"javascript:parent.QueryPaymentConsult()\"");
		doTemp.setHTMLStyle("YesNo"," onClick=\"javascript:parent.SelectYesNo()\"");
		doTemp.setDDDWCode("YesNo", "YesNo");
		doTemp.setEditStyle("YesNo", "2");
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //����Ϊ��д
		
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
			{"true","","Button","��ǰ�������뱣��","��ǰ�������뱣��","PrePaymentApply()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>
	
<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=ѡ���Ƿ���ȡ��ǰ����������;InputParam=�����¼�;OutPutParam=��;]~*/
	function SelectYesNo()
	{	
		setItemValue(0,getRow(),"ScheduleDate","");	
		setItemValue(0,getRow(),"payDate","");
		setItemValue(0,getRow(),"payAmt","");
		AsControl.OpenView("/BusinessManage/RetailManage/ImageViewInfo.jsp","","rightdown","");
		return;
	}	

	/*~[Describe=��ǰ������ѯ;InputParam=�����¼�;OutPutParam=��;]~*/
	var Flag = true;
	function QueryPaymentConsult()
	{	
		//if(!vI_all("myiframe0")) return;
		var sScheduleDate=getItemValue(0,getRow(),"ScheduleDate");
		var sContractSerialNo=getItemValue(0,getRow(),"ContractSerialno");
		var sYesNo=getItemValue(0,getRow(),"YesNo");
		if (typeof(sYesNo)=="undefined" || sYesNo.length==0){
			alert("����ѡ���Ƿ���ȡ��ǰ���������ѡ���");
			AsControl.OpenView("/BusinessManage/RetailManage/ImageViewInfo.jsp","","rightdown","");
			return;
		}
		
		if("<%=BusinessDate%>">sScheduleDate){
			alert("�������ڲ���С�ڵ�ǰϵͳ����");
			setItemValue(0,getRow(),"payDate","");
			setItemValue(0,getRow(),"payAmt","");
			AsControl.OpenView("/BusinessManage/RetailManage/ImageViewInfo.jsp","","rightdown","");
			return;
		}
		
		//��ȡ��ǰ�������������Ӧ���ܽ��
		var sReturn= RunMethod("BusinessManage","BusinessPayDateAmt",sContractSerialNo+","+sScheduleDate+","+sYesNo);
		var str=sReturn.split(",");
		
		setItemValue(0,getRow(),"payDate",str[0]);
		setItemValue(0,getRow(),"payAmt",str[1]);
		Flag = str[2];
		
		var transactionSerialNo = "";
		var transactionCode ="0055";
		var PrePrepayFeeAmt = str[3];
		var sYesNo=getItemValue(0,getRow(),"YesNo");
		sCompID = "CreditTab";
		sCompURL = "/CustomService/BusinessConsult/paymentLoanTrans.jsp";
		sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&"+"&PayDate="+str[0]+"&"+"&ScheduleDate="+sScheduleDate+"&Flag=010&"+"&PrePrepayFeeAmt="+PrePrepayFeeAmt+"&ContractSerialNo="+sContractSerialNo+"&YesNo="+sYesNo;
		AsControl.OpenView(sCompURL,sParamString,"rightdown","");
	}	
	
	
	<%/*~[Describe=��ǰ��������;] added by tbzeng 2014/02/19~*/%>
	function PrePaymentApply() {
		if(!vI_all("myiframe0")) return;
		if(!confirm("�Ƿ�ȷ����ǰ��������,ȷ�Ͻ����ܲ�����Ӧ���ã�")) return;
		var sPayDate=getItemValue(0,getRow(),"payDate");
		var sScheduleDate=getItemValue(0,getRow(),"ScheduleDate");
		var sYesNo=getItemValue(0,getRow(),"YesNo");
		
		//���ҵ����ˮ��
		sSerialNo ="<%=sSerialNo%>";	
		var transactionDate="";
		var transactionCode ="0055";
		
		var sLoanSerialno = RunMethod("BusinessManage","SelLoanSerialno",sSerialNo);
		var relativeObjectType = "jbo.app.ACCT_LOAN";
		var relativeObjectNo = sLoanSerialno;
		
		//CCS-953 ��ǰ����˻������ü����໥�ж��Ƿ��н��׽�����
		var returnValue = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PayMentRevisionSchedule","validate","contractSerialNo="+sSerialNo+"");
		if(returnValue!="0"){
			alert(returnValue);
			return;
		}//CCS-953 end
		
		var allowApplyFlag = RunMethod("LoanAccount","GetTransAllowApplyFlag",transactionCode+","+relativeObjectType+","+relativeObjectNo);
		
		if(allowApplyFlag != "true")
		{
		
			RunMethod("LoanAccount","DeleteAcctTransPayment",transactionCode+","+relativeObjectNo+","+relativeObjectType);
			RunMethod("LoanAccount","DeleteAcctTransaction",transactionCode+","+relativeObjectNo+","+relativeObjectType);
			RunMethod("LoanAccount","DeleteAcctPaymentSchedule",relativeObjectNo+","+relativeObjectType);
			RunMethod("LoanAccount","DeletePrepayFee",relativeObjectNo+","+relativeObjectType);
			
		}
		//modify end
		var objectType="TransactionApply";
		var returnValue = RunMethod("LoanAccount","CreateTransaction",objectType+","+transactionCode+","+relativeObjectType+","+relativeObjectNo+","+transactionDate+",<%=CurUser.getUserID()%>");
		if(returnValue.substring(0,5) != "true@") {
			alert("��������ʧ�ܣ�����ԭ��-"+returnValue);
			return;
		}
		returnValue = returnValue.split("@");
		var transactionSerialNo = returnValue[1];
		if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo.length == 0){
			alert("��������ʧ�ܣ�����ԭ��-"+returnValue);
			return;
		}
		RunMethod("BusinessManage","DeleteFlowObject",transactionSerialNo);
		RunMethod("BusinessManage","DeleteFlowTask",transactionSerialNo);
		/* //������ǰ���������ѻ����¼
		if(Flag=="true" && sYesNo=="1")
		RunMethod("BusinessManage","BusinessPrepayAmt",sSerialNo+","+sPayDate); */
		
		//RunMethod("BusinessManage","UpdateTransPayment",transactionSerialNo+","+sPayDate+","+sPayAmt);
		var PrePrepayFeeAmt = "";
		if(Flag=="true" && sYesNo=="1"){
			var sparas = "sContractSerialNo="+sSerialNo;//+",periods="+Periods+",businessSum="+sBusinessSum+",ObjectNo="+sObjectNo+",CarStatus="+CarStatus
			var sReturnValuef = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PrePrepayFeeAmt", "runTransaction",sparas);
			PrePrepayFeeAmt = sReturnValuef;
		}else{
			PrePrepayFeeAmt = "0.00";
		}
		
		sCompID = "CreditTab";
		sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
		sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&"+"&PayDate="+sPayDate+"&"+"&ScheduleDate="+sScheduleDate+"&Flag=010&"+"&PrePrepayFeeAmt="+PrePrepayFeeAmt+"&ContractSerialNo="+sSerialNo+"&YesNo="+sYesNo;
		//OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		AsControl.OpenView(sCompURL,sParamString,"rightdown","");
		//reloadSelf();
		//self.close();
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
		}
		setItemValue(0,getRow(),"ContractSerialno","<%=sSerialNo%>");
		setItemValue(0,getRow(),"CertID","<%=sCertID%>");
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
