<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.biz.workflow.action.*" %>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang 2004-12-16 20:35
		Tester:
		Content: 显示授信业务信息
		Input Param:
			    TaskNo：任务编号
			    ObjectNo：对象编号
			    ObjectType：对象类型
			    FlowNo：流程编号
			    PhaseNo：阶段编号
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "显示授信业务信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	
	String sTaskNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TaskNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	
	//获得页面参数		
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String sApproveType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApproveType"));
	
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
		ASResultSet rs = null;
		SqlObject so = null;
		
		FlowAction flowAction = new FlowAction();
		flowAction.setSerialNo(sTaskNo);
		String sPhaseName = flowAction.getPhaseName(Sqlca);
		
		//设定标题
		sSql = 	" select CustomerName||'-'||getBusinessName(BusinessType), "+
				" BusinessSum,BusinessRate,nvl(TermMonth,0), "+
				" getOrgName(InputOrgID),getUserName(InputUserID) "+
				" from BUSINESS_APPLY where SerialNo=:SerialNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
		if(rs.next()){
			sTitle = "当前阶段-["+sPhaseName+"]";
			sTitle += "-授信申请-[" + rs.getString(1) +"]";
			sTitle += "-金额[" + DataConvert.toMoney(rs.getString(2)) +"元]";
			sTitle += "-利率[" + rs.getDouble(3) +"‰]";
			sTitle += "-期限[" + rs.getString(4) +"]";
			sTitle += "-经办机构[" + rs.getString(5) +"]";
			sTitle += "-经办人[" + rs.getString(6) +"]";
		}
		rs.getStatement().close();
				
		sSql = "select CustomerID from BUSINESS_APPLY where SerialNo =:SerialNo";
		sCustomerID = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));

		sItemName = "签署意见";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('signApplyTaskOpinion','"+sObjectNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
		
		sItemName = "查看各级意见";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('ViewFlowOpinions','"+sObjectNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);

		sItemName = "历史审查审批意见";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('viewHistoryOpinion','"+sCustomerID+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);

		sItemName = "业务申请信息";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('CreditApply','"+sObjectNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
		
		//客户经理岗位（总行/分行/支行）的人员：从客户所属信息表中查询出本机构自己具有当前客户的信息查看权或信息维护权的记录数
		if(CurUser.hasRole("080") || CurUser.hasRole("280") || CurUser.hasRole("480")){
			sSql = 	" select Count(*) from CUSTOMER_BELONG  "+
					" where CustomerID =:CustomerID "+
					" and OrgID =:OrgID "+
					" and UserID =:UserID "+
					" and (BelongAttribute1 = '1' or BelongAttribute2 = '1')";
			so = new SqlObject(sSql);
			so.setParameter("CustomerID",sCustomerID).setParameter("OrgID",CurOrg.getOrgID()).setParameter("UserID",CurUser.getUserID());	
		}else{ //非客户经理岗位的人员：从客户所属信息表中查询出本机构及其下属机构具有当前客户的信息查看权或信息维护权的记录数
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
		//关闭结果集
		rs.getStatement().close();
		
		//如果用户没有上述相关权限，则给出相应的提示
		if( iCount  > 0){
			sItemName = "客户信息";
			sAddStringArray = new String[] {"",sItemName,"doTabAction('Customer','"+sCustomerID+"')"};
			sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
		}
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

<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
	<script type="text/javascript">
	//参数依次为： tab的ID,tab定义数组,默认显示第几项,目标单元格
	hc_drawTabToTable("tab_DeskTopInfo",tabstrip,<%=initTab%>,document.getElementById('<%=sTabID%>'));
	//设定默认页面
	<%=sTabStrip[initTab-1][2]%>;
	</script>	
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>