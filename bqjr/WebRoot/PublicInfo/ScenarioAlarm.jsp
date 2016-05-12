<%
/* Copyright 2001-2010 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 *
 * Author: syang 2009/09/15
 * Tester:
 * Content: 
 *          自动风险探测场景主页面，主要是探测模型调用，返回结果处理功能
 * Input Param:
 *      ScenarioNo:	预警的场景ID，如审批等
 *      ObjectType:	参数类型，如类型为审批流水号
 *      ObjectNo: 	参数值，如审批流水号
 *      BizArg: 	场景参数（格式如：CustomerID=001,CustomerName=林冲）
 *			SubTypeNo：子类型号，用于只执行模型中，子类型号匹配的检查项，如果此参数不传，则默认使用场景中配置的子类型号
 *			OneStepRun: yes/no 是否可以单步提交，默认为否（此参数不建议使用）
 * Output param:
 *      ReturnValue:预警检查处理通过否（true/false）
 * History Log:  
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.alarm.*"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	
	/** 参数定义 **/
	int iModelCount = 0;		//模型个数
	String sNoPassDeal = "";//未通过的处理方法
	
	//获得组件参数	
	String sScenarioNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ScenarioNo")); 
	String sBizArg = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BizArg"));
	String sSubTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SubTypeNo"));
	
	ARE.getLog().debug("传入业务参数:"+sBizArg);
	
	
	//将空值转化为空字符串
	if(sScenarioNo == null) sScenarioNo = "";
	if(sBizArg == null) sBizArg = "";
	if(sSubTypeNo == null) sSubTypeNo = "";
	if(sSubTypeNo.equals("undefined")) sSubTypeNo = "";
	
	//风险提示	
	AlarmScenario scenario = null;
	//如果只类型号为空，不初始化只类型号
	if(sSubTypeNo.equals("")){	
		scenario = new AlarmScenario(sScenarioNo,sBizArg);			//传入初始化变量
	}else{
		scenario = new AlarmScenario(sScenarioNo,sBizArg,sSubTypeNo);	//传入初始化变量
	}
	//执行初始化
	scenario.init(Sqlca);	
	
	String sScenarioName = "",sScenarioDescribe = "";
	sScenarioName = scenario.getScenarioName();
	sScenarioDescribe = scenario.getScenarioDescibe();
	if(sScenarioDescribe == null) sScenarioDescribe = "";
	
	int i=0,num=0;
  	
	//将对象放置到session中
	session.setAttribute("CurAlarmScenario",scenario);
%>
<html>
	
<head>
<title>符合性条件判断</title>
<style type="text/css">
<!--
table.scenario{
	border: 1px solid #CCCCCC;
}

table.scenario th{
	border-bottom:2px solid #cccccc;
}

table.scenario td{
	border-bottom:1px solid #CCCCCC;
}

th{
	font-size:14px;
	text-align:center;
	font-weight:400;
}

.process{
	width:40px;
}
.checkbox{
	width:40px;
}

.modelName{
	width:400px;
	text-align:left;
}
.resultImg{
	width:80px;
}
.resultMsg{
	width:400px;
}
/*高亮错误提示行*/
.hignLight{

}
body{
	margin:0px;
	padding:0px auto;
	text-align:center;
}
/*最外层容器*/
#outterDiv{
	position:absolute;
	left:1%;
	margin:0px auto;
	width:100%;
	height:100%;
}
/*场景面板*/
#plantformDiv{
	/*border:1px solid #FF0000;*/
	width:100%;
	height:92%;
	overflow:auto;
}

#messageDiv{
	/*border:1px solid #00FF00;*/
	height:2%;
	font-weight:bold;
	text-align:center;
	font-size:10pt;
}
/*按钮面板*/
#buttonDiv{
	/*border:1px solid #0000FF;*/
	height:2%;
}

-->
</style>
</head>
<body bgcolor="#EAEAEA" >
<div id="outterDiv">
<div id="plantformDiv">
	<table width="100%" cellspacing="0" cellpadding="0" class="scenario">
		<tr bgcolor=#fafafa>
			<th class="process">&nbsp;</th>	
			<th class="checkbox">&nbsp;</th>
			<th class="modelName">处理的任务</th>
			<th class="resultImg">处理结果</th>
			<th class="resultMsg">提示信息</th>
		</tr>
		<%
		Vector keys = scenario.getModelkeys();
		for (i=0;i< keys.size();i++)
		{
			String sModelNo  = keys.get(i).toString();
			String sModelName = (String)scenario.getModelAttribute(sModelNo,"ModelName");
			if(!scenario.checkRunCondition(Sqlca,sModelNo)){	//如果检查条件不允许运行，则不运行
				continue;
			}
			//取出每个模型中，检查通过，检查未通过的处理方法
			sNoPassDeal += ((String)scenario.getModelAttribute(sModelNo,"NoPassDeal")+",");
		%>
		<tr bgcolor=#fafafa id="checkModel<%=iModelCount%>">
			<td width='5%'>
				<input id="modelNo<%=iModelCount%>" type="hidden" value="<%=sModelNo%>" /><!-- 标识模型号 -->
				<span id=pointer<%=iModelCount%> style="display:none"><strong><img src=<%=sResourcesPath%>/logo.jpg></span>
			</td>	
	    	<td align=center width='4%'>
	      	<INPUT ID="checkbox<%=iModelCount%>" TYPE="checkbox" NAME="checkbox<%=iModelCount%>" checked disabled="disabled">
	    	</td>
	    	<td width='37%'><%=sModelName%></td>
			<td width='4%'>
				<span id=checkResultImg<%=iModelCount%> style="display:block"><img id=resultImg<%=iModelCount%> src=<%=sResourcesPath%>/alarm/icon4.gif></span>
			</td>	
			<td width='50%'>
				<div id=checkResultMsg<%=iModelCount%>>&nbsp;</div> 
			</td>
		</tr>
	<%
		//不能用i作下标，由于页面中如果checkCondition检查通不过，就会出现1,2,3,6,断号的情况，这样会出问题
		iModelCount ++ ;	
		}%>
	</table>
</div>
<div id="messageDiv"></div>
<div id="buttonDiv">
		<center>
			<table>
				<tr>
					<td id="buttonTd" text-align="center">
					<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","确定","确定预警检查结果","javascript:alarm_ok();",sResourcesPath)%>
					</td>
					<td id=al_exit >
						<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","取消","放弃预警检查结果","javascript:alarm_exit();",sResourcesPath)%>
					</td>
				</tr>
			</table>
		</cenrer>
</div>
</div>
</body>
</html>
<%
	if(sNoPassDeal.length() >= 1){
		sNoPassDeal = sNoPassDeal.substring(0,sNoPassDeal.length() -1);
	}
%>
<script type="text/javascript">

//-----------------全局变量------------------------
	var iModelCount = <%=iModelCount%>;								//执行预警扫描场景个数
	var iPreIndex = 0;																//前一个预警扫描的索引
	var startIndex = 0;																//运行模型的起始号
	var timeoutId ;																		//定时器ID
	var bContinue = true;															//是否能继续运行，主要用于前一单元未执行完的情况下，阻塞后面的单元
	var bScenarioCleared = false;											//标记是否从内存中清除过场景了
	var bEnded = false;																//标记所有模型是否结束，全部运行完成以及有中途停止的情况均算作结束
	var sRunModel = "<%=sCurRunMode%>";								//运行模型：开发模式下，如果出错给出出错提示Development

	var vIsPassed = new Array(iModelCount);						//记录每一个模型的检查结果
	var vFinishFlag = new Array(iModelCount);					//记录每个扫描模型的完成状态，目前未参与任何控制，暂时保留在这儿
	var vNoPassDeal = "<%=sNoPassDeal%>".split(",");	//记录每个模型检查未通过的处理方法：00 停止,10 禁止办理,20 提示,99 不处理
	/**
	 * 初始化
	 */
	function init(){
		for(var i=0;i<vFinishFlag.length;i++){	//初始化所有完成标志为false
			vIsPassed[i] = false;
			vFinishFlag[i] = false;
		}
		//$("buttonTd").disabled = true;
	}
	/**
	 *运行全部被选中的预警模型
	 */
	function runAllModel(){
		//由于是异步执行，且为单个扫描，只有前一个执行完后，才能执行后一个
		//因此，需要每过一段时间后扫描一下，直接执行完后，清除定时器
		getMinCheckedIndex();
		timeoutId = setInterval(runAlarmModel,100);
	}

	/**
	 *执行风险扫描
	 */
	function runAlarmModel(){

		//遍历全部预警模型
		for(var i=0;i<iModelCount;i++){
			executeAlarmModel(i);
		}
		//执行完所有的检查后,从session中清除场景
		if(checkComplete()){
			clearScenario();
			clearInterval(timeoutId);
			if(isPass()){
				showMessage("<font color='green'>检查通过</font>");
				//$("buttonTd").disabled = false;	//开启下一步按钮
			}else{
				showMessage("<font color='red'>检查未通过</font>");
				//$("buttonTd").disabled = true;	//禁用下一步按钮
			}
		}
	}
	
		/**
		 *
		 *执行预警扫描单元 ，如果前一单元未执行则不会执行后面的单元，如果此单元已执行过，则不会重复执行
		 *@index 单元索引号
		 *
		 */
		function executeAlarmModel(index){

			var i = index;	//执行单元的索引
			//如果要执行的单元与前一单元相同，说明已执行过了，则不执行
			//如果前一单元未执行完毕，则也不能执行当前单元
			if(bContinue == false){
				return;
			}
			//由于是异步调用，如果需要执行的单元正是当前执行的单元，则不执行
			if(i != startIndex && iPreIndex == i){
				return;
			}

			idCheckBox = "checkbox"+i;		//取得checkbox的id
			idModenNo = "modelNo"+i;		//取得模型号

			oCheckBox = $(idCheckBox);
			vModelNo = $(idModenNo).value;
			if(oCheckBox.checked){
				oCheckBox.disabled="disabled";
				oCheckBox.style.display="block";

				invokerUrl = "<%=sWebRootPath%>/PublicInfo/AlarmModelInvoker.jsp";
				sParam = "?ModelNo="+vModelNo+"&CompClientID=<%=SpecialTools.amarsoft2Real(sCompClientID)%>&rand1="+randomNumber();
				Url = invokerUrl+sParam;

				xmlHttp=getXmlHttpObject();
				if (xmlHttp==null){
					  alert ("Your browser does not support AJAX!");
					  return;
				}
				iPreIndex = i;	//记录下当前正在执行的单元
				xmlHttp.onreadystatechange=function(){

					showResult("",i,0);
					if(xmlHttp.readyState==4){
						sReturn = xmlHttp.responseText;
						showResult(sReturn,i,1);	//输出结果
						vFinishFlag[i] = true;		//记录状态
						bContinue = true;
					}else{
						vFinishFlag[i] = false;
						bContinue = false;
					}
				};
				xmlHttp.open("GET",Url,true);
				xmlHttp.send(null); 
			}
		}

		/**
		 * 检查各预警模型是否运行完毕
		 */
		function checkComplete(){
			//检查是否全部执行完毕，如果全部都执行完毕，则清除计时器
			var	bFlag = true;
			for(var j=startIndex;j<iModelCount;j++){
				oCheckBox = $("checkbox"+j);	//取复选 框
				if(oCheckBox.checked){
					bFlag = false;
					break;
				}
			}
			if(bFlag == true){
				bEnded = true;	//在所有的模型运行完成后，标识为已结束
			}
			return bFlag;
		}

	/**
	 * 获取被选中的复选 杠中，最小的索引
	 */
	function getMinCheckedIndex(){
		for(var i=0;i<iModelCount;i++){
			oCheckBox = $("checkbox"+i);
			if(oCheckBox.checked){
				startIndex = i;
				return i;
			}
		}
	}
		
	/**根据返回值，改变页面显示
	  *@sReturn 服务器返回值
	  *@cursor 当前处理预警模型的游标
	  *@status　壮态 是处理中还是处理完成 0表示处理中，1表示处理完成
	*/
	function showResult(message,cursor,status){
		i = cursor;	//取出相关需要设置的id
		idPointer = "pointer"+i;
		idCheckBox = "checkbox"+i;		//取得checkbox的id
		idResultImg = "resultImg"+i;	//探测结果相应图片指示
		idMsg = "checkResultMsg"+i;		//显示探测结果文字区域
		
		oCheckBox = $(idCheckBox);
		oMsg = $(idMsg);
		oResultImg = $(idResultImg);
		oPointer = $(idPointer);

		resPool = new Array(
				["09","green","icon14.gif","后续免检"],	//这个暂时未使用
				["10","red","icon10.gif","禁止办理"],
				["81","blue","icon1.gif","提示"],
				["99","green","icon7.gif","成功"],
				["00","red" ,"icon_alert.gif","停止"]
		);

		//vNoPassDeal  记录每个模型检查未通过的处理方法：10　禁止办理，20　提示
		if(status == 1){
			alarmMsg = null;
			try{
				message = trim(message);
				alarmMsg = eval('('+message+')');	//如果返回消息不合法，这里会报错，所以得用try
			}catch(e){
				//在开发模式下给出提示
				if(sRunModel == "Development"){
					var sMsg = "请确认检查模型是否运行完成，如果运行完成请查看相关日志";
					alert("运行第["+(i+1)+"]个模型出错，"+sMsg);
				}
				bEnded = true;	//如果运行出现异常，也认为中止了
				alarm_exit();
				return;
			}
			oPointer.style.display="none";	//处理完当前单元，隐藏指示器
			oCheckBox.checked=false;		//取消复选 框 的选中状态

			//检查通过
			if(alarmMsg.status == "true"){
				oResultImg.src = "<%=sResourcesPath%>"+"/alarm/"+resPool[3][2];
				oMsg.style.color = resPool[3][1];
				oMsg.innerHTML = formatMessage(alarmMsg.message);
				vIsPassed[i] = true;	//通过

			//检查未通过的情况
			}else{
				if(vNoPassDeal[i] == "10"){
				//禁止办理
					oResultImg.src = "<%=sResourcesPath%>"+"/alarm/"+resPool[1][2];
					oMsg.style.color = resPool[1][1];
					vIsPassed[i] = false;	
				}else if(vNoPassDeal[i] == "20"){
				//提示
					oResultImg.src = "<%=sResourcesPath%>"+"/alarm/"+resPool[2][2];
					oMsg.style.color = resPool[2][1];
					vIsPassed[i] = true;
				}else if(vNoPassDeal[i] == "00"){
				//停止
					oResultImg.src = "<%=sResourcesPath%>"+"/alarm/"+resPool[4][2];
					oMsg.style.color = resPool[4][1];
					oMsg.style.fontWeight = "bold"; 
					vIsPassed[i] = false;
					bEnded = true;									//遇上中间停止的情况，标识为结束
					stop();
				}else{
					alert(vNoPassDeal[i]+"未通过的处理方法，目前系统没支持，请更改");
				}
				oMsg.innerHTML = formatMessage(alarmMsg.message);
			}
			
		//显示为处理中
		}else{
			oResultImg.src = "<%=sResourcesPath%>/35.gif";	//图片状态为处理中
			oPointer.style.display = "block";
			oMsg.innerText = amarsoft2Real("处理中 . . . ");	//文字内容
		}
	}

	/*
	 *停止运行
	 */
	function stop(){
		clearScenario();
		clearInterval(timeoutId);
	}
	/**
	 * 计算页面是否验证通过
	 */
	function isPass(){
		var bPass = true;
		for(var i=0;i<vIsPassed.length;i++){
			if(vIsPassed[i] == false){	//只要有一个验证未通过，就算未通过
				bPass = false;
				break;
			}
		}
		return bPass;
	}

	/**
	 * 格式化服务器返回消息
	 *@str 参数字符串，一般是用"[~`~]"为分割符的
	 */
	function formatMessage(str){
		var msg = str.split(/\[\~\`\~\]/g);
		var message = "";
		for(var i=0;i<msg.length&&msg.length != 1;i++){
			if(msg[i].length <= 0) continue;
			message += ((i+1)+"."+msg[i]+"<br/>");
		}
		if(msg.length == 1){
			message = msg[0];
		}
		if(message.length == 0){
			message = "&nbsp;";
		}
		return message;
	}

	/**
	 * 输出调试信息
	 *@str 信息
	 */
	function showMessage(str){
		oDebugMsg = $("messageDiv");
		oDebugMsg.style.display = "block";	
		oDebugMsg.innerHTML = str;
	}
	/**
	 *根据id号，取得相应元素的引用
	 *@id 元素ID号
	 */
	function $(id){
		return document.getElementById(id);
	}

	/**
	 * 从session中清除场景，此函数在整个页面生命周期中，只执行一次
	 */
	function clearScenario(){
		if(bScenarioCleared == false){	//由于此函数不止一次调用，如果场景还未被清除，则清除之
			invokerUrl = "<%=sWebRootPath%>/PublicInfo/AlarmModelInvoker.jsp";
			sParam = "?OperateType=clear&CompClientID=<%=SpecialTools.real2Amarsoft(sCompClientID)%>&rand1="+randomNumber();
			Url = invokerUrl+sParam;
			xmlHttp=getXmlHttpObject();
			if (xmlHttp==null){
				  alert ("Your browser does not support AJAX!");
				  return;
			}
			xmlHttp.onreadystatechange=function(){
				if(xmlHttp.readyState==4){
				}
			};
			xmlHttp.open("GET",Url,false);
			xmlHttp.send(null); 
			bScenarioCleared = true;
		}
	}
	
	/**
	 *取消
	 */
	function alarm_exit(){
		self.returnValue = false;
		self.close();
	}

	/**
	 *确定,如果未运行完成，则不允许关闭
	 */
	function alarm_ok(){
		if(bEnded){
			clearScenario();
			self.returnValue = isPass();
			self.close();	//执行此函数后，会触发window.onbeforeunload
		}else{
			alert("还未运行完成");
		}
	}

	window.onload = function(){
		//如果不单步执行，则让“运行”按钮可用
		init();
		//debugMsg(document.body.innerHTML);
		setTimeout("runAllModel()",200);
	};
	
	/**
	 *页面关闭时，清除场景。
	 *由于此页面是以组件的形式被调用的，是放在OpenCompDialog.jsp页面里的一个Iframe下
	 *所以这里在覆盖了上层页面的onbeforeunload事件后，需要手工调用它的执行代码
	 */
	parent.document.body.onbeforeunload = function(){
			//清除场景
			clearScenario();
			//参考OpenCompDialog.jsp的第26行onBeforeUnload="onClose()"
			parent.onClose();	
	};

	/**
	 *按下Enter键，等同于页面点“确定”按钮
	 */
	document.onkeydown = function(){
		if(event.keyCode == 13){
			alarm_ok();
		}else if(event.keyCode==27){
			alarm_exit();
		}
	};

</script>

<%@ include file="/IncludeEndAJAX.jsp"%>