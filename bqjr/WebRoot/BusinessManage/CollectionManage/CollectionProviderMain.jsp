<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��:ʾ��ģ����ҳ��
	 */
	String PG_TITLE = "ί�����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;���ڴ���&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//���ҳ�����
	String sComponentName = CurPage.getParameter("ComponentName");

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ί�������ҳ��","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

	//������ͼ�ṹ
	//String sFolder1=tviTemp.insertFolder("root","ʾ����Ϣ","",1);
	tviTemp.insertPage("root","��ί��","",1);
	tviTemp.insertPage("root","��ί��","",2);
	tviTemp.insertPage("root","��ί��(��ǰί��)","",3);
	tviTemp.insertPage("root","��ί��(��ǰί��)","",4);

	
	//�������ֶ�����ͼ�ṹ�ķ�����SQL���ɺʹ�������   �μ�View������ ExampleView.jsp��ExampleView01.jsp
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 

	function TreeViewOnClick(){
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
        
		if(sCurItemname=='��ί��')
		{
			AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionExportProviderList.jsp","PhaseType1=0030","right");
		}
		else if(sCurItemname=='��ί��')
		{
			AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionProviderList.jsp","PhaseType1=0030","right");
		}else  if(sCurItemID=="3")
		{
			AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionExportProviderList.jsp","PhaseType1=0030&type=3","right");

		}else if (sCurItemID=="4"){
			AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionProviderList.jsp","PhaseType1=0030&type=4","right");
		}
		setTitle(getCurTVItem().name);
	}
	
	<%/*~[Describe=����treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItem(1);
		//selectItemByName("<%=sComponentName%>");	//Ĭ�ϴ򿪵�(Ҷ��)ѡ��	
	}
	
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>
