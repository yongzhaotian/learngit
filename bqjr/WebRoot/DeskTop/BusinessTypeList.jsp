<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
		Tester:
		Describe: 中间库中借据表列表
		Input Param:
					ContractType：
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "借据列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数
	
	//获得组件参数
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


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
							{"CustomerID","客户号"},
							{"CustomerName","客户名称"},							
							{"ArtificialNo","合同号"},
							{"IndustryTypeName","行业分类"},
							{"ContractNo","合同号"},						
							{"BusinessTypeName","业务品种"},						
							{"BusinessCurrencyName","币种"},
							{"BusinessSum","合同金额(元)"},
							{"Balance","余额(元)"},
							{"BusinessRate","利率(‰)"},
							{"PutoutDate","发放日"},
							{"Maturity","到期日"},
							{"OrgName","机构名称"},
							{"InputDate","登记日期"},
							{"CreditLevel","评级结果"},
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
	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	
	doTemp.setHeader(sHeaders);
	doTemp.setKeyFilter("SerialNo");
	//设置不可见项
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
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20); 

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

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
			{"true","","Button","客户详情","客户详情","viewCustomer()",sResourcesPath},
			{"true","","Button","合同详情","合同详情","viewAndEdit()",sResourcesPath},
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
	function viewAndEdit()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			openObject("AfterLoan",sSerialNo,"002");
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
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




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%@	include file="/IncludeEnd.jsp"%>