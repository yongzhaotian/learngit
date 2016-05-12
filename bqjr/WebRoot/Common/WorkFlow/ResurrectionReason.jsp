<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 原地复活原因填写页面  add by yzhang9-- */
	String PG_TITLE = "原地复活原因";

	// 获得页面参数  根据打开页面的方式  CurComp
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
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ResurrectionReason";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.appendHTMLStyle("ResurrectionReason"," onBlur=\"javascript:parent.getDoChange()\" ");
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","确定","确定","saveRecord()",sResourcesPath},
			{"true","","Button","取消操作","取消操作","cancel()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	
	function saveRecord(){
		var sResurrectionReason = getItemValue(0,0,"ResurrectionReason");
		var sResurrectionReasonRemark = getItemValue(0,0,"ResurrectionReasonRemark");
		if (typeof(sResurrectionReason)=="undefined" || sResurrectionReason.length==0){
			alert("请选择原地复活原因");
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
		 		showItem(0, 0, "ResurrectionReasonRemark", "block");//如果选择'其他' 则弹出一个框 用来填写其他原因 
		 		setItemRequired(0,0,"ResurrectionReasonRemark",true);//设置为必输项
		 		var sResurrectionReasonRemark = getItemValue(0,0,"ResurrectionReasonRemark");
		 		if (typeof(sResurrectionReasonRemark)=="undefined" || sResurrectionReasonRemark.length==0){
					return false;
				}
		 		return true;
		 	 }else{
		 		hideItem(0,0,"ResurrectionReasonRemark");//隐藏 
		 		setItemRequired(0,0,"ResurrectionReasonRemark",false);//设置非必输 
		 		return true;
		 	 }
	    }
	
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
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
