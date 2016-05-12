<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.biz.workflow.*" %>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
<%
	/*
		Author: byhu 2004-12-06 
		Tester:
		Describe: 提交选择框
		Input Param:
			SerialNo：任务流水号
		Output Param:
		HistoryLog: zywei 2005/08/01
								syang 2009/10/15 使用ajax改写页面，意见与动作联动起来
	 */
%>
<%/*~END~*/%> 


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<% 
	//获取参数：任务流水号
	String sSerialNo = CurPage.getParameter("SerialNo");//从上个页面得到传入的任务流水号
	String oldPhaseNo = CurPage.getParameter("oldPhaseNo");//当前被提交业务所处阶段
	String objectType = CurPage.getParameter("objectType");//当前被提交业务所处流程中的流程对象类型
	String objectNo = CurPage.getParameter("objectNo");//当前被提交业务所处流程中的流程对象编号
	//定义变量：流程编号、阶段编号、对象编号
	String sFlowNo = "",sPhaseNo = "";
	
	//定义变量：动作、动作列表、阶段的类型、动作提示、阶段的属性
	String sSelectStyle = "",sPhaseAttribute = "",sPhaseOpinion1[]; 
	String sSql="";
	ASResultSet rsTemp = null;
%>
<%/*~END~*/%>	


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义业务逻辑主体;]~*/%>
<%	
	//从任务流程表FLOW_TASK中查询出流程编号、阶段编号
	sSql = "select FlowNo,PhaseNo from FLOW_TASK where SerialNo = :SerialNo ";
	rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
	if (rsTemp.next()){
		sFlowNo  = DataConvert.toString(rsTemp.getString("FlowNo"));
		sPhaseNo  = DataConvert.toString(rsTemp.getString("PhaseNo"));
		
		//将空值转化成空字符串
		if(sFlowNo == null) sFlowNo = "";
		if(sPhaseNo == null) sPhaseNo = "";				
	}
	rsTemp.getStatement().close();
	
	//从流程模型表FLOW_MODEL中查询出阶段属性、阶段描述
	sSql = "select PhaseAttribute,ActionDescribe from FLOW_MODEL where FlowNo = :FlowNo and PhaseNo = :PhaseNo";
	rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("FlowNo",sFlowNo).setParameter("PhaseNo",sPhaseNo));
	if (rsTemp.next()){
		sPhaseAttribute  = DataConvert.toString(rsTemp.getString("PhaseAttribute"));
		
		//将空值转化成空字符串
		if(sPhaseAttribute == null) sPhaseAttribute = "";
		if(sSelectStyle == null) sSelectStyle = "";
		sSelectStyle = StringFunction.getProfileString(sPhaseAttribute,"ActionStyle");
	}
	rsTemp.getStatement().close();
	rsTemp = null;

	//初始化任务对象
	FlowTask ftBusiness = new FlowTask(sSerialNo,Sqlca);

	sPhaseOpinion1 = ftBusiness.getChoiceList();
	if(sPhaseOpinion1 == null){
		sPhaseOpinion1 = new String[1];
		sPhaseOpinion1[0] = "";
	}
%>
<%/*~END~*/%>	


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义选择提交动作界面风格;]~*/%>
	<html>
	<head>
		<title>提交动作选择列表</title>
	</head>
	<body class="ShowModalPage" leftmargin="0" topmargin="0" onload="" >
	<form name="Phase" method="post" target="_top">
	<table width="100%" align="center">
		<tr width="100%" >
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
			<td>意见选择列表</td>
		</tr>
	    <tr height=1> 
		    <td colspan="5" valign="top" >
		    		<hr>
		    </td>
	    </tr>
		<tr>
			<td>
				<table>							
					<tr>
				 		<td valign="top" width=1><img src="<%=sResourcesPath%>/TN_031.gif" width="123" height="80"></td>
						<td colspan=4  width="100%">
							<select size=8 style="width:80%;" id="PhaseOpinion1"  class="select1" onchange="doActionList();">
								<option value=''></option>
									<%=HTMLControls.generateDropDownSelect(sPhaseOpinion1,sPhaseOpinion1,"")%>
							</select>
					 </td>
					</tr>							
				</table>
			</td>
		</tr>
	</table>
	<table width="100%" align="center" id="selectlist" style="visibility: hidden;">
		<tr>
			<td>动作选择列表</td>
		</tr>
		<tr height=1>
			<td colspan="5" valign="top"><hr></td>
		</tr>
		<tr>
			<td>
				<table>
					<tr>
						<td valign="top" width=1><img src="<%=sResourcesPath%>/TN_099.gif"  width="123" height="80"></td>
						<td colspan=4 width="100%">
							<select size=8 style="width:80%;" <%=sSelectStyle%> id="PhaseAction"  onChange="getNextPaseInfo(2);">
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
				<td align="center"><span id="nextPaseInfo" style="color: #FF0000" ></span></td>
			</tr>
	</table>
	</form>
	</body>
	</html>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">		

	var bActionReqiured = true;	//是否需要选择动作（如果为退回一类的，就不需要选择下一步Action了)
	
	window.onload = function(){
		initPage();
	}
	/*~[Describe=页面加载后，初始化操作;InputParam=无;OutPutParam=无;]~*/
	function initPage(){
		document.getElementById("selectlist").style.display = "none";//隐藏动作选择框
	}
	
	/*~[Describe=取消提交;InputParam=无;OutPutParam=无;]~*/
	function doCancel(){
		if(confirm("您确定要放弃此次提交吗？")){
			top.returnValue = "_CANCEL_";
			top.close();
		}
	}

	/*~[Describe=控制动作选择窗口;InputParam=无;OutPutParam=无;]~*/
	function doActionList(){
		var thisPhaseOpinion1 = "";	
		var thisPhaseAction  = "";
		<%-- var roleSubmit = RunJavaMethodSqlca("com.amarsoft.biz.workflow.FlowUtil","isRoleSubmit","FlowNo=<%=sFlowNo%>,PhaseNo=<%=sPhaseNo%>"); --%>
		
		iLength =  document.forms["Phase"].PhaseOpinion1.length;	//取可供选择的意见个数
		for(i = 0;i <= iLength - 1;i++){
			var stdItem = document.forms["Phase"].PhaseOpinion1.item(i);	//取被选择的意见的对象
			document.getElementById("nextPaseInfo").innerHTML="";//先清除下一阶段信息
			if (stdItem.selected){
				var vItem = stdItem.value;	//取出被选择的意见
				if(vItem != ""){
	    			document.getElementById("selectlist").style.display = "";
					if ( vItem.search("最终审批人") >= 0 ){
		    			bActionReqiured = true;
					}else{
						bActionReqiured = false;
					}
	    			
					var phaseOpinion1 = getPaseOpinion();		//获取选择的意见
					//得到提交人列表
					var sSerialNo = "<%=sSerialNo%>";
					var sActionList = PopPageAjax("/Common/WorkFlow/GetPhaseActionAjax.jsp?SerialNo=<%=sSerialNo%>&PhaseOpinion1="+phaseOpinion1);
					genActionList(sActionList);
					
					var phaseAction = getPaseAction();			//获取选择的动作
					
					//显示下一阶段
					var url="/Common/WorkFlow/GetNextFlowPhaseAJAX.jsp";
					url += "?SerialNo=<%=sSerialNo%>&PhaseAction="+ phaseAction + "&PhaseOpinion1=" + phaseOpinion1;
					document.getElementById("nextPaseInfo").innerHTML = PopPageAjax(url);
					
				}else{
						document.getElementById("selectlist").style.display = "none";
				}
			}
		}
	}
	/*~[Describe=获取下一阶段信息;InputParam=type 1表示意见触发,2表示动作触发;OutPutParam=无;]~*/
	function getNextPaseInfo(type){
		var phaseOpinion1 =  document.forms["Phase"].PhaseOpinion1.value;	//获取意见
		var phaseAction =  document.forms["Phase"].PhaseAction.value;			//获取动作
		
		if(phaseOpinion1.substring(0,2)=="同意" 
			|| phaseOpinion1.substring(0,2)=="提交" 
			|| phaseOpinion1.substring(0,2)=="补充" 
			|| phaseOpinion1.substring(0,2)=="重新"){//add by jgao1 2009-10-12 for 单项计提减值准备流程
			
			document.getElementById("nextPaseInfo").innerHTML="";
			if(phaseAction==""){
				document.forms["Phase"].PhaseAction.value = "";
			}
		}else{	//如果为退回一类的，清除其选择动作
			//document.forms["Phase"].PhaseAction.value = "";
		}
		
		//如果为选择意见触发此函数，则需要通过ajax去获取意见列表
		if(type == 1 || type == 3){
			var sSerialNo = "<%=sSerialNo%>";
			var sActionList = PopPageAjax("/Common/WorkFlow/GetPhaseActionAjax.jsp?SerialNo="+sSerialNo+"&PhaseOpinion1="+phaseOpinion1);
			genActionList(sActionList);
		}
		
		phaseOpinion1 = getPaseOpinion();		//获取选择的意见
		phaseAction = getPaseAction();			//获取选择的动作
		if(type != 3 && (phaseOpinion1.length == 0 ||(phaseAction==""  && (phaseOpinion1.substring(0,2)=="同意" || phaseOpinion1.substring(0,2)=="提交" || phaseOpinion1.substring(0,2)=="补充" || phaseOpinion1.substring(0,2)=="重新")))){				
			//alert("请先进行提交意见选择 !");
			document.getElementById("nextPaseInfo").innerHTML="";
		}else{
			var url="/Common/WorkFlow/GetNextFlowPhaseAJAX.jsp";
			url += "?SerialNo=<%=sSerialNo%>&PhaseAction="+ phaseAction + "&PhaseOpinion1=" + phaseOpinion1;
			document.getElementById("nextPaseInfo").innerHTML = PopPageAjax(url);
		}
	}
	
	/*~[Describe=生成意见列表;InputParam= 如：{{test11 系统管理员},{test11 普通用户}};OutPutParam=无;]~*/
	function genActionList(action){
		sActionList = eval('new Array('+action+')');
		oSelect = document.forms["Phase"].elements["PhaseAction"];
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
		iLength = document.forms["Phase"].PhaseOpinion1.length;
		for (i = 0; i <= iLength - 1; i++) {
			var oItem = document.forms["Phase"].PhaseOpinion1.item(i);	//获取意见选项
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
		var phaseAction = "";
		iLength = document.forms["Phase"].PhaseAction.length;	//获取动作列表选择项长度
		if(bActionReqiured){
			for (i = 0; i <= iLength - 1; i++) {
				var oItem = document.forms["Phase"].PhaseAction.item(i);
				if (oItem.selected) {
					if (oItem.value != "") {
						phaseAction += ","+ oItem.value;
					}
				}
			}
		}else{
			for (i = 0; i <= iLength - 1; i++) {
				var oItem = document.forms["Phase"].PhaseAction.item(i);
				if(oItem.value != ""){
					phaseAction += ","+ oItem.value;
				}
			}
		}
		var str = "";
		if(phaseAction.length>0) {
			str = phaseAction.substring(1);
		}
		return str;	//去除第一位上的逗号
	}

	/*~[Describe=提交任务;InputParam=无;OutPutParam=无;]~*/
	function commitAction(){
		var thisPhaseAction  = "";
		var thisPhaseOpinion1 = "";
		thisPhaseAction = getPaseAction();
		thisPhaseOpinion1 = getPaseOpinion();		
		
		if(thisPhaseOpinion1.length == 0){
			alert("请先进行提交意见选择 !");
		}else if(thisPhaseAction.length == 0 && bActionReqiured) {
			alert("请先进行提交动作选择 !");
		}else if (thisPhaseAction == '<%=CurUser.getUserID()%>'){
			//alert("提交对象不能为当前用户！");
			//return;
		}else{
			if (confirm("该笔业务的"+document.getElementById("nextPaseInfo").innerHTML+"\r\n你确定提交吗？")){
				
				sReturnValue = PopPageAjax("/Common/WorkFlow/SubmitActionAjax.jsp?SerialNo=<%=sSerialNo%>&oldPhaseNo=<%=oldPhaseNo%>&objectType=<%=objectType%>&objectNo=<%=objectNo%>&PhaseOpinion1="+thisPhaseOpinion1+"&PhaseAction="+thisPhaseAction,"","");
				top.returnValue = sReturnValue;   				
				top.close();
			}
		}
	}

	document.onkeydown = function(){
		if(event.keyCode==27){
			top.returnValue = "_CANCEL_"; 
			top.close();
		}
	};
</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
