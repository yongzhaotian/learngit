<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    ������ͼ
	 */
	String PG_TITLE = "������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;������Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	
	//����������	
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sViewID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewID"));
	String sItemID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemID"));
	if(sFlowNo == null) sFlowNo = "";
   	if(sViewID == null) sViewID = "";
   	if(sItemID == null) sItemID = "";	

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"������������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo='FlowCatalogView' and IsInUse='1' ";
	sSqlTreeView += "and (RelativeCode like '%"+sViewID+"%' or RelativeCode='All') ";//��ͼfilter Add by zhuang 2010-03-17

	tviTemp.initWithSql("SortNo","ItemName","ItemName","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	//treeview����ѡ���¼�
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		if(sCurItemID=="0010"){
			openChildComp("FlowCatalogInfo","/Common/Configurator/FlowManage/FlowCatalogInfo.jsp","FlowNo=<%=sFlowNo%>");
		}else if(sCurItemID=="0020"){
			openChildComp("FlowModelList","/Common/Configurator/FlowManage/FlowModelList.jsp","FlowNo=<%=sFlowNo%>");
		}
		setTitle(getCurTVItem().name);
	}
	
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	startMenu();
	expandNode('root');
	selectItem('0010');
</script>
<%@ include file="/IncludeEnd.jsp"%>