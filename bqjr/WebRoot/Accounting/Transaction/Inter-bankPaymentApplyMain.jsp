<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
	
<%
	String PG_TITLE = "����֧������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;����֧������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"����֧������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�


	//������ͼ�ṹ,ȥ�����ٵĲ����ʲ��ʹ��պ����ٲ�ѯ
	String sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'Inter-bankPaymentApplyMain' and IsInUse = '1' ";
	tviTemp.initWithSql("SortNo","ItemName","ItemNo","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
%>
	
	
<%@include file="/Resources/CodeParts/Main04.jsp"%>


<script type="text/javascript"> 
	
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sTermType = getCurTVItem().value;
		if(sTermType !=null || sTermType!="root"){
			AsControl.OpenView("/Accounting/Transaction/Inter-bankPaymentList.jsp","Flag=0&FlowStatus="+sTermType+"&OrgID="+<%=CurOrg.getOrgID()%>,"right");
		}
			setTitle(getCurTVItem().name);
	}
	
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
</script> 

<script type="text/javascript">    
	startMenu();
	expandNode('root');
	selectItem('010');
</script>


<%@ include file="/IncludeEnd.jsp"%>
