<%
/* Copyright 2001-2010 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 *
 * Author: syang 2009/09/15
 * Tester:
 * Content: 
 *          �Զ�����̽�ⳡ����ҳ�棬��Ҫ��̽��ģ�͵��ã����ؽ��������
 * Input Param:
 *      ScenarioNo:	Ԥ���ĳ���ID����������
 *      ObjectType:	�������ͣ�������Ϊ������ˮ��
 *      ObjectNo: 	����ֵ����������ˮ��
 *      BizArg: 	������������ʽ�磺CustomerID=001,CustomerName=�ֳ壩
 *			SubTypeNo�������ͺţ�����ִֻ��ģ���У������ͺ�ƥ��ļ�������˲�����������Ĭ��ʹ�ó��������õ������ͺ�
 *			OneStepRun: yes/no �Ƿ���Ե����ύ��Ĭ��Ϊ�񣨴˲���������ʹ�ã�
 * Output param:
 *      ReturnValue:Ԥ����鴦��ͨ����true/false��
 * History Log:  
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.alarm.*"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	
	/** �������� **/
	int iModelCount = 0;		//ģ�͸���
	String sNoPassDeal = "";//δͨ���Ĵ�����
	
	//����������	
	String sScenarioNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ScenarioNo")); 
	String sBizArg = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BizArg"));
	String sSubTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SubTypeNo"));
	
	ARE.getLog().debug("����ҵ�����:"+sBizArg);
	
	
	//����ֵת��Ϊ���ַ���
	if(sScenarioNo == null) sScenarioNo = "";
	if(sBizArg == null) sBizArg = "";
	if(sSubTypeNo == null) sSubTypeNo = "";
	if(sSubTypeNo.equals("undefined")) sSubTypeNo = "";
	
	//������ʾ	
	AlarmScenario scenario = null;
	//���ֻ���ͺ�Ϊ�գ�����ʼ��ֻ���ͺ�
	if(sSubTypeNo.equals("")){	
		scenario = new AlarmScenario(sScenarioNo,sBizArg);			//�����ʼ������
	}else{
		scenario = new AlarmScenario(sScenarioNo,sBizArg,sSubTypeNo);	//�����ʼ������
	}
	//ִ�г�ʼ��
	scenario.init(Sqlca);	
	
	String sScenarioName = "",sScenarioDescribe = "";
	sScenarioName = scenario.getScenarioName();
	sScenarioDescribe = scenario.getScenarioDescibe();
	if(sScenarioDescribe == null) sScenarioDescribe = "";
	
	int i=0,num=0;
  	
	//��������õ�session��
	session.setAttribute("CurAlarmScenario",scenario);
%>
<html>
	
<head>
<title>�����������ж�</title>
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
/*����������ʾ��*/
.hignLight{

}
body{
	margin:0px;
	padding:0px auto;
	text-align:center;
}
/*���������*/
#outterDiv{
	position:absolute;
	left:1%;
	margin:0px auto;
	width:100%;
	height:100%;
}
/*�������*/
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
/*��ť���*/
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
			<th class="modelName">���������</th>
			<th class="resultImg">������</th>
			<th class="resultMsg">��ʾ��Ϣ</th>
		</tr>
		<%
		Vector keys = scenario.getModelkeys();
		for (i=0;i< keys.size();i++)
		{
			String sModelNo  = keys.get(i).toString();
			String sModelName = (String)scenario.getModelAttribute(sModelNo,"ModelName");
			if(!scenario.checkRunCondition(Sqlca,sModelNo)){	//�������������������У�������
				continue;
			}
			//ȡ��ÿ��ģ���У����ͨ�������δͨ���Ĵ�����
			sNoPassDeal += ((String)scenario.getModelAttribute(sModelNo,"NoPassDeal")+",");
		%>
		<tr bgcolor=#fafafa id="checkModel<%=iModelCount%>">
			<td width='5%'>
				<input id="modelNo<%=iModelCount%>" type="hidden" value="<%=sModelNo%>" /><!-- ��ʶģ�ͺ� -->
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
		//������i���±꣬����ҳ�������checkCondition���ͨ�������ͻ����1,2,3,6,�Ϻŵ�����������������
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
					<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","ȷ��","ȷ��Ԥ�������","javascript:alarm_ok();",sResourcesPath)%>
					</td>
					<td id=al_exit >
						<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","ȡ��","����Ԥ�������","javascript:alarm_exit();",sResourcesPath)%>
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

//-----------------ȫ�ֱ���------------------------
	var iModelCount = <%=iModelCount%>;								//ִ��Ԥ��ɨ�賡������
	var iPreIndex = 0;																//ǰһ��Ԥ��ɨ�������
	var startIndex = 0;																//����ģ�͵���ʼ��
	var timeoutId ;																		//��ʱ��ID
	var bContinue = true;															//�Ƿ��ܼ������У���Ҫ����ǰһ��Ԫδִ���������£���������ĵ�Ԫ
	var bScenarioCleared = false;											//����Ƿ���ڴ��������������
	var bEnded = false;																//�������ģ���Ƿ������ȫ����������Լ�����;ֹͣ���������������
	var sRunModel = "<%=sCurRunMode%>";								//����ģ�ͣ�����ģʽ�£�����������������ʾDevelopment

	var vIsPassed = new Array(iModelCount);						//��¼ÿһ��ģ�͵ļ����
	var vFinishFlag = new Array(iModelCount);					//��¼ÿ��ɨ��ģ�͵����״̬��Ŀǰδ�����κο��ƣ���ʱ���������
	var vNoPassDeal = "<%=sNoPassDeal%>".split(",");	//��¼ÿ��ģ�ͼ��δͨ���Ĵ�������00 ֹͣ,10 ��ֹ����,20 ��ʾ,99 ������
	/**
	 * ��ʼ��
	 */
	function init(){
		for(var i=0;i<vFinishFlag.length;i++){	//��ʼ��������ɱ�־Ϊfalse
			vIsPassed[i] = false;
			vFinishFlag[i] = false;
		}
		//$("buttonTd").disabled = true;
	}
	/**
	 *����ȫ����ѡ�е�Ԥ��ģ��
	 */
	function runAllModel(){
		//�������첽ִ�У���Ϊ����ɨ�裬ֻ��ǰһ��ִ����󣬲���ִ�к�һ��
		//��ˣ���Ҫÿ��һ��ʱ���ɨ��һ�£�ֱ��ִ����������ʱ��
		getMinCheckedIndex();
		timeoutId = setInterval(runAlarmModel,100);
	}

	/**
	 *ִ�з���ɨ��
	 */
	function runAlarmModel(){

		//����ȫ��Ԥ��ģ��
		for(var i=0;i<iModelCount;i++){
			executeAlarmModel(i);
		}
		//ִ�������еļ���,��session���������
		if(checkComplete()){
			clearScenario();
			clearInterval(timeoutId);
			if(isPass()){
				showMessage("<font color='green'>���ͨ��</font>");
				//$("buttonTd").disabled = false;	//������һ����ť
			}else{
				showMessage("<font color='red'>���δͨ��</font>");
				//$("buttonTd").disabled = true;	//������һ����ť
			}
		}
	}
	
		/**
		 *
		 *ִ��Ԥ��ɨ�赥Ԫ �����ǰһ��Ԫδִ���򲻻�ִ�к���ĵ�Ԫ������˵�Ԫ��ִ�й����򲻻��ظ�ִ��
		 *@index ��Ԫ������
		 *
		 */
		function executeAlarmModel(index){

			var i = index;	//ִ�е�Ԫ������
			//���Ҫִ�еĵ�Ԫ��ǰһ��Ԫ��ͬ��˵����ִ�й��ˣ���ִ��
			//���ǰһ��Ԫδִ����ϣ���Ҳ����ִ�е�ǰ��Ԫ
			if(bContinue == false){
				return;
			}
			//�������첽���ã������Ҫִ�еĵ�Ԫ���ǵ�ǰִ�еĵ�Ԫ����ִ��
			if(i != startIndex && iPreIndex == i){
				return;
			}

			idCheckBox = "checkbox"+i;		//ȡ��checkbox��id
			idModenNo = "modelNo"+i;		//ȡ��ģ�ͺ�

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
				iPreIndex = i;	//��¼�µ�ǰ����ִ�еĵ�Ԫ
				xmlHttp.onreadystatechange=function(){

					showResult("",i,0);
					if(xmlHttp.readyState==4){
						sReturn = xmlHttp.responseText;
						showResult(sReturn,i,1);	//������
						vFinishFlag[i] = true;		//��¼״̬
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
		 * ����Ԥ��ģ���Ƿ��������
		 */
		function checkComplete(){
			//����Ƿ�ȫ��ִ����ϣ����ȫ����ִ����ϣ��������ʱ��
			var	bFlag = true;
			for(var j=startIndex;j<iModelCount;j++){
				oCheckBox = $("checkbox"+j);	//ȡ��ѡ ��
				if(oCheckBox.checked){
					bFlag = false;
					break;
				}
			}
			if(bFlag == true){
				bEnded = true;	//�����е�ģ��������ɺ󣬱�ʶΪ�ѽ���
			}
			return bFlag;
		}

	/**
	 * ��ȡ��ѡ�еĸ�ѡ ���У���С������
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
		
	/**���ݷ���ֵ���ı�ҳ����ʾ
	  *@sReturn ����������ֵ
	  *@cursor ��ǰ����Ԥ��ģ�͵��α�
	  *@status��׳̬ �Ǵ����л��Ǵ������ 0��ʾ�����У�1��ʾ�������
	*/
	function showResult(message,cursor,status){
		i = cursor;	//ȡ�������Ҫ���õ�id
		idPointer = "pointer"+i;
		idCheckBox = "checkbox"+i;		//ȡ��checkbox��id
		idResultImg = "resultImg"+i;	//̽������ӦͼƬָʾ
		idMsg = "checkResultMsg"+i;		//��ʾ̽������������
		
		oCheckBox = $(idCheckBox);
		oMsg = $(idMsg);
		oResultImg = $(idResultImg);
		oPointer = $(idPointer);

		resPool = new Array(
				["09","green","icon14.gif","�������"],	//�����ʱδʹ��
				["10","red","icon10.gif","��ֹ����"],
				["81","blue","icon1.gif","��ʾ"],
				["99","green","icon7.gif","�ɹ�"],
				["00","red" ,"icon_alert.gif","ֹͣ"]
		);

		//vNoPassDeal  ��¼ÿ��ģ�ͼ��δͨ���Ĵ�������10����ֹ����20����ʾ
		if(status == 1){
			alarmMsg = null;
			try{
				message = trim(message);
				alarmMsg = eval('('+message+')');	//���������Ϣ���Ϸ�������ᱨ�����Ե���try
			}catch(e){
				//�ڿ���ģʽ�¸�����ʾ
				if(sRunModel == "Development"){
					var sMsg = "��ȷ�ϼ��ģ���Ƿ�������ɣ�������������鿴�����־";
					alert("���е�["+(i+1)+"]��ģ�ͳ���"+sMsg);
				}
				bEnded = true;	//������г����쳣��Ҳ��Ϊ��ֹ��
				alarm_exit();
				return;
			}
			oPointer.style.display="none";	//�����굱ǰ��Ԫ������ָʾ��
			oCheckBox.checked=false;		//ȡ����ѡ �� ��ѡ��״̬

			//���ͨ��
			if(alarmMsg.status == "true"){
				oResultImg.src = "<%=sResourcesPath%>"+"/alarm/"+resPool[3][2];
				oMsg.style.color = resPool[3][1];
				oMsg.innerHTML = formatMessage(alarmMsg.message);
				vIsPassed[i] = true;	//ͨ��

			//���δͨ�������
			}else{
				if(vNoPassDeal[i] == "10"){
				//��ֹ����
					oResultImg.src = "<%=sResourcesPath%>"+"/alarm/"+resPool[1][2];
					oMsg.style.color = resPool[1][1];
					vIsPassed[i] = false;	
				}else if(vNoPassDeal[i] == "20"){
				//��ʾ
					oResultImg.src = "<%=sResourcesPath%>"+"/alarm/"+resPool[2][2];
					oMsg.style.color = resPool[2][1];
					vIsPassed[i] = true;
				}else if(vNoPassDeal[i] == "00"){
				//ֹͣ
					oResultImg.src = "<%=sResourcesPath%>"+"/alarm/"+resPool[4][2];
					oMsg.style.color = resPool[4][1];
					oMsg.style.fontWeight = "bold"; 
					vIsPassed[i] = false;
					bEnded = true;									//�����м�ֹͣ���������ʶΪ����
					stop();
				}else{
					alert(vNoPassDeal[i]+"δͨ���Ĵ�������Ŀǰϵͳû֧�֣������");
				}
				oMsg.innerHTML = formatMessage(alarmMsg.message);
			}
			
		//��ʾΪ������
		}else{
			oResultImg.src = "<%=sResourcesPath%>/35.gif";	//ͼƬ״̬Ϊ������
			oPointer.style.display = "block";
			oMsg.innerText = amarsoft2Real("������ . . . ");	//��������
		}
	}

	/*
	 *ֹͣ����
	 */
	function stop(){
		clearScenario();
		clearInterval(timeoutId);
	}
	/**
	 * ����ҳ���Ƿ���֤ͨ��
	 */
	function isPass(){
		var bPass = true;
		for(var i=0;i<vIsPassed.length;i++){
			if(vIsPassed[i] == false){	//ֻҪ��һ����֤δͨ��������δͨ��
				bPass = false;
				break;
			}
		}
		return bPass;
	}

	/**
	 * ��ʽ��������������Ϣ
	 *@str �����ַ�����һ������"[~`~]"Ϊ�ָ����
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
	 * ���������Ϣ
	 *@str ��Ϣ
	 */
	function showMessage(str){
		oDebugMsg = $("messageDiv");
		oDebugMsg.style.display = "block";	
		oDebugMsg.innerHTML = str;
	}
	/**
	 *����id�ţ�ȡ����ӦԪ�ص�����
	 *@id Ԫ��ID��
	 */
	function $(id){
		return document.getElementById(id);
	}

	/**
	 * ��session������������˺���������ҳ�����������У�ִֻ��һ��
	 */
	function clearScenario(){
		if(bScenarioCleared == false){	//���ڴ˺�����ֹһ�ε��ã����������δ������������֮
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
	 *ȡ��
	 */
	function alarm_exit(){
		self.returnValue = false;
		self.close();
	}

	/**
	 *ȷ��,���δ������ɣ�������ر�
	 */
	function alarm_ok(){
		if(bEnded){
			clearScenario();
			self.returnValue = isPass();
			self.close();	//ִ�д˺����󣬻ᴥ��window.onbeforeunload
		}else{
			alert("��δ�������");
		}
	}

	window.onload = function(){
		//���������ִ�У����á����С���ť����
		init();
		//debugMsg(document.body.innerHTML);
		setTimeout("runAllModel()",200);
	};
	
	/**
	 *ҳ��ر�ʱ�����������
	 *���ڴ�ҳ�������������ʽ�����õģ��Ƿ���OpenCompDialog.jspҳ�����һ��Iframe��
	 *���������ڸ������ϲ�ҳ���onbeforeunload�¼�����Ҫ�ֹ���������ִ�д���
	 */
	parent.document.body.onbeforeunload = function(){
			//�������
			clearScenario();
			//�ο�OpenCompDialog.jsp�ĵ�26��onBeforeUnload="onClose()"
			parent.onClose();	
	};

	/**
	 *����Enter������ͬ��ҳ��㡰ȷ������ť
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