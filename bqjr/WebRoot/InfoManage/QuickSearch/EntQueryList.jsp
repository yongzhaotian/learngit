<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   CYHui 2005-1-25
		Tester:
		Content: 公司客户快速查询
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "公司客户快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;公司客户快速查询&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql;//--存放sql语句
	//获得组件参数
	
	//定义表头文件
	String sHeaders[][] = { 							
										{"CustomerID","客户编号"},
										{"EnterpriseName","客户名称"},
										{"EnglishName","客户英文名"},
										{"CorpID","组织机构代码"},
										{"LicenseNo","工商营业执照号码"},
										{"OrgNatureName","机构类型"},
										{"Licensedate","营业执照登记日"},
										{"LicenseMaturity","营业执照到期日"},
										{"OrgType","企业类型"},
										{"OrgTypeName","企业类型"},
										{"IndustryType","国标行业分类"},
										{"IndustryTypeName","国标行业分类"},
										{"MostBusiness","经营范围"},
										{"EmployeeNumber","职工人数"},
										{"ScopeName","企业规模"},
										{"EnterpriseBelongName","企业隶属"},
										{"ListingCorpTypeName","上市公司类型"},
										{"SetupDate","企业成立日期"},
										{"RCCurrencyName","注册资本币种"},
										{"RegisterCapital","注册资本"},
										{"RegisterAdd","注册地址"},
										{"CountryCodeName","所在国家(地区)"},
										{"RegionCodeName","省份、直辖市、自治区"},
										{"OfficeAdd","办公地址"},
										{"OfficeZIP","邮政编码"},
										{"OfficeTel","联系电话"},
										{"LoanCardNo","贷款卡号"},
										{"PCCurrencyName","实收资本币种"},
										{"PaiclUpCapital","实收资本"},
										{"HasIERightName","有无进出口经营权"},
										{"CreditLevel","本行即期信用等级"},
										{"InputUserName","登记人"},
										{"InputOrgName","登记机构"},
										{"InputDate","登记日期"},
										{"UpdateUserName","更新人员"},
										{"UpdateOrgName","更新机构"},
										{"UpdateDate","更新日期"}
						   }; 
	
	sSql =	" select CustomerID,EnterpriseName,EnglishName,CorpID,LicenseNo, "+
			" Licensedate,LicenseMaturity, "+
			" OrgType,getItemName('OrgType',OrgType) as OrgTypeName,IndustryType, "+
			" getItemName('IndustryType',IndustryType) as IndustryTypeName, "+
			" MostBusiness,EmployeeNumber,getItemName('Scope',Scope) as ScopeName, "+
			" getItemName('EnterpriseBelong',EnterpriseBelong) as EnterpriseBelongName, "+
			" getItemName('ListingCorpType',ListingCorpOrNot) as ListingCorpTypeName,SetupDate, "+
			" getItemName('Currency',RCCurrency) as RCCurrencyName,RegisterCapital, "+
			" RegisterAdd,getItemName('CountryCode',CountryCode) as CountryCodeName, "+
			" getItemName('AreaCode',RegionCode) as RegionCodeName,OfficeAdd,OfficeZIP, "+
			" OfficeTel,LoanCardNo,getItemName('Currency',PCCurrency) as PCCurrencyName,"+
			" PaiclUpCapital,getItemName('HaveNot',HasIERight) as HasIERightName,CreditLevel, "+
			" getUserName(InputUserID) as InputUserName, "+
			" getOrgName(InputOrgID) as InputOrgName,InputDate, "+
			" getUserName(UpdateUserID) as UpdateUserName,"+
			" getOrgName(UpdateOrgID) as UpdateOrgName,UpdateDate "+
			" from ENT_INFO" +
			" where CustomerID in "+
			"		(select CustomerID from CUSTOMER_BELONG "+
			" 		where OrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%')) "+
			" and exists"+
					"(select 1 from CUSTOMER_INFO where ENT_INFO.CustomerID=CUSTOMER_INFO.CustomerID and CUSTOMER_INFO.CustomerType='0110')";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);   
	//设置表头
	doTemp.setHeader(sHeaders);	
	//设置关键字
	doTemp.setKey("CustomerID",true);	 

	//设置字段类型
    doTemp.setCheckFormat("RegisterCapital,PaiclUpCapital","2");
    doTemp.setType("RegisterCapital,PaiclUpCapital","Number");
    doTemp.setVisible("OrgType,IndustryType",false);
    doTemp.setDDDWCode("OrgType","OrgType");
    doTemp.setDDDWSql("IndustryType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'IndustryType' and length(ItemNo)=1");
    
	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","EnterpriseName","");
	doTemp.setFilter(Sqlca,"2","CustomerID","");
	doTemp.setFilter(Sqlca,"3","CorpID","");
	doTemp.setFilter(Sqlca,"4","InputOrgName","");
	doTemp.setFilter(Sqlca,"5","OrgType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"6","IndustryType","Operators=BeginsWith;");
	doTemp.setFilter(Sqlca,"7","RegisterCapital","");
	doTemp.setFilter(Sqlca,"8","RegisterAdd","");
	doTemp.setFilter(Sqlca,"9","OfficeAdd","");
	doTemp.setFilter(Sqlca,"10","LicenseNo","");
	doTemp.setFilter(Sqlca,"11","MostBusiness","");
	doTemp.setAlign("EmployeeNumber","3");
	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(21);  //服务器分页

	//生成HTMLDataWindow
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
		{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath}
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit(){
		//获得客户编号
		var sCustomerID=getItemValue(0,getRow(),"CustomerID");	
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else{
			openObject("Customer",sCustomerID,"002");
		}
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