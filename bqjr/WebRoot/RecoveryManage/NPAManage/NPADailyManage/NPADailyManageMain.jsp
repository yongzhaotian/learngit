<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
<%
/*
	Author:   hxli 2005-8-2
	Tester:	  
	Content: �����ʲ��ճ�����
	Input Param:
	Output param:
	History Log: zywei 2005/09/03 �ؼ����
 */
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
<%
	String PG_TITLE = "�����ʲ�����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�����ʲ�����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
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
	HTMLTreeView tviTemp = new HTMLTreeView(Sqlca,CurComp,sServletURL,"�����ʲ�����","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView = " from CODE_LIBRARY where CodeNo = 'NPADaily' and ItemNo not like '005%' and IsInUse = '1' ";

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
	function TreeViewOnClick()
	{
		
		var sItemMenuNo = getCurTVItem().id;      //CodeLibrary ��describe��Ϊ�˵����
		
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		var sCurItemDescribe = sCurItemDescribe.split("@");
		var sCurItemDescribe1=sCurItemDescribe[0];
		var sCurItemDescribe2=sCurItemDescribe[1];
			
		if(sItemMenuNo!="root" && sItemMenuNo!="0" && sItemMenuNo!="005" && sItemMenuNo!="010" && sItemMenuNo!="020" && sItemMenuNo!="1" && sItemMenuNo!="110" && sItemMenuNo!="120")
		{
			if(sItemMenuNo != "null" )   //�˵�����������Ŀ¼
			{
				OpenComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName=sCurItemName&ItemMenuNo="+sItemMenuNo,"right",OpenStyle);
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
	expandNode('0');
	expandNode('010');
	expandNode('040');
	expandNode('005');
	expandNode('030');
	expandNode('045');
	selectItem('01010');	 
</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>