<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%@page import="com.amarsoft.app.als.process.util.ProcessHelp,
                java.util.Map,
                com.amarsoft.app.als.process.action.BusinessProcessAction,
                " %>
<%
	String sBusinessTaskID = CurPage.getParameter("BusinessTaskID");   			//������ˮ��
	String sProcessTaskID = CurPage.getParameter("ProcessTaskID");     			//��������������ˮ��
	String sProcessDefID = CurPage.getParameter("ProcessDefID");       			//���̶�����,FlowNo
	String sApplyNo = CurPage.getParameter("ApplyNo");     			   			//������
	String sApplyType = CurPage.getParameter("ApplyType");   		   			//��������
	String sBizProcessObjectID = CurPage.getParameter("BizProcessObjectID");    //���̶�����ˮ��
	String sPhaseNo = CurPage.getParameter("PhaseNo"); 							//�׶α��
	
	if(sBusinessTaskID == null) sBusinessTaskID = "";
	if(sProcessTaskID == null) sProcessTaskID = "";
	if(sProcessDefID == null) sProcessDefID = "";
	if(sApplyNo == null) sApplyNo = "";
	if(sApplyType == null) sApplyType = "";
	if(sBizProcessObjectID == null) sBizProcessObjectID = "";
	if(sPhaseNo == null) sPhaseNo = "";
	//������Ϣ
	String sUserID = CurUser.getUserID();//�û�ID
	ASUserObject asCurUser = ASUserObject.getUser(sUserID);
	String sOrgType = asCurUser.getOrgType();
	//��Ȩ��������
	CRProcessPower power = new CRProcessPower(sApplyNo,CurUser.getOrgID(),sUserID); 
	String powerParam = power.powerParam();
	BusinessProcessAction bpAction = new BusinessProcessAction();
	bpAction.setProcessTaskID(sProcessTaskID);
	bpAction.setRelativeData("POWER_01="+powerParam+"@"+"CREDIT.ORGTYPE="+sOrgType);
	String sResult = bpAction.setProcessObject();
	if("SUCCESS".equals(sResult)){
		System.out.println("�������ݳɹ���");
	}
	
	
	
	//ȡ���ύ�����б�
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
					<td width="50%" align="right"><%=new Button("�ύ","ȷ���ύ","javascript:commitAction();","","btn_icon_Submit","").getHtmlText()%></td>	
					<td width="50%" align="center"><%=new Button("����","�����ύ","javascript:doCancel();","","btn_icon_delete","").getHtmlText()%></td>
				</tr>
   			</table>
	    </td>
	</tr>
	<tr>
		<td><font color="#000000"><b>��ѡ����һ�׶��ύ������</b></font></td>
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
		<td><font color="#000000"><b>��ѡ����һ�׶��ύ�����</b></font></td>
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
	var bActionReqiured = true;	//�Ƿ���Ҫѡ���������Ϊ�˻�һ��ģ��Ͳ���Ҫѡ����һ��Action��)
	
	/*~[Describe=ҳ����غ󣬳�ʼ������;InputParam=��;OutPutParam=��;]~*/
	$(document).ready(function(){
		document.getElementById("selectlist").style.display = "none";//���ض���ѡ���
		document.onkeydown = function(){
			if(event.keyCode==27){
				top.returnValue = "_CANCEL_"; 
				top.close();
			}
		};
	});
	
	/*~[Describe=ȡ���ύ;InputParam=��;OutPutParam=��;]~*/
	function doCancel(){
		if(confirm("��ȷ��Ҫ�����˴��ύ��")){
			//�����ղŵ�ѡ�����
			document.forms["Phase"].elements["PhaseOpinion"].value = "";
			document.getElementById("selectlist").style.display = "none";
			document.forms["Phase"].elements["PhaseAction"].value = "";
			document.getElementById("nextPaseInfo").innerHTML="";
			top.returnValue = "_CANCEL_";
			top.close();
		}
	}

	/*~[Describe=���ƶ���ѡ�񴰿�;InputParam=��;OutPutParam=��;]~*/
	function doActionList(){
		var thisPhaseOpinion = "";	
		var thisPhaseAction  = "";
		var objPhaseOpinion = document.forms["Phase"].elements["PhaseOpinion"];
		iLength =  objPhaseOpinion.length;	//ȡ�ɹ�ѡ����������
		for(i = 0;i <= iLength - 1;i++){
			var stdItem = objPhaseOpinion.item(i);	//ȡ��ѡ�������Ķ���
			document.getElementById("nextPaseInfo").innerHTML="";//�������һ�׶���Ϣ
			if (stdItem.selected){
				var vItem = stdItem.text;	//ȡ����ѡ������
				if(vItem != ""){
					if(true){
						document.getElementById("selectlist").style.display = "none";
		    			bActionReqiured = true;
		    			getNextPaseInfo(1);	//����һ�׶���Ϣ
					}
				}else{
					document.getElementById("selectlist").style.display = "none";
				}
			}
		}
	}
	/*~[Describe=��ȡ��һ�׶���Ϣ;InputParam=type 0��ʾ�������,1��ʾ��������;OutPutParam=��;]~*/
	function getNextPaseInfo(type){
		var objPhaseOpinion = document.forms["Phase"].elements["PhaseOpinion"];
		var phaseOpinion =  objPhaseOpinion.options[objPhaseOpinion.selectedIndex].text;	//��ȡ���
		var phaseOpinionvalue =  objPhaseOpinion.value;									//��ȡ�������
		var phaseAction =  document.forms["Phase"].elements["PhaseAction"].value;			//��ȡ����
		document.getElementById("nextPaseInfo").innerHTML="";
		if(phaseAction==""){
			document.forms["Phase"].elements["PhaseAction"].value = "";
		}
		//���Ϊѡ����������˺���������Ҫͨ��ajaxȥ��ȡ����б�
		if(type == 1){
			var sActionList = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessActivityAction","getTaskParticipants",
												 "UserID=<%=sUserID%>,ProcessAction="+phaseOpinionvalue+",ProcessDefID=<%=sProcessDefID%>,ProcessTaskID=<%=sProcessTaskID%>");
			var thisPhaseOpinion = getPaseOpinion();		
			if(sActionList.length == 4 && thisPhaseOpinion.substring(0,3)!="End"){
				alert("��һ�׶�û�д����ˣ������ύ��");
				return;
			}
			var sFlag = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessActivityAction","getNextState",
					 							 "UserID=<%=sUserID%>,ProcessAction="+phaseOpinionvalue+",ProcessDefID=<%=sProcessDefID%>,ProcessTaskID=<%=sProcessTaskID%>");
			
			genActionList(sActionList,sFlag);
		}

		phaseOpinion = getPaseOpinion();		//��ȡѡ������
		phaseAction = getPaseAction();			//��ȡѡ��Ķ���
		if(!phaseOpinion ||(!phaseAction && (phaseOpinion.indexOf("ͬ��")>0 || phaseOpinion.indexOf("���")>0 || phaseOpinion.indexOf("����") || phaseOpinion.indexOf("�����")>0 || phaseOpinion.indexOf("�ύ")>0))){			
			//alert("���Ƚ����ύ���ѡ�� !");
			document.getElementById("nextPaseInfo").innerHTML="";
		}else{
			document.getElementById("nextPaseInfo").innerHTML = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessActivityAction",
																		"getNextActivityInfo",
																		"ProcessTaskID=<%=sProcessTaskID%>,ProcessAction="+phaseOpinionvalue+",ProcessDefID=<%=sProcessDefID%>,ProcessOpinion="+phaseAction);
		}
	}
	
	/*~[Describe=��������б�;InputParam= �磺{{test11 ϵͳ����Ա},{test11 ��ͨ�û�}};OutPutParam=��;]~*/
	function genActionList(action,flag){
		sActionList = eval('new Array('+action+')');
		oSelect = document.forms["Phase"].elements["PhaseAction"];
		if(flag=="CounterSign"){oSelect.multiple=true;}
		if(flag=="Task"){oSelect.multiple=false;}
		oSelect.options.length = 1;
		for(var i=0;i<sActionList.length;i++){
			var oOption = new Option(sActionList[i],sActionList[i]);
			//if(i== 0)oOption.selected = true;//Ĭ��ѡ�е�һ��
			oSelect.options.add(oOption);
		}
	}
	
	/*~[Describe=��ȡѡ������;InputParam=��;OutPutParam=��;]~*/
	function getPaseOpinion(){
		var phaseOpinion = "";
		var objPhaseOpinion = document.forms["Phase"].elements["PhaseOpinion"];
		iLength = objPhaseOpinion.length;
		for (i = 0; i <= iLength - 1; i++) {
			var oItem = objPhaseOpinion.item(i);	//��ȡ���ѡ��
			if (oItem.selected) {
				if (oItem.value != "") {
					phaseOpinion += ","+ oItem.value;
				}
			}
		}
		return phaseOpinion.substring(1);//ȥ����һλ�ϵĶ���
	}

	/*~[Describe=��ȡѡ��Ķ���;InputParam=��;OutPutParam=��;]~*/
	function getPaseAction(){
		var objPhaseAction = document.forms["Phase"].elements["PhaseAction"];
		var phaseAction = "";
		iLength = objPhaseAction.length;	//��ȡ�����б�ѡ�����
		for (i = 0; i <= iLength - 1; i++) {
			var oItem = objPhaseAction[i];
			if (oItem.selected) {
				if (oItem.value != "") {
					phaseAction += ";"+ oItem.value;
				}
			}
		}
		return phaseAction.substring(1);	//ȥ����һλ�ϵĶ���
	}

	/*~[Describe=�ύ����;InputParam=��;OutPutParam=��;]~*/
	function commitAction(){
		var PhaseNo = "<%=sPhaseNo%>";
		var thisPhaseAction  = "";
		var thisPhaseOpinion = "";
		thisPhaseAction = getPaseAction();			
		thisPhaseOpinion = getPaseOpinion();
		thisPhaseOpinion = thisPhaseOpinion.split("@")[0];																									
		// ��һ�׶�û�д����˲������ύ
		var objPhaseOpinion = document.forms["Phase"].elements["PhaseOpinion"];
		if(objPhaseOpinion.selectedIndex=="-1")return;
		var phaseOpinion =  objPhaseOpinion.options[objPhaseOpinion.selectedIndex].text;	//��ȡ���
		var phaseOpinionvalue =  objPhaseOpinion.value;
		var sActionList = RunJavaMethodSqlca("com.amarsoft.app.als.process.action.BusinessActivityAction","getTaskParticipants",
				"UserID=<%=sUserID%>,ProcessAction="+phaseOpinionvalue+",ProcessDefID=<%=sProcessDefID%>,ProcessTaskID=<%=sProcessTaskID%>");
		if(sActionList.length == 4 && thisPhaseOpinion.substring(0,3)!="End"){
			alert("��һ�׶�û�д����ˣ������ύ��");
			return;
		}						
		if(thisPhaseOpinion.length == 0){				
			alert("���Ƚ����ύ����ѡ�� !");
		}else if(false) {
			alert("���Ƚ����ύ���ѡ�� !");
		}else if (thisPhaseAction == '<%=CurUser.getUserID()%>'){
			alert("�ύ������Ϊ��ǰ�û���");
			return;
		}else{			
			if (confirm("�ñ�ҵ���"+document.getElementById("nextPaseInfo").innerHTML+"\r\n��ȷ���ύ��")){
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