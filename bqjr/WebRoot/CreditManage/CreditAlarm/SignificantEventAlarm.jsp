<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   byhu 2005.01.21
		Tester:
		Content: 
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = ""; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	String sAction; //������
	ASResultSet rs;
	
	//����������	
	sAction =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Action"));
	if(sAction==null) sAction="";
	//���ҳ�����	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletFilter = "1=1";
	String sHeaders[][] = {
							{"CustomerID","�ͻ����"},
							{"EnterpriseName","�ͻ�����"},
							{"ReportDate","��������"},
							{"IndustryType","��ҵ"},
							{"SignalType","�����ź�����"},
							{"signalName","�����ź�����"},
							{"InputDate","��������"},
						  };

	 sSql =	"select EI.CustomerID,EI.EnterpriseName,EI.IndustryType,RS.SignalType,"+
					" getItemName('AlertSignal',Signaltype) as signalName,RS.InputDate"+
					" from RISK_SIGNAL RS,ENT_INFO EI" +
					" where RS.ObjectType='Customer' and RS.ObjectNo=EI.CustomerID";
	//ͨ��sql����doTemp���ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);	
	//����������
	doTemp.setDDDWCode("IndustryType","IndustryType");
	//���ù�����
	doTemp.setFilter(Sqlca,"1","InputDate","HtmlTemplate=Date;Operators=BetweenString;DefaultValues=@"+StringFunction.getToday());
	doTemp.setFilter(Sqlca,"2","IndustryType","Operators=BeginsWith;HtmlTemplate=PopSelect;");
	doTemp.setFilter(Sqlca,"3","SignalType","Operators=BeginsWith;HtmlTemplate=PopSelect");
	doTemp.setVisible("IndustryType,SignalType",false);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//��������¼�
	//dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");
	
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
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/Frame/CodeExamples/ExampleInfo.jsp","_self","");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sExampleID = getItemValue(0,getRow(),"ExampleID");
		
		if (typeof(sExampleID)=="undefined" || sExampleID.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")) 
		{
			//as_del(myiframename);
			as_save(myiframe0);  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sCustomerID=getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		openObject("Customer",sCustomerID,"001");
	}
	
	function importWatcher(){
		sReturn = popComp("WatcherSelection","/CreditManage/CreditAlarm/WatcherSelectionList.jsp","","");
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	function filterAction(sObjectID,sFilterID,sObjectID2){
		oMyObj = document.getElementById(sObjectID);
		oMyObj2 = document.getElementById(sObjectID2);
		if(sFilterID=="1"){
		
		}else if(sFilterID=="2"){
			sReturn = selectObjectInfo("Code","CodeNo=IndustryType^��ѡ����ҵ����^length(ItemNo)=1","");
			if(typeof(sReturn)=="undefined" || sReturn=="_CANCEL_"){
				return;
			}else if(sReturn=="_CLEAR_"){
				oMyObj.value="";
				//oMyObj2.value="";
			}else{
				sReturns = sReturn.split("@");
				oMyObj.value=sReturns[0];
				//oMyObj2.value=sReturns[1];
			}
		}else if(sFilterID=="3"){
			sReturn = selectObjectInfo("Code","CodeNo=AlertSignal^��ѡ������ź�����^","");
			if(typeof(sReturn)=="undefined" || sReturn=="_CANCEL_"){
				return;
			}else if(sReturn=="_CLEAR_"){
				oMyObj.value="";
				//oMyObj2.value="";
			}else{
				sReturns = sReturn.split("@");
				oMyObj.value=sReturns[0];
				//oMyObj2.value=sReturns[1];
			}
		}
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
