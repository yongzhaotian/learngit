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
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"����Ŀ¼","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSql = "select distinct CodeTypeOne from CODE_CATALOG order by CodeTypeOne";
	String sCodeTypeOne[][] = Sqlca.getStringMatrix(sSql);
	sSql = "select distinct CodeTypeOne,CodeTypeTwo from CODE_CATALOG order by CodeTypeOne";
	String sCodeTypeTwo[][] = Sqlca.getStringMatrix(sSql);

	int iTreeNode=1;
	String sFolders[][] = new String[sCodeTypeOne.length][2];
	for(int i=0;i<sFolders.length;i++){
		sFolders[i][0] = sCodeTypeOne[i][0];
		sFolders[i][1] =  tviTemp.insertFolder("root",sCodeTypeOne[i][0],"","",iTreeNode++);
		for(int j=0;j<sCodeTypeTwo.length;j++){
			if(sCodeTypeTwo[j][0] != null && sCodeTypeTwo[j][0].equals(sCodeTypeOne[i][0]) && sCodeTypeTwo[j][1] != null && !sCodeTypeTwo[j][1].equals(sCodeTypeOne[i][0])){
				tviTemp.insertPage(sFolders[i][1],sCodeTypeTwo[j][1],sCodeTypeTwo[j][0],"",iTreeNode++);
			}
		}
	}
	tviTemp.insertPage("root","����","","",iTreeNode++);	
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick(){
		var sCodeTypeOne="",sCodeTypeTwo="";
		sNodeValue = getCurTVItem().value;
		if(sNodeValue==""){
			sCodeTypeOne = getCurTVItem().name;
		}else{
			sCodeTypeOne = getCurTVItem().value;
			sCodeTypeTwo = getCurTVItem().name;
		}
		if(sCodeTypeOne=="����") sCodeTypeOne="";
		javascript:parent.OpenComp("CodeCatalog","/Common/Configurator/CodeManage/CodeCatalogList.jsp","CodeTypeOne="+sCodeTypeOne+"&CodeTypeTwo="+sCodeTypeTwo,"right","");	
        setTitle(getCurTVItem().name);
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	startMenu();
	expandNode('root');		
	selectItemByName("������Ϣ");
</script>
<%@ include file="/IncludeEnd.jsp"%>