<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   slliu 2004.12.06
		Tester:
		Content: ��������
		Input Param:
				SerialNo��������ˮ��
		Output param:
		            
		History Log: zywei 2005/09/06 �ؼ����
		              
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;����������Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	//���������Sql��䡢��������
	String sSql = "";
	String sLawCaseType = "";
	String 	sPigeonholeDate ="";
	//����������(������ˮ��)	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sSerialNo == null) sSerialNo = "";
	String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType",3));
	if(sFinishType == null) sFinishType = "";
	//��ȡ��������
	sSql =  " select LawCaseType from LAWCASE_INFO where SerialNo =:SerialNo ";
   	sLawCaseType = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sSerialNo)); 
//��ȡ�鵵����
	sSql =  " select PigeonholeDate from LAWCASE_INFO where SerialNo =:SerialNo ";
	sPigeonholeDate = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sSerialNo)); 
	if(sPigeonholeDate ==null) sPigeonholeDate="";
   	
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/%>
	<%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"���������б�","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	
	//������ͼ�ṹ
	//���ݲ�ͬ�İ�������LawCaseType�Ĳ�ͬ����ʾ��ͬ�����β˵�
	if(sLawCaseType.equals("01"))	//һ�㰸��
	{
		String sSqlTreeView = " from CODE_LIBRARY where CodeNo = 'CaseInfoList1' and IsInUse = '1' ";
		tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
		//����������������Ϊ��
		//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
		
	}
	if(sLawCaseType.equals("02"))	//����/�ٲð���
	{
		String sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'CaseInfoList2' and IsInUse = '1' ";
		tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
		
	}
	if(sLawCaseType.equals("05"))	//�Ʋ�����
	{
		String sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'CaseInfoList5' and IsInUse = '1' ";
		tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
		
	}
%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;Describe=��ͼ�¼�;]~*/%>
<script type="text/javascript"> 

	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	//��TreeView��code_library�����Ի�ȡ�¼�codeno = CaseInfoList
	function openChildComp(sCompID,sURL,sParameterString)
	{
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
		var sBookType=sCurItemDescribe[2];	//̨������
		sSerialNo = "<%=sSerialNo%>";
		sLawCaseType = "<%=sLawCaseType%>";
		if(sCurItemID!="root")
		{
			if(sCurItemDescribe2 == "Back")
			{
				self.close();
				opener.location.reload();
			}else if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root")
			{  	
				//the below added by Gongfs 2005-03-10
				if(sCurItemDescribe2 == "DocumentList")
				{
					openChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&PigeonholeDate=<%=sPigeonholeDate%>&FinishType=<%=sFinishType%>&ObjectType=LawcaseInfo&ObjectNo="+sSerialNo,OpenStyle);
				}else
				//the above added by Gongfs 2005-03-10
				openChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&PigeonholeDate=<%=sPigeonholeDate%>&FinishType=<%=sFinishType%>&BookType="+sBookType+"&SerialNo="+sSerialNo+"&LawCaseType="+sLawCaseType,OpenStyle);
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
	expandNode('030');
	expandNode('030001');	
	selectItem('010');	
</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
