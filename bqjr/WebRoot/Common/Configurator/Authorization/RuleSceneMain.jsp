<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		Content: ��Ȩ����������
 	*/
	String PG_TITLE = "��Ȩ����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��Ȩ����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	
	//�������
	
	//����������
	
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��Ȩ����","right");
	//������ͼ�ṹ
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����
	/*
	String sFolder = tviTemp.insertFolder("root","��Ȩ��������","",1);
	tviTemp.insertPage(sFolder,"��Ȩ����������","",11);
	tviTemp.insertPage(sFolder,"��Ȩ��������","",12);
	tviTemp.insertPage("01","root","��Ȩ��������","","",1);
	*/
	tviTemp.insertPage("01","root","��Ȩ��������","","",1);
	tviTemp.insertPage("02","root","��Ȩ��������","","",2);
%>
<%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick()
	{
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemID=='01'){
			OpenComp("RuleSceneGroupList","/Common/Configurator/Authorization/RuleSceneGroupList.jsp","","right");
			setTitle(sCurItemname);
		}else if(sCurItemID=='02'){
			OpenComp("DimensionList","/Common/Configurator/Authorization/DimensionList.jsp","","right");
			setTitle(sCurItemname);
		}
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	startMenu();
	expandNode('root');
	selectItemByName('��Ȩ��������');	//Ĭ�ϴ򿪵�(Ҷ��)ѡ��
</script>
<%@ include file="/IncludeEnd.jsp"%>