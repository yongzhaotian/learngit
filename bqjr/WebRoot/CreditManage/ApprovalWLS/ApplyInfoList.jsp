<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:	thong 2005.9.01 11:30
		Tester:
		Content: ����������ͳ�ƹ���
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����������ͳ�ƹ���"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	String sInputUser; //������
	String sOrgID;
	//����������	
	sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	if(sInputUser==null) sInputUser="";
	sOrgID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgID"));
	//���ҳ�����	
	//sCustomerID =  DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	//ͨ����ʾģ�����ASDataObject����doTemp
    String sHeaders[][] = {
						   {"SerialNo","������"},
						   {"CustomerID","�����˱��"},
                           
                           {"CustomerName","����������"},
                           {"BusinessType","��������"},
                           {"OccurType","��������"},
                           {"OccurDate","��������"},
                           {"OccurDate","����ʱ��[Сʱ]"},
                           };
	String sTempletFilter = "1=1"; //�й�������ע�ⲻҪ�����ݹ���������
	sSql = "Select SerialNo,CustomerID,CustomerName,BusinessType,OccurType,OccurDate,OccurDate from Business_Apply where 1=1";
				
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.setColumnAttribute("SerialNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.UpdateTable="EXAMPLE_INFO";
	doTemp.setKey("ExampleID",true);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	if(!sInputUser.equals("")) doTemp.WhereClause += " and InputUser = '"+sInputUser+"'";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	//dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");
	
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

	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{

	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{

	}
	
	/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function openWithObjectViewer()
	{
		sExampleID=getItemValue(0,getRow(),"ExampleID");
		if (typeof(sExampleID)=="undefined" || sExampleID.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		
		openObject("Example",sExampleID,"001");//ʹ��ObjectViewer����ͼ001��Example��
		/*
		 * [�ο�]
		 * ��ͬ����һ�䣺
		 * OpenComp("ObjectViewer","/Frame/ObjectViewer.jsp","ComponentName=����鿴��&ObjectType=Example&ObjectNo="+sExampleID+"&ViewID=001","_blank",OpenStyle);
		 */
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*�������һ��Ҫ add by hxd in 2001/08/28 for ... preview ... */
	function mySelectRow()
	{
		sApplyNO = getItemValue(0,getRow(),"ApplyNO");	
		OpenPage("/CreditManage/ApprovalWLS/ApplyInfoTime.jsp?OrgID=<%=sOrgID%>&ApplyNO="+sApplyNO,"rightdown","");
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
