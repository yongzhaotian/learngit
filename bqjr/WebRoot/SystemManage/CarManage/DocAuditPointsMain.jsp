<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Author:  xswang 2015/05/25
		Tester:
		Content: �ļ�����������Ҫ�����
		Input Param:
		Output param:
		History Log: 
	*/
	String PG_TITLE = "�ļ�����������Ҫ�����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�ļ�����������Ҫ�����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "0";//Ĭ�ϵ�treeview���

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�ļ�����������Ҫ�����","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

	//������ͼ�ṹ
	tviTemp.insertPage("root","�ļ�����������Ҫ�����","",1);
	
	//�������ֶ�����ͼ�ṹ�ķ�����SQL���ɺʹ�������   �μ�View������ ExampleView.jsp��ExampleView01.jsp
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	function TreeViewOnClick(){
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		//var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		AsControl.OpenView("/SystemManage/CarManage/DocAuditPointsList.jsp","","right");
		setTitle(getCurTVItem().name);
	}
	
	<%/*~[Describe=����treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItem(1);
		selectItemByName("�ļ�����������Ҫ�����");	//Ĭ�ϴ򿪵�(Ҷ��)ѡ��	
	}
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>
