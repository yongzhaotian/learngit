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
	String PG_TITLE = "�˿��ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����

	//����������
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));

	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	     	
		String sTempletNo = "RefundApplyList"; //ģ����
	    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
		//���ɲ�ѯ��
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		
		//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
		
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		dwTemp.setPageSize(16);  //��������ҳ

		//����HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
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
		{"true","","Button","�˿�����","�˿�����","returnAmtApply()",sResourcesPath},
		//{"true","","Button","��������","��������","viewTask()",sResourcesPath},
		//{"true","","Button","ȡ������","ȡ������","cancelApply()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
	function viewTask(){
		//����������͡�������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		sCompID = "CreditTab";
		sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
		sParamString = "ObjectType=Transaction&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		
		reloadSelf();
	}

	/*~[Describe=ȡ������;InputParam=��;OutPutParam=��;]~*/
	function cancelApply(){
		//����������͡�������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getHtmlMessage('70'))){ //�������ȡ������Ϣ��
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
		reloadSelf();//����������ȡ��ʱ����
	}
	

	/*~[Describe= �˿�;InputParam=��;OutPutParam=SerialNo;]~*/
	function returnAmtApply()
	{
		//���ҵ����ˮ��
		sCustomerID = getItemValue(0,getRow(),"customerid");
		sDepositsamt = getItemValue(0,getRow(),"depositsamt");
		sCustomerName = getItemValue(0,getRow(),"customername");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		var sApplyCount = RunMethod("BusinessManage","UntreatedRefundApply",sCustomerID);
		if(sApplyCount>0){
			alert("�ÿͻ����´���δ��Ч���˿�����,�������ٴ�����");
			return;
		}
		
		var sReturn = RunMethod("BusinessManage","CustomerLoanCount",sCustomerID);
		if(sReturn>0){
			if(confirm("�ÿͻ���һ��������7����,��ȷ��Ҫ�����˿���?")){

				sCompID = "DepositsRefundApply";
				sCompURL = "/InfoManage/QuickSearch/DepositsRefundApply.jsp";
				popComp(sCompID,sCompURL,"CustomerID="+sCustomerID+"&CustomerName="+sCustomerName+"&Depositsamt="+sDepositsamt,"dialogWidth=700px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");

			}
		}else{
			sCompID = "DepositsRefundApply";
			sCompURL = "/InfoManage/QuickSearch/DepositsRefundApply.jsp";
			popComp(sCompID,sCompURL,"CustomerID="+sCustomerID+"&CustomerName="+sCustomerName+"&Depositsamt="+sDepositsamt,"dialogWidth=700px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");

		}
		
		reloadSelf(); 

	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">


	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
