<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ����ʹ�������б�ҳ��
		author:yzheng
		date:2013-6-13
	 */
	String PG_TITLE = "����ʹ�������б�ҳ��";
	//���ҳ�����
	String codeNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeNo"));
	if(codeNo==null) codeNo="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CodeUsageDetailList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(25);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(codeNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
// 		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
// 		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
// 		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
			{"true","","Button","�ֶ�����","�鿴/�޸�����","viewAndEditTableCol()",sResourcesPath},
			{"true","","Button","ģ������","�鿴/�޸�����","viewAndEditTemplate()",sResourcesPath},
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
	
	function viewAndEditTableCol(){
		var codeNo=getItemValue(0,getRow(),"CodeNo");
		var colName=getItemValue(0,getRow(),"ColName");
		
		if (typeof(codeNo)=="undefined" || codeNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryTableColList.jsp","ColName=" + colName + "&ReadOnly=0" + "&CodeNo="+codeNo,"_self","");
	}

	function viewAndEditTemplate(){
		var codeNo=getItemValue(0,getRow(),"CodeNo");
		var doNo=getItemValue(0,getRow(),"DoNo");
		
		if (typeof(doNo)=="undefined" || doNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryTemplateList.jsp","DoNo=" + doNo + "&ReadOnly=0" + "&CodeNo="+codeNo,"_self","");
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
