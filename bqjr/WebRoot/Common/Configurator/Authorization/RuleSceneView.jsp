<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content: 
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ȩ��������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��Ȩ��������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//������������������ơ�ģ������
	
	//���ҳ�����	

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/%>
	<%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��Ȩ���������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	tviTemp.initWithSql("SortNo","GroupName","GroupId","","","from SADRE_SCENEGROUP","Order By SortNo",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	
	String sButtons[][] = {
		{"true","","Button","����","�����������","newSceneGroup()",sResourcesPath},
		{"true","","Button","�༭","�༭�������","editSceneGroup()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ���������","deleteSceneGroup()",sResourcesPath},
		//ˢ�»��湦������Ŀ������ʹ��
		{"false","","Button","ˢ�»���","ˢ����Ȩ����","reloadCache()",sResourcesPath}
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��;]~*/%>
	<%@include file="/Common/Configurator/Authorization/View04btn.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>
	
<script language=javascript> 
	
	function newSceneGroup(){
		var sGroupID = popComp("SceneGroupInfo","/Common/Configurator/Authorization/SceneGroupInfo.jsp","","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sGroupID)=="undefined") return;
		OpenPage("/Common/Configurator/Authorization/RuleSceneView.jsp", "_self", "");
	}
	
	function editSceneGroup(){
		var sGroupID = getCurTVItem().value;//--��õ�ǰ�ڵ�Ĵ���ֵ
		if(typeof(sGroupID)=="undefined"||sGroupID=="root"){
			alert("��ѡ�񷽰����!");
			return;
		}
		sGroupID = popComp("SceneGroupInfo","/Common/Configurator/Authorization/SceneGroupInfo.jsp","GroupID=" + sGroupID,"dialogWidth=40;dialogHeight=25;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof sGroupID == "undefined" || sGroupID.length == 0) return;
		//AsControl.OpenPage("/AppConfig/Authorization/RuleSceneView.jsp", "GroupID="+sGroupID, "_self");
		OpenPage("/Common/Configurator/Authorization/RuleSceneView.jsp?GroupID="+sGroupID, "_self", "");
	}
	
	function deleteSceneGroup(){
		var sGroupID = getCurTVItem().value;//--��õ�ǰ�ڵ�Ĵ���ֵ
		if(typeof(sGroupID)=="undefined"||sGroupID=="root"){
			alert("��ѡ�񷽰����!");
			return;
		}
		var sGroupName = getCurTVItem().name;//--��õ�ǰ�ڵ�����
		if(!confirm("��ͬʱɾ�������µ���Ȩ����,ȷ��ɾ��\""+sGroupName+"\"?")) return;
		
		//var sReturn = RunJavaMethod("com.amarsoft.sadre.app.action.RemoveSceneGroup", "execute", "GroupID="+sGroupID);
		var sReturn = RunMethod("PublicMethod","AuthorObjectManage","remove,SceneGroup,"+sGroupID);
		if(sReturn && sReturn == "SUCCESSFUL"){
			alert("ɾ��\""+sGroupName+"\"�ɹ�.");
			//AsControl.OpenPage("/AppConfig/Authorization/RuleSceneView.jsp", "", "_self");
			OpenPage("/Common/Configurator/Authorization/RuleSceneView.jsp", "_self", "");
		}else{
			alert("ɾ����Ȩ���ʧ�ܣ�");
			return;
		}
	}

	function reloadCache(){
		if(confirm("������ˢ����Ȩ���建��,��ȷ��û���û�����ʹ��ϵͳ��������Ȩ��صĹ���!\n����:������ˢ����Ȩ���建��ʱ,�û�����ʹ������Ȩ��ع���,���ܵ��¹����쳣!")){
			var sReturn=RunJavaMethodSqlca("com.amarsoft.app.als.sadre.util.ReloadSADERCache","reloadSADRECache","");
			if(sReturn=="<%=com.amarsoft.app.util.RunJavaMethodAssistant.SUCCESS_MESSAGE%>"){
				alert("�ɹ�ˢ����Ȩ���建��!");
			}else{
				alert("ˢ����Ȩ���建���쳣,����ϵͳ����Ա��ϵ!");
			}
		}
	}
	
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function TreeViewOnClick()
	{
		var sCurItemName = getCurTVItem().name;//--��õ�ǰ�ڵ�����
		var sGroupID = getCurTVItem().value;//--��õ�ǰ�ڵ�Ĵ���ֵ
		
		OpenComp("RuleSceneList","/Common/Configurator/Authorization/RuleSceneList.jsp","GroupID="+sGroupID,"right");
		setTitle(getCurTVItem().name);
	}

	/*~[Describe=����������ı���;InputParam=sTitle:����;OutPutParam=��;]~*/
	function setTitle(sTitle)
	{
		document.all("table0").cells(0).innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}	
	
	function genCtrlButton(myDocument){
		myDocument.writeln("<input type=\"button\" id=\"confirm\" value=\"&nbsp;ȷ&nbsp;��&nbsp;\" alt=\"ȷ��\" onclick=\"javascript:doQuery();\"/>");
		myDocument.close();	
	}
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
	<script language="JavaScript">
	startMenu();
	expandNode('root');	
	//genCtrlButton(left.document);
	</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
