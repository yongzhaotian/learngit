<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: jbye 2004-12-16 20:40
		Tester:
		Describe: �������񱨱�׼����Ϣ ��ҳ��������ڱ�����Ϣ����������
		Input Param:
			--CustomerID����ǰ�ͻ����
			--ModelClass: ģʽ����
		Output Param:
			--CustomerID����ǰ�ͻ����
		HistoryLog:		
			DATE	CHANGER		CONTENT
			2005-8-10	fbkang	ҳ�����	
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����˵��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
    String sCustomerID="";//--�ͻ�����
    String sModelClass = "";//--ģʽ����
    String sSql = "";//--���sql���
    String sPassRight = "true";//--�����ͱ���
	//�������������ͻ����롢ģʽ����
	sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID")); 
	sModelClass = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelClass")); 
	//���ҳ�����	
%>
<%/*~END~*/%>


<%
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "AddFSPre";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//�������в��񱨱�ĳ�ʼ������
	dwTemp.setEvent("AfterInsert","!BusinessManage.InitFinanceReport(CustomerFS,#CustomerID,#ReportDate,#ReportScope,#RecordNo,ModelClass^'"+sModelClass+"',,AddNew,"+CurOrg.getOrgID()+","+CurUser.getUserID()+")");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=���尴ť;]~*/%>
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
		       {"true","","Button","ȷ��","ȷ��","doCreation()",sResourcesPath}
		      };
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info04;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------//
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		//¼��������Ч�Լ��
		sReportDate = getItemValue(0,0,"ReportDate");
		sReportScope = getItemValue(0,0,"ReportScope");
		if(sReportScope == '01')
			sReportScopeName = "�ϲ�";
		else if(sReportScope == '02')
			sReportScopeName = "����";
		else
			sReportScopeName = "����";
		//�����Ҫ���Խ��б���ǰ��Ȩ���ж�
		sPassRight = PopPageAjax("/CustomerManage/EntManage/FinanceCanPassAjax.jsp?ReportDate="+sReportDate+"&ReportScope="+sReportScope,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		if(sPassRight=="pass"){
			var sTableName = "CUSTOMER_FSRECORD";//����
			var sColumnName = "RecordNo";//�ֶ���
			var sPrefix = "CFS";//ǰ׺

			//��ȡ��ˮ��
			var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
			//����ˮ�������Ӧ�ֶ�
			setItemValue(0,0,"RecordNo",sSerialNo);
			as_save("myiframe0",sPostEvents);
		}else{
			alert(sReportDate +"�·ݵ�"+sReportScopeName+"�ھ����񱨱��Ѵ��ڣ�������ѡ��");
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function doCreation(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		top.returnValue= "ok";  // modified by yzheng 2013-06-17
		top.close();  // modified by yzheng  2013-06-17
	}
	/*~[Describe=����ѡ��;InputParam=��;OutPutParam=��;]~*/
	function getMonth(sObject){
		sReturnMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=18;dialogHeight=12;center:yes;status:no;statusbar:no");
		if(typeof(sReturnMonth) != "undefined"){
			setItemValue(0,0,sObject,sReturnMonth);
		}
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){ //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");//������¼
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"ReportStatus","01");
			setItemValue(0,0,"UserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"OrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
