<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sExampleId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ExampleId"));
	if(sExampleId==null) sExampleId="";
	
	String sSql = "select GroupNo from Store_Info where 1=2";
	String[][] sHeaders = {
		{"GroupNo","分组编号"},
		};
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.setDDDWCode("GroupNo","GroupNoCode");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","确定","确定","confirm()",sResourcesPath},
		{"false","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"true","","Button","取消","取消","cancel()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	function confirm(sPostEvents){
		self.returnValue = getItemValue(0, 0, "GroupNo");
		
		self.close();
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function cancel(){
		self.returnValue = "";
		self.close();
		//AsControl.OpenView("/FrameCase/ExampleList.jsp","","_self");
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		var serialNo = getSerialNo("EXAMPLE_INFO","ExampleId");// 获取流水号
		setItemValue(0,getRow(),"ExampleID",serialNo);
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			bIsInsert = true;
		}

    }
	
	$(document).ready(function(){
		beforeCloseCheck();
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
