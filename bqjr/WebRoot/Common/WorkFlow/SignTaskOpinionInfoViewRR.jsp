<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xswang 20150505
		Tester:
		Content: CCS-637 PRM-293 ��˹��������Ҫ�㹦��ά��
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	/*
		--ҳ��˵��: ʾ�����¿��ҳ��--
	 */
	 //��ȡҳ�����
	 String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	 String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	 String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo")); 
	 String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo")); 
	 String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
	 //��ȡģ����
	 
%><%@include file="/Resources/CodeParts/Frame0302.jsp"%>
<script type="text/javascript">	
	var OpenStyle = "width=100%,height=100%,top=20,left=20,toolbar=yes,scrollbars=yes,resizable=yes,status=yes,menubar=yes,";
	AsControl.OpenView("/Common/WorkFlow/SignTaskAuditPoints.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&FlowNo=<%=sFlowNo%>&PhaseNo=<%=sPhaseNo%>","frameleft",OpenStyle);
	AsControl.OpenView("/Common/WorkFlow/SignTaskOpinionInfoNew.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&FlowNo=<%=sFlowNo%>&PhaseNo=<%=sPhaseNo%>","frameright",OpenStyle);
	//ID5����10���ˢ��ֹͣID5���ã��ĳ��ֶ�ģʽ add by phe
	setTimeout(
			function ID5(){
				var sSerialNo = "<%=sSerialNo%>";
				var sRet = "timeOut";
				var sReqData="";
				var sReqHeader ="";
				var sCount = "";
				var sCustomerID = RunMethod("���÷���","GetColValue","Business_Contract,Customerid,serialno='<%=sObjectNo%>'");
				var sRzb = RunMethod("���÷���","GetColValue","business_renzhengbao,status,1='1'");//��ȡ��֤����־
				var maxSerialNo = RunMethod("���÷���", "GetColValue", "FLOW_TASK,max(serialno),objectNo='<%=sObjectNo%>'");//��ȡ��ǰ�׶�
				var sPhaseName  = RunMethod("���÷���", "GetColValue", "FLOW_TASK,PHASENAME,SERIALNO='"+maxSerialNo+"'");//��ȡ������				
				
				if(sRzb=="N"){
					if(sPhaseName=="NCIIC��Ϣ�Զ����"){
						sReqData = RunMethod("���÷���","GetColValue", "IND_INFO,CUSTOMERNAME||'@'||CERTID,CUSTOMERID='"+sCustomerID+"'");
						if(sReqData == null) sReqData = "";	
						sReqData = sReqData.replace("-", "");
						sReqHeader = "1A020201";
						//sCount = RunMethod("���÷���","GetColValue", "ID5_XML_ELE_VAL,count(1),serialno='"+sParm+"'");
						sCount = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.CheckID5TimeOut", "CheckTimeOut", "ReqHeader="+sReqHeader+",ReqData="+sReqData);
						sReqData = "CERTID";
					}else if(sPhaseName=="ID5�칫�绰���"||sPhaseName=="ID5�칫�绰�˲�"){
						sReqData = RunMethod("���÷���","GetColValue", "IND_INFO,WORKTEL,CUSTOMERID='"+sCustomerID+"'");
						if(sReqData == null) sReqData = "";	
						sReqData = sReqData.replace("-", "");
						sReqHeader = "1C1G01";
						//sCount = RunMethod("���÷���","GetColValue", "ID5_XML_ELE_VAL,count(1),serialno='"+sParm+"' and (TO_DATE(TO_CHAR(SYSDATE,'yyyy/mm/dd'),'yyyy/mm/dd')-(TO_DATE(SUBSTR(INPUTDATE,1,10), 'yyyy/mm/dd')+30))>0");
						sCount = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.CheckID5TimeOut", "CheckTimeOut", "ReqHeader="+sReqHeader+",ReqData="+sReqData);
						sReqData = "WORKTEL";
					}else if(sPhaseName=="ID5��ͥ�绰���"||sPhaseName=="ID5��ͥ�绰�˲�"){
						sReqData = RunMethod("���÷���","GetColValue", "IND_INFO,FAMILYTEL,CUSTOMERID='"+sCustomerID+"'");
						if(sReqData == null) sReqData = "";	
						sReqData = sReqData.replace("-", "");
						sReqHeader = "1C1G01";
						//sCount = RunMethod("���÷���","GetColValue", "ID5_XML_ELE_VAL,count(1),serialno='"+sParm+"' and (TO_DATE(TO_CHAR(SYSDATE,'yyyy/mm/dd'),'yyyy/mm/dd')-(TO_DATE(SUBSTR(INPUTDATE,1,10), 'yyyy/mm/dd')+30))>0");
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
