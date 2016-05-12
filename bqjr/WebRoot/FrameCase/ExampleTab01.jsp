<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明:从sql生成tab页面
	 */
%>
<script type="text/javascript">
	var tabstrip = new Array();
  	<%
		String sSqlTab = "select ItemNo,ItemName,Attribute1 from CODE_LIBRARY where CodeNo = 'TabStripExample' and IsInUse = '1' order by SortNo";
	  	String sTabStrip[][] = HTMLTab.getTabArrayWithSql(sSqlTab,Sqlca);

	  	String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=98% height=98%";
		String sTabHeadStyle = "";
		String sTabHeadText = "<br>";
		String sTopRight = "";
		String sTabID = "tabtd";
		String sIframeName = "TabContentFrame";
		String sDefaultPage = sWebRootPath+"/Blank.jsp?TextToShow=正在打开页面，请稍候";
		String sIframeStyle = "width=100% height=100% frameborder=0	hspace=0 vspace=0 marginwidth=0	marginheight=0 scrolling=no";

		out.println(HTMLTab.genTabArray(sTabStrip,"tab_DeskTopInfo","document.getElementById('"+sTabID+"')"));
	%>
</script>
<html>
<head>
<title>从sql生成tab页面</title>
</head> 
<body leftmargin="0" topmargin="0" class="pagebackground">
	<%@include file="/Resources/CodeParts/Tab04.jsp"%>
</body>
</html>
<script type="text/javascript">
	/**
	 * 默认的tab执行函数
	 * 返回true，则切换tab页;
	 * 返回false，则不切换tab页
	 */
  	function doTabAction(sArg){
  		if(sArg=="firstTab"){
  			AsControl.OpenView("/FrameCase/ExampleInfo01.jsp","","<%=sIframeName%>","");
			return true; 
		}else if(sArg=="secondTab"){
			AsControl.OpenView("/FrameCase/ExampleStrip06.jsp","","<%=sIframeName%>","");
			return true;
		}else if(sArg=="thirdTab"){
			AsControl.OpenView("/FrameCase/ExampleTab06.jsp","","<%=sIframeName%>","");
			return true;
		}
  	}
	
	$(document).ready(function(){
		//参数依次为： tab的ID,tab定义数组,默认显示第几项,目标单元格
		hc_drawTabToTable("tab_DeskTopInfo",tabstrip,1,document.getElementById('<%=sTabID%>'));
		doTabAction('firstTab');
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>