<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang 2004-12-16 20:35
		Tester:
		Content: 显示授信业务信息
		Input Param:
                ObjectNo:代号
                InspectType:报告类型
	                010	贷款用途报告
					020	贷款检查报告
		Output param:
		History Log:   
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户检查报告"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	

	//获得页面参数	
	String sSerialNo   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sObjectNo   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));

	%>
<%/*~END~*/%>     

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义标签;]~*/%>
<script type="text/javascript">
	var tabstrip = new Array();
  	<%
		String sSql = "";
		String sItemName = "";
		String sCustomerID = "";
		String sTitle="";
	  	String sAddStringArray[] = null;
	  	String sTabStrip[][] = new String[20][3];
		int initTab = 1;//设定默认的 tab ，数值代表第几个tab

		sItemName = "客户检查报告摘要";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('PrintInspectResume','"+sSerialNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);

		sItemName = "客户检查报告";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('Inspect','"+sSerialNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
		
		sItemName = "贷后检查表";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('AfterLoanInspect','"+sSerialNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
		
		sItemName = "附录一(风险分类)";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('PrintInspectResum1','"+sSerialNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);

		sItemName = "附录二(业务信息)";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('PrintInspectResum2','"+sSerialNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);

		sItemName = "附录三(抵质押物信息)";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('PrintInspectResum3','"+sSerialNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);

		sItemName = "附录四(财务信息)";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('PrintInspectResum4','"+sSerialNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
		
		sSql = "select ObjectNo from INSPECT_INFO where SerialNo =:SerialNo";
		sCustomerID = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));

		sItemName = "附录五(客户信息)";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('Customer','"+sCustomerID+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);

		//设定标题
		sTitle = "客户检查报告";

		//根据定义组生成 tab
		out.println(HTMLTab.genTabArray(sTabStrip,"tab_DeskTopInfo","document.getElementById('tabtd')"));

		String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=98% height=98%";
		String sTabHeadStyle = "";
		String sTabHeadText = "<br>";
		String sTopRight = "";
		String sTabID = "tabtd";
		String sIframeName = "TabContentFrame";
		String sDefaultPage = sWebRootPath+"/Blank.jsp?TextToShow=正在打开页面，请稍候";
		String sIframeStyle = "width=100% height=100% frameborder=0	hspace=0 vspace=0 marginwidth=0	marginheight=0 scrolling=yes";
	%>

</script>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面]~*/%>
<html>
<head>
<title><%=sTitle%></title>
</head> 
<body leftmargin="0" topmargin="0" class="pagebackground">
	<%@include file="/Resources/CodeParts/Tab04.jsp"%>
</body>
</html>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
	<script type="text/javascript">
  	function doTabAction(sObjectType,sObjectNo)
  	{
  		if (sObjectType=="Customer") {
			sViewID = "002";
			openObjectInFrame(sObjectType,sObjectNo,sViewID,"<%=sIframeName%>");
			return true;
  		}
  		else if (sObjectType=="BusinessContract") {
			sCompID = "CustomerLoanAfterList";
			sCompURL = "/CustomerManage/EntManage/CustomerLoanAfterList.jsp";
			sParamString = "CustomerID=<%=sCustomerID%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}
  		else if (sObjectType=="Inspect") {			
			sCompID = "BusinessInspect01";
			sCompURL = "/FormatDoc/BusinessInspect/01.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>&DocID=01";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}
  		else if (sObjectType=="AfterLoanInspect") {			
			sCompID = "BusinessInspect06";
			sCompURL = "/FormatDoc/BusinessInspect/06.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>&DocID=06";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}  
  		else if (sObjectType=="PrintInspectResume") {			
			sCompID = "BusinessInspect00";
			sCompURL = "/FormatDoc/BusinessInspect/00.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}  		
  		else if (sObjectType=="PrintInspectResum1") {			
			sCompID = "BusinessInspect03";
			sCompURL = "/FormatDoc/BusinessInspect/03.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}
  		else if (sObjectType=="PrintInspectResum2") {			
			sCompID = "BusinessInspect04";
			sCompURL = "/FormatDoc/BusinessInspect/04.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}
  		else if (sObjectType=="PrintInspectResum3") {			
			sCompID = "BusinessInspect05";
			sCompURL = "/FormatDoc/BusinessInspect/05.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}  		
  		else if (sObjectType=="PrintInspectResum4") {
			sCompID = "CustomerFAList";
			sCompURL = "/CustomerManage/FinanceAnalyse/CustomerFAList.jsp";
			sParamString = "CustomerID=<%=sObjectNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}
  	}
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
	<script type="text/javascript">
	//参数依次为： tab的ID,tab定义数组,默认显示第几项,目标单元格
	hc_drawTabToTable("tab_DeskTopInfo",tabstrip,<%=initTab%>,document.getElementById('<%=sTabID%>'));
	//设定默认页面
	<%=sTabStrip[initTab-1][2]%>;
	</script>	
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>