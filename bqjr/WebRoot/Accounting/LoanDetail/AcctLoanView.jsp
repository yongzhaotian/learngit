<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.app.bizmethod.*"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content: ̨������������
		Input Param:
			 	SerialNo��ҵ��������ˮ��
		Output param:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ҵ������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;������Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	
	//�������
	String sBusinessType = "",sCustomerID = "";
	String sOccurType = "";
	String sApplyType="";//��������
	String sTable="";
	
	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ҵ������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
	
	String sSqlTreeView = "";
	//������ͼ�ṹ,���ݽ׶�(RelativeCode)����������(Attribute1)��ҵ��Ʒ��(Attribute2)���ų���ҵ��Ʒ��(Attribute3)���ɲ�ͬ����ͼ
	sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'AcctLoanView' and isinuse = '1' ";
	
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
		setDialogTitle("&nbsp;<b>��ͬ��Ӧ���ʻ���Ϣ-����-ֻ��-��Ȩ��</b>");
    </script>
	
	<script type="text/javascript"> 

      function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		
		sObjectType="<%=BUSINESSOBJECT_CONSTATNTS.loan%>";
		sObjectNo="<%=sObjectNo%>";
		
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";
		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		sParaStringTmp=sParaStringTmp.replace("#ObjectType",sObjectType);
		sParaStringTmp=sParaStringTmp.replace("#ObjectNo",sObjectNo);
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
		
	}
	
	//treeview����ѡ���¼�
	function TreeViewOnClick(){
		var AccountType="";
		var sSerialNo = getCurTVItem().id;
		if (sSerialNo == "root")	return;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe0=sCurItemDescribe[0];
		sCurItemDescribe1=sCurItemDescribe[1];
		sCurItemDescribe2=sCurItemDescribe[2];
		
		openChildComp(sCurItemDescribe1,sCurItemDescribe0,"ComponentName="+sCurItemName+"&"+sCurItemDescribe2);
		setTitle(getCurTVItem().name);
		
	}
	
	function startMenu() {
		<%=tviTemp.generateHTMLTreeView()%>
	}
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View06;Describe=��ҳ��װ��ʱִ��,��ʼ��]~*/%>
	<script type="text/javascript">
	myleft.width=170;
	startMenu();
	expandNode('root');
	selectItem('010');
	setTitle("������Ϣ");
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>