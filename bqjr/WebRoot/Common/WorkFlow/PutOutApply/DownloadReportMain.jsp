<%@page import="java.net.URLDecoder"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  FSGong 2005.01.25
		Tester:
		Content: �������۱�����ϸ
		Input Param:		
		Output param:		                
		History Log: 		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������۱�����ϸ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�������۱�����ϸ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview����
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	

	//���ҳ�����

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/%>
	<%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�������۱�����ϸ","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�


	//������ͼ�ṹ,ȥ�����ٵĲ����ʲ��ʹ��պ����ٲ�ѯ
	//add by clhuang 2015/07/09 CCS-905 PRM-440 �����۴�����ͨ��ͬ������ϸ�����������ͬ��ϸ�������պ�ͬ������ע��ϸ��
	  if(CurUser.hasRole("1006")||CurUser.hasRole("1622")||CurUser.hasRole("1624")||CurUser.hasRole("1626")||CurUser.hasRole("1628")||CurUser.hasRole("1630")||CurUser.hasRole("1620")||CurUser.hasRole("3008")){
		  String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'DownloadReportMain' and itemno in ('01','05','06') and IsInUse = '1' ";
		  tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	   }else{
			String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'DownloadReportMain' and IsInUse = '1' ";
			tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	   }
	//end 
//	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'DownloadReportMain' and IsInUse = '1' ";
	//��ȡ�����ļ�����ApproveNeed���ж��Ƿ���ʾ��ͼ��������������ٲ�ѯ��true-��ʾ��false-����ʾ
//	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>

<script type="text/javascript"> 
	
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];  //����������ֶ�����@�ָ��ĵ�1����
		sCurItemDescribe2=sCurItemDescribe[1];  //����������ֶ�����@�ָ��ĵ�2����
		sCurItemDescribe3=sCurItemDescribe[2];  //����������ֶ�����@�ָ��ĵ�3��������������������Ժܶࡣ
		if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root"){
			OpenComp(sCurItemDescribe2,sCurItemDescribe1,"componentName="+sCurItemName+"&curItemID="+sCurItemID,"right");
			setTitle(getCurTVItem().name);
		}
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
</script> 
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>

<script type="text/javascript">    
	startMenu();
	expandNode('root');
	selectItem('01');
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>