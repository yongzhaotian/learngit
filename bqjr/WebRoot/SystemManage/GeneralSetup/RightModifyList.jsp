<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cwliu 2004-11-29
		Tester:
		Describe: �ͻ�����Ȩά��
		Input Param:
			RightType��Ȩ������
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ�����Ȩά����Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	//���ҳ�����	
	//����������	
  	String sRightType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));  
	if(sRightType == null) sRightType = "";
	String sSortNo = CurOrg.getSortNo()+"%";

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	
	String sTempletNo = "RightModifyList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);	
	if(sRightType.equals("01"))  doTemp.WhereClause += " and ApplyRight = '"+CurOrg.getOrgID()+"' and ApplyStatus = '1' ";
	if(!doTemp.haveReceivedFilterCriteria()) 
	{    
	    if(sRightType.equals("02"))
	    {
	        doTemp.WhereClause+=" and 1=2 ";
	    }
	}
	if(sRightType.equals("01"))
	{
	    doTemp.setVisible("BelongAttribute",false);
	}
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20);
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sSortNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				
	//��ѯ����ҳ�����
	String sCriteriaAreaHTML = ""; 
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
		{(sRightType.equals("02")?"true":"false"),"","Button","�ܻ�Ȩ����","�鿴�����޸Ŀͻ�ά��������Ϣ","viewAndEdit()",sResourcesPath},
		{(sRightType.equals("01")?"true":"false"),"","Button","��������","��������","CheckApply()",sResourcesPath}
		};
		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		sOrgID   = getItemValue(0,getRow(),"OrgID");
		sUserID   = getItemValue(0,getRow(),"UserID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{       
			popComp("RightModifyInfo","/SystemManage/GeneralSetup/RightModifyInfo.jsp","CustomerID="+sCustomerID+"&OrgID="+sOrgID+"&UserID="+sUserID,"");
		}
	}
	
	/*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
	function CheckApply()
	{
	    sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sUserID = getItemValue(0,getRow(),"UserID");
		sOrgID = getItemValue(0,getRow(),"OrgID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		popComp("RoleApplyInfo","/CustomerManage/RoleApplyInfo.jsp","Check=Y&CustomerID="+sCustomerID+"&UserID="+sUserID+"&OrgID="+sOrgID,"");
		reloadSelf();
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
	showFilterArea();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>