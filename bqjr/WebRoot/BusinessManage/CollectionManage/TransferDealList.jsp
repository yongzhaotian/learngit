<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%

	String PG_TITLE = "�ʲ�ת��Э���б�ҳ��";
	//���ҳ�����
	String isSelected =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Selected"));
	if(isSelected==null) isSelected="";
	
	//�״�ת�û���ת���жϱ�ʶ
	String sTransferType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransferType"));
	if(sTransferType==null) sTransferType="";
	
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	if(sApplyType==null) sApplyType="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject("TransferDealConfigList",Sqlca);
	
	doTemp.WhereClause+=" and T.applyType='"+sApplyType+"'";
	
	if("0010".equals(sTransferType)){
		doTemp.WhereClause+=" and T.DealStatus='01'";//ɸѡ����
	}
	
	if("0020".equals(sTransferType)){
		doTemp.WhereClause+=" and T.DealStatus='02'";//ɸѡ����
	}
	
	if("0030".equals(sTransferType)){
		doTemp.WhereClause+=" and T.DealStatus='03'";//ɸѡ����
	}
	
	//��Ŀ����Э��ʱѡ��Э��ʱ���ж�
	if(isSelected.equals("true"))
	{
		doTemp.multiSelectionEnabled=true;
	}
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
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
		{"true","","Button","Э����Ч","�ʲ�Э����Ч","finishedRecord()",sResourcesPath},
		{"true","","Button","Э����ֹ","�ʲ�Э����ֹ","endOfDeal()",sResourcesPath},
		{"true","","Button","���µǼ�Э��","���µǼ�Э��","RestartRecord()",sResourcesPath},
	};
	
	if("0010".equals(sTransferType)){
		sButtons[4][0]="false";
		sButtons[5][0]="false";
	}
	
	if("0020".equals(sTransferType)){
		sButtons[0][0]="false";
		sButtons[2][0]="false";
		sButtons[3][0]="false";
	}
	
	if("0030".equals(sTransferType)){
		sButtons[0][0]="false";
		sButtons[2][0]="false";
		sButtons[3][0]="false";
		sButtons[4][0]="false";
		sButtons[5][0]="false";
	}

%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	
	/*~~[�����ʲ�ת��Э��]~~*/
	function newRecord(){
		var sTransferType = "<%=sTransferType%>";
		AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealManagerInfo.jsp","TransferType=<%=sTransferType%>"+"&ApplyType="+"<%=sApplyType%>","_self","");
		
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		var sReturn = RunMethod("���÷���","GetColValue","Transfer_group,count(*),RelativeSerialNo='"+sSerialNo+"'");
		if(typeof(sReturn)!="undefined"&&parseInt(sReturn)>0){
			alert("��Э���Ѵ��������ʲ�����������ɾ����");
			return;
		}
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
		reloadSelf();
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealManagerInfo.jsp","SerialNo="+sSerialNo+"&TransferType=<%=sTransferType%>","_self","");
		
		
	}
	
	function RestartRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		sReturn = RunMethod("PublicMethod","UpdateColValue","String@DealStatus@01,transfer_deal,String@SerialNo@"+sSerialNo);
		if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
			alert("���µǼ�Э��ʧ��");//�Ǽ�ʧ�ܣ�
			return;
		}else
		{
			reloadSelf();
			alert("���µǼ�Э��ɹ�");//���µǼǳɹ���
		}

	}
	
	function finishedRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		sReturn = RunMethod("PublicMethod","UpdateColValue","String@DealStatus@02,transfer_deal,String@SerialNo@"+sSerialNo);
		if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
			alert("Э����Чʧ��");//�Ǽ�ʧ�ܣ�
			return;
		}else
		{
			reloadSelf();
			alert("Э����Ч�ɹ�");//��ɵǼǣ�
		}
	}
	function endOfDeal(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		if(!confirm("���������ֹ��Э����")){
			return;
		}
		sReturn = RunMethod("PublicMethod","UpdateColValue","String@DealStatus@03,transfer_deal,String@SerialNo@"+sSerialNo);
		if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
			alert("Э����ֹʧ��");
			return;
		}else
		{
			reloadSelf();
			alert("Э����ֹ�ɹ�");
		}
	}
	
	$(document).ready(function(){
		hideFilterArea();
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>