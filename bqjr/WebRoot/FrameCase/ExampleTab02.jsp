<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��:ʾ��tabҳ��
	 */
%>
<script type="text/javascript">
	var tabstrip = new Array();
  	<%
	  	String sTabStrip[][] = {
								{"","����Info","doTabAction(\'firstTab\')"},
								{"","STRIPT","doTabAction(\'secondTab\')"},
								{"","TAB","doTabAction(\'thirdTab\')"},
								{"","�հ�ҳ","doTabAction(\'fourthTab\')"},
								{"","���л�ҳ","doTabAction(\'fivethTab\')"}
								};

  		String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=98% height=98%";
		String sTabHeadStyle = "";
		String sTabHeadText = "<br>";
		String sTopRight = "";
		String sTabID = "tabtd";
		String sIframeName = "TabContentFrame";
		String sDefaultPage = sWebRootPath+"/Blank.jsp?TextToShow=���ڴ�ҳ�棬���Ժ�";
		String sIframeStyle = "width=100% height=100% frameborder=0	hspace=0 vspace=0 marginwidth=0	marginheight=0 scrolling=no";
		
		out.println(HTMLTab.genTabArray(sTabStrip,"tab_DeskTopInfo","document.getElementById('"+sTabID+"')"));
	%>
</script>
<html>
<head>
<title>ʾ��tabҳ��</title>
</head> 
<body leftmargin="0" topmargin="0" class="pagebackground">
	<%@include file="/Resources/CodeParts/Tab04.jsp"%>
</body>
</html>
<script type="text/javascript">
	/**
	 * Ĭ�ϵ�tabִ�к���
	 * ����true�����л�tabҳ;
	 * ����false�����л�tabҳ
	 */
  	function doTabAction(sArg){
  		if(sArg=="firstTab"){
  			AsControl.OpenView("/FrameCase/ExampleInfo01.jsp","","<%=sIframeName%>","");
		}else if(sArg=="secondTab"){
			AsControl.OpenView("/FrameCase/ExampleStrip06.jsp","","<%=sIframeName%>","");
		}else if(sArg=="thirdTab"){
			AsControl.OpenView("/FrameCase/ExampleTab06.jsp","","<%=sIframeName%>","");
		}else if(sArg=="fourthTab"){
			AsControl.OpenView("/Blank.jsp","","<%=sIframeName%>","");
		}else{
			alert("����false,ҳ�治�л���");
		}
  	}
	
	$(document).ready(function(){
		//��������Ϊ�� tab��ID,tab��������,Ĭ����ʾ�ڼ���,Ŀ�굥Ԫ��
		hc_drawTabToTable("tab_DeskTopInfo",tabstrip,1,document.getElementById('<%=sTabID%>'));
		doTabAction('firstTab');
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>