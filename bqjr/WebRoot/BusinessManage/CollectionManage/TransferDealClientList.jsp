<%@ page contentType="text/html; charset=GBK"%>
<%@
 include file="/IncludeBegin.jsp"%><%

	String PG_TITLE = "�ʲ�ת��Э���б�ҳ��";
    String PG_CONTENT_TITLE = "&nbsp;&nbsp;�ʲ�ת��ɸѡ&nbsp;&nbsp;";
 %>
 <% 
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject("TrustCompaniesList",Sqlca);

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
		{"true","","Button","����","�������÷����÷���Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴���÷����÷�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ�����÷����÷���Ϣ","deleteRecord()",sResourcesPath},
	};
	
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	
	/*~~[�����ʲ�ת��Э��]~~*/
	function newRecord(){
		AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealClientInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		var sReturn = RunMethod("���÷���","GetColValue","Transfer_deal,count(*),RivalSerialNo='"+sSerialNo+"' or TrustCompaniesSerialNo='"+sSerialNo+"'");
		if(typeof(sReturn)!="undefined"&&parseInt(sReturn)){
			alert("�Ѵ�����Ч��Э���¼��������ɾ����");
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
		AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealClientInfo.jsp","SerialNo="+sSerialNo,"_self","");
	}

	$(document).ready(function(){
		hideFilterArea();
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>