<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  --fbkang 2005.7.25
		Tester:
		Content: --��������״��
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������״��"; //-- ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��������״��&nbsp;&nbsp;"; //--Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//--Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//--Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
    String sTreeViewTemplet = "";
	//����������	,�ͻ�����
    String sGroupID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GroupID"));
	String sRightType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));
	
    if(sGroupID == null) sGroupID = "";
    if(sRightType == null) sRightType = "";
	//���ҳ�����	

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%	
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��������״��","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	sTreeViewTemplet = "GroupCustomerCreditView";
	String sSqlTreeView = " from CODE_LIBRARY where CodeNo= '"+sTreeViewTemplet+"' and isinuse = '1' ";
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView," Order By SortNo ",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;]~*/%>
	<script type="text/javascript"> 
	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	//treeview����ѡ���¼�
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;//--�����ͼ�Ľڵ����
		var sCurItemName = getCurTVItem().name;//--�����ͼ�Ľڵ�����
		var sCurItemDescribe = getCurTVItem().value;//--��������¸�ҳ���·������صĲ���
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];//--��������¸�ҳ���·��
		sCurItemDescribe2=sCurItemDescribe[1];//--����¸�ҳ��ĵ�ҳ������
		sCurItemDescribe3=sCurItemDescribe[2];//--����û��
		sCurItemDescribe4=sCurItemDescribe[3];//--����û��
		if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root")
		{
			openChildComp(sCurItemDescribe2,sCurItemDescribe1,"GroupID=<%=sGroupID%>&RightType=<%=sRightType%>");
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
	selectItem('010010');
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
