<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   XWu 2004.12.12
		Tester:
		Content: ��ͬ���߰�����Ϣ�б�
		Input Param:
			   ObjectNo����ͬ��� �����ʲ�����    
			   ObjectType����������     
			   CustomerID���ͻ�ID �Ŵ��ͻ���Ϣ����    
		Output param:
				 
		History Log: 
		                  
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬ���߰�����Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sWhereCondition = "";
    String sInCondition = "";

	//����������	
	//���ҳ�����
	String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType"));
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID")); 
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); //�������ͣ��������Customer����������û���ô�����Ϊ��Ҫ��BusinessContract
	
	if(sCustomerID == null) sCustomerID = "";
	if(sObjectType == null) sObjectType = "BusinessContract";
	if(sFinishType == null) sFinishType = "";

	if(sCustomerID.equals("")){
		//�����ʲ�̨�ʹ���������Ϣҳ���ﲻ��CustomerID�������ʳ����������������ObjectNo�Ǻ�ͬ�ţ�ObjectType��BusinessContract
		String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
		sWhereCondition	= " SerialNo in (Select SerialNo From LAWCASE_RELATIVE Where ObjectNo = '"+sObjectNo+"' And ObjectType = 'BusinessContract') ";
	}
	else{
		//���ͺ���С����ҵ�������������
		String sSql = "select SerialNo from BUSINESS_CONTRACT where CustomerID=:CustomerID";
		ASResultSet rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
		while(rs.next()){
			if(sInCondition != null && !sInCondition.equals(""))
				sInCondition = sInCondition+",";
			sInCondition = sInCondition+ "'"+rs.getString(1)+"'";
		}
		rs.getStatement().close();

		if(sInCondition == null) sInCondition = "";
		if(sInCondition.indexOf("'")<0) sInCondition = "'"+sInCondition+"'";
		sWhereCondition	= 	" SerialNo in (Select Distinct SerialNo From LAWCASE_RELATIVE Where ObjectNo in ("+sInCondition+")" + 
							" And ObjectType = 'BusinessContract') order by InputDate desc ";  	
	}
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
		String sTempletNo = "NPALawCaseList";//ģ�ͱ��
		ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

		doTemp.WhereClause += sWhereCondition;
		
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
		dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		dwTemp.setPageSize(10);

		//����HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
	
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
	
		//���Ϊ��ǰ���������б���ʾ���°�ť
		String sButtons[][] = {
					{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
				};	
%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��ð�����ˮ�š���������
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
		}
		else
		{		
			sObjectType = "LawCase";
			sObjectNo = sSerialNo;
			sViewID = "002";
			openObject(sObjectType,sObjectNo,sViewID);		}
		
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
