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
	String PG_TITLE = "��ʾ����ҵ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//����������	
	String sSerialNo   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sObjectNo   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));

	%>
<%/*~END~*/%>     


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=�����ǩ;]~*/%>
<script type="text/javascript">
	var tabstrip = new Array();
  	<%
		String sSql = "";
		String sItemName = "";
		String sContractSerialNo = "";
		String sTitle="";
	  	String sAddStringArray[] = null;
	  	String sTabStrip[][] = new String[20][3];
		int initTab = 1;//�趨Ĭ�ϵ� tab ����ֵ����ڼ���tab

		sItemName = "������;�������";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('Inspect','"+sObjectNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);

		sItemName = "�����ӡԤ��";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('PrintPurpose','"+sObjectNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
				
		sSql = "select ObjectNo from INSPECT_INFO where SerialNo =:SerialNo";
		sContractSerialNo = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));

		sItemName = "ҵ������";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('BusinessContract','"+sContractSerialNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);


		//�趨����
		sTitle = "������;����";

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
		if (sObjectType=="BusinessContract") 
		{
			sViewID = "002";
			openObjectInFrame(sObjectType,sObjectNo,sViewID,"<%=sIframeName%>");
			return true;
		}
		else if (sObjectType=="Inspect") 
		{ 			
			sCompID = "PurposeView";
			sCompURL = "/CreditManage/CreditCheck/PurposeView.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo="+sObjectNo+"&SerialNo=<%=sSerialNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
		}
		else if (sObjectType=="PrintPurpose") 
		{ 			
			sCompID = "PurposeInspect01";
			sCompURL = "/FormatDoc/PurposeInspect/01.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>";
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