<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	String PG_TITLE = "��ʽ����������б�";
	String parentNo = CurPage.getParameter("ParentTypeNo");
	if(parentNo == null) parentNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("FDSubTypeList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(parentNo);

	String sButtons[][] = {
		{"true","","Button","����","����","add()","","","",""},
		{"true","","Button","����","����","editRecord()","","","",""},
		{"true","","Button","ɾ��","ɾ��","deleteRecord()","","","","btn_icon_delete"},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function mySelectRow(){
		//��ȡ������
		var sTypeNo=getItemValue(0,getRow(),"TypeNo");
		AsControl.OpenView("/AppConfig/FormatDoc/FDConfig/FormatDocCatalogList.jsp","SubTypeNo="+sTypeNo,"rightdown");
	}
 	function add(){
	 	AsControl.PopView("/AppConfig/FormatDoc/FDConfig/FormatDocSubTypeInfo.jsp",'',"dialogWidth=400px;dialogHeight=300px;resizable=yes;maximize:yes;help:no;status:no;");
	 	reloadSelf();
 	}
 	function editRecord(){
	 	var sTypeNo=getItemValue(0,getRow(),"TypeNo");
	 	AsControl.PopView("/AppConfig/FormatDoc/FDConfig/FormatDocSubTypeInfo.jsp","SubTypeNo="+sTypeNo,"dialogWidth=400px;dialogHeight=300px;resizable=yes;maximize:yes;help:no;status:no;");
	 	reloadSelf();
 	}
 	function deleteRecord(){
 		if(confirm('ȷʵҪɾ����?')){
 			as_delete("myiframe0");
 		}
 	}
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>