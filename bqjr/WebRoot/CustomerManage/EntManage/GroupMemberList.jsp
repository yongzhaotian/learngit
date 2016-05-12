<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2005-12-27
		Tester:
		Describe: �������ų�Ա��Ϣ�б�;
		Input Param:
			CustomerID����ǰ�ͻ����
		Output Param:
			CustomerID����ǰ�ͻ����
			RelativeID�������ͻ���֯��������
			Relationship��������ϵ
		HistoryLog:
		    cbsu 2009/10/23 Ϊ��ӦALS6.5�µļ��ſͻ��������󣬽�ҳ����±���CUSTOMER_RELATIVE��ΪGROUP_RELATIVE.
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������ų�Ա��Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	//���ҳ�����
	//����������
	
    //���ſͻ����
    String sRelativeID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));

    //�õ����ſͻ��Ŀͻ����ͣ�ʵ�弯�Ż����⼯�� 
    String sSql = " Select CustomerType from CUSTOMER_INFO where CustomerID = :CustomerID";
    String sGroupType = Sqlca.getString(new SqlObject(sSql).setParameter("CustomerID",sRelativeID));
    if (sGroupType == null) sGroupType = "";
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	
	String sHeaders[][] = {
							{"CustomerName","���ų�Ա����"},
							{"CertType","֤������"},
							{"CertID","֤������"},
							{"RelationShip","��Ա����"},
							{"RelationShipName","��Ա����"},
							{"ManageOrgName","�ܻ�����"},
							{"ManageUserName","�ܻ��ͻ�����"}
						  };
    //��GROUP_RELATIVE��CUSTOMER_INFO���еõ� ���ų�Ա��ţ����ű�ţ����ų�Ա���ƣ����ų�Ա֤������
    //���ų�Ա֤�����룬��ϵ���ܻ��������ܻ���
	sSql =  " select CI.CustomerID,GR.RelativeID,CI.CustomerName, "+
			" getItemName('CertType',CI.CertType) as CertType, "+
			" CI.CertID,GR.RelationShip, getItemName('GroupRelation',GR.RelationShip) as RelationShipName,"+
			" getManageOrgName(CI.CustomerID) as ManageOrgName, "+
			" getManageUserName(CI.CustomerID) as ManageUserName " +
			" from GROUP_RELATIVE GR, CUSTOMER_INFO CI" +
			" where GR.RelativeID='"+sRelativeID+"' "+
			" and GR.CustomerID = CI.CustomerID";

   	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GROUP_RELATIVE";
	//�������������ں����ɾ��
	doTemp.setKey("CustomerID,RelativeID",true);
	//���ò��ɼ���
	doTemp.setVisible("CustomerID,RelativeID,InputUserID,RelationShip,RelationShipName",false);
	//��ʽ����
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setAlign("CertType","2");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteGroupInfo(#CustomerID,#RelativeID,"+CurUser.getUserID()+")");
	
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
		{"true","","Button","����","����������ҵ��Ա��Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴������ҵ��Ա��Ϣ����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��������ҵ��Ա��Ϣ","deleteRecord()",sResourcesPath},
		{"true","","Button","�ͻ�����","�鿴������ҵ��Ա�ͻ���Ϣ����","viewCustomer()",sResourcesPath},
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
		var sGroupType = "<%=sGroupType%>";
	    OpenPage("/CustomerManage/EntManage/GroupMemberInfo.jsp?GroupType="+sGroupType,"_self",""); //modify by cbsu 2009-10-22
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����			
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sGroupType = "<%=sGroupType%>"; //add by cbsu 2009-10-22
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			OpenPage("/CustomerManage/EntManage/GroupMemberInfo.jsp?GroupMemberID="+sCustomerID+"&GroupType="+sGroupType, "_self","");
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewCustomer()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			openObject("Customer",sCustomerID,"003");
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
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
