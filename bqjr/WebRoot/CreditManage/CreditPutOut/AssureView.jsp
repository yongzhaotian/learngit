<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   ��ҵ�  2005-08-09
		Tester:
		Content: ������Ϣ����
		Input Param:
			      SerialNo��ҵ��������ˮ��
		Output param:
			      
		History Log: 
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;������ͬ��Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	
	//�轫��������AfterLoan��ReinforceContractת��ΪBusinessContract
	if(sObjectType.equals("AfterLoan") || sObjectType.equals("ReinforceContract")) 
		sObjectType = "BusinessContract";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"������Ϣ����","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ,���ݽ׶�(RelativeCode)����������(Attribute1)��ҵ��Ʒ��(Attribute2)���ų���ҵ��Ʒ��(Attribute3)���ɲ�ͬ����ͼ
	String sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'CreditView' "+
						  " and (RelativeCode like '%"+sObjectType+"%' "+
						  " or RelativeCode='All') "+
						  " and ItemNo like '04%' "+
						  " and IsInUse = '1' " ;
	
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

	function openChildComp(sCompID,sURL,sParameterString)
	{
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
		var AccountType="";
		var sSerialNo = getCurTVItem().id;
		if (sSerialNo == "root") return;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];
		sCurItemDescribe2=sCurItemDescribe[1];
		sCurItemDescribe4=sCurItemDescribe[3];
		
		if(sCurItemDescribe2 == "GuarantyList")
		{
			openChildComp("GuarantyList","/CreditManage/GuarantyManage/GuarantyList.jsp","ObjectType=<%=sObjectType%>&WhereType=Business_Guaranty&ObjectNo=<%=sObjectNo%>");
		    setTitle(getCurTVItem().name);
		}
		else if(sCurItemDescribe1 != "null")
		{
			openChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&AccountType=ALL&ContractType="+sCurItemDescribe4);
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
	expandNode('040');
	expandNode('041');
	selectItem('041050');
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>