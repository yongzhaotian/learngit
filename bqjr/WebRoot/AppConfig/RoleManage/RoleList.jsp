<%@page import="com.amarsoft.app.util.ReloadCacheConfigAction"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "��ɫ�б�";

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "RoleList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	//���ӹ�����	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);

	//��������¼�
	dwTemp.setEvent("BeforeDelete","!Configurator.DelRoleRight(#RoleID)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{(CurUser.hasRole("099")?"true":"false"),"","Button","������ɫ","����һ�ֽ�ɫ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴��ɫ���","viewAndEdit()",sResourcesPath},
		{(CurUser.hasRole("099")?"true":"false"),"","Button","ɾ��","ɾ���ý�ɫ","deleteRecord()",sResourcesPath},
		{"true","","Button","��ɫ���û�","�鿴�ý�ɫ�����û�","viewUser()","","","",""},
		{"true","","Button","���˵���Ȩ","����ɫ��Ȩ���˵�","my_AddMenu()",sResourcesPath},
		{"true","","Button","���ɫ�˵���Ȩ","�������ɫ��Ȩ���˵�","much_AddMenu()","","","",""},
		{(CurUser.hasRole("099")?"true":"false"),"","Button","�����Ч","ͬ������������ʹ���ݿ�����Ч","reloadCacheRole()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		sReturn=popComp("RoleInfo","/AppConfig/RoleManage/RoleInfo.jsp","","");
		if (typeof(sReturn)!='undefined' && sReturn.length!=0) {
			reloadSelf();
		}
	}
	
	function viewAndEdit(){
		var sRoleID = getItemValue(0,getRow(),"RoleID");
		if (typeof(sRoleID)=="undefined" || sRoleID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
	
		sReturn=popComp("RoleInfo","/AppConfig/RoleManage/RoleInfo.jsp","RoleID="+sRoleID,"");
		//�޸����ݺ�ˢ���б�
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			reloadSelf();
		}
	}
	
	function deleteRecord(){
		var sRoleID = getItemValue(0,getRow(),"RoleID");
		if (typeof(sRoleID)=="undefined" || sRoleID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getBusinessMessage("902"))){ //ɾ���ý�ɫ��ͬʱ��ɾ���ý�ɫ��Ӧ��Ȩ�ޣ�ȷ��ɾ���ý�ɫ��
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	<%/*~[Describe=����ɫ��Ȩ���˵�;]~*/%>
	function my_AddMenu(){
		var sRoleID = getItemValue(0,getRow(),"RoleID");
		if (typeof(sRoleID)=="undefined" || sRoleID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		PopPage("/AppConfig/RoleManage/AddRoleMenu.jsp?RoleID="+sRoleID,"","400px;dialogHeight=540px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");       	
	}
	
	<%/*[Describe=�����ɫ��Ȩ���˵�;]*/%>
	function much_AddMenu(){
		PopPage("/AppConfig/RoleManage/AddMuchRoleMenus.jsp","","dialogWidth=550px;dialogHeight=600px;center:yes;resizable:yes;scrollbars:no;status:no;help:no");
	}
	
	<%/*[Describe=�鿴�ý�ɫ�����û�;]*/%>
	function viewUser(){
		var sRoleID = getItemValue(0,getRow(),"RoleID");
		if (typeof(sRoleID)=="undefined" || sRoleID.length==0){
			alert(getMessageText('AWEW1001'));//��ѡ��һ����Ϣ��
			return;
		}
		//PopPage("/AppConfig/RoleManage/ViewAllUserList.jsp?RoleID="+sRoleID,"","dialogWidth=700px;dialogHeight=540px;center:yes;resizable:yes;scrollbars:no;status:no;help:no");
		AsControl.PopView("/AppConfig/RoleManage/ViewAllUserList.jsp","RoleID="+sRoleID,"dialogWidth=700px;dialogHeight=540px;center:yes;resizable:yes;scrollbars:no;status:no;help:no");
	}
	
	<%/*~[Describe=��Ч���;]~*/%>
	function reloadCacheRole(){
		//AsDebug.reloadCacheAll();
		var sReturn = RunJavaMethod("com.amarsoft.app.util.ReloadCacheConfigAction","reloadCacheAll","");
		if(sReturn=="SUCCESS") alert("���ز�������ɹ���");
		else alert("���ز�������ʧ�ܣ�");
	}		

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>