<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: ���༯�ų�Ա�б�;
		Input Param:
			CustomerID����ǰ�ͻ����
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���༯�ų�Ա�б�"; // ��������ڱ��� <title> PG_TITLE </title>
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
							{"CustomerName","��Ա����"},	
							{"CertID","��Ա��֯��������"},	
							{"whethen2Name","�����˹�ϵ"},
							{"RelationShipName","�ÿͻ��ڼ����еĵ�λ"},													
							{"OrgName","�ܻ�����"},
							{"UserName","�ܻ��ͻ�����"}
			       		  };  
	

		sSql = " select CR.CustomerID,CR.RelativeID,CR.CustomerName,CR.CertID as CertID, "+
		       " CR.RelationShip,GetItemName('RelativeType',whethen2) as whethen2Name, "+			   
			   " getItemName('RelationShip',RelationShip) as RelationShipName, "+
			   " getManageOrgName(CR.RelativeID) as OrgName,getManageUserName(CR.RelativeID) as UserName "+
			   " from CUSTOMER_RELATIVE CR,CUSTOMER_BELONG CB "+
			   " where CR.CustomerID = CB.CustomerID "+
			   " and CR.RelativeID = '"+sCustomerID+"' "+
			   " and CR.RelationShip like '04%' "+
			   " and CR.Describe = '2' "+
			   " order by CR.Whethen1 desc ";		

	
	//������ʾģ��
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_RELATIVE";
	//��������
	doTemp.setKey("CustomerID,RelativeID,RelationShip",true);	
	//���ò��ɼ����� 
	doTemp.setVisible("CustomerID,RelativeID,RelationShip",false);	
	//���ò��ɸ�������
	doTemp.setUpdateable("CustomerName,RelationShipName,OrgName,UserName,whethen2Name",false); 
	//������ʾ��ʽ
  	doTemp.setHTMLStyle("CustomerName"," style={width:250px} ");  	
	
	
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
		{"true","","Button","���༯�ſͻ�������Ϣ","�鿴���༯�ſͻ�������Ϣ","my_RelativeBusiness()",sResourcesPath},
		{"true","","Button","��Ա�����¼","��Ա�����¼","my_relativechangeinfo()",sResourcesPath},
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
		}else
		{
			openObject("Customer",sRelativeID,"001");
		}
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

	/*~[Describe=���༯�ų�Ա�����¼;InputParam=��;OutPutParam=��;]~*/
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
