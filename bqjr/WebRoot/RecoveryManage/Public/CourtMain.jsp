<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   ndeng 2004.12.24
		Tester:	  
		Content: ����������Ա��Ϣ����������
		Input Param:
			                
		Output param:
		                
		History Log: 
		                 
	 */

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����������Ա��Ϣ����������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;����������Ա��Ϣ����������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
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
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�������ؼ������˹����б�","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'CourtList' and IsInUse = '1'";
	
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
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
	//��TreeView��code_library�����Ի�ȡ�¼�codeno = CaseList
	
	function TreeViewOnClick()
	{
		
		var sItemID = getCurTVItem().id;
		
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		
		sCurItemDescribe1=sCurItemDescribe[0];
		sCurItemDescribe2=sCurItemDescribe[1];
		
		if(sItemID!="root")
		{
			if(sCurItemDescribe1 != "null")
			{
				OpenComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&ItemID="+sItemID,"right");
				setTitle(sCurItemName);
			}
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
</script>

<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>