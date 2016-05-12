<%@ page contentType="text/html; charset=GBK"%><%@ include file="/Resources/Include/IncludeBeginDWAJAX.jspf"%><%
	String sDWName = DataConvert.toRealString(iPostChange,(String)request.getParameter("dw"));
	String sCurPage = DataConvert.toRealString(iPostChange,(String)request.getParameter("pg"));
	int iCurPage = 0;
	
	if(sCurPage!=null && !sCurPage.equals(""))
		iCurPage = Integer.valueOf(sCurPage).intValue();

	if(sDWName!=null && !sDWName.equals("")){
		ASDataWindow dwTemp = Component.getDW(sSessionID);
		dwTemp.iCurPage = iCurPage;
	
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++){
			out.print(vTemp.get(i));
		}
	}
%><%@ include file="/Resources/Include/IncludeTail.jspf"%>