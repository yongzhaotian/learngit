<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   CYHui 2005-1-25
		Tester:
		Content: P2P��ͬ��ѯ
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "P2P��ͬ��ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;P2P��ͬ��ѯ&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql���
	//����������	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	//����sSql�������ݶ���

	String sTempletNo = "P2PContractQueryList"; //ģ����
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//doTemp.setKeyFilter("SerialNo");
	
	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	
	/*
	String todayTime = StringFunction.getToday() + " 16:00";
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
	Date yesterday = new Date(sdf.parse(todayTime).getTime() - 86400000L);
	String yesterdayTime = sdf.format(yesterday);*/
	
	//P2P��ͬ �ų� ��ͬ״̬Ϊ���·���������У�����ͨ��������δע�ᣬ��ȡ�����ѷ��
	doTemp.WhereClause += " and BC.ContractStatus not in ('060','070','080','090','100','010')";
	
	//Ĭ�ϵ���ǩ������Ϊ����16:00������16:00��p2p��ͬ
	//String sDefaultCondition = " and BC.SHIFTDOCDESCRIBE between '"+yesterdayTime+"' and '"+ todayTime + "'";
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause += " and BCO.P2P_EXPORT_TIME is null ";
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			{"true","","Button","����","����Excel","ExportExcel()",sResourcesPath},
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------------
	
	function ExportExcel(){
		
		//RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "dataImportStoreInfo", 
		
		//RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "beforeExport","")
				
		RunJavaMethodSqlca("com.amarsoft.proj.action.P2PCredit", "updateP2pExportTime","");
		
		amarExport("myiframe0"); //����Excel 
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


<%@ include file="/IncludeEnd.jsp"%>