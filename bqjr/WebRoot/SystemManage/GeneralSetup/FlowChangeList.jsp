<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: ccxie 2010/03/15
		Tester:
		Describe: 流转记录列表
		Input Param:
			ObjectNo：  	流程业务申请号
			ObjectType:	流程对象类型
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "流转记录列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得参数	
  	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));  
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));  
  	String sFlowStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowStatus"));  
	if(sFlowStatus == null) sFlowStatus = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sTempletNo = "FlowChangeList";
	String sTempletFilter = "1=1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20);
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+sObjectType);
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
			
		{"true","","Button","流程调整","流程调整","FlowAdjust()",sResourcesPath}
		};
	
		if(sFlowStatus.equals("02")){
			sButtons[0][0] = "false";
		}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	/*~[Describe=查看详情;InputParam=无;OutPutParam=无;]~*/
	function FlowAdjust()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sPhaseName = getItemValue(0,getRow(),"PhaseName");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("请选择你要调整到的阶段！");//请选择一条信息！
		}else
		{       
			sCurPhaseName = RunMethod("WorkFlowEngine","GetMaxPhaseName",sSerialNo);
			if(sPhaseName == sCurPhaseName){
				alert("流程正处于"+sPhaseName+"，请重新选择！");
			}else{
				if(confirm("你确定要将流程调整到"+sPhaseName+"吗?")){
					sReturn = RunMethod("WorkFlowEngine","ChangeFlowPhase",sSerialNo+","+sObjectNo+","+sObjectType);
					if(typeof(sReturn) != "undefined" && sReturn == "success"){
						alert("流程调整成功！");
					}else{
						alert("流程调整失败！");
					}
					reloadSelf();
				}
			}
		}
	}

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