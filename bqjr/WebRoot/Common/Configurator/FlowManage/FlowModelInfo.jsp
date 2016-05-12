<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    流程模型信息详情
		Input Param:
                    FlowNo：    流程编号
                    PhaseNo：   阶段编号
	 */
	String PG_TITLE = "流程模型信息详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得组件参数	
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";

	String sTempletNo = "FlowModelInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	String sSql = " select ItemNo,ItemName from CODE_LIBRARY where IsInUse='1' and CodeNo in (select trim(ItemDescribe) from CODE_LIBRARY where CodeNo='ApplyType' and trim(ItemNo) in (select FlowType from FLOW_CATALOG where FlowNo='"+sFlowNo+"'))";
	doTemp.setDDDWSql("PhaseType",sSql);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sFlowNo+","+sPhaseNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","保存并返回","保存修改并返回","saveRecordAndReturn()",sResourcesPath},
		{"true","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	
	function saveRecordAndReturn(){
		if(beforeSave() == false && bIsInsert){
			alert("该阶段编号已经被占用,请输入新的编号");
			return;
		}
		bIsInsert = false;
		
		as_save("myiframe0","doReturn('Y');");
	}
    
	function saveRecordAndAdd(){
		if(beforeSave() == false && bIsInsert){
			alert("该阶段编号已经被占用,请输入新的编号");
			return;
		}
		bIsInsert = false;
		
       as_save("myiframe0","newRecord()");
	}

    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"FlowNo");
       parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
	function newRecord(){
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		OpenComp("FlowModelInfo","/Common/Configurator/FlowManage/FlowModelInfo.jsp","FlowNo="+sFlowNo,"_self","");
	}
	
	/*~[Describe=检验插入数据唯一性;InputParam=;OutPutParam=是否有记录;]~*/
    function beforeSave()
    {
    	var flowNo  = getItemValue(0,getRow(),"FlowNo");
    	var phaseNo  = getItemValue(0,getRow(),"PhaseNo");
    	
		var sPara = "FlowNo=" + flowNo + ", TableName=FLOW_MODEL" + ", PhaseNo=" + phaseNo;
		var hasRecord =  RunJavaMethodSqlca("com.amarsoft.app.als.process.action.FlowNoUniqueCheck","insertUniqueCheck",sPara);
		if (hasRecord == "true"){
			return false;
		}
    }

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			if ("<%=sFlowNo%>" !=""){
				setItemValue(0,0,"FlowNo","<%=sFlowNo%>");
			}
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>