<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   	FSGong  2004.12.05
		Tester:
		Content:  	���չ���(List���,��Ϊģ������,��Main��ʽ����.)
		Input Param:
				���в�����Ϊ�����������
				PropertyType	�ʲ����ͣ������ʲ�/�����ʲ�								
				ObjectType	�������ͣ�BUSINESS_CONTRACT
						��������������Ŀ���Ǳ�����չ��,�������ܲ������û������ʲ��Ĵ��պ�����.
			        
		Output param:
		                ContractID	��ͬ���
		History Log: 
		               
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���չ���"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;���չ���&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	
	String sObjectType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sPropertyType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PropertyType"));	//���ҳ�����	
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
	myleft.width=1;
	OpenComp("DunManageList","/RecoveryManage/DunManage/DunManageList.jsp","","right");		
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
