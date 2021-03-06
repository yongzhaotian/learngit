<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cwliu 2004-11-29
		Tester:
		Describe:  项目资金来源
		Input Param:
			ProjectNo：当前项目编号
		Output Param:
			ProjectNo：当前项目编号
			

		HistoryLog:
					2005.7.28	hxli   界面改写
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "项目资金来源"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	//获得页面参数	 
	String sObjectNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	//获得组件参数	
	String sProjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProjectNo"));
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ProjectFundsList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sProjectNo+","+sObjectType+","+sObjectNo);
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
		{"true","","Button","新增","新增项目资金来源信息","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看项目资金来源详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除项目资金来源信息","deleteRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		//资金来源方式录入模态框调用
		sReturnValue = PopPage("/CustomerManage/EntManage/AddFundSrcDialog.jsp?","","resizable=yes;dialogWidth=20;dialogHeight=8;center:yes;status:no;statusbar:no");

		//判断是否返回有效信息
		if(typeof(sReturnValue)!="undefined" && sReturnValue.length!=0 && sReturnValue != '_none_')
			OpenPage("/CustomerManage/EntManage/ProjectFundsInfo.jsp?FundSource="+sReturnValue,"_self","");
	}
	

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sProjectNo = getItemValue(0,getRow(),"ProjectNo");		
		if (typeof(sProjectNo)=="undefined" || sProjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}		
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sProjectNo = getItemValue(0,getRow(),"ProjectNo");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sFundSource = getItemValue(0,getRow(),"FundSource");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)		
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{       
			OpenPage("/CustomerManage/EntManage/ProjectFundsInfo.jsp?SerialNo="+sSerialNo+"&FundSource="+sFundSource, "_self","");
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

<%@ include file="/IncludeEnd.jsp"%>
