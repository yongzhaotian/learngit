<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	String PG_TITLE = "�����Ǽ�֤�鵵 "; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�����Ǽ�֤�鵵 &nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���


	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�����Ǽ�֤�鵵 ","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	tviTemp.insertPage("root", "���鵵����", "", 1);
	tviTemp.insertPage("root", "�ѹ鵵����", "", 2);
	tviTemp.insertPage("root", "δ�鵵�ĳ����Ǽ�֤", "", 3);
	tviTemp.insertPage("root", "�ѹ鵵�ĳ����Ǽ�֤", "", 4);
	tviTemp.insertPage("root", "�������ĳ����Ǽ�֤", "", 5);
	tviTemp.insertPage("root", "�ѽ���ĳ����Ǽ�֤", "", 6);
	tviTemp.insertPage("root", "������ĳ����Ǽ�֤", "", 7);
	tviTemp.insertPage("root", "�ѳ���ĳ����Ǽ�֤", "", 8);
	%>

<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>


<script type="text/javascript"> 
	
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		if(sCurItemID=="1"){	
			AsControl.OpenView("/AppConfig/Document/BoxList.jsp","temp=1","right");
		}else if(sCurItemID=="2"){
			AsControl.OpenView("/AppConfig/Document/BoxList.jsp","temp=2","right");
		}else if(sCurItemID=="3"){
			AsControl.OpenView("/AppConfig/Document/BoxNOCarList.jsp","curItemID="+sCurItemID,"right");
		}else if(sCurItemID=="4"){
			AsControl.OpenView("/AppConfig/Document/BoxNOCarList.jsp","curItemID="+sCurItemID,"right");
		}else if(sCurItemID=="5"){
			AsControl.OpenView("/AppConfig/Document/BoxNOCarList.jsp","curItemID="+sCurItemID,"right");
		}else if(sCurItemID=="6"){
			AsControl.OpenView("/AppConfig/Document/BoxNOCarList.jsp","curItemID="+sCurItemID,"right");
		}else if(sCurItemID=="7"){
			AsControl.OpenView("/AppConfig/Document/BoxNOCarList.jsp","curItemID="+sCurItemID,"right");
		}else {
			AsControl.OpenView("/AppConfig/Document/BoxNOCarList.jsp","curItemID="+sCurItemID,"right");
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
