<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��:ʾ��ģ����ҳ��
	 */
	String PG_TITLE = "����������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;����������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview����

	//���ҳ�����

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"������Ա����","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

	//������ͼ�ṹ
	//String sFolder1=tviTemp.insertFolder("root","ʾ����Ϣ","",1);
	//tviTemp.insertPage(sFolder1,"���е�ʾ����Ϣ","",1);
	//tviTemp.insertPage(sFolder1,"�ҵ�ʾ����Ϣ","",2);
	//tviTemp.insertPage(sFolder1,"����ʾ����Ϣ","",3);
	tviTemp.insertPage("root","�ͻ�������","",1);
	//tviTemp.insertPage("root","����������","",2);
	//tviTemp.insertPage("root","�ֻ����������","",3);
	//tviTemp.insertPage("root","�칫�绰������","",4);
	//tviTemp.insertPage("root","��ͥ�绰������","",5);
	//tviTemp.insertPage("root","��ַ������","",6);
	
	
	//�������ֶ�����ͼ�ṹ�ķ�����SQL���ɺʹ�������   �μ�View������ ExampleView.jsp��ExampleView01.jsp
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	function TreeViewOnClick(){
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		//var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=='�ͻ�������'){
			AsControl.OpenView("/SystemManage/CustomerFinanceManage/CustomerWhiteList.jsp","","right");
		}else{
			return;
		}
		setTitle(getCurTVItem().name);
	}
	
	<%/*~[Describe=����treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItemByName("�ͻ�������");	//Ĭ�ϴ򿪵�(Ҷ��)ѡ��	
	}
	
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>