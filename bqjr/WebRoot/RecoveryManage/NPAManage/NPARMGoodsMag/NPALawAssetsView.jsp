<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   slliu 2004.12.06
		Tester:
		Content: ����ʲ�����
		Input Param:
				SerialNo������ʲ���ˮ��
		Output param:
		            
		History Log: 
		              
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ʲ�����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;����ʲ�������Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������(����ʲ���ˮ�š�����ʲ�����)	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType",3));
	if(sFinishType == null) sFinishType = "";
	
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/%>
	<%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"����ʲ������б�","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'NPALawsuitList' ";
	
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;Describe=��ͼ�¼�;]~*/%>
<script type="text/javascript"> 

	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	//��TreeView��code_library�����Ի�ȡ�¼�codeno = CaseInfoList
	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];
		sCurItemDescribe2=sCurItemDescribe[1];
		sSerialNo = "<%=sSerialNo%>";
		
		if(sCurItemID=="010")
		{
			var sObjectType="LawCase_Info";
		}
		if(sCurItemID=="060")
		{
			var sObjectType="Asset_Info";
		}
		if(sCurItemID=="030")
		{
			var sObjectType="AssetInfo";
		}
		if(sCurItemID!="root")
		{	
			if(sCurItemDescribe2 == "Back")
			{
				self.close();
				opener.location.reload();
			}
			else if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root")
			{
				openChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&FinishType=<%=sFinishType%>&SerialNo="+sSerialNo+"&ObjectNo="+sSerialNo+"&ObjectType="+sObjectType+"&ItemID="+sCurItemID+"",OpenStyle);
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

<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
<script type="text/javascript">
	startMenu();
	expandNode('root');		
</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
