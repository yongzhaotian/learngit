<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
		Tester:
		Describe: �м���н�ݱ��б�
		Input Param:
					ContractType��
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����
	
	//����������
	String sInOutFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("InOutFlag"));
	if(sInOutFlag==null)sInOutFlag="";
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	if(sOrgID==null)sOrgID=CurOrg.getOrgID();
	String sSortNo=Sqlca.getString("select SortNo from Org_Info where OrgID='"+sOrgID+"'");
	if(sSortNo==null)sSortNo="";
	String sInputDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("InputDate"));
	if(sInputDate==null)sInputDate=StringFunction.getToday();
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID==null)sCustomerID="";
	String sVouchType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("VouchType"));
	if(sVouchType==null)sVouchType="";
	String sBusinessType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BusinessType"));
	if(sBusinessType==null)sBusinessType="";
	String sCreditLevel = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CreditLevel"));
	if(sCreditLevel==null)sCreditLevel="";
	String sDirection = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Direction"));
	if(sDirection==null)sDirection="";
	String sClassifyResult = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ClassifyResult"));
	if(sClassifyResult==null)sClassifyResult="";
	String sClass4Result = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Class4Result"));
	if(sClass4Result==null)sClass4Result="";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"CustomerID","�ͻ���"},
							{"CustomerName","�ͻ�����"},							
							{"ArtificialNo","��ͬ��"},
							{"IndustryTypeName","��ҵ����"},
							{"ContractNo","��ͬ��"},						
							{"BusinessTypeName","ҵ��Ʒ��"},						
							{"BusinessCurrencyName","����"},
							{"BusinessSum","��ͬ���(Ԫ)"},
							{"Balance","���(Ԫ)"},
							{"BusinessRate","����(��)"},
							{"PutoutDate","������"},
							{"Maturity","������"},
							{"OrgName","��������"},
							{"InputDate","�Ǽ�����"},
							{"CreditLevel","�������"},
						  };
    String sSql = "";
    sSql =   " select SerialNo,CustomerID,CustomerName,ArtificialNo,"+
    		" getBusinessName(BusinessType) as BusinessTypeName,"+
    		" getItemName('Currency',BusinessCurrency) as BusinessCurrencyName,"+
    		" BusinessSum,Balance,BusinessRate,PutoutDate,Maturity,"+
    		" getItemName('IndustryType',Direction) as IndustryTypeName,"+
    		" getOrgName(InputOrgID) as OrgName,"+
    		" InputDate"+
    		" from BUSINESS_CONTRACT"+
    		" where InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%') "+
    		" and InputDate <= '"+sInputDate+"' ";
    
    if(!sCustomerID.equals(""))
    {
    	sSql = sSql + " and CustomerID = '"+sCustomerID+"' ";
    }
    if(!sVouchType.equals(""))
    {
    	sSql = sSql + " and VouchType like '"+sVouchType+"%' ";
    }
    if(!sInOutFlag.equals(""))
    {
    	sSql = sSql + " and BusinessType like '"+sInOutFlag+"%' ";
    }
    if(!sCreditLevel.equals(""))
    {
    	sSql = sSql + " and CreditLevel = '"+sCreditLevel+"' ";
    }
    if(!sDirection.equals(""))
    {
    	sSql = sSql + " and Direction like '"+sDirection+"%' ";
    }

	if(!sClassifyResult.equals(""))
    {
    	sSql = sSql + " and ClassifyResult = '"+sClassifyResult+"' ";
    }
    if(sClass4Result.equals("01"))
    {
    	sSql = sSql + " and NormalBalance > 0 ";
    }
    else if(sClass4Result.equals("02"))
    {
    	sSql = sSql + " and OverdueBalance > 0 ";
    }
    else if(sClass4Result.equals("03"))
    {
    	sSql = sSql + " and DullBalance > 0 ";
    }
    else if(sClass4Result.equals("04"))
    {
    	sSql = sSql + " and BadBalance > 0 ";
    }
	
	//out.println(sSql);
	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	
	doTemp.setHeader(sHeaders);
	doTemp.setKeyFilter("SerialNo");
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,CustomerID",false);	
	
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum,Balance,","3");
	doTemp.setType("BusinessSum,Balance","Number");
	doTemp.setCheckFormat("BusinessSum,Balance","2");
	doTemp.setCheckFormat("BusinessRate","14");

	doTemp.setHTMLStyle("BusinessCurrencyName,PutOutDate,Maturity,BusinessRate,ClassifyResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("ArtificialNo"," style={width:120px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");

	doTemp.setColumnAttribute("ArtificialNo,CustomerName,BusinessTypeName,BusinessSum","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

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
			{"true","","Button","�ͻ�����","�ͻ�����","viewCustomer()",sResourcesPath},
			{"true","","Button","��ͬ����","��ͬ����","viewAndEdit()",sResourcesPath},
		};
	
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			openObject("AfterLoan",sSerialNo,"002");
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewCustomer()
	{
		var sCustomerID=getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		openObject("Customer",sCustomerID,"002");
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
</script>
<%@	include file="/IncludeEnd.jsp"%>