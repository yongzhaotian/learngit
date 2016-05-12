<%@ page contentType="text/html; charset=GBK"%><%@ include file="/Resources/Include/IncludeBeginDWAJAX.jspf"%><%
	String sDWName = DataConvert.toRealString(iPostChange,(String)request.getParameter("dw"));
	String sCurPage = DataConvert.toRealString(iPostChange,(String)request.getParameter("pg"));
	String sSortField = DataConvert.toRealString(iPostChange,(String)request.getParameter("sortfield"));
	String sSortOrder = DataConvert.toRealString(iPostChange,(String)request.getParameter("sortorder")); //0Éý1½µ

	int iCurPage = 0;
	
	if(sCurPage!=null && !sCurPage.equals("")&&!sSortField.equals("*"))
		iCurPage = Integer.valueOf(sCurPage).intValue();
	
	if(sDWName!=null && !sDWName.equals("")&&!sSortField.equals("*")){
		ASDataWindow dwTemp = Component.getDW(sSessionID);
		dwTemp.iCurPage = iCurPage;
		dwTemp.setSortField(sSortField,sSortOrder);
				
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++){
			out.print((String)vTemp.get(i));
		}
	}
%><%@ include file="/Resources/Include/IncludeTail.jspf"%>