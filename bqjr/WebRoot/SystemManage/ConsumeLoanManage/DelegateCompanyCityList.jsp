<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
	//���ҳ�����
	String sObjectNO =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNO"));
	String sTemp =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("temp"));
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	if(sTemp==null) sTemp="";
	if(sObjectNO==null) sObjectNO="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "DELEGATECOMPANYCITY";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNO);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"false","","Button","ȷ��","ȷ��","queDing()",sResourcesPath},
	};
	if(sTemp.equals("002")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
		sButtons[2][0]="false";
		sButtons[3][0]="true";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		var sObjectNO = <%=sObjectNO%>;
		AsControl.OpenView("/SystemManage/ConsumeLoanManage/DelegateCompanyCityInfo.jsp","ObjectNO="+sObjectNO,"_self","");
	}
	
	function deleteRecord(){
		var sExampleId = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/SystemManage/ConsumeLoanManage/DelegateCompanyCityInfo.jsp","SerialNO="+sSerialNo+"&ObjectNO=<%=sObjectNO%>","_self","");
	}
	
	<%/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/%>
	function queDing(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sCompanyName = getItemValue(0,getRow(),"CUSTOMERNAME");
		var sCityNo = getItemValue(0,getRow(),"CITYNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		RunMethod("ModifyNumber","GetModifyNumber","CONSUME_COLLECTION_INFO,PROVIDERSERIALNO='"+sCompanyName+"',SERIALNO='<%=sSerialNo%>'");
		RunMethod("ModifyNumber","GetModifyNumber","CONSUME_COLLECTION_INFO,PROVIDERAREA='"+sCityNo+"',SERIALNO='<%=sSerialNo%>'");
		alert("�޸ĳɹ���");
		window.close();
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
