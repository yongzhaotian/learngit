<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xdhou  2005.02.18
		Tester:
		Content: ���鱨��������
		Input Param:
			DocID:    formatdoc_catalog�е��ĵ���𣨵��鱨�棬�����鱨�棬...)
			ObjectNo��ҵ����ˮ��
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���鱨�����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ϸ��Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
<%
	//����������	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sDocID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocID"));

	//�������
	String sSql = "";	
	String sCustomerType = "";
	String sCustomerTemplet = "";
	String sCustomerInfoTemplet = "",sModelType = "";
	
	//����treeview...root
	String sSql1 = "";
	ASResultSet rsData = null;

	//ȡ�øñ�����Ŀͻ�����
	String sRootCaption = "";
	sSql1 = "select CustomerName,getBusinessName(BusinessType),getItemName('OccurType',OccurType) " +
			" from BUSINESS_APPLY where SerialNo='"+sObjectNo+"'";
	rsData = Sqlca.getResultSet(sSql1);
	if(rsData.next())
		sRootCaption = rsData.getString(1)+"|"+rsData.getString(2)+"|"+rsData.getString(3);
	rsData.getStatement().close();	
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"���鱨��("+sRootCaption+")","right");
	tviTemp.ImageDirectory = sResourcesPath; 
	tviTemp.toRegister = false; 
	tviTemp.TriggerClickEvent=true; 

	//������ͼ�ṹ
	String sSqlTreeView = "from FORMATDOC_DATA where ObjectNo='"+sObjectNo+"' and DocID='"+sDocID+"' ";

	tviTemp.initWithSql("SerialNo","DirName","SerialNo","","",sSqlTreeView,"Order By TreeNo",Sqlca);  //TreeNo
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;]~*/%>
	<script type="text/javascript"> 
	
	//treeview����ѡ���¼�
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemValue = getCurTVItem().value;
		var sCurItemType = getCurTVItem().type;
		
		if(sCurItemType=="page"){
			var sReturn = PopPageAjax("/FormatDoc/ChooseJsp.jsp?SerialNo="+sCurItemID+"&ObjectNo=<%=sObjectNo%>","","");
			if(typeof(sReturn)!='undefined' && sReturn!=""){
				OpenPage(sReturn+"SerialNo="+sCurItemID+"&ObjectNo=<%=sObjectNo%>","right");
				setTitle(sCurItemName);
			}
		}else{
			return false;
		}
	}
	
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
	</script> 
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View06;Describe=��ҳ��װ��ʱִ��,��ʼ��]~*/%>
	<script type="text/javascript">
	startMenu();
	expandNode('root');	
	setTitle("���鱨��");
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
