<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
	Author:   cchang  2004.12.2
	Tester:	  BYao	  2004.12.07
	Content: �ͻ�������
	Input Param:
		 CustomerType���ͻ�����				
			01����˾�ͻ���
			0110��������ҵ�ͻ���
			0120����С����ҵ�ͻ���
			02�����ſͻ���
			0210��ʵ�弯�ſͻ���
			0220�����⼯�ſͻ���
			03�����˿ͻ�
			0310�����˿ͻ���
			0320�����徭Ӫ����
		 CustomerListTemplet:�ͻ��б�ģ�����
		                ���ϲ���ͳһ�ɴ����:MainMenu���˵��õ�����
	Output param:
		 CustomerType���ͻ�����
		 CustomerListTemplet:�ͻ��б�ģ�����
		                ���ϲ���ͳһ�ɴ����:MainMenu���˵��õ�����
	History Log: 
		2004-12-13	cchang	���Ӹ��幤�̻�����
 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ�����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�ͻ�����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	String sCustomerListTemplet = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerListTemplet"));
	
	if(sCustomerType == null) sCustomerType = "";
	if(sCustomerListTemplet == null) sCustomerListTemplet = "";
	
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/%>
	<%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"���ſͻ�����","right");
	if(sCustomerType.equals("02")){
		//������ͼ�ṹ
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
		tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����
		tviTemp.insertPage("01","root","���ſͻ����� ","","",1);
		tviTemp.insertPage("02","root","���ſͻ���ѯ","","",2);
	}
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
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemID=='root'){
			return;
		}else if(sCurItemID=='01'){
			OpenComp("CustomerList","/CustomerManage/CustomerList.jsp","CustomerType="+sCustomerType+"&CustomerListTemplet="+sCustomerListTemplet,"right");
			setTitle(getCurTVItem().name);
		}else if(sCurItemID=='02'){
		}
	} 
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
	<script type="text/javascript">
	sCustomerType = "<%=sCustomerType%>";
	sCustomerListTemplet = "<%=sCustomerListTemplet%>";

	//�����Ϊ���ſͻ������Զ���List,����������ͼ����
	if(sCustomerType == "02"){
		startMenu();
		expandNode('root');
		selectItemByName("���ſͻ����� ");	//Ĭ�ϴ򿪵�(Ҷ��)ѡ��
		//selectItemById("01");
	}else{
		myleft.width=1;
		//OpenComp("CustomerList","/CustomerManage/CustomerList.jsp","CustomerType="+sCustomerType+"&CustomerListTemplet="+sCustomerListTemplet,"right");
		AsControl.OpenView("/InfoManage/QuickSearch/IndQueryList.jsp","","right","");
	}
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
	