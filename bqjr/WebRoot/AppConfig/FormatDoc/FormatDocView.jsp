<%@page import="com.amarsoft.biz.formatdoc.model.*"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String sDocID    = CurPage.getParameter("DocID");    		//���鱨���ĵ����
	String sObjectNo = CurPage.getParameter("ObjectNo"); 		//ҵ����ˮ��
	String sObjectType = CurPage.getParameter("ObjectType"); 	//��������
	String sMethod = CurPage.getParameter("Method");
	if(sDocID==null) sDocID="";
	if(sMethod==null) sMethod="";

	String PG_TITLE = "��ʽ������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ʽ��������Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
    String firstNodeID = "";
	
	String sExcludeDirIds =CurPage.getParameter("ExcludeDirIds"); 		//�ų��Ľڵ�
	IFormatTool formatTool = FormatToolManager.getFormatTool(sDocID,sExcludeDirIds);
	firstNodeID = formatTool.getFirstNodeID(CurUser,sObjectType,sObjectNo,sDocID); //Ĭ�ϴ�ҳ��
	
  	//����Treeview
  	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��ʽ������","right");
  	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
  	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
  	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	String sSqlTreeView = " from AWE_ERPT_DATA where RelativeSerialNo in "+
			" (select SerialNo from AWE_ERPT_RECORD where ObjectType='"+sObjectType+"' and ObjectNo='"+sObjectNo+"' and DocID='"+sDocID+"')" ;
	tviTemp.initWithSql("SerialNo","DirName","SerialNo","","",sSqlTreeView,"Order By SerialNo",Sqlca);
	
%><%@ include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript">
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		var sCurItemText = getCurTVItem().name;
		setTitle(sCurItemText);
		AsControl.OpenView("/AppConfig/FormatDoc/InvokeTemplate.jsp","Method=<%=sMethod%>&DataSerialNo="+sCurItemID,"right","");
	}

	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItem('<%=firstNodeID%>');
	}

	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>