<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hxli 2005-8-18
		Tester:
		Content: ���ѡ���б�
		Input Param:
		Output param:
		History Log: xhgao 2005/09/05 �ؼ�ҳ��

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ѡ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	
	//����������	
	String sSerialNo    = DataConvert.toRealString(iPostChange,CurComp.getParameter("SerialNo"));
	//���ҳ�����	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders = {
					{"LineID","���ID"},
					{"CLTypeID","������ͱ��"},
					{"CLTypeName","�������"},
					{"LineContractNo","���ź�ͬ��"},
					{"CustomerID","�ͻ����"},
					{"CustomerName","�ͻ�����"},
					{"LineSum1","��Ƚ��"},
					{"Currency","����"},
					};
	sSql =  " select LineID,CLTypeID,CLTypeName,LineContractNo,CustomerID,CustomerName,"+
			" LineSum1,getItemName('Currency',Currency) as Currency from CL_INFO Where 1=1";	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="CL_INFO";
	doTemp.setKey("LineID",true);
	doTemp.setHeader(sHeaders);
	doTemp.setVisible("LineID,CLTypeID,CustomerID",false);
	
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
		//{"true","","Button","ȷ��","����ѡҵ��ת���˶������","TransRecord()",sResourcesPath},
		{"true","","Button","ȷ��","ȷ��ʹ�ô˶��","UseConfirm()",sResourcesPath},
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
	function TransRecord(){
		var sLineID=getItemValue(0,getRow(),"LineID");
		if (typeof(sLineID)=="undefined" || sLineID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}		
		sReturn = PopPageAjax("/CreditManage/CreditLine/CreditLineTransActionAjax.jsp?LineID="+sLineID+"&SerialNo=<%=sSerialNo%>","","dialogWidth=21;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 
		if(sReturn="true"){
			alert(getBusinessMessage('412'));//ҵ�������ϵ�ɹ�ת�ƣ�
			parent.close();
		}
	}
	
	function UseConfirm(){
		var sLineID=getItemValue(0,getRow(),"LineID");
		if (typeof(sLineID)=="undefined" || sLineID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		top.returnValue = sLineID;
		top.close();
	}
	
	function my_close(){
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
	setDialogTitle("���Ŷ��ѡ���б�");
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
