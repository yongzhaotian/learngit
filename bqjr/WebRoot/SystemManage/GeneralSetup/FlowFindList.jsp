<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: ndeng 2005-04-23
		Tester:
		Describe: ���������ѯ
		Input Param:
			
		Output Param:
			
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���������ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����
	
	//����������
	String sFlowType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowType"));
    if(sFlowType == null) sFlowType = "";
    //out.println(sFlowType);
    
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = 	{
							   {"SerialNo","������ˮ��"},
							   {"ObjectNo","ҵ����ˮ��"},
                               {"PhaseNo","���̽׶κ�"},
                               {"PhaseName","���̽׶�����"},
                               {"UserName","������"},                              
                               {"OrgName","�������"},
                               {"BeginTime","��ʼ����"},
                               {"EndTime","��ֹ����"},
                               {"PhaseAction","����"}
							};

	
	String sSql = " select SerialNo,ObjectType,ObjectNo,PhaseNo,PhaseName, "+
                  " UserName,OrgName,BeginTime,EndTime,PhaseAction "+
                  " from FLOW_TASK where 1=1 ";
	//������������������Ӧ�Ĳ�ѯ����
	if(sFlowType.equals("01"))//����ҵ������
		sSql += " and FlowNo = 'CreditFlow' "+
				" and ObjectNo in (select "+
				" SerialNo from BUSINESS_APPLY "+
				" where OperateOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%'))";
	if(sFlowType.equals("02"))//���������������
		sSql += " and FlowNo = 'ApproveFlow' "+
				" and ObjectNo in (select "+
				" SerialNo from BUSINESS_APPROVE "+
				" where OperateOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%'))";
	if(sFlowType.equals("03"))//�Ŵ�����
		sSql += " and FlowNo = 'PutOutFlow' "+
				" and ObjectNo in (select "+
				" SerialNo from BUSINESS_PUTOUT "+
				" where OperateOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%'))";
	sSql += " and UserID <> 'system' ";
	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	//�����ֶβ��ɼ���
	doTemp.setVisible("ObjectType",false);
	//���ò�ѯ����
	doTemp.setFilter(Sqlca,"1","ObjectNo","");
	doTemp.setFilter(Sqlca,"2","PhaseName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"3","UserName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"4","OrgName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
    doTemp.parseFilterData(request,iPostChange);   
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
    //������������
    doTemp.OrderClause = " group by ObjectNo ";
    doTemp.OrderClause = " order by BeginTime ";
    
    doTemp.appendHTMLStyle("","style=\"cursor:pointer\" ondblclick=\"javascript:parent.viewAndEdit()\"");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

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
		{"true","","Button","�鿴ҵ������","�鿴ҵ������","viewAndEdit()",sResourcesPath}
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		//��ȡ�������ͺͶ�����
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenObject(sObjectType,sObjectNo,"002");
		}
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
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
