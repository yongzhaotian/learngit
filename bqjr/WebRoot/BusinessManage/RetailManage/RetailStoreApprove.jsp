<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--�������ŵ�׼������
	 */
	String PG_TITLE = "�������ŵ�׼������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�������ŵ�׼������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//���ҳ�����

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�������ŵ�׼������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

	//������ͼ�ṹ                          
	String sFold1=tviTemp.insertFolder("root","������׼������","",1);   
	String tmp1=tviTemp.insertFolder(sFold1,"�����̵�ǰ����","",1); 
 	tviTemp.insertPage(tmp1,"�����̵�ǰ��������","",1);
	tviTemp.insertPage(tmp1,"�����̵�ǰ��������","",2);
    tviTemp.insertPage(sFold1,"���������������","",2); 
    tviTemp.insertPage(sFold1,"�����̲�ͨ������","",3); 

	String sFold2=tviTemp.insertFolder("root","�ŵ�׼������","",2);
	String tmp3=tviTemp.insertFolder(sFold2,"�ŵ굱ǰ����","",1); 
 	tviTemp.insertPage(tmp3,"�ŵ굱ǰ��������","",1);
	tviTemp.insertPage(tmp3,"�ŵ굱ǰ��������","",2);
    tviTemp.insertPage(sFold2,"�ŵ����������","",2); 
    tviTemp.insertPage(sFold2,"�ŵ겻ͨ������","",3); 
	
	//�������ֶ�����ͼ�ṹ�ķ�����SQL���ɺʹ�������   �μ�View������ ExampleView.jsp��ExampleView01.jsp
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	
	function TreeViewOnClick() {
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;

		if (sCurItemname == '�����̵�ǰ��������') {
			AsControl.OpenView(
					"/BusinessManage/RetailManage/RetailApproveList.jsp",
					"type=02", "right");
		} else if (sCurItemname == '�����̵�ǰ��������') {
			AsControl.OpenView(
					"/BusinessManage/RetailManage/RetailApproveList1.jsp",
					"type=02", "right");
		} else if (sCurItemname == '���������������') {
			AsControl.OpenView(
					"/BusinessManage/RetailManage/RetailApproveList2.jsp",
					"type=02", "right");
		} else if (sCurItemname == '�����̲�ͨ������') {
			AsControl.OpenView(
					"/BusinessManage/RetailManage/RetailApproveList2.jsp",
					"type=05", "right");
		} else if (sCurItemname == '�ŵ굱ǰ��������') {
			AsControl.OpenView(
					"/BusinessManage/RetailManage/StoreApproveList.jsp",
					"type=02", "right");
		} else if (sCurItemname == '�ŵ굱ǰ��������') {
			AsControl.OpenView(
					"/BusinessManage/RetailManage/StoreApproveList1.jsp",
					"type=02", "right");
		} else if (sCurItemname == '�ŵ����������') {
			AsControl.OpenView(
					"/BusinessManage/RetailManage/StoreApproveList2.jsp",
					"type=02", "right");
		} else if (sCurItemname == '�ŵ겻ͨ������') {
			AsControl.OpenView(
					"/BusinessManage/RetailManage/StoreApproveList2.jsp",
					"type=05", "right");
		}
		setTitle(getCurTVItem().name);
	}
<%/*~[Describe=����treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItemByName("������׼������");	//Ĭ�ϴ򿪵�(Ҷ��)ѡ��	
	}
	
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>
