<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: �˻�����
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
	String PG_TITLE = "�˻�������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sBusinessDate=SystemConfig.getBusinessDate();

	//���ҳ�����

	//����������
	String sSerialNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo")));
	String sCustomerName = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerName")));
	String sBusinessSum = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessSum")));
	System.out.println(sSerialNo+"-------"+sCustomerName+"--------"+sBusinessSum);
	if(sSerialNo == null) sSerialNo = "";
	if(sCustomerName == null) sCustomerName = "";
	if(sBusinessSum == null) sBusinessSum = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	     	
		String sTempletNo = "BusinessRefundCargo"; //ģ����
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
		as_save("myiframe0",sPostEvents);
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	
	

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		
		setItemValue(0, 0, "inputorgid", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"inputuserid","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"inputdate","<%=sBusinessDate%>");
		bIsInsert = false;
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			setItemValue(0, 0, "serialno", <%=sSerialNo%>);
			setItemValue(0,0,"customername","<%=sCustomerName%>");
			setItemValue(0,0,"businesssum","<%=sBusinessSum%>");
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
