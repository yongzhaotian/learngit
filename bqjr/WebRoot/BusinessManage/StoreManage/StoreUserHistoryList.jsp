<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��: ʾ����ѡ�б�ҳ��--
	 */
	String PG_TITLE = "����¼";
 
	// ���ҳ�����
	String sSNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNO"));
	if (sSNo == null) sSNo = "";

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "StoreHistoryList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
    doTemp.WhereClause+="  and SType is not null";
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"false","","Button","����ŵ�","����ŵ�","deleteRecord()",sResourcesPath},
		{"true","","Button","����","�����ŵ������ҳ��","getBack()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function getBack() {
		
		AsControl.OpenView("/BusinessManage/StoreManage/StoreList.jsp","","_self","");
	}

	
	function deleteRecord(){
		var sSNos = getItemValueArray(0,"SERIALNO");//��ȡѡ�еĶ�����¼ID			
		if (typeof(sSNos)=="undefined" || sSNos.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		var idstring = sSNos.toString();
		var re =/,/g; 
		idstring = idstring.replace(re,"@");	
		alert(idstring);
		if(confirm("�����������ѡ�ŵ���")){
			var sReturn = AsControl.RunJavaMethodSqlca("com.amarsoft.app.billions.StoreManagerRelativeCommon","unbindStores","serialNos="+idstring);
			if(sReturn=="SUCCESS"){
				alert("���ɹ�!");
				reloadSelf();
			}	
		}
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		showFilterArea();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>