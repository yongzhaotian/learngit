<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: ���ų�Ա�б�;
		Input Param:
			CustomerID����ǰ�ͻ����
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ų�Ա�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="" ;
	
	//���ҳ�����
	//����������
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	
	//�б�
	String sHeaders[][] = {
							{"GroupName","��������"},
							{"CustomerName","��Ա����"},	
							{"CertTypeName","��Ա֤������"},	
							{"CertID","��Ա֤������"},	
							{"RelationShipName","�ÿͻ��ڼ����еĵ�λ"},													
							{"OrgName","�ܻ�����"},
							{"UserName","�ܻ��ͻ�����"}
			       		  };  
	

		sSql = " select CustomerID,getCustomerName(CustomerID) as GroupName, RelativeID,CustomerName,getItemName('CertType',CertType) as CertTypeName, "+
		       " CertID,RelationShip,"+			   
			   " getItemName('RelationShip',RelationShip) as RelationShipName, "+
			   " getManageOrgName(RelativeID) as OrgName,getManageUserName(RelativeID) as UserName "+
			   " from CUSTOMER_RELATIVE  "+
			   " where RelativeID <> '"+sCustomerID+"' "+
			   " and CustomerID in "+
					   " ( select CustomerID from CUSTOMER_RELATIVE "+
							   " where RelativeID = '"+sCustomerID+"'"+
							   " and RelationShip like '04%'  )"+
			   " and RelationShip like '04%' "+			   		
			   " order by Whethen1 desc ";		

	
	//������ʾģ��
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_RELATIVE";
	//��������
	doTemp.setKey("CustomerID,RelativeID,RelationShip",true);	
	//���ò��ɼ����� 
	doTemp.setVisible("CustomerID,RelativeID,RelationShip",false);	
	//���ò��ɸ�������
	doTemp.setUpdateable("CustomerName,CertTypeName,RelationShipName,OrgName,UserName,whethen2Name",false); 
	//������ʾ��ʽ
  	doTemp.setHTMLStyle("GroupName,CustomerName"," style={width:180px} ");  	
  	doTemp.setAlign("CertTypeName,RelationShipName","2");
	
	//����datawindow
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
		{"true","","Button","�鿴����","�鿴����","my_customerinfo()",sResourcesPath},
		{"true","","Button","�ͻ�������Ϣ","�鿴�ͻ�������������Ϣ","my_RelativeBusiness()",sResourcesPath},
		{"false","","Button","��Ա�����¼","��Ա�����¼","my_relativechangeinfo()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script>
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function my_customerinfo()
	{
		sRelativeID = getItemValue(0,getRow(),"RelativeID");
		if (typeof(sRelativeID)=="undefined" || sRelativeID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		openObject("Customer",sRelativeID,"001");		
	}
	
	/*~[Describe=�ͻ�������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function my_RelativeBusiness()
	{
		sRelativeID = getItemValue(0,getRow(),"RelativeID");
		if (typeof(sRelativeID)=="undefined" || sRelativeID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CustomerCreditView";
		sCompURL = "/CustomerManage/CustomerCreditView.jsp";
		sParamString = "ObjectNo="+sRelativeID;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	}
		
	/*~[Describe=һ�༯�ų�Ա�����¼;InputParam=��;OutPutParam=��;]~*/
	function my_relativechangeinfo()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));
			return;
		}else
		{
			//��ʾ���ų�Ա�ı����¼
			OpenComp("GroupMemberChangeList","/CustomerManage/EntManage/GroupMemberChangeList.jsp","CustomerID="+sCustomerID,"right");
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

<%@	include file="/IncludeEnd.jsp"%>
