<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%

	String PG_TITLE = "�ʲ�ת��Э���б�ҳ��";
	//���ҳ�����
	String isSelected =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Selected"));
	if(isSelected==null) isSelected="";
	
	//�״�ת�û���ת���жϱ�ʶ
	String sTransferType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransferType"));
	if(sTransferType==null) sTransferType="";
	
	//out.println("ת�����ͣ�"+sTransferType);
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject("TransferDealManagerList",Sqlca);
	doTemp.WhereClause+=" and T.TransferType='0010'";//�״�ת��Э�����ת��Э���ж�����
	
	//��Ŀ����Э��ʱѡ��Э��ʱ���ж�
	if(isSelected.equals("true"))
	{
		doTemp.multiSelectionEnabled=true;
	}
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
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
	};
	if(isSelected.equals("true")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
		sButtons[2][0]="false";
		sButtons[3][0]="true";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~�½���Ŀ����Э��~*/
	function getAndReturnSelected(){
		var arr0 = getItemValueArray(0, "SerialNo");
		var arr1 = getItemValueArray(0,"RivalSerialNo");//���ֱ��
		var arr2 = getItemValueArray(0,"RivalName");//��������
		if(arr0.length!=1){
			 alert("������ֻ�ܹ�ѡһ��ί���ʲ����÷�");return;
		 }
		alert(arr0[0]+"@"+arr1[0]+"@"+arr2[0]);
		if (typeof(arr0[0])=="undefined" || arr0[0].length==0 || typeof(arr1[0])=="undefined" || arr1[0].length==0 || typeof(arr2[0])=="undefined" || arr2[0].length==0){
			alert("ѡ��ĸ�Э����Ϣ������!");
			return;
		}
		self.returnValue=arr0[0]+"@"+arr1[0]+"@"+arr2[0];
		self.close();
	}
	
	/*~~[�����ʲ�ת��Э��]~~*/
	function newRecord(){
		var sTransferType = "<%=sTransferType%>";//ת������(0010�״�ת��;0020�ٴ�ת��)
		
		//���ٴ�ת�����顢�״�ת�������ж� 
		if(sTransferType=="0010")
		{
			AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealManagerInfo.jsp","TransferType=<%=sTransferType%>","_self","");
		}
		else if(sTransferType=="0020")
		{
			AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealManagerInfo2.jsp","TransferType=<%=sTransferType%>","_self","");
		}
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			//setItemValue(0,getRow(),"Status","1");
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
		AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealManagerInfo.jsp","SerialNo="+sSerialNo+"&RightType=ReadOnly&TransferType=<%=sTransferType%>","_self","");
	}
	
	$(document).ready(function(){
		showFilterArea();
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>