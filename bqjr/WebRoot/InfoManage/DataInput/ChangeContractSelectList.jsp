<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cchang 2004-12-26
		Tester:
		Describe: ��ͬѡ��;
		Input Param:
		Output Param:

		HistoryLog:
		jytian 2004/12/28 �������Ŷ�Ⱥ�ͬ
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬѡ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";
	String sWhereClause ="";
	String sTempletNo ="";
	
	//����������	
	String sContractNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractNo"));
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
		
	if(sContractNo==null) sContractNo="";
	if(sCustomerID==null) sCustomerID="";
	
	//�����ͷ�ļ�
	String sHeaders[][] = { 		
	    					{"SerialNo","��ͬ��ˮ��"},      					
	    					{"CustomerName","�ͻ�����"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"BusinessCurrencyName","����"},
							{"BusinessSum","���(Ԫ)"},
							{"BalanceSum","���(Ԫ)"},
							{"ManageUserName","�ܻ���"},
							{"ManageOrgName","�ܻ�����"}
						}; 
	
	
	sSql = 	" select BC.SerialNo as SerialNo ,BC.CustomerID,BC.CustomerName as CustomerName, "+
		   	" BC.BusinessType as BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName, "+
	       	" BC.BusinessCurrency,getItemName('Currency',BC.BusinessCurrency) as BusinessCurrencyName, "+
		   	" BC.BusinessSum as BusinessSum,BC.Balance as BalanceSum, "+
		   	" BC.ManageOrgID, "+
		   	" getUserName(BC.ManageUserID) as ManageUserName, "+
		   	" GetOrgName(BC.ManageOrgID) as ManageOrgName ,BC.ManageUserID "+
		 	" from BUSINESS_CONTRACT BC "+
			" where BC.SerialNo <> '"+sContractNo+"' "+
		 	" and BC.DeleteFlag = '01'"+		 
		 	" and BC.CustomerID = '"+sCustomerID+"' order by BC.PutOutDate ";
		
	
	
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	
	//����Sql���ɴ������
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	
	//���ù��ø�ʽ
	doTemp.setVisible("BusinessType,CustomerID,BusinessType,BusinessCurrency,ManageOrgID,ManageUserID",false);	

	//���ý��Ϊ������ʽ
	doTemp.setType("BusinessSum","Number");
	doTemp.setCheckFormat("BusinessSum","2");
	
	doTemp.setType("BalanceSum","Number");
	doTemp.setCheckFormat("BalanceSum","2");
	
	//���ý����뷽ʽ
	doTemp.setAlign("BusinessSum,BalanceSum","3");
	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("SerialNo,BusinessTypeName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//����html��ʽ	
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName,BusinessTypeName,RecoveryUserName"," style={width:100px} ");

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);  //��������ҳ
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	String sButtons[][] = {
				{"true","","Button","�ͻ�����","�ͻ�����","CustomerInfo()",sResourcesPath},
				{"true","","Button","ҵ������","ҵ������","BusinessInfo()",sResourcesPath}
			};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>





<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script>
  	/*~[Describe=�ͻ�����;InputParam=��;OutPutParam=��;]~*/
	function CustomerInfo()
	{
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			var sReturn = PopPageAjax("/InfoManage/DataInput/CustomerQueryActionAjax.jsp?CustomerID="+sCustomerID,"","");
			if(sReturn == "NOEXSIT")
			{
				alert("Ҫ��ѯ�Ŀͻ���Ϣ�����ڣ�");
				return;
			}
			if(sReturn == "EMPTY")
			{
				alert("Ҫ��ѯ�Ŀͻ�����Ϊ�գ���ѡ��ͻ����ͣ�");
			}
			openObject("ReinforceCustomer",sCustomerID,"002");
		}
	}

	/*~[Describe=��ͬ����;InputParam=��;OutPutParam=��;]~*/
	function BusinessInfo()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			
			if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0)
			{
				sCustomerType   = getItemValue(0,getRow(),"CustomerType");
				
				sCustomerType = sCustomerType.substr(0,3);
				
				sReturn=selectObjectInfo("BusinessType","CustomerType="+sCustomerType+"~ReinforceFlag=N");
				
				if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_' || sReturn=='_NONE_'))
				{
					sss1 = sReturn.split("@");
					sBusinessType=sss1[0];
					sReturn = PopPageAjax("/InfoManage/DataInput/UpdateInputContractActionAjax.jsp?SerialNo="+sSerialNo+"&BusinessType="+sBusinessType,"","");
					openObject("AfterLoan",sSerialNo,"002");
					
				}else if (sReturn=='_CLEAR_')
				{
					return;
				}
				else 
				{
					return;
				}
				
			}else
			{
				openObject("AfterLoan",sSerialNo,"002");
				
			}
			
		}
	}

	function doSearch()
	{
		document.forms("form1").submit();
	}
	
	function mySelectRow()
	{      
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		parent.sObjectInfo =sSerialNo; 
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


<%@ include file="/IncludeEnd.jsp"%>