<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	//��ò���	
	String sObjectType =  CurPage.getParameter("ObjectType");
	if(sObjectType==null) sObjectType="";

	ASObjectModel doTemp = new ASObjectModel("AppBizObjectInfo");
	
	//�����Ϊ����ҳ�棬�������ID�����޸�
	if(sObjectType.length() != 0 ){
		doTemp.setReadOnly("ObjectType",true);
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sObjectType);

	String sButtons[][] = {
		{"true","","Button","����","","saveRecord()","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(){
		as_save("myiframe0","parent.frames[0].as_refreshCurrentRow(0)");
	}
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>