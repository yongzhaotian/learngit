<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<% 
	/*
		Author: jbye  2004-12-16 20:15
		Tester:
		Describe: --��ʾ�ͻ���ص��ֽ���Ԥ��
		Input Param:
			CustomerID�� --��ǰ�ͻ����
		Output Param:
			CustomerID�� --��ǰ�ͻ����
		HistoryLog:
		DATE	CHANGER		CONTENT
		2005-7-22 fbkang    �µİ汾�ĸ�д
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ֽ���Ԥ����Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
     String sCustomerID = "";
     String sFinanceBelong = "";
	//����������
	sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	//���ҳ�����
%>
<%/*~END~*/%>


<%
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CashFlowList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��

	String sButtons[][] = {
			{"true","All","Button","����Ԥ��","�����ֽ���Ԥ���¼","addRecord()",sResourcesPath},
			{"true","All","Button","ɾ��Ԥ��","ɾ���ֽ���Ԥ���¼","delRecord()",sResourcesPath},
			{"true","","Button","�鿴Ԥ��","�鿴�ֽ���Ԥ���¼","viewRecord()",sResourcesPath},
		   };
	%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	var sMDStyle = "dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no";
	function addRecord(){
		var vReturn = PopPage("/CustomerManage/FinanceAnalyse/CashFlowAddTerm.jsp?CustomerID=<%=sCustomerID%>","","dialogWidth=20;dialogHeight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(vReturn == "_none_" || typeof(vReturn) == "undefined")
			return;
			   
		OpenPage("/CustomerManage/FinanceAnalyse/CashFlowAddAction.jsp?CustomerID=<%=sCustomerID%>&"+vReturn+"","_self","");
	}

	function delRecord(){
		sUserID=getItemValue(0,getRow(),"UserID");
		var vBaseYear = getItemValue(0,getRow(),"BaseYear");
		var vYearCount = getItemValue(0,getRow(),"FCN");
		var vReportScope = getItemValue(0,getRow(),"ReportScope");

		if(vBaseYear == "" || typeof(vBaseYear) == "undefined"){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else if(sUserID=='<%=CurUser.getUserID()%>'){
    		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
    		{
				var sReturn=PopPageAjax("/CustomerManage/FinanceAnalyse/CashFlowDelActionAjax.jsp?ReportScope="+vReportScope+"&CustomerID=<%=sCustomerID%>&BaseYear="+vBaseYear+"&YearCount="+vYearCount+"&rand="+randomNumber(),"_self","");
				if(typeof(sReturn)!="undefined" && sReturn=="succeed"){
					alert(getBusinessMessage('187'));//�ֽ���Ԥ���¼ɾ����ϣ�
					reloadSelf();
				}else{
					alert("�ֽ���Ԥ���¼ɾ��ʧ�ܣ�");
				}
				
            }
    	}else 
    		alert(getHtmlMessage('3'));
	}

	function viewRecord(){
		var vBaseYear = getItemValue(0,getRow(),"BaseYear");
		var vYearCount = getItemValue(0,getRow(),"FCN");
		var vReportScope = getItemValue(0,getRow(),"ReportScope");
		if(vBaseYear == "" || typeof(vBaseYear) == "undefined"){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		OpenPage("/CustomerManage/FinanceAnalyse/CashFlowDetail.jsp?ReportScope="+vReportScope+"&CustomerID=<%=sCustomerID%>&BaseYear="+vBaseYear+"&YearCount="+vYearCount+"&rand="+randomNumber(),"_self");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
