<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  ccxie 2010/03/17
		Tester:
		Describe: 流程监控列表
		Input Param:
			FlowStatus：01在办业务 02办结业务
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "流程监控列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	//获得页面参数	
	//获得组件参数	
  	String sFlowStatus =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowStatus"));  
	if(sFlowStatus == null) sFlowStatus = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sTempletNo = "FlowControlList";
	String sTempletFilter = "1=1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	if(sFlowStatus.equals("01"))
		doTemp.WhereClause = doTemp.WhereClause + " and PhaseNo not in ('1000','8000') " ;
	else
		doTemp.WhereClause = doTemp.WhereClause + " and PhaseNo in ('1000','8000') " ;
	doTemp.WhereClause = doTemp.WhereClause+" and OrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%') ";
	//设置Filter		
	doTemp.setFilter(Sqlca,"1","FlowName","Operators=EqualsString;HtmlTemplate=PopSelect");
	doTemp.setFilter(Sqlca,"2","PhaseName","Operators=EqualsString;HtmlTemplate=PopSelect");
	doTemp.setFilter(Sqlca,"3","ObjectNo","Operators=EqualsString,Contains,BeginsWith,EndWith;");
	doTemp.setFilter(Sqlca,"4","UserName","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"5","OrgName","Operators=EqualsString;HtmlTemplate=PopSelect");
	doTemp.setFilter(Sqlca,"6","InputDate","HtmlTemplate=Date;Operators=BeginsWith,EndWith,BetweenString;");

	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2 ";
	
	String sApproveNeed = "";
	sApproveNeed = CurConfig.getConfigure("ApproveNeed");//获取业务是否要走最终审批意见的流程的标志
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20);
	
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
			
		{"true","","Button","详情","详情","ViewDetail()",sResourcesPath},
		{"true","","Button","查看意见","查看意见","ViewOpinion()",sResourcesPath},
		{"true","","Button","流转记录","流转记录","ChangeFlow()",sResourcesPath},
		{"false","","Button","业务移交","业务移交","BizTransfer()",sResourcesPath}
		};
	
		if(sFlowStatus.equals("01")){
			sButtons[3][0] = "true";
		}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	/*~[Describe=查看详情;InputParam=无;OutPutParam=无;]~*/
	function ViewDetail(){
		var sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType   = getItemValue(0,getRow(),"ObjectType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			paraString = RunMethod("WorkFlowEngine","GetFlowParaString",sObjectType+","+sObjectNo+",FlowDetailPara");
			paraList = paraString.split("@");
			popComp(paraList[1],paraList[0],paraList[2],"");
		}
	}

	/*~[Describe=查看意见;InputParam=无;OutPutParam=无;]~*/
	function ViewOpinion(){
		var sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType   = getItemValue(0,getRow(),"ObjectType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			paraString = RunMethod("WorkFlowEngine","GetFlowParaString",sObjectType+","+sObjectNo+",FlowOpinionPara");
			paraList = paraString.split("@");
			popComp(paraList[1],paraList[0],paraList[2],"");
		}
	}
	
	/*~[Describe=流转记录;InputParam=无;OutPutParam=无;]~*/
	function ChangeFlow(){
		var sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType   = getItemValue(0,getRow(),"ObjectType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			popComp("FlowChangeList","/SystemManage/GeneralSetup/FlowChangeList.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&FlowStatus="+"<%=sFlowStatus%>","");
			reloadSelf();
		}
	}

	/*~[Describe=业务移交;InputParam=无;OutPutParam=无;]~*/
	function BizTransfer(){
		var sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType   = getItemValue(0,getRow(),"ObjectType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			sParaStr = "SortNo,"+"<%=CurOrg.getSortNo()%>";
			sReturn= setObjectValue("SelectUserInOrg",sParaStr,"",0,0);	
			if(typeof(sReturn) != "undefined" && sReturn.length != 0 ){
				sReturn = sReturn.split('@');
				sUserID = sReturn[0];
				RunMethod("WorkFlowEngine","ChangeFlowOperator",sObjectNo+","+sObjectType+","+sUserID);
				alert("当前业务已移交给用户 "+sUserID);
				reloadSelf();
			}
		}  
	}


	/*~[Describe=查询条件弹出对话框;InputParam=无;OutPutParam=无;]~*/
	function filterAction(sObjectID,sFilterID,sObjectID2){
		oMyObj = document.getElementById(sObjectID);
		oMyObj2 = document.getElementById(sObjectID2);
		if(sFilterID=="1"){
			var sApproveNeed = "<%=sApproveNeed%>";
			if("true" == sApproveNeed){//判断该笔业务是否要走最终审批意见的流程
				sParaString = "CodeNo"+","+"FlowObject";
				sReturn =setObjectValue("SelectCode",sParaString,"",0,0,"");
			}else{
				sParaString = "CodeNo"+","+"FlowObject"+","+"Attribute1"+","+"SWITapprove";
				sReturn =setObjectValue("SelectCodeFlowObject",sParaString,"",0,0,"");
			}
			if(typeof(sReturn) == "undefined" || sReturn == "_CANCEL_"){
				return;
			}else if(sReturn == "_CLEAR_"){
				oMyObj.value = "";
				//oMyObj2.value = "";
			}else{				
				sReturns = sReturn.split("@");
				//oMyObj2.value=sReturns[0];
				oMyObj.value=sReturns[1];
			}
		}else if(sFilterID=="2"){		
			obj = document.getElementById("1_1_INPUT");
			if(obj.value == ""){
				alert('请先选择流程名称！');
				return;
			}
			sParaString = "FlowName"+","+obj.value;
			sReturn =setObjectValue("SelectPhaseByFlowName",sParaString,"",0,0,"");
			if(typeof(sReturn) == "undefined" || sReturn == "_CANCEL_"){
				return;
			}else if(sReturn == "_CLEAR_"){
				oMyObj.value = "";
				//oMyObj2.value = "";
			}else{				
				sReturns = sReturn.split("@");
				//oMyObj2.value=sReturns[0];
				oMyObj.value=sReturns[1];
			}
		}else if(sFilterID=="5"){		
			sParaString = "OrgID,<%=CurOrg.getOrgID()%>";
			sReturn =setObjectValue("SelectBelongOrg",sParaString,"",0,0,"");
			if(typeof(sReturn) == "undefined" || sReturn == "_CANCEL_"){
				return;
			}else if(sReturn == "_CLEAR_"){
				oMyObj.value = "";
				//oMyObj2.value = "";
			}else{				
				sReturns = sReturn.split("@");
				//oMyObj2.value=sReturns[0];
				oMyObj.value=sReturns[1];
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