<%@page import="com.amarsoft.app.awe.config.function.model.ResourceTree"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String sDefaultNode = CurPage.getParameter("DefaultNode"); //Ĭ�ϴ򿪽ڵ�
	if(sDefaultNode == null) sDefaultNode = "";

	HTMLTreeView tviTemp = new ResourceTree().getResourceTree(Sqlca, "���ܵ�����");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
	
	String sButtons[][] = {
		{"true","All","Button","����","����һ����¼","newRecord()","","","","btn_icon_add"},
		{"true","All","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()","","","","btn_icon_delete"},
		{"true","","Button","��ѯ","","showTVSearch()","","","",""},
	};
%><%@include file="/Resources/CodeParts/View07.jsp"%>
<script type="text/javascript">
	function openChildComp(sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";
	
		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		AsControl.OpenView(sURL,sParaStringTmp,"frameright");
	}
	function TreeViewOnClick(){
		var sID = getCurTVItem().id;
		var sNodeType = getCurTVItem().value; //�������value���������ֽڵ�����ͣ�ģ�顢���ܵ㡢��ť�е�һ��
		if(sNodeType=="Function"){ //���ܵ�
			openChildComp("/AppConfig/FunctionManage/FunctionInfo.jsp","FunctionID="+sID);
		}else if(sNodeType=="RightPoint"){ //Ȩ�޵�
			var sParentID = getCurTVItem().parentID; //���ڵ����
			openChildComp("/AppConfig/FunctionManage/RightPointInfo.jsp", "FunctionID="+sParentID+"&SerialNo="+sID);
		}else{
			openChildComp("/AppConfig/MenuManage/MenuInfo.jsp","MenuID="+sID+"&RightType=ReadOnly");
		}
	}
	
	function newRecord(){
		var sID = getCurTVItem().id;
		var sName = getCurTVItem().name;
		if(!sID){
			alert(getMessageText('AWEW1001'));//��ѡ��һ����Ϣ��
			return ;
		}
		var sNodeType = getCurTVItem().value; //�������value���������ֽڵ�����ͣ�ģ�顢���ܵ㡢��ť�е�һ��
		if(sNodeType=="Function"){ //���ܵ�������Ȩ�޵�
			alert("������ѡ�ڵ㡾"+sName+"��������<Ȩ�޵�>���ã�");
			openChildComp("/AppConfig/FunctionManage/RightPointInfo.jsp", "FunctionID="+sID+"&RightPointType=button");
		}else if(sNodeType=="RightPoint"){ //Ȩ�޵����ͽڵ��²����κβ���
			return;
		}else{
			alert("������ѡ�ڵ㡾"+sName+"��������<���ܵ�>���ã�");
			openChildComp("/AppConfig/FunctionManage/FunctionInfo.jsp", "ModuleID="+sID+"&ModuleName="+sName);
		}
	}
	
	function deleteRecord(){
		var sID = getCurTVItem().id;
		if(!sID){
			alert(getMessageText('AWEW1001'));//��ѡ��һ����Ϣ��
			return ;
		}
		var sNodeType = getCurTVItem().value;
		if(sNodeType=="Function"){
			if(confirm("ɾ���ü�¼��ͬʱɾ������ɼ���ɫ�Ĺ�����ϵ��\n��ȷ��ɾ����")){
				var sReturn = RunJavaMethodTrans("com.amarsoft.app.awe.config.function.action.DeleteFunctionAction","deleteFuncAndRela","FunctionID="+sID);
				if(typeof sReturn != "undefined" && sReturn == "SUCCEEDED"){
					AsControl.OpenView("/AppConfig/FunctionManage/FunctionConfTree.jsp", "", "frameleft", "");
					AsControl.OpenView("/Blank.jsp","TextToShow=�������ѡ��һ��","frameright","");
				}
			}
		}else if(sNodeType=="RightPoint"){
			if(confirm("ɾ���ü�¼��ͬʱɾ������ɼ���ɫ�Ĺ�����ϵ��\n��ȷ��ɾ����")){
				var sReturn = RunJavaMethodTrans("com.amarsoft.app.awe.config.function.action.DeleteRightPointAction","deleteRightAndRela","RightPointNo="+sID);
				if(typeof sReturn != "undefined" && sReturn == "SUCCEEDED"){
					AsControl.OpenView("/AppConfig/FunctionManage/FunctionConfTree.jsp", "", "frameleft", "");
					AsControl.OpenView("/Blank.jsp","TextToShow=�������ѡ��һ��","frameright","");
				}
			}
		}else{
			alert("�ýڵ㲻��ɾ����");
			return;
		}
	}
	
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItem('<%=sDefaultNode%>');
	}
	
	startMenu();
</script>
<%@ include file="/IncludeEnd.jsp"%>