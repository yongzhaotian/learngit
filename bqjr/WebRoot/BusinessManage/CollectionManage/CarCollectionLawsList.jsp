<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "����������յǼ��б�ҳ��";
	//���ҳ�����
	String sContractSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ContractSerialNo"));
	if(sContractSerialNo==null) sContractSerialNo="";
	String sCollectionSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CollectionSerialNo"));
	if(sCollectionSerialNo==null) sCollectionSerialNo="";
	//out.println("sColSerialNo:"+sContractSerialNo+"sBcSerialNo:"+sCollectionSerialNo);
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CARCOLLECTIONLAWSLIST";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sContractSerialNo+","+sCollectionSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		//{"true","","Button","ʹ��ObjectViewer��","ʹ��ObjectViewer��","openWithObjectViewer()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/BusinessManage/CollectionManage/CarColectionLawsInfo.jsp","CollectionSerialNo=<%=sCollectionSerialNo%>&ContractSerialNo=<%=sContractSerialNo%>","_self","");
	}
	
	/*~~ɾ��������ռ�¼~~*/
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
		//alert("SerialNo="+sSerialNo+"CollectionSerialNo=<%=sCollectionSerialNo%>&ContractSerialNo=<%=sContractSerialNo%>");
		AsControl.OpenView("/BusinessManage/CollectionManage/CarColectionLawsInfo.jsp","CollectionSerialNo=<%=sCollectionSerialNo%>&ContractSerialNo=<%=sContractSerialNo%>&SerialNo="+sSerialNo,"_self","");
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
