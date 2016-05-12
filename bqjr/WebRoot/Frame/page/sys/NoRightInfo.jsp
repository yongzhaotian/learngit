<%@ page contentType="text/html; charset=GBK" isErrorPage="true"%>
<%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>权限异常</title>
<META http-equiv="Content-Type" content="text/html; charset=GBK">
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/Frame/page/resources/css/syspage.css"/>
<script type="text/javascript" src="<%=request.getContextPath()%>/Frame/resources/js/jquery/jquery-1.9.1.min.js"></script>
</head>
<body>
<div class="nor_doc">
      <div class="nor_show">
            <div class="nor_tit">没有权限</div>
            <div class="nor_tit">AWES0002</div>
			 <div class="nor_info">没有权限访问该页面</div>
	        <div class="nor_line"></div>
	        <div class="purview_img"></div>
      </div>
	  <div class="nor_btnzone" style="width:100%; height:60px; float:left;">
	  <div class="nor_btn" id="logout"></div>
	  <div onclick="goHome();" class="nor_btn_home" id="backhome"></div>
	  </div>
</div>
</body>
<script type="text/javascript">
	function goHome() {
		window.open("<%=request.getContextPath()%>/Redirector?ComponentURL=/Main.jsp&sToDestroyAllComponent=Y","_top");
	}

	$(document).ready(function(){
		$("#logout").bind("click",function(){
			window.open('<%=request.getContextPath()%>/Frame/page/sys/SessionOut.jsp','_top');
		});
		$("#logout").bind("mousedown",function(){
			$(this).toggleClass("nor_btn_down").toggleClass("nor_btn");
		});
		$("#logout").bind("mouseup",function(){//alert();
			$(this).toggleClass("nor_btn_down").toggleClass("nor_btn");
		});
		$("#logout").hover(function(){
			$(this).toggleClass("nor_btn_on").toggleClass("nor_btn");
		},function(){
			$(this).removeClass("nor_btn_on").addClass("nor_btn");
		});
		$(document).bind("mouseover",function(){//alert();
			$("#logout").removeClass("nor_btn_down").addClass("nor_btn");
		});
		
		$("#backhome").bind("mousedown",function(){
			$(this).toggleClass("nor_btn_down_home").toggleClass("nor_btn_home");
		});
		$("#backhome").bind("mouseup",function(){//alert();
			$(this).toggleClass("nor_btn_down_home").toggleClass("nor_btn_home");
		});
		$("#backhome").hover(function(){
			$(this).toggleClass("nor_btn_on_home").toggleClass("nor_btn_home");
		},function(){
			$(this).removeClass("nor_btn_on_home").addClass("nor_btn_home");
		});
		$(document).bind("mouseover",function(){//alert();
			$("#backhome").removeClass("nor_btn_down_home").addClass("nor_btn_home");
		});
	});
</script>
</html>