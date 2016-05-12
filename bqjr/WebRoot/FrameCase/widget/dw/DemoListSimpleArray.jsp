<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%@
 page import="com.amarsoft.are.jbo.JBOFactory" %><%@
 page import="com.amarsoft.are.jbo.BizObjectManager" %>
<%
	String[] headers = {"标题1","标题2","标题3","标题4"};
	ASObjectModel doTemp = new ASObjectModel(headers);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1";//只读模式
	String[][] displayData = new String[20][4];
	for(int i=0;i<displayData.length;i++){
		for(int j=0;j<displayData[i].length;j++){
			displayData[i][j]= "数据" + i + "," + (j+1);
		}
	}
	
	
	
	dwTemp.genHTMLObjectWindow(displayData);
	
	
	String sButtons[][] = {
			
	};
%><%@
include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
