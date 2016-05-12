<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例多选列表页面
	 */
	String PG_TITLE = "示例多选列表页面";

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "StoreGroupList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.multiSelectionEnabled=true;//设置可多选

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
		{"true","","Button","修改分组代码","修改分组代码","updateGroupNo()",sResourcesPath},
		{"true","","Button","导入","导入","importGroupNo()",sResourcesPath},
		{"false","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"false","","Button","使用ObjectViewer打开","使用ObjectViewer打开","openWithObjectViewer()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function updateGroupNo(){
		
		var sSNos = getItemValueArray(0,"SNo");//获取选中的多条记录ID
		if (typeof(sSNos)=="undefined" || sSNos.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		var sSNoStr = sSNos.toString();
		var re =/,/g; 
		sSNoStr = sSNoStr.replace(re,"@");
		var sRetVal = AsControl.PopView("/SystemManage/CustomerFinanceManage/DownUpGroupNo.jsp", "", "dialogWidth=480px;dialogHeight=240px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if (sRetVal=="") {alert("请选择分组代码！"); reloadSelf(); return;}
		
		var sReturn = AsControl.RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateStoreGroupId","updateGroupNos","sSNos="+sSNoStr+",sGroupNo="+sRetVal);
		if(sReturn=="FAIL"){
			alert("更新分组代码失败!");
		}
		reloadSelf();
		
	}
	
	function importGroupNo(){
		var sExampleIds = getItemValueArray(0,"ExampleId");//获取选中的多条记录ID			
		if (typeof(sExampleIds)=="undefined" || sExampleIds.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		var idstring = sExampleIds.toString();
		var re =/,/g; 
		idstring = idstring.replace(re,"@");	
		if(confirm("您真的想删除该信息吗？")){
			var sReturn = AsControl.RunJavaMethodSqlca("demo.Example4RJM","deleteExampleByIds","ExampleId="+idstring);
			if(sReturn=="SUCCESS"){
				alert("删除成功!");
				reloadSelf();
			}	
		}
	}

	function viewAndEdit(){
		var sExampleId=getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/FrameCase/ExampleInfo.jsp","ExampleId="+sExampleId+"&flag=02","_self","");
	}
	
	<%/*~[Describe=使用ObjectViewer打开;]~*/%>
	function openWithObjectViewer(){
		var sExampleId=getItemValue(0,getRow(),"ExampleId");
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
