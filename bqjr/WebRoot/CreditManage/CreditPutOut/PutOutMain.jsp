<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   --cchang  2004.12.6
		Tester:
		Content: --�����̨ͬ��������
		Input Param:
            --sTreeviewTemplet:ģ������
		Output param:
		History Log: 
	    DATE	CHANGER		CONTENT
	    2005-7-29 fbkang   ��ʽ������
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ҵ��̨��"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;ҵ��̨��&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	��������ơ�ģ������
	String sTreeviewTemplet = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TreeviewTemplet"));
    if(sTreeviewTemplet == null) sTreeviewTemplet = "";
	//���ҳ�����	

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/%>
	<%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ҵ��̨�ʹ���","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
     //move by fbkang 2005-7-30
     //�Ѳ������������ɾ��������ÿ����ڽ⿪
	//������ͼ�ṹ
	String sSqlTreeView = " from CODE_LIBRARY where CodeNo= '"+sTreeviewTemplet+"' and "+	                      
	                      " IsInUse = '1'";

	tviTemp.initWithSql("SortNo","ItemName","ItemNo","","",sSqlTreeView,"Order By SortNo",Sqlca);
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
		var sCurItemName = getCurTVItem().name;//--��õ�ǰ�ڵ�����
		var sCurItemValue = getCurTVItem().value;//--��õ�ǰ�ڵ�Ĵ���ֵ
		
		if((sCurItemValue.length == 6 && sCurItemValue.indexOf("030") < 0) || sCurItemValue.length == 9)
		{
			OpenComp("ContractList","/CreditManage/CreditPutOut/ContractList.jsp","ComponentName="+sCurItemName+"&ContractType="+sCurItemValue,"right");
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
	expandNode('010');		
	expandNode('020');
	selectItem('010010');		
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
