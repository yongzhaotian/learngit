<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
	
<%
	String PG_TITLE = "ҵ�����������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;ҵ���������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview����
	
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ҵ�����������ѯ","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�


	//������ͼ�ṹ,ȥ�����ٵĲ����ʲ��ʹ��պ����ٲ�ѯ
	String sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'TermType' and IsInUse in('0','1') ";
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
%>
	
	
<%@include file="/Resources/CodeParts/Main04.jsp"%>


<script type="text/javascript"> 
	
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sItemDescribe = getCurTVItem().value;
		if(typeof(sItemDescribe) != "undefined" && sItemDescribe != "" && sItemDescribe != "null"){
			AsControl.OpenView(sItemDescribe.split("@")[0],sItemDescribe.split("@")[2],"right");
			setTitle(getCurTVItem().name);
		}
	}
	
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
</script> 

<script type="text/javascript">    
	startMenu();
	expandNode('root');
	selectItem('0010');
	expandNode('0020');
</script>


<%@ include file="/IncludeEnd.jsp"%>