<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   ccxie 2010/04/06
		Tester:
		Content: ҵ�񲹵�������
		Input Param:
			 	SerialNo��ҵ��������ˮ��
		Output param:
			      
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ҵ�񲹵�"; // ��������ڱ��� <title> PG_TITLE </title>
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
	String sApplyType="";
	String sTable="";
	
	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%
	
	//����sObjectType�Ĳ�ͬ���õ���ͬ�Ĺ���������ģ����
	String sSql="select ObjectTable from OBJECTTYPE_CATALOG where ObjectType=:ObjectType";
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType",sObjectType));
	if(rs.next()){ 
		sTable=DataConvert.toString(rs.getString("ObjectTable"));
	}
	rs.getStatement().close(); 
	
	sSql="select CustomerID,OccurType,ApplyType,BusinessType from "+sTable+" where SerialNo=:SerialNo";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(rs.next()){
		sCustomerID=DataConvert.toString(rs.getString("CustomerID"));
		sOccurType=DataConvert.toString(rs.getString("OccurType"));
		sApplyType=DataConvert.toString(rs.getString("ApplyType")); 
		sBusinessType=DataConvert.toString(rs.getString("BusinessType"));
	}
	rs.getStatement().close(); 

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ҵ������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'InputCreditView' and IsInUse = '1' ";

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
		
		sObjectType="<%=sObjectType%>";
		sObjectNo="<%=sObjectNo%>";
		sCustomerID="<%=sCustomerID%>";
		sOccurType="<%=sOccurType%>";
		
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";
		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		sParaStringTmp=sParaStringTmp.replace("#ObjectType",sObjectType);
		sParaStringTmp=sParaStringTmp.replace("#ObjectNo",sObjectNo);
		sParaStringTmp=sParaStringTmp.replace("#CustomerID",sCustomerID);
		sParaStringTmp=sParaStringTmp.replace("#OccurType",sOccurType);
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
		
	}

	function TreeViewOnClick(){
		var AccountType="";
		var sSerialNo = getCurTVItem().id;
		if (sSerialNo == "root")	return;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe0=sCurItemDescribe[0];
		if(!sCurItemDescribe0 || sCurItemDescribe0 == "null") return;
		sCurItemDescribe1=sCurItemDescribe[1];
		sCurItemDescribe2=sCurItemDescribe[2];
		
		openChildComp(sCurItemDescribe1,sCurItemDescribe0,"ComponentName="+sCurItemName+"&AccountType=ALL&"+sCurItemDescribe2);
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
	expandNode('01');
	expandNode('040');
	expandNode('041');	
	selectItem('010');
	setTitle("������Ϣ");
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>