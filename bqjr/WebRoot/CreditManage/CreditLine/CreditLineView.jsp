<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View00;Describe=ע����;]~*/%>
	<%
	/*
		Author:zywei 2005/11/23
		Tester:
		Content:���Ŷ����������
		Input Param:
			ObjectType����������
			ObjectNo��������
		Output param:
		
		History Log: 
			zywei 2007/10/10 ������ʾ��һ�����Ͳ˵���
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ŷ������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;���Ŷ������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	String sSql = "";
	String sCustomerID = "";
	//���ۺ����ű��
	String sCreditLineID = "";
	String sBusinessType="";
	ASResultSet rs=null;
	//�����±�
	String sTable = "";
	int iOrder1 = 1;
	int iOrder2 = 1;
	
	//���ҳ�����		
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%	
	//����sObjectType�Ĳ�ͬ���õ���ͬ�Ĺ���������ģ����
	sSql="select ObjectTable from OBJECTTYPE_CATALOG where ObjectType=:ObjectType";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType",sObjectType));
	if(rs.next()){ 
		sTable=DataConvert.toString(rs.getString("ObjectTable"));
	}
	rs.getStatement().close();
	//���������Ż�ÿͻ�����,ҵ������
	sSql = " select CustomerID,BusinessType from "+sTable+" where SerialNo =:SerialNo ";
	rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(rs.next()){
		sCustomerID=rs.getString("CustomerID");
		sBusinessType=rs.getString("BusinessType");
	}
	rs.getStatement().close();
	//����ֵת��Ϊ���ַ���
	if(sCustomerID == null) sCustomerID = "";
	if(sBusinessType == null) sBusinessType = "";
	//���������Ż���ۺ����Ŷ�ȱ��
	if(sObjectType.equals("CreditApply")){
		sSql = " select LineID from CL_INFO where ApplySerialNo =:ObjectNo and (Parentlineid is null or Parentlineid = ' ') order by LineID";
	}else if(sObjectType.equals("ApproveApply")){
		sSql = " select LineID from CL_INFO where ApproveSerialNo =:ObjectNo and (Parentlineid is null or Parentlineid = ' ') order by LineID";
	}else if(sObjectType.equals("BusinessContract") || sObjectType.equals("AfterLoan")){
		sSql = " select LineID from CL_INFO where BCSerialNo =:ObjectNo and (Parentlineid is null or Parentlineid = ' ') order by LineID";
	}
	sCreditLineID = Sqlca.getString(new SqlObject(sSql).setParameter("ObjectNo",sObjectNo));
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ҵ������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
	
	//������ͼ�ṹ,���ݶ�������(RelativeCode)��ҵ��Ʒ��(Attribute1���ɲ�ͬ����ͼ
	if(sBusinessType.startsWith("3020"))
	{
		String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'CreditLineView' and RelativeCode like '%"+sObjectType+"%' and Attribute1 like '%"+sBusinessType+"%' and IsInUse = '1' and ItemNo<>'080'";
		tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	}else{
		String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'CreditLineView' and RelativeCode like '%"+sObjectType+"%' and Attribute1 like '%"+sBusinessType+"%' and IsInUse = '1' ";
		tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	}
	
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;]~*/%>
	<script type="text/javascript">
	//���Ҳ���ͼ���� 
	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";
		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		sParaStringTmp=sParaStringTmp.replace("#ObjectType","<%=sObjectType%>");
		sParaStringTmp=sParaStringTmp.replace("#ObjectNo","<%=sObjectNo%>");
		sParaStringTmp=sParaStringTmp.replace("#CustomerID","<%=sCustomerID%>");
		sParaStringTmp=sParaStringTmp.replace("#ParentLineID","<%=sCreditLineID%>");
		sParaStringTmp=sParaStringTmp.replace("#ModelType","030");
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
		
	}

	//treeview����ѡ���¼�
	function TreeViewOnClick(){
		var sSerialNo = getCurTVItem().id;
		if (sSerialNo == "root")	return;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe0=sCurItemDescribe[0];
		sCurItemDescribe1=sCurItemDescribe[1];
		sCurItemDescribe2=sCurItemDescribe[2];
		
		if(sCurItemDescribe0 != "null"){
			openChildComp(sCurItemDescribe1,sCurItemDescribe0,"ComponentName="+sCurItemName+"&"+sCurItemDescribe2);
			setTitle(getCurTVItem().name);
		}
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
	expandNode('040');
	selectItem('010');
	setTitle("������Ϣ");
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
