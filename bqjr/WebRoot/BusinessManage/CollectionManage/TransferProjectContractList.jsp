<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 <%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "�ʲ�ת����Ŀ���¹�����ͬ��Ϣ�б����";
	//���ҳ�����
	String sProjectSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProjectSerialNo"));//��Ŀ���
	String sProtocolNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProtocolNo"));//��Ŀ��������Э����
	//String sTransferType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransferType"));//��Ŀ��������Э����
	if(sProjectSerialNo==null) sProjectSerialNo="";
	if(sProtocolNo==null) sProtocolNo="";
	//if(sTransferType==null)sTransferType="";
	//out.println("��Ŀ���:"+sProjectSerialNo+";Э����:"+sProtocolNo+"ת�����ͣ�"+sTransferType);
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject("TransferProjectContractList",Sqlca);

	//doTemp.generateFilters(Sqlca);
	//doTemp.parseFilterData(request,iPostChange);
	//CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sProjectSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����������ͬ","ѡ�������ͬ","newRecord()",sResourcesPath},
		//{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		//{"true","","Button","ʹ��ObjectViewer��","ʹ��ObjectViewer��","openWithObjectViewer()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		var sBcSerialNo = AsControl.PopPage("/BusinessManage/CollectionManage/AssetsBusinessContractList.jsp","ProjectSerialNo=<%=sProjectSerialNo%>","_self","");
		var sSerialNo = getSerialNo("TRANSFER_PROJECT_CONTRACT", "SerialNo", "");//���������ˮ��
		var sTransferDealSerialNo = "<%=sProtocolNo%>";//�ʲ�ת��Э���
		var sProjectSerialNo = "<%=sProjectSerialNo%>";//�ʲ�ת��Э��������Ŀ���
		var sContractSerialNo = sBcSerialNo;//�ʲ�ת��Э����Ŀ���¹����ĺ�ͬ��
		var sTransferType = "0010";//�ʲ�ת������(0010�״�ת��;0020�ٴ�ת��)
		var sInputUserID = "<%=CurUser.getUserID()%>";
		var sInputOrgID = "<%=CurUser.getOrgID()%>";
		var sInputDate = "<%=StringFunction.getToday()%>";
		if(typeof(sTransferDealSerialNo)==null||sTransferDealSerialNo=="" ||typeof(sContractSerialNo)==null||sContractSerialNo==""||typeof(sProjectSerialNo)==null||sProjectSerialNo==""){
			alert("Э��š���Ŀ�š���ͬ�Ŷ�����Ϊ��!");
			return;
		}
		
		sParam = "SerialNo="+sSerialNo+",TransferDealSerialNo="+sTransferDealSerialNo+",ProjectSerialNo="+sProjectSerialNo+",ContractSerialNo="+sContractSerialNo+",TransferType="+sTransferType+",InputUserID="+sInputUserID+",InputOrgID="+sInputOrgID+",InputDate="+sInputDate;
		var sReturn = AsControl.RunJavaMethodSqlca("com.amarsoft.app.hhcf.after.colection.AfterColectionAction","projectRelationContract",sParam);
		
		if(sReturn=="true")
		{
			reloadSelf();
		}
		else if(sReturn =="ContractIsExist")
		{
			alert("�ú�ͬ������Ŀ����!");
			return;
		}
		else
		{
			alert("��Ŀ����ѡ��ĺ�ͬ����ʧ��!");
			return;
		}
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
		reloadSelf();
	}

	function viewAndEdit(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/FrameCase/ExampleInfo.jsp","ExampleId="+sExampleId,"_self","");
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
