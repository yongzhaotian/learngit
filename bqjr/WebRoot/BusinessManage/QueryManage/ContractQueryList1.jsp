<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.app.accounting.config.loader.*" %>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   lwang 20140219
		Tester:
		Content: ��ͬ��ѯ
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬ��ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ͬ��ѯ&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql���
	//����������	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	//����sSql�������ݶ���

	String sTempletNo = "ContractQueryList1"; //ģ����
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setKeyFilter("SerialNo");
	//���ɲ�ѯ��
	//add by lwang 20140219  begin
	doTemp.generateFilters(Sqlca);
	//add by lwang 20140219  end
	doTemp.parseFilterData(request,iPostChange);
	
	String sSortNo = CurOrg.getSortNo()+"%";
	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSortNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

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
		//{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
		//{"true","","Button","�����˺ű��","�����˺ű��","",sResourcesPath},
		//{"true","","Button","�����ٴδ���","�����ٴδ���","",sResourcesPath},
		{"true","","Button","��ǰ�����ѯ","��ѯ��ǰ������Ϣ","SelectPrepayment()",sResourcesPath},
		//{"true","","Button","�˿��ѯ","��ѯ�˿��ѯ��Ϣ","",sResourcesPath},
		{"true","","Button","�˿�","�˿�����","returnAmtApply()",sResourcesPath},
		{"true","","Button","ȷ���˿�","ȷ���˿�","affirm('0110','�˿��')",sResourcesPath},
		{"true","","Button","�ֹ�¼�뻹��","�ֹ�¼�뻹��","PayManualRecord()",sResourcesPath},
		{"true","","Button","ȷ���ֹ�¼�뻹��","ȷ���ֹ�¼�뻹��","affirm('0050','�ֹ�¼�뻹��')",sResourcesPath},
		//{"true","","Button","ȷ��������ǰ����","ȷ��������ǰ����","affirm('0055','��ǰ����')",sResourcesPath},
		{"true","","Button","�����ձ��","�����ձ������","LoanAfterChange()",sResourcesPath},
		{"true","","Button","ȷ�ϻ����ձ��","ȷ�ϻ����ձ��","affirm('2012','�����ձ������')",sResourcesPath},
		{"true","","Button","���ʽ���","���ʽ�������","PaymentMethodChange()",sResourcesPath},
		{"true","","Button","ȷ�ϻ��ʽ���","ȷ�ϻ��ʽ���","affirm('2011','���ʽ�������')",sResourcesPath},
		//{"true","","Button","�������֤������","�������֤������","CreditSettle()",sResourcesPath},
		{"true","","Button","�˻�","�˻�����","returnLoan()",sResourcesPath},
		{"true","","Button","���ü���","���ü�������","feeWaive()",sResourcesPath},
		{"true","","Button","�����¼�","�����¼�����","newFeeEvent()",sResourcesPath},
		//{"true","","Button","����ȡ������","����ȡ������","",sResourcesPath},
		//{"true","","Button","���ս�����","���ս�����","",sResourcesPath},
		//{"true","","Button","���Ӻ�ͬ����","���Ӻ�ͬ����","",sResourcesPath},
		//{"true","","Button","Ӱ���ͬ����","Ӱ���ͬ����","",sResourcesPath},
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		
	    sObjectType = "BusinessContract";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			sCompID = "CreditTab";
    		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
    		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
    		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}

	}	
	
	/*~[Describe=��ǰ�����ѯ;InputParam=��;OutPutParam=SerialNo;]~*/
	function SelectPrepayment()
	{
		//��ȡ��ͬ�ţ����֤��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		sCertID =getItemValue(0,getRow(),"CertID");	
		alert(sSerialNo);
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			var sReturn=RunMethod("BusinessManage","LoanCount",sSerialNo);
			if(sReturn==0){
				alert("�ñʺ�ͬ��δ�ſ�,��ſ�֮�������ò���");
				return;
			}
			
			AsControl.OpenView("/CustomService/BusinessConsult/PaymentApplyDlog.jsp","SerialNo="+sSerialNo+"&CertID="+sCertID,"_blank",OpenStyle);
		}

	}
	
	/*~[Describe=�������뽻��ȷ��;InputParam=��;OutPutParam=SerialNo;]~*/
	function affirm(transactionCode,messageError)
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		var transactionSerialNo=RunMethod("BusinessManage","TransactionSerialno",transactionCode+","+sSerialNo);
		if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo.length == 0){
			alert("�ú�ͬ��������δ��Ч��"+messageError);
			return;
		}else{
			//�����ձ���뻹�ʽ���У��
			if (transactionCode=='2011' || transactionCode=='2012'){
				var sReturn=RunMethod("BusinessManage","getCheckReturn",transactionSerialNo);
				if(sReturn!='true'){
					alert("�ú�ͬ��������δ��Ч��"+messageError);
					return;
				}
			}
			
			//�ֹ�¼�뻹����˿�У��
			if (transactionCode=='0050' || transactionCode=='0110'){
				var sReturn=RunMethod("BusinessManage","getPayCheckReturn",transactionSerialNo);
				if(sReturn!='true'){
					alert("�ú�ͬ��������δ��Ч��"+messageError);
					return;
				}
			}
			
			if(confirm("��ȷ���Ƿ������Ч����"))
			{
				alert(transactionSerialNo);
				var returnValue = RunMethod("LoanAccount","RunTransaction2",transactionSerialNo+",<%=CurUser.getUserID()%>,N");
				if(typeof(returnValue)=="undefined"||returnValue.length==0){
					alert("ϵͳ�����쳣��");
					return;
				}
				var message=returnValue.split("@")[1];
				alert(message);
				reloadSelf();
			}			
		}
	}	
	
	function CreditSettle(){
		sObjectNo =getItemValue(0,getRow(),"SerialNo");	
		sObjectType = "CreditSettle";
		sExchangeType = "";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		//������֪ͨ���Ƿ��Ѿ�����
		var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (sReturn == "false"){ //δ���ɳ���֪ͨ��
			//���ɳ���֪ͨ��	
			PopPage("/FormatDoc/Report13/7001.jsp?DocID=7001&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sObjectNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		}
		//��ü��ܺ�ĳ�����ˮ��
		var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
		
		//ͨ����serverlet ��ҳ��
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
		OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
		
		
	}	
	
	
	/*~[Describe= ���������¼�;InputParam=��;OutPutParam=SerialNo;]~*/
	function newFeeEvent()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			var sReturn=RunMethod("BusinessManage","LoanCount",sSerialNo);
			if(sReturn==0){
				alert("�ñʺ�ͬ��δ�ſ�,��ſ�֮�������ò���");
				return;
			}
			
			var sReturn=RunMethod("BusinessManage","SelectCarLoan",sSerialNo);
			if(sReturn==0){
				alert("�ñʺ�ͬ�������������������ò���");
				return;
			}
			popComp("PaymentDateChange","/BusinessManage/QueryManage/BusinessFeeEvent.jsp","SerialNo="+sSerialNo,"dialogWidth=600px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		}

	}	
	
	
	/*~[Describe= �ֹ�¼�뻹��;InputParam=��;OutPutParam=SerialNo;]~*/
	function PayManualRecord()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{	
			var sReturn=RunMethod("BusinessManage","LoanCount",sSerialNo);
			if(sReturn==0){
				alert("�ñʺ�ͬ��δ�ſ�,��ſ�֮�������ò���");
				return;
			}
			
			var transactionDate="";
			var transactionCode ="0050";
			
			var sLoanSerialno = RunMethod("BusinessManage","SelLoanSerialno",sSerialNo);
			var relativeObjectType = "jbo.app.ACCT_LOAN";
			var relativeObjectNo = sLoanSerialno;
				

			var TransSerialno = RunMethod("LoanAccount","GetExistApplyFlag",transactionCode+","+relativeObjectNo+","+relativeObjectType);
			if(typeof(TransSerialno) == "undefined" || TransSerialno.length == 0 || TransSerialno=="Null")
			{
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
					
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&";
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}else{
				alert(TransSerialno);
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+TransSerialno;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
				
			}
			reloadSelf();
		}

	}
	
	/*~[Describe= ���ü�������;InputParam=��;OutPutParam=SerialNo;]~*/
	function feeWaive()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		sCustomerName=getItemValue(0,getRow(),"CustomerName");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		var sLoanSerialno = RunMethod("BusinessManage","SelLoanSerialno",sSerialNo);
		var s=setObjectValue("SelectFeeWaive","serialno,"+sLoanSerialno,"@"+sOrgID+"@0@"+sOrgName+"@1",0,0,"");
		
	}
	
	/*~[Describe= �˻�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function returnLoan()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			//�Ƿ����Ѵ�
		   /*  var sResult=RunMethod("BusinessManage","LoanProductType",sSerialNo);
			if(sResult==0){
				alert("�ñʺ�ͬ�������Ѵ���Ʒ���������˻�����");
				return;
			} 
			
			//�Ƿ�����ԥ����
			var sReturn=RunMethod("BusinessManage","HesitateDay",sSerialNo);
			if(sReturn==0){
				alert("�ñʺ�ͬ�ѳ�����ԥ����,�������˻�����");
				return;
			}  
			 */
			var sReturn=RunMethod("BusinessManage","LoanCount",sSerialNo);
			if(sReturn==0){
				alert("�ñʺ�ͬ��δ�ſ�,��ſ�֮�������ò���");
				return;
			}
			
			var transactionDate="";
			var transactionCode ="0052";
			
			var sLoanSerialno = RunMethod("BusinessManage","SelLoanSerialno",sSerialNo);
			var relativeObjectType = "jbo.app.ACCT_LOAN";
			var relativeObjectNo = sLoanSerialno;
				

			var TransSerialno = RunMethod("LoanAccount","GetExistApplyFlag",transactionCode+","+relativeObjectNo+","+relativeObjectType);
			if(typeof(TransSerialno) == "undefined" || TransSerialno.length == 0 || TransSerialno=="Null")
			{
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
					
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&";
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}else{
				alert(TransSerialno);
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+TransSerialno;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
				
			}
			reloadSelf();
		}

	}
	
	/*~[Describe= �����ձ��;InputParam=��;OutPutParam=SerialNo;]~*/
	function LoanAfterChange()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			var sReturn=RunMethod("BusinessManage","LoanCount",sSerialNo);
			if(sReturn==0){
				alert("�ñʺ�ͬ��δ�ſ�,��ſ�֮�������ò���");
				return;
			}
			
			var transactionDate="";
			var transactionCode ="2012";
			
			
			var sLoanSerialno = RunMethod("BusinessManage","SelLoanSerialno",sSerialNo);
			var relativeObjectType = "jbo.app.ACCT_LOAN";
			var relativeObjectNo = sLoanSerialno;

			var TransSerialno = RunMethod("LoanAccount","GetExistApplyFlag",transactionCode+","+relativeObjectNo+","+relativeObjectType);
			if(typeof(TransSerialno) == "undefined" || TransSerialno.length == 0 || TransSerialno=="Null")
			{
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
					
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&";
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}else{
				alert(TransSerialno);
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+TransSerialno;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
				
			}
			reloadSelf();
		}

	}
	
	/*~[Describe= ���ʽ���;InputParam=��;OutPutParam=SerialNo;]~*/
	function PaymentMethodChange()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			var sReturn=RunMethod("BusinessManage","LoanCount",sSerialNo);
			if(sReturn==0){
				alert("�ñʺ�ͬ��δ�ſ�,��ſ�֮�������ò���");
				return;
			}
			
			var transactionDate="";
			var transactionCode ="2011";
			
			var sLoanSerialno = RunMethod("BusinessManage","SelLoanSerialno",sSerialNo);
			var relativeObjectType = "jbo.app.ACCT_LOAN";
			var relativeObjectNo = sLoanSerialno;
			
			var TransSerialno = RunMethod("LoanAccount","GetExistApplyFlag",transactionCode+","+relativeObjectNo+","+relativeObjectType);
			if(typeof(TransSerialno) == "undefined" || TransSerialno.length == 0 || TransSerialno=="Null")
			{
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
					
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&";
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}else{
				alert(TransSerialno);
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+TransSerialno;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
				
			}
			reloadSelf();
		}

	}
	
	/*~[Describe= �˿�;InputParam=��;OutPutParam=SerialNo;]~*/
	function returnAmtApply()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			var sReturn=RunMethod("BusinessManage","LoanCount",sSerialNo);
			if(sReturn==0){
				alert("�ñʺ�ͬ��δ�ſ�,��ſ�֮�������ò���");
				return;
			}
			
			var transactionDate="";
			var transactionCode ="0110";
			
			var sLoanSerialno = RunMethod("BusinessManage","SelLoanSerialno",sSerialNo);
			var relativeObjectType = "jbo.app.ACCT_LOAN";
			var relativeObjectNo = sLoanSerialno;
				
			var TransSerialno = RunMethod("LoanAccount","GetExistApplyFlag",transactionCode+","+relativeObjectNo+","+relativeObjectType);
			if(typeof(TransSerialno) == "undefined" || TransSerialno.length == 0 || TransSerialno=="Null")
			{
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
					
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&";
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}else{
				alert(TransSerialno);
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+TransSerialno;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
				
			}
			reloadSelf();
		}

	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
