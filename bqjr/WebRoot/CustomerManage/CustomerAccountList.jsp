<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: sjchuan 2009-10-12
		Tester:
		Describe: �ͻ��˻��б�ҳ��
		Input Param:
			CustomerID:��ǰ�ͻ����
		Output Param:
			CustomerID:��ǰ�ͻ����
			SerialNo:��¼��ˮ��
			EditRight:Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��
		HistoryLog:
	*/
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ��˻���Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
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
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CustomerAccountList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
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
		{"true","","Button","����","�����ͻ��˻���Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴�ͻ��˻���Ϣ����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ���ͻ��˻���Ϣ","deleteRecord()",sResourcesPath},
	};
	%>
<%/*~END~*/%>



<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�---------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/CustomerManage/CustomerAccountInfo.jsp?EditRight=02","_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sUserID = getItemValue(0,getRow(),"InputUserID");//�û�����
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID) == "undefined" || sCustomerID.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(sUserID == '<%=CurUser.getUserID()%>')
		{
    		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
    		{
    			as_del('myiframe0');
    			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
    		}	
    	}
    	else
        	alert(getHtmlMessage('3'));	
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sUserID = getItemValue(0,getRow(),"InputUserID");
		if(sUserID == '<%=CurUser.getUserID()%>')
			sEditRight = '02';
		else
			sEditRight = '01';
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/CustomerManage/CustomerAccountInfo.jsp?SerialNo="+sSerialNo+"&EditRight="+sEditRight, "_self","");
		}
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