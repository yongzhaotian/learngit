<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: ndeng 2005-03-25
		Tester:
		Describe: չ��ԭ�ʺ�ѡ��
		Input Param:
			
		Output Param:

		 	

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������ѡ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";

	//����������	
	String sContractSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractSerialNo"));
	
%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
    String sHeaders[][] = { 							
            				{"SerialNo","�ʺ�"},
            				{"RelativeSerialNo1","��ݺ�"},
            				{"CustomerName","�ͻ�����"},
            				{"BusinessSum","���"}
			              }; 
	
	sSql =	"select ba.serialno as SerialNo,ba.RelativeSerialNo1 as RelativeSerialNo1, "+
	        " ba.CustomerName as CustomerName,ba.BusinessSum as BusinessSum"+
	        " from business_duebill bd ,business_account ba "+
            " where bd.serialno=ba.relativeserialno1 "+
            " and bd.relativeserialno2 in (select objectno from contract_relative where objecttype = 'BUSINESSCONTRACT'"+
            " and serialno = '"+sContractSerialNo+"')";
	
	
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
    //doTemp.setHTMLStyle("SerialNo"," style={width:200px}");
    doTemp.setHTMLStyle("CustomerName"," style={width:200px}");
    doTemp.setCheckFormat("BusinessSum","2");
    doTemp.setType("BusinessSum","number"); 
	doTemp.setColumnAttribute("RelativeSerialNo1,CustomerName,BusinessSum","IsFilter","1");
    doTemp.generateFilters(Sqlca);
    doTemp.parseFilterData(request,iPostChange);
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(13);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


%> 
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	String sButtons[][] = {};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>





<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script>
	function doSearch()
	{
		document.forms["form1"].submit();
	}
	function mySelectRow()
	{      
		try{
			sSerialNo = getItemValue(0,getRow(),"SerialNo");
		}catch(e){
			return;
		}
		parent.sObjectInfo = sSerialNo;
	}
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>