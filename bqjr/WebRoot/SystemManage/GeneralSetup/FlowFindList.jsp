<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: ndeng 2005-04-23
		Tester:
		Describe: 流程情况查询
		Input Param:
			
		Output Param:
			
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "流程情况查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数
	
	//获得组件参数
	String sFlowType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowType"));
    if(sFlowType == null) sFlowType = "";
    //out.println(sFlowType);
    
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = 	{
							   {"SerialNo","任务流水号"},
							   {"ObjectNo","业务流水号"},
                               {"PhaseNo","流程阶段号"},
                               {"PhaseName","流程阶段名称"},
                               {"UserName","经办人"},                              
                               {"OrgName","经办机构"},
                               {"BeginTime","起始日期"},
                               {"EndTime","终止日期"},
                               {"PhaseAction","操作"}
							};

	
	String sSql = " select SerialNo,ObjectType,ObjectNo,PhaseNo,PhaseName, "+
                  " UserName,OrgName,BeginTime,EndTime,PhaseAction "+
                  " from FLOW_TASK where 1=1 ";
	//根据流程类型设置相应的查询条件
	if(sFlowType.equals("01"))//授信业务流程
		sSql += " and FlowNo = 'CreditFlow' "+
				" and ObjectNo in (select "+
				" SerialNo from BUSINESS_APPLY "+
				" where OperateOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%'))";
	if(sFlowType.equals("02"))//最终审批意见流程
		sSql += " and FlowNo = 'ApproveFlow' "+
				" and ObjectNo in (select "+
				" SerialNo from BUSINESS_APPROVE "+
				" where OperateOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%'))";
	if(sFlowType.equals("03"))//放贷流程
		sSql += " and FlowNo = 'PutOutFlow' "+
				" and ObjectNo in (select "+
				" SerialNo from BUSINESS_PUTOUT "+
				" where OperateOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%'))";
	sSql += " and UserID <> 'system' ";
	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	//设置字段不可见性
	doTemp.setVisible("ObjectType",false);
	//设置查询条件
	doTemp.setFilter(Sqlca,"1","ObjectNo","");
	doTemp.setFilter(Sqlca,"2","PhaseName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"3","UserName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"4","OrgName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
    doTemp.parseFilterData(request,iPostChange);   
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
    //设置排序条件
    doTemp.OrderClause = " group by ObjectNo ";
    doTemp.OrderClause = " order by BeginTime ";
    
    doTemp.appendHTMLStyle("","style=\"cursor:pointer\" ondblclick=\"javascript:parent.viewAndEdit()\"");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

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
		{"true","","Button","查看业务详情","查看业务详情","viewAndEdit()",sResourcesPath}
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		//获取对象类型和对象编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenObject(sObjectType,sObjectNo,"002");
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
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
