<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��:ʾ��ģ����ҳ��--
	 */
	String PG_TITLE = "�鵵����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ͬ�鵵&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//���ҳ�����

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��ͬ�鵵","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

	//������ͼ�ṹ
	/* String sFolder1=tviTemp.insertFolder("root","ʾ����Ϣ","",1);
	tviTemp.insertPage(sFolder1,"���е�ʾ����Ϣ","",1);
	tviTemp.insertPage(sFolder1,"�ҵ�ʾ����Ϣ","",2);
	tviTemp.insertPage(sFolder1,"����ʾ����Ϣ","",3); */
	tviTemp.insertPage("root","δ�鵵��ͬ","",1);
	tviTemp.insertPage("root","�ѹ鵵��ͬ","",2);
	tviTemp.insertPage("root","����δ�黹�ĵ��ĺ�ͬ","",2);
	
	//�������ֶ�����ͼ�ṹ�ķ�����SQL���ɺʹ�������   �μ�View������ ExampleView.jsp��ExampleView01.jsp
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	function TreeViewOnClick(){
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=='�ѹ鵵��ͬ'){
			AsControl.OpenView("/AppConfig/Document/ArchiveContractList.jsp","","right");
		}else if(sCurItemname=='δ�鵵��ͬ'){
			AsControl.OpenView("/AppConfig/Document/UnarchiveContractList.jsp","","right");
		}else if(sCurItemname=='����δ�黹�ĵ��ĺ�ͬ'){
			AsControl.OpenView("/AppConfig/Document/ContractNoReturnList.jsp","","right");
		}else{
			return;
		}
		setTitle(getCurTVItem().name);
	}
	
	<%/*~[Describe=����treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItemByName("δ�鵵��ͬ");	//Ĭ�ϴ򿪵�(Ҷ��)ѡ��	
	}
	
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>
