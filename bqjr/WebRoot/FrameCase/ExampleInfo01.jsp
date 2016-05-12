<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		页面说明: 信息分组示例页面
	 */
	String PG_TITLE = "信息分组示例页面";

	//获得页面参数	
	String sExampleId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ExampleId"));
	if(sExampleId==null) sExampleId="";

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ExampleInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//构建一个HTML模版
	/* String sHTMLTemplate = "<table border=0 width='100%'  cellspacing='0' cellpadding='0'>";
	sHTMLTemplate += "<tr onclick='parent.my_toggle_n(this)' height=1 ><td class='dw_title'>分组一</td></tr>";
	sHTMLTemplate += "<tr><td class='dw_conacte'> ${DOCK:PART1} </td></tr>";
	sHTMLTemplate += "<tr onclick='parent.my_toggle_n(this)' height=1><td class='dw_title'>分组二</td></tr>";
	sHTMLTemplate += "<tr><td  class='dw_conacte'> ${DOCK:PART2} </td></tr>";
	sHTMLTemplate += "<tr onclick='parent.my_toggle_n(this)' height=1><td class='dw_title'>其他信息</td></tr>";
	sHTMLTemplate += "<tr><td class='dw_conacte'> ${DOCK:default} </td></tr>";
	sHTMLTemplate += "</table>"; */
	//将模版应用于Datawindow
	//dwTemp.setHarborTemplate(sHTMLTemplate);
	
	//将DW的字段放到模版的泊位(Dock)中
	//doTemp.setColumnAttribute("ExampleId,SortNo,ExampleName,ParentExampleId,BeginDate","DockOptions","DockID=PART1");
	//doTemp.setColumnAttribute("AuditUser,AuditUserName,InputUser,InputUserName,InputTime,ApplySum,CustomerType","DockOptions","DockID=PART2");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sExampleId);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存并返回","保存所有修改,并返回列表页面","saveAndGoBack()",sResourcesPath},
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
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
		AsControl.OpenView("/FrameCase/ExampleList.jsp","","_self","");
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		setItemValue(0,getRow(),"ExampleId",getSerialNo("EXAMPLE_INFO","ExampleId"));//初始化流水号字段
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputOrg","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	
	<%/*~[Describe=页面装载时，对DW进行初始化;]~*/%>
	function initRow(){
		if(getRowCount(0)==0){
			as_add("myiframe0");
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