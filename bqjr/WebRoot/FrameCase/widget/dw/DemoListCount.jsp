<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
 <style>
 /*ҳ��С����ʽ*/
.list_div_pagecount{
	font-weight:bold;
}
/*�ܼ���ʽ*/
.list_div_totalcount{
	font-weight:bold;
}
 </style>
<%	
	ASObjectModel doTemp = new ASObjectModel("ExampleNumber");
	doTemp.setColumnFilter("serialno", true);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ShowSummary = "1";
	dwTemp.ReadOnly = "1";//ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
