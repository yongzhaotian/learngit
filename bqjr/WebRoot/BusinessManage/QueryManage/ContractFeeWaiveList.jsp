<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Describe: ��ͬ���ü�����Ϣҳ��
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬ���ü�����Ϣҳ��"; // ��������ڱ��� <title> PG_TITLE </title>
	//����������
    String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
    String sLoanSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
    if(sLoanSerialNo == null ) sLoanSerialNo = "";
    if(sObjectType == null ) sObjectType = "";

	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
		String sHeaders[][] = { 
								{"FeeType","��������"},
								{"WaiveFromStage","���⿪ʼ�ڴ�"},
								{"WaiveToStage","���⵽���ڴ�"},
								{"Status","״̬"}
								
								}; 

		 String sSql ="SELECT costreductiontype as FeeType,WaiveFromStage as WaiveFromStage,WaiveToStage as WaiveToStage,Status as Status "+
				      "from acct_fee_waive where objectno in (select serialno from acct_fee where objectno='"+sLoanSerialNo+"') ";

	 //����DataObject				
	 ASDataObject doTemp = new ASDataObject(sSql);
	
	 doTemp.setHeader(sHeaders);
	 doTemp.setDDDWCode("FeeType", "AcctFeeType");
	 doTemp.setDDDWCode("Status", "FeeStatus");
	 doTemp.setColumnType("WaiveFromStage,WaiveToStage", "2");
	 doTemp.setHTMLStyle("FeeType","style={width:150px}");
	 doTemp.setHTMLStyle("WaiveFromStage,WaiveToStage","style={width:30px}");
	 
	 ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	 //dwTemp.setPageSize(24);//���÷�ҳ
	 dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	 dwTemp.ReadOnly = "1"; //����Ϊ��д
	 dwTemp.ShowSummary = "1";//���û���
	//����datawindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		

	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
		{"true","","Button","����Excel","����Excel","exportAll()",sResourcesPath}
		};
	
	%> 
<%/*~END~*/%>
	
<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	 /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
