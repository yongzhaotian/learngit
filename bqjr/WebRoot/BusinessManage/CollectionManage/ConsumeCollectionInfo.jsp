<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "催收任务登记结果详情界面";

	// 获得页面参数
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//催收结果登记号
	if(sSerialNo==null)sSerialNo="";
	
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ConsumeCollectionInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setVisible("INPUTUSERID,INPUTORGID,UPDATEUSERID,UPDATEORGID,EXECUTORUSERID", false);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	//<input class=\"inputdate\" value=\"...\" type=button onclick=parent.getRegionCode(\"\")>
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	
	//选择二级行动代码
	function getSubExecutorCode(){
		var sExecutorCode = getItemValue(0,getRow(),"EXECUTORCODE");//一级行动代码 
		if (typeof(sExecutorCode)=="undefined" || sExecutorCode.length==0){
			alert("请先选择一级行动代码再选择二级行动代码！");
			return;
		}
		
		var sSubExecutorCode = AsControl.PopPage("/SystemManage/ConsumeLoanManage/ActionCodeList.jsp", "ExecutorCode="+sExecutorCode+"&IsSelected=true", "");
		if (typeof(sSubExecutorCode)=="undefined" || sSubExecutorCode.length==0){
			alert("必须选择一项！");
			return;
		}
		setItemValue(0,0,"SUBEXECUTORCODE",sSubExecutorCode);
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
		AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionList.jsp","","_self");
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		
	}
	
	function initSerialNo(){
		var sSerialNo = getSerialNo("CONSUME_COLLECTIONREGIST_INFO","SERIALNO");// 获取流水号
		setItemValue(0,getRow(),"SERIALNO",sSerialNo);
	}
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			initSerialNo();
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
