<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Tree00;Describe=ע����;]~*/%>
	<%
	/*
		Author:     ���ѡ��
		Tester:
		Content:    Ȩ�޹�����ͼ
		Input Param:
                  
		Output param:
		                
		History Log: 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Tree01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ȩ�޹�����ͼ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;Ȩ�޹���&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Tree02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	
	//��ȡ�������ObjectNo��ȷ���Ǹ����û��鿴Ȩ�޻��Ǹ��ݽ�ɫ�鿴Ȩ��
    String sPara = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo")); 
	String sViewID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewID"));

    //�ж������������Ƿ��ظ�
    ASResultSet rsRole = SqlcaRepository.getASResultSet("select OrderNo,count(*) from reg_comp_def where OrderNo not like '99%' group by OrderNo having count(*)>1");
	while(rsRole.next())
    {
		throw new Exception("������ظ���"+rsRole.getString("OrderNo"));
	}
	rsRole.getStatement().close();
    
    %>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Tree03;Describe=������ͼ;]~*/%>
	<%
	//����Treeview
    HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"Ӧ������б�","right");
    tviTemp.TriggerClickEvent=true;
    String sSqlTreeView = " from REG_COMP_DEF where OrderNo is not null and OrderNo not like '99%'";
    tviTemp.initWithSql("OrderNo","CompName"," CompID ","","",sSqlTreeView,"Order By OrderNo",Sqlca);

	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Tree04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/Tree04.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Tree05;]~*/%>
	<script type="text/javascript"> 

    //treeview����ѡ���¼�
	function TreeViewOnClick()
	{
		
		top.returnValue = getCurTVItem().value+"@"+getCurTVItem().name+"@"+getCurTVItem().id;
		if(confirm("��ѡ����\n\n���ID: ["+getCurTVItem().id+"]\n�����: ["+getCurTVItem().name+"]\n�����:["+getCurTVItem().value+"]\n\nȷ����?"))
			top.close();
		else top.returnValue="";
			
		
		//setTitle(getCurTVItem().name);
	}
	
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
	
    function closeAndReturn()
    {
        parent.reloadOpener();
        parent.close();
    }
	</script> 
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Tree06;Describe=��ҳ��װ��ʱִ��,��ʼ��]~*/%>
	<script type="text/javascript">
	startMenu();
	expandNode('root');
	expandNode(1);
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
