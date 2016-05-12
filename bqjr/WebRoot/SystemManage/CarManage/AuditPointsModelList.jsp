<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 
 <%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content: 
		Input Param:
		Output param:
		History Log: xswang 20150505 CCS-637 PRM-293 审核过程中审核要点功能维护
	 */
	%>
 <%/*~END~*/%>
 
 <%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "示例列表页面";
	//获得页面参数
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "AuditConfigurationList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
<%/*记录被选中时触发事件*/%>
function mySelectRow(){
	var sFlowNo = getItemValue(0,getRow(),"FlowNo");
	var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
	if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0 || typeof(sPhaseNo) == "undefined" || sPhaseNo.length == 0) {
		AsControl.OpenView("/Blank.jsp","TextToShow=请先选择相应的信息!","frameright","");
	}else{
		// edit by xswang 20150505 CCS-637 PRM-293 审核过程中审核要点功能维护
		 AsControl.OpenView("/SystemManage/CarManage/AuditPointsModelFrame.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"frameright","");
		/* AsControl.OpenView("/SystemManage/CarManage/AuditPointsModelInfoAdd.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"frameright",""); */
		// end by xswang 20150505
	}
}

$(document).ready(function(){
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
