<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sMethodName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("methodName"));
	String sClassName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("className"));
	if(sMethodName==null) sMethodName="";
	if(sClassName==null) sClassName="";
    String className="";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "MethodCategoryInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if(sMethodName.equals("")){
		className="审批流程";
		doTemp.WhereClause+=" and 1=2";
	}else{
		 className=sClassName;
		doTemp.WhereClause+=" and CLASSNAME='"+className+"' and methodName='"+sMethodName+"'";
	}
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
	function checkFlowExists() {
		var methodName = getItemValue(0, 0, "METHODNAME");
		if (typeof(methodName)=='undefined' || methodName.length==0) {
			return;
		}
		
		var methodName1 = RunMethod("公用方法", "GetColValue", "class_method,methodName,className='<%=className%>' and methodName='"+methodName+"'");
		//alert(sFlowNo1+"|"+typeof(sFlowNo1));
		if (methodName1!="Null" && methodName1.length>0) {
			alert("该方法名已经存在，请重新输入！");
			setItemValue(0, 0, "METHODNAME", "");
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
		AsControl.OpenView("/SystemManage/CarManage/MethodCategoryList.jsp","","_self");
		parent.reloadSelf();
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
	}
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			setItemValue(0, 0, "CLASSNAME", "<%=className%>");
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
