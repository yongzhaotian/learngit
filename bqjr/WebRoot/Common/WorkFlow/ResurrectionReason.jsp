<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ԭ�ظ���ԭ����дҳ��  add by yzhang9-- */
	String PG_TITLE = "ԭ�ظ���ԭ��";

	// ���ҳ�����  ���ݴ�ҳ��ķ�ʽ  CurComp
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	String sInitFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("InitFlowNo"));
	String sInitPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("InitPhaseNo"));
	String sUserID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserID"));
	String sOrgID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	String sUserName =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserName"));
	String sOrgName =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgName"));
	String sNextFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("NextFlowNo"));
	String sFlowName =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowName"));
	String sInputTime =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("InputTime"));
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ResurrectionReason";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.appendHTMLStyle("ResurrectionReason"," onBlur=\"javascript:parent.getDoChange()\" ");
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","ȷ��","ȷ��","saveRecord()",sResourcesPath},
			{"true","","Button","ȡ������","ȡ������","cancel()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	function saveRecord(){
		var sResurrectionReason = getItemValue(0,0,"ResurrectionReason");
		var sResurrectionReasonRemark = getItemValue(0,0,"ResurrectionReasonRemark");
		if (typeof(sResurrectionReason)=="undefined" || sResurrectionReason.length==0){
			alert("��ѡ��ԭ�ظ���ԭ��");
			return;
		}
		as_save("myiframe0");
		if(!getDoChange()) return;
		//self.returnValue= sResurrectionReason+"@"+sResurrectionReasonRemark;
		
		var sObjectType = "<%=sObjectType%>";	
		var sObjectNo = "<%=sObjectNo%>";	
		var sApplyType = "<%=sApplyType%>";	
		var sInitFlowNo = "<%=sInitFlowNo%>";	
		var sInitPhaseNo = "<%=sInitPhaseNo%>";
		var sSerialNo = "<%=sSerialNo%>";
		var sUserID = "<%=sUserID%>";
		var sOrgID = "<%=sOrgID%>";
		var sUserName = "<%=sUserName%>";
		var sOrgName = "<%=sOrgName%>";
		var sNextFlowNo = "<%=sNextFlowNo%>";
		var sFlowName = "<%=sFlowName%>";
		var sInputTime = "<%=sInputTime%>";
		
		var sPar_Value = "ObjectType="+sObjectType+",ObjectNo="+sObjectNo+",ApplyType="+sApplyType+",FlowNo="+sInitFlowNo+",PhaseNo="+sInitPhaseNo+",serialNo="+sSerialNo+",UserID="+sUserID+",OrgID="+sOrgID+",userName="+sUserName+",orgName="+sOrgName+",nextFlowNo="+sNextFlowNo+",flowName="+sFlowName+",InputTime="+sInputTime+",ResurrectionReason="+sResurrectionReason+",ResurrectionReasonRemark="+sResurrectionReasonRemark;
		self.returnValue = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.AddReconsiderInfo", "GenerateReconsiderContractInfo",sPar_Value);
		self.close();
	}
	
	function cancel(sPostEvents){
		self.returnValue= "false";
		self.close();
	}
	
	  function getDoChange(){
		 	 var sReason =getItemValue(0,getRow(),"ResurrectionReason");
		 	 if(sReason=='050'){
		 		showItem(0, 0, "ResurrectionReasonRemark", "block");//���ѡ��'����' �򵯳�һ���� ������д����ԭ�� 
		 		setItemRequired(0,0,"ResurrectionReasonRemark",true);//����Ϊ������
		 		var sResurrectionReasonRemark = getItemValue(0,0,"ResurrectionReasonRemark");
		 		if (typeof(sResurrectionReasonRemark)=="undefined" || sResurrectionReasonRemark.length==0){
					return false;
				}
		 		return true;
		 	 }else{
		 		hideItem(0,0,"ResurrectionReasonRemark");//���� 
		 		setItemRequired(0,0,"ResurrectionReasonRemark",false);//���÷Ǳ��� 
		 		return true;
		 	 }
	    }
	
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
