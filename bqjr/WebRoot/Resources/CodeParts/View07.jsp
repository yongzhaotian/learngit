<html>
<head>
<title>集团关联搜索</title>
<style>
<!--
	div{
		padding:0px;
		margin:0px;
	}
	#outter{
		height:100%;
		width:100%;
	}
	#buttonDiv{
		padding-top:1%;
		height:5%;
		width:100%;
		overflow:auto;
	}
	#ContentDiv{
		height:90%;
		width:100%; 
	}
	#DebugDiv{
		height:1%;
		width:100%;
	}
-->
</style>
</head>
<body leftmargin="0" topmargin="0" class="windowbackground" onload="">
<!-- for refresh this page -->
<form name="DOFilter" method=post onSubmit="if(!checkDOFilterForm(this)) return false;">
	<input type=hidden name=CompClientID value="<%=CurComp.getClientID()%>">
	<input type=hidden name=PageClientID value="<%=CurPage.getClientID()%>">
</form>
<div id="outter">
	<div id="buttonDiv">
		<%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%>
	</div>
	<script type="text/javascript">
		sButtonAreaHTML = document.getElementById("buttonDiv").innerHTML;
		if(sButtonAreaHTML.indexOf("AWEButton")<0){
			document.getElementById("buttonDiv").style.display="none";
		}
	</script>
	<div id="ContentDiv">
		<iframe name="left" src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0 scrolling=no ></iframe>
	</div>
<div>
</body>
</html>