<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.biz.workflow.*" %>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
<%
	/*
		Author: byhu 2004-12-06 
		Tester:
		Describe: �ύѡ���
		Input Param:
			SerialNo��������ˮ��
		Output Param:
		HistoryLog: zywei 2005/08/01
								syang 2009/10/15 ʹ��ajax��дҳ�棬����붯����������
	 */
%>
<%/*~END~*/%> 


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<% 
	//��ȡ������������ˮ��
	String sSerialNo = CurPage.getParameter("SerialNo");//���ϸ�ҳ��õ������������ˮ��
	String oldPhaseNo = CurPage.getParameter("oldPhaseNo");//��ǰ���ύҵ�������׶�
	String objectType = CurPage.getParameter("objectType");//��ǰ���ύҵ�����������е����̶�������
	String objectNo = CurPage.getParameter("objectNo");//��ǰ���ύҵ�����������е����̶�����
	//������������̱�š��׶α�š�������
	String sFlowNo = "",sPhaseNo = "";
	
	//��������������������б��׶ε����͡�������ʾ���׶ε�����
	String sSelectStyle = "",sPhaseAttribute = "",sPhaseOpinion1[]; 
	String sSql="";
	ASResultSet rsTemp = null;
%>
<%/*~END~*/%>	


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=����ҵ���߼�����;]~*/%>
<%	
	//���������̱�FLOW_TASK�в�ѯ�����̱�š��׶α��
	sSql = "select FlowNo,PhaseNo from FLOW_TASK where SerialNo = :SerialNo ";
	rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
	if (rsTemp.next()){
		sFlowNo  = DataConvert.toString(rsTemp.getString("FlowNo"));
		sPhaseNo  = DataConvert.toString(rsTemp.getString("PhaseNo"));
		
		//����ֵת���ɿ��ַ���
		if(sFlowNo == null) sFlowNo = "";
		if(sPhaseNo == null) sPhaseNo = "";				
	}
	rsTemp.getStatement().close();
	
	//������ģ�ͱ�FLOW_MODEL�в�ѯ���׶����ԡ��׶�����
	sSql = "select PhaseAttribute,ActionDescribe from FLOW_MODEL where FlowNo = :FlowNo and PhaseNo = :PhaseNo";
	rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("FlowNo",sFlowNo).setParameter("PhaseNo",sPhaseNo));
	if (rsTemp.next()){
		sPhaseAttribute  = DataConvert.toString(rsTemp.getString("PhaseAttribute"));
		
		//����ֵת���ɿ��ַ���
		if(sPhaseAttribute == null) sPhaseAttribute = "";
		if(sSelectStyle == null) sSelectStyle = "";
		sSelectStyle = StringFunction.getProfileString(sPhaseAttribute,"ActionStyle");
	}
	rsTemp.getStatement().close();
	rsTemp = null;

	//��ʼ���������
	FlowTask ftBusiness = new FlowTask(sSerialNo,Sqlca);

	sPhaseOpinion1 = ftBusiness.getChoiceList();
	if(sPhaseOpinion1 == null){
		sPhaseOpinion1 = new String[1];
		sPhaseOpinion1[0] = "";
	}
%>
<%/*~END~*/%>	


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=����ѡ���ύ����������;]~*/%>
	<html>
	<head>
		<title>�ύ����ѡ���б�</title>
	</head>
	<body class="ShowModalPage" leftmargin="0" topmargin="0" onload="" >
	<form name="Phase" method="post" target="_top">
	<table width="100%" align="center">
		<tr width="100%" >
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
			<td>���ѡ���б�</td>
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
			<td>����ѡ���б�</td>
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


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">		

	var bActionReqiured = true;	//�Ƿ���Ҫѡ���������Ϊ�˻�һ��ģ��Ͳ���Ҫѡ����һ��Action��)
	
	window.onload = function(){
		initPage();
	}
	/*~[Describe=ҳ����غ󣬳�ʼ������;InputParam=��;OutPutParam=��;]~*/
	function initPage(){
		document.getElementById("selectlist").style.display = "none";//���ض���ѡ���
	}
	
	/*~[Describe=ȡ���ύ;InputParam=��;OutPutParam=��;]~*/
	function doCancel(){
		if(confirm("��ȷ��Ҫ�����˴��ύ��")){
			top.returnValue = "_CANCEL_";
			top.close();
		}
	}

	/*~[Describe=���ƶ���ѡ�񴰿�;InputParam=��;OutPutParam=��;]~*/
	function doActionList(){
		var thisPhaseOpinion1 = "";	
		var thisPhaseAction  = "";
		<%-- var roleSubmit = RunJavaMethodSqlca("com.amarsoft.biz.workflow.FlowUtil","isRoleSubmit","FlowNo=<%=sFlowNo%>,PhaseNo=<%=sPhaseNo%>"); --%>
		
		iLength =  document.forms["Phase"].PhaseOpinion1.length;	//ȡ�ɹ�ѡ����������
		for(i = 0;i <= iLength - 1;i++){
			var stdItem = document.forms["Phase"].PhaseOpinion1.item(i);	//ȡ��ѡ�������Ķ���
			document.getElementById("nextPaseInfo").innerHTML="";//�������һ�׶���Ϣ
			if (stdItem.selected){
				var vItem = stdItem.value;	//ȡ����ѡ������
				if(vItem != ""){
	    			document.getElementById("selectlist").style.display = "";
					if ( vItem.search("����������") >= 0 ){
		    			bActionReqiured = true;
					}else{
						bActionReqiured = false;
					}
	    			
					var phaseOpinion1 = getPaseOpinion();		//��ȡѡ������
					//�õ��ύ���б�
					var sSerialNo = "<%=sSerialNo%>";
					var sActionList = PopPageAjax("/Common/WorkFlow/GetPhaseActionAjax.jsp?SerialNo=<%=sSerialNo%>&PhaseOpinion1="+phaseOpinion1);
					genActionList(sActionList);
					
					var phaseAction = getPaseAction();			//��ȡѡ��Ķ���
					
					//��ʾ��һ�׶�
					var url="/Common/WorkFlow/GetNextFlowPhaseAJAX.jsp";
					url += "?SerialNo=<%=sSerialNo%>&PhaseAction="+ phaseAction + "&PhaseOpinion1=" + phaseOpinion1;
					document.getElementById("nextPaseInfo").innerHTML = PopPageAjax(url);
					
				}else{
						document.getElementById("selectlist").style.display = "none";
				}
			}
		}
	}
	/*~[Describe=��ȡ��һ�׶���Ϣ;InputParam=type 1��ʾ�������,2��ʾ��������;OutPutParam=��;]~*/
	function getNextPaseInfo(type){
		var phaseOpinion1 =  document.forms["Phase"].PhaseOpinion1.value;	//��ȡ���
		var phaseAction =  document.forms["Phase"].PhaseAction.value;			//��ȡ����
		
		if(phaseOpinion1.substring(0,2)=="ͬ��" 
			|| phaseOpinion1.substring(0,2)=="�ύ" 
			|| phaseOpinion1.substring(0,2)=="����" 
			|| phaseOpinion1.substring(0,2)=="����"){//add by jgao1 2009-10-12 for ��������ֵ׼������
			
			document.getElementById("nextPaseInfo").innerHTML="";
			if(phaseAction==""){
				document.forms["Phase"].PhaseAction.value = "";
			}
		}else{	//���Ϊ�˻�һ��ģ������ѡ����
			//document.forms["Phase"].PhaseAction.value = "";
		}
		
		//���Ϊѡ����������˺���������Ҫͨ��ajaxȥ��ȡ����б�
		if(type == 1 || type == 3){
			var sSerialNo = "<%=sSerialNo%>";
			var sActionList = PopPageAjax("/Common/WorkFlow/GetPhaseActionAjax.jsp?SerialNo="+sSerialNo+"&PhaseOpinion1="+phaseOpinion1);
			genActionList(sActionList);
		}
		
		phaseOpinion1 = getPaseOpinion();		//��ȡѡ������
		phaseAction = getPaseAction();			//��ȡѡ��Ķ���
		if(type != 3 && (phaseOpinion1.length == 0 ||(phaseAction==""  && (phaseOpinion1.substring(0,2)=="ͬ��" || phaseOpinion1.substring(0,2)=="�ύ" || phaseOpinion1.substring(0,2)=="����" || phaseOpinion1.substring(0,2)=="����")))){				
			//alert("���Ƚ����ύ���ѡ�� !");
			document.getElementById("nextPaseInfo").innerHTML="";
		}else{
			var url="/Common/WorkFlow/GetNextFlowPhaseAJAX.jsp";
			url += "?SerialNo=<%=sSerialNo%>&PhaseAction="+ phaseAction + "&PhaseOpinion1=" + phaseOpinion1;
			document.getElementById("nextPaseInfo").innerHTML = PopPageAjax(url);
		}
	}
	
	/*~[Describe=��������б�;InputParam= �磺{{test11 ϵͳ����Ա},{test11 ��ͨ�û�}};OutPutParam=��;]~*/
	function genActionList(action){
		sActionList = eval('new Array('+action+')');
		oSelect = document.forms["Phase"].elements["PhaseAction"];
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
		iLength = document.forms["Phase"].PhaseOpinion1.length;
		for (i = 0; i <= iLength - 1; i++) {
			var oItem = document.forms["Phase"].PhaseOpinion1.item(i);	//��ȡ���ѡ��
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
		var phaseAction = "";
		iLength = document.forms["Phase"].PhaseAction.length;	//��ȡ�����б�ѡ�����
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
		return str;	//ȥ����һλ�ϵĶ���
	}

	/*~[Describe=�ύ����;InputParam=��;OutPutParam=��;]~*/
	function commitAction(){
		var thisPhaseAction  = "";
		var thisPhaseOpinion1 = "";
		thisPhaseAction = getPaseAction();
		thisPhaseOpinion1 = getPaseOpinion();		
		
		if(thisPhaseOpinion1.length == 0){
			alert("���Ƚ����ύ���ѡ�� !");
		}else if(thisPhaseAction.length == 0 && bActionReqiured) {
			alert("���Ƚ����ύ����ѡ�� !");
		}else if (thisPhaseAction == '<%=CurUser.getUserID()%>'){
			//alert("�ύ������Ϊ��ǰ�û���");
			//return;
		}else{
			if (confirm("�ñ�ҵ���"+document.getElementById("nextPaseInfo").innerHTML+"\r\n��ȷ���ύ��")){
				
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
