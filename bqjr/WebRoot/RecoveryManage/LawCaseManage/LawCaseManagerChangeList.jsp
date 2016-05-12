<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: slliu 2004.12.08
*	Tester:
*	Describe: 案件管理人变更列表
*	Input Param:
*
*	Output Param:     
*	HistoryLog:
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "案件管理人变更列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql;
	
	//获得页面参数

	//获得组件参数
		
%>
<%/*~END~*/%>

<%
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "LawCaseManagerChangeList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	dwTemp.setPageSize(20); 	//服务器分页
	
	Vector vTemp = dwTemp.genHTMLDataWindow(CurOrg.getSortNo()+","+CurUser.getUserID());
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
			{"true","","Button","案件详情","查看案件详细信息","viewAndEdit()",sResourcesPath},
			{"true","","Button","变更管理人","//变更管理人信息","my_ChangeUser()",sResourcesPath},
			{"true","","Button","查看变更记录","查看变更管理人历史","my_history()",sResourcesPath}
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
	function viewAndEdit()
	{
		//获得案件流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		sObjectType = "LawCase";
		sObjectNo = sSerialNo;
		sViewID = "002";
		openObject(sObjectType,sObjectNo,sViewID);	
	}
	
	/*~[Describe=变更管理人信息;InputParam=无;OutPutParam=SerialNo;]~*/
	function my_ChangeUser()
	{   
		sLawCaseNo=getItemValue(0,getRow(),"SerialNo"); //获得案件编号
		sManageUserID=getItemValue(0,getRow(),"ManageUserID"); //获得原管理人编号
		sManageOrgID=getItemValue(0,getRow(),"ManageOrgID"); //获得原管理机构编号
		sUserName=getItemValue(0,getRow(),"ManageUserName"); //获得原管理人名称
		sOrgName=getItemValue(0,getRow(),"ManageOrgName"); //获得原管理机构名称
		
		if (typeof(sLawCaseNo)=="undefined" || sLawCaseNo.length==0)
		{
			alert(getHtmlMessage(1));//请选择一条信息！
			return;
		}else
		{
			//获取流水号
			var sTableName = "MANAGE_CHANGE";//表名
			var sColumnName = "SerialNo";//字段名
			var sPrefix = "";//前缀
			var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		
			OpenPage("/RecoveryManage/LawCaseManage/ManagerChangeInfo.jsp?UserName="+sUserName+"&OrgName="+sOrgName+"&ManageUserID="+sManageUserID+"&ManageOrgID="+sManageOrgID+"&SerialNo="+sSerialNo+"&ObjectType=LawcaseInfo&ObjectNo="+sLawCaseNo+"","right","");
		}
	 }
	
	/*~[Describe=查看变更管理人历史;InputParam=无;OutPutParam=SerialNo;]~*/	
	function my_history()
	{
		sLawCaseNo=getItemValue(0,getRow(),"SerialNo"); //案件编号		
	    if (typeof(sLawCaseNo)=="undefined" || sLawCaseNo.length==0)
		{
			alert(getHtmlMessage(1));//请选择一条信息！
			return;
		}else
		{
			OpenComp("LawCaseHistoryChangeList","/RecoveryManage/LawCaseManage/LawCaseHistoryChangeList.jsp","ComponentName=案件历史变更列表ComponentType=MainWindow&ObjectType=LawcaseInfo&ObjectNo="+sLawCaseNo+"","right",OpenStyle);
		}
		 
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
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>
