<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%@
 page import="com.amarsoft.are.jbo.JBOFactory" %><%@
 page import="com.amarsoft.are.jbo.BizObjectManager" %>
<%
	String[] headers = {"����1","����2","����3","����4"};
	ASObjectModel doTemp = new ASObjectModel(headers);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1";//ֻ��ģʽ
	String[][] displayData = new String[20][4];
	for(int i=0;i<displayData.length;i++){
		for(int j=0;j<displayData[i].length;j++){
			displayData[i][j]= "����" + i + "," + (j+1);
		}
	}
	
	
	
	dwTemp.genHTMLObjectWindow(displayData);
	
	
	String sButtons[][] = {
			
	};
%><%@
include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
