<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.biz.workflow.*" %>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   bwang 2009-02-17
		Tester:
		Content: 流程模型列表,查看流程历史
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "流程模型列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	
	
	//获得组件参数	
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	
	//获得页面参数	
	if(sPhaseNo==null)	sPhaseNo = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String[][] sHeaders={
			{"ObjectType","对象类型"},
			{"FlowName","流程名称"},
			{"PhaseNo","阶段编号"},
			{"PhaseName","阶段名称"},
			{"UserName","承办人"},
			{"OrgName","承办机构"},
			{"PhaseAction","选择动作"},
			{"BeginTime","开始时间"},
			{"EndTime","结束时间"},
		};

	sSql =  " select SerialNo,ObjectType,FlowName,PhaseNo,PhaseName,UserName,"+
			" PhaseAction,BeginTime,EndTime "+
			" from FLOW_TASK where FlowNo='"+sFlowNo+"' and ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"'  order by SerialNo";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FLOW_CATALOG";
	doTemp.setKey("FlowNo",true);
	doTemp.setHeader(sHeaders);
	doTemp.setVisible("SerialNo,ObjectType,FlowName,",false);
	doTemp.setHTMLStyle("FlowNo,BeginTime,EndTime,FlowName"," style={width:150px} ");
	doTemp.setHTMLStyle("PhaseNo,FlowType,InitPhase"," style={width:120px} ");	
	doTemp.setHTMLStyle("PhaseName,PhaseAction,FlowDescribe"," style={width:260px} ");
	
	//查询
 	doTemp.setColumnAttribute("ObjectNo,CustomerName,PhaseNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);

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
		{"false","","Button","流程过程明细","流程过程明细","FlowDetail()",sResourcesPath},
		{"false","","Button","调整流程至","调整流程至","backEveryStep()",sResourcesPath},
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
	/*~[Describe=退回前面任一步;InputParam=无;OutPutParam=无;]~*/
	function backEveryStep()
	{		
		var sReturnValue ;
        //获取任务流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
        sFlowNo = "<%=sFlowNo%>";		
   		
		if(typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
        {	
    		alert(getHtmlMessage('1'));//请选择一条信息！
    		return;
		}
		
		//退回任务操作   	
		sReturnValue = PopPage("/Common/WorkFlow/CancelPhaseNoSelect.jsp?SerialNo="+sSerialNo+"&FlowNo="+sFlowNo+"&rand=" + randomNumber(),"退回任务操作","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");        
	
		if(typeof(sReturnValue)=="undefined"||sReturnValue=="_none_")
		{
				//alert("sReturnValue2:"+sReturnValue);  
		}
		else
		{
        	sReturnValue = PopPage("/Common/WorkFlow/CancelPhaseAction.jsp?SerialNo="+sSerialNo+"&PhaseNo="+sReturnValue+"&ObjectNo="+sObjectNo+"&rand=" + randomNumber(),"退回任务操作","dialogWidth=50;dialogHeight=200;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
        	parent.reloadSelf();
		}
    	
	}
	function FlowDetail()
	{
        OpenComp("","","","_blank");
	}
	function madeFlowto()
	{
        
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	function mySelectRow()
	{
        
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;
	my_load(2,0,'myiframe0');
    
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
