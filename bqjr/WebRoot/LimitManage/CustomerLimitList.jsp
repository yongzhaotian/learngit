<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:Thong 2005.8.30 10:20
		Tester:
		Content: ����޶������б�
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����޶������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	String sInputUser; //������
	
	//����������	
	sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	if(sInputUser==null) sInputUser="";
	//���ҳ�����	
	//sCustomerID =  DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	//ͨ��Sql����ASDataObject����doTemp
	
	String sHeaders[][] = { 
				{"LimitType","�޶�����"},
				{"KindCode","�ͻ�����"},
				{"Limit","��һ�޶�(Ԫ)"},
				{"ActualLimit","ʵ��ռ���޶�(Ԫ)"},
				{"BeginDate","��Ч����"},
				{"EndDate","ʧЧ����"},
				{"Useflg","�Ƿ�ʹ��"},
				{"UserName","������Ա"}
			       };   				   		
			       
	sSql = "select SerialNo,LimitType,KindCode,KindItem,Limit,ActualLimit,"+
				  "BeginDate,EndDate,getItemName('YesOrNo',Useflg) as Useflg,"+
				  "getUserName(UserID) as UserName  "+
				  "from LIMIT_INFO "+
				  "where LimitType='��һ�޶�'";	
	String sTempletFilter = "1=1"; //�й�������ע�ⲻҪ�����ݹ���������
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "LIMIT_INFO";           //for delete        		
	doTemp.setKey("SerialNo",true);

	doTemp.setVisible("SerialNo,KindItem,UserName",false);
	doTemp.setHTMLStyle("*"," style={width:70px}");
	doTemp.setHTMLStyle("KindCode,Limit,ActualLimit"," style={width:130px}");
	doTemp.setAlign("TotalSum,Limit,ActualLimit,Rate,AlertRate","3");
	doTemp.setCheckFormat("TotalSum,Limit,ActualLimit","2");
		
	doTemp.setColumnAttribute("LimitType","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);

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
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","ʹ��ObjectViewer��","ʹ��ObjectViewer��","openWithObjectViewer()",sResourcesPath}
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
		OpenPage("/LimitManage/CustomerLimitDetail.jsp","_self","");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		OpenPage("/LimitManage/CustomerLimitDetail.jsp?sSerialNo="+sSerialNo,"_self","");
	}
	
	/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function openWithObjectViewer()
	{
		sSerialNo=getItemValue(0,getRow(),"sSerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
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
