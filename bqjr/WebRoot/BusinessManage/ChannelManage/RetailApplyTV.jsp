<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��:ʾ��������Ϣ�鿴ҳ��
	 */
	String PG_TITLE = "������׼������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;SQL������ͼ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "150";//Ĭ�ϵ�treeview���

	//���ҳ�����
	String sRSSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RSSerialNo"));
	String sRSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RSerialNo"));
	String sViewId = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewId"));
	String sApplyType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	if (sRSSerialNo == null) sRSSerialNo = "";
	if (sRSerialNo == null) sRSerialNo = "";
	if (sViewId == null) sViewId = "01";
	if (sApplyType == null) sApplyType = "";

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"������׼������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ
	//String sFolder1=tviTemp.insertFolder("root","������Ϣ","",1);
	tviTemp.insertPage("root","������Ϣ","",1);
	tviTemp.insertPage("root","�����ŵ���Ϣ","",2);
	tviTemp.insertPage("root","������Ϣ","",3);
	
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
		if(sCurItemname=="������Ϣ"){
			openChildComp("/BusinessManage/ChannelManage/RetailApplyInfo.jsp","RSSerialNo=<%=sRSSerialNo %>&RSerialNo=<%=sRSerialNo%>&ViewId=<%=sViewId%>&ApplyType=<%=sApplyType%>");
		}else if(sCurItemname=="�����ŵ���Ϣ"){
			openChildComp("/BusinessManage/ChannelManage/RetailRetiveStoreList.jsp","RSSerialNo=<%=sRSSerialNo %>&RSerialNo=<%=sRSerialNo%>&ViewId=<%=sViewId%>&ApplyType=<%=sApplyType%>");
		}else if(sCurItemname=="������Ϣ"){
			//openChildComp("/AppConfig/Document/AttachmentList.jsp","RSSerialNo=<%=sRSSerialNo %>&ViewId=<%=sViewId%>");
			openChildComp("/ImageManage/ImageView.jsp","RSSerialNo=<%=sRSSerialNo %>&ViewId=<%=sViewId%>&ObjectType=RetailStore&ObjectNo=<%=sRSSerialNo %>");
		}
		setTitle(getCurTVItem().name);
	}
	
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItemByName("������Ϣ");
	}
		
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>
