<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: --���ſͻ�����;
		Input Param:
			CustomerID��--��ǰ�ͻ����
		Output Param:
			CustomerID��--��ǰ�ͻ����
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ſͻ�����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
     String sSql="";
    
	//���ҳ�����
	
	//����������
	//String sSqlTemp    =  DataConvert.toRealString(iPostChange,(String)request.getParameter("SqlTemp"));
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
		
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {     
							{"OtherRelativeID","��Ա��֯��������"},
							{"RelativeName","���ų�Ա����"},
							{"AggregateName","��������"},
							{"BelongOrg","�ܻ�����"},
							{"CorporationName","����������"},
							{"Region","���ڵ�"},
							{"RelativeTypeName","�����˹�ϵ"},
							{"IsBusiness","�Ƿ�������������δ����ҵ��"},
							{"SearchFlagName","�Ƿ�ϵͳ�������"}  
			       		  };  
	

	sSql = " select A.CustomerID,A.RelativeID,EI.EnterpriseName as RelativeName,"+
	       " EI.CorpID as OtherRelativeID,FictitiousPerson as CorporationName,"+
	       " getItemName('AreaCode',EI.RegionCode) as Region,A.InputOrgID,"+
		   " getItemName('YesNo','2') as IsBusiness,"+
		   " getOrgName(CB.OrgID) as BelongOrg, "+
		   " A.RelativeType,getItemName('RelativeType',A.RelativeType) as RelativeTypeName,"+
		   " A.SearchFlag,getItemName('YesNo',A.SearchFlag) as SearchFlagName "+
		   " from GROUP_SEARCH A,ENT_INFO EI ,CUSTOMER_BELONG CB"+
		   " where  "+
		   " A.RelativeID=EI.CustomerID and EI.CustomerID = CB.CustomerID and CB.BelongAttribute = '1' and A.CustomerID='"+sCustomerID+"' "+
		   " order by A.RelativeType ";	

	//������ʾģ��
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GROUP_SEARCH";
	//�ͻ����Ƴ���
  	//doTemp.setHTMLStyle("RelativeName"," style={width:250px} ");
  	
	doTemp.setKey("CustomerID,RelativeID",true);	 
	doTemp.setVisible("Region,CustomerID,RelativeID,InputOrgID,InputDate,SearchFlag,RelativeType",false);
	doTemp.setAlign("IsBusiness,SearchFlagName","2");

	//doTemp.setUpdateable("RelativeName,OtherRelativeID,Region,InputOrgName,IsBusiness,SearchFlagName,BelongOrg,RelativeTypeName,CorporationName",false); 
	
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
		{"true","","Button","���ſͻ�����","���ſͻ�����","my_relativesearch()",sResourcesPath},
		{"true","","Button","������Ա","�ֹ��������ų�Ա�ͻ�","my_RelativeAdd()",sResourcesPath},
		{"true","","Button","�鿴��Ա����","�鿴��Ա����","my_customerinfo()",sResourcesPath},
		{"true","","Button","���ſͻ��϶�������","���ſͻ��϶�������","my_relativefile()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">
		
	/*~[Describe=������ǰ�ͻ��Ĺ�����Ա;InputParam=��;OutPutParam=��;]~*/
	function my_relativesearch()
	{
		sReturnValue = PopPageAjax("/CustomerManage/EntManage/GroupMemberSearchAjax.jsp?CustomerID=<%=sCustomerID%>","","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(sReturnValue == "True")
		{
			alert("���ſͻ���ϵ�����ɹ���");
			reloadSelf();
		}
		if(sReturnValue == "False")
		{
			alert("���ſͻ���ϵ����ʧ�ܣ�������������");
			return
		}
	}
	
	/*~[Describe=������ǰ�ͻ��Ĺ�����Ա;InputParam=��;OutPutParam=��;]~*/
	function my_RelativeAdd()
	{
		sCustomerInfo = PopPage("/CustomerManage/EntManage/AddGroupMemberDialog.jsp","","dialogWidth=20;dialogHeight=10;minimize:yes");
		if (typeof(sCustomerInfo)=="undefined" || sCustomerInfo.length==0)
		{
		}else
		{		
			sCustomerInfo = sCustomerInfo.split("@");
			sRelativeID = sCustomerInfo[0];
			sRelativeType = sCustomerInfo[1];			
			sReturnValue = PopPageAjax("/CustomerManage/EntManage/AddGroupMemberActionAjax.jsp?CustomerID=<%=sCustomerID%>&RelativeID="+sRelativeID+"&RelativeType="+sRelativeType,"","dialogWidth=0;dialogHeight=0;minimize:yes");
			if(sReturnValue == "HaveRecord_Member")
			{
				alert("�ͻ��Ѿ�����ĳ�����ţ��������ӵ���ǰ�����£�");
				return
			}
			if(sReturnValue == "HaveRecord_Search")
			{
				alert("���ſͻ��������Ѿ����ڸÿͻ�����Ϣ���޷�������ӣ�");
				return
			}
			if(sReturnValue == "Join")
			{
				alert("������Ա�ɹ���");
				return
			}
		}
	}
	
	/*~[Describe=�ͻ�����;InputParam=��;OutPutParam=��;]~*/
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
	
	/*~[Describe=���ſͻ��϶�;InputParam=��;OutPutParam=��;]~*/
	function my_relativefile()
	{		
		alert("���ڽ�����......")
		return;			
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
