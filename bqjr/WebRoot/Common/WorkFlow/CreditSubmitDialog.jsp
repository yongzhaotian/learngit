<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.app.als.process.util.ProcessHelp,
                com.amarsoft.app.als.process.action.BusinessProcessAction,
                java.util.Map,
                com.amarsoft.are.jbo.BizObject,
                com.amarsoft.are.lang.StringX,
                com.amarsoft.app.als.process.action.BusinessProcessConst" %>
<%
	String sBusinessTaskID = CurPage.getParameter("SerialNo");   				//������ˮ��
	String sNextFlowState = CurPage.getParameter("NextFlowState");				//��һ�׶�����״̬
	if(StringX.isSpace(sBusinessTaskID)) sBusinessTaskID = "";
	//if(StringX.isSpace(sNextFlowState)) sNextFlowState = "";
	BizObject task = com.amarsoft.app.als.process.action.GetApplyParams.getFlowTaskParams(sBusinessTaskID);
	String sProcessTaskID = task.getAttribute("ProcessTaskNo").getString();     //��������������ˮ��
	String sProcessDefID = task.getAttribute("FlowNo").getString();				//���̶�����,FlowNo
	String sObjectNo = task.getAttribute("ObjectNo").getString();		   		//������
	String sObjectType = task.getAttribute("ObjectType").getString();		   		//������
	String sApplyType = task.getAttribute("ApplyType").getString();	   			//��������
	String sBizProcessObjectID = task.getAttribute("RelativeObjectNo").getString();//���̶�����ˮ��
	String sPhaseNo = task.getAttribute("PhaseNo").getString();					//�׶α��
	String sCurFlowState = task.getAttribute("FlowState").getString();			//��ǰ�׶�����״̬
	String sUserID = CurUser.getUserID();										//��ǰ�û�ID
	
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
	
	//Ԥ��������Ȩ��ʶ�����̣��������ж���ѡ���ж�
	BusinessProcessAction bpAction = new BusinessProcessAction();
	bpAction.setProcessTaskID(sProcessTaskID);
	bpAction.setRelativeData("ALS.POWER=1");
	String sResult = bpAction.setProcessObject();
	if("SUCCESS".equals(sResult)){
		System.out.println("������Ȩ��ʶ�ɹ�");
	}
	
	//�Դ�������κ�һƱ��������⴦��
	if(BusinessProcessConst.FLOWSTATE_VOTE.equals(sCurFlowState)){
		//sPhaseNo = "";//����������ύ��ǩ�����ǽ׶����̺��ÿգ��ѷ�Ӧ���������棬�����޸ģ��޸ĺ���ÿտ�ɾ��2011/08/30
		//sNextFlowState = BusinessProcessConst.FLOWSTATE_MCHECK;
	}
	if(BusinessProcessConst.FLOWSTATE_MCHECK.equals(sCurFlowState)){
		sNextFlowState = BusinessProcessConst.FLOWSTATE_MAPPROVE;
	}

	//ȡ���ύ�����б�
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
					<td><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","��  ��","�ύ","javascript:commitAction()",sResourcesPath)%></td>
					<td><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","��  ��","����","javascript:doCancel()",sResourcesPath)%></td>	
				</tr>
   			</table>
	    </td>
	</tr>
	<tr>
		<!-- <td><input id="smsFlag" type="checkbox" />�Ƿ����֪ͨ</td> -->	
	</tr>
	<tr>
		<td><font color="#000000"><b>��ѡ����һ�׶��ύ������</b></font></td>
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
		<td><font color="#000000"><b>��ѡ����һ���н׶��ύ����(���з�֧����˫����Աѡ����Է�֧���ύ��Ա)��</b></font></td>
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
		<td><font color="#000000"><b>��ѡ����һ�׶��ύ��Ա��</b></font></td>
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
	var bActionReqiured = true;	//�Ƿ���Ҫѡ���������Ϊ�˻�һ��ģ��Ͳ���Ҫѡ����һ��Action��)
	
	/*~[Describe=ҳ����غ󣬳�ʼ������;InputParam=��;OutPutParam=��;]~*/
	$(document).ready(function(){
		document.getElementById("selectlist").style.display = "none";//�����ύ��Աѡ���
		document.getElementById("forklist").style.display = "none";  //���ط�֧����ѡ���
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
	
	/*~[Describe=���������̷�֧�����Ա;InputParam=��;OutPutParam=��;]~*/
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
	
	/*~[Describe=ȡ���ύ;InputParam=��;OutPutParam=��;]~*/
	function doCancel(){
		if(confirm("��ȷ��Ҫ�����˴��ύ��")){
			//�����ղŵ�ѡ�����
			document.forms["Phase"].elements["PhaseAction"].value = "";
			document.getElementById("selectlist").style.display = "none";
			document.forms["Phase"].elements["PhaseUser"].value = "";
			document.getElementById("nextPhaseInfo").innerHTML="";
			top.returnValue = "_CANCEL_";
			top.close();
		}
	}

	/*~[Describe=���ƶ���ѡ�񴰿�;InputParam=��;OutPutParam=��;]~*/
	function doActionList(){
		var oPhaseAction = document.forms["Phase"].elements["PhaseAction"];
		iLength =  oPhaseAction.length;	//ȡ�ɹ�ѡ��Ķ�������
		for(var i = 0;i < iLength;i++){
			var oItem = oPhaseAction.item(i);	//ȡ��ѡ��Ķ����Ķ���
			if (oItem.selected){
				var itemName = oItem.text;		//ȡ����ѡ��Ķ�������
				var itemValue = oItem.value;	//ȡ����ѡ��Ķ���ֵ
				if(itemValue != "" && itemName != ""){
					if(itemValue.search("End") >= 0){
						document.getElementById("selectlist").style.display = "none";
		    			bActionReqiured = false;
		    			getNextPhaseInfo(1);	//����һ�׶���Ϣ
					}
					if(itemValue.search("Task") >= 0 || itemValue.search("CounterSign") >= 0 || itemValue.search("Join") >= 0){
						document.getElementById("selectlist").style.display = "";
						document.getElementById("forklist").style.display = "none";
						var size = document.forms["Phase"].elements["ForkAction"].options.length;
						for(var j=size-1;j>0;j--){
							document.forms["Phase"].elements["ForkAction"].options.remove(j);
						}
		    			bActionReqiured = true;
		    			getNextPhaseInfo(1);	//����һ�׶���Ϣ
					}
					if(itemValue.search("Fork") >= 0){
						document.getElementById("selectlist").style.display = "none";
						document.getElementById("forklist").style.display = "";
		    			bActionReqiured = true;
		    			var phaseAction = document.forms["Phase"].elements["PhaseAction"].value;	//��ȡѡ��Ķ���							
		    			var forkAction = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessProcessAction","getForkActions",
	 							 "ProcessDefID=<%=sProcessDefID%>,ProcessTaskID=<%=sProcessTaskID%>"+",PhaseNo="+phaseAction);
		    			genForkList(forkAction);
					}
				}else{
					document.getElementById("nextPhaseInfo").innerHTML="";//�����һ�׶���Ϣ
					document.getElementById("selectlist").style.display = "none";
					document.getElementById("forklist").style.display = "none";
				}
			}
		}
	}
	
	/*~[Describe=���Ʒ�֧����ѡ�񴰿�;InputParam=��;OutPutParam=��;]~*/
	function doForkActionList(){
		var oForkAction = document.forms["Phase"].elements["ForkAction"];
		iLength =  oForkAction.length;	//ȡ�ɹ�ѡ��Ķ�������
		for(var i = 0;i <= iLength - 1;i++){
			var oItem = oForkAction.item(i);	//ȡ��ѡ��Ķ����Ķ���
			document.getElementById("nextPhaseInfo").innerHTML="";//�������һ�׶���Ϣ
			if (oItem.selected){
				var itemName = oItem.text;	//ȡ����ѡ��Ķ�������
				var itemValue = oItem.value;	//ȡ����ѡ��Ķ���ֵ
				if(itemValue != "" && itemName != ""){
					if(itemValue.search("Task") >= 0 || itemValue.search("CounterSign") >= 0){
						document.getElementById("selectlist").style.display = "";
						document.getElementById("forklist").style.display = "";
		    			bActionReqiured = true;
		    			getNextForkPhaseInfo(1);	//����һ�׶���Ա��Ϣ
					}
				}else{
					document.getElementById("selectlist").style.display = "none";
				}
			}
		}
	}

	/*~[Describe=��ȡ��һ�׶���Ϣ;InputParam=type 0��ʾ�������,1��ʾ��������;OutPutParam=��;]~*/
	function getNextForkPhaseInfo(type){
		var oForkAction = document.forms["Phase"].elements["ForkAction"];			//��ȡ��������
		var forkActionValue =  oForkAction.value;									//��ȡ��������
		var PhaseUser =  document.forms["Phase"].elements["PhaseUser"].value;		//��ȡ��Ա
		
		document.getElementById("nextPhaseInfo").innerHTML="";		//�����һ�׶���Ϣ
		if(PhaseUser==""){
			document.forms["Phase"].elements["PhaseUser"].value = "";
		}

		var forkActionValue = forkActionValue.split("@")[0]; //�����û�����ȡ��һ���׶α��
		if(type == 1){
			var PhaseNo = "<%=sPhaseNo%>";
			var sUserID = "<%=CurUser.getUserID()%>";
			var sOrgID  = "<%=CurUser.getOrgID()%>";
			
			//��ȡ��Ա�б�
			var sUserList = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessProcessAction","getTaskParticipants",
												 "UserID="+sUserID+",ProcessAction="+forkActionValue+",ProcessDefID=<%=sProcessDefID%>,ProcessTaskID=<%=sProcessTaskID%>");
		 	//��ȡ��ѡ��ʶ
			var sFlag = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessProcessAction","getNextState",
					 							 "UserID="+sUserID+",ProcessAction="+forkActionValue+",ProcessDefID=<%=sProcessDefID%>,ProcessTaskID=<%=sProcessTaskID%>");
			//����������Ա�б�
			genUserList(sUserList,sFlag);
		}
		
		//������һ�׶���Ϣ
		var phaseAction = document.forms["Phase"].elements["PhaseAction"].value;	//��ȡ��֧����
		var nextPhaseInfo = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessProcessAction",
								"getNextActivityInfo","ProcessTaskID=<%=sProcessTaskID%>,ProcessAction="+phaseAction+",ProcessDefID=<%=sProcessDefID%>,TaskParticipants="+PhaseUser);
		document.getElementById("nextPhaseInfo").innerHTML = nextPhaseInfo;
	}
	
	/*~[Describe=��ȡ��һ�׶���Ϣ;InputParam=type 0��ʾ�������,1��ʾ��������;OutPutParam=��;]~*/
	function getNextPhaseInfo(type){
		var oPhaseAction = document.forms["Phase"].elements["PhaseAction"];			//��ȡ��������
		var phaseActionValue =  oPhaseAction.value;									//��ȡ��������
		var phaseUser =  document.forms["Phase"].elements["PhaseUser"].value;		//��ȡ��Ա
		
		document.getElementById("nextPhaseInfo").innerHTML="";		//�����һ�׶���Ϣ
		if(phaseUser==""){
			document.forms["Phase"].elements["PhaseUser"].value = ""; 
		}
		
		if(type==1){
			var PhaseNo = "<%=sPhaseNo%>";
			var sUserID = "<%=CurUser.getUserID()%>";
			var sOrgID  = "<%=CurUser.getOrgID()%>";
			
			//��ȡ��Ա�б�
			var sUserList = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessProcessAction","getTaskParticipants",
					 	"UserID="+sUserID+",ProcessAction="+phaseActionValue+",ProcessDefID=<%=sProcessDefID%>,ProcessTaskID=<%=sProcessTaskID%>");
		 	//��ȡ��ѡ��ʶ
			var sMultipleFlag = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessProcessAction","getNextState",
					 	"UserID="+sUserID+",ProcessAction="+phaseActionValue+",ProcessDefID=<%=sProcessDefID%>,ProcessTaskID=<%=sProcessTaskID%>");
			//����������Ա�б�
			genUserList(sUserList,sMultipleFlag);
		}

		//������һ�׶���Ϣ
		var sNextPhaseInfo = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessProcessAction",
						"getNextActivityInfo","ProcessTaskID=<%=sProcessTaskID%>,ProcessAction="+phaseActionValue+",ProcessDefID=<%=sProcessDefID%>,TaskParticipants="+phaseUser);
		$("#nextPhaseInfo").html(sNextPhaseInfo);
		//document.getElementById("nextPhaseInfo").innerHTML = sNextPhaseInfo;
	}
	
	/*~[Describe=������Ա�б�;InputParam= �磺{{test11 ϵͳ����Ա},{test11 ��ͨ�û�}};OutPutParam=��;]~*/
	function genUserList(action,flag){
		sUserList = eval('new Array('+action+')');
		oSelect = document.forms["Phase"].elements["PhaseUser"];
		if(flag=="CounterSign"){oSelect.multiple=true;}
		if(flag=="Task"){oSelect.multiple=false;}
		oSelect.options.length = 1;
		for(var i=0;i<sUserList.length;i++){
			var oOption = new Option(sUserList[i],sUserList[i]);
			var sUserID = "<%=sUserID%>";
			//if(i== 0)oOption.selected = true;//Ĭ��ѡ�е�һ��
			if(oOption.text.indexOf(sUserID)<0){
				oSelect.options.add(oOption);
			}
		}
	}

	/*~[Describe=���ɷ�֧�б�;InputParam= �磺{{test11 ϵͳ����Ա},{test11 ��ͨ�û�}};OutPutParam=��;]~*/
	function genForkList(action){
		sForkList = eval('new Array('+action+')');
		oSelect = document.forms["Phase"].elements["ForkAction"];
		oSelect.options.length = 1;
		var i=0;
		while (i < sForkList.length){
			var oOption = new Option(sForkList[i],sForkList[i+1]);
			var sUserID = "<%=sUserID%>";
			//if(i== 0)oOption.selected = true;//Ĭ��ѡ�е�һ��
			if(oOption.text.indexOf(sUserID)<0){
				oSelect.options.add(oOption);
			}
			i = i + 2;
		}
	}
	
	/*~[Describe=��ȡѡ������;InputParam=��;OutPutParam=��;]~*/
	function getPhaseAction(){
		var PhaseAction = "",phaseOpinionName = "";
		var objPhaseOpinion = document.forms["Phase"].elements["PhaseAction"];
		iLength = objPhaseOpinion.length;
		for (i = 0; i <= iLength - 1; i++) {
			var oItem = objPhaseOpinion.item(i);	//��ȡ���ѡ��
			if (oItem.selected) {
				if (oItem.value != "") {
					PhaseAction += ","+ oItem.value;
					phaseOpinionName += "," +oItem.text;
				}
			}
		}
		return PhaseAction.substring(1)+"@"+phaseOpinionName.substring(1);//ȥ����һλ�ϵĶ���
	}

	/*~[Describe=��ȡѡ��Ķ���;InputParam=��;OutPutParam=��;]~*/
	function getPhaseUser(){
		var oPhaseUser = document.forms["Phase"].elements["PhaseUser"];
		var phaseUser = "";
		iLength = oPhaseUser.length;	//��ȡ�����б�ѡ�����
		for (i = 0; i <= iLength - 1; i++) {
			var oItem = oPhaseUser[i];
			if (oItem.selected) {
				if (oItem.value != "") {
					phaseUser += ";"+ oItem.value;
				}
			}
		}
		return phaseUser.substring(1);	//ȥ����һλ�ϵĶ���
	}

	/*~[Describe=�ύ����;InputParam=��;OutPutParam=��;]~*/
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
			var oItemValue = oForkAction.item(i).value;	//��ȡ��֧����ֵ
			var oItemName = oForkAction.item(i).text;	//��ȡ��֧�����ı�
			if((oItemValue.split("@").length<2)){
				alert("���["+oItemName+"]����ύ��Ա");
				return;
			}
		}

		thisPhaseAction = getPhaseAction();
		thisPhaseAction = thisPhaseAction.split("@")[0];
		//alert("PhaseAction:"+thisPhaseAction);

		//�ж��Ƿ��Ƿ�֧�ڵ��ύ�������շ�֧��Ա��Ϸ�ʽ�������������ύ��Ϸ�ʽ��
		if(thisPhaseAction.search("Fork")>= 0){
			var oForkAction = document.forms["Phase"].elements["ForkAction"];
			iLength = oForkAction.length;
			for (var i = 1; i <= iLength - 1; i++) {
				var oItemValue = oForkAction.item(i).value;	//��ȡ��֧����ֵ
				var oItemName = oForkAction.item(i).text;	//��ȡ��֧�����ı�
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
			alert("���Ƚ����ύ����ѡ�� !");
		}else if(thisPhaseOpinion.length==0 && bActionReqiured) {
		    alert("���Ƚ����ύ��Աѡ�� !");
		}else if (thisPhaseOpinion == '<%=CurUser.getUserID()%>'){
			alert("�ύ������Ϊ��ǰ�û���");
			return;
		
		}else{	
			if (confirm("�ñ�ҵ���"+document.getElementById("nextPhaseInfo").innerHTML+"\r\n��ȷ���ύ��")){
				var sReturn = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessProcessAction",
												 	  "commit",
												 	  "bizProcessObjectID=<%=sBizProcessObjectID%>,ProcessTaskID=<%=sProcessTaskID%>,ProcessDefID=<%=sProcessDefID%>,ObjectNo=<%=sObjectNo%>,ObjectType=<%=sObjectType%>,ApplyType=<%=sApplyType%>,BizProcessTaskID=<%=sBusinessTaskID%>,ProcessAction="+thisPhaseAction+",TaskParticipants="+thisPhaseOpinion+",PhaseNo="+PhaseNo+",ProcessState="+NextFlowState+",UserID="+sUserID+",OrgID="+sOrgID);   				
				/* if (sReturn == "SUCCESS"){
					if(document.getElementById("smsFlag").checked){
						Recipient = thisPhaseOpinion.split(" ")[0]; //�½׶���Ա
						sSubject = "������������";
						sBody = "��Ŀǰ������������ע����ģ�";
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