<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   FBkang 2005-08-01
		Tester:
		Content: 个人客户快速查询
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "个人客户快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;个人客户快速查询&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//--存放sql语句
	//获得组件参数	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 							
										{"CustomerID","客户编号"},
										{"CustomerName","客户名称"},
										{"CustomerType","客户类型"},
										{"CustomerType1","客户类型"},
										{"CertTypeName","证件类型"},
										{"CertTypeCode","证件类型"},
										{"CertID","证件号码"},
										{"SexName","性别"},
										{"Birthday","出生日期"},
										{"EduExperienceName","最高学历"},
										{"EduDegreeName","最高学位"},										
										{"NationalityName","民族"},
										{"PoliticalFaceName","政治面貌"},
										{"MarriageName","婚姻状况"},
										{"FamilyTel","住宅电话"},
										{"FamilyStatusName","居住状况"},
										{"MobileTelephone","手机号码"},
										{"EmailAdd","电子邮箱"},
										{"OccupationName","职业"},
										{"HeadShipName","职务"},
										{"PositionName","职称"},
										{"UnitKindName","单位所属行业"},
										{"WorkCorp","单位名称"},
										{"WorkZip","单位地址邮编"},
										{"WorkTel","单位电话"},
										{"UserName","登记人"},
										{"OrgName","登记机构"},
										{"InputDate","登记日期"},
										{"UpdateDate","更新日期"},
										{"CityName","城市"},
										{"SalesexecutiveName","销售代表"},
										{"Salesexecutive","销售代表ID"},
										{"SaleManagerName","销售经理"},
										{"SalesManager","销售经理ID"}
						   }; 
	
	sSql = 	" select IND_INFO.CustomerID as CustomerID,IND_INFO.CustomerName as CustomerName,getItemName('CustomerType',IND_INFO.CustomerType) as CustomerType, IND_INFO.CustomerType as CustomerType1,getItemName('CertType',IND_INFO.CertType) as CertTypeName, IND_INFO.CertType as CertTypeCode, "+
			" IND_INFO.CertID as CertID,getItemName('Sex',IND_INFO.Sex) as SexName,IND_INFO.Birthday as Birthday, "+
			" getItemName('EducationExperience',IND_INFO.EduExperience) as EduExperienceName, "+
			" getItemName('EducationDegree',IND_INFO.EduDegree) as EduDegreeName, "+
			" getItemName('Nationality',IND_INFO.Nationality) as NationalityName, "+
			" getItemName('PoliticalFace',IND_INFO.PoliticalFace) as PoliticalFaceName, "+
			" getItemName('Marriage',IND_INFO.Marriage) as MarriageName, "+
			" IND_INFO.FamilyTel as FamilyTel,getItemName('FamilyStatus',IND_INFO.FamilyStatus) as FamilyStatusName, "+
			" IND_INFO.MobileTelephone as MobileTelephone,IND_INFO.EmailAdd as EmailAdd, "+
			" getItemName('Occupation',IND_INFO.Occupation) as OccupationName, "+
			" getItemName('HeadShip',IND_INFO.HeadShip) as HeadShipName, "+
			" getItemName('TechPost',IND_INFO.Position) as PositionName, "+
			" getItemName('IndustryType',IND_INFO.UnitKind) as UnitKindName, "+
			" IND_INFO.WorkCorp as WorkCorp,IND_INFO.WorkZip as WorkZip,IND_INFO.WorkTel as WorkTel, "+
			" getUserName(IND_INFO.InputUserID) as UserName,getOrgName(IND_INFO.InputOrgID) as OrgName, "+
			" IND_INFO.InputDate as InputDate,IND_INFO.UpdateDate as UpdateDate, "+
			" getItemName('AreaCode',BUSINESS_CONTRACT.City) as CityName,"+
			" getUserName(BUSINESS_CONTRACT.Salesexecutive) as SalesexecutiveName,"+
			" BUSINESS_CONTRACT.Salesexecutive as Salesexecutive,"+
			" getuserName(STORE_INFO.SalesManager)   as SaleManagerName , STORE_INFO.SalesManager as SalesManager "+
			" from IND_INFO,BUSINESS_CONTRACT,STORE_INFO  "+
//			" where CustomerID in "+
//			"		(select CustomerID from CUSTOMER_BELONG "+
//			" 		where OrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%')) "+
//			" and exists"+
            " where  IND_INFO.Customerid=BUSINESS_CONTRACT.Customerid"+
            " and BUSINESS_CONTRACT.Stores=STORE_INFO.Sno"
					;
	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置关键字
	//doTemp.setKeyFilter("CustomerID");
	doTemp.setKey("CustomerID",true);	
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	doTemp.setAlign("FamilyMonthIncome,YearIncome","3");
	doTemp.setVisible("YearIncome,SalesManager,CertTypeCode,CustomerType1",false);
	//设置证件类型下拉
	doTemp.setDDDWSql("CertTypeCode", "select itemno,itemname from code_library where codeno='CertType' and IsInUse = '1' ");
	doTemp.setDDDWSql("CustomerType1", "select itemno,itemname from code_library where codeno='CustomerType' and IsInUse = '1'");
	//隐藏字段
	//doTemp.setVisible("CustomerType",false);
	
	//生成查询框
	//doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","CustomerName","Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca,"2","CustomerID","Operators=EqualsString,BeginsWith;");
	//doTemp.setFilter(Sqlca,"3","CustomerType1","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"4","CertTypeCode","Operators=EqualsString;");	
	doTemp.setFilter(Sqlca,"5","CertID","Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca,"6","MobileTelephone","Operators=EqualsString,BeginsWith;");
	//doTemp.setFilter(Sqlca,"7","CityName","Operators=EqualsString,BeginsWith;");
	//doTemp.setFilter(Sqlca,"8","Salesexecutive","Operators=EqualsString;");
	//doTemp.setFilter(Sqlca,"9","SalesManager","Operators=EqualsString;");
	doTemp.parseFilterData(request,iPostChange);
	//判断符合该条件是否数据比较多，影响查询条件
	boolean flag = true;
	for(int k=0;k<doTemp.Filters.size();k++){
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && (("1").equals(doTemp.getFilter(k).sFilterID)||("2").equals(doTemp.getFilter(k).sFilterID)||("5").equals(doTemp.getFilter(k).sFilterID)||("6").equals(doTemp.getFilter(k).sFilterID)) ){
			flag = false;
			break;
		}
	}
	if(doTemp.haveReceivedFilterCriteria()&& flag)
	{
		%>
		<script type="text/javascript">
			alert("客户名称,客户编号,证件号码,手机号码至少输入一项！");
		</script>
		<%
		doTemp.WhereClause+=" and 1=2";
	}
	for(int k=0;k<doTemp.Filters.size();k++){
		
		//输入的条件都不能含有%符号
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && doTemp.Filters.get(k).sFilterInputs[0][1].contains("%")){
			%>
			<script type="text/javascript">
				alert("输入的条件不能含有\"%\"符号!");
			</script>
			<%
			doTemp.WhereClause+=" and 1=2";
			break;
		}
	
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null  && "BeginsWith".equals(doTemp.Filters.get(k).sOperator)){
			if(("1").equals(doTemp.getFilter(k).sFilterID) && doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 2){
				%>
				<script type="text/javascript">
					alert("输入的字符长度必须要大于等于2位!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
				break;
			} else if((("2").equals(doTemp.getFilter(k).sFilterID) || ("5").equals(doTemp.getFilter(k).sFilterID)|| ("6").equals(doTemp.getFilter(k).sFilterID)) && doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 8){
				%>
				<script type="text/javascript">
					alert("输入的字符长度必须要大于等于8位!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
				break;
			}
			
		} else if(k==doTemp.Filters.size()-1){
		
			if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
		
		}
	}
	
//	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页

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
		{"true","","Button","客户详情","客户详细信息","viewAndEdit()",sResourcesPath},
		{"true","","Button","联系方式修改","联系方式修改","getUpdateCustomer()",sResourcesPath},
		{"true","","Button","电话仓库","电话仓库","getPhoneCode()",sResourcesPath},
		{"true","","Button","还款记录查询","还款记录查询","withholdRecordQuery()",sResourcesPath},
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	//---------------------定义按钮事件------------------------------//

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得个人客户代码
		sCustomerID=getItemValue(0,getRow(),"CustomerID");	
		
	
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			openObject("Customer",sCustomerID,"002");//打开个人客户详细信息
		}
	}
	
	/*~[Describe=联系方式修改;InputParam=无;OutPutParam=SerialNo;]~*/
	function getUpdateCustomer(){
		//获取客户编号
		sCustomerID=getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}

		sCompID = "UpdateCustomerInfo";
		sCompURL = "/InfoManage/QuickSearch/UpdateCustomerInfo.jsp";
		sParamString = "CustomerID="+sCustomerID;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=700px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	 /*~[Describe=电话录入;InputParam=无;OutPutParam=无;]~*/
	function getPhoneCode()
	{
		var sCustomerID=getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
//		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
	//	sReturn = sReturn.split("@");
		
	 }
	
	 /*~[Describe=客户代扣记录查询;InputParam=无;OutPutParam=无;]~*/
	function withholdRecordQuery()
	{
		var sCustomerID=getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		sCompID = "withholdRecordQuery";
		sCompURL = "/InfoManage/QuickSearch/WithholdRecordQuery.jsp";
	 	sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=800px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");

	 }
 
	function testrule(){
		var sReturn = RunMethod("BusinessManage", "RuleProfaceDate", "10000440001");
		akert(sReturn);
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
