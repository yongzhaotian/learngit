<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	String PG_TITLE = "��Ʒ������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��Ʒ������Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//���ҳ�����,��Ʒ���
	String sTypeNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("typeNo"));
	if(sTypeNo == null) sTypeNo = "";
	//��Ʒ����
	String sProductType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProductType"));
	if(null == sProductType) sProductType = "";

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��Ʒ������Ϣ","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	tviTemp.insertPage("root", "��Ʒ������Ϣ", "", 1);
	tviTemp.insertPage("root", "��������", "", 2);
	tviTemp.insertPage("root", "���ü�������", "", 3);
	
	%>

<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>


<script type="text/javascript"> 
	
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick(){
		var sTypeNo="<%=sTypeNo%>";
		var sCurItemID = getCurTVItem().id;
		if(sCurItemID=="1"){	
			AsControl.OpenView("/BusinessManage/BusinessType/BusinessTypeDetailsInfo.jsp","typeNo="+sTypeNo+"&ProductType=<%=sProductType%>","right");//update �ֽ������
		}else if(sCurItemID=="2"){
			//AsControl.OpenView("/BusinessManage/BusinessType/BusinessTypeCostList.jsp","typeNo="+sTypeNo,"right");
			AsControl.OpenView("/BusinessManage/Products/FeeLibraryList.jsp","ObjectType=Product&typeNo="+sTypeNo,"right");
		}else if(sCurItemID=="3"){
			AsControl.OpenView("/BusinessManage/BusinessType/BusinessTypeCReductionList.jsp","typeNo="+sTypeNo,"right");
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
