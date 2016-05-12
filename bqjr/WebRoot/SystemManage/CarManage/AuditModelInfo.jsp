<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String sActionType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ActionType"));
	if(sFlowNo==null) sFlowNo= "";
	if(sPhaseNo==null) sPhaseNo = "";
	if(sActionType==null) sActionType = "";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "AuditModelInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if (sPhaseNo.length()>0) 
		doTemp.WhereClause += " and FlowNo='"+sFlowNo+"' and PhaseNo="+sPhaseNo;	// 查看详情
	else
		doTemp.WhereClause += " and FlowNo='' and PhaseNo=''";	// 新增
	
	// 设置只读区
	if ("ViewDetail".equals(sActionType))
		doTemp.setReadOnly("PHASENO", false);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"false","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	
	<%/*~[Describe=检查该流程是否已经存在;]~*/%>
	function checkIsExists() {
		var sPhaseNo = getItemValue(0, 0, "PHASENO");
		if (typeof(sPhaseNo)=='undefined' || sPhaseNo.length==0) {
			return;
		}
		sPhaseNo = sPhaseNo.replace(/[^0-9]+/gi,'');
		setItemValue(0, 0, "PHASENO", sPhaseNo);
		if (sPhaseNo.length<=0) {
			return;
		}
		var sPhaseNo1 = RunMethod("公用方法", "GetColValue", "Flow_Model,PhaseNo,FlowNo='<%=sFlowNo%>' and PhaseNo='"+sPhaseNo.replace(/[^0-9]+/gi,'')+"'");
		//alert(sPhaseNo1+"|"+typeof(sPhaseNo1));
		if (sPhaseNo1!="Null" && sPhaseNo1.length>0) {
			alert("该阶段已经存在，请重新输入！");
			setItemValue(0, 0, "PHASENO", "");
		}
		return;
	}
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		AsControl.OpenView("/SystemManage/CarManage/AuditModelList.jsp","FlowNo=<%=sFlowNo%>","_self");
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		setItemValue(0, 0, "INPUTUSER", "<%=CurUser.getUserID() %>");
		setItemValue(0, 0, "INPUTTIME", "<%=DateX.format(new Date(), "yyyy/MM/dd HH:MM:SS") %>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0, 0, "UPDATEUSER", "<%=CurUser.getUserID() %>");
		setItemValue(0, 0, "UPDATETIME", "<%=DateX.format(new Date(), "yyyy/MM/dd HH:MM:SS") %>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			setItemValue(0, 0, "FLOWNO", "<%=sFlowNo %>");
			setItemValue(0, 0, "INPUTUSER", "<%=CurUser.getUserID() %>");
			setItemValue(0, 0, "INPUTTIME", "<%=DateX.format(new Date(), "yyyy/MM/dd HH:MM:SS") %>");
			
			setItemValue(0, 0, "UPDATEUSER", "<%=CurUser.getUserID() %>");
			setItemValue(0, 0, "UPDATETIME", "<%=DateX.format(new Date(), "yyyy/MM/dd HH:MM:SS") %>");
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
