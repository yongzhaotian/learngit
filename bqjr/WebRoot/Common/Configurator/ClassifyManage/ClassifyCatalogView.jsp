<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    ������ģ��Ŀ¼��ͼ
	 */
	String PG_TITLE = "������ģ��Ŀ¼��ͼ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;������ģ��Ŀ¼��ͼ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview����
	
	//����������	
	String sModelNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sViewID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewID"));
	String sItemID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemID"));
	if(sItemID == null) sItemID = "";
	if(sViewID == null) sViewID = "";
	if(sModelNo == null) sModelNo = "";

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"������ģ��","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo='ClassifyCatalogView' and IsInUse='1' ";
	sSqlTreeView += "and (RelativeCode like '%"+sViewID+"%' or trim(RelativeCode) ='All') ";//��ͼfilter Add by zhuang 2010-03-17

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
			openChildComp("ClassifyCatalogInfo","/Common/Configurator/ClassifyManage/ClassifyCatalogInfo.jsp","ModelNo=<%=sModelNo%>");
		}else if(sCurItemID=="0020"){
			openChildComp("ClassifyModelList","/Common/Configurator/ClassifyManage/ClassifyModelList.jsp","ModelNo=<%=sModelNo%>");
		}else if(sCurItemID=="0030"){    //����
			closeAndReturn();
		}
		setTitle(getCurTVItem().name);
	}
	
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
	
	function closeAndReturn(){
        parent.reloadOpener();
        parent.close();
    }

	startMenu();
	expandNode('root');
	expandNode('10');
	//selectItemByName("������Ϣ");
	selectItem('<%=sItemID%>');
</script>
<%@ include file="/IncludeEnd.jsp"%>