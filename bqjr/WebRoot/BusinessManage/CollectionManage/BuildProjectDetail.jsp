<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	String PG_TITLE = "ת������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;ת������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//���ҳ�����,��Ʒ���
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//��Ŀ���
	String sProtocolNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProtocolNo"));//��Ŀ��������Э����
	if(sSerialNo == null) sSerialNo = "";
	if(sProtocolNo==null) sProtocolNo = "";

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ת������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	tviTemp.insertPage("root", "������Ϣ", "", 1);
	tviTemp.insertPage("root", "ת�ú�ͬ��Ϣ", "", 2);
	
	%>

<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>

<script type="text/javascript"> 
	
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick(){
		var sSerialNo="<%=sSerialNo%>";
		var sCurItemName = getCurTVItem().name;
		if(sCurItemName=="������Ϣ"){	
			AsControl.OpenView("/BusinessManage/CollectionManage/BuildProjectInfo.jsp","SerialNo="+sSerialNo,"right");
		}else if(sCurItemName=="ת�ú�ͬ��Ϣ"){
			AsControl.OpenView("/BusinessManage/CollectionManage/TransferProjectContractList.jsp","ProjectSerialNo="+sSerialNo+"&ProtocolNo=<%=sProtocolNo%>","right");
			//AsControl.OpenView("/BusinessManage/CollectionManage/ProjectContractList.jsp","SerialNo="+sSerialNo,"right");
		}
	
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
</script> 

<script type="text/javascript">    
	startMenu();
	expandNode('root');
	selectItem("1");
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
