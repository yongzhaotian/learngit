<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:jgao1 2009-10-9
		Tester:
		Content:��С��ҵ�϶�ģ��ҳ��
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��С��ҵ�϶�ģ��ҳ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	

	//���ҳ�����	
	String sIndustryType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("IndustryType"));
	if(sIndustryType==null) sIndustryType="";
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=�����ǩ;]~*/%>
<script type="text/javascript">
	var tabstrip = new Array();
  	<%
	  	String sTabStrip[][] = {
								{"3","������ҵ","doTabAction(\'firstTab\')"},
								{"4","С����ҵ","doTabAction(\'secondTab\')"}
								};

		out.println(HTMLTab.genTabArray(sTabStrip,"tab_DeskTopInfo","document.getElementById('tabtd')"));

		String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=98% height=98%";
		String sTabHeadStyle = "";
		String sTabHeadText = "<br>";
		String sTopRight = "";
		String sTabID = "tabtd";
		String sIframeName = "TabContentFrame";
		String sDefaultPage = sWebRootPath+"/Blank.jsp?TextToShow=���ڴ�ҳ�棬���Ժ�";
		String sIframeStyle = "width=100% height=100% frameborder=0	hspace=0 vspace=0 marginwidth=0	marginheight=0 scrolling=no";

	%>

</script>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��]~*/%>
<html>
<head>
<title><%=PG_TITLE%></title>
</head> 
<body leftmargin="0" topmargin="0" class="pagebackground">
	<%@include file="/Resources/CodeParts/Tab04.jsp"%>
</body>
</html>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>
	<script type="text/javascript">

	/**
	 * Ĭ�ϵ�tabִ�к���
	 * ����true�����л�tabҳ;
	 * ����false�����л�tabҳ
	 */
  	function doTabAction(sArg)
  	{
  		if(sArg=="firstTab")
  		{
			OpenComp("SMEConfirmInfo","/Common/Configurator/ConfirmModel/SMEConfirmInfo.jsp","Scope=3&IndustryType=<%=sIndustryType%>","<%=sIframeName%>","");
			return true; 
		}else if(sArg=="secondTab")
  		{
			OpenComp("SMEConfirmInfo","/Common/Configurator/ConfirmModel/SMEConfirmInfo.jsp","Scope=4&IndustryType=<%=sIndustryType%>","<%=sIframeName%>","");
			return true;
		}else
		{
			return false; 
		}
  	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
	<script type="text/javascript">
	
	//��������Ϊ�� tab��ID,tab��������,Ĭ����ʾ�ڼ���,Ŀ�굥Ԫ��
	hc_drawTabToTable("tab_DeskTopInfo",tabstrip,1,document.getElementById('<%=sTabID%>'));
	doTabAction('firstTab');

	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
