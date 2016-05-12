<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cchang 2004-12-26
		Tester:
		Describe: 合同选择;
		Input Param:
		Output Param:

		HistoryLog:
		jytian 2004/12/28 区分授信额度合同
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "合同选择"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql="";
	String sWhereClause ="";
	String sTempletNo ="";
	
	//获得组件参数	
	String sContractNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractNo"));
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
		
	if(sContractNo==null) sContractNo="";
	if(sCustomerID==null) sCustomerID="";
	
	//定义表头文件
	String sHeaders[][] = { 		
	    					{"SerialNo","合同流水号"},      					
	    					{"CustomerName","客户名称"},
							{"BusinessTypeName","业务品种"},
							{"BusinessCurrencyName","币种"},
							{"BusinessSum","金额(元)"},
							{"BalanceSum","余额(元)"},
							{"ManageUserName","管户人"},
							{"ManageOrgName","管户机构"}
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

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	
	//利用Sql生成窗体对象
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	
	//设置共用格式
	doTemp.setVisible("BusinessType,CustomerID,BusinessType,BusinessCurrency,ManageOrgID,ManageUserID",false);	

	//设置金额为数字形式
	doTemp.setType("BusinessSum","Number");
	doTemp.setCheckFormat("BusinessSum","2");
	
	doTemp.setType("BalanceSum","Number");
	doTemp.setCheckFormat("BalanceSum","2");
	
	//设置金额对齐方式
	doTemp.setAlign("BusinessSum,BalanceSum","3");
	
	//生成查询框
	doTemp.setColumnAttribute("SerialNo,BusinessTypeName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//设置html格式	
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName,BusinessTypeName,RecoveryUserName"," style={width:100px} ");

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);  //服务器分页
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	String sButtons[][] = {
				{"true","","Button","客户详情","客户详情","CustomerInfo()",sResourcesPath},
				{"true","","Button","业务详情","业务详情","BusinessInfo()",sResourcesPath}
			};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>





<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script>
  	/*~[Describe=客户详情;InputParam=无;OutPutParam=无;]~*/
	function CustomerInfo()
	{
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			var sReturn = PopPageAjax("/InfoManage/DataInput/CustomerQueryActionAjax.jsp?CustomerID="+sCustomerID,"","");
			if(sReturn == "NOEXSIT")
			{
				alert("要查询的客户信息不存在！");
				return;
			}
			if(sReturn == "EMPTY")
			{
				alert("要查询的客户类型为空，请选择客户类型！");
			}
			openObject("ReinforceCustomer",sCustomerID,"002");
		}
	}

	/*~[Describe=合同详情;InputParam=无;OutPutParam=无;]~*/
	function BusinessInfo()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
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


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>