<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View00;Describe=ע����;]~*/%>
<%
/*
	Author:   XWu  2004.12.02
	Tester:
	Content: �����ʲ�̨�ʹ���
	Input Param:
		ObjectType:��������															
		ObjectNo  :��ͬ���															
	Output param:
		ObjectType:��������															
		ObjectNo  :��ͬ���
		NoteType  :�����ʼ�����	
		WhereType :����Ѻ���������Ϊ020
		AccountType:��AccountWasteBookList�����Ͳ���														
	History Log: 
*/
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
<%
	String PG_TITLE = "�����ʲ�̨�ʹ���"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�����ʲ�̨�ʹ���&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	
	//����������		
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo")); 
	String sViewID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewID"));
	//����ֵת���ɿ��ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sViewID == null) sViewID = ""; 
	//����ս�����
	String sSql = " select FinishType from BUSINESS_CONTRACT where SerialNo =:SerialNo ";	
	String sFinishType = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(sFinishType == null) sFinishType = "";
		
	//���ö�������
	String sObjectType = "BusinessContract"; //��������
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
<%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�����ʲ�̨�ʹ���","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
		
	//������ͼ�ṹ
	String sSqlTreeView="";
	if(sFinishType.equals("0601") || sFinishType.equals("0602"))	//�Ѻ����Ĳ����ʲ�����
		sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'NPABookView' and IsInUse = '1' ";
	else		//�Ǻ����Ĳ����ʲ�����
		sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'NPABookView' and ItemNo <> '065'  and IsInUse = '1' ";

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
	//��TreeView��code_library�����Ի�ȡ�¼�codeno = NPABookView
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
		var sCurItemDescribe = sCurItemDescribe.split("@");
		var sCurItemDescribe1=sCurItemDescribe[0];
		var sCurItemDescribe2=sCurItemDescribe[1];
		var sCurItemDescribe3=sCurItemDescribe[2];
		var sCurItemDescribe4=sCurItemDescribe[3];
				
		if(sCurItemID!="root")
		{
			if(sCurItemDescribe2 == "Back")
			{
				self.close();
			}else if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root")
			{				
				if(sCurItemDescribe4 == "BusinessContract" || sCurItemDescribe4 == "BusinessDueBill")
				{	
					openChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&ObjectType="+sCurItemDescribe4+"&ObjectNo=<%=sObjectNo%>&ViewID=<%=sViewID%>&FinishType=<%=sFinishType%>&Flag=010&NoteType=NPAWorkType&ClassifyType="+sCurItemDescribe3+"&CurItemID="+sCurItemID,OpenStyle);
					setTitle(sCurItemName);
				}else
				{
					openChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ViewID=<%=sViewID%>&FinishType=<%=sFinishType%>&Flag=010&NoteType=NPAWorkType&AccountType="+sCurItemDescribe3+"&CurItemID="+sCurItemID,OpenStyle);
					setTitle(sCurItemName);
				}
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
	expandNode('025');
	expandNode('060');		
	expandNode('070');	
	expandNode('075');
	selectItem('010');	
</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>