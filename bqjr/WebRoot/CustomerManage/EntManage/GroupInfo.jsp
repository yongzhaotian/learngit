<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-11-29
		Tester:
		Describe: �������ų�Ա��Ϣ;
		Input Param:
			CustomerID����ǰ�ͻ����
			RelativeID�������ͻ���֯��������
			Relationship��������ϵ
		Output Param:
			CustomerID����ǰ�ͻ����
		HistoryLog:
		    cbsu 2009/10/23 Ϊ��Ӧ�µļ��ſͻ��������󣬽����±��ΪGROUP_RELATIVE��
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������ų�Ա��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
    String sCertType = "";
    String sCertID = "";
    String sCustomerName = "";
    ASResultSet rs = null;
	//����������
	//���ſͻ����
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	sSql = " select BelongGroupID from Customer_Info where CustomerID = :CustomerID";
	String sRelativeID = Sqlca.getString(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(sRelativeID == null) sRelativeID = "";

%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//�������
	String sTempletNo = "EnterpriseInfo04";//--ģ�����ͼ��ſͻ�
	//����ʾģ�����ɴ������
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.setUnit("RegionCodeName","");
		
	//�������ݴ���
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";//freeform��ʽ
	dwTemp.ReadOnly="1";
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sRelativeID);  //���뼯�ű��
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
		//{"true","","Button","�������Ŷ����Ϣ","���������޸�","GroupLine()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	/*~[Describe=�������Ŷ����Ϣ;InputParam=�����¼�;OutPutParam=��;]~*/
	function GroupLine()
	{
		
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	var bCheckBeforeUnload=false;
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>