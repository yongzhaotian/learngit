<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��:ʾ��ģ����ҳ��
	 */
	String PG_TITLE = "��������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//���ҳ�����

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

	//������ͼ�ṹ
	//String sFolder1=tviTemp.insertFolder("root","ʾ����Ϣ","",1);
	//tviTemp.insertPage(sFolder1,"���е�ʾ����Ϣ","",1);
	//tviTemp.insertPage(sFolder1,"�ҵ�ʾ����Ϣ","",2);
	//tviTemp.insertPage(sFolder1,"����ʾ����Ϣ","",3);
	tviTemp.insertPage("root","���̹���","",1);
	tviTemp.insertPage("root","ί��ʱ������","",2);
	tviTemp.insertPage("root","ί�а����嵥�������ڹ���","",3);
	tviTemp.insertPage("root","һ��ί�а�����Ч�ڹ���","",4);
	tviTemp.insertPage("root","����ί�а�����Ч�ڹ���","",5);
	tviTemp.insertPage("root","���ּ�����ί�а�����Ч�ڹ���","",6);
	tviTemp.insertPage("root","������������","",7);
	tviTemp.insertPage("root","�ж��������","",8);
	tviTemp.insertPage("root","ί����˾����","",9);
	tviTemp.insertPage("root","��������������յĶ���","",10);
	tviTemp.insertPage("root","���ڽ��������յĶ���","",11);
	tviTemp.insertPage("root","���������߼�����","",12);
	
	//�������ֶ�����ͼ�ṹ�ķ�����SQL���ɺʹ�������   �μ�View������ ExampleView.jsp��ExampleView01.jsp
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	function TreeViewOnClick(){
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=='���̹���') {
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/CollectionFlowList.jsp","","right");
		}else  if(sCurItemname=='ί��ʱ������'){
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/DelegateDuration.jsp","TypeCode=DelegateDuration","right");
		}else if(sCurItemname=='ί�а����嵥�������ڹ���'){
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/DelegateCaseListCreateDate.jsp","TypeCode=DelegateCaseListCreateDate","right");
		}else if(sCurItemname=='һ��ί�а�����Ч�ڹ���'){
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/FirstCaseWorkDuration.jsp","TypeCode=FirstCaseWorkDuration","right");
		}else if(sCurItemname=='����ί�а�����Ч�ڹ���'){
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/SecondCaseWorkDuration.jsp","TypeCode=SecondCaseWorkDuration","right");
		}else if(sCurItemname=='���ּ�����ί�а�����Ч�ڹ���'){
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/ThreeMoreCaseWorkDuration.jsp","TypeCode=ThreeMoreCaseWorkDuration","right");
		}else if(sCurItemname=='������������'){
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/CollectionChannelList.jsp","","right");
		}else if(sCurItemname=='�ж��������'){
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/ActionCodeList.jsp","","right");
		}else if(sCurItemname=='ί����˾����'){
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/DelegateCompanyList1.jsp","","right");
		}else if(sCurItemname=='��������������յĶ���'){
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/OverDayDuration.jsp","TypeCode=OverDayDuration","right");
		}else if(sCurItemname=='���ڽ��������յĶ���') {
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/OverDayCollectionAmount.jsp","TypeCode=OverDayCollectionAmount","right");
		}else if(sCurItemname=='���������߼�����') {
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/BatchWithholdLogic.jsp","","right");
		}else{
			return;
		}
		setTitle(getCurTVItem().name);
	}
	
	<%/*~[Describe=����treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItemByName("���̹���");	//Ĭ�ϴ򿪵�(Ҷ��)ѡ��	
	}
	
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>
