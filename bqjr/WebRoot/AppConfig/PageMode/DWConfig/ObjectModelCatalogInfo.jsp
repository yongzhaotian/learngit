<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String sDoNo = CurPage.getParameter("DONO");
	if(sDoNo==null) sDoNo = "";

    String sTempletNo = "ObjectModelCatalogInfo";//模板号
    ASObjectModel doTemp = new ASObjectModel(sTempletNo);
    ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
    dwTemp.Style = "2";//freeform
    dwTemp.genHTMLObjectWindow(sDoNo);
    
    String sButtons[][] = {
        {"true","All","Button","保存","保存所有修改","as_save(0)","","","","btn_icon_save"},
    };
%><%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>