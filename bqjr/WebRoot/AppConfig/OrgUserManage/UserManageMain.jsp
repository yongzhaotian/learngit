<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵����
	*/
	String PG_TITLE = "�û�����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ϸ��Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//��ȡ�Ƿ񳵴���־	
	String sIsCar = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("isCar"));
	if(sIsCar == null) sIsCar = "";
	
	
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�û�����","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView ="";
	
	if(CurUser.hasRole("1047")){
		sSqlTreeView = " from ORG_INFO where OrgID in (select OrgID from ORG_INFO where SortNo like '10%')";
	}else{
		sSqlTreeView = " from ORG_INFO where OrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%')";
	}
	
	
	if(CurUser.hasRole("1036")){
		sSqlTreeView +=" or OrgID in (select OrgID from ORG_INFO where SortNo like '105%')";
	}
	if(CurUser.hasRole("1035")){
		sSqlTreeView +=" and OrgID not in (select OrgID from ORG_INFO where SortNo like '104%') or OrgID in (select OrgID from ORG_INFO where SortNo like '105%') ";
	}
	if(CurUser.hasRole("1036") && CurUser.hasRole("1035")){
		sSqlTreeView +=" or OrgID in (select OrgID from ORG_INFO where SortNo like '105%')";
	}

	
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	tviTemp.initWithSql("SortNo","OrgName","OrgID","","",sSqlTreeView,"Order By SortNo",Sqlca);
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	function TreeViewOnClick(){
		var sOrgID = getCurTVItem().value;		
		if(sOrgID != "null" && sOrgID!='root'){
			OpenComp("UserList","/AppConfig/OrgUserManage/UserList.jsp","ComponentName=�û�����&OrgID="+sOrgID,"right");
			setTitle(getCurTVItem().name+"��Աһ��");
		}
	}
	
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		click_change(1);
	}

	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>