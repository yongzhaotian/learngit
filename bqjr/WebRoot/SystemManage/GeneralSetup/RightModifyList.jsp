<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cwliu 2004-11-29
		Tester:
		Describe: 客户管理权维护
		Input Param:
			RightType：权限类型
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户管理权维护信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	//获得页面参数	
	//获得组件参数	
  	String sRightType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));  
	if(sRightType == null) sRightType = "";
	String sSortNo = CurOrg.getSortNo()+"%";

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	
	String sTempletNo = "RightModifyList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);	
	if(sRightType.equals("01"))  doTemp.WhereClause += " and ApplyRight = '"+CurOrg.getOrgID()+"' and ApplyStatus = '1' ";
	if(!doTemp.haveReceivedFilterCriteria()) 
	{    
	    if(sRightType.equals("02"))
	    {
	        doTemp.WhereClause+=" and 1=2 ";
	    }
	}
	if(sRightType.equals("01"))
	{
	    doTemp.setVisible("BelongAttribute",false);
	}
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20);
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sSortNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				
	//查询区的页面代码
	String sCriteriaAreaHTML = ""; 
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
		{(sRightType.equals("02")?"true":"false"),"","Button","管户权操作","查看并可修改客户维护基本信息","viewAndEdit()",sResourcesPath},
		{(sRightType.equals("01")?"true":"false"),"","Button","审批申请","审批申请","CheckApply()",sResourcesPath}
		};
		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		sOrgID   = getItemValue(0,getRow(),"OrgID");
		sUserID   = getItemValue(0,getRow(),"UserID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{       
			popComp("RightModifyInfo","/SystemManage/GeneralSetup/RightModifyInfo.jsp","CustomerID="+sCustomerID+"&OrgID="+sOrgID+"&UserID="+sUserID,"");
		}
	}
	
	/*~[Describe=审阅申请;InputParam=无;OutPutParam=无;]~*/
	function CheckApply()
	{
	    sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sUserID = getItemValue(0,getRow(),"UserID");
		sOrgID = getItemValue(0,getRow(),"OrgID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		popComp("RoleApplyInfo","/CustomerManage/RoleApplyInfo.jsp","Check=Y&CustomerID="+sCustomerID+"&UserID="+sUserID+"&OrgID="+sOrgID,"");
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
	showFilterArea();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>