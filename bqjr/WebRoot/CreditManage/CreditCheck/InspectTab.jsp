<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cchang 2004-12-16 20:35
		Tester:
		Content: ��ʾ����ҵ����Ϣ
		Input Param:
                ObjectNo:����
                InspectType:��������
	                010	������;����
					020	�����鱨��
		Output param:
		History Log:   
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ���鱨��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	

	//���ҳ�����	
	String sSerialNo   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sObjectNo   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));

	%>
<%/*~END~*/%>     

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=�����ǩ;]~*/%>
<script type="text/javascript">
	var tabstrip = new Array();
  	<%
		String sSql = "";
		String sItemName = "";
		String sCustomerID = "";
		String sTitle="";
	  	String sAddStringArray[] = null;
	  	String sTabStrip[][] = new String[20][3];
		int initTab = 1;//�趨Ĭ�ϵ� tab ����ֵ����ڼ���tab

		sItemName = "�ͻ���鱨��ժҪ";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('PrintInspectResume','"+sSerialNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);

		sItemName = "�ͻ���鱨��";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('Inspect','"+sSerialNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
		
		sItemName = "�������";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('AfterLoanInspect','"+sSerialNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
		
		sItemName = "��¼һ(���շ���)";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('PrintInspectResum1','"+sSerialNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);

		sItemName = "��¼��(ҵ����Ϣ)";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('PrintInspectResum2','"+sSerialNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);

		sItemName = "��¼��(����Ѻ����Ϣ)";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('PrintInspectResum3','"+sSerialNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);

		sItemName = "��¼��(������Ϣ)";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('PrintInspectResum4','"+sSerialNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
		
		sSql = "select ObjectNo from INSPECT_INFO where SerialNo =:SerialNo";
		sCustomerID = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));

		sItemName = "��¼��(�ͻ���Ϣ)";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('Customer','"+sCustomerID+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);

		//�趨����
		sTitle = "�ͻ���鱨��";

		//���ݶ��������� tab
		out.println(HTMLTab.genTabArray(sTabStrip,"tab_DeskTopInfo","document.getElementById('tabtd')"));

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
<title><%=sTitle%></title>
</head> 
<body leftmargin="0" topmargin="0" class="pagebackground">
	<%@include file="/Resources/CodeParts/Tab04.jsp"%>
</body>
</html>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>
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

<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
	<script type="text/javascript">
	//��������Ϊ�� tab��ID,tab��������,Ĭ����ʾ�ڼ���,Ŀ�굥Ԫ��
	hc_drawTabToTable("tab_DeskTopInfo",tabstrip,<%=initTab%>,document.getElementById('<%=sTabID%>'));
	//�趨Ĭ��ҳ��
	<%=sTabStrip[initTab-1][2]%>;
	</script>	
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>