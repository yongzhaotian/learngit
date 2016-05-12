<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xswang 20150505
		Tester:
		Content: CCS-637 PRM-293 审核过程中审核要点功能维护
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	/*
		--页面说明: 示例上下框架页面--
	 */
	 //获取页面参数
	 String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	 String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	 String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo")); 
	 String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo")); 
	 String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
	 //获取模版编号
	 
%><%@include file="/Resources/CodeParts/Frame0302.jsp"%>
<script type="text/javascript">	
	var OpenStyle = "width=100%,height=100%,top=20,left=20,toolbar=yes,scrollbars=yes,resizable=yes,status=yes,menubar=yes,";
	AsControl.OpenView("/Common/WorkFlow/SignTaskAuditPoints.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&FlowNo=<%=sFlowNo%>&PhaseNo=<%=sPhaseNo%>","frameleft",OpenStyle);
	AsControl.OpenView("/Common/WorkFlow/SignTaskOpinionInfoNew.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&FlowNo=<%=sFlowNo%>&PhaseNo=<%=sPhaseNo%>","frameright",OpenStyle);
	//ID5调用10秒后，刷新停止ID5调用，改成手动模式 add by phe
	setTimeout(
			function ID5(){
				var sSerialNo = "<%=sSerialNo%>";
				var sRet = "timeOut";
				var sReqData="";
				var sReqHeader ="";
				var sCount = "";
				var sCustomerID = RunMethod("公用方法","GetColValue","Business_Contract,Customerid,serialno='<%=sObjectNo%>'");
				var sRzb = RunMethod("公用方法","GetColValue","business_renzhengbao,status,1='1'");//获取认证宝标志
				var maxSerialNo = RunMethod("公用方法", "GetColValue", "FLOW_TASK,max(serialno),objectNo='<%=sObjectNo%>'");//获取当前阶段
				var sPhaseName  = RunMethod("公用方法", "GetColValue", "FLOW_TASK,PHASENAME,SERIALNO='"+maxSerialNo+"'");//获取流程名				
				
				if(sRzb=="N"){
					if(sPhaseName=="NCIIC信息自动检查"){
						sReqData = RunMethod("公用方法","GetColValue", "IND_INFO,CUSTOMERNAME||'@'||CERTID,CUSTOMERID='"+sCustomerID+"'");
						if(sReqData == null) sReqData = "";	
						sReqData = sReqData.replace("-", "");
						sReqHeader = "1A020201";
						//sCount = RunMethod("公用方法","GetColValue", "ID5_XML_ELE_VAL,count(1),serialno='"+sParm+"'");
						sCount = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.CheckID5TimeOut", "CheckTimeOut", "ReqHeader="+sReqHeader+",ReqData="+sReqData);
						sReqData = "CERTID";
					}else if(sPhaseName=="ID5办公电话检查"||sPhaseName=="ID5办公电话核查"){
						sReqData = RunMethod("公用方法","GetColValue", "IND_INFO,WORKTEL,CUSTOMERID='"+sCustomerID+"'");
						if(sReqData == null) sReqData = "";	
						sReqData = sReqData.replace("-", "");
						sReqHeader = "1C1G01";
						//sCount = RunMethod("公用方法","GetColValue", "ID5_XML_ELE_VAL,count(1),serialno='"+sParm+"' and (TO_DATE(TO_CHAR(SYSDATE,'yyyy/mm/dd'),'yyyy/mm/dd')-(TO_DATE(SUBSTR(INPUTDATE,1,10), 'yyyy/mm/dd')+30))>0");
						sCount = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.CheckID5TimeOut", "CheckTimeOut", "ReqHeader="+sReqHeader+",ReqData="+sReqData);
						sReqData = "WORKTEL";
					}else if(sPhaseName=="ID5家庭电话检查"||sPhaseName=="ID5家庭电话核查"){
						sReqData = RunMethod("公用方法","GetColValue", "IND_INFO,FAMILYTEL,CUSTOMERID='"+sCustomerID+"'");
						if(sReqData == null) sReqData = "";	
						sReqData = sReqData.replace("-", "");
						sReqHeader = "1C1G01";
						//sCount = RunMethod("公用方法","GetColValue", "ID5_XML_ELE_VAL,count(1),serialno='"+sParm+"' and (TO_DATE(TO_CHAR(SYSDATE,'yyyy/mm/dd'),'yyyy/mm/dd')-(TO_DATE(SUBSTR(INPUTDATE,1,10), 'yyyy/mm/dd')+30))>0");
						sCount = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.CheckID5TimeOut", "CheckTimeOut", "ReqHeader="+sReqHeader+",ReqData="+sReqData);
					}
					if((sCount!=""||sCount.length!=0)&&sCount=="0"&&sReqData!=""){
						AsControl.OpenView("/Common/WorkFlow/SignTaskOpinionInfoNew.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&FlowNo=<%=sFlowNo%>&PhaseNo=<%=sPhaseNo%>&Ret="+sRet,"frameright",OpenStyle);
					}
				}
			}, 5000);
	//end by phe
</script>	
<%@ include file="/IncludeEnd.jsp"%>
