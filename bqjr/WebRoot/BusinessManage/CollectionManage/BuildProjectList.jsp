<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "�ʲ�ת����Ŀ�����б�ҳ��";
	//���ҳ�����
	String sStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProjectPhoseType"));//��Ŀ״̬0010���ｨ��; 0020�������У�0030�����ս�;
	if(sStatus==null) sStatus="";
	//ת������
	String sTransferType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransferType"));
	if(sTransferType==null) sTransferType="";
	
	//out.println("��Ŀ�׶Σ�"+sStatus+"ת�����ͣ�"+sTransferType);
	
	
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "BuildProjectList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	
	//������Ŀ����Э���ѯ�����жϣ����ֹ����״�ת��Э�����Ŀ���͹����ٴ�ת��Э�����Ŀ��ѯ������
	doTemp.WhereClause +=" and status='"+sStatus+"' and ProtocolNo in(select serialno from transfer_deal where transfertype='"+sTransferType+"')";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����ת��","����ת��","newRecord()",sResourcesPath},
		{"true","","Button","ȡ��ת��","ȡ��ת��","",sResourcesPath},
		{"true","","Button","ת������","ת������","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
	};
	
	//�ǳｨ�׶ε���Ŀ������ɾ����ȡ��ת�ò���
	if(!sStatus.equals("0010")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
		sButtons[3][0]="false";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/BusinessManage/CollectionManage/BuildProjectInfo.jsp","TransferType=<%=sTransferType%>&Status=<%=sStatus%>","_self","");
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//��Ŀ���
		var sProtocolNo = getItemValue(0,getRow(),"ProtocolNo");//��Ŀ������Э����
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		if (typeof(sProtocolNo)=="undefined" || sProtocolNo.length==0){
			alert("����Ŀ��Ϣ��������������Э����Ϊ�գ�");
			return;
		}
		//AsControl.OpenView("/BusinessManage/CollectionManage/BuildProjectDetail.jsp","SerialNo="+sSerialNo+"&RightType=ReadOnly","_blank");
		AsControl.OpenView("/BusinessManage/CollectionManage/BuildProjectDetail.jsp","SerialNo="+sSerialNo+"&ProtocolNo="+sProtocolNo,"_blank");
	}
	
	$(document).ready(function(){
		//showFilterArea();
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>