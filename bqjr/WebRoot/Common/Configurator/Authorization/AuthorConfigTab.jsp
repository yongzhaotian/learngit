<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  
		Tester:
		Content: ��Ȩ����������,Ϊ�˼���als6.5������,��ʹ��als6.6+�е�tabCompent
		Input Param:
                
		Output param:
			
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ȩ��������"; 	// ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	

	%>
<%/*~END~*/%>     

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=�����ǩ;]~*/%>
<script language="JavaScript">
	var tabstrip = new Array();
  	<%
		String sTabStrip[][] = {{"true","��Ȩ��������","doTabAction('scene')"},{"true","��Ȩ��������","doTabAction('dimension')"}};
		
		//���ݶ��������� tab
		out.println(HTMLTab.genTabArray(sTabStrip,"tab_AuthorInfo","document.all('tabtd')"));

		String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=98% height=98%";
		String sTabHeadStyle = "";
		String sTabHeadText = "<br>";
		String sTopRight = "";
		String sTabID = "tabtd";
		String sIframeName = "TabContentFrame";
		String sDefaultPage = sWebRootPath+"/Blank.jsp?TextToShow=���ڴ�ҳ�棬���Ժ�";
		String sIframeStyle = "width=100% height=100% frameborder=0	hspace=0 vspace=0 marginwidth=0	marginheight=0 scrolling=yes";

	%>

</script>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��]~*/%>
<html>
<head>
<title><%=PG_TITLE%></title>
</head> 
<body leftmargin="0" topmargin="0" class="pagebackground" onBeforeUnload="unloadCheck()">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
		<tr>
			<td class="mytop">
				<%@include file="/MainTop.jsp"%>
			</td>
		</tr> 
		<tr>
  			<td valign="top" id="mymiddleShadow" class="mymiddleShadow"></td>
		</tr>
   		<tr>
			<td valign="top" bgcolor="#E0ECFF">
				<%@include file="/Resources/CodeParts/Tab04.jsp"%>
			</td>
		</tr>
	</table>
</body>
</html>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>
	<script language=javascript>
  	function doTabAction(varp)
  	{
  		if(varp=="scene"){
  			OpenComp("RuleSceneView","/Common/Configurator/Authorization/RuleSceneView.jsp","","<%=sIframeName%>");
  		}else if(varp=="dimension"){
  			OpenComp("DimensionList","/Common/Configurator/Authorization/DimensionList.jsp","","<%=sIframeName%>");
  		}else{
  			alert("doActionδ����.");
  			return;
  		}
  	}
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
	<script language=javascript>
	//��������Ϊ�� tab��ID,tab��������,Ĭ����ʾ�ڼ���,Ŀ�굥Ԫ��
	hc_drawTabToTable("tab_AuthorInfo",tabstrip,1,document.all('<%=sTabID%>'));
	//�趨Ĭ��ҳ��
	<%=sTabStrip[0][2]%>
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
