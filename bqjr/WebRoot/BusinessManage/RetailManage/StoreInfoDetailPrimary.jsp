<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��:ʾ��ģ����ҳ��--
	 */
	String PG_TITLE = "�ŵ�׼������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�ŵ�׼������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview����
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sRegCode =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RegCode"));
	if (sSerialNo == null) sSerialNo = "";
	if (sRegCode == null) sRegCode = "";
	//���ҳ�����

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�ŵ�׼������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

	//������ͼ�ṹ
	String [] ssSerialNo=sSerialNo.split(",");
	
	if((ssSerialNo.length)==1){
		tviTemp.insertPage("root","������Ϣ","",1);
		tviTemp.insertPage("root","������Ϣ","",2);
	}else{
	tviTemp.insertPage("root","������Ϣ","",1);
	tviTemp.insertPage("root","������Ϣ","",2);
	}
	
	//�������ֶ�����ͼ�ṹ�ķ�����SQL���ɺʹ�������   �μ�View������ ExampleView.jsp��ExampleView01.jsp
%>
<%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	function TreeViewOnClick(){
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		
		if(sCurItemname=='������Ϣ'){
			AsControl.OpenView("/BusinessManage/RetailManage/StoreApplyInfoPrimary.jsp","SerialNo=<%=sSerialNo%>","right");
		}else if(sCurItemname=='������Ϣ'){
			AsControl.OpenView("/BusinessManage/RetailManage/ImageViewFrameStore.jsp","SerialNo=<%=sSerialNo%>&RegCode=<%=sRegCode%>","right");
		}else{
			return;
		}
		setTitle(getCurTVItem().name);
	}
	
	<%/*~[Describe=����treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItemByName("������Ϣ");	//Ĭ�ϴ򿪵�(Ҷ��)ѡ��	
	}
	
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>