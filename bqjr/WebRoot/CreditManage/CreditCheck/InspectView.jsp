<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cchang 2004-12-6
		Tester:
		Content: �����鱨��
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����鱨��"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�����鱨��&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sObjectNo   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));

	String sCustomerID = sObjectNo;


	//���ҳ�����	
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/%>
	<%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�����鱨��","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'InspectView' and IsInUse = '1' ";
	
	tviTemp.initWithSql("SortNo","ItemName","ItemNo","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	
%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/View06.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>
	<script type="text/javascript"> 
	
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick()
	{
		if (getCurTVItem().id == "010030") {
			OpenComp("MemorabiliaList","/CustomerManage/EntManage/MemorabiliaList.jsp","CustomerID=<%=sCustomerID%>","right");
		}
		else if (getCurTVItem().id == "010040") {
			OpenComp("AutoRiskSignalInfo","/CreditManage/CreditPutOut/AutoRiskSignalInfo.jsp","CustomerID=<%=sCustomerID%>","right");
		}
		//�����鱨��ժҪ
		else if (getCurTVItem().id == "020") {			
			OpenPage("/CreditManage/CreditCheck/PrintInspectResume.jsp?SerialNo=<%=sSerialNo%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","right","");
		}
		//�����鱨������
		else if (getCurTVItem().id == "030") {			
			OpenPage("/CreditManage/CreditCheck/InspectFrame.jsp?SerialNo=<%=sSerialNo%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","right","");
		}
		//�����鱨����˱�
		else if (getCurTVItem().id == "040") {
			OpenPage("/CreditManage/CreditCheck/PrintInspectSheet.jsp?SerialNo=<%=sSerialNo%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","right","");
		}
		else if (getCurTVItem().id == "050") {
			OpenComp("SumInspectInfo","/CreditManage/CreditCheck/SumInspectInfo.jsp","SerialNo=<%=sSerialNo%>","right");
		}
		setTitle(getCurTVItem().name);
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
	<script type="text/javascript">
	startMenu();
	expandNode('root');		
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
