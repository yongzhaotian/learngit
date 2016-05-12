<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   yyang3 2013-03-12
		Tester:
		Content: 业务批处理日志列表
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "业务批处理日志列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	
	//获取组件参数
	
	//获取页面参数
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "BatchTaskList";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
    //增加过滤器	
	doTemp.setColumnAttribute("INPUTDATE,TASKNAME,TARGETDESCRIBE,TASKDESCRIBE,STATUS","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause += " and InputDate = '"+SystemConfig.getBusinessDate()+"'";
	    
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(200);

	//定义后续事件
	//dwTemp.setEvent("AfterDelete","!SystemManage.DeleteOrgBelong(#OrgID)");
	
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
		{"true","","Button","查看信息","查看详细信息","viewError()",sResourcesPath},
		{"true","","Button","跳过","跳过选中的步骤","skip()",sResourcesPath},
		{"true","","Button","单元错误明细","单元错误明细","viewErrorDetail()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
    var sCurCodeNo=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------   
	/*~[Describe=查看信息;InputParam=无;OutPutParam=无;]~*/
	function viewError()
	{
		inputDate = getItemValue(0,getRow(),"INPUTDATE");
		targetName = getItemValue(0,getRow(),"TARGETNAME");
		taskName = getItemValue(0,getRow(),"TASKNAME");
		hostIP = getItemValue(0,getRow(),"HOSTIP");
		processID = getItemValue(0,getRow(),"PROCESSID");
        if(typeof(inputDate) == "undefined" || inputDate.length == 0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		popComp("BatchTaskInfo","/SystemManage/SysLogManage/BatchTaskInfo.jsp","InputDate="+inputDate+"&TargetName="+targetName+"&TaskName="+taskName+"&HostIP="+hostIP+"&ProcessID="+processID);
	}

	//跳过该步骤
	function skip()
	{
		inputDate = getItemValue(0,getRow(),"INPUTDATE");
		targetName = getItemValue(0,getRow(),"TARGETNAME");
		taskName = getItemValue(0,getRow(),"TASKNAME");
		hostIP = getItemValue(0,getRow(),"HOSTIP");
		processID = getItemValue(0,getRow(),"PROCESSID");
        if(typeof(inputDate) == "undefined" || inputDate.length == 0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		if(!confirm("确认跳过此步吗？")) return;
		RunMethod("LoanAccount","UpdateBatchTaskStatus",inputDate+","+targetName+","+taskName+","+hostIP+","+processID+",4");
		reloadSelf();
	}

	/*~[Describe=查看错误明细;InputParam=无;OutPutParam=无;]~*/
	function viewErrorDetail()
	{
		inputDate = getItemValue(0,getRow(),"INPUTDATE");
		targetName = getItemValue(0,getRow(),"TARGETNAME");
		taskName = getItemValue(0,getRow(),"TASKNAME");
		hostIP = getItemValue(0,getRow(),"HOSTIP");
		processID = getItemValue(0,getRow(),"PROCESSID");
        if(typeof(inputDate) == "undefined" || inputDate.length == 0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		popComp("BatchTaskError","/SystemManage/SysLogManage/BatchTaskError.jsp","InputDate="+inputDate+"&TaskName="+taskName);
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
