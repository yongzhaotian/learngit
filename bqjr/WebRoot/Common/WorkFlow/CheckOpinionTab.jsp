<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.biz.workflow.action.*" %>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cchang 2004-12-16 20:35
		Tester:
		Content: ��ʾ����ҵ����Ϣ
		Input Param:
			    TaskNo��������
			    ObjectNo��������
			    ObjectType����������
			    FlowNo�����̱��
			    PhaseNo���׶α��
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
	//�������
	
	//����������	
	String sTaskNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TaskNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	
	//���ҳ�����		
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String sApproveType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApproveType"));
	
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
		ASResultSet rs = null;
		SqlObject so = null;
		
		FlowAction flowAction = new FlowAction();
		flowAction.setSerialNo(sTaskNo);
		String sPhaseName = flowAction.getPhaseName(Sqlca);
		
		//�趨����
		sSql = 	" select CustomerName||'-'||getBusinessName(BusinessType), "+
				" BusinessSum,BusinessRate,nvl(TermMonth,0), "+
				" getOrgName(InputOrgID),getUserName(InputUserID) "+
				" from BUSINESS_APPLY where SerialNo=:SerialNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
		if(rs.next()){
			sTitle = "��ǰ�׶�-["+sPhaseName+"]";
			sTitle += "-��������-[" + rs.getString(1) +"]";
			sTitle += "-���[" + DataConvert.toMoney(rs.getString(2)) +"Ԫ]";
			sTitle += "-����[" + rs.getDouble(3) +"��]";
			sTitle += "-����[" + rs.getString(4) +"]";
			sTitle += "-�������[" + rs.getString(5) +"]";
			sTitle += "-������[" + rs.getString(6) +"]";
		}
		rs.getStatement().close();
				
		sSql = "select CustomerID from BUSINESS_APPLY where SerialNo =:SerialNo";
		sCustomerID = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));

		sItemName = "ǩ�����";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('signApplyTaskOpinion','"+sObjectNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
		
		sItemName = "�鿴�������";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('ViewFlowOpinions','"+sObjectNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);

		sItemName = "��ʷ����������";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('viewHistoryOpinion','"+sCustomerID+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);

		sItemName = "ҵ��������Ϣ";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('CreditApply','"+sObjectNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
		
		//�ͻ������λ������/����/֧�У�����Ա���ӿͻ�������Ϣ���в�ѯ���������Լ����е�ǰ�ͻ�����Ϣ�鿴Ȩ����Ϣά��Ȩ�ļ�¼��
		if(CurUser.hasRole("080") || CurUser.hasRole("280") || CurUser.hasRole("480")){
			sSql = 	" select Count(*) from CUSTOMER_BELONG  "+
					" where CustomerID =:CustomerID "+
					" and OrgID =:OrgID "+
					" and UserID =:UserID "+
					" and (BelongAttribute1 = '1' or BelongAttribute2 = '1')";
			so = new SqlObject(sSql);
			so.setParameter("CustomerID",sCustomerID).setParameter("OrgID",CurOrg.getOrgID()).setParameter("UserID",CurUser.getUserID());	
		}else{ //�ǿͻ������λ����Ա���ӿͻ�������Ϣ���в�ѯ�����������������������е�ǰ�ͻ�����Ϣ�鿴Ȩ����Ϣά��Ȩ�ļ�¼��
			sSql =  " select sortno||'%' from org_info where orgid=:orgid ";
			String sSortNo = Sqlca.getString(new SqlObject(sSql).setParameter("orgid",CurUser.getOrgID()));
			sSql = 	" select Count(*) from CUSTOMER_BELONG  "+
					" where CustomerID =:CustomerID "+
					" and OrgID in (select orgid from org_info where sortno like :sortno) "+
					" and (BelongAttribute1 = '1' or BelongAttribute2 = '1')";
			so = new SqlObject(sSql);
			so.setParameter("CustomerID",sCustomerID).setParameter("sortno",sSortNo);
		}
		int iCount = 0;
		rs = Sqlca.getASResultSet(so);
		if(rs.next())
			iCount = rs.getInt(1);
		//�رս����
		rs.getStatement().close();
		
		//����û�û���������Ȩ�ޣ��������Ӧ����ʾ
		if( iCount  > 0){
			sItemName = "�ͻ���Ϣ";
			sAddStringArray = new String[] {"",sItemName,"doTabAction('Customer','"+sCustomerID+"')"};
			sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
		}
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
	var bHidePrintButton = true;
  	function doTabAction(sObjectType,sObjectNo){
		if (sObjectType=="ViewFlowOpinions"){
			sCompID = "ViewApplyFlowOpinions";
			sCompURL = "/Common/WorkFlow/ViewApplyFlowOpinions.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&FlowNo=<%=sFlowNo%>&PhaseNo=<%=sPhaseNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			setDialogTitle("<%=sTitle%>");
			return true;
		}else if (sObjectType=="viewHistoryOpinion"){
			sCompID = "HistoryApplyList";
			sCompURL = "/Common/WorkFlow/HistoryApplyList.jsp";
			sParamString = "CustomerID=<%=sCustomerID%>&ObjectNo=<%=sObjectNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			setDialogTitle("<%=sTitle%>");
			return true;
		}else if (sObjectType=="signApplyTaskOpinion"){
			sCompID = "SignApplyTaskOpinionInfo";
			sCompURL = "/Common/WorkFlow/SignApplyTaskOpinionInfo.jsp";
			sParamString = "TaskNo=<%=sTaskNo%>&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ApproveType=<%=sApproveType%>";
		    OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			setDialogTitle("<%=sTitle%>");
			return true;
		}else{
			openObjectInFrame(sObjectType,sObjectNo,"002","<%=sIframeName%>");
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