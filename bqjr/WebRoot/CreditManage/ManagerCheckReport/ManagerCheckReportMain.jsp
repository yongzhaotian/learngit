<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   CYHui  2003.8.18
		Tester:
		Content: ��ҵծȯ������Ϣ_List
		Input Param:
			                CustomerID���ͻ����
			                CustomerRight:Ȩ�޴���----01�鿴Ȩ��02ά��Ȩ��03����ά��Ȩ
		Output param:
		                CustomerID����ǰ�ͻ�����Ŀͻ���
		              	Issuedate:��������
		              	BondType:ծȯ����
		                CustomerRight:Ȩ�޴���
		                EditRight:�༭Ȩ�޴���----01�鿴Ȩ��02�༭Ȩ
		History Log: 
		                 2003.08.20 CYHui
		                 2003.08.28 CYHui
		                 2003.09.08 CYHui 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����鱨��"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�����鱨��&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	

	//���ҳ�����	

	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/%>
	<%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�����鱨��","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
	int iTreeNode=1;

	//������ͼ�ṹ
	tviTemp.insertPage("root","δ��ɵĹ����鱨��","Unfinished","",iTreeNode++);
	tviTemp.insertPage("root","����ɵĹ����鱨��","Finished","",iTreeNode++);
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>
	<script type="text/javascript"> 
	
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick()
	{
		sAction = getCurTVItem().value;
		if(sAction=="Unfinished"){
			OpenComp("ManagerCheckReportList","/CreditManage/ManagerCheckReport/ManagerCheckReportList.jsp","Status=Unfinished&ComponentName=�����鱨��&Status="+getCurTVItem().id+"&OpenerFunctionName="+getCurTVItem().name,"right");
		}else if(sAction=="Finished"){
			OpenComp("ManagerCheckReportList","/CreditManage/ManagerCheckReport/ManagerCheckReportList.jsp","Status=Finished&ComponentName=�����鱨��&Status="+getCurTVItem().id+"&OpenerFunctionName="+getCurTVItem().name,"right");
		}else{
			return;
		}
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
	startMenu();
	expandNode('root');		
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
