<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵����
	*/
	String PG_TITLE = "��������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ϸ��Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//���ҳ�����
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgID"));
	if(sOrgID == null) sOrgID = "1";

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView = " from ORG_INFO where OrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%')";
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
			OpenComp("OrgList","/AppConfig/OrgUserManage/OrgList.jsp","ComponentName=��������&OrgID="+sOrgID,"right");
			setTitle(getCurTVItem().name);
		}
	}
	
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		expandNode('1');
		expandNode('11');
		selectItem('<%=sOrgID%>');
	}
	
	function reloadView(){
		var node = getCurTVItem();
		if(node) sOrgID = node.value;
		AsControl.OpenView("/AppConfig/OrgUserManage/OrgManageMain.jsp", "OrgID="+sOrgID, "_top");
	}
	
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>