<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
<%
	/*
		Author:	sjchuan	2009-10-19
		Tester:
		Content:��������ֵ׼��������ҳ��
		Input Param:
		Output param:
			CustomerType: �ͻ�����
				 01 ��˾�ͻ� 
				 03 ���˿ͻ�
		History Log: 
	*/
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	//���Ͳ˵�ҳ��
	int iLeaf = 1;
	//����������	
	
	//���ҳ�����	

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
<%
	//��������ڱ��� <title> PG_TITLE </title>
	String PG_TITLE = "��������ֵ׼������"; 
	//Ĭ�ϵ�����������
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��������ֵ׼������&nbsp;&nbsp;"; 
	//Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";
	//Ĭ�ϵ�treeview���
	String PG_LEFT_WIDTH = "200";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/%>
<%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�������������Ϣ","right");
	//������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.ImageDirectory = sResourcesPath; 
	//�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.toRegister = false; 
	
	//������ͼ�ṹ
	tviTemp.insertPage("root","��˾�ͻ������������","javascript:parent.openPhase('01')",iLeaf++);
	tviTemp.insertPage("root","���˿ͻ������������","javascript:parent.openPhase('03')",iLeaf++);	
%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>
<script type="text/javascript"> 

	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function openPhase(sCustomerType)
	{
		//�򿪶�Ӧ��List����
		OpenComp("ReserveSingleList","/Reserve/ReserveSingle/ReserveSingleList.jsp","CustomerType="+sCustomerType,"right");
		setTitle(getCurTVItem().name);
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
</script> 
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
<script type="text/javascript">
	//������ͼ
	startMenu();
	//չ����ͼ�Ľڵ�
	expandNode('root');
	selectItem('1');
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
