<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  hxli 2005-8-3
		Tester:
		Content: ��ծ�ʲ��ճ�����������PDAMain.jsp
		Input Param:			                
		Output param:		                
		History Log: 		                 
	 */

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ�����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ծ�ʲ�����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
		
	//����������	
	String sObjectType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
		
	//���ҳ�����

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/%>
	<%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��ծ�ʲ�����","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�


	//������ͼ�ṹ
	String sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'PDADailyList' and ItemNo<>'04' and isinuse<>'2' ";
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
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
		sCurItemDescribe1=sCurItemDescribe[0];  //����������ֶ�����@�ָ��ĵ�1����:url
		sCurItemDescribe2=sCurItemDescribe[1];  //����������ֶ�����@�ָ��ĵ�2����:name
		sCurItemDescribe3=sCurItemDescribe[2];  //����������ֶ�����@�ָ��ĵ�3��������������������Ժܶ�:parameter
		sObjectType = "<%=sObjectType%>";
		//����׼�������ʲ�
		if (sCurItemDescribe2=="AppNoDisposalList"){
			OpenComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName=�����õ��ʲ��б�&ObjectType="+sObjectType,"right");
			setTitle(sCurItemName);
		}

		//�ѵ���/�����еĵ�ծ�ʲ��б�ҳ��
		if (sCurItemDescribe2=="AppDisposingList"){
			OpenComp(sCurItemDescribe2,sCurItemDescribe1,
						"ComponentName=�����еĵ�ծ�ʲ��б�&ObjectType="+sObjectType+"&InOut="+sCurItemDescribe3,"right");
			setTitle(sCurItemName);
		}

		//������ϵĵ�ծ�ʲ��б�ҳ��
		if (sCurItemDescribe2=="PDADisposalEndList"){
			OpenComp(sCurItemDescribe2,sCurItemDescribe1,
						"ComponentName=�����ս�ĵ�ծ�ʲ��б�&ObjectType="+sObjectType+"&InOut="+sCurItemDescribe3,"right");
			setTitle(sCurItemName);
		}

		//goback
		if (sCurItemDescribe2=="goBack"){
			OpenPage("/Main.jsp","_self","");
		}
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
</script> 
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>

<script type="text/javascript">    
	startMenu();
	expandNode('root');
	expandNode('02');
	expandNode('03');
</script>

<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
