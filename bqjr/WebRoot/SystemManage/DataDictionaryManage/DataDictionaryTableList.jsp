<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ���б�ҳ��
		author: yzheng
		date: 2013-6-8
	 */
	String PG_TITLE = "���б�ҳ��";
	//���ҳ�����
// 	String tableType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TableType"));
// 	if(tableType==null) tableType="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "TableList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

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
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryTableInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var tableNo = getItemValue(0,getRow(),"TableNo");
		if (typeof(tableNo)=="undefined" || tableNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	function viewAndEdit(){
		var tableNo=getItemValue(0,getRow(),"TableNo");
		if (typeof(tableNo)=="undefined" || tableNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryTableInfo.jsp","TableNo="+tableNo,"_self","");
	}
	
	function mySelectRow(){
		var tableNo = getItemValue(0,getRow(),"TableNo");
		if(typeof(tableNo)=="undefined" || tableNo.length==0) {
		}
		else{
			AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryTableColList.jsp","TableNo="+tableNo,"rightdown"); 
		}
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
		mySelectRow();
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
