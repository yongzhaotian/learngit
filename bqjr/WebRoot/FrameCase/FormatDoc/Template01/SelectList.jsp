<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%@
 page import="com.amarsoft.app.awe.framecase.formatdoc.template01.ActionForD000100" %><%@
 page import="com.amarsoft.are.jbo.*" %>
 <script>
 function afterSave(){
	 var sResultInfo = getResultInfo(0);//�������
	 if(sResultInfo==''){
		 self.close();
		 return;
	 }
	 var aResultInfo = eval(sResultInfo);//ת��Ϊ���鴦��
	 var parentWindow = window.dialogArguments;
	 var table = parentWindow.document.getElementById("listtest");
	 var tbody;
	 if(table.childNodes[0].tagName=='TBODY'){
		tbody = table.childNodes[0];
	 }
	 else{//����firefox
		tbody = table.childNodes[1];
	 }
	 //������ת��Ϊhtml���뵽�����
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
	//��ȡjbo��list
	BizObjectManager bomOne = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_CATALOG");
	ASDataObject doTemp = new ASDataObject(bomOne);
	doTemp.setBusinessProcess("com.amarsoft.app.awe.framecase.formatdoc.template01.ActionForD000100");
	doTemp.setVisible("*",false); //ȱʡ��ʾȫ�����ԣ���������ȫ������ʾ��
	doTemp.setVisible("DOCID,DOCNAME,DOCTYPE,ORGID",true);   //������ʾ��
	doTemp.setJboWhere(ActionForD000100.genJboWhere(CurPage.getParameter("DataSerialNo")));
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,request);
	dwTemp.setPageSize(10);
	dwTemp.MultiSelect = true;
	dwTemp.forceSerialJBO = true;
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ShowSummary = "1";
	dwTemp.ReadOnly = "1";//ֻ��ģʽ
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	String sButtons[][] = {
		{"true","","Button","ȷ��","ȷ��","as_doAction(0,'afterSave()','saveList')","","","",""},
		{"true","","Button","�ر�","�ر�","window.close()","","","",""},
	};
%><%@
include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
