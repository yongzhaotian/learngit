<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��ʽ���������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
	
	String sSqlTreeView = " FROM AWE_ERPT_TYPE WHERE IsInUse = '1' and attribute1='1'" ;
	tviTemp.initWithSql("TypeNo", "TypeTitle", "SortNo","","",sSqlTreeView,"Order By SortNo",Sqlca);
	
	String[][] sButtons = {
		{"true","","Button","����","������ͼ���","newFormatDocType()","","","",""},
		{"true","","Button","�༭","�༭��ͼ���","viewFormatDocType()","","","",""},
		{"true","","Button","ɾ��","ɾ����ͼ���","deleteFormatDocType()","","","",""},
	};
%><%@include file="/Resources/CodeParts/View07.jsp"%>
</body><script type="text/javascript">
	<%/*[Describe=����ڵ��¼�,�鿴���޸�����;]*/%>
	function TreeViewOnClick(){
		var sTypeNo = getCurTVItem().id;
		if(!sTypeNo){
			AsControl.OpenView("/AppMain/Blank.jsp?TextToShow=��ѡ�������ͼ�ڵ�!", "frameright");
		}else if(sTypeNo=="root"){
		}else{
			AsControl.OpenView("/AppConfig/FormatDoc/FDConfig/FormatDocSubTypeFrame.jsp", "TypeNo="+sTypeNo, "frameright"); 
		}
	}
	
	<%/*������ͼ���*/%>
	function newFormatDocType(){
		var sGroupID = AsControl.PopView("/AppConfig/FormatDoc/FDConfig/FormatDocTypeInfo.jsp","","dialogWidth=600px;dialogHeight=300px;resizable=yes;maximize:yes;help:no;status:no;");
		if(!sGroupID) return;
		AsControl.OpenView("/AppConfig/FormatDoc/FDConfig/FormatDocTypeView.jsp", "", "_self");
	}
	
	<%/* �༭�������ͼ��� */%>
	function viewFormatDocType(){
		var sTypeNo = getCurTVItem().id;
		if(!sTypeNo){
			alert("��ѡ���ʽ���������");
			return;
		}
		// ����Ƿ�������ͼ�����ͼ������������������
		var sGroupID = AsControl.PopView("/AppConfig/FormatDoc/FDConfig/FormatDocTypeInfo.jsp","TypeNo=" + sTypeNo,"dialogWidth=600px;dialogHeight=300px;resizable=yes;maximize:yes;help:no;status:no;");
		if(typeof sGroupID == "undefined" || sGroupID.length == 0) return;
		AsControl.OpenView("/AppConfig/FormatDoc/FDConfig/FormatDocTypeView.jsp", "", "_self");
	}
	
	<%/* ɾ���������ͼ��� */%>
	function deleteFormatDocType(){
		var sTypeNo = getCurTVItem().id;
		if(!sTypeNo){
			alert("��ѡ���ʽ���������");
			return;
		}
		
		var sTypeTitle = getCurTVItem().name;
		if(!confirm("��ȷ��ɾ����"+sTypeTitle+"�����")) return;
		var sReturn = RunJavaMethodTrans("com.amarsoft.app.awe.config.formatdoc.action.FormatDocTypeAction", "delete", "TypeNo="+sTypeNo);
		if(sReturn && sReturn == "SUCCESS"){
			AsControl.OpenView("/AppConfig/FormatDoc/FDConfig/FormatDocTypeView.jsp", "", "_self");
		}else{
			alert("ɾ����ͼ���ʧ�ܣ�");
		}
	}
	
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
	}
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>