<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��:ʾ��������Ϣ�鿴ҳ��--
	 */
	String PG_TITLE = "�ļ�����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;SQL������ͼ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//���ҳ�����
	String sExampleId = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sViewId = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewId"));
	String InputDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("InputDate"));
	String sflag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("flag"));
	if(InputDate == null) InputDate = "";
	if(sflag == null||"".equals(sflag)) sflag="";

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�ļ�����","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	//String sFolder1=tviTemp.insertFolder("root","������Ϣ","",1);
	tviTemp.insertPage("root","δƥ��ɹ�","",1);
	tviTemp.insertPage("root","ϵͳƥ��ɹ�","",2);
	tviTemp.insertPage("root","�ֹ�ƥ��ɹ�","",3);
	
	//sSqlTreeView += "and (RelativeCode like '%"+sViewId+"%' or RelativeCode='All') ";//��ͼfilter

	
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	function openChildComp(sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		/*
		 * ������������
		 * ToInheritObj:�Ƿ񽫶����Ȩ��״̬��ر��������������
		 * OpenerFunctionName:�����Զ�ע�����������REG_FUNCTION_DEF.TargetComp��
		 */
		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		AsControl.OpenView(sURL,sParaStringTmp,"right");
	}
	
	//treeview����ѡ���¼�
	function TreeViewOnClick(){
		//var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=="δƥ��ɹ�"){
			openChildComp("/CustomService/BusinessConsult/TackbackDocumentList.jsp","MatchType=1&InputDate=<%=InputDate%>&flag=<%=sflag%>");
		}else if(sCurItemname=="ϵͳƥ��ɹ�"){
			openChildComp("/CustomService/BusinessConsult/TackbackDocumentList.jsp","MatchType=2&InputDate=<%=InputDate%>&flag=<%=sflag%>");
		}else if(sCurItemname=="�ֹ�ƥ��ɹ�"){
			openChildComp("/CustomService/BusinessConsult/TackbackDocumentList.jsp","MatchType=3&InputDate=<%=InputDate%>&flag=<%=sflag%>");
		}
		setTitle(getCurTVItem().name);
	}
	
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItemByName("δƥ��ɹ�");
	}
		
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>
