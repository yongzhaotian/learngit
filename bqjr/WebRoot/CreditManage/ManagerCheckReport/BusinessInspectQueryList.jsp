<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: ndeng 2005-01-17
		Tester:
		Describe: �������б�
		Input Param:
					InspectType��   010     ������;��鱨��
						            010010  δ���
						            010020  �����
						            020     �����鱨��
						            020010  δ���
						            020020  �����
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	

	//���ҳ�����
	
	//����������
	String sInspectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("InspectType"));
    //ֻ�ܲ�ѯ����ɱ���
    if(sInspectType == null) sInspectType="020010";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	ASDataObject doTemp = null;
  //������;�����б�
  if(sInspectType.equals("010010") || sInspectType.equals("010020"))
  {
	  String sHeaders1[][] = {
							{"CustomerName","�ͻ�����"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"ArtificialNo","��ͬ���"},
							{"Currency","����"},
							{"BusinessSum","��ͬ���"},
							{"PutOutDate","��ͬ��Ч����"},
							{"InspectType","�������"},
							{"UpDateDate","��������"},
							{"InputUser","�����"},
							{"InputOrg","��������"},
							{"ManageOrg","�������"}
							};

	  String sSql1 = " select II.SerialNo as SerialNo,II.ObjectNo as ObjectNo,II.ObjectType as ObjectType,"+
					" BC.CustomerID as CustomerID,BC.CustomerName as CustomerName, "+
					" getBusinessName(BusinessType) as BusinessTypeName,"+
					" getItemName('Currency',BC.BusinessCurrency) as Currency,"+
		            " BC.BusinessType as BusinessType ,"+
		            " BC.ArtificialNo as ArtificialNo,"+
		            " BC.BusinessSum as BusinessSum,BC.PutOutDate,getOrgName(BC.ManageOrgid) as ManageOrg,"+
					" getItemName('InspectType',II.InspectType) as InspectType,"+
					" II.UpDateDate as UpDateDate,"+
					" getUserName(II.InputUserID) as InputUser,"+
					" getOrgName(II.InputOrgId) as InputOrg"+
					" from INSPECT_INFO II,BUSINESS_CONTRACT BC "+
					" where II.ObjectType='BusinessContract' "+
	                " and II.InspectType like '010%' "+
	                " and II.ObjectNo=BC.SerialNo ";

	if(sInspectType.equals("010010"))
	{
	  sSql1=sSql1+" and (II.FinishDate = ' ' or II.FinishDate is null)";
	}
	else
	{
	  sSql1=sSql1+" and II.FinishDate is not null";
	}
	//��SQL������ɴ������
	doTemp = new ASDataObject(sSql1);

	doTemp.UpdateTable = "INSPECT_INFO";

	doTemp.setKey("SerialNo",true);
	doTemp.setHeader(sHeaders1);
  	//���ò��ɼ���
  	doTemp.setVisible("SerialNo,ObjectNo,BusinessType,ObjectType,InspectType,ManageOrg,CustomerID",false);
  	doTemp.setUpdateable("BusinessTypeName,BusinessType,BusinessSum,CustomerName",false);
  	doTemp.setAlign("BusinessSum,Balance","3");
  	doTemp.setCheckFormat("BusinessSum,Balance","2");
  	//����html��ʽ
  	doTemp.setHTMLStyle("UptoDate,BusinessSum"," style={width:80px} ");
  	doTemp.setHTMLStyle("InspectType"," style={width:100px} ");
  	doTemp.setHTMLStyle("ObjectNo,CustomerName,BusinessTypeName"," style={width:120px} ");      
  	  
	//���ɲ�ѯ��
	doTemp.setFilter(Sqlca,"1","UpDateDate","HtmlTemplate=Date;Operators=BetweenString;");
	doTemp.setFilter(Sqlca,"2","PutOutDate","HtmlTemplate=Date;Operators=BetweenString;");
	doTemp.setFilter(Sqlca,"3","ManageOrg","");
	doTemp.setFilter(Sqlca,"4","CustomerName","");
	doTemp.setFilter(Sqlca,"5","InputUser","");
	doTemp.setFilter(Sqlca,"6","InputOrg","");	
  }
    
  //�����鱨���б�
  else if(sInspectType.equals("020010") || sInspectType.equals("020020"))
  {
    String sHeaders2[][] = {
							{"CustomerName","�ͻ�����"},
							{"ObjectNo","�ͻ����"},
							{"CustomerBelongOrg","�������"},
							{"InspectType","�������"},
							{"UpDateDate","��������"},
							{"InputUserName","�����"},
							{"InputOrgName","��������"}							
						  };

	  String sSql2 = //" select SerialNo,ObjectNo,ObjectType,getCustomerName(ObjectNo) as CustomerName,getOrgName(CI.InputOrgID) as CustomerBelongOrg,"+
	                " select II.SerialNo,II.ObjectNo,II.ObjectType,CI.CustomerName,getOrgName(CI.InputOrgID) as CustomerBelongOrg,"+
					" getItemName('InspectType',II.InspectType) as InspectType,"+
		            " II.UpDateDate,II.InputUserID,II.InputOrgID,"+
		            " getUserName(II.InputUserID) as InputUserName,"+
		            " getOrgName(II.InputOrgID) as InputOrgName "+
					" from INSPECT_INFO II,CUSTOMER_INFO CI "+
					" where ObjectType='Customer' and II.ObjectNo = CI.CustomerID"+
	                " and InspectType  like '020%' ";

	  if(sInspectType.equals("020010"))
	  {
	    sSql2=sSql2+" and (FinishDate = ' ' or FinishDate is null)";
	  }
	  else
	  {
	    sSql2=sSql2+" and FinishDate is not null";
	  }
	  //��SQL������ɴ������
	  doTemp = new ASDataObject(sSql2);

	  doTemp.UpdateTable = "INSPECT_INFO";

	  doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);
	  doTemp.setHeader(sHeaders2);
  	//���ò��ɼ���
  	doTemp.setVisible("SerialNo,InputUserID,InputOrgID,ObjectNo,ObjectType,InspectType,CustomerBelongOrg",false);
  	doTemp.setUpdateable("CustomerName,InputUserName,InputOrgName",false);
  	//����html��ʽ
  	doTemp.setHTMLStyle("UptoDate,InputUserName"," style={width:80px} ");
  	doTemp.setHTMLStyle("InspectType"," style={width:100px} ");
  	doTemp.setHTMLStyle("ObjectNo,CustomerName"," style={width:250px} ");
  	
  	
  	//���ɲ�ѯ��
	doTemp.setFilter(Sqlca,"1","UpDateDate","HtmlTemplate=Date;Operators=BetweenString;");
	doTemp.setFilter(Sqlca,"2","CustomerBelongOrg","");
	doTemp.setFilter(Sqlca,"3","CustomerName","");
	doTemp.setFilter(Sqlca,"4","InputUserName","");
	doTemp.setFilter(Sqlca,"5","InputOrgName","");
	
	//doTemp.setVisible("CustomerBelongOrg",false);
  }
 
  	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2 ";
  	
  	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
  	dwTemp.Style="1";      //����ΪGrid���
  	dwTemp.ReadOnly = "1"; //����Ϊֻ��
  
    //out.println(doTemp.SourceSql);
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
			{"true","","Button","����","�鿴��������","viewAndEdit()",sResourcesPath},
			{"true","","Button","�ͻ�������Ϣ","�鿴�ͻ�������Ϣ","viewCustomer()",sResourcesPath},
		    {"true","","Button","ҵ���嵥","�鿴ҵ���嵥","viewBusiness()",sResourcesPath}
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sInspectType = "<%=sInspectType%>";
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectType=getItemValue(0,getRow(),"ObjectType");

		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else {
			if(sInspectType == '010010' || sInspectType == '010020')
			{
				sCompID = "PurposeInspectTab";
				sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
				sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}
			else if(sInspectType == '020010' || sInspectType == '020020')
			{
				sCompID = "InspectTab";
				sCompURL = "/CreditManage/CreditCheck/InspectTab.jsp";
				sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}
		}
	}
    /*~[Describe=�鿴�ͻ�����;InputParam=��;OutPutParam=��;]~*/
	function viewCustomer()
	{
		if("<%=sInspectType%>"=="010010" || "<%=sInspectType%>"=="010020")
        {
            sCustomerID   = getItemValue(0,getRow(),"CustomerID");
        }
       	else if("<%=sInspectType%>"=="020010" || "<%=sInspectType%>"=="020020")	
    	{
    	    sCustomerID   = getItemValue(0,getRow(),"ObjectNo");
    	}
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			openObject("Customer",sCustomerID,"001");
		}
    		
    }
    /*~[Describe=�鿴ҵ���嵥;InputParam=��;OutPutParam=��;]~*/
	function viewBusiness()
	{
		if("<%=sInspectType%>"=="010010" || "<%=sInspectType%>"=="010020")
        {
            sCustomerID   = getItemValue(0,getRow(),"CustomerID");
        }
       	else if("<%=sInspectType%>"=="020010" || "<%=sInspectType%>"=="020020")	
    	{
    	    sCustomerID   = getItemValue(0,getRow(),"ObjectNo");
    	}
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			popComp("CustomerLoanAfterList","/CustomerManage/EntManage/CustomerLoanAfterList.jsp","CustomerID="+sCustomerID,"","","");
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
	showFilterArea();
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>