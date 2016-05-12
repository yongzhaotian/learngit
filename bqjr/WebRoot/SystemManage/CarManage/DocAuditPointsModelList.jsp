<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 
 <%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  xswang 2015/05/25
		Tester:
		Content: 文件质量检查审核要点管理
		Input Param:
		Output param:
		History Log: 
	*/
	%>
 <%/*~END~*/%>
 
 <%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "文件质量检查审核要点管理";
	//获得页面参数
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ImageTypeListAuditPoints1";//模型编号
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
	var sTypeNo = getItemValue(0,getRow(),"TypeNo");
	if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0 || typeof(sTypeNo) == "undefined" || sTypeNo.length == 0) {
		AsControl.OpenView("/Blank.jsp","TextToShow=请先选择相应的信息!","frameright","");
	}else{
		 AsControl.OpenView("/SystemManage/CarManage/DocAuditPointsModelInfoAdd.jsp","TypeNo="+sTypeNo,"frameright","");
	}
}

$(document).ready(function(){
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
