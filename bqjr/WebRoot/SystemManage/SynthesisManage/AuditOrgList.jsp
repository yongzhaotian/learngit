<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
<%
	/*
			Author:
			Tester:
			Content: 本行认可评估机构列表页面
			Input Param:
			Output param:
			History Log: 

		 */
%>
<%
	/*~END~*/
%>
<%
	String PG_TITLE = "本行认可评估机构管理";
		//获得页面参数
		//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
		//if(sInputUser==null) sInputUser="";

		//通过DW模型产生ASDataObject对象doTemp
		String sTempletNo = "AuditOrgList";//模型编号
		ASDataObject doTemp = new ASDataObject(sTempletNo, Sqlca);

		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request, iPostChange);
		CurPage.setAttribute("FilterHTML", doTemp.getFilterHtml(Sqlca));

		ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
		dwTemp.Style = "1"; //设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
		dwTemp.setPageSize(10);

		//生成HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for (int i = 0; i < vTemp.size(); i++)
			out.print((String) vTemp.get(i));

		//out.println(doTemp.SourceSql); //常用这句话调试datawindow
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/
%>
<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
		String sButtons[][] = {
				{"true", "", "Button", "新增", "新增一条记录", "newRecord()",	sResourcesPath},
				{"true", "", "Button", "详情", "查看/修改详情","viewAndEdit()", sResourcesPath},
				{"true", "", "Button", "删除", "删除所选中的记录","deleteRecord()", sResourcesPath}};
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
<script type="text/javascript">
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord() {
		OpenPage("/SystemManage/SynthesisManage/AuditOrgInfo.jsp", "_self", "");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord() {
		sSerialNo = getItemValue(0, getRow(), "SerialNo");
		if (typeof (sSerialNo) == "undefined" || sSerialNo.length == 0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}

		if (confirm(getHtmlMessage('2'))) //您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0"); //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit() {
		sSerialNo = getItemValue(0, getRow(), "SerialNo");
		if (typeof (sSerialNo) == "undefined" || sSerialNo.length == 0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		OpenPage("/SystemManage/SynthesisManage/AuditOrgInfo.jsp?SerialNo="
				+ sSerialNo, "_self", "");
	}
</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
<script type="text/javascript">
	
</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/
%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2, 0, 'myiframe0');
</script>
<%
	/*~END~*/
%>


<%@ include file="/IncludeEnd.jsp"%>
