<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: --�ͻ����񱨱����
		Input Param:
			  CustomerID��--��ǰ�ͻ����
		Output Param:
			  CustomerID��--��ǰ�ͻ����
			
		HistoryLog:
		--fbkang 2005.7.21,ҳ��������޸�
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����
	
	//�������������ͻ�����
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));

%>
<%/*~END~*/%>


<%
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CustomerFAList";//ģ�ͱ��
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
			{"true","","Button","�Ű����","�Ű����","dupondInfo()",sResourcesPath},
			{"true","","Button","�ṹ����","�ṹ����","structureInfo()",sResourcesPath},
			{"true","","Button","ָ�����","ָ�����","itemInfo()",sResourcesPath},
			{"true","","Button","���Ʒ���","���Ʒ���","trendInfo()",sResourcesPath}
	  };
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�Ű����;InputParam=�ͻ�����;OutPutParam=��;]~*/
	function dupondInfo()
	{   
		var sReportDate=getItemValue(0,getRow(),"ReportDate");

		if(typeof(sReportDate)=="undefined" || sReportDate.length==0){
		//����ֵ�����������
			alert("��ѡ��Ҫ�����ı���");
		}else{
			//sMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=16;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;scrollbar:yes");
			//if(typeof(sMonth)=="undefined" || sMonth=="_none_" || sReturnValue == null)	 return;
			PopComp("DBAnalyse","/CustomerManage/FinanceAnalyse/DBAnalyse.jsp","CustomerID=<%=sCustomerID%>&AccountMonth="+sReportDate);
		}
	}
	
	/*~[Describe=�ṹ����;InputParam=�ͻ�����;OutPutParam=��;]~*/
	function structureInfo(){
	    //����ֵ���������������������¡�����Χ
		sReturnValue = PopPage("/CustomerManage/FinanceAnalyse/AnalyseTerm.jsp?CustomerID=<%=sCustomerID%>","","dialogWidth=40;dialogHeight=30;minimize:no;maximize:no;status:yes;center:yes");
	    if(typeof(sReturnValue)=="undefined" || sReturnValue=="_none_"  || sReturnValue == null)	return;
		PopComp("StructureMain","/CustomerManage/FinanceAnalyse/StructureView.jsp","CustomerID=<%=sCustomerID%>&Term=" + sReturnValue);
	}

	/*~[Describe=ָ�����;InputParam=�ͻ�����;OutPutParam=��;]~*/
	function itemInfo(){
	    //����ֵ���������������������¡�����Χ
		sReturnValue = PopPage("/CustomerManage/FinanceAnalyse/AnalyseTerm.jsp?CustomerID=<%=sCustomerID%>","","dialogWidth=40;dialogHeight=30;minimize:no;maximize:no;status:yes;center:yes");
	    if(typeof(sReturnValue)=="undefined" || sReturnValue=="_none_" || sReturnValue == null) return;
		PopComp("ItemDetail","/CustomerManage/FinanceAnalyse/ItemView.jsp","CustomerID=<%=sCustomerID%>&Term="+sReturnValue);
	}

	/*~[Describe=���Ʒ���;InputParam=�ͻ�����;OutPutParam=��;]~*/
	function trendInfo(){
	    //����ֵ���������������������¡�����Χ
		sReturnValue = PopPage("/CustomerManage/FinanceAnalyse/AnalyseTerm_Trend.jsp?CustomerID=<%=sCustomerID%>","","dialogWidth=40;dialogHeight=30;minimize:no;maximize:no;status:yes;center:yes");
		if(typeof(sReturnValue)=="undefined" || sReturnValue=="_none_" || sReturnValue == null) return;
		PopComp("TrendMain","/CustomerManage/FinanceAnalyse/TrendView.jsp","CustomerID=<%=sCustomerID%>&Term="+sReturnValue);
	}
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
