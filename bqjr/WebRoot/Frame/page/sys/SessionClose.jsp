<%@ page contentType="text/html; charset=GBK"%>
<%@ page buffer="64kb" errorPage="/Frame/page/control/ErrorPage.jsp"%>
<%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);

	String sWebRootPath = request.getContextPath();	
%>
<body class="pagebackground" style="{overflow:scroll;overflow-x:visible;overflow-y:visible}" onBeforeUnload="onClose(event)">
</body>
<script type="text/javascript">
	function onClose(event){
		var bx =(event.screenX+24-top.screenLeft-top.document.documentElement.scrollWidth) > 0 && (event.screenX-top.screenLeft-top.document.documentElement.scrollWidth) < 0;
		var by =(event.clientY+24<0);
		if((bx&&by) || event.altKey) {
			window.open("<%=sWebRootPath%>/Frame/page/sys/SessionOut.jsp","_top","");
		}
	}
</script>