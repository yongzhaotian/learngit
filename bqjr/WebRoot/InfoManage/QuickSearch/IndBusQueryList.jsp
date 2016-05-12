<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: jgao1 2009-10-12
		Tester:
		Content: 个体经营户快速查询
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "个体经营户快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;个体经营户快速查询&nbsp;&nbsp;";
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
										{"CustomerName","姓名"},
										{"CertTypeName","证件类型"},
										{"CertID","证件号码"},
										{"SexName","性别"},
										{"Birthday","出生日期"},
										{"EduExperienceName","最高学历"},
										{"EduDegreeName","最高学位"},										
										{"SINo","社会保险号"},
										{"StaffName","是否本行员工"},
										{"NationalityName","民族"},
										{"NativePlace","户籍地址"},
										{"PoliticalFaceName","政治面貌"},
										{"MarriageName","婚姻状况"},
										{"FamilyAdd","居住地址"},
										{"FamilyZIP","居住地址邮编"},
										{"FamilyTel","住宅电话"},
										{"FamilyStatusName","居住状况"},
										{"MobileTelephone","手机号码"},
										{"EmailAdd","电子邮箱"},
										{"CommAdd","通讯地址"},
										{"CommZip","通讯地址邮编"},
										{"OccupationName","职业"},
										{"HeadShipName","职务"},
										{"PositionName","职称"},
										{"FamilyMonthIncome","家庭月收入(元)"},
										{"YearIncome","个人年收入(元)"},
										{"UnitKindName","单位所属行业"},
										{"WorkCorp","单位名称"},
										{"WorkAdd","单位地址"},
										{"WorkZip","单位地址邮编"},
										{"WorkTel","单位电话"},
										{"WorkBeginDate","本单位工作起始日"},
										{"EduRecord","毕业学校(取得最高学历)"},
										{"GraduateYear","毕业年份(取得最高学历)"},
										{"UserName","登记人"},
										{"OrgName","登记机构"},
										{"InputDate","登记日期"},
										{"UpdateDate","更新日期"}
						   }; 
	
	sSql = 	" select CustomerID,CustomerName,getItemName('CertType',CertType) as CertTypeName, "+
			" CertID,getItemName('Sex',Sex) as SexName,Birthday, "+
			" getItemName('EducationExperience',EduExperience) as EduExperienceName, "+
			" getItemName('EducationDegree',EduDegree) as EduDegreeName, "+
			" SINo,getItemName('YesNo',Staff) as StaffName, "+
			" getItemName('Nationality',Nationality) as NationalityName, "+
			" NativePlace,getItemName('PoliticalFace',PoliticalFace) as PoliticalFaceName, "+
			" getItemName('Marriage',Marriage) as MarriageName,FamilyAdd,FamilyZIP, "+
			" FamilyTel,getItemName('FamilyStatus',FamilyStatus) as FamilyStatusName, "+
			" MobileTelephone,EmailAdd,CommAdd,CommZip, "+
			" getItemName('Occupation',Occupation) as OccupationName, "+
			" getItemName('HeadShip',HeadShip) as HeadShipName, "+
			" getItemName('TechPost',Position) as PositionName,FamilyMonthIncome, "+
			" YearIncome,getItemName('IndustryType',UnitKind) as UnitKindName, "+
			" WorkCorp,WorkAdd,WorkZip,WorkTel,WorkBeginDate,EduRecord,GraduateYear, "+
			" getUserName(InputUserID) as UserName,getOrgName(InputOrgID) as OrgName, "+
			" InputDate,UpdateDate "+
			" from IND_INFO "+
			" where CustomerID in "+
			"		(select CustomerID from CUSTOMER_BELONG "+
			" 		where OrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%')) "+
			" and exists"+
					"(select 1 from CUSTOMER_INFO where IND_INFO.CustomerID=CUSTOMER_INFO.CustomerID and CUSTOMER_INFO.CustomerType='0320')"
					;
	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("CustomerID");
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置关键字
	doTemp.setKey("CustomerID",true);	
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	doTemp.setAlign("FamilyMonthIncome,YearIncome","3");
	doTemp.setVisible("YearIncome",false);
	
	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","CustomerName","");
	doTemp.setFilter(Sqlca,"2","CustomerID","");
	doTemp.setFilter(Sqlca,"3","CertID","");	
	doTemp.setFilter(Sqlca,"4","OrgName","");	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
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
		{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath}
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
