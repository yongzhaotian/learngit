<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	String PG_TITLE = "�������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//���ҳ�����,��Ʒ���
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("serialNo"));
	String sBusinessType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("businessType"));
	String sQuotaID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("quotaID"));
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("customerID"));
	if(sCustomerID == null) sCustomerID = "";
	if(sSerialNo == null) sSerialNo = "";
	if(sBusinessType == null) sBusinessType = "";
	if(sQuotaID == null) sQuotaID = "";

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	tviTemp.insertPage("root", "���ʳ�����Ϣ", "", 1);
	tviTemp.insertPage("root", "�����Ϣ", "", 2);
	
	%>

<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>


<script type="text/javascript"> 
	
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick(){
		var sSerialNo="<%=sSerialNo %>";
		var sCurItemID = getCurTVItem().id;
		if(sCurItemID=="1"){	
			AsControl.OpenView("/DistributorInfo/DistributorLoadDetailCarList.jsp","serialNo="+sSerialNo,"right");
		}else if(sCurItemID=="2"){
			AsControl.OpenView("/DistributorInfo/DistributorLoadDetailInfo.jsp","serialNo=<%=sSerialNo %>&businessType=<%=sBusinessType %>&quotaID=<%=sQuotaID %>&customerID=<%=sCustomerID %>","right");
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
