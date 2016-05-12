<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%@
 page import="com.amarsoft.app.awe.framecase.formatdoc.template01.ActionForD000100" %><%@
 page import="com.amarsoft.are.jbo.*" %>
 <script>
 function afterSave(){
	 var sResultInfo = getResultInfo(0);//获得数据
	 if(sResultInfo==''){
		 self.close();
		 return;
	 }
	 var aResultInfo = eval(sResultInfo);//转化为数组处理
	 var parentWindow = window.dialogArguments;
	 var table = parentWindow.document.getElementById("listtest");
	 var tbody;
	 if(table.childNodes[0].tagName=='TBODY'){
		tbody = table.childNodes[0];
	 }
	 else{//兼容firefox
		tbody = table.childNodes[1];
	 }
	 //将数据转化为html插入到表格中
	 for(var i=0;i<aResultInfo.length;i++){
		 var tr = parentWindow.document.createElement("tr");
		 tbody.appendChild(tr);
		 for(var j=0;j<aResultInfo[i].length;j++){
			 var td = parentWindow.document.createElement("td");
			 td.innerHTML = '&nbsp;' + aResultInfo[i][j];
			 tr.appendChild(td);
		 }
	 }
	 self.close();
 }
 </script>
<%
	//获取jbo的list
	BizObjectManager bomOne = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_CATALOG");
	ASDataObject doTemp = new ASDataObject(bomOne);
	doTemp.setBusinessProcess("com.amarsoft.app.awe.framecase.formatdoc.template01.ActionForD000100");
	doTemp.setVisible("*",false); //缺省显示全部属性，这里设置全部不显示的
	doTemp.setVisible("DOCID,DOCNAME,DOCTYPE,ORGID",true);   //设置显示的
	doTemp.setJboWhere(ActionForD000100.genJboWhere(CurPage.getParameter("DataSerialNo")));
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,request);
	dwTemp.setPageSize(10);
	dwTemp.MultiSelect = true;
	dwTemp.forceSerialJBO = true;
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ShowSummary = "1";
	dwTemp.ReadOnly = "1";//只读模式
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	String sButtons[][] = {
		{"true","","Button","确定","确定","as_doAction(0,'afterSave()','saveList')","","","",""},
		{"true","","Button","关闭","关闭","window.close()","","","",""},
	};
%><%@
include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
