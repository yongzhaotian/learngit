<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    ����ģ����ͼ
	 */
	String PG_TITLE = "����ģ����ͼ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;����ģ����ͼ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	
	//����������	
	String sModelNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sViewID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewID"));

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ģ��Ŀ¼","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo='EvaluateCatalogView' and IsInUse='1' ";
	sSqlTreeView += "and (RelativeCode like '%"+sViewID+"%' or RelativeCode='All') ";//��ͼfilter

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
	
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		if(sCurItemID=="0010"){
			openChildComp("EvaluateCatalogInfo","/Common/Configurator/EvaluateManage/EvaluateCatalogInfo.jsp","ModelNo=<%=sModelNo%>");
		}else if(sCurItemID=="0020"){
			openChildComp("EvaluateModelList","/Common/Configurator/EvaluateManage/EvaluateModelList.jsp","ModelNo=<%=sModelNo%>");
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
	selectItemByName("������Ϣ");
</script>
<%@ include file="/IncludeEnd.jsp"%>