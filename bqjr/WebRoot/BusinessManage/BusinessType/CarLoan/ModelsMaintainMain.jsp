<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	String PG_TITLE = "����ά��"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;����ά��&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���


	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"����ά��","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	tviTemp.insertPage("root", "����ά��", "", 1);
	
	%>

<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>


<script type="text/javascript"> 
	
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		if(sCurItemID=="1"){	
			AsControl.OpenView("/BusinessManage/BusinessType/CarLoan/ModelsMaintainList.jsp","","right");
		}
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
</script> 

<script type="text/javascript">    
	startMenu();
	expandNode('root');
	selectItem('1');
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
