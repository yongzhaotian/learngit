<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zllin@amarsoft.com
		Tester:
		Describe: ��Ȩά���б�
		Input Param:
				
		Output Param:
				
		HistoryLog:
							
	 */
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ȩά���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","160");
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject("AuthorSceneGroupList",Sqlca);

	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��

	String sButtons[][] = {
		{"true","","Button","����","������Ȩ������","newRecord()",sResourcesPath},
		{"true","","Button","�༭","�༭��Ȩ������","editSceneGroup()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����Ȩ������","deleteSceneGroup()",sResourcesPath},
		//ˢ�»��湦������Ŀ������ʹ��
		{"false","","Button","ˢ�»���","ˢ����Ȩ���û���","reloadCache()",sResourcesPath},
		};
	%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	function newRecord(){
		OpenPage("/Common/Configurator/Authorization/SceneGroupInfo.jsp","DetailFrame","");
	}
	
	function editSceneGroup(){
		var sGroupID = getItemValue(0,getRow(),"GROUPID");//--���������
		if(typeof(sGroupID)=="undefined" || sGroupID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			OpenPage("/Common/Configurator/Authorization/SceneGroupInfo.jsp?GroupID="+sGroupID,"DetailFrame","");
		}
	}
	
	function deleteSceneGroup(){
		var sGroupID = getItemValue(0,getRow(),"GROUPID");//--���������
		var sGroupName = getItemValue(0,getRow(),"GROUPNAME");//--�����������
		if(typeof(sGroupID)=="undefined" || sGroupID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			if(!confirm("��ͬʱɾ�������µ���Ȩ����,ȷ��ɾ����Ȩ�����顾"+sGroupName+"����?")) return;
			var sReturn = RunMethod("PublicMethod","AuthorObjectManage","remove,SceneGroup,"+sGroupID);
			if(sReturn && sReturn == "SUCCESSFUL"){
				alert("ɾ����Ȩ�����顾"+sGroupName+"���ɹ�.");
			}else{
				alert("ɾ����Ȩ���ʧ�ܣ�");
				return;
			}
		}
		reloadSelf();
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

	function mySelectRow(){
		var sGroupID = getItemValue(0,getRow(),"GROUPID");//--���������
		if(typeof(sGroupID)=="undefined" || sGroupID.length==0) {
		}else{
			OpenPage("/Common/Configurator/Authorization/RuleSceneList.jsp?GroupID="+sGroupID,"DetailFrame","");
		}
	}
    
</script>
<script	type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	//OpenPage("/Blank.jsp?TextToShow=����ѡ����Ӧ����Ȩ����!","DetailFrame","");
</script>
<%@	include file="/IncludeEnd.jsp"%>