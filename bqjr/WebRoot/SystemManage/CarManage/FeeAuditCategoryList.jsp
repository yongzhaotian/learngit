<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "示例列表页面";

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "FeeAuditCategoryList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
			{"false","","Button","使用ObjectViewer打开","使用ObjectViewer打开","openWithObjectViewer()",sResourcesPath},
		};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	<%/*记录被选中时触发事件*/%>
	function mySelectRow(){
		var sFlowNo = getItemValue(0,getRow(),"FLOWNO");
		if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=请先选择相应的信息!","rightdown","");
		}else{
			AsControl.OpenView("/SystemManage/CarManage/FeeAuditModelList.jsp","FlowNo="+sFlowNo,"rightdown","");
		}
	}
	
	function newRecord(){
		AsControl.OpenView("/SystemManage/CarManage/FeeAuditCategoryInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var sFlowNo = getItemValue(0,getRow(),"FLOWNO");
		if (typeof(sFlowNo)=="undefined" || sFlowNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			RunMethod("公用方法", "DelByWhereClause", "Flow_Model,FlowNo='"+sFlowNo+"'");
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			parent.parent.reloadSelf();
		}
	}

	function viewAndEdit(){
		var sFlowNo = getItemValue(0,getRow(),"FLOWNO");
		if (typeof(sFlowNo)=="undefined" || sFlowNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/SystemManage/CarManage/FeeAuditCategoryInfo.jsp","FlowNo="+sFlowNo,"_self","");
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>