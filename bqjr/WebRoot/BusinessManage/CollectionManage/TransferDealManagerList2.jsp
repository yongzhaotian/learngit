<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
	//���ҳ�����
	String isSelected =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Selected"));
	if(isSelected==null) isSelected="";
	//�״�ת�û���ת���жϱ�ʶ
	String sTransferType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransferType"));
	if(sTransferType==null) sTransferType="";
	//out.println("ת������:"+sTransferType);
	
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "TransferDealManagerList2";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//��Ŀ������ת��Э��ʱѡ��Э��ʱ���ж�
	if(isSelected.equals("true"))
	{
		doTemp.multiSelectionEnabled=true;
	}
	
	//�״�ת�ú��ٴ�ת��ʱ��ԭЭ����ˮ���ֶ������ж�
	if(sTransferType.equals("0020")){
		doTemp.setVisible("RelativeSerialNo", true);//�ٴ�ת��Э��ʱ��ʾ���ֶ�
	}else{
		doTemp.setVisible("RelativeSerialNo", false);//���ٴ�ת��Э��ʱ���ظ��ֶ�(false����ʾ;true��ʾ)
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����Э����Ϣ","�����ʲ�ת��Э��","newRecord()",sResourcesPath},
		{"true","","Button","Э������","�鿴�ʲ�ת��Э������","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ���ʲ�ת��Э��","deleteRecord()",sResourcesPath},
		{"false","","Button","ȷ��","ȷ��","getAndReturnSelected()",sResourcesPath},
		//{"true","","Button","ʹ��ObjectViewer��","ʹ��ObjectViewer��","openWithObjectViewer()",sResourcesPath},
	};
	
	if(isSelected.equals("true")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
		sButtons[2][0]="false";
		sButtons[3][0]="true";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">


	function newRecord(){
		AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealManagerInfo2.jsp","TransferType=<%=sTransferType%>","_self","");
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
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealManagerInfo2.jsp","SerialNo="+sSerialNo+"&RightType=ReadOnly&TransferType=<%=sTransferType%>","_self","");
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
