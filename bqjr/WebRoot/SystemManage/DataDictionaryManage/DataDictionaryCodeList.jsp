<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: �����б�ҳ��
		author:yzheng
		date:2013-6-8
	 */
	String PG_TITLE = "�����б�ҳ��";
	//���ҳ�����
// 	String codeType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeType"));
// 	if(codeType==null) codeType="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CodeList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(25);

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
		AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryCodeInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var codeNo = getItemValue(0,getRow(),"CodeNo");
		if (typeof(codeNo)=="undefined" || codeNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	function viewAndEdit(){
		var codeNo=getItemValue(0,getRow(),"CodeNo");
		if (typeof(codeNo)=="undefined" || codeNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryCodeInfo.jsp","CodeNo="+codeNo,"_self","");
	}
	
	function mySelectRow(){
		var codeNo = getItemValue(0,getRow(),"CodeNo");
		if(typeof(codeNo)=="undefined" || codeNo.length==0) {
		}
		else{
			AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryCodeUsageDetailList.jsp","CodeNo="+codeNo,"rightdown"); 
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
