<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%@page import="com.amarsoft.app.als.process.util.ProcessHelp,
                java.util.Map,
                com.amarsoft.app.als.process.action.BusinessProcessAction,
                " %>
<%
	String sBusinessTaskID = CurPage.getParameter("BusinessTaskID");   			//任务流水号
	String sProcessTaskID = CurPage.getParameter("ProcessTaskID");     			//流程引擎任务流水号
	String sProcessDefID = CurPage.getParameter("ProcessDefID");       			//流程定义编号,FlowNo
	String sApplyNo = CurPage.getParameter("ApplyNo");     			   			//申请编号
	String sApplyType = CurPage.getParameter("ApplyType");   		   			//申请类型
	String sBizProcessObjectID = CurPage.getParameter("BizProcessObjectID");    //流程对象流水号
	String sPhaseNo = CurPage.getParameter("PhaseNo"); 							//阶段编号
	
	if(sBusinessTaskID == null) sBusinessTaskID = "";
	if(sProcessTaskID == null) sProcessTaskID = "";
	if(sProcessDefID == null) sProcessDefID = "";
	if(sApplyNo == null) sApplyNo = "";
	if(sApplyType == null) sApplyType = "";
	if(sBizProcessObjectID == null) sBizProcessObjectID = "";
	if(sPhaseNo == null) sPhaseNo = "";
	//机构信息
	String sUserID = CurUser.getUserID();//用户ID
	ASUserObject asCurUser = ASUserObject.getUser(sUserID);
	String sOrgType = asCurUser.getOrgType();
	//授权参数设置
	CRProcessPower power = new CRProcessPower(sApplyNo,CurUser.getOrgID(),sUserID); 
	String powerParam = power.powerParam();
	BusinessProcessAction bpAction = new BusinessProcessAction();
	bpAction.setProcessTaskID(sProcessTaskID);
	bpAction.setRelativeData("POWER_01="+powerParam+"@"+"CREDIT.ORGTYPE="+sOrgType);
	String sResult = bpAction.setProcessObject();
	if("SUCCESS".equals(sResult)){
		System.out.println("参数传递成功！");
	}
	
	
	
	//取得提交动作列表
	BusinessTaskAction btAction = new BusinessTaskAction();
	Map<String, String> actions = btAction.getTaskActions(sProcessDefID,sProcessTaskID,sUserID,Sqlca);
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
<table width="100%" align="center">
	<tr>
		<td width="100%"  valign="top" >
	 		<table>
				<tr>
					<td width="50%" align="right"><%=new Button("提交","确认提交","javascript:commitAction();","","btn_icon_Submit","").getHtmlText()%></td>	
					<td width="50%" align="center"><%=new Button("放弃","放弃提交","javascript:doCancel();","","btn_icon_delete","").getHtmlText()%></td>
				</tr>
   			</table>
	    </td>
	</tr>
	<tr>
		<td><font color="#000000"><b>请选择下一阶段提交动作：</b></font></td>
	</tr>
	<tr>
		<td>
			<table width="100%">							
				<tr>
					<td>
						<select size=5 style="width:100%;" name="PhaseOpinion" id="Opinion1" class="select1" onchange="doActionList();">
							<option value=''></option>
								<%=ProcessHelp.generateDropDownSelect(actionValues,actionNames,"")%>
						</select>
				 </td>
				</tr>							
			</table>
		</td>
	</tr>
</table>
<table width="100%" align="center" id="selectlist">
	<tr>
		<td><font color="#000000"><b>请选择下一阶段提交意见：</b></font></td>
	</tr>
	<tr>
		<td>
			<table width="100%">
				<tr>
					<td>
						<select size=5 style="width:100%;" name="PhaseAction"  onChange="getNextPaseInfo(2);">
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
		<td align="center"><b><span id="nextPaseInfo" style="color: #FF0000" ></span></b></td>
	</tr>
</table>
</form>
</body>
<script type="text/javascript">		
	var bActionReqiured = true;	//是否需要选择动作（如果为退回一类的，就不需要选择下一步Action了)
	
	/*~[Describe=页面加载后，初始化操作;InputParam=无;OutPutParam=无;]~*/
	$(document).ready(function(){
		document.getElementById("selectlist").style.display = "none";//隐藏动作选择框
		document.onkeydown = function(){
			if(event.keyCode==27){
				top.returnValue = "_CANCEL_"; 
				top.close();
			}
		};
	});
	
	/*~[Describe=取消提交;InputParam=无;OutPutParam=无;]~*/
	function doCancel(){
		if(confirm("您确定要放弃此次提交吗？")){
			//撤消刚才的选择操作
			document.forms["Phase"].elements["PhaseOpinion"].value = "";
			document.getElementById("selectlist").style.display = "none";
			document.forms["Phase"].elements["PhaseAction"].value = "";
			document.getElementById("nextPaseInfo").innerHTML="";
			top.returnValue = "_CANCEL_";
			top.close();
		}
	}

	/*~[Describe=控制动作选择窗口;InputParam=无;OutPutParam=无;]~*/
	function doActionList(){
		var thisPhaseOpinion = "";	
		var thisPhaseAction  = "";
		var objPhaseOpinion = document.forms["Phase"].elements["PhaseOpinion"];
		iLength =  objPhaseOpinion.length;	//取可供选择的意见个数
		for(i = 0;i <= iLength - 1;i++){
			var stdItem = objPhaseOpinion.item(i);	//取被选择的意见的对象
			document.getElementById("nextPaseInfo").innerHTML="";//先清除下一阶段信息
			if (stdItem.selected){
				var vItem = stdItem.text;	//取出被选择的意见
				if(vItem != ""){
					if(true){
						document.getElementById("selectlist").style.display = "none";
		    			bActionReqiured = true;
		    			getNextPaseInfo(1);	//找下一阶段信息
					}
				}else{
					document.getElementById("selectlist").style.display = "none";
				}
			}
		}
	}
	/*~[Describe=获取下一阶段信息;InputParam=type 0表示意见触发,1表示动作触发;OutPutParam=无;]~*/
	function getNextPaseInfo(type){
		var objPhaseOpinion = document.forms["Phase"].elements["PhaseOpinion"];
		var phaseOpinion =  objPhaseOpinion.options[objPhaseOpinion.selectedIndex].text;	//获取意见
		var phaseOpinionvalue =  objPhaseOpinion.value;									//获取意见参数
		var phaseAction =  document.forms["Phase"].elements["PhaseAction"].value;			//获取动作
		document.getElementById("nextPaseInfo").innerHTML="";
		if(phaseAction==""){
			document.forms["Phase"].elements["PhaseAction"].value = "";
		}
		//如果为选择意见触发此函数，则需要通过ajax去获取意见列表
		if(type == 1){
			var sActionList = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessActivityAction","getTaskParticipants",
												 "UserID=<%=sUserID%>,ProcessAction="+phaseOpinionvalue+",ProcessDefID=<%=sProcessDefID%>,ProcessTaskID=<%=sProcessTaskID%>");
			var thisPhaseOpinion = getPaseOpinion();		
			if(sActionList.length == 4 && thisPhaseOpinion.substring(0,3)!="End"){
				alert("下一阶段没有处理人，不能提交！");
				return;
			}
			var sFlag = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessActivityAction","getNextState",
					 							 "UserID=<%=sUserID%>,ProcessAction="+phaseOpinionvalue+",ProcessDefID=<%=sProcessDefID%>,ProcessTaskID=<%=sProcessTaskID%>");
			
			genActionList(sActionList,sFlag);
		}

		phaseOpinion = getPaseOpinion();		//获取选择的意见
		phaseAction = getPaseAction();			//获取选择的动作
		if(!phaseOpinion ||(!phaseAction && (phaseOpinion.indexOf("同意")>0 || phaseOpinion.indexOf("否决")>0 || phaseOpinion.indexOf("再议") || phaseOpinion.indexOf("任务池")>0 || phaseOpinion.indexOf("提交")>0))){			
			//alert("请先进行提交意见选择 !");
			document.getElementById("nextPaseInfo").innerHTML="";
		}else{
			document.getElementById("nextPaseInfo").innerHTML = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessActivityAction",
																		"getNextActivityInfo",
																		"ProcessTaskID=<%=sProcessTaskID%>,ProcessAction="+phaseOpinionvalue+",ProcessDefID=<%=sProcessDefID%>,ProcessOpinion="+phaseAction);
		}
	}
	
	/*~[Describe=生成意见列表;InputParam= 如：{{test11 系统管理员},{test11 普通用户}};OutPutParam=无;]~*/
	function genActionList(action,flag){
		sActionList = eval('new Array('+action+')');
		oSelect = document.forms["Phase"].elements["PhaseAction"];
		if(flag=="CounterSign"){oSelect.multiple=true;}
		if(flag=="Task"){oSelect.multiple=false;}
		oSelect.options.length = 1;
		for(var i=0;i<sActionList.length;i++){
			var oOption = new Option(sActionList[i],sActionList[i]);
			//if(i== 0)oOption.selected = true;//默认选中第一项
			oSelect.options.add(oOption);
		}
	}
	
	/*~[Describe=获取选择的意见;InputParam=无;OutPutParam=无;]~*/
	function getPaseOpinion(){
		var phaseOpinion = "";
		var objPhaseOpinion = document.forms["Phase"].elements["PhaseOpinion"];
		iLength = objPhaseOpinion.length;
		for (i = 0; i <= iLength - 1; i++) {
			var oItem = objPhaseOpinion.item(i);	//获取意见选项
			if (oItem.selected) {
				if (oItem.value != "") {
					phaseOpinion += ","+ oItem.value;
				}
			}
		}
		return phaseOpinion.substring(1);//去除第一位上的逗号
	}

	/*~[Describe=获取选择的动作;InputParam=无;OutPutParam=无;]~*/
	function getPaseAction(){
		var objPhaseAction = document.forms["Phase"].elements["PhaseAction"];
		var phaseAction = "";
		iLength = objPhaseAction.length;	//获取动作列表选择项长度
		for (i = 0; i <= iLength - 1; i++) {
			var oItem = objPhaseAction[i];
			if (oItem.selected) {
				if (oItem.value != "") {
					phaseAction += ";"+ oItem.value;
				}
			}
		}
		return phaseAction.substring(1);	//去除第一位上的逗号
	}

	/*~[Describe=提交任务;InputParam=无;OutPutParam=无;]~*/
	function commitAction(){
		var PhaseNo = "<%=sPhaseNo%>";
		var thisPhaseAction  = "";
		var thisPhaseOpinion = "";
		thisPhaseAction = getPaseAction();			
		thisPhaseOpinion = getPaseOpinion();
		thisPhaseOpinion = thisPhaseOpinion.split("@")[0];																									
		// 下一阶段没有处理人不允许提交
		var objPhaseOpinion = document.forms["Phase"].elements["PhaseOpinion"];
		if(objPhaseOpinion.selectedIndex=="-1")return;
		var phaseOpinion =  objPhaseOpinion.options[objPhaseOpinion.selectedIndex].text;	//获取意见
		var phaseOpinionvalue =  objPhaseOpinion.value;
		var sActionList = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessActivityAction","getTaskParticipants",
				"UserID=<%=sUserID%>,ProcessAction="+phaseOpinionvalue+",ProcessDefID=<%=sProcessDefID%>,ProcessTaskID=<%=sProcessTaskID%>");
		if(sActionList.length == 4 && thisPhaseOpinion.substring(0,3)!="End"){
			alert("下一阶段没有处理人，不能提交！");
			return;
		}						
		if(thisPhaseOpinion.length == 0){				
			alert("请先进行提交动作选择 !");
		}else if(false) {
			alert("请先进行提交意见选择 !");
		}else if (thisPhaseAction == '<%=CurUser.getUserID()%>'){
			alert("提交对象不能为当前用户！");
			return;
		}else{			
			if (confirm("该笔业务的"+document.getElementById("nextPaseInfo").innerHTML+"\r\n你确定提交吗？")){
				var sReturn = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessProcessAction",
												 	  "commit",
												 	  "bizProcessObjectID=<%=sBizProcessObjectID%>,UserID=<%=CurUser.getUserID()%>,ProcessTaskID=<%=sProcessTaskID%>,ProcessDefID=<%=sProcessDefID%>,ApplyNo=<%=sApplyNo%>,ApplyType=<%=sApplyType%>,BizProcessTaskID=<%=sBusinessTaskID%>,ProcessAction="+thisPhaseOpinion+",TaskParticipants="+thisPhaseAction+",PhaseNo="+PhaseNo);   				
				self.returnValue = sReturn;				
		        self.close();
			}
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>