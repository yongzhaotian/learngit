<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String sDefaultNode = CurPage.getParameter("DefaultNode"); //Ĭ�ϴ򿪽ڵ�
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"���˵�����","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	tviTemp.initWithSql("SortNo","MenuName","MenuID","","","from AWE_MENU_INFO where 1 = 1 ","Order By SortNo",Sqlca);
	String sButtons[][] = {
		{"true","All","Button","����","����һ����¼","newRecord()","","","","btn_icon_add"},
		{"true","All","Button","����","���ø�����¼","changeMenuState('1')","","","",""},
		{"true","All","Button","ͣ��","ͣ�ø�����¼","changeMenuState('2')","","","",""},
		{"true","All","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()","","","","btn_icon_delete"},
		{"true","All","Button","���ý�ɫ","���ÿɼ���ɫ","selectMenuRoles()","","","",""},
		{"false","","Button","ˢ�»���","","reloadCacheAll()","","","",""},
		{"true","","Button","��ѯ","","showTVSearch()","","","",""},
	};
%><%@include file="/Resources/CodeParts/View07.jsp"%>
<script type="text/javascript">
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItem('<%=sDefaultNode%>');
	}
	<%/*[Describe=������¼;]*/%>
	function newRecord(){
        OpenPage("/AppConfig/MenuManage/MenuInfo.jsp","frameright","");
	}

	function changeMenuState(sChange){ // ���� 1��ͣ�� 2
		var sSortNo = getCurTVItem().id; //���ݲ˵������ɣ�����ȡ���ǲ˵������
		var sMenuID = getCurTVItem().value;
		if(!sMenuID){
			alert(getMessageText('AWEW1001'));//��ѡ��һ����Ϣ��
			return ;
		}
		var sAction = "";
		if(sChange == "1") sAction = "����";
		else if(sChange == "2") sAction = "ͣ��";
		else sAction = "����";

		var sIncludeSubs = "false";
		if(confirm("�Ƿ�ͬʱ"+sAction+"���²˵���")){
			sIncludeSubs = "true";
		}
		var sPara = "MenuID="+sMenuID+",SortNo="+sSortNo+",Flag="+sChange+",IncludeSubs="+sIncludeSubs;
		var sReturn = RunJavaMethodSqlca("com.amarsoft.app.awe.config.menu.action.ChangeMenuState","changeMenuState",sPara);
		if(sReturn != "SUCCEEDED"){
			alert(sAction+"�ò˵���ʧ�ܣ�");
		}else{
		    alert("����Ŀ��"+sAction+"�ɹ���");
		    OpenPage("/AppConfig/MenuManage/MenuInfo.jsp?MenuID="+sMenuID, "frameright"); //���´򿪽ڵ�
		}
	}
	
    function openChildComp(sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		AsControl.OpenView(sURL,sParaStringTmp,"frameright");
	}
	
	<%/*[Describe=����ڵ��¼�,�鿴���޸�����;]*/%>
	function TreeViewOnClick(){
		var sMenuID = getCurTVItem().value;
		if(!sMenuID){
			OpenPage("/AppMain/Blank.jsp?TextToShow=��ѡ�������ͼ�ڵ�!", "frameright");
		}else if(sMenuID=="root"){
		}else{
	      	OpenPage("/AppConfig/MenuManage/MenuInfo.jsp?MenuID="+sMenuID, "frameright"); 
		}
	}

	<%/*[Describe=ɾ����¼;]*/%>
	function deleteRecord(){
		var sMenuID = getCurTVItem().value;
		if(!sMenuID){
			alert(getMessageText('AWEW1001'));//��ѡ��һ����Ϣ��
			return ;
		}
		if(confirm("ɾ���ü�¼��ͬʱɾ������ɼ���ɫ�Ĺ�����ϵ��\n��ȷ��ɾ����")){
			var sReturn = RunJavaMethodSqlca("com.amarsoft.app.awe.config.menu.action.DeleteMenuAction","deleteMenuAndRela","MenuID="+sMenuID);
			if(typeof sReturn != "undefined" && sReturn == "SUCCEEDED"){
				AsControl.OpenView("/AppConfig/MenuManage/MenuTree.jsp", "", "frameleft", "");
				AsControl.OpenView("/Blank.jsp","TextToShow=�������ѡ��һ��","frameright","");
			}
		}
	}
	
	<%/*[Describe=ѡ��˵��ɼ���ɫ;]*/%>
	function selectMenuRoles(){
		var sMenuID = getCurTVItem().value;
		var sMenuName = getCurTVItem().name;
		if(!sMenuID){
			alert(getMessageText('AWEW1001'));//��ѡ��һ����Ϣ��
			return ;
		}else{
			AsControl.PopView("/AppConfig/MenuManage/SelectMenuRoleTree.jsp","MenuID="+sMenuID+"&MenuName="+sMenuName,"dialogWidth=440px;dialogHeight=500px;center:yes;resizable:no;scrollbars:no;status:no;help:no");
        }
    }
	<%/*ˢ�����л���*/%>
	function reloadCacheAll(){
		var sReturn = RunJavaMethod("com.amarsoft.app.awe.common.action.ReloadCacheConfigAction","reloadCacheAll","");
		if(sReturn=="SUCCESS") alert("ˢ�³ɹ���");
		else alert("ˢ��ʧ�ܣ�");
	}
	
	startMenu();
</script>
<%@ include file="/IncludeEnd.jsp"%>