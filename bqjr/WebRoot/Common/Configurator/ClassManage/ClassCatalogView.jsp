<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ��������
	 */
	String PG_TITLE = "��������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSql = "Select ClassName from CLASS_CATALOG Order By ClassName";
	String sTreeView[][] = Sqlca.getStringMatrix(sSql);

	int iTreeNode=1;
	for(int i=0;i<sTreeView.length;i++){
		tviTemp.insertPage("root",sTreeView[i][0],"","",iTreeNode++);
	}
	tviTemp.insertPage("root","����","","",iTreeNode++);
	//tviTemp.initWithSql("CodeTypeOne","ItemName","ItemNo","ItemDescribe","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ�� ID�ֶ�,Name�ֶ�,Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�,OrderBy�Ӿ�,Sqlca
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick(){
		var sClassName="";
		sNodeValue = getCurTVItem().value;
		if(sNodeValue==""){
			sClassName = getCurTVItem().name;
		}else{
			sClassName = getCurTVItem().value;
		}
		if(sClassName=="����") sClassName="";
		OpenComp("ClassCatalogList","/Common/Configurator/ClassManage/ClassCatalogList.jsp","ClassName="+sClassName,"right","");
       setTitle(getCurTVItem().name);
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	startMenu();
	expandNode('root');		
</script>
<%@ include file="/IncludeEnd.jsp"%>