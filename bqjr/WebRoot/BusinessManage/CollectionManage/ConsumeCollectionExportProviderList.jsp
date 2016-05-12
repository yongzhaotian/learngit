<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "委外催收导出展示页面";
	//获得页面参数
	String sPhaseType1 =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType1"));
	String sType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("type"));
	if(sPhaseType1==null) sPhaseType1="";
	if(sType==null) sType="";

	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ConsumeExoprtProviderList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(sType.endsWith("3")){
		doTemp.WhereClause+="  and Status='01'";
	}else{
		doTemp.WhereClause+=" and Status is null";
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPhaseType1);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","导出EXCEL","导出EXCEL","viewAndEdit()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	//行动代码录入
	function viewAndEdit(){
		amarExport("myiframe0");
	}
	
	
	//查看催收历史 
	function viewHistory(){
		var sCustomerID = getItemValue(0,getRow(),"CUSTOMERID");
	
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		AsControl.OpenPage("/BusinessManage/CollectionManage/ConsumeCollectionRegistList.jsp", "CustomerID="+sCustomerID+"&PhaseType1=<%=sPhaseType1%>", "_self","");
		
	}
	
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
