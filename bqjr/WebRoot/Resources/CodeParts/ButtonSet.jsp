<table width=100% height=100% cellspacing="0" cellpadding="0" border="0">
	<%
	String[][] sButtons1stLine = sButtons;
	String sLineMaxButtons = (String)CurPage.getAttribute("ButtonsLineMax");
	String sScreenWidth = (String)CurARC.getAttribute("ScreenWidth");
	String sCompRightType = (String)CurComp.getAttribute("RightType");
	if(sScreenWidth==null || sScreenWidth.equals("") || Integer.parseInt(sScreenWidth)<=800){
		sLineMaxButtons = "6";
	}else{
		if(sLineMaxButtons==null){
			sLineMaxButtons = "9";
		}
	}
	int iButtonsCount = 1;
	if(sButtons1stLine!=null){
		out.println("<tr>");
		out.println("<td class=\"buttonback\" valign=top>");
		out.println("<table>");
		out.println("<tr>");
		for(int iBT=0;iBT<sButtons1stLine.length;iBT++){
			if(sButtons1stLine[iBT][0]==null || !sButtons1stLine[iBT][0].equals("true")) continue;
			if ("ReadOnly".equals(sCompRightType)) {
				if(sButtons1stLine[iBT][1]!=null  && !sButtons1stLine[iBT][1].equals("")&& sButtons1stLine[iBT][1].indexOf("ReadOnly")<0) continue;
				if(sButtons1stLine[iBT][3]!=null  && (sButtons1stLine[iBT][3].indexOf("ĞÂÔö")>=0 || sButtons1stLine[iBT][3].indexOf("±£´æ")>=0 || sButtons1stLine[iBT][3].indexOf("Ôİ´æ")>=0|| sButtons1stLine[iBT][3].indexOf("É¾³ı")>=0)) continue;
			}
			if(iButtonsCount>Integer.parseInt(sLineMaxButtons)){
				out.println("</tr>");
				out.println("</table>");
				out.println("</td>");
				out.println("</tr>");
				out.println("<tr>");
				out.println("<td class=\"buttonback\" valign=top>");
				out.println("<table>");
				out.println("<tr>");
				iButtonsCount = 1;
			}
			iButtonsCount++;
			
			if(sButtons1stLine[iBT].length > 7){ // sButtons1stLine[iBT][7] is iconCls
			%>
				<td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,sButtons1stLine[iBT][1],sButtons1stLine[iBT][2],sButtons1stLine[iBT][3],sButtons1stLine[iBT][4],sButtons1stLine[iBT][5],sResourcesPath,sButtons1stLine[iBT][7])%></td>
			<%
			}else{
			%>
				<td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,sButtons1stLine[iBT][1],sButtons1stLine[iBT][2],sButtons1stLine[iBT][3],sButtons1stLine[iBT][4],sButtons1stLine[iBT][5],sResourcesPath)%></td>
			<%
			}
		}
			out.println("</tr>");
			out.println("</table>");
			out.println("</td>");
			out.println("</tr>");
	}
	%>
</table>