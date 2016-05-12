<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.app.als.process.util.ProcessHelp,
                com.amarsoft.app.als.process.action.BusinessProcessAction,
                java.util.Map,
                com.amarsoft.are.jbo.BizObject,
                com.amarsoft.are.lang.StringX,
                com.amarsoft.app.als.process.action.BusinessProcessConst" %>
<%
	String sBusinessTaskID = CurPage.getParameter("SerialNo");   				//任务流水号
	String sNextFlowState = CurPage.getParameter("NextFlowState");				//下一阶段流程状态
	if(StringX.isSpace(sBusinessTaskID)) sBusinessTaskID = "";
	//if(StringX.isSpace(sNextFlowState)) sNextFlowState = "";
	BizObject task = com.amarsoft.app.als.process.action.GetApplyParams.getFlowTaskParams(sBusinessTaskID);
	String sProcessTaskID = task.getAttribute("ProcessTaskNo").getString();     //流程引擎任务流水号
	String sProcessDefID = task.getAttribute("FlowNo").getString();				//流程定义编号,FlowNo
	String sObjectNo = task.getAttribute("ObjectNo").getString();		   		//申请编号
	String sObjectType = task.getAttribute("ObjectType").getString();		   		//申请编号
	String sApplyType = task.getAttribute("ApplyType").getString();	   			//申请类型
	String sBizProcessObjectID = task.getAttribute("RelativeObjectNo").getString();//流程对象流水号
	String sPhaseNo = task.getAttribute("PhaseNo").getString();					//阶段编号
	String sCurFlowState = task.getAttribute("FlowState").getString();			//当前阶段流程状态
	String sUserID = CurUser.getUserID();										//当前用户ID
	
	if(StringX.isSpace(sProcessTaskID)) sProcessTaskID = "";
	if(StringX.isSpace(sObjectNo)) sObjectNo = "";
	if(StringX.isSpace(sApplyType)) sApplyType = "";
	if(StringX.isSpace(sBizProcessObjectID)) sBizProcessObjectID = "";
	if(StringX.isSpace(sPhaseNo)) sPhaseNo = "";
	if(StringX.isSpace(sCurFlowState)) sCurFlowState = "";
	
	System.out.println("sBizProcessObjectID="+sBizProcessObjectID);
	System.out.println("sProcessTaskID="+sProcessTaskID);
	System.out.println("sProcessDefID="+sProcessDefID);
	System.out.println("sBusinessTaskID="+sBusinessTaskID);
	
	//预先设置授权标识进流程，用来进行动作选择判断
	BusinessProcessAction bpAction = new BusinessProcessAction();
	bpAction.setProcessTaskID(sProcessTaskID);
	bpAction.setRelativeData("ALS.POWER=1");
	String sResult = bpAction.setProcessObject();
	if("SUCCESS".equals(sResult)){
		System.out.println("设置授权标识成功");
	}
	
	//对贷审会主任和一票否决人特殊处理
	if(BusinessProcessConst.FLOWSTATE_VOTE.equals(sCurFlowState)){
		//sPhaseNo = "";//贷审会秘书提交会签任务是阶段流程号置空，已反应到流程引擎，待其修改，修改后该置空可删掉2011/08/30
		//sNextFlowState = BusinessProcessConst.FLOWSTATE_MCHECK;
	}
	if(BusinessProcessConst.FLOWSTATE_MCHECK.equals(sCurFlowState)){
		sNextFlowState = BusinessProcessConst.FLOWSTATE_MAPPROVE;
	}

	//取得提交动作列表
	Map<String, String> actions = bpAction.getTaskActions(sProcessDefID,sProcessTaskID,sUserID,Sqlca);
	String[] actionNames = (String[])actions.keySet().toArray(new String[actions.size()]);
	String[] actionValues = (String[])actions.values().toArray(new String[actions.size()]);

	for(int i = 0; i < actionValues.length; i++){
		actionValues[i] = actionValues[i].replace(',','@');
	}
	if(actionNames == null){
		actionNames = new String[1];
		actionNames[0] = "";
	}
%>
<style>
body{ margin:0; padding:0;background:url(<%=sWebRootPath%>/AppMain/resources/images/tab_tit_bg.jpg) repeat-x;}
</style>
<body leftmargin="0" topmargin="0" onload=""  text="#000000">
<form name="Phase" method="post" target="_top">
<table width="100%" align="center"  >
	<tr>
		<td width="100%"  valign="top" >
	 		<table>
				<tr>
					<td><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","提  交","提交","javascript:commitAction()",sResourcesPath)%></td>
					<td><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","放  弃","放弃","javascript:doCancel()",sResourcesPath)%></td>	
				</tr>
   			</table>
	    </td>
	</tr>
	<tr>
		<!-- <td><input id="smsFlag" type="checkbox" />是否短信通知</td> -->	
	</tr>
	<tr>
		<td><font color="#000000"><b>请选择下一阶段提交动作：</b></font></td>
	</tr>
	<tr>
		<td>
			<table width="100%" id="list">							
				<tr>
					<td>
						<select size=5 style="width:100%;" name="PhaseAction" class="select1" onchange="doActionList();">
							<option value=''></option>
								<%=ProcessHelp.generateDropDownSelect(actionValues,actionNames,"")%>
						</select>
				 </td>
				</tr>							
			</table>
		</td>
	</tr>
</table>
<table width="100%" align="center" id="forklist">
	<tr>
		<td><font color="#000000"><b>请选择下一并行阶段提交动作(所有分支必须双击人员选择各自分支的提交人员)：</b></font></td>
	</tr>
	<tr>
		<td>
			<table width="100%">							
				<tr>
					<td>
						<select size=5 style="width:100%;" name="ForkAction" class="select1" onchange="doForkActionList();" >
							<option value=''></option>
						</select>
				 </td>
				</tr>							
			</table>
		</td>
	</tr>
</table>
<table width="100%" align="center" id="selectlist">
	<tr>
		<td><font color="#000000"><b>请选择下一阶段提交人员：</b></font></td>
	</tr>
	<tr>
		<td>
			<table width="100%">
				<tr>
					<td>
						<select size=5 style="width:100%;" name="PhaseUser"  onChange="getNextPhaseInfo(2);" ondblclick="addUser()">
							<option value=''></option>
						</select>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<table width="100%" align="center">
    <tr>
		<td align="center"><b><span id="nextPhaseInfo" style="color: #FF0000" ></span></b></td>
	</tr>
</table>
</form>
</body>
<script type="text/javascript">
	var bActionReqiured = true;	//是否需要选择动作（如果为退回一类的，就不需要选择下一步Action了)
	
	/*~[Describe=页面加载后，初始化操作;InputParam=无;OutPutParam=无;]~*/
	$(document).ready(function(){
		document.getElementById("selectlist").style.display = "none";//隐藏提交人员选择框
		document.getElementById("forklist").style.display = "none";  //隐藏分支动作选择框
		document.onkeydown = function(){
			if(event.keyCode==27){
				top.returnValue = "_CANCEL_";
				top.close();
			}
		};
	});

	function nextStep(){
		document.getElementById("selectlist").style.display = "none";
		document.getElementById("forklist").style.display = "none";
		document.getElementById("list").style.display = "none";
	}
	
	/*~[Describe=给并行流程分支添加人员;InputParam=无;OutPutParam=无;]~*/
	function addUser(){
		var userInfo = document.forms["Phase"].elements["PhaseUser"].value;
		var obj = document.forms["Phase"].elements["ForkAction"];
		if(obj.value!="" && obj.value!="undefined" && userInfo.split(" ")[0]!="undefined" && userInfo.split(" ")[0]!=""){
			var userName = "["+userInfo.split(" ")[1]+"]";
			var userID = "@"+userInfo.split(" ")[0];
			var actionName = obj.options[obj.selectedIndex].text;
			var actionValue = obj.options[obj.selectedIndex].value;
			if(actionName.indexOf(userName)>0){
				actionName = actionName.replace(userName,"");
				actionValue = actionValue.replace(userID,"");
			}else{
				actionName = actionName + userName;
				actionValue = actionValue + userID;
			}
			obj.options[obj.selectedIndex].text = actionName;
			obj.options[obj.selectedIndex].value = actionValue;
		}
	}
	
	/*~[Describe=取消提交;InputParam=无;OutPutParam=无;]~*/
	function doCancel(){
		if(confirm("您确定要放弃此次提交吗？")){
			//撤消刚才的选择操作
			document.forms["Phase"].elements["PhaseAction"].value = "";
			document.getElementById("selectlist").style.display = "none";
			document.forms["Phase"].elements["PhaseUser"].value = "";
			document.getElementById("nextPhaseInfo").innerHTML="";
			top.returnValue = "_CANCEL_";
			top.close();
		}
	}

	/*~[Describe=控制动作选择窗口;InputParam=无;OutPutParam=无;]~*/
	function doActionList(){
		var oPhaseAction = document.forms["Phase"].elements["PhaseAction"];
		iLength =  oPhaseAction.length;	//取可供选择的动作个数
		for(var i = 0;i < iLength;i++){
			var oItem = oPhaseAction.item(i);	//取被选择的动作的对象
			if (oItem.selected){
				var itemName = oItem.text;		//取出被选择的动作文字
				var itemValue = oItem.value;	//取出被选择的动作值
				if(itemValue != "" && itemName != ""){
					if(itemValue.search("End") >= 0){
						document.getElementById("selectlist").style.display = "none";
		    			bActionReqiured = false;
		    			getNextPhaseInfo(1);	//找下一阶段信息
					}
					if(itemValue.search("Task") >= 0 || itemValue.search("CounterSign") >= 0 || itemValue.search("Join") >= 0){
						document.getElementById("selectlist").style.display = "";
						document.getElementById("forklist").style.display = "none";
						var size = document.forms["Phase"].elements["ForkAction"].options.length;
						for(var j=size-1;j>0;j--){
							document.forms["Phase"].elements["ForkAction"].options.remove(j);
						}
		    			bActionReqiured = true;
		    			getNextPhaseInfo(1);	//找下一阶段信息
					}
					if(itemValue.search("Fork") >= 0){
						document.getElementById("selectlist").style.display = "none";
						document.getElementById("forklist").style.display = "";
		    			bActionReqiured = true;
		    			var phaseAction = document.forms["Phase"].elements["PhaseAction"].value;	//获取选择的动作							
		    			var forkAction = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessProcessAction","getForkActions",
	 							 "ProcessDefID=<%=sProcessDefID%>,ProcessTaskID=<%=sProcessTaskID%>"+",PhaseNo="+phaseAction);
		    			genForkList(forkAction);
					}
				}else{
					document.getElementById("nextPhaseInfo").innerHTML="";//清除下一阶段信息
					document.getElementById("selectlist").style.display = "none";
					document.getElementById("forklist").style.display = "none";
				}
			}
		}
	}
	
	/*~[Describe=控制分支动作选择窗口;InputParam=无;OutPutParam=无;]~*/
	function doForkActionList(){
		var oForkAction = document.forms["Phase"].elements["ForkAction"];
		iLength =  oForkAction.length;	//取可供选择的动作个数
		for(var i = 0;i <= iLength - 1;i++){
			var oItem = oForkAction.item(i);	//取被选择的动作的对象
			document.getElementById("nextPhaseInfo").innerHTML="";//先清除下一阶段信息
			if (oItem.selected){
				var itemName = oItem.text;	//取出被选择的动作文字
				var itemValue = oItem.value;	//取出被选择的动作值
				if(itemValue != "" && itemName != ""){
					if(itemValue.search("Task") >= 0 || itemValue.search("CounterSign") >= 0){
						document.getElementById("selectlist").style.display = "";
						document.getElementById("forklist").style.display = "";
		    			bActionReqiured = true;
		    			getNextForkPhaseInfo(1);	//找下一阶段人员信息
					}
				}else{
					document.getElementById("selectlist").style.display = "none";
				}
			}
		}
	}

	/*~[Describe=获取下一阶段信息;InputParam=type 0表示意见触发,1表示动作触发;OutPutParam=无;]~*/
	function getNextForkPhaseInfo(type){
		var oForkAction = document.forms["Phase"].elements["ForkAction"];			//获取动作对象
		var forkActionValue =  oForkAction.value;									//获取动作参数
		var PhaseUser =  document.forms["Phase"].elements["PhaseUser"].value;		//获取人员
		
		document.getElementById("nextPhaseInfo").innerHTML="";		//清除下一阶段信息
		if(PhaseUser==""){
			document.forms["Phase"].elements["PhaseUser"].value = "";
		}

		var forkActionValue = forkActionValue.split("@")[0]; //带上用户后仍取第一个阶段编号
		if(type == 1){
			var PhaseNo = "<%=sPhaseNo%>";
			var sUserID = "<%=CurUser.getUserID()%>";
			var sOrgID  = "<%=CurUser.getOrgID()%>";
			
			//获取人员列表
			var sUserList = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessProcessAction","getTaskParticipants",
												 "UserID="+sUserID+",ProcessAction="+forkActionValue+",ProcessDefID=<%=sProcessDefID%>,ProcessTaskID=<%=sProcessTaskID%>");
		 	//获取多选标识
			var sFlag = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessProcessAction","getNextState",
					 							 "UserID="+sUserID+",ProcessAction="+forkActionValue+",ProcessDefID=<%=sProcessDefID%>,ProcessTaskID=<%=sProcessTaskID%>");
			//生成生成人员列表
			genUserList(sUserList,sFlag);
		}
		
		//设置下一阶段信息
		var phaseAction = document.forms["Phase"].elements["PhaseAction"].value;	//获取分支动作
		var nextPhaseInfo = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessProcessAction",
								"getNextActivityInfo","ProcessTaskID=<%=sProcessTaskID%>,ProcessAction="+phaseAction+",ProcessDefID=<%=sProcessDefID%>,TaskParticipants="+PhaseUser);
		document.getElementById("nextPhaseInfo").innerHTML = nextPhaseInfo;
	}
	
	/*~[Describe=获取下一阶段信息;InputParam=type 0表示意见触发,1表示动作触发;OutPutParam=无;]~*/
	function getNextPhaseInfo(type){
		var oPhaseAction = document.forms["Phase"].elements["PhaseAction"];			//获取动作对象
		var phaseActionValue =  oPhaseAction.value;									//获取动作参数
		var phaseUser =  document.forms["Phase"].elements["PhaseUser"].value;		//获取人员
		
		document.getElementById("nextPhaseInfo").innerHTML="";		//清除下一阶段信息
		if(phaseUser==""){
			document.forms["Phase"].elements["PhaseUser"].value = ""; 
		}
		
		if(type==1){
			var PhaseNo = "<%=sPhaseNo%>";
			var sUserID = "<%=CurUser.getUserID()%>";
			var sOrgID  = "<%=CurUser.getOrgID()%>";
			
			//获取人员列表
			var sUserList = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessProcessAction","getTaskParticipants",
					 	"UserID="+sUserID+",ProcessAction="+phaseActionValue+",ProcessDefID=<%=sProcessDefID%>,ProcessTaskID=<%=sProcessTaskID%>");
		 	//获取多选标识
			var sMultipleFlag = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessProcessAction","getNextState",
					 	"UserID="+sUserID+",ProcessAction="+phaseActionValue+",ProcessDefID=<%=sProcessDefID%>,ProcessTaskID=<%=sProcessTaskID%>");
			//生成生成人员列表
			genUserList(sUserList,sMultipleFlag);
		}

		//设置下一阶段信息
		var sNextPhaseInfo = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessProcessAction",
						"getNextActivityInfo","ProcessTaskID=<%=sProcessTaskID%>,ProcessAction="+phaseActionValue+",ProcessDefID=<%=sProcessDefID%>,TaskParticipants="+phaseUser);
		$("#nextPhaseInfo").html(sNextPhaseInfo);
		//document.getElementById("nextPhaseInfo").innerHTML = sNextPhaseInfo;
	}
	
	/*~[Describe=生成人员列表;InputParam= 如：{{test11 系统管理员},{test11 普通用户}};OutPutParam=无;]~*/
	function genUserList(action,flag){
		sUserList = eval('new Array('+action+')');
		oSelect = document.forms["Phase"].elements["PhaseUser"];
		if(flag=="CounterSign"){oSelect.multiple=true;}
		if(flag=="Task"){oSelect.multiple=false;}
		oSelect.options.length = 1;
		for(var i=0;i<sUserList.length;i++){
			var oOption = new Option(sUserList[i],sUserList[i]);
			var sUserID = "<%=sUserID%>";
			//if(i== 0)oOption.selected = true;//默认选中第一项
			if(oOption.text.indexOf(sUserID)<0){
				oSelect.options.add(oOption);
			}
		}
	}

	/*~[Describe=生成分支列表;InputParam= 如：{{test11 系统管理员},{test11 普通用户}};OutPutParam=无;]~*/
	function genForkList(action){
		sForkList = eval('new Array('+action+')');
		oSelect = document.forms["Phase"].elements["ForkAction"];
		oSelect.options.length = 1;
		var i=0;
		while (i < sForkList.length){
			var oOption = new Option(sForkList[i],sForkList[i+1]);
			var sUserID = "<%=sUserID%>";
			//if(i== 0)oOption.selected = true;//默认选中第一项
			if(oOption.text.indexOf(sUserID)<0){
				oSelect.options.add(oOption);
			}
			i = i + 2;
		}
	}
	
	/*~[Describe=获取选择的意见;InputParam=无;OutPutParam=无;]~*/
	function getPhaseAction(){
		var PhaseAction = "",phaseOpinionName = "";
		var objPhaseOpinion = document.forms["Phase"].elements["PhaseAction"];
		iLength = objPhaseOpinion.length;
		for (i = 0; i <= iLength - 1; i++) {
			var oItem = objPhaseOpinion.item(i);	//获取意见选项
			if (oItem.selected) {
				if (oItem.value != "") {
					PhaseAction += ","+ oItem.value;
					phaseOpinionName += "," +oItem.text;
				}
			}
		}
		return PhaseAction.substring(1)+"@"+phaseOpinionName.substring(1);//去除第一位上的逗号
	}

	/*~[Describe=获取选择的动作;InputParam=无;OutPutParam=无;]~*/
	function getPhaseUser(){
		var oPhaseUser = document.forms["Phase"].elements["PhaseUser"];
		var phaseUser = "";
		iLength = oPhaseUser.length;	//获取动作列表选择项长度
		for (i = 0; i <= iLength - 1; i++) {
			var oItem = oPhaseUser[i];
			if (oItem.selected) {
				if (oItem.value != "") {
					phaseUser += ";"+ oItem.value;
				}
			}
		}
		return phaseUser.substring(1);	//去除第一位上的逗号
	}

	/*~[Describe=提交任务;InputParam=无;OutPutParam=无;]~*/
	function commitAction(){
		var PhaseNo = "<%=sPhaseNo%>";
		var NextFlowState = "<%=sNextFlowState%>";
		var sUserID = "<%=CurUser.getUserID()%>";
		var sOrgID = "<%=CurUser.getOrgID()%>";
		var thisPhaseOpinion  = "";
		var thisPhaseAction = "";

		var oForkAction = document.forms["Phase"].elements["ForkAction"];
		iLength = oForkAction.length;
		for (var i = 1; i <= iLength - 1; i++) {
			var oItemValue = oForkAction.item(i).value;	//获取分支动作值
			var oItemName = oForkAction.item(i).text;	//获取分支动作文本
			if((oItemValue.split("@").length<2)){
				alert("请给["+oItemName+"]添加提交人员");
				return;
			}
		}

		thisPhaseAction = getPhaseAction();
		thisPhaseAction = thisPhaseAction.split("@")[0];
		//alert("PhaseAction:"+thisPhaseAction);

		//判断是否是分支节点提交，是则按照分支人员组合方式，否则按照正常提交组合方式。
		if(thisPhaseAction.search("Fork")>= 0){
			var oForkAction = document.forms["Phase"].elements["ForkAction"];
			iLength = oForkAction.length;
			for (var i = 1; i <= iLength - 1; i++) {
				var oItemValue = oForkAction.item(i).value;	//获取分支动作值
				var oItemName = oForkAction.item(i).text;	//获取分支动作文本
				//alert(oItemValue);
				thisPhaseOpinion = thisPhaseOpinion+oItemValue+"-";
			}
			thisPhaseOpinion = thisPhaseOpinion.substring(0,thisPhaseOpinion.length-1);
			//alert(thisPhaseOpinion);
		}else{
			thisPhaseOpinion = getPhaseUser();	
			//alert("PhaseOpinion:"+thisPhaseOpinion);
		}
		
		if(thisPhaseAction.length == 0){				
			alert("请先进行提交动作选择 !");
		}else if(thisPhaseOpinion.length==0 && bActionReqiured) {
		    alert("请先进行提交人员选择 !");
		}else if (thisPhaseOpinion == '<%=CurUser.getUserID()%>'){
			alert("提交对象不能为当前用户！");
			return;
		
		}else{	
			if (confirm("该笔业务的"+document.getElementById("nextPhaseInfo").innerHTML+"\r\n你确定提交吗？")){
				var sReturn = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessProcessAction",
												 	  "commit",
												 	  "bizProcessObjectID=<%=sBizProcessObjectID%>,ProcessTaskID=<%=sProcessTaskID%>,ProcessDefID=<%=sProcessDefID%>,ObjectNo=<%=sObjectNo%>,ObjectType=<%=sObjectType%>,ApplyType=<%=sApplyType%>,BizProcessTaskID=<%=sBusinessTaskID%>,ProcessAction="+thisPhaseAction+",TaskParticipants="+thisPhaseOpinion+",PhaseNo="+PhaseNo+",ProcessState="+NextFlowState+",UserID="+sUserID+",OrgID="+sOrgID);   				
				/* if (sReturn == "SUCCESS"){
					if(document.getElementById("smsFlag").checked){
						Recipient = thisPhaseOpinion.split(" ")[0]; //下阶段人员
						sSubject = "审批任务提醒";
						sBody = "您目前有审批任务，请注意查阅！";
						RunJavaMethod("com.amarsoft.app.msg.action.SendSMS","sendSMS","Recipient="+sUserID+",Subject="+sSubject+",Body="+sBody);
					}
				} */
				top.returnValue = sReturn;				
		        top.close();
			}
		}
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>