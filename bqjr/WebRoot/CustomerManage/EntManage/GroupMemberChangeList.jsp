<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: JBai 2005-12-18
		Tester:
		Describe: ���ų�Ա����б�;
		Input Param:
			CustomerID����ǰ�ͻ����
		Output Param:
			

		HistoryLog:zywei 2006/1/4 �ؼ����
		           cbsu 2009/10/27 ��"��֯��������"��Ϊ���ɼ�
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ų�Ա����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String  sSql = "";
	//���ҳ�����
	//����������
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));

%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
    String sHeaders[][] = { 							
							{"CustomerName","���ų�Ա����"},
							{"Corp","��֯��������"},
							{"UpdateDate","�������"},
							{"UpdateUserName","�����"},
							{"ChangeTypeName","�����ʽ"},							
							{"OldName","ԭ��˾����"}
			              }; 
	
		sSql = " select SerialNo,GroupNo,CustomerName,Corp,CustomerID, "+
			   " UpdateDate,getUserName(UpdateUserid) as UpdateUserName, "+
			   " GetItemName('ChangeType',ChangeType) as ChangeTypeName,OldName "+
			   " from GROUP_CHANGE "+
			   " where GroupNo = '"+sCustomerID+"' "+
			   " and ChangeType<>'060' "+
			   " order by SerialNo desc ";	
				   
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GROUP_CHANGE";
	doTemp.setAlign("ChangeTypeName","2");
	//���ù��ø�ʽ
	doTemp.setVisible("GroupNo,CustomerID,SerialNo,Corp",false);
	doTemp.setHTMLStyle("ChangeTypeName","style={width:100px} ");  
	doTemp.setHTMLStyle("CustomerName,OldName"," style={width:250px} ");
	


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
		{"false","","Button","�ͻ�����","�鿴������ҵ��Ա�ͻ���Ϣ����","viewCustomer()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script>
	
	function my_info()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));
		}else
		{
			//���ÿͻ�����ģ��
			window.open("EnterpriseDetail.jsp?CustomerID="+sCustomerID+"&BackPage=Blank&rand="+randomNumber(),"",OpenStyle);
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
