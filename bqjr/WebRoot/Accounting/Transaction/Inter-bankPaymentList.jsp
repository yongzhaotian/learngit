<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  xjzhao 2009/12/29
		Tester:
		Describe:
		Input Param:
				ObjectNo ������
				ObjectType ��������
		Output Param:
				
		HistoryLog:
							
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ת���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String readOnlyStr = "ToInheritObj=Y&RightType=ReadOnly&";
	
	//�������������������͡�������
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag")); //���� 0 ���� ��1 ����
	String sFlowStatus = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowStatus"));
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgID"));
	if(sFlag == null)sFlag = "";
	if(sFlowStatus == null)sFlowStatus = "";
	if(sOrgID == null)sOrgID = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//��sSql�������ݴ������
	String sTempletNo = "TransferDealList";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo, sTempletFilter, Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	//���ӹ�����	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(200);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sOrgID+","+sFlowStatus);
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
		{"false","","Button","����","��������֧��","newRecord()",sResourcesPath},
		{"false","","Button","ȡ��֧��","ȡ��֧��","deleteRecord()",sResourcesPath},
		{"false","","Button","����","����","view()",sResourcesPath},
		{"true","","Button","����״̬��ѯ","����״̬��ѯ","select()",sResourcesPath},
		{"false","","Button","�ύ����","�ύ����","doSubmit()",sResourcesPath},
		{"false","","Button","ִ�л���","ִ�л���","Send()",sResourcesPath},
		{"false","","Button","�˻�","�˻�","doNo()",sResourcesPath},
		{"false","","Button","ȡ���ſ�","ȡ���ſ�","flushCommitment()",sResourcesPath},
	};
	if("0".equals(sFlag))
	{
		sButtons[2][0] = "true";
		if("01".equals(sFlowStatus))
		{
			sButtons[0][0] = "true";
			sButtons[4][0] = "true";
			readOnlyStr = "";
		}
		else if("03".equals(sFlowStatus))
		{
			sButtons[3][0] = "true";
		}
		else if("04".equals(sFlowStatus))
		{
			sButtons[4][0] = "true";
			readOnlyStr = "";			
		}
	}
	else if("1".equals(sFlag))
	{
		sButtons[2][0] = "true";
		if("02".equals(sFlowStatus))
		{
			sButtons[3][0] = "true";
			sButtons[5][0] = "true";
			sButtons[6][0] = "true";
		}
		else if("03".equals(sFlowStatus))
		{
			sButtons[3][0] = "true";
		}
	}
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		popComp("TransferDealInfo","/Accounting/Transaction/Inter-bankPaymentInfo.jsp","Type=0","");
		reloadSelf();
	}
	
	/*~[Describe=ͬ��;InputParam=��;OutPutParam=��;]~*/
	function Send()
	{
		alert("����ִ�д�����!");
	}
	
	/*~[Describe=��ѯ;InputParam=��;OutPutParam=��;]~*/
	function select()
	{
		alert("����״̬��ѯ������!");
	}
	
	/*~[Describe=�鿴����;InputParam=��;OutPutParam=��;]~*/
	function view()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo"); //�ʺ���ˮ��
		var sStatus = getItemValue(0,getRow(),"Status"); //�˻�״̬
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			popComp("TransferDealInfo","/Accounting/Transaction/Inter-bankPaymentInfo.jsp","<%=readOnlyStr%>SerialNo="+sSerialNo,"dialogWidth=50;dialogHeight=50;");
			reloadSelf();
		}
	}
    
	/*~[Describe=ɾ��;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("ȷ��ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	
	/*~[Describe=�ύ����;InputParam=��;OutPutParam=��;]~*/
	function doSubmit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		var sReturn = RunMethod("BusinessManage","UpdateTransferStatus",sSerialNo+",02");
		if(parseInt(sReturn) == 1)
		{
			alert("�ύ�ɹ���");
			reloadSelf();
		}
	}
	
	/*~[Describe=�˻�;InputParam=��;OutPutParam=��;]~*/
	function doNo()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		var sReturn = RunMethod("BusinessManage","UpdateTransferStatus",sSerialNo+",04");
		if(parseInt(sReturn) == 1)
		{
			alert("�ύ�ɹ���");
			reloadSelf();
		}
	}

	//�ſ����
	function flushCommitment(){
		var putoutNo = getItemValue(0,getRow(),"ObjectNo");
		var objectType = getItemValue(0,getRow(),"ObjectType");
		if(objectType=="BusinessPutout"){
			var serialNo = RunMethod("PutOutManage","SelectLoanSerialNo",putoutNo+","+contractSerialNo);
			if(typeof(serialNo)=="undefined"||serialNo.length==0){
				alert("��ѡ��һ����¼");
				return;
			}
			var sResult = RunMethod("LoanAccount","FlushCommitment",serialNo+",<%=CurUser.getUserID()%>");
			if(sResult=="true"){
				alert("�ſ���˳ɹ�");
				reloadSelf();
			}else{
				alert(sResult);
				return;
			}
		}else{
			return;
		}
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>