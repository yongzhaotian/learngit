<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: FMWu 2004-11-29
		Tester:
		Describe: 关联集团成员信息;
		Input Param:
			CustomerID：当前客户编号
			RelativeID：关联客户组织机构代码
			Relationship：关联关系
		Output Param:
			CustomerID：当前客户编号
		HistoryLog:
		    cbsu 2009/10/23 为适应新的集团客户管理需求，将更新表改为GROUP_RELATIVE。
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "关联集团成员信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
    String sCertType = "";
    String sCertID = "";
    String sCustomerName = "";
    ASResultSet rs = null;
	//获得组件参数
	//集团客户编号
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	sSql = " select BelongGroupID from Customer_Info where CustomerID = :CustomerID";
	String sRelativeID = Sqlca.getString(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(sRelativeID == null) sRelativeID = "";

%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//定义变量
	String sTempletNo = "EnterpriseInfo04";//--模板类型集团客户
	//由显示模板生成窗体对象
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.setUnit("RegionCodeName","");
		
	//生成数据窗体
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";//freeform格式
	dwTemp.ReadOnly="1";
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sRelativeID);  //传入集团编号
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
		//{"true","","Button","集团授信额度信息","保存所有修改","GroupLine()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	/*~[Describe=集团授信额度信息;InputParam=后续事件;OutPutParam=无;]~*/
	function GroupLine()
	{
		
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	var bCheckBeforeUnload=false;
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>