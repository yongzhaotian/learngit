<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
 
	String PG_TITLE = "ԭ�ظ������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;ԭ�ظ������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "0";//Ĭ�ϵ�treeview���

	//���ҳ�����

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ԭ�ظ������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

	//������ͼ�ṹ
	tviTemp.insertPage("root","ԭ�ظ������","",1);
	
	//�������ֶ�����ͼ�ṹ�ķ�����SQL���ɺʹ�������   �μ�View������ ExampleView.jsp��ExampleView01.jsp
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	function TreeViewOnClick(){
		AsControl.OpenView("/SystemManage/CarManage/ReconsiderList.jsp","","right");
		setTitle(getCurTVItem().name);
	}
	
	<%/*~[Describe=����treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItem(1);
		selectItemByName("ԭ�ظ��������");	//Ĭ�ϴ򿪵�(Ҷ��)ѡ��	
	}
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>
