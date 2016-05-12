<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sItemNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("itemNo"));
	if(sItemNo==null) sItemNo="";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ExpressTypeInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sItemNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveAndGoBack()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	
	// 检查代码项编号是否重复
	function checkItemNo() {
		var sNo = getItemValue(0, 0, "itemNo");
		var ssItNo = RunMethod("公用方法", "GetColValue", "code_library,itemNo,itemNo='"+sNo+"' and codeNo='ExpressType' ");
		if (ssItNo!="Null" && ssItNo!=null && ssItNo!="null" && ssItNo!="") {
			alert("该序号已经存在，请重新输入！");
			setItemValue(0, 0, "itemNo", "");
			return;
		}
	}
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			//检查代码项编号是否重复
			checkItemNo();
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		AsControl.OpenView("/Common/WorkFlow/PutOutApply/ExpressTypeList.jsp","","_self");
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		setItemValue(0, 0, "CodeNo", "ExpressType");
		setItemValue(0, 0, "InputOrg", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			setItemValue(0, 0, "InputOrg", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "InputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
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
