<%@page import="com.amarsoft.app.als.customer.model.CustomerRelationTreeModel"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Describe: ������ϵ��������;
		Input Param:
			CustomerID����ǰ�ͻ����
	 */
	String PG_TITLE = "������ϵ��������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ϸ��Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "2000";//Ĭ�ϵ�treeview���

	//����������	
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));

	HTMLTreeView tviTemp= new CustomerRelationTreeModel(sCustomerID,"0","4").getRelationTree(sResourcesPath,Sqlca);
%><%@include file="/Resources/CodeParts/View05.jsp"%>
<script type="text/javascript"> 
	//treeview����ѡ���¼�
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		if (sCurItemID == "root")
			return;
		var sCurItemName = getCurTVItem().name;
		if (isNull(sCurItemName) || sCurItemName.indexOf("�ͻ�����ϸ��Ϣ")>0) {
			alert("�ÿͻ�����ϸ��Ϣ,���ڿͻ���Ϣ�б�����Ӹÿͻ�!");
			return;
		}
		var sCustomerID=getCurTVItem().value;
		openObject("Customer",sCustomerID,"002");
	}

	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	function isNull(value){
		if(typeof(value)=="undefined" || value==""){
			return true;
		}
		return false;
	}
	
	startMenu();
	expandNode('root');
</script>
<%@ include file="/IncludeEnd.jsp"%>