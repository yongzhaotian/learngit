<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%@
 page import="com.amarsoft.app.awe.framecase.formatdoc.template01.ActionForD000100" %><%@
 page import="com.amarsoft.are.jbo.*" %>
 <script>
 function afterSave(){
	var selrows = getSelRows(0);
	var parentWindow = window.dialogArguments;
	var table = parentWindow.document.getElementById("listtest");
	var tbody;
	if(table.childNodes[0].tagName=='TBODY'){
		tbody = table.childNodes[0];
	}
	else{//兼容firefox
		tbody = table.childNodes[1];
	}
	//先建tr对象存入数组
	var trarray = new Array();
	for(var i=0;i<tbody.childNodes.length;i++){
		//alert(tbody.childNodes[i].tagName);
		if(tbody.childNodes[i].tagName.toUpperCase() == 'TR'){
			trarray[trarray.length] = tbody.childNodes[i];
		}
	}
	//根据tr删除数据.需要排除前两行
	for(var i=selrows.length-1;i>=0;i--){
		var deleteRowIndex = selrows[i] + 2;
		tbody.removeChild(trarray[deleteRowIndex]);
	}
	self.close();
 }
 </script>
<%
	
	//获取jbo的list
	String[] headers = {"文档类型编号","文档类型名称","文档类型","机构"};
	ASDataObject doTemp = new ASDataObject(headers);
	doTemp.setBusinessProcess("com.amarsoft.app.awe.framecase.formatdoc.template01.ActionForD000100");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,request);
	dwTemp.MultiSelect = true;
	dwTemp.Style="1";      //设置为Grid风格
	Vector vTemp = dwTemp.genHTMLDataWindow(ActionForD000100.getSelectedDatas(CurPage.getParameter("DataSerialNo")));
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	String sButtons[][] = {
		{"true","","Button","确定","确定","as_extendAction(0,'afterSave()','removeList')","","","",""},
	};
%><%@
include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
