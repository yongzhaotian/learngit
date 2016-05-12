<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: pli2 2015-4-3
		Tester:
		Describe: 贷款人关联城市记录列表
		
		Input Param:
		SerialNo:流水号
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "贷款人电子合同模板 "; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得页面参数,贷款人编号
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanNo"));
	if(sSerialNo == null) sSerialNo = "";
	System.out.println(sSerialNo+"---");
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
		
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "LoanManEDocList";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//新增模型：2013-5-9
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	doTemp.multiSelectionEnabled=true;	
	 
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(100);  //服务器分页
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//新增参数传递：2013-5-9
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
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
		{"false","","Button","新增","添加新的电子合同模板","newRecord()",sResourcesPath},
		{"false","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的模版","deleteRecord()",sResourcesPath},
		{"false","","Button","停用","停用已有电子合同模板","deleteRecord()",sResourcesPath}
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		AsControl.OpenView("/BusinessManage/CollectionManage/LoanManEDocInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var sSpSerialNoArr = getItemValueArray(0,"SpSerialNo");
		var sBusinessTypeArr = getItemValueArray(0,"BusinessType");
		var sSpSerialNo = sSpSerialNoArr[0];
		var sBusinessType = sBusinessTypeArr[0];
		var params = "";
		if (typeof(sSpSerialNo)=="undefined" || sSpSerialNo.length==0 || typeof(sBusinessType)=="undefined" || sBusinessType.length==0){
			alert("请选择一条记录！");
			return;
		}
		if(confirm("您真的想删除该信息吗？")){
			var strList = "";
			for(var i = 0; i < sSpSerialNoArr.length; i++){
				strList = strList + sSpSerialNoArr[i] + "@@" + sBusinessTypeArr[i] + "|";
			}
			if (strList != null && strList != "") {
				strList = strList.substring(0, strList.length - 1);
			}
			params = "paramList=" + strList;
			var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.DelectLoanCity",
					"deletePrint", params);				
		}
		if (result.split("@")[0] != "true") {
			alert(result.split("@")[1]);
			return;
		} else {
			alert("删除成功！");
			reloadSelf();
			return;
		}
	}
	
	function viewAndEdit(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/FrameCase/ExampleInfo.jsp","ExampleId="+sExampleId,"_self","");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>

