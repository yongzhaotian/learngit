<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
 	String sOperateType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OperateType"));
 	String sChannelSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
 	if(sOperateType == null) sOperateType = "";
 	if(sChannelSerialNo==null || "".equals(sChannelSerialNo))  sChannelSerialNo = "";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "RepaymentChannelDetailList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sChannelSerialNo); 
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","����","����","importExcel()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
	};
	
	if(!"".equals(sOperateType)){
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		var sChannelSerialNo="<%=sChannelSerialNo%>";
		if("" ==sChannelSerialNo){
			alert("�����ȱ��滹������������Ϣ");
			reloadSelf();
			return;
		}
		AsControl.OpenPage("/CustomService/BusinessConsult/RepaymentChannelInfo.jsp","ChannelSerialNo=<%=sChannelSerialNo%>","_self");
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			//as_del("myiframe0");
			//as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			RunMethod("���÷���", "DelByWhereClause", "REPAYMENT_CHANNEL_LIST,SerialNo='"+sSerialNo+"'");
		}
		reloadSelf();
	}

	function importExcel(){
		var sChannelSerialNo="<%=sChannelSerialNo%>";
		if("" ==sChannelSerialNo){
			alert("�����ȱ��滹������������Ϣ");
			reloadSelf();
			return;
		}
		var sFilePath = AsControl.PopView("/CustomService/BusinessConsult/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0 || sFilePath =='_none_') {
			// ����Excel�� alert("��ѡ���ļ���");
			return;
		}
		RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "importChannelDetailList",  "filePath="+sFilePath+",userid="+"<%=CurUser.getUserID()%>"+",orgid="+"<%=CurUser.getOrgID()%>"+",channelSerialNo="+sChannelSerialNo);
		reloadSelf();
	}
	
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenPage("/CustomService/BusinessConsult/RepaymentChannelInfo.jsp","ChannelSerialNo=<%=sChannelSerialNo%>&detailSerialNo="+sSerialNo+"&OperateType=<%=sOperateType%>","_self");
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
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
