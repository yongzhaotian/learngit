<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	String sDocID = CurPage.getParameter("DocID");
 	if(sDocID == null) sDocID = "";

	ASObjectModel doTemp = new ASObjectModel("FDParaList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "0";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(sDocID);

	String sButtons[][] = {
		{"true","","Button","����","����","add()","","","",""},
		{"true","","Button","����","����","as_save('myiframe0')","","","",""},
		{"true","","Button","ɾ��","ɾ��","deleteRecord()","","","","btn_icon_delete"},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	setDialogTitle("�����������");
 	function add(){
	 	as_add("myiframe0");
	 	//����Ĭ��ֵ
	 	setItemValue(0,getRow(0),'DocID','<%=sDocID%>');
 	}
 
	function deleteRecord(){
	 	if(confirm('ȷʵҪɾ����?')){
		 	as_delete("myiframe0");
	 	}
 	}
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>