<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	String PG_TITLE = "��Ʒϵ������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��Ʒϵ������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//���ҳ�����,��Ʒ���
	String sProductID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("productID"));
	if(sProductID == null) sProductID = "";
	//��Ʒ����
    String sProductType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProductType"));
    if(null == sProductType) sProductType = "";
	//��Ʒ������
    String sSubProductType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SubProductType"));
    if(null == sSubProductType) sSubProductType = "";

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��Ʒϵ������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	tviTemp.insertPage("root", "������Ϣ", "", 1);
	tviTemp.insertPage("root", "��Ʒ����", "", 2);
	tviTemp.insertPage("root", "�ĵ���Ϣ", "", 3);
	
	%>

<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>

<script type="text/javascript"> 
	
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick(){
		var sProductID="<%=sProductID%>";
		var sCurItemName = getCurTVItem().name;
		if(sCurItemName=="������Ϣ"){	
			AsControl.OpenView("/BusinessManage/Products/ProductTypesDetailsInfo.jsp","productID="+sProductID+"&SubProductType=<%=sSubProductType%>","right");
		}else if(sCurItemName=="��Ʒ����"){
			AsControl.OpenView("/BusinessManage/Products/ProductTypesDetailsInfo1.jsp","productID="+sProductID+"&ProductType=<%=sProductType%>","right");//update �ֽ������
		}else if(sCurItemName=="�ĵ���Ϣ"){
			AsControl.OpenView("/AppConfig/Document/ProductTypeAttachmentList.jsp","DocNo="+sProductID+"&UserID=<%=CurUser.getUserID()%>","right");
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
