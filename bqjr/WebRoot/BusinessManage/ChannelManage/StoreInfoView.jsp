<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  --fbkang 2005.7.25
		Tester:
		Content: --�ͻ���ͼ������
		Input Param:
			  ObjectNo  ��--�ͻ���
		Output param:
			               
		History Log: 
		
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ŵ�׼������"; //-- ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ϸ��Ϣ&nbsp;&nbsp;"; //--Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//--Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//--Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	String sSql = "";	//--���sql���
	String sItemAttribute = "",sItemDescribe = "",sAttribute3 = "";//--�ͻ�����	
	String sCustomerType = "";//--�ͻ�����	
	String sTreeViewTemplet = "";//--���custmerviewҳ����ͼ��CodeNo
	ASResultSet rs = null;//--��Ž����
	int iCount = 0;//��¼��
	String sBelongGroupID = "";//�������ſͻ�ID
	//����������	,�ͻ�����
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//���ҳ�����	

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%	
	//����û�û���������Ȩ�ޣ��������Ӧ����ʾ
	if( false){
%>
		<script type="text/javascript">
			//�û����߱���ǰ�ͻ��鿴Ȩ
			alert( getHtmlMessage("15"));				
		    self.close();			        
		</script>
<%
	}
	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	if(sObjectNo == null) sObjectNo="";
	if(sObjectType == null) sObjectType="";		// RetailApplyInfo
	
	sTreeViewTemplet = "StoreApplyView";
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�ͻ���Ϣ����","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= '"+sTreeViewTemplet+"' and isinuse = '1' ";
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
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
		var sCurItemName = getCurTVItem().name;//--�����ͼ�Ľڵ�����
		var sCurItemDescribe = getCurTVItem().value;//--��������¸�ҳ���·������صĲ���

		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];//--��������¸�ҳ���·��
		sCurItemDescribe2=sCurItemDescribe[1];//--����¸�ҳ��ĵ�ҳ������
		sCurItemDescribe3=sCurItemDescribe[2];//--����û��
		sCurItemDescribe4=sCurItemDescribe[3];//--����û��
		
		if(sCurItemDescribe2 == "Back")
		{
			top.close();
		}
		else if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root" && sCurItemDescribe1 != "")  //modified by yzheng 2013-7-3 ���ڵ㲻��Ӧ�¼�����IE
		{
			openChildComp(sCurItemDescribe2,sCurItemDescribe1,"ModelType="+sCurItemDescribe4+"&ComponentName="+sCurItemName+"&NoteType="+sCurItemDescribe3);
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
	var sCustomerType = "<%=sCustomerType%>";

	//����ͻ�����Ϊ���ſͻ������Զ����"010"��Ŀ��������Ǽ��ſͻ������Զ�չ��"010"�ڵ� add by cbsu 2009-10-21
	var sGroupType = sCustomerType.substring(0,2);
	if (sGroupType != '02') {
		expandNode('010');
	} else {
	    selectItem('010');
	}
	
	if(sCustomerType != '0120')
	{
		selectItem('010010');//�Զ������ͼ��Ŀǰд����Ҳ�������õ� code_library�н����趨
	}else 
	{
		selectItem('010005');//��С��ҵ�� �Զ������ͼ��Ŀǰд����Ҳ�������õ� code_library�н����趨
	}
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
