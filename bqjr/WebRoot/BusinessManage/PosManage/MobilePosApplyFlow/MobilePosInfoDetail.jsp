<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��:ʾ��ģ����ҳ��--
	 */
	String PG_TITLE = "�ƶ�POS��׼������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�ƶ�Pos��׼������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String sMobilePosNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MobilePosNo"));
	String sSNO = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("sNo"));
	if (sSerialNo == null) sSerialNo = "";
	if(sMobilePosNo==null) sMobilePosNo="";
	if(sSNO==null) sSNO="";
	if(sPhaseNo==null) sPhaseNo="";
	//���ҳ�����

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�ƶ�POS��׼������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

	//������ͼ�ṹ
	tviTemp.insertPage("root","������Ϣ","",1);	
	if(sSerialNo.length()>0){
	tviTemp.insertPage("root","������Ϣ","",2);
	tviTemp.insertPage("root","������Ʒ","",3);
	tviTemp.insertPage("root","��������","",4);
	}
	
	
	//�������ֶ�����ͼ�ṹ�ķ�����SQL���ɺʹ�������   �μ�View������ ExampleView.jsp��ExampleView01.jsp
%>
<%@include file="/Resources/CodeParts/View04.jsp"%>
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

	function TreeViewOnClick(){
		var ssSerailNo="<%=sSerialNo %>";
		var sMobilePosNo = "<%=sMobilePosNo%>";
		var sSNO = "<%=sSNO%>";
		var sPhaseNo = "<%=sPhaseNo%>";
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		
		if(sCurItemname=='������Ϣ'){
			AsControl.OpenView("/BusinessManage/PosManage/MobilePosApplyFlow/MobilePosApplyInfo.jsp","SerialNo=<%=sSerialNo%>","right");
		}else if(sCurItemname=='������Ʒ'){
			if(ssSerailNo==""){
				alert("������д������Ϣ��");
				return;
			}else{
				AsControl.OpenView( "/BusinessManage/PosManage/MobilePosApplyFlow/ProductList.jsp","SNo="+sSNO+"&MOBLIEPOSNO="+sMobilePosNo+"&PhaseNo="+sPhaseNo,"right");
			}
		}else if(sCurItemname=='��������'){
			if(ssSerailNo==""){
				alert("������д������Ϣ��");
				return;
			}else{
				AsControl.OpenView("/BusinessManage/PosManage/MobilePosApplyFlow/SalesManListForMobilePos.jsp", "SSerialNo="+ssSerailNo+"&SNo="+sSNO+"&MOBLIEPOSNO="+sMobilePosNo+"&PhaseNo="+sPhaseNo,"right");
			}
		}else if(sCurItemname=='������Ϣ'){
			if(ssSerailNo==""){
				alert("������д������Ϣ��");
			
				return;
			}else{
				AsControl.OpenView("/BusinessManage/PosManage/MobilePosApplyFlow/ImageViewFrame.jsp","SerialNo=<%=sSerialNo%>","right");
			}
		}else{
			return;
		}
		setTitle(getCurTVItem().name);
	}
	
	<%/*~[Describe=����treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItemByName("������Ϣ");	//Ĭ�ϴ򿪵�(Ҷ��)ѡ��	
	}
	
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>
