<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hxli 2005-8-18
		Tester:
		Content: �������ҵ���ͬѡ���б�
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	//String PG_TITLE = "�������ҵ���ͬѡ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	
	String PG_TITLE = "�������ҵ���ͬѡ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	
	//����������	
	String sLineID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("LineID"));
	//sLineID="BCA20050603000002";
	//���ҳ�����	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders = {
							{"ArtificialNo","��ͬ���"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"BusinessSum","���"},
							{"Balance","���"},
							{"Currency","����"},
							{"CustomerName","�ͻ�����"}							
					};
	sSql =  " select SerialNo,ArtificialNo,CustomerName,getBusinessName(BusinessType) as BusinessTypeName,"+
			" nvl(BusinessSum,0) as BusinessSum,nvl(Balance,0) as Balance,getItemName('Currency',BusinessCurrency) as Currency"+
			" from BUSINESS_CONTRACT "+
			" Where CreditAggreement='"+sLineID+"'";	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="BUSINESS_CONTRACT";
	doTemp.setKey("SerialNo",true);
	doTemp.setHeader(sHeaders);
	doTemp.setVisible("SerialNo",false);
	//�����ѡ
	doTemp.multiSelectionEnabled=true;
	
	doTemp.setColumnAttribute("CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause += " and 1=1 ";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	//out.println(doTemp.SourceSql); //������仰����datawindow
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
		{"true","","Button","ȷ��","ת���������ҵ��","TransRecord()",sResourcesPath},
		{"true","","Button","ȡ��","�رմ���","my_close()",sResourcesPath}		
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
		
	/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function TransRecord()
	{
		sSerialNo=getItemValueArray(0,"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		
		popComp("CreditLineSelectList","/CreditManage/CreditLine/CreditLineSelectList.jsp","SerialNo="+sSerialNo,"");
		parent.close();
	}
	function my_close()
	{
		parent.close();
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
	setDialogTitle("���Ŷ������ҵ���ͬѡ���б�");
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
