<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: ndeng 2005-04-04
		Tester:
		Describe: �ͻ�����Ȩһ��
		Input Param:
			CustomerID����ǰ�ͻ����
		Output Param:
			CustomerID����ǰ�ͻ����
			

		HistoryLog:
		DATE	CHANGER		CONTENT
		2005-7-24 fbkang    �°汾�ĸ�д
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
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
    //String sRightType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));  
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sHeaders[][] = {     
                            {"CustomerID","�ͻ����"},
                            {"CustomerName","�ͻ�����"},
                            {"CustomerTypeName","�ͻ�����"},
                            {"InputOrgID","�Ǽǻ���"},
                            {"UserName","�ܻ��ͻ�����"},
                            {"OrgName","��������"},                           
                            {"BelongAttribute","�ͻ�����Ȩ"},
                            {"BelongAttribute1","��Ϣ�鿴Ȩ"},
                            {"BelongAttribute2","��Ϣά��Ȩ"},
                            {"BelongAttribute3","ҵ�����Ȩ"}
			                  };   	  		   		
	
	String sSql = " select CustomerID, "+
                " getCustomerName(CustomerID) as CustomerName,"+
                " UserID,getUserName(UserID) as UserName," +
                " OrgID, getOrgName(OrgID) as OrgName,"+                
                " getItemName('HaveNot',BelongAttribute) as BelongAttribute,"+
                " getItemName('HaveNot',BelongAttribute1) as BelongAttribute1,"+
                " getItemName('HaveNot',BelongAttribute2) as BelongAttribute2,"+
                " getItemName('HaveNot',BelongAttribute3) as BelongAttribute3"+
                " from CUSTOMER_BELONG" +
                " where CustomerID='"+sCustomerID+"'";	
  
  //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_BELONG";
	doTemp.setKey("CustomerID,OrgID,UserID",true);	 //Ϊ�����ɾ��
	//���ò��ɼ���
	doTemp.setVisible("OrgID,UserID,CustomerID,CustomerName,InputOrgID",false);
	//ͨ�������ⲿ�洢�����õ����ֶ�
	doTemp.setUpdateable("UserName,OrgName",false);   
	doTemp.setHTMLStyle("CustomerTypeName"," style={width:80px} ");
    doTemp.setHTMLStyle("BelongAttribute"," style={width:70px} ");
    doTemp.setHTMLStyle("BelongAttribute1"," style={width:90px} ");
    doTemp.setHTMLStyle("BelongAttribute2"," style={width:70px} ");
    doTemp.setHTMLStyle("BelongAttribute3"," style={width:70px} ");
    doTemp.setHTMLStyle("CustomerName"," style={width:200px} "); 
	//out.println(doTemp.SourceSql);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20);
	
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

		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	
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