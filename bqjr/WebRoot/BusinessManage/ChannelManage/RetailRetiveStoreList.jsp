<%@page import="com.amarsoft.app.billions.CommonConstans"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
 
	//���ҳ�����
	String sRSSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RSSerialNo"));
	String sRSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RSerialNo"));
	String sViewId = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewId"));
	String sApplyType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	if (sRSSerialNo == null) sRSSerialNo = "";
	if (sRSerialNo == null) sRSerialNo = "";
	if (sViewId == null) sViewId = "01";
	if (sApplyType == null) sApplyType = "";
	
	if ("02".equals(sViewId)) CurComp.setAttribute("RightType", "ReadOnly");
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "StoreList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sRSSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","�����ϴ�","�����ϴ�","addAttachment()",sResourcesPath},
		{"true","","Button","�鿴����","�鿴��������","viewFile()",sResourcesPath},
		{"false","","Button","ǩ�����","ǩ�����","signOpinion()",sResourcesPath},
		{"false","","Button","�鿴���","�鿴���","viewOpinions()",sResourcesPath},
		{"false","","Button","ʹ��ObjectViewer��","ʹ��ObjectViewer��","openWithObjectViewer()",sResourcesPath},
		{"true","","Button","�����ŵ���Ϣ","�����ǵ���Ϣ","copyStoreInfo()",sResourcesPath},
	};
	
	if (CommonConstans.ReTAILSTORE_APPROVE_TYPE.equals(sApplyType)) {
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "true";
		sButtons[5][0] = "true";
		sButtons[8][0] = "false";
	}
	
	if ("02".equals(sViewId)) sButtons[3][0] = "false";
	
	// ������������ɽ׶Σ�ֻ�ܲ鿴���
	String sFinishePhaseNo = Sqlca.getString(new SqlObject("select PhaseNo from flow_object where objectno=:ObjectNo").setParameter("ObjectNo", sRSSerialNo));
	if ("2000".equals(sFinishePhaseNo)  || "9000".equals(sFinishePhaseNo)) {
		sButtons[5][0] = "false";
		sButtons[6][0] = "true";
	}
	
	String sSRPhaseType = Sqlca.getString(new SqlObject("select PhaseType from flow_object where objectno=:ObjectNo").setParameter("ObjectNo", sRSSerialNo));
	if (!"1010".equals(sSRPhaseType)) sButtons[8][0] = "false";
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	// �����ŵ���Ϣ
	function copyStoreInfo() {
		var sSerialNo = getItemValue(0, getRow(), "SERIALNO");
		
		if (typeof(sSerialNo)=='undefined' || sSerialNo.length==0) {
			alert("��ѡ��һ����¼��");
			return;
		}
		
		RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "copyStoreInfo", "serialNo="+sSerialNo+",tableName=Store_Info,colName=SerialNo");
		reloadSelf();
	}

	function signOpinion()
	{
		//���������ˮ�š��������͡�������
		sSerialNo = getItemValue(0,getRow(),"SERIALNO");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ�� 
			return;
		}
		//ǩ���Ӧ�����
		AsControl.PopView("/Common/WorkFlow/SignTaskOpinionInfo2.jsp","SerialNo="+sSerialNo+"&ObjectType=<%=CommonConstans.RETAILSTORE_APPLY_TYPE %>&ObjectNo=<%=sRSSerialNo %>&SNo="+getItemValue(0, getRow(), "SNO"),"dialogWidth=580px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions()
	{
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		var sSerialNoTemp = RunMethod("���÷���","GetColValue","Flow_Opinion,SerialNo,SerialNo='"+sSerialNo+"' and OpinionNo=<%=sRSSerialNo%>");
		if (sSerialNoTemp == "Null") {
			alert("��δǩ�����������ǩ�������");
			return;
		}
		
		//AsControl.PopView("/Common/WorkFlow/SignTaskOpinionInfo2.jsp","SerialNo="+sSerialNo+"&SNo="+getItemValue(0, getRow(), "SNO")+"&ViewId=002","dialogWidth=580px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		AsControl.PopView("/Common/WorkFlow/SignTaskOpinionInfo2.jsp","SerialNo="+sSerialNo+"&ObjectType=<%=CommonConstans.RETAILSTORE_APPLY_TYPE %>&ObjectNo=<%=sRSSerialNo %>&ViewId=002&SNo="+getItemValue(0, getRow(), "SNO"),"dialogWidth=580px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}

	/*~[Describe=�ϴ�����;InputParam=��;OutPutParam=��;]~*/
	function addAttachment() {
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(serialNo)=="undefined" || serialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		// ��������Ѿ��ϴ�����ɾ���ü�¼���ϴ�
		var sDocNo = RunMethod("���÷���", "GetColValue", "DOC_ATTACHMENT,DocNo,DocNo='"+serialNo+"'");
		if (sDocNo!="Null") {
			RunMethod("���÷���", "DelByWhereClause", "DOC_ATTACHMENT,DocNo='"+serialNo+"'");
		}
		
		AsControl.PopView("/AppConfig/Document/AttachmentChooseDialog.jsp","DocNo="+serialNo,"dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
		
	/*~[Describe=�鿴��������;InputParam=��;OutPutParam=��;]~*/
	function viewFile()
	{
		var sDocNo= getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sDocNo)=="undefined" || sDocNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		else
		{
			// ��ȡ�������
			var sAttachmentNo = RunMethod("���÷���", "GetColValue", "DOC_ATTACHMENT,AttachmentNo,DocNo='"+sDocNo+"'");
			AsControl.PopView("/AppConfig/Document/AttachmentView.jsp","DocNo="+sDocNo+"&AttachmentNo="+sAttachmentNo);
		}
	}
	
	function newRecord(){
		
		AsControl.OpenView("/BusinessManage/ChannelManage/StoreInfo.jsp","RSSerialNo=<%=sRSSerialNo%>&RSerialNo=<%=sRSerialNo %>","_self");

	}
	
	function deleteRecord(){
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(serialNo)=="undefined" || serialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			
				as_del("myiframe0");
				as_save("myiframe0");  //�������ɾ������Ҫ���ô����
				reloadSelf();
		}
	}

	function viewAndEdit(){
		
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.OpenView("/BusinessManage/ChannelManage/StoreInfo.jsp","RSSerialNo=<%=sRSSerialNo%>&RSerialNo=<%=sRSerialNo %>&SSerialNo="+sSerialNo+"&ApplyType=<%=sApplyType%>&ViewId=<%=sViewId%>","_self");

	}
	
	<%/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/%>
	function openWithObjectViewer(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.OpenObject("Example",sExampleId,"001");//ʹ��ObjectViewer����ͼ001��Example��
	}

	$(document).ready(function(){
		showFilterArea();
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>