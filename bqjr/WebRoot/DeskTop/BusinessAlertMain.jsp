<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   jytian  2004/12/28
		Tester:
		Content: ҵ����Ϣ����
		Input Param:
			                
		Output param:
			              
		History Log: 
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ҵ����Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ϸ��Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	
	
	//���ҳ�����	

	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%
	

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ҵ����Ϣ����","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//���ɱ���������Sql���
	String sSql = "select SortNo,ItemName,ItemNo from CODE_LIBRARY where CodeNo= 'BusinessAlert' Order By SortNo";
	ASResultSet rs=Sqlca.getASResultSet(sSql);
	String sSortNo="";
	String sItemName="";
	String sItemNo="";
	while(rs.next())
	{
		sSortNo = rs.getString("SortNo");
		sItemName = rs.getString("ItemName");
		sItemNo = rs.getString("ItemNo");
		sSql = "select count(*) from WORK_REMIND  where RemindType=:RemindType and InputUserID=:InputUserID";
		ASResultSet rs1=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("RemindType",sSortNo).setParameter("InputUserID",CurUser.getUserID()));
		rs1.next();
		sItemName += "("+rs1.getInt(1)+")��"; 
		rs1.getStatement().close();
		tviTemp.insertPage(sSortNo,"root",sItemName,sItemNo,"",0);
	}
	rs.getStatement().close();
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;]~*/%>
	<script type="text/javascript"> 
	//treeview����ѡ���¼�
	function TreeViewOnClick()
	{
		var sCurItemNo = getCurTVItem().value;
		
		if(sCurItemNo != "root")
		{
			OpenComp("BusinessAlertList","/DeskTop/BusinessAlertList.jsp","RemindType="+sCurItemNo,"right");
			setTitle(getCurTVItem().name);
		}
	}

	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View06;Describe=��ҳ��װ��ʱִ��,��ʼ��]~*/%>
	<script type="text/javascript">
		startMenu();
		expandNode('root');
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
