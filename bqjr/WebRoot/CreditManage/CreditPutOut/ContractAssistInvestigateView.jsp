<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Э������"; //-- ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ϸ��Ϣ&nbsp;&nbsp;"; //--Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//--Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//--Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	String sSql = "";	//--���sql���
	String sTreeViewTemplet = "";//--�����ͼ��CodeNo
	ASResultSet rs = null;//--��Ž����
	//����������	,�ͻ�����
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//���ҳ�����	
    if (sObjectNo == null) sObjectNo="";
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
<%
//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"Э����Ϣ","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	tviTemp.insertPage("root","Э����Ϣ","",1);
	%>
	<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>
<script type="text/javascript"> 

	function TreeViewOnClick(){
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		//var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=='Э����Ϣ'){
			AsControl.OpenView("/CreditManage/CreditPutOut/AssitInvestigateInfo.jsp","ObjectNo=<%=sObjectNo%>","right");
		}else{
			return;
		}
		setTitle(getCurTVItem().name);
	}
	
	<%/*~[Describe=����treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItem(1);
		selectItemByName("���е�ʾ����Ϣ");	//Ĭ�ϴ򿪵�(Ҷ��)ѡ��	
	}
	
	initTreeView();
</script>
	<%@ include file="/IncludeEnd.jsp"%>
	