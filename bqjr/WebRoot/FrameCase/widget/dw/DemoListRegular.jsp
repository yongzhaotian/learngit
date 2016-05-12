<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<style>
.css_blue{
	color:blue;
}
.css_red{
	color:red;
}
.css_bgcolor_1{
	background-color:#09f;
}
.css_bgcolor_2{
	background-color:yellow;
	color:red;
}
.css_bgcolor_3{
	background-color:red;
	color:blue;
}

</style>
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
	//自定义显示规则
	doTemp.addColumnDisplayRule("TELEPHONE","{VALUE}.substring(0,3)=='133'","","css_bgcolor_1");
	doTemp.addColumnDisplayRule("TELEPHONE","{VALUE}.substring(0,3)=='135'","TELEPHONE","css_bgcolor_2");
	doTemp.addColumnDisplayRule("ISINUSE","{VALUE}=='1'","ISINUSE,SERIALNO","css_bgcolor_3");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1";//只读模式
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0)","","","",""}
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
