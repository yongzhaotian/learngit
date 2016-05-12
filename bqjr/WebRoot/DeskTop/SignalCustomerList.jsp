<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: ndeng 2005-05-09
		Tester:
		Describe: ����̨����Ԥ����ʾ�ͻ��б�;
		Input Param:
			
		Output Param:
			
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����Ԥ����ʾ�ͻ��б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����
	
	//����������
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
    if(sOrgID == null) sOrgID = CurOrg.getOrgID();
    String sSortNo=Sqlca.getString(new SqlObject("select SortNo from Org_Info where OrgID=:OrgID").setParameter("OrgID",sOrgID));
	if(sSortNo==null)sSortNo="";
    String sTime = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Time"));
    String sCustomerName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerName"));
    String sOrgName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgName"));
    String sUserName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserName"));
    String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
    String sCertID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CertID"));
    if(sTime == null) sTime = "";
    if(sCustomerName == null) sCustomerName = "";
    if(sOrgName == null) sOrgName = "";
    if(sUserName == null) sUserName = "";
    if(sCustomerID == null) sCustomerID = "";
    if(sCertID == null) sCertID = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sSql = "";
	String sIsRight = "";
	String sHeaders[][] = {	{"CustomerID","�ͻ����"},
	                        {"CustomerName","�ͻ�����"},
							{"CertTypeName","֤������"},
							{"CertID","֤����"},
							{"CustomerTypeName","�ͻ�����"},
							{"UserName","�ͻ�����"}
						  };
	String sDate = StringFunction.getToday();
    if(CurUser.hasRole("480") || CurUser.hasRole("280"))
    {
	    sSql =	"select CustomerID,CustomerName,getItemName('CertType',CertType) as CertTypeName,CertID,"+
                        " getItemName('CustomerType',CustomerType) as CustomerTypeName from Customer_Info"+
                        " where CustomerID in (select distinct(CustomerID) from Customer_Belong where UserID='"+CurUser.getUserID()+"')"+
                        " and CustomerID in (select ObjectNo from risk_signal where InputUserID='"+CurUser.getUserID()+"')";

    }
    else if(CurUser.hasRole("040") || CurUser.hasRole("240") || CurUser.hasRole("440"))
    {
        sSql =	"select CustomerID,CustomerName,getItemName('CertType',CertType) as CertTypeName,CertID,"+
                        " getItemName('CustomerType',CustomerType) as CustomerTypeName from Customer_Info"+
                        " where CustomerID in (select CustomerID from Customer_Belong where OrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%'))"+
                        " and CustomerID in (select ObjectNo from risk_signal)";
        if(CurUser.hasRole("040"))
        {
            sIsRight = "Y";
        }
    }
    if(!sTime.equals(""))
    {
        
        if(sTime.equals("1")) //һ����
        {           
            sSql += " and CustomerID in (select ObjectNo from Risk_Signal where datediff(dy,inputdate,getdate()) <= 7)";
        }
        else if(sTime.equals("2")) //ʮ����
        {
            sSql += " and CustomerID in (select ObjectNo from Risk_Signal where datediff(dy,inputdate,getdate()) <= 10)";
        }
        else if(sTime.equals("3")) //һ����
        {
            sSql += " and CustomerID in (select ObjectNo from Risk_Signal where datediff(dy,inputdate,getdate()) <= 30)";
        }
    }
    if(!sCustomerName.equals(""))
    {
        sSql += " and CustomerName like '%"+sCustomerName+"%'";
    }
    if(!sOrgName.equals(""))
    {
        sSql += " and CustomerID in (select CustomerID from Customer_Belong where getOrgName(OrgID) like '%"+sOrgName+"%')";
    }
    if(!sUserName.equals(""))
    {
        sSql += " and CustomerID in (select CustomerID from Customer_Belong where getUserName(UserID) like '%"+sUserName+"%')";
    }
    if(!sCustomerID.equals(""))
    {
        sSql += " and CustomerID like '%"+sCustomerID+"%'";
    }
    if(!sCertID.equals(""))
    {
        sSql += " and CertID like '%"+sCertID+"%'";
    }
	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	
	doTemp.setKey("CustomerID",true);
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
    dwTemp.setPageSize(20);

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

	String sButtons[][] = {
		{"true","","Button","�ͻ���Ϣ","�鿴�ͻ���Ϣ","viewCustomer()",sResourcesPath},
		{"true","","Button","Ԥ����Ϣ","�鿴Ԥ����Ϣ","viewSignal()",sResourcesPath},
		{"true","","Button","��ѯ��Ϣ","��ѯ��Ϣ","Search()",sResourcesPath}
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=�鿴�ͻ�����;InputParam=��;OutPutParam=��;]~*/
	function viewCustomer()
	{
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			openObject("Customer",sCustomerID,"001");
		}
	}
	/*~[Describe=�鿴Ԥ������;InputParam=��;OutPutParam=��;]~*/
    function viewSignal()
	{
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			popComp("CustomerSignalList","/CustomerManage/EntManage/CustomerSignalList.jsp","CustomerID="+sCustomerID+"&Enter=80","","");
		}
	}
	/*~[Describe=��ѯ��Ϣ;InputParam=��;OutPutParam=��;]~*/
    function Search()
	{
		var sReturnValue = popComp("SignalSearchDialog","/DeskTop/SignalSearchDialog.jsp","","dialogWidth=450px;dialogHeight=330px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturnValue) != "undefined" && sReturnValue != "" && sReturnValue != "_none_")
		{	
		    sReturnValue = sReturnValue.split("@");
			sTime=sReturnValue[0];
			sCustomerName = sReturnValue[1];
			sCustomerID = sReturnValue[2];
			sCertID = sReturnValue[3];
			sOrgName = sReturnValue[4];
			sUserName = sReturnValue[5];
			if(sTime == null) sTime = "";
			if(sCustomerName == null) sCustomerName = "";
			if(sOrgName == null) sOrgName = "";
			if(sUserName == null) sUserName = "";
			if(sCustomerID == null) sCustomerID = "";
			if(sCertID == null) sCertID = "";
			sParaString = "Time="+sTime+"&CustomerName="+sCustomerName+"&OrgName="+sOrgName+"&UserName="+sUserName+"&CustomerID="+sCustomerID+"&CertID="+sCertID+"";
			if("<%=sIsRight%>" == "Y")
			    OpenComp("SignalCustomerList","/DeskTop/SignalCustomerList.jsp",sParaString,"right","");
			else
			    OpenComp("SignalCustomerList","/DeskTop/SignalCustomerList.jsp",sParaString,"_blank","");
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
