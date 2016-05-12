<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "示例列表页面";
	//获得页面参数
	String sExecutorCode =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ExecutorCode"));//一级行动代码
	String sIsSelected =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("IsSelected"));//一级行动代码
	if(sExecutorCode==null) sExecutorCode="";
	if(sIsSelected==null)sIsSelected="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ActionCodeList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
 
	if(sIsSelected.equals("true")){
		doTemp.multiSelectionEnabled=true;
		doTemp.WhereClause+=" and CodeCategory='"+sExecutorCode+"'";
	}
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"false","","Button","确定","返回二级行动代码","returnSubExecutorCode()",sResourcesPath},
	};
	
	if(sIsSelected.equals("true")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
		sButtons[2][0]="false";
		sButtons[3][0]="true";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function returnSubExecutorCode(){
		var sSubExecutorCode = getItemValueArray(0,"Describe");//二级行动代码
		if(sSubExecutorCode.length!=1){
			 alert("必须且只能勾选一个委外资产受让方");
			 return;
		 }
		else if(sSubExecutorCode[0]==""||sSubExecutorCode[0]==null){
			alert("该记录中的二级行动代码不能为空!");
			return;
		}
		self.returnValue=sSubExecutorCode[0];
		self.close();
	}
	function newRecord(){
		AsControl.OpenView("/SystemManage/ConsumeLoanManage/ActionCodeInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	function viewAndEdit(){
		
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/SystemManage/ConsumeLoanManage/ActionCodeInfo.jsp","SerialNo="+sSerialNo,"_self","");
	}
	
	<%/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/%>
	function openWithObjectViewer(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		AsControl.OpenObject("Example",sExampleId,"001");//使用ObjectViewer以视图001打开Example，
	}

	$(document).ready(function(){
		showFilterArea();
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>