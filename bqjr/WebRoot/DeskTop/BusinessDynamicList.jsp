<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: 业务列表
			sListType 11 新增申请
			          12 批准申请
			          13 否决申请
			          14 合同登记
			          15 新提出放贷申请
			          21 期间发放
			          22 期间回收
			          23 展期
			          24 垫款
			          25 逾期
			          26 核销
			          31 即将发放
			          32 即将到期
		Input Param:
		Output param:
		History Log:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "贷后合同列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql1="",sSql2="",sSql3="";

	//获得页面参数
	
	//获得组件参数
	String sOrgName ="";
	String sOrgId = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	String sToday = StringFunction.getToday();

	if (sOrgId==null) {
		sOrgId = CurOrg.getOrgID();
	}
	String sSortNo=Sqlca.getString(new SqlObject("select SortNo from Org_Info where OrgID=:OrgID").setParameter("OrgID",sOrgId));
	if(sSortNo==null)sSortNo="";
	sOrgName = Sqlca.getString(new SqlObject("select OrgName from ORG_INFO where OrgID = :OrgID").setParameter("OrgID",sOrgId));
	String sDay = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DataDate"));
	if (sDay==null) {
		sDay = StringFunction.getToday();
	}
	String sEndDay = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("EndDay"));
	if (sEndDay==null) {
		sEndDay = sDay;
	}
	String sViewDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewDate"));
	if (sViewDate==null) {
		sViewDate = StringFunction.getToday();
	}
	String sListType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ListType"));
	if (sListType==null) {
		sListType = "13";
	}
	String sCurrency = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Currency"));
	if (sCurrency==null) {
		sCurrency = "";
	}

%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","流水号"},
							{"CustomerName","客户名称"},							
							{"BusinessTypeName","业务品种"},
							{"CreditAggreement","额度协议编号"},						
							{"OccurTypeName","发生类型"},
							{"ArtificialNo","合同编号"},							
							{"Currency","币种"},
							{"BusinessSum","金额(元)"},
							{"Balance","余额(元)"},
							{"BailAccount","保证金帐号"},
							{"BailSum","保证金(元)"},
							{"ClearSum","敞口金额(元)"},
							{"OverdueBalance","逾期/垫款金额(元)"},
							{"FineBalance","欠息金额(元)"},
							{"BusinessRate","利率(‰)"},
							{"PutOutDate","起始日期"},
							{"Maturity","到期日期"},
							{"VouchTypeName","担保方式"},
							{"RiskRate","风险度"},
							{"RelativeContractNo","合同流水号"},
							{"RelativeSerialNo","借据号"},
							{"OccurTypeName","流水类型"},
							{"OccurDate","发生日期"},
							{"BusinessCCYName","币种"},
							{"BackType","回收方式"},
							{"ActualDebitSum","发放金额(元)"},
							{"ActualCreditSum","回收金额(元)"},
							{"UserName","客户经理"},
							{"OperateOrgName","经办机构"}
						  };
    String sSql =" select SerialNo,CustomerName,ArtificialNo, "+
				" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
				" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
				" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
				" BusinessSum,Balance,"+
				" FineBalance,BusinessRate,PutOutDate,Maturity,"+
				" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,OverdueBalance,"+
				" getOrgName(ManageOrgID) as OrgName,"+
				" getUserName(ManageUserID) as UserName,"+
				" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
				" from BUSINESS_CONTRACT";
	String sWhere = " where InputDate >= '"+sDay+"' and InputDate <= '"+sEndDay+"' and BusinessCurrency != ''";
	if (!sCurrency.equals("")) {
		sWhere += " and BusinessCurrency = '"+sCurrency+"'";
	}

	if (!sOrgId.equals("9900")) {
		sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
	}

	if (sListType.equals("10")) {
		 sSql =" select SerialNo,CustomerName,"+
				" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
				" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
				" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
				" BusinessSum,"+
				" BusinessRate,"+
				" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
				" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
				" from BUSINESS_APPLY";
	}
	else if (sListType.equals("11")) {
		 sSql =" select SerialNo,CustomerName,"+
				" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
				" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
				" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
				" BusinessSum,"+
				" BusinessRate,"+
				" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
				" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
				" from BUSINESS_APPROVE";
		sWhere = " where InputDate >= '"+sDay+"' and InputDate <= '"+sEndDay+"' and ApproveType='010'";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
		if (!sCurrency.equals("")) {
			sWhere += " and BusinessCurrency = '"+sCurrency+"'";
		}
	}
	else if (sListType.equals("12")) {
		 sSql =" select SerialNo,CustomerName,"+
				" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
				" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
				" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
				" BusinessSum,"+
				" BusinessRate,"+
				" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
				" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
				" from BUSINESS_APPROVE";
		sWhere = " where InputDate >= '"+sDay+"' and InputDate <= '"+sEndDay+"' and ApproveType='020'";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
		if (!sCurrency.equals("")) {
			sWhere += " and BusinessCurrency = '"+sCurrency+"'";
		}
	}
	else if (sListType.equals("14")) {
		 sSql =" select SerialNo,CustomerName,ArtificialNo,"+
				" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
				" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
				" BusinessSum,"+
				" BusinessRate,"+
				" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
				" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
				" from BUSINESS_PUTOUT";
		sWhere = " where InputDate >= '"+sDay+"' and InputDate <= '"+sEndDay+"' and BusinessCurrency != '' and ContractSerialNo is not null";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
		if (!sCurrency.equals("")) {
			sWhere += " and BusinessCurrency = '"+sCurrency+"'";
		}
	}
	else if (sListType.equals("20")) {
		sSql =	" select CustomerName,SerialNo,"+
				" RelativeContractNo,OccurDate,ActualDebitSum "+
				" from BUSINESS_WASTEBOOK";
		sWhere = " where TransactionFlag = '0' and OccurDate >= '"+sDay+"' and OccurDate <= '"+sEndDay+"' and OccurDirection = '0'";
		if (!sOrgId.equals("9900")) {
			sWhere += " and OrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
	}
	else if (sListType.equals("21")) {
		sSql =	" select CustomerName,SerialNo,"+
				" RelativeContractNo,OccurDate,ActualCreditSum "+
				" from BUSINESS_WASTEBOOK";
		sWhere = " where TransactionFlag = '0' and OccurDate >= '"+sDay+"' and OccurDate <= '"+sEndDay+"' and OccurDirection = '1'";
		if (!sOrgId.equals("9900")) {
			sWhere += " and OrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
	}
	else if (sListType.equals("22")) {
		sSql =" select SerialNo,CustomerName,ArtificialNo, "+
				" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
				" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
				" BusinessSum,Balance,"+
				" FineBalance,BusinessRate,PutOutDate,Maturity,"+
				" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,OverdueBalance,"+
				" getOrgName(ManageOrgID) as OrgName,"+
				" getUserName(ManageUserID) as UserName,"+
				" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
				" from BUSINESS_CONTRACT";
		sWhere = " where BusinessType = '9010' and PutOutDate >= '"+sDay+"' and PutOutDate <= '"+sEndDay+"' and BusinessCurrency != ''";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
	}
	else if (sListType.equals("23")) {
		sWhere = " where BusinessType = '1100050' and PutOutDate >= '"+sDay+"' and PutOutDate <= '"+sEndDay+"' and BusinessCurrency != ''";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
	}
	else if (sListType.equals("24")) {
		sWhere = " where OverdueBalance>0 and Maturity >= '"+sDay+"' and Maturity <= '"+sEndDay+"'";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
	}
	else if (sListType.equals("25")) {
		sWhere = " where FinishType like '060%' and FinishDate >= '"+sDay+"' and FinishDate <= '"+sEndDay+"'";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
	}
	else if (sListType.equals("30")) {
		 sSql =" select SerialNo,CustomerName,"+
				" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
				" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
				" BusinessSum,"+
				" BusinessRate,"+
				" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
				" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
				" from BUSINESS_PUTOUT";
		sWhere = " where PutOutDate >= '"+sToday+"' and PutOutDate <= '"+sViewDate+"'and BusinessCurrency != ''";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
	}
	else if (sListType.equals("31")) {
    	sSql =" select SerialNo,CustomerName,ArtificialNo, "+
				" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
				" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
				" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
				" BusinessSum,Balance,"+
				" FineBalance,BusinessRate,PutOutDate,Maturity,"+
				" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,OverdueBalance,"+
				" getOrgName(ManageOrgID) as OrgName,"+
				" getUserName(ManageUserID) as UserName,"+
				" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
				" from BUSINESS_CONTRACT";
		sWhere = " where Maturity >= '"+sToday+"' and Maturity <= '"+sViewDate+"'  and BusinessCurrency != ''";
		if (!sOrgId.equals("9900")) {
			sWhere += " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')";
		}
	}

	sSql = sSql + sWhere;// +" order by CustomerName";
	
	//out.println(sSql);
	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	
	doTemp.setHeader(sHeaders);

	//设置不可见项
	doTemp.setVisible("SerialNo,BusinessType,OccurType,CreditAggreement,BusinessCurrency,VouchType,OperateOrgID,OrgName,FineBalance",false);	
	
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum,Balance,BailSum,OverdueBalance,FineBalance,BusinessRate,RiskRate,ClearSum,PdgRatio","3");
	doTemp.setType("BusinessSum,Balance,BailSum,OverdueBalance,FineBalance,BusinessRate,ClearSum,PdgRatio","Number");
	doTemp.setCheckFormat("BusinessSum,Balance,BailSum,OverdueBalance,FineBalance,PdgRatio,ClearSum","2");
	doTemp.setCheckFormat("BusinessRate","2");
	//设置html格式
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("OccurTypeName,Currency"," style={width:60px} ");
	doTemp.setHTMLStyle("ArtificialNo"," style={width:120px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");

	doTemp.setColumnAttribute("ArtificialNo,CustomerName,BusinessTypeName,BusinessSum","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20); 	//服务器分页

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //查询区的页面代码
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径

	String sButtons[][] = {
			{"true","","Button","详情","详情","viewTab()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}

		sObjectType = "AfterLoan";
		if ("<%=sListType%>"=="10") {
			sObjectType = "CreditApply";
		}
		else if ("<%=sListType%>"=="11") {
			sObjectType = "ApproveApply";
		}
		else if ("<%=sListType%>"=="12") {
			sObjectType = "ApproveApply";
		}
		else if ("<%=sListType%>"=="14" || "<%=sListType%>"=="30") {
			sObjectType = "PutOutApply";
		}
		else if ("<%=sListType%>"=="20") {
			sObjectType = "WasteBook";
		}
		else if ("<%=sListType%>"=="21") {
			sObjectType = "WasteBook";
		}

		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ViewID=002";
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	}
	</script>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>