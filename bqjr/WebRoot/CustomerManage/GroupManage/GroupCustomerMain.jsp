<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
	Author:   
	Tester:	  
	Content: ���ſͻ�������
	Input Param:
	Output param:
	History Log: 
 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ſͻ�����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;���ſͻ�����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));	
	if(sCustomerType == null) sCustomerType = "";
	String sParm = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Parm"));	
	if(sParm == null) sParm = "";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/%>
	<%
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>
	<script type="text/javascript"> 
		
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
	<script type="text/javascript">
	//���Ϊ���ſͻ������Զ���List,����������ͼ����
	   var sCustomerType = "<%=sCustomerType%>";
	   var sParm="<%=sParm%>";

		if(sParm=="GroupCustomerView"){
			myleft.width=1;
			OpenComp("GroupCustomerList","/CustomerManage/GroupManage/GroupCustomerView.jsp","CustomerType="+sCustomerType,"right");//���ż��ײ�ѯ
		}else{
			myleft.width=1;
			OpenComp("GroupCustomerList","/CustomerManage/GroupManage/GroupCustomerList.jsp","CustomerType="+sCustomerType,"right");//���ż���ά��
		}
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
	